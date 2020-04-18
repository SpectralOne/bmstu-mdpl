extern ud_inp:near
extern ud_out:near
extern sd_out:near
extern ub_out:near
extern sh_out:near
public number

stk segment para stack 'STACK'
    db 200 dup (?)
stk ends

dseg segment public 'DATA'
	func dw ud_inp, ud_out, sd_out, ub_out, sh_out, exit
	menu db	'menu:', 10, 13
		db	'   0. Input number in unsigned dec', 10, 13
		db  '   1. Print number in unsigned dec', 10, 13
		db  '   2. Print number in signed   dec', 10, 13
		db	'   3. Print number in unsigned bin', 10, 13
		db	'   4. Print number in signed   hex', 10, 13
		db	'   5. Exit ', 10, 13
		db  'Your choice: '
		db  '$'
	number dw ?
dseg ends

cseg segment public 'CODE'
	assume cs:cseg, ds:dseg, ss:stk
main:
	mov ax, dseg
	mov ds, ax
	print_menu:
		mov dx, offset menu
		mov ah, 9
		int 21h
		
		mov ah, 1
		int 21h
		
		sub al, '0'
		mov BL, 2
		mul BL
		mov bx, ax    ; номер байта с которого хранится функция
		
		mov dl, 10
		mov ah, 2
		int 21h
		call func[bx]
		mov dl, 10
		mov ah, 2
		int 21h
		jmp print_menu

exit proc near
	mov ah, 4Ch
	int 21h
exit endp

cseg ends
end main