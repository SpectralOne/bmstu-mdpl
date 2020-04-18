STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

SD1 SEGMENT para common 'DATA'
	W dw 3444h ; выделяем 2 байта и записываем число, (записывается в память с конца) 44, 34
SD1 ENDS
END
