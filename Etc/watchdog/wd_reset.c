#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <termios.h>

#define WDG_STX               0x02
#define WDG_ACK               0x06
#define WDG_POLL              0x11
#define WDG_DISABLE           0x12
#define WDG_ENABLE            0x13
#define WDG_SET_TIME          0x14
#define WDG_INIT              0x15
#define WDG_SET_LCM_MODE      0x21
#define WDG_SET_LCM_OPEN_TIME 0x22
#define WDG_SET_LCM_MODE_TIME 0x23
#define WDG_REBOOT            0xA4
#define WDG_START             0x30

static const char *path = "/dev/ttyS5";

int UART_WD;

int WD_Init()
{
	struct termios conf;

	if((UART_WD = open(path, O_RDWR | O_NOCTTY)) == -1){
        fprintf(stderr, "watdhcod open fail!\n");
		return -1;
	}

	printf("watdog open %s success!\n", path);

    bzero(&conf, sizeof(conf));

    conf.c_cflag &= ~CSIZE;
    conf.c_cflag |= B9600 | CS8 | CLOCAL | CREAD;
	conf.c_cflag &= ~PARENB;
	conf.c_cflag &= ~CSTOPB;

	conf.c_iflag = IGNPAR;
    conf.c_oflag = OPOST;
    conf.c_lflag = IGNPAR;

	conf.c_cc[VTIME] = 0;
	conf.c_cc[VMIN] = 0;

    tcflush(UART_WD , TCIFLUSH);
    tcsetattr(UART_WD, TCSANOW, &conf);
    tcsetattr(UART_WD, TCSAFLUSH, &conf);

	return 0;
}

int WD_Enable()
{
    char buf[3] = { WDG_STX, WDG_ENABLE, 0x00};
    write(UART_WD, buf, 3);
	return 0;
}

int WD_Settime(int data)
{
    char buf[3] = { WDG_STX, WDG_SET_TIME, data};
    write(UART_WD, buf, 3);
	return 0;
}

void WD_Close(void)
{
    close(UART_WD);
}

void WD_Reboot()
{
	char buf[3] = { WDG_STX, WDG_REBOOT, 0x00};
	write(UART_WD, buf, 3);
	return 0;
}

int main()
{
	WD_Init();

	if(WD_Enable(UART_WD) < 0){
		printf("watchdog enable fail!\n");
		return -1;
	}

	sleep(5);

	WD_Reboot();

	return 0;
}
