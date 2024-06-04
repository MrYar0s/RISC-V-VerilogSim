project(cmake_example)
cmake_minimum_required(VERSION 3.22)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})
add_executable(simulator main.cpp)
verilate(simulator SOURCES Simulator/Simulator.v
                   INCLUDE_DIRS Simulator
)