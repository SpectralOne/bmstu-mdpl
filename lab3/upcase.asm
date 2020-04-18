STK SEGMENT para STACK 'STACK'
	db 64 dup(?)
STK ENDS

SD1 SEGMENT 'DATA'
    string db 6,0              ; буфер
    buf db 6 dup(?)            ; место под буфер
    new_line db 0Ah, '$'       ; перенос на новую строку
    result db 'result: $'      ; строка результат 
SD1 ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1, SS:STK
main: 
    mov ax, SD1 ; устанавливаем адрес сегмента данных SD1
    mov ds, ax  
    
    mov ah,0ah               ; сигнализируем буфферный ввод
    mov dx, offset string    ; становимся в начало 
    int 21h                  ; начинаем читать
    
    mov ah,09h               ; команда печати строки
    mov dx, offset new_line  ; становимся в начало
    int 21h                  ; печатаем строку
    
    mov ah,09h               ; команда печати строки
    mov dx, offset result    ; становимся в начало
    int 21h                  ; печатаем
    
    
    mov bx,OFFSET string ; устанавливаем в bx начало строки
    mov al,[bx+4]        ; устанавливаем в al значение 3 символа строки
    sub al, 20h          ; Переводим символ в заглавный
    mov ah, 02  ; команда вывода на экран
    mov dl, al  ; помещаем символ в dl
    int 21h     ; вывод
    
	mov ax, 4c00h ; завершение программы с кодом ошибки 0
	int 21h
CSEG ENDS
END main
