#ifndef BLAZE_IO_WORKER_H
#define BLAZE_IO_WORKER_H

#include "Type.h"
#include "Graph.h"
#include "ebpf_types.h"
#include "galois/Bag.h"
#include "Param.h"
#include "IoSync.h"
#include "Synchronization.h"
#include "AsyncIo.h"
#include "Queue.h"
#include "Param.h"
#include <cstdint>
#include <cstdlib>
#include <unordered_set>
#include "helpers.h"

namespace blaze {

class Runtime;

class IoWorker {
 public:
    IoWorker(int id,
             uint64_t buffer_size,
             MPMCQueue<IoItem*>* out)
        :   _id(id),
            _buffered_tasks(out),
            _queued(0), _sent(0), _received(0), _requested_all(false),
            _total_bytes_accessed(0),_total_bytes_accessed_ebpf(0), _time(0.0),
            duration_aio(0),duration_magazine(0),
            duration_received(0),duration_dispatch(0)
    {
        initAsyncIo();
        initMagazine();
        _stats_bufs = (struct hit_stats*)calloc(1, sizeof(struct hit_stats));
        _num_buffer_pages = (int64_t)buffer_size / PAGE_SIZE;
    }

    ~IoWorker() {
        deinitAsyncIo();
        deinitMagazine();
    }

    void initAsyncIo() {
        _ctx = 0;
        int ret = io_setup(IO_QUEUE_DEPTH, &_ctx);
        assert(ret == 0);
        _iocb = (struct iocb*)calloc(IO_QUEUE_DEPTH, sizeof(*_iocb));
        _iocbs = (struct iocb**)calloc(IO_QUEUE_DEPTH, sizeof(*_iocbs));
        _events = (struct io_event*)calloc(IO_QUEUE_DEPTH, sizeof(*_events));
    }

    void deinitAsyncIo() {
        io_destroy(_ctx);
        free(_iocb);
        free(_iocbs);
        free(_stats_bufs);
        free(_events);
    }

    // void init_bpf_program(){
    //     _bpf_fd = load_bpf_program("/home/zxd/blaze/magazine/magazine.o");
    // }
        
    void initMagazine ()
    {
        // 临时使用，与iocbs相同，内核拷贝完成后返回，才提交下一批请求。因此可以重复使用。
        _scratch_bufs_tmp = (char**)calloc(IO_QUEUE_DEPTH, sizeof(ptr__m));
    }
    
    void deinitMagazine() {
        free(_scratch_bufs_tmp);
    }


    void run(int fd, bool dense_all, Bitmap* page_bitmap, CountableBag<PAGEID>* sparse_page_frontier,
            Synchronization& sync, IoSync& io_sync, FLAGS& use_ebpf) {

        _use_ebpf = use_ebpf;
        // if(is_use_ebpf(_use_ebpf)){
        //     init_bpf_program();
        // }
        _fd = fd;
        sync.set_num_free_pages(_id, _num_buffer_pages);

        if (dense_all) {
            run_dense_all(page_bitmap, sync, io_sync);
        }

        if (sparse_page_frontier) {
            run_sparse(sparse_page_frontier, page_bitmap, sync, io_sync);

        } else {
            run_dense(page_bitmap, sync, io_sync);
        }
        // printf("----MAX IO SIZE is %d, MAX AIO QUEUE is %d----\n",MAX_BIO_SIZE,IO_QUEUE_DEPTH);
        duration_aio -= duration_aio;
        duration_magazine -= duration_magazine;
        duration_received -= duration_received;
        duration_dispatch -= duration_dispatch;
        // printf("----release: magazine time is %lf, aio time is %lf----\n",duration_magazine.count(),duration_aio.count());
        // printf("----release: received time is %lf, dispatch time is %lf----\n",duration_received.count(),duration_dispatch.count());

    }

    uint64_t getBytesAccessed() const {
        return _total_bytes_accessed;
    }

    uint64_t getBytesAccessed_ebpf() const {
        return _total_bytes_accessed_ebpf;
    }

    void initState() {
        _queued = 0;
        _sent = 0;
        _received = 0;
        _requested_all = false;
        _total_bytes_accessed = 0;
        _total_bytes_accessed_ebpf = 0;
        _time = 0;
    }

 private:
    void run_dense_all(Bitmap* page_bitmap, Synchronization& sync, IoSync& io_sync) {
        IoItem* done_tasks[IO_QUEUE_DEPTH];
        int received;

        PAGEID beg = 0;
        const PAGEID end = page_bitmap->get_size();

        while (!_requested_all || _received < _queued) {
            submitTasks_dense_all(beg, end, sync, io_sync);
            received = receiveTasks(done_tasks);
            dispatchTasks(done_tasks, received);
        }
    }

    void run_dense(Bitmap* page_bitmap, Synchronization& sync, IoSync& io_sync) {
        IoItem* done_tasks[IO_QUEUE_DEPTH];
        int received;

        PAGEID beg = 0;
        const PAGEID end = page_bitmap->get_size();

        while (!_requested_all || _received < _queued) {
            if(is_use_ebpf(_use_ebpf)){
                submitTasks_dense_ebpf(page_bitmap, beg, end, sync, io_sync);
            } else {
                submitTasks_dense(page_bitmap, beg, end, sync, io_sync);
            }


            received = receiveTasks(done_tasks);
            // if(_received != _queued){
            //     printf("----received is %ld, queued is %ld----\n", _received, _queued);
            //     // break;
            // }
            dispatchTasks(done_tasks, received);
        }
        // printf("----magazine time is %lf, aio time is %lf----\n",duration_magazine.count(),duration_aio.count());
    }

    void run_sparse(CountableBag<PAGEID>* sparse_page_frontier, Bitmap* page_bitmap, 
                            Synchronization& sync, IoSync& io_sync) {
        IoItem* done_tasks[IO_QUEUE_DEPTH];
        int received;

        auto beg = sparse_page_frontier->begin();
        auto const end = sparse_page_frontier->end();

        // auto beg_tmp = sparse_page_frontier->begin();
        // PAGEID page_id_tmp;
        // while (beg_tmp != end) {
        //     page_id_tmp = *beg_tmp;

        //     if (page_bitmap->get_bit(page_id_tmp)) {
        //         beg_tmp++;
        //         continue;
        //     }
        //     printf("----pid is %d----\n", page_id_tmp);
        //     page_bitmap->set_bit(page_id_tmp);
        //     beg_tmp++;
        // }

        // beg_tmp = sparse_page_frontier->begin();
        // while (beg_tmp != end) {
        //     page_id_tmp = *beg_tmp;
        //     // printf("----reset pid is %d----\n", page_id_tmp);
        //     page_bitmap->reset_bit(page_id_tmp);
        //     beg_tmp++;
        // }

        while (!_requested_all || _received < _queued) {
            if(is_use_ebpf(_use_ebpf)){
                submitTasks_sparse_ebpf(beg, end, page_bitmap, sync, io_sync);
            } else {
                submitTasks_sparse(beg, end, page_bitmap, sync, io_sync);
            }

            _time_start = std::chrono::steady_clock::now();

            received = receiveTasks(done_tasks);

            _time_end = std::chrono::steady_clock::now();
            duration_received += (_time_end - _time_start);

            _time_start = std::chrono::steady_clock::now();

            dispatchTasks(done_tasks, received);

            _time_end = std::chrono::steady_clock::now();
            duration_dispatch += (_time_end - _time_start);
        }
        printf("----magazine time is %lf, aio time is %lf----\n",duration_magazine.count(),duration_aio.count());
        printf("----received time is %lf, dispatch time is %lf----\n",duration_received.count(),duration_dispatch.count());
    }

    void submitTasks_dense_all(PAGEID& beg, const PAGEID& end,
                            Synchronization& sync, IoSync& io_sync)
    {
        char* buf;
        off_t offset;
        void* data;

        while (beg < end && (_queued - _sent) < IO_QUEUE_DEPTH) {
            // check continuous pages up to 16kB
            PAGEID page_id = beg;
            uint32_t num_pages = IO_MAX_PAGES_PER_REQ;
            if (beg + num_pages > end)
                num_pages = end - beg;

            // wait until free pages are available
            while (sync.get_num_free_pages(_id) < num_pages) {}
            sync.add_num_free_pages(_id, (int64_t)num_pages * (-1));

            uint32_t len = num_pages * PAGE_SIZE;
            buf = (char*)aligned_alloc(PAGE_SIZE, len);
            offset = (uint64_t)page_id * PAGE_SIZE;
            IoItem* item = new IoItem(_id, page_id, num_pages, buf,0);
            enqueueRequest(buf, len, offset, item);

            beg += num_pages;
        }

        if (beg >= end) _requested_all = true;

        if (_queued - _sent == 0) return;

        for (size_t i = 0; i < _queued - _sent; i++) {
            _iocbs[i] = &_iocb[(_sent + i) % IO_QUEUE_DEPTH];
        }

        int ret = io_submit(_ctx, _queued - _sent, _iocbs);
        if (ret > 0) {
            _sent += ret;
        }
    }

    void submitTasks_dense(Bitmap* page_bitmap, PAGEID& beg, const PAGEID& end,
                        Synchronization& sync, IoSync& io_sync)
    {
        _time_start = std::chrono::steady_clock::now();
        char* buf;
        off_t offset;
        void* data;

        while (beg < end && (_queued - _sent) < IO_QUEUE_DEPTH) {
            // skip an entire word in bitmap if possible
            // note: this is quite effective to keep IO queue busy
            if (!page_bitmap->get_word(Bitmap::word_offset(beg))) {
                beg = Bitmap::pos_in_next_word(beg);
                continue;
            }

            if (!page_bitmap->get_bit(beg)) {
                beg++;
                continue;

            } else {
                // check continuous pages up to 16kB
                PAGEID page_id = beg;
                uint32_t num_pages = 1;
                while (page_bitmap->get_bit(++beg)
                             && beg < end 
                             && num_pages < IO_MAX_PAGES_PER_REQ)
                {
                    num_pages++;
                }

                // wait until free pages are available
                while (sync.get_num_free_pages(_id) < num_pages) {}
                sync.add_num_free_pages(_id, (int64_t)num_pages * (-1));
                
                uint32_t len = num_pages * PAGE_SIZE;
                buf = (char*)aligned_alloc(PAGE_SIZE, len);
                offset = (uint64_t)page_id * PAGE_SIZE;
                IoItem* item = new IoItem(_id, page_id, num_pages, buf,0);
                enqueueRequest(buf, len, offset, item);
                // zhengxd: 打印page 连续性
                // printf(" %d \n",num_pages);
            }
        }

        if (beg >= end) _requested_all = true;

        if (_queued - _sent == 0) return;

        for (size_t i = 0; i < _queued - _sent; i++) {
            _iocbs[i] = &_iocb[(_sent + i) % IO_QUEUE_DEPTH];
        }
        _time_end = std::chrono::steady_clock::now();
        duration_magazine += (_time_end - _time_start);
        _time_start = std::chrono::steady_clock::now();
        int ret = io_submit(_ctx, _queued - _sent, _iocbs);
        if (ret > 0) {
            _sent += ret;
        }
        _time_end = std::chrono::steady_clock::now();
        duration_aio += (_time_end - _time_start);
    }

    void submitTasks_sparse(CountableBag<PAGEID>::iterator& beg,
                            const CountableBag<PAGEID>::iterator& end,
                            Bitmap* page_bitmap,
                            Synchronization& sync, IoSync& io_sync)
    {
        _time_start = std::chrono::steady_clock::now();
        char* buf;
        off_t offset;
        void* data;
        PAGEID page_id;

        while (beg != end && (_queued - _sent) < IO_QUEUE_DEPTH) {
            page_id = *beg;

            if (page_bitmap->get_bit(page_id)) {
                beg++;
                continue;
            }

            // wait until free pages are available
            while (sync.get_num_free_pages(_id) < 1) {}
            sync.add_num_free_pages(_id, (int64_t)(-1));
            // zhengxd: 打印page 连续性
            // printf(" 1 \n");

            buf = (char*)aligned_alloc(PAGE_SIZE, PAGE_SIZE);
            offset = (uint64_t)page_id * PAGE_SIZE;
            IoItem* item = new IoItem(_id, page_id, 1, buf,0);
            enqueueRequest(buf, PAGE_SIZE, offset, item);
            //将下发过的page置为1，防止重复下发。
            page_bitmap->set_bit(page_id);

            beg++;
        }

        if (beg == end) _requested_all = true;

        if (_queued - _sent == 0) return;

        for (size_t i = 0; i < _queued - _sent; i++) {
            _iocbs[i] = &_iocb[(_sent + i) % IO_QUEUE_DEPTH];
        }
        _time_end = std::chrono::steady_clock::now();
        duration_magazine += (_time_end - _time_start);

        _time_start = std::chrono::steady_clock::now();
        int ret = io_submit(_ctx, _queued - _sent, _iocbs);
        if (ret > 0) {
            _sent += ret;
        }
        _time_end = std::chrono::steady_clock::now();
        duration_aio += (_time_end - _time_start);
    }
        //zhengxd: 向magazine中填充IO
    void magazine_dense(Bitmap* page_bitmap, PAGEID& beg, const PAGEID& end, uint32_t used_pages,char* _scratch_buf){

        PAGEID page_id;
        uint32_t cur_pages;
        uint64_t offset = 0;
        uint32_t offset_pages = 0, index = 0;
        uint32_t max_pages = IO_MAX_PAGES_PER_MG - used_pages;
        magazine* pscratch = (magazine*)_scratch_buf;
        // pscratch->iter = 0;
        // pscratch->done = 0;
        // pscratch->in_use = 0;
        _buffer_len = used_pages * PAGE_SIZE;

        while (beg < end && _buffer_len < MAX_BIO_SIZE ) {
            // skip an entire word in bitmap if possible
            // note: this is quite effective to keep IO queue busy
            if (!page_bitmap->get_word(Bitmap::word_offset(beg))) {
                beg = Bitmap::pos_in_next_word(beg);
                continue;
            }

            if (!page_bitmap->get_bit(beg)) {
                beg++;
                continue;
            } else {
                // check continuous pages up to 128KB
                // check beg is not host io
                page_id = beg;
                cur_pages = 1;
                // while (page_bitmap->get_bit(++beg)
                //              && cur_pages < IO_MAX_PAGES_PER_REQ
                //              && beg < end 
                //              && cur_pages < max_pages - offset_pages)
                // {
                //     cur_pages++;
                // }
                offset_pages += cur_pages;
                offset = (uint64_t)page_id * PAGE_SIZE;
                _buffer_len += cur_pages * PAGE_SIZE;

                pscratch->page[index] = page_id;
                pscratch->addr[index] = offset;
                pscratch->size[index] = PAGE_SIZE;
                pscratch->max = index;
                pscratch->in_use = 1;
                index++;
                beg++;
            }
        }
    }

    void submitTasks_dense_ebpf(Bitmap* page_bitmap, PAGEID& beg, const PAGEID& end,
                        Synchronization& sync, IoSync& io_sync)
    {
        // _time_start = std::chrono::steady_clock::now();
        char* buf;
        uint64_t offset;
        void* data;
        PAGEID page_id;
        uint64_t index = 0;
        uint32_t num_pages;

        while (beg < end && (_queued - _sent) < IO_QUEUE_DEPTH) {
            // skip an entire word in bitmap if possible
            // note: this is quite effective to keep IO queue busy
            if (!page_bitmap->get_word(Bitmap::word_offset(beg))) {
                beg = Bitmap::pos_in_next_word(beg);
                continue;
            }

            if (!page_bitmap->get_bit(beg)) {
                beg++;
                continue;

            } else {
                // check continuous pages up to 16kB
                page_id = beg;
                num_pages = 1;
                beg++;
                // while (page_bitmap->get_bit(++beg)
                //              && beg < end 
                //              && num_pages < IO_MAX_PAGES_PER_REQ)
                // {
                //     num_pages++;
                // }
                // magazine 填充
                char* _scratch_buf = (char*)aligned_alloc(PAGE_SIZE, sizeof(magazine));
                memset(_scratch_buf,0,sizeof(magazine));
                magazine_dense(page_bitmap,beg,end,num_pages,_scratch_buf);
                uint64_t magazine_pages = _buffer_len / PAGE_SIZE;

                // wait until free pages are available
                while (sync.get_num_free_pages(_id) < magazine_pages) {}
                sync.add_num_free_pages(_id, (int64_t)magazine_pages * (-1));
                buf = (char*)aligned_alloc(PAGE_SIZE, _buffer_len);
                offset = (uint64_t)page_id * PAGE_SIZE;

                // aio init
                IoItem* item = new IoItem(_id, page_id, 1, buf,1, _scratch_buf);
                enqueueRequest_xrp(buf, PAGE_SIZE, _buffer_len, offset, item);
                _scratch_bufs_tmp[index] = _scratch_buf;
                index++;
                // debug info : char (1字节)， SCRATCH （4096字节）
                // dump_page((unsigned char *)(&_scratch_buf[index]), 4096);
                // printf("----io submit: ptr is %p----\n", _scratch_buf);
            }
        }

        if (beg >= end) _requested_all = true;

        if (_queued - _sent == 0) return;

        for (size_t i = 0; i < _queued - _sent; i++) {
            _iocbs[i] = &_iocb[(_sent + i) % IO_QUEUE_DEPTH];
        }
        // _time_end = std::chrono::steady_clock::now();
        //  duration_magazine += (_time_end - _time_start);

        // _time_start = std::chrono::steady_clock::now();
        int ret = io_submit_xrp(_ctx, _queued - _sent, _iocbs, _bpf_fd, _scratch_bufs_tmp);
        if (ret > 0) {
            _sent += ret;
        }
        // _time_end = std::chrono::steady_clock::now();
        // duration_aio += (_time_end - _time_start);
        memset(_scratch_bufs_tmp, 0, (IO_QUEUE_DEPTH * sizeof(ptr__m)));
    }

    //zhengxd: 向magazine中填充IO
    void magazine_sparse(Bitmap* page_bitmap, CountableBag<PAGEID>::iterator& beg,
                    const CountableBag<PAGEID>::iterator& end, uint32_t used_pages,char* _scratch_buf){

        uint64_t offset = 0, index = 0;
        magazine* pscratch = (magazine*)_scratch_buf;
        // pscratch->iter = 0;
        // pscratch->max = 0;
        // pscratch->done = 0;
        // pscratch->in_use = 0;
        _buffer_len = used_pages * PAGE_SIZE;
  
        PAGEID page_id;

        while (beg != end && _buffer_len < MAX_BIO_SIZE) {
  
            page_id = *beg;
            if (page_bitmap->get_bit(page_id)) {
                beg++;
                continue;
            } else {
                // check continuous pages up to 128KB
                // check beg is not host io
                offset = (uint64_t)page_id * PAGE_SIZE;
                _buffer_len += PAGE_SIZE;

                pscratch->page[index] = (uint64_t)page_id;
                pscratch->addr[index] = offset;
                pscratch->size[index] = PAGE_SIZE;
                pscratch->max = index;
                pscratch->in_use = 1;
                index++;
                page_bitmap->set_bit(page_id);
                // printf("----xrp pid is %d, item buffer len is %ld-----\n",page_id,_buffer_len);
            }
        }
    }

    void submitTasks_sparse_ebpf(CountableBag<PAGEID>::iterator& beg,
                            const CountableBag<PAGEID>::iterator& end,
                            Bitmap* page_bitmap,
                            Synchronization& sync, IoSync& io_sync)
    {
        _time_start = std::chrono::steady_clock::now();
        char* buf;
        uint64_t offset;
        void* data;
        PAGEID page_id;
        uint32_t index = 0;

        while (beg != end && (_queued - _sent) < IO_QUEUE_DEPTH) {
            page_id = *beg;

            if (page_bitmap->get_bit(page_id)) {
                beg++;
                continue;
            }
            // 提前加锁，避免magazine_sparse时重复下发请求
            page_bitmap->set_bit(page_id);
            beg++;

            //scratch，无论scratch是否包含数据，都下发一个scratch。
            char* _scratch_buf = (char*)aligned_alloc(PAGE_SIZE, sizeof(magazine));
            memset(_scratch_buf,0,sizeof(magazine));
            magazine_sparse(page_bitmap,beg,end,1,_scratch_buf);
            uint64_t magazine_pages = _buffer_len / PAGE_SIZE;

            // wait until free pages are available
            while (sync.get_num_free_pages(_id) < magazine_pages) {}
            sync.add_num_free_pages(_id, magazine_pages*(-1));
            buf = (char*)aligned_alloc(PAGE_SIZE, _buffer_len);
            offset = (uint64_t)page_id * PAGE_SIZE;

            // aio init
            IoItem* item = new IoItem(_id, page_id, 1, buf,1, _scratch_buf);
            enqueueRequest_xrp(buf, PAGE_SIZE, _buffer_len, offset, item);
            // printf("----start pid is %d, item buffer len is %ld-----\n",page_id,_buffer_len);
            _scratch_bufs_tmp[index] = _scratch_buf;
            index++;
            // debug info
            // dump_page((unsigned char *)(_scratch_buf), sizeof(magazine));
            // printf("----io submit: ptr is %p----\n", _scratch_buf);
           
        }

        if (beg == end) _requested_all = true;

        if (_queued - _sent == 0) return;

        for (size_t i = 0; i < _queued - _sent; i++) {
            _iocbs[i] = &_iocb[(_sent + i) % IO_QUEUE_DEPTH];
        }

        _time_end = std::chrono::steady_clock::now();
        duration_magazine += (_time_end - _time_start);
        
        _time_start = std::chrono::steady_clock::now();
        // printf("----we have io %ld, submit io number %ld----\n",_queued,(_queued - _sent));
        // io_stat(_stats_bufs);
        int ret = io_submit_xrp(_ctx, _queued - _sent, _iocbs, _bpf_fd, _scratch_bufs_tmp);
        // io_stat(_stats_bufs);
        // printf("----aio time is %ld, aio count is %ld----\n",_stats_bufs->aio_time, _stats_bufs->aio_count);
        // printf("----we submit success io number %d----\n",ret);
        if (ret > 0) {
            _sent += ret;
        }
        _time_end = std::chrono::steady_clock::now();
        duration_aio += (_time_end - _time_start);
        memset(_scratch_bufs_tmp, 0, (IO_QUEUE_DEPTH * sizeof(ptr__m)));
    }

    void enqueueRequest(char* buf, size_t len, off_t offset, void* data) {
        uint32_t idx = _queued % IO_QUEUE_DEPTH;
        struct iocb* pIocb = &_iocb[idx];
        memset(pIocb, 0, sizeof(*pIocb));
        pIocb->aio_fildes = _fd;
        pIocb->aio_lio_opcode = IOCB_CMD_PREAD;
        pIocb->aio_buf = (uint64_t)buf;
        pIocb->aio_nbytes = len;
        pIocb->aio_offset = offset;
        pIocb->aio_data = (uint64_t)data;
        _queued++;

        _total_bytes_accessed += len;
    }


    void enqueueRequest_xrp(char* buf, size_t data_len, size_t _buffer_len, off_t offset, void* data) {
        uint32_t idx = _queued % IO_QUEUE_DEPTH;
        struct iocb* pIocb = &_iocb[idx];
        memset(pIocb, 0, sizeof(*pIocb));
        pIocb->aio_fildes = _fd;
        pIocb->aio_lio_opcode = IOCB_CMD_PREAD;
        pIocb->aio_buf = (uint64_t)buf;
        pIocb->aio_nbytes = _buffer_len;
        pIocb->aio_offset = offset;
        pIocb->aio_data = (uint64_t)data;
        pIocb->aio_dsize = data_len;
        _queued++;

        _total_bytes_accessed += data_len;
        _total_bytes_accessed_ebpf += _buffer_len;
        _buffer_len = 0;
    }    

    int receiveTasks(IoItem** done_tasks) {
        if (_requested_all && _sent == _received) return 0;

        unsigned min = 0;
        unsigned max = IO_QUEUE_DEPTH;

        int received = io_getevents(_ctx, min, max, _events, NULL);
        // printf("----we get success io number %d----\n",received);
        assert(received <= max);
        assert(received >= 0);

        for (int i = 0; i < received; i++) {
            assert(_events[i].res > 0);
            auto item = reinterpret_cast<IoItem*>(_events[i].data);
            done_tasks[i] = item;
        }
        _received += received;

        return received;
    }

    void dispatchTasks(IoItem** done_tasks, int received) {
        if (received > 0)
            _buffered_tasks->enqueue_bulk(done_tasks, received);
    }

 protected:
    int                     _id;
    MPMCQueue<IoItem*>*     _buffered_tasks;

    // To control IO
    int                     _fd;
    uint64_t                _queued;
    uint64_t                _sent;
    uint64_t                _received;
    bool                    _requested_all;
    int64_t                 _num_buffer_pages;
    // For statistics
    uint64_t                _total_bytes_accessed;
    uint64_t                _total_bytes_accessed_ebpf;
    double                  _time;

    aio_context_t                       _ctx;
    struct iocb*                        _iocb;
    struct iocb**                       _iocbs;
    struct io_event*                    _events;

    // ebpf 
    int                     _bpf_fd;
    char*                   _scratch_buf_tmp;
    char**                  _scratch_bufs_tmp;
    uint32_t                _scratch_pages;
    uint32_t                _use_ebpf;
    size_t                  _buffer_len; // bytes
    struct hit_stats* _stats_bufs;
    std::chrono::time_point<std::chrono::steady_clock>  _time_start;
    std::chrono::time_point<std::chrono::steady_clock>  _time_end;
    std::chrono::duration<double> duration_magazine;
    std::chrono::duration<double> duration_aio;
    std::chrono::duration<double> duration_received;
    std::chrono::duration<double> duration_dispatch;

};

} // namespace blaze

#endif // BLAZE_IO_WORKER_H
