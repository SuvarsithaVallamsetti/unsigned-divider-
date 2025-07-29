import cocotb
from cocotb.triggers import RisingEdge

def pack_input(dividend, divisor):
    return (dividend << 4) | (divisor & 0xF)

def extract_output(value):
    quotient = (value >> 4) & 0xF
    remainder = value & 0xF
    return quotient, remainder

@cocotb.test()
async def run_divider_test(dut):
    """Test Unsigned Divider"""
    dut._log.info("Starting Divider Testbench...")

    dut.ena.value = 1
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Normal Division Test Cases
    for dividend in range(0, 16):
        for divisor in range(1, 16):
            # Apply Inputs
            dut.ui_in.value = pack_input(dividend, divisor)
            await RisingEdge(dut.clk)  # Inputs are latched here

            await RisingEdge(dut.clk)  # Wait extra cycle for output to update

            value = dut.uo_out.value.integer
            quotient, remainder = extract_output(value)

            expected_quotient = dividend // divisor
            expected_remainder = dividend % divisor

            assert quotient == expected_quotient, \
                f"{dividend}/{divisor}: Quotient mismatch! Got {quotient}, Expected {expected_quotient}"
            assert remainder == expected_remainder, \
                f"{dividend}/{divisor}: Remainder mismatch! Got {remainder}, Expected {expected_remainder}"

    # Divide-by-Zero Test
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # Wait extra cycle
    value = dut.uo_out.value.integer
    assert value == 0xFF, f"Divide-by-zero failed: Got {value:02X}, Expected FF"

    dut._log.info("All tests passed successfully!")
