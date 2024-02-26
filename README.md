# VGA_System

VLSI System to integrate a Video Graphics Array, Arithmetic Logic Unit, Random Access Memory, and Keyboard.
Incorporates multiple clock speeds, controllers, memory, data structures, graphics.

~ Each file that was used in the final implementation has a small description at its top. 

~ Modules were tested individually through test benches and syntheses and then integrated.

~ FPGA Board: Xilinx XC7A100TCSG

~ Worst-Case Propagation Delay: 4.5ns on a 100 MHz system clock.

~ LUT Utilization: 3.18%

~ Written in Verilog. Vivado-Provided RAM IP is written in VHDL.

General Project Structure:
1. Keyboard receives data in the order of A Operation B, where Operation can be +,-,*,MOD3. While a proper sequence is in progress, the numbers/operation are displayed on the Video Graphics Array.
2. This information is added to the RAM using a stack (FIFO) approach.
3. When the keyboard's ENTER button is pressed, the most recent A Operation B sequence is displayed on the Video Graphics Array along with the solution.
