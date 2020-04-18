PUBLIC X ; в других файлах
EXTRN exit: far ; дальний переход из другого файла

SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0)
SSTK ENDS

SD1 SEGMENT para public 'DATA'
	X db 'X' ; инициализация
SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:SD1
main:	
	jmp exit ; прыгаем в exit (нехорошо - не сможем вернуться обратно)
SC1 ENDS
END main
