#include <memory>
#include <elfio/elfio.hpp>

#include "VSimulator.h"
#include "VSimulator_FetchStage.h"
#include "VSimulator_InstructionMem.h"
#include "VSimulator_Simulator.h"
#include <verilated_vcd_c.h>

int main (int argc, char *argv[])
{
    Verilated::commandArgs(argc, argv);

    auto topModule = std::make_unique<VSimulator>();

    Verilated::traceEverOn(true);
    auto vcd = std::make_unique<VerilatedVcdC>();

    topModule->trace(vcd.get(), 10);
    vcd->open("out.vcd");

    ELFIO::elfio m_reader{};
    if (!m_reader.load("test.out"))
        throw std::invalid_argument("Bad ELF filename : test.out");
    if (m_reader.get_class() != ELFIO::ELFCLASS32) {
        throw std::runtime_error("Wrong ELF file class.");
    }

    if (m_reader.get_encoding() != ELFIO::ELFDATA2LSB) {
        throw std::runtime_error("Wrong ELF encoding.");
    }
    ELFIO::Elf_Half seg_num = m_reader.segments.size();

    for (size_t seg_i = 0; seg_i < seg_num; ++seg_i) {
        const ELFIO::segment *segment = m_reader.segments[seg_i];
        if (segment->get_type() != ELFIO::PT_LOAD) {
            continue;
        }
        uint32_t address = segment->get_virtual_address();

        size_t filesz = static_cast<size_t>(segment->get_file_size());
        size_t memsz = static_cast<size_t>(segment->get_memory_size());

        if (filesz) {
            const auto *begin =
                reinterpret_cast<const uint8_t *>(segment->get_data());
            uint8_t *dst =
                reinterpret_cast<uint8_t *>(topModule->Simulator->FETCH_STAGE->IMEM->Memory);
            std::copy(begin, begin + filesz, dst + address);
        }
    }

    vluint64_t vtime = 0;
    int clock = 1;
    topModule->clk = 1;
    topModule->rst = 0;

    topModule->Simulator->FETCH_STAGE->PC = m_reader.get_entry();

    int inst_counter = 0;
    int tackt = 0;

    while (!Verilated::gotFinish()) {
        vtime += 1;
        if (vtime % 8 == 0) {
            // switch the clock
            clock ^= 1;
            tackt += clock;
            topModule->rst = 0;
        }
        if (vtime == 1000) {
            break;
        }
        topModule->clk = clock;
        topModule->eval();
        vcd->dump(vtime);
    }

    topModule->final();
    vcd->close();

    return 0;
}
