/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include <altera_avalon_spi.h>
#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <altera_avalon_spi_regs.h>


void showLeds(alt_u32 data[],alt_u32 length){
	int led = 0;
	while(led<length){
		if(IORD_ALTERA_AVALON_SPI_STATUS(SPI_BASE)&ALTERA_AVALON_SPI_STATUS_TRDY_MSK){
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_BASE, data[led]);
			led++;
		}
	}
}

alt_u32 color(alt_8 r,alt_8 g,alt_8 b){
	alt_u32 c;
	  c = r;
	  c <<= 8;
	  c |= g;
	  c <<= 8;
	  c |= b;
	  return c;
}
int main()
{ 


  /* Event loop never exits. */

	alt_u32 data[32];
	data[0] = 0x010101;
	data[1] = 0x040404;
	data[2] = 0x080808;
	data[3] = 0x0C0C0C;
	data[4] = 0x0F0F0F;
	data[5] = 0x303030;
	data[6] = 0x808080;
	data[7] = 0xA0A0A0;
	data[8] = 0xF0F0F0;
	data[9] = 0xFFFFFF;
	data[10] = 0xFFFFFF;
	data[11] = 0xFFFFFF;
	data[12] = 0xFFFFFF;
	data[13] = 0xFFFFFF;
	data[14] = 0xFFFFFF;
	data[15] = 0xFFFFFF;
	data[16] = 0xFFFFFF;
	data[17] = 0xFFFFFF;
	data[18] = 0xFFFFFF;
	data[19] = 0xFFFFFF;
	data[20] = 0xFFFFFF;
	data[21] = 0xFFFFFF;
	data[22] = 0xFFFFFF;
	data[23] = 0xFFFFFF;
	data[24] = 0xFFFFFF;
	data[25] = 0xFFFFFF;
	data[26] = 0xFFFFFF;
	data[27] = 0xFFFFFF;
	data[28] = 0xFFFFFF;
	data[29] = 0xFFFFFF;
	data[30] = 0xFFFFFF;
	data[31] = 0xFF00FF;

// 8 + 8 + 8


	alt_putstr("start\n");





		showLeds(data,32);



		alt_putstr("doet t\n");



  return 0;
}
