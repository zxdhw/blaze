#include <stdio.h>
#include <locale.h>
#include "galois/Galois.h"
#include "Util.h"
#include "boilerplate.h"

namespace cll = llvm::cl;

cll::opt<int>
    numComputeThreads("computeWorkers",
                    cll::desc("Number of compute threads (default: 1)"),
                    cll::init(1));

cll::opt<unsigned int>
    ioBufferSize("ioBufferSize",
                    cll::desc("IO buffer space size in MB (default: 1024)"),
                    cll::init(256));
cll::opt<unsigned int>
    hitchhike("hit",
                    cll::desc("use hitchhike ibaio syscall) (default: 0)"),
                    cll::init(0));
// cll::opt<unsigned int>
//     ioQueueDepth("queueDepth",
//                     cll::desc("AIO Queue Depth (default: 128)"),
//                     cll::init(128));
cll::opt<unsigned int>
    hitSize("hitSize",
                    cll::desc("Hitchhike size in KB (default: 128)"),
                    cll::init(128));

cll::opt<std::string>
    outIndexFilename(cll::Positional, cll::desc("<out index file>"), cll::Required);

cll::list<std::string>
    outAdjFilenames(cll::Positional, cll::desc("<out adj files>"), cll::OneOrMore);

int numIoThreads;

namespace blaze {

void AgileStart(int argc, char** argv) {
    cll::ParseCommandLineOptions(argc, argv);
    numIoThreads = outAdjFilenames.size();
    int numThreads = numIoThreads + numComputeThreads;

    // For pretty output
//  std::locale comma_locale(std::locale(), new comma_numpunct());
//  std::cout.imbue(comma_locale);
//  setlocale(LC_NUMERIC, "");
}

} // namespace blaze
