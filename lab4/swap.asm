stackseg segment para stack 'STACK'
    db 100 dup(?)
stackseg ends

; Сегмент данных, содержащий матрицу
dseg segment para 'DATA'
    entry_str db 'Enter size of matrix: $'
	inp_str db 'Enter matrix: $'
	out_str db 'Result matrix: $'
    m_row dw ?
    m_col dw ?
    max db 0
    max_idx dw 0
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

upd_max macro idx
    mov al, matrix[idx]
    mov max, al
    mov ax, idx
    mov max_idx, ax
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
    mov cx, m_row
    INP_ROW:
        push cx
        mov cx, m_col
        INP_COL:
            call input_symb
            mov matrix[bx], al
            print ' '
            inc bx
            loop INP_COL
        pop cx
        call new_line
        loop INP_ROW
    call new_line
    ret
read_mtr endp

; Вывод матрицы
out_mtr proc near 
    xor bx, bx
    mov cx, m_row
    OUT_ROW:
        push cx
        mov cx, m_col
        OUT_COL:
            print matrix[bx]
            print ' '
            inc bx
            loop OUT_COL
        call new_line
        pop cx
        loop OUT_ROW
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
    mov m_row, bx
    print ' '
    
    xor bx, bx
    call input_size
    mov m_col, bx
    
    call new_line
    
    ; Приглашение к вводу
    message inp_str
    call new_line
    
    ; Ввод
    call read_mtr
 
    xor bx, bx
    mov cx, m_row
    OUT_ROW:
        push cx     ; запоминаем размер
        upd_max bx  ; обновляем максимум (1 элемент строки)
        
        mov cx, m_col
        OUT_COL:
            mov al, max
            cmp matrix[bx], al ; сравниваем
            jg UPD_MAX_LBL     ; переходим
            
            back: 
            inc bx
            loop OUT_COL
        mov al, max         ; загружаем максимум
        sub bx, m_col       ; вычитаем из текущего индекса количество столбцов (попадаем в начало строки)
        xchg matrix[bx], al ; меняем 1 элемент с максимумом
        add bx, m_col       ; возвращаемся в конец строки
        push bx             ; сохраняем индекс конца
        mov bx, max_idx     ; загружаем макс индекс
        xchg matrix[bx], al ; меняем 
        
        pop bx              
        pop cx
        loop OUT_ROW
    jmp next
    
UPD_MAX_LBL:
    upd_max bx ; обновляем
    jmp back

next:

    ; Пояснение к выводу
    message out_str
    call new_line

    ; Вывод
    call out_mtr

    mov ax, 4c00h
    int 21h
cseg ends
end main