.386
.model flat, c
public my_strncpy

.code
my_strncpy proc
    push ebp
    mov ebp, esp
    push esi
    push edi
    
    mov ecx, [ebp + 16] ; len
    mov edi, [ebp + 12] ; dst
    mov esi, [ebp + 8]  ; src

    cld            ; direction = 0
    cmp edi, esi
    je exit        ; dst == src
    jb forward     ; dst < src

    ; dst > src
    std            ; direction = 1
    add edi, ecx
    dec edi
    add esi, ecx
    dec esi

forward:
    rep movsb			

exit:
    pop edi
    pop esi
    pop ebp

	ret
my_strncpy endp
end
