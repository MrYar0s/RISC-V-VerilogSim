project(Simulator)

cmake_minimum_required(VERSION 3.22)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})
set(CMAKE_CXX_STANDARD 20)

add_executable(simulator main.cpp)

add_subdirectory(FunctionalSimulator)

target_link_libraries(simulator PRIVATE elfio::elfio core)
add_subdirectory(third_party)

verilate(simulator SOURCES Simulator/Simulator.v
                   VERILATOR_ARGS --trace
                   INCLUDE_DIRS "./Simulator"
)