.PHONY: lab8 clean

lab8 : lab8.o fadeshiftasm.o tscounter.o
	gcc -m64 $^ -lSDL -lSDL_image -o $@ -no-pie

lab8.o : src/lab8.c
	gcc -m64 -c -I/usr/include/SDL $^

fadeshiftasm.o : src/fadeshiftasm.s
	gcc -m64 -c $^

tscounter.o : src/tscounter.s
	gcc -m64 -c $^
	
clean : 
	rm *.o lab8
