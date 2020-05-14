.386
.model flat, c
public my_strncpy

.code
my_strncpy proc
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi

    mov     ecx, [ebp + 16] ; len
    mov     edi, [ebp + 12] ; dst
    mov     esi, [ebp + 8]  ; src

    rep movsb

    pop  edi
    pop  esi
    pop  ebp

    ret
my_strncpy endp
end
