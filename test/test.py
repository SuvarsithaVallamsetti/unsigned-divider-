import cocotb
from cocotb.triggers import RisingEdge
from cocotb.result import TestFailure

def pack_input(dividend, divisor):
    return (dividend << 4) | (divisor & 0xF)

def extract_output(value):
    quotient = (value >> 4) & 0xF
    remainder = value & 0xF
    return quotient, remainder

@cocotb.test()
async def run_divider_test(dut):
    """Test the Unsigned Divider using cocotb"""
    dut._log.info("Starting Divider Testbench...")

    # Initialize signals
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)  # Reset pulse
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Test dividend = 0 to 15, divisor = 1 to 15 (avoid divide-by-zero first)
    for dividend in range(0, 16):
        for divisor in range(1, 16):
            # Apply input
            dut.ui_in.value = pack_input(dividend, divisor)
            await RisingEdge(dut.clk)  # Inputs latched
            await RisingEdge(dut.clk)  # Outputs updated

            value = dut.uo_out.value.integer
            quotient, remainder = extract_output(value)

            expected_quotient = dividend // divisor
            expected_remainder = dividend % divisor

            assert quotient == expected_quotient, f"FAIL: {dividend}/{divisor} Quotient got {quotient}, expected {expected_quotient}"
            assert remainder == expected_remainder, f"FAIL: {dividend}/{divisor} Remainder got {remainder}, expected {expected_remainder}"

    # Divide-by-zero Test
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    value = dut.uo_out.value.integer
    assert value == 0xFF, f"Divide-by-zero test failed, got {value:02X}, expected FF"

    dut._log.info("All Divider Tests Passed Successfully!")
