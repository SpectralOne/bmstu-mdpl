PUBLIC output_X ; вызываться из другого файла
EXTRN X: byte ; искать перемнную в другом файле

DS2 SEGMENT AT 0b800h ; видеопамять, 1 байт - символ (код), 2 байт - атрибут (цвет, фон, мигание)
	CA LABEL byte 
	ORG 80 * 2 * 2 + 2 * 2 ; 80 символов по 2 байта (ворд) , последняя 2 - номер строки, после + перемещение по столбцам (2 байта - один символ)
	SYMB LABEL word ; после смещения объявляем, благодаря ей знаем где высвечивать символ
DS2 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE' 
	assume CS:CSEG, ES:DS2
output_X proc near 
	mov ax, DS2
	mov es, ax
	mov ah, 10 ; параметры (атрибуты) 
	mov al, X ; сам символ
	mov symb, ax ; запись в видеобуфер ? (происходит высвечивание)
	ret ; возвращаем управление вызывающей программе
output_X endp
CSEG ENDS
END
