#ifndef BLAZE_RUNTIME_H
#define BLAZE_RUNTIME_H

#include <galois/Galois.h>
#include "IoEngine.h"
#include "ComputeEngine.h"
#include "PBEngine.h"
#include "Util.h"
#include "Bitmap.h"
#include "atomics.h"
#include "Param.h"
#include "Type.h"
#include "Queue.h"

namespace blaze {

class Runtime {
 public:
    Runtime(int num_compute_threads, int num_io_threads, uint64_t io_buffer_size)
        :   _num_compute_threads(num_compute_threads),
            _num_io_threads(num_io_threads),
            _pb_engine(nullptr),
            _round(0),
            _total_accessed_io_bytes(0),
            _total_accessed_edges(0),
            _total_io_time(0.0),
            //zhengxd: poll 
            _total_gather_time(0.0),
            _total_scatter_time(0.0),
            _gather_time(0.0),
            _scatter_time(0.0)
    {
        // Set active thread counts
        int num_threads = num_compute_threads + num_io_threads;
        num_threads = galois::setActiveThreads(num_threads);
        printf("Number of threads: %d (Compute %d, IO %d)\n",
            num_threads, num_compute_threads, num_io_threads);


        // Initialize ring buffers
        for (int i = 0; i < num_io_threads; i++) {
            _fetched_tasks.push_back(new MPMCQueue<IoItem*>(IO_PAGE_QUEUE_INIT_SIZE));
        }
    

        // Initialize IO engine
        _io_engine = new IoEngine(num_io_threads,
                                  num_compute_threads,
                                  io_buffer_size / num_io_threads,
                                  _fetched_tasks);

        _compute_engine = new ComputeEngine(1,
                                            num_compute_threads,
                                            _fetched_tasks);

        setRuntimeInstance(this);
    }

    ~Runtime() {
        double io_bw_in_gbps = _total_io_time > 0 ? (double)_total_accessed_io_bytes / _total_io_time / GB : 0.0;
        printf("# IO SUMMARY    : %'lu bytes,  %8.5fsec, %4.2f GB/s\n", _total_accessed_io_bytes, _total_io_time, io_bw_in_gbps);
        printf("# SUMMARY       : %'lu edges accessed.\n", _total_accessed_edges);
        //zhengxd：POLL:: print poll info
        printf("# POLL          : %8.5fsec total gather thread time, %8.5fsec gather time, %8.5fsec total sactter thread time, %8.5fsec scatter time\n",
                                                             _total_gather_time, _gather_time, _total_scatter_time, _scatter_time);

        if (_io_engine)
            delete _io_engine;

        if (_compute_engine)
            delete _compute_engine;

        if (_pb_engine)
            delete _pb_engine;

        for (auto queue : _fetched_tasks) {
            delete queue;
        }
    }

    int getNumberOfComputeWorkers() const {
        return _num_compute_threads;
    }

    int getNumberOfIoWorkers() const {
        return _num_io_threads;
    }

    IoEngine* getIoEngine() {
        return _io_engine;
    }

    ComputeEngine* getComputeEngine() {
        return _compute_engine;
    }

    int getRound(void) const {
        return _round;
    }

    void incRound(void) {
        _round++;
    }

    void addAccessedIoBytes(uint64_t bytes) {
        _total_accessed_io_bytes += bytes;
    }

    void addAccessedEdges(uint64_t edges) {
        _total_accessed_edges += edges;
    }

    uint64_t getAccessedEdges() const {
        return _total_accessed_edges;
    }

    void addIoTime(double time) {
        _total_io_time += time;
    }
    // zhegnxd: poll
    // total time 是每个edgemap重新从0计数的，所以需要累加。
    void addTotalGatherTime(double time) {
        _total_gather_time += time;
    }

    void addTotalScatterTime(double time) {
        _total_scatter_time += time;
    }
    
    // zhengxd： gahter time 和 scatter time 是累计计数的，所以直接赋值。 
    void addGatherTime(double time) {
        _gather_time = time;
    }

    void addScatterTime(double time) {
        _scatter_time = time;
    }

    // Binning specific
    void initBinning(float ratio) {
        int num_bin_workers = (int)(ratio * _num_compute_threads);
        int num_acc_workers = _num_compute_threads - num_bin_workers;
        _pb_engine = new PBEngine(1,
                                  num_bin_workers,
                                  num_acc_workers,
                                  _fetched_tasks);
    }

    PBEngine* getPBEngine() {
        return _pb_engine;
    }

 public:
    static Runtime* runtimeInstance;

    static void setRuntimeInstance(Runtime* rt) {
        BLAZE_ASSERT(!(runtimeInstance && rt), "Double initialization of Runtime");
        runtimeInstance = rt;
    }

    static Runtime& getRuntimeInstance(void) {
        BLAZE_ASSERT(runtimeInstance, "Runtime not initialized");
        return *runtimeInstance;
    }

 private:
    // thread pool
    galois::SharedMemSys    _galoisRuntime;
    int                     _num_compute_threads;
    int                     _num_io_threads;

    // io execution
    IoEngine*               _io_engine;

    // compute execution
    ComputeEngine*          _compute_engine;

    // bin-based execution
    PBEngine*               _pb_engine;

    // ring buffers
    std::vector<MPMCQueue<IoItem*>*>    _fetched_tasks;

    // stat
    int                     _round;
    uint64_t                _total_accessed_io_bytes;
    uint64_t                _total_accessed_edges;
    double                  _total_io_time;
    MemoryCounter           _mem_counter;
    //zhengxd: poll
    double                  _total_gather_time;
    double                  _total_scatter_time;
    double                  _gather_time;
    double                  _scatter_time;
};

} // namespace blaze

#endif // BLAZE_RUNTIME_H

