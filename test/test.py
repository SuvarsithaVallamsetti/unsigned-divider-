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

    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.uio_in.value = 0

    # Run tests for dividend = 0 to 15 and divisor = 1 to 15 (Avoid divide-by-zero)
    for dividend in range(0, 16):
        for divisor in range(1, 16):
            # Prepare inputs
            dut.ui_in.value = pack_input(dividend, divisor)
            await RisingEdge(dut.clk)  # Wait for a clock edge

            # Read outputs
            quotient, remainder = extract_output(int(dut.uo_out.value))

            # Expected results
            expected_quotient = dividend // divisor
            expected_remainder = dividend % divisor

            # Check correctness
            assert quotient == expected_quotient, f"Mismatch: {dividend}/{divisor} Quotient got {quotient}, expected {expected_quotient}"
            assert remainder == expected_remainder, f"Mismatch: {dividend}/{divisor} Remainder got {remainder}, expected {expected_remainder}"

    # Test divide-by-zero case (expect output 0xFF)
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    assert int(dut.uo_out.value) == 0xFF, f"Divide-by-zero test failed, got {int(dut.uo_out.value):02X}"

    dut._log.info("Divider Test Passed Successfully!")

