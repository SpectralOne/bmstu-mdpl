STK SEGMENT para STACK 'STACK'
	db 64 dup(?)
STK ENDS

SD1 SEGMENT 'DATA'
    string db 6,0              ; буфер
    buf db 6 dup(?)            ; место под буфер
    new_line db 0Ah, '$'       ; перенос на новую строку
    result db 'sum: $'         ; печать слова sum 
SD1 ENDS

SD2 SEGMENT 'DATA'
    org 1h  ; смещение
    R DB 0  ; инициализация переменной
SD2 ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1, SS:STK
main: 
    mov ax, SD1 ; устанавливаем адрес сегмента данных SD1
    mov ds, ax  ;
    
    mov ah,0ah               ; сигнализируем буфферный ввод
    mov dx, offset string    ; становимся в начало 
    int 21h                  ; начинаем читать
    
    mov ah,09h               ; команда печати строки
    mov dx, offset new_line  ; становимся в начало
    int 21h                  ; печатаем строку
    
    mov ah,09h               ; команда печати строки
    mov dx, offset result    ; становимся в начало
    int 21h                  ; печатаем
    
    assume DS:SD2        ; перемещаемся во второй сегмент 
    mov bx,OFFSET string ; устанавливаем в bx начало строки
    mov al,[bx+3]        ; устанавливаем в al значение 2 символа строки
    sub al, 30h          ; переводим символ в число
    add al,[bx+6]        ; прибавляем 5 символ строки
    
    mov R, al   ; записываем в R сумму чисел
    mov ah, 02  ; команда вывода на экран
    mov dl, R   ; установить результат в dl 
    int 21h     ; вывод
    
	mov ax, 4c00h ; завершение программы с кодом ошибки 0
	int 21h
CSEG ENDS
END main
