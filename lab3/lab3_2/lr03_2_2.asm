SD1 SEGMENT para common 'DATA' ; common - все сегменты типа дата рапологаются по одному адресу (перекрыватся и совместно используют память) (друг за ругом паблик и стек) результирующий размер равен размеру самого большого сегмента
	C1 LABEL byte ; метка
	ORG 1h ; отступ
	C2 LABEL byte ; метка
SD1 ENDS

CSEG SEGMENT para 'CODE'
	ASSUME CS:CSEG, DS:SD1
main:
	mov ax, SD1
	mov ds, ax
	mov ah, 2 
	mov dl, C1 ; при прерывании выводится С1
	int 21h
	mov dl, C2 ; С2
	int 21h
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main
