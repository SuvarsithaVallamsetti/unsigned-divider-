import cocotb
from cocotb.triggers import RisingEdge, Timer

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
    dut.uio_in.value = 0

    # Apply Reset
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Divider Tests
    for dividend in range(0, 16):
        for divisor in range(1, 16):
            dut.ui_in.value = pack_input(dividend, divisor)
            
            await RisingEdge(dut.clk)    # Inputs latched on clk edge
            await RisingEdge(dut.clk)    # DUT computes result here
            await Timer(1, units='ns')   # Wait for propagation delay

            value = dut.uo_out.value.integer  # <-- USE .integer to handle 'x' safely

            quotient, remainder = extract_output(value)

            expected_quotient = dividend // divisor
            expected_remainder = dividend % divisor

            assert quotient == expected_quotient, f"Quotient Mismatch: {dividend}/{divisor} got {quotient}, expected {expected_quotient}"
            assert remainder == expected_remainder, f"Remainder Mismatch: {dividend}/{divisor} got {remainder}, expected {expected_remainder}"

    # Divide-by-zero Test
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await Timer(1, units='ns')

    assert dut.uo_out.value.integer == 0xFF, f"Divide-by-zero test failed, got {dut.uo_out.value.integer:02X}"

    dut._log.info("Divider Test Passed Successfully!")
