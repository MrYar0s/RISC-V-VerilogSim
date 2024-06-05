#include <iostream>
#include <elfio/elfio.hpp>

#include "simulator/hart.h"
#include "VSimulator.h"
#include "VSimulator_DecodeStage.h"
#include "VSimulator_FetchStage.h"
#include "VSimulator_InstructionMem.h"
#include "VSimulator_RegFile.h"
#include "VSimulator_Simulator.h"
#include <verilated_vcd_c.h>

static int maxAttempts = 15;

enum class ERRORS
{
    NONE,
    SOFT,
    HARD
};

static enum ERRORS compareRegisterFiles(auto gpr1, auto gpr2, int &attempt)
{
    size_t regNumSize = 32;
    bool isEqual = true;
    for (size_t regNum = 0; regNum < regNumSize; regNum++) {
        bool res = (gpr1.read(regNum) & 0xFFFFFFFF ) == gpr2[regNum];
        isEqual = isEqual && res;
    }
    if (isEqual) {
        attempt = 0;
        return ERRORS::NONE;
    }
    if (attempt <= maxAttempts) {
        attempt += 1;
        return ERRORS::SOFT;
    }
    return ERRORS::HARD;
}

static void dumpStatus(auto err)
{
    if (err == ERRORS::SOFT) {
        std::cout << "###SOFT###" << std::endl;
    } else if (err == ERRORS::HARD) {
        std::cout << "###HARD###" << std::endl;
    } else if (err == ERRORS::NONE) {
        std::cout << "###NONE###" << std::endl;
    }
}

static void dumpResult(auto err, auto gpr1, auto gpr2)
{
    dumpStatus(err);
    size_t regNumSize = 32;
    std::cout << "FUNCTIONAL GPRF:" << std::endl;
    for (size_t regNum = 0; regNum < regNumSize; regNum++) {
        std::cout << "reg" << regNum << " " << (gpr1.read(regNum) & 0xFFFFFFFF) << std::endl;
    }
    std::cout << "CURRENT GPRF:" << std::endl;
    for (size_t regNum = 0; regNum < regNumSize; regNum++) {
        std::cout << "reg" << regNum << " " << gpr2[regNum] << std::endl;
    }
}


int main (int argc, char *argv[])
{
    Verilated::commandArgs(argc, argv);

    std::string path;

    if (argc < 2) {
        std::cout << "Need src file, please add it" << std::endl;
        return -1;
    }

    path = argv[1];

    auto topModule = std::make_unique<VSimulator>();

    Verilated::traceEverOn(true);
    auto vcd = std::make_unique<VerilatedVcdC>();

    topModule->trace(vcd.get(), 10);
    vcd->open("out.vcd");

    ELFIO::elfio m_reader{};
    if (!m_reader.load(path))
        throw std::invalid_argument("Bad ELF filename : " + path);
    if (m_reader.get_class() != ELFCLASS32) {
        throw std::runtime_error("Wrong ELF file class.");
    }

    if (m_reader.get_encoding() != ELFDATA2LSB) {
        throw std::runtime_error("Wrong ELF encoding.");
    }
    ELFIO::Elf_Half seg_num = m_reader.segments.size();

    for (size_t seg_i = 0; seg_i < seg_num; ++seg_i) {
        const ELFIO::segment *segment = m_reader.segments[seg_i];
        if (segment->get_type() != PT_LOAD) {
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

    // Init of functional model
    simulator::mem::MMU *mmu = simulator::mem::MMU::CreateMMU();
    uintptr_t entry_point = mmu->StoreElfFile(path);
    simulator::core::Hart hart(mmu, entry_point, false);

    vluint64_t vtime = 0;
    int clock = 1;
    topModule->clk = 1;
    topModule->rst = 0;

    topModule->Simulator->FETCH_STAGE->PC = m_reader.get_entry();

    int inst_counter = 0;
    int tackt = 0;
    int attempt = 0;
    int ret = 0;

    while (true) {
        vtime += 1;
        if (vtime % 8 == 0) {
            if (attempt == 0) {
                ret = hart.RunInstr();
                if (ret == 1) {
                    break;
                }
            }
            // switch the clock
            simulator::GPR_file registerFile = hart.getGPRfile();
            auto err = compareRegisterFiles(registerFile, topModule->Simulator->DECODE_STAGE->REG_FILE->Registers, attempt);
            dumpResult(err, registerFile, topModule->Simulator->DECODE_STAGE->REG_FILE->Registers);
            if (err == ERRORS::HARD) {
                return -1;
            }
            clock ^= 1;
            tackt += clock;
            topModule->rst = 0;
        }
        // if (vtime == 1000) {
        //     break;
        // }
        topModule->clk = clock;
        topModule->eval();
        vcd->dump(vtime);
    }

    topModule->final();
    vcd->close();

    return 0;
}
