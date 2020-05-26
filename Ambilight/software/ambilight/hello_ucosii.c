/*************************************************************************
* Copyright (c) 2004 Altera Corporation, San Jose, California, USA.      *
* All rights reserved. All use of this software and documentation is     *
* subject to the License Agreement located at the end of this file below.*
**************************************************************************
* Description:                                                           *
* The following is a simple hello world program running MicroC/OS-II.The * 
* purpose of the design is to be a very simple application that just     *
* demonstrates MicroC/OS-II running on NIOS II.The design doesn't account*
* for issues such as checking system call return codes. etc.             *
*                                                                        *
* Requirements:                                                          *
*   -Supported Example Hardware Platforms                                *
*     Standard                                                           *
*     Full Featured                                                      *
*     Low Cost                                                           *
*   -Supported Development Boards                                        *
*     Nios II Development Board, Stratix II Edition                      *
*     Nios Development Board, Stratix Professional Edition               *
*     Nios Development Board, Stratix Edition                            *
*     Nios Development Board, Cyclone Edition                            *
*   -System Library Settings                                             *
*     RTOS Type - MicroC/OS-II                                           *
*     Periodic System Timer                                              *
*   -Know Issues                                                         *
*     If this design is run on the ISS, terminal output will take several*
*     minutes per iteration.                                             *
**************************************************************************/


#include <stdio.h>
#include "includes.h"
#include "sys/alt_stdio.h"
#include <altera_avalon_spi.h>
#include <system.h>
#include <stdlib.h>
#include <altera_avalon_spi_regs.h>
/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2



void refreshRate(int length){
	for(int a=0 ;a<length;a++){for(int b=0 ;b<length;b++){}}
}
void showLeds(alt_u32 data[],alt_u32 length){
	int led = 0;
	while(led<length){
		if(IORD_ALTERA_AVALON_SPI_STATUS(SPI_BASE)&ALTERA_AVALON_SPI_STATUS_TRDY_MSK){
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_BASE, data[led]);
			led++;
		}
	}
}
void task1(void* pdata)
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
		  }else if(cc == 0x00FF00){
			  cc = 0xFF0000;
		  }else{
			  cc = 0x0000FF;
		  }
	  }
	  showLeds(color,32);
	 color[i]=cc;
	  i++;

	  refreshRate(10);
	  OSTimeDlyHMSM(0, 0, 0, 10);
  }
}


/* The main function creates two task and starts multi-tasking */
int main(void)
{

  OSTaskCreateExt(task1,
                  NULL,
                  (void *)&task1_stk[TASK_STACKSIZE-1],
                  TASK1_PRIORITY,
                  TASK1_PRIORITY,
                  task1_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);



  OSStart();
  return 0;
}

