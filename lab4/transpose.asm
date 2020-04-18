stackseg segment para stack 'STACK'
    db 100 dup(?)
stackseg ends

; Сегмент данных, содержащий матрицу
dseg segment para 'DATA'
    entry_str db 'Enter size of square matrix: $'
	inp_str db 'Enter matrix: $'
	out_str db 'Transposed matrix: $'
    m_size dw ?
    matrix db 9*9 dup(?)	
dseg ends

cseg segment para 'CODE'
    assume cs:cseg, ds:dseg, ss:stackseg

; Ввод символа
input_symb:
    mov ah, 1
    int 21h
    ret

; Ввод размера
input_size:
    mov ah, 1
    int 21h
    xor ah,ah
    sub al,'0'
    add bx,ax  
    ret

; Печать новой строки
new_line:
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret

; Печать сообщения
message macro string
    lea dx, string
    mov ah, 9
    int 21h
endm

; Печать символа
print macro char
    mov ah, 2
    mov dl, char
    int 21h
endm

; Ввод матрицы
read_mtr proc near
    xor bx, bx ; mov bx, 0
    mov cx, m_size 
    INP_COL:
        push cx
        mov cx, m_size
        INP_ROW:
            call input_symb
            mov matrix[bx], al
            print ' '
            inc bx
            loop INP_ROW
        pop cx
        call new_line
        loop INP_COL
    call new_line
    ret
read_mtr endp

; Вывод матрицы
out_mtr proc near 
    xor bx, bx
    mov cx, m_size
    OUT_COL:
        push cx
        mov cx, m_size 
        OUT_ROW:
            print matrix[bx]
            print ' '
            inc bx
            loop OUT_ROW
        call new_line
        pop cx
        loop OUT_COL
    call new_line
    ret
out_mtr endp

; Main
main:
    mov ax, dseg
    mov ds, ax

    ; Приглашение к вводу размерности
    message entry_str

    ; Ввод размерности
    call input_size
    mov m_size, bx
    call new_line
    
    ; Приглашение к вводу
    message inp_str
    call new_line
    
    ; Ввод
    call read_mtr
    
    ; Транспонирование 
    mov si,offset matrix
    mov bx, si     ; Заносим в регистры BX и SI базовые адреса начала матрицы
    mov dx, m_size
    mov cx, dx     ; В регистры CX и DX заносим размеры матрицы
    add bx, dx     ; Переходим к второй строке матрицы
    dec cx         ; Пропускаем клетку, лежащую на главной диагонали, которая не изменяется
    T_ROW:
        push cx
        push bx         ; Сохраняем размеры матрицы
        T_COL:
            inc si         ; Переходим к следующему столбцу
            mov al, [si]
            xchg al, [bx]
            mov [si], al   ; Обмен значений столбцов и строк
            add bx, dx     ; Переходим к следующей строке
            loop T_COL     ; Обмен строки верхнего треугольника с столбцом нижнего
        pop bx
        pop cx         ; Извлекаем сохраненные регистры
        add bx, dx
        inc bx         ; Переходим к следующему столбцу, пропуская клетку, лежащую на главной диагонали
        mov si, bx
        sub si, dx     ; и к следующей строке
        loop T_ROW       

    ; Пояснение к выводу
    message out_str
    call new_line
    
    ; Вывод
    call out_mtr

    mov ax, 4c00h
    int 21h
cseg ends
end main