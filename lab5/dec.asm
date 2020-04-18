public ud_inp
public ud_out
public sd_out
EXTERN number:WORD

cseg segment public 'CODE'
	assume cs:cseg
	
ud_inp proc near
	mov ax, seg number
	mov ds, ax
	mov bx, 10 ; основание системы счисления (10)
	mov ah, 1
	int 21h    ; ввод первого символа в al
	sub al,'0' ; перевод символа в число
	mov ah, 0
	mov cx, ax
	ud_inp_cycle:  
		mov ah, 1
		int 21h
		cmp al, 0dh
		je ud_inp_stop
        sub al, '0'
		mov ah, 0
		xchg ax, cx      ; теперь в ax - предыдущее число, в cx - следующая
		mul bx           ; ax * 10
		add cx, ax       ; cx = ax * 10 + cx
		jmp ud_inp_cycle ; продолжение ввода
	ud_inp_stop:    
		mov number, cx
		ret
ud_inp endp

ud_out proc near
	mov ax, seg number
	mov ds, ax
	mov ax, number
    mov bx, 10         ;делитель (основание системы счисления)
    mov cx, 0          ;количество выводимых цифр
    ud_out_div:
		xor dx, dx
        div bx
        add dl, '0'    ;преобразуем остаток деления в символ цифры
        push dx        ;и сохраняем его в стеке
        inc cx         ;увеличиваем счётчик цифр
        test ax, ax    ;в числе ещё есть цифры?
        jnz ud_out_div ;да - повторить цикл выделения цифры
    ud_out_print:
        mov ah, 2  
        pop dx            ;извлекаем из стека очередную цифру
        int 21h           ;и выводим её на экран
        loop ud_out_print ;и так поступаем столько раз, сколько нашли цифр в числе (cx)
	ret
ud_out endp


sd_out proc near
	mov ax, seg number
	mov ds, ax
	mov ax, number
	mov bx, 32767  ; 2^((2^4)-1)-1 максимальное знаковое
	cmp ax, bx
	ja sd_out_print_sign
sd_out_print_number:
    mov bx, 10       ;делитель (основание системы счисления)
    mov cx, 0        ;количество выводимых цифр
    sd_out_div:
		xor dx, dx
        div bx         ; AL = AX / BX, DL - остаток от деления
        add dl, '0'    ;преобразуем остаток деления в символ цифры
        push dx        ;и сохраняем его в стеке
        inc cx         ;увеличиваем счётчик цифр
        test ax, ax    ;в числе ещё есть цифры?
        jnz sd_out_div ;да - повторить цикл выделения цифры
    sd_out_print:
        mov ah, 2  
        pop dx            ;извлекаем из стека очередную цифру
        int 21h           ;и выводим её на экран
        loop sd_out_print ;и так поступаем столько раз, сколько нашли цифр в числе (cx)
	ret

sd_out_print_sign:
	not ax
	add ax, 1
	mov bx, ax
	mov ah, 2
	mov dl, '-'
	int 21h
	mov ax, bx
	jmp sd_out_print_number
sd_out endp


cseg ends
end