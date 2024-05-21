#ifndef BLAZE_BINNING_WORKER_H
#define BLAZE_BINNING_WORKER_H

#include <string>
#include "Type.h"
#include "galois/Bag.h"
#include "Synchronization.h"
#include "Queue.h"
#include "Param.h"
#include "Bin.h"
#include "helpers.h"

namespace blaze {

class ScatterWorker {
 public:
    ScatterWorker(int id,
                  std::vector<MPMCQueue<IoItem*>*>& fetched_pages)
        :   _id(id),
            _num_disks(0),
            _fetched_pages(fetched_pages),
            _in_frontier(nullptr),
            _bins(nullptr),
            _time(0.0),
            _num_processed_pages(0)
    {}

    ~ScatterWorker() {}

    void setFrontier(Worklist<VID>* in) {
        _in_frontier = in;
    }

    template <typename Gr, typename Func>
    void run(Gr& graph, Func& func, Synchronization& sync) {
        auto time_start = std::chrono::steady_clock::now();

        _num_disks = graph.NumberOfDisks();
        _p2v_map = &graph.GetP2VMap();
        _bins = func.get_bins();

        sync.wait_io_start();

        IoItem *items[IO_PAGE_QUEUE_BULK_DEQ];
        size_t count;
        bool io_done = false;

        while (1) {
            do {
                count = _fetched_pages[_id % _num_disks]->try_dequeue_bulk(items, IO_PAGE_QUEUE_BULK_DEQ);
                for (size_t i = 0; i < count; i++) {
                    processFetchedPages(graph, func, *items[i], sync);
                    delete items[i];
                }
            } while (count > 0);

            if (sync.check_io_done()) {
                // All completed IOs are sent and placed in the ring buffer.
                // One more loop is required to process them.
                if (!io_done) io_done = true;
                else                    break;
            }
        }

        // flush remaining entries in buffer to bin
        _bins->flush(_id);

        _in_frontier = nullptr;

        auto time_end = std::chrono::steady_clock::now();
        std::chrono::duration<double> elapsed = time_end - time_start;
        _time = elapsed.count();
    }
    //暂未使用
    uint64_t getNumProcessedPages() const {
        return _num_processed_pages;
    }

    double getTime() const {
        return _time;
    }

    int getId() const {
        return _id;
    }

 private:
    template <typename Gr, typename Func>
    bool applyFunction(Gr& graph, Func& func, const VID& vid, const uint64_t page_start, const uint64_t page_end, char *buffer) {
        uint32_t degree = graph.GetDegree(vid);
        if (!degree || (_in_frontier && !_in_frontier->activated(vid)))
            return false;

        uint64_t offset = graph.GetOffset(vid) * sizeof(VID);
        uint64_t offset_end = offset + (degree << EDGE_WIDTH_BITS);
        uint32_t offset_in_buf;

        if (offset < page_start) {
            degree -= (page_start - offset) >> EDGE_WIDTH_BITS;
            offset_in_buf = 0;

        } else {
            offset_in_buf = offset - page_start;
        }

        if (offset_end > page_end) {
            degree -= (offset_end - page_end) >> EDGE_WIDTH_BITS;
        }

        VID* edges = (VID*)(buffer + offset_in_buf);
        for (uint32_t i = 0; i < degree; i++) {
            VID dst = edges[i];
            if (func.cond(dst)){
                // printf("----edge vertex is %u -------\n",dst);
                _bins->append(_id, dst, func.scatter(vid, dst));
            }
        }

        return true;
    }

    template <typename Gr, typename Func>
    void processFetchedPages(Gr& graph, Func& func, IoItem& item, Synchronization& sync) {
        PAGEID ppid_start = item.page;
        const PAGEID ppid_end       = item.page + item.num;
        char* buffer = item.buf;
        // printf("----nromal pid is %u -------\n",ppid_start);
        while (ppid_start < ppid_end) {
            /* blaze的数据分布  
             *  disk0----disk1----disk2
             *  0,3,6----1,4,7----2,5,8(page id)
             *  0,1,2----0,1,2----0,1,2(bitmap page id)
            */
            const PAGEID pid = ppid_start * _num_disks + item.disk_id;
            processFetchedPage(graph, func, pid, buffer);
            ppid_start++;
            buffer += PAGE_SIZE;
        }
        // 处理scratch
        if(item.scratch){
            magazine* pscratch = (magazine*) item._scratch_buf;
            // dump_page((unsigned char *)(pscratch), sizeof(magazine));
            // pscratch->curr_index已经在magazine中迭代到max+1
            // printf("----scratch resubmission times: %d-----\n",pscratch->iter);
            uint64_t index = 0;
            while( pscratch->in_use && index <= pscratch->max){

                ppid_start = pscratch->page[index];
                const PAGEID ppid_end_magazine  = ppid_start + pscratch->size[index];
                
                // printf("----scratch pid is %u -------\n",ppid_start);
                while (ppid_start < ppid_end_magazine) {
                    const PAGEID pid = ppid_start * _num_disks + item.disk_id;
                    processFetchedPage(graph, func, pid, buffer);
                    ppid_start++;
                    buffer += PAGE_SIZE;
                }
                index++;
            }
        }
        if(item.scratch){
            magazine* pscratch = (magazine*) item._scratch_buf;
            // max io number is 32, scratch is 31,max = 30;
            sync.add_num_free_pages(item.disk_id, (pscratch->max + 2));
            _num_processed_pages += (pscratch->max + 1);
            free(item._scratch_buf);
        } else {
            sync.add_num_free_pages(item.disk_id, item.num);
            _num_processed_pages += item.num;
        }
        free(item.buf);
    }

    template <typename Gr, typename Func>
    void processFetchedPage(Gr& graph, Func& func, PAGEID pid, char* buffer) {
        const VID vid_start = _p2v_map[pid].first;
        const VID vid_end       = _p2v_map[pid].second;

        const uint64_t page_start = (uint64_t)pid * PAGE_SIZE;
        const uint64_t page_end = page_start + PAGE_SIZE;

        VID vid = vid_start;
        while (vid <= vid_end) {
            applyFunction(graph, func, vid, page_start, page_end, buffer);
            vid++;
        }
    }

 private:
    int                     _id;
    int                     _num_disks;
    VidRange*               _p2v_map;
    std::vector<MPMCQueue<IoItem*>*>&     _fetched_pages;
    Worklist<VID>*          _in_frontier;
    Bins*                   _bins;
    double                  _time;
    uint64_t                _num_processed_pages;
};

} // namespace blaze

#endif // BLAZE_BINNING_WORKER_H
