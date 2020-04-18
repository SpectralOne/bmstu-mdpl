STK SEGMENT para STACK 'STACK'
	db 64 dup(?)
STK ENDS

SD1 SEGMENT 'DATA'
    string db 6,0              ; �����
    buf db 6 dup(?)            ; ����� ��� �����
    new_line db 0Ah, '$'       ; ������� �� ����� ������
    result db 'sum: $'         ; ������ ����� sum 
SD1 ENDS

SD2 SEGMENT 'DATA'
    org 1h  ; ��������
    R DB 0  ; ������������� ����������
SD2 ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1, SS:STK
main: 
    mov ax, SD1 ; ������������� ����� �������� ������ SD1
    mov ds, ax  ;
    
    mov ah,0ah               ; ������������� ��������� ����
    mov dx, offset string    ; ���������� � ������ 
    int 21h                  ; �������� ������
    
    mov ah,09h               ; ������� ������ ������
    mov dx, offset new_line  ; ���������� � ������
    int 21h                  ; �������� ������
    
    mov ah,09h               ; ������� ������ ������
    mov dx, offset result    ; ���������� � ������
    int 21h                  ; ��������
    
    assume DS:SD2        ; ������������ �� ������ ������� 
    mov bx,OFFSET string ; ������������� � bx ������ ������
    mov al,[bx+3]        ; ������������� � al �������� 2 ������� ������
    sub al, 30h          ; ��������� ������ � �����
    add al,[bx+6]        ; ���������� 5 ������ ������
    
    mov R, al   ; ���������� � R ����� �����
    mov ah, 02  ; ������� ������ �� �����
    mov dl, R   ; ���������� ��������� � dl 
    int 21h     ; �����
    
	mov ax, 4c00h ; ���������� ��������� � ����� ������ 0
	int 21h
CSEG ENDS
END main
