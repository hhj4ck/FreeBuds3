CFLAGS := -O2 -std=c99 -Wall

all: exploit 
	./exploit

shellcode.o:
	arm-eabi-as -mthumb -EL -o shellcode.sbin shellcode.s
	arm-eabi-objcopy -O binary -j .text shellcode.sbin shellcode.bin
	ld -r -b binary -o shellcode.o shellcode.bin
	rm shellcode.bin shellcode.sbin

exploit: shellcode.o
	$(CC) -o exploit exploit.c shellcode.o libusb-1.0.a -lpthread -ludev
	rm shellcode.o

clean:
	rm exploit
