# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/zhengxd/blaze

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/zhengxd/blaze/test

# Include any dependencies generated for this target.
include apps/CMakeFiles/spmv_sync.dir/depend.make

# Include the progress variables for this target.
include apps/CMakeFiles/spmv_sync.dir/progress.make

# Include the compile flags for this target's objects.
include apps/CMakeFiles/spmv_sync.dir/flags.make

apps/CMakeFiles/spmv_sync.dir/spmv_sync.cpp.o: apps/CMakeFiles/spmv_sync.dir/flags.make
apps/CMakeFiles/spmv_sync.dir/spmv_sync.cpp.o: ../apps/spmv_sync.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/zhengxd/blaze/test/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object apps/CMakeFiles/spmv_sync.dir/spmv_sync.cpp.o"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/spmv_sync.dir/spmv_sync.cpp.o -c /home/zhengxd/blaze/apps/spmv_sync.cpp

apps/CMakeFiles/spmv_sync.dir/spmv_sync.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/spmv_sync.dir/spmv_sync.cpp.i"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/zhengxd/blaze/apps/spmv_sync.cpp > CMakeFiles/spmv_sync.dir/spmv_sync.cpp.i

apps/CMakeFiles/spmv_sync.dir/spmv_sync.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/spmv_sync.dir/spmv_sync.cpp.s"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/zhengxd/blaze/apps/spmv_sync.cpp -o CMakeFiles/spmv_sync.dir/spmv_sync.cpp.s

apps/CMakeFiles/spmv_sync.dir/boilerplate.cpp.o: apps/CMakeFiles/spmv_sync.dir/flags.make
apps/CMakeFiles/spmv_sync.dir/boilerplate.cpp.o: ../apps/boilerplate.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/zhengxd/blaze/test/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object apps/CMakeFiles/spmv_sync.dir/boilerplate.cpp.o"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/spmv_sync.dir/boilerplate.cpp.o -c /home/zhengxd/blaze/apps/boilerplate.cpp

apps/CMakeFiles/spmv_sync.dir/boilerplate.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/spmv_sync.dir/boilerplate.cpp.i"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/zhengxd/blaze/apps/boilerplate.cpp > CMakeFiles/spmv_sync.dir/boilerplate.cpp.i

apps/CMakeFiles/spmv_sync.dir/boilerplate.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/spmv_sync.dir/boilerplate.cpp.s"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/zhengxd/blaze/apps/boilerplate.cpp -o CMakeFiles/spmv_sync.dir/boilerplate.cpp.s

apps/CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.o: apps/CMakeFiles/spmv_sync.dir/flags.make
apps/CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.o: ../src/Runtime.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/zhengxd/blaze/test/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object apps/CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.o"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.o -c /home/zhengxd/blaze/src/Runtime.cpp

apps/CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.i"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/zhengxd/blaze/src/Runtime.cpp > CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.i

apps/CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.s"
	cd /home/zhengxd/blaze/test/apps && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/zhengxd/blaze/src/Runtime.cpp -o CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.s

# Object files for target spmv_sync
spmv_sync_OBJECTS = \
"CMakeFiles/spmv_sync.dir/spmv_sync.cpp.o" \
"CMakeFiles/spmv_sync.dir/boilerplate.cpp.o" \
"CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.o"

# External object files for target spmv_sync
spmv_sync_EXTERNAL_OBJECTS =

bin/spmv_sync: apps/CMakeFiles/spmv_sync.dir/spmv_sync.cpp.o
bin/spmv_sync: apps/CMakeFiles/spmv_sync.dir/boilerplate.cpp.o
bin/spmv_sync: apps/CMakeFiles/spmv_sync.dir/__/src/Runtime.cpp.o
bin/spmv_sync: apps/CMakeFiles/spmv_sync.dir/build.make
bin/spmv_sync: libllvm/libgllvm.a
bin/spmv_sync: libgalois/libgalois_shmem.a
bin/spmv_sync: /usr/lib/x86_64-linux-gnu/libnuma.so
bin/spmv_sync: apps/CMakeFiles/spmv_sync.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/zhengxd/blaze/test/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX executable ../bin/spmv_sync"
	cd /home/zhengxd/blaze/test/apps && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/spmv_sync.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
apps/CMakeFiles/spmv_sync.dir/build: bin/spmv_sync

.PHONY : apps/CMakeFiles/spmv_sync.dir/build

apps/CMakeFiles/spmv_sync.dir/clean:
	cd /home/zhengxd/blaze/test/apps && $(CMAKE_COMMAND) -P CMakeFiles/spmv_sync.dir/cmake_clean.cmake
.PHONY : apps/CMakeFiles/spmv_sync.dir/clean

apps/CMakeFiles/spmv_sync.dir/depend:
	cd /home/zhengxd/blaze/test && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/zhengxd/blaze /home/zhengxd/blaze/apps /home/zhengxd/blaze/test /home/zhengxd/blaze/test/apps /home/zhengxd/blaze/test/apps/CMakeFiles/spmv_sync.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : apps/CMakeFiles/spmv_sync.dir/depend

