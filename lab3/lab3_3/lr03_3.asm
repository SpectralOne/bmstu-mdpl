SD1 SEGMENT para public 'DATA'
	S1 db 'Y'
	db 65535 - 2 dup (0) ; это не нужно (меньше ехе будет весить)
SD1 ENDS

SD2 SEGMENT para public 'DATA'
	S2 db 'E'
	db 65535 - 2 dup (0)
SD2 ENDS

SD3 SEGMENT para public 'DATA' ; все сегменты расположатся друг за другом
	S3 db 'S'
	db 65535 - 2 dup (0)
SD3 ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1
output:
	mov ah, 2
	int 21h
	mov dl, 13 ; в начало
	int 21h
	mov dl, 10 ; новая строка
	int 21h
	ret
main: ; вход, по очереди все сегменты
	mov ax, SD1
	mov ds, ax
	mov dl, S1
	call output
assume DS:SD2
	mov ax, SD2
	mov ds, ax
	mov dl, S2
	call output
assume DS:SD3
	mov ax, SD3
	mov ds, ax
	mov dl, S3
	call output
	
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main
