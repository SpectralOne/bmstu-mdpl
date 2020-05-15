global my_strncpy

section .text
my_strncpy:
    mov rcx, rdi   ; len
    lea rsi, [rsi] ; s1
    lea rdi, [rdx] ; s2

    cld ; direction = 0

    cmp rsi, rdi
    je exit            ; s2 == s1
    jb forward         ; s2 < s1

    ; s2 > s1
    std ; direction = 1
    add rsi, rcx
    dec rsi
    add rdi, rcx
    dec rdi

    forward:
    rep movsb			

    exit:

    cld ; direction = 0

    ret
