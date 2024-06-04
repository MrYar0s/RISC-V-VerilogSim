project(Simulator)

cmake_minimum_required(VERSION 3.22)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(simulator main.cpp)

target_link_libraries(simulator PRIVATE elfio::elfio)
add_subdirectory(third_party)

verilate(simulator SOURCES Simulator/Simulator.v
                   VERILATOR_ARGS --trace
                   INCLUDE_DIRS "./Simulator"
)