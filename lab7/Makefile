.PHONY: lab7 clean

lab7 : lab7.o my_strncpy.o
	gcc -o $@ $^ -g

lab7.o : lab7.c
	gcc -c $^

my_strncpy.o : my_strncpy.asm
	nasm -f elf64 -o $@ $^

clean:
	rm -rf *.o *.s lab7
