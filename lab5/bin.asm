extern number:word
public ub_out

cseg segment public 'CODE'
	assume cs:cseg
ub_out proc near
	mov ax, seg number
	mov ds, ax
	mov bx, number
	mov cx, 16
	ub_out_cycle:
		mov ax, '0' ; в регистрах al=код символа '0', ah=00h
		shl bx, 1   ; выделение бита, последний выдвинутый бит, становится значением флага переноса cf   
		adc al, ah  ; сложение кода символа '0' со значением выделенного бита, складываем приёмник, источник и флаг CF.
		
        mov ah, 2
        mov dl, al
        int 21h
		loop ub_out_cycle
	ret
ub_out endp
cseg ends
end	