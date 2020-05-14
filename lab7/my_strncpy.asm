global my_strncpy

section .text
my_strncpy:
    mov rcx, rdi
    lea rsi, [rsi]
    lea rdi, [rdx]

    cld

    cmp rsi, rdi
    je exit            ; s2 == s1
    jb forward         ; s2 < s1

    ; s2 > s1
    std
    add rsi, rcx
    dec rsi
    add rdi, rcx
    dec rdi

    forward:
    rep movsb			

    exit:

    cld

    ret
