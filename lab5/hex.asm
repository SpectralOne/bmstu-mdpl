extern number:word
public sh_out

cseg segment public 'CODE'
	assume cs:cseg
sh_out proc near
	mov ax, seg number
	mov ds, ax
	mov ax, number
	mov bx, 32767
	cmp ax, bx
	ja sh_out_print_sign
sh_out_print_number:
    mov    CL,	16-4  ; 16-битный регистр, будем выводить по 4 бита (0..F)
    xchg   dx,	ax    ; Сохраняем число в dx
 
	sh_out_cycle:
 
        mov ax, dx     ; Восстанавливаем число в ax
        shr ax, cl     ; Сдвигаем на CL бит вправо
        and al, 0Fh    ; Получаем в al цифру 0..15
        add al, '0'    ; Получаем в al символ цифры
        cmp al, '9'    ; Проверяем цифру
        
        jbe sh_out_print     ; Прыгаем, если это цифра 0..9
        add al,	'A'-('9'+1)  ; Иначе (для A..F) корректируем ее
	sh_out_print:
		mov dl, al ; произошёл троллинг.............
		mov ah, 2h
		int 21h
	
        ;int 29h    ;???        ; Выводим символ в al на экран
        sub cl,	4          ; Уменьшаем CL на 4 для следующей цифры
        jnc sh_out_cycle
        ret
		
sh_out_print_sign:
	NOT ax
	add ax, 1
	mov bx, ax
	mov ah, 2
	mov dl, '-'
	int 21h
	mov ax, bx
	jmp sh_out_print_number
sh_out endp
cseg ends
end