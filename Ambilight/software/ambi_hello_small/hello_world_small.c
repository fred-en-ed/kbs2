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
//#include "includes.h"

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


	alt_u32 color[32];
		color[0] = 0x010101;
		color[1] = 0x040404;
		color[2] = 0x080808;
		color[3] = 0x0C0C0C;
		color[4] = 0x0F0F0F;
		color[5] = 0x303030;
		color[6] = 0x808080;
		color[7] = 0xA0A0A0;
		color[8] = 0xF0F0F0;
		color[9] = 0xFFFFFF;
		color[10] = 0xFFFFFF;
		color[11] = 0xFFFFFF;
		color[12] = 0xFFFFFF;
		color[13] = 0xFFFFFF;
		color[14] = 0xFFFFFF;
		color[15] = 0xFFFFFF;
		color[16] = 0xFFFFFF;
		color[17] = 0xFFFFFF;
		color[18] = 0xFFFFFF;
		color[19] = 0xFFFFFF;
		color[20] = 0xFFFFFF;
		color[21] = 0xFFFFFF;
		color[22] = 0xFFFFFF;
		color[23] = 0xFFFFFF;
		color[24] = 0xFFFFFF;
		color[25] = 0xFFFFFF;
		color[26] = 0xFFFFFF;
		color[27] = 0xFFFFFF;
		color[28] = 0xFFFFFF;
		color[29] = 0xFFFFFF;
		color[30] = 0xFFFFFF;
		color[31] = 0xFF00FF;

		alt_8 i =0;
		alt_u32 cc = 0x0000FF;
  while (1)
  {
	  if(i>32){
		  i=0;
		  if(cc == 0x0000FF){
			  cc = 0x00FF00;
		  }else{
			  cc = 0x0000FF;
		  }
	  }
showLeds(color,32);
	 color[i]=cc;
	  i++;

	 // alt_putstr("doet t\n");


    //OSTimeDlyHMSM(0, 0, 0, 20);
	 // OSTimeDly(1);
  }



  return 0;
}
