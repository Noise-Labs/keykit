#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/smid.h>
#include <sys/signal.h>

main(argc,argv)
int argc;
char **argv;
{
	int fd;

	if ( argc > 1 )
		fd = open(argv[1],O_RDONLY );
	else
		fd = open("/dev/smid",O_RDONLY );
	ioctl(fd,MIDIRESET,0);
	close(fd);
}
