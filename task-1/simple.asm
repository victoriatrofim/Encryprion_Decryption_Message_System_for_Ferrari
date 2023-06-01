%include "../include/io.mac"

section .text
    global simple
    extern printf

section .data
    index dd 0

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
    mov dword[index], 0
my_loop:
    ;; move index in ebx
    mov ebx, dword[index]
    ;; move in al the first letter from string
    mov al, [esi + ebx]
    ;; add the shifts to the first letter
    add eax, edx
    ;; compare if the result is greater that 90 = Z
    cmp eax, "Z"
    ;; If the res is greater than go to overflow
    jg overflow
;; we have a look for shifting each element
back_my_loop:
    ;; insert the first letter to make the encrypted string
    mov [edi + ebx], eax
    inc ebx
    ;; increment index for each letter
    inc dword[index]
    ;; verify if the index is less than the length of the string
    cmp ebx, ecx
    ;; if index is lower, 
    jl my_loop
    jmp exit
;; special case, the value after shifting is more than Z
overflow:
    ;; push the length of string for saving the value
    push ecx
    ;; save the extra value in eax
    sub eax, 90
    ;; init ecx with 'A' value
    mov ecx, 65
    ;; add the saved extra value 
    add ecx, eax
    ;; decrement once because the result will be increased with 1
    dec ecx
    mov eax, ecx
    ;; extract the previous value for ecx
    pop ecx
    jmp back_my_loop

    ;; DO NOT MODIFY
exit:
    popa
    leave
    ret
    
    ;; DO NOT MODIFY
