%include "../include/io.mac"
section .data

section .text
	global checkers
    extern printf
checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE
    ; here I search for corner cases for x & y
    cmp eax, 0
    je x_is_zero
    cmp ebx, 0
    je y_is_zero
    cmp eax, 7
    je x_is_max
    cmp ebx, 7
    je y_is_max

    ;; normal printing(no special case)
    ; print left down value
    sub eax, 1
    sub ebx, 1
    ; I use everywhere the formula [8 * x + y] to get to the wanted element
    imul eax, 8
    add eax, ebx
    ; move value 1 at the wanted place
    mov dword[ecx + eax], 1
    ; print left up value
    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    add ebx, 1
    sub eax, 1
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    ; print right down value
    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    inc eax
    sub ebx, 1
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    ; print right up value
    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    inc eax
    inc ebx
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    jmp exit

    ; Special case: y = 7
y_is_max:
    ; print left value
    sub eax, 1
    sub ebx, 1
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    ; print right value
    mov eax, [ebp + 8]	; x
    add eax, 1
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    jmp exit

    ; Special case: x = 7
x_is_max:
    cmp ebx, 7
    je x_max_y_max
    sub eax, 1
    push eax
    sub ebx, 1
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    pop eax
    add ebx, 2
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    jmp exit

    ; Special case: y = x = 7
x_max_y_max:
    sub eax, 1
    sub ebx, 1
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    jmp exit

    ; Special case: y = 0
y_is_zero:
    cmp eax, 7
    je top_x_zero_y
    sub eax, 1
    inc ebx
    push ebx
    imul eax, 8
    add eax, ebx 
    pop ebx ; in ebx remains the right column 
    ; print the lower value
    mov dword[ecx + eax], 1
    ; print the upper value
    mov eax, [ebp + 8]	; x
    inc eax
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    jmp exit

    ; Special case: x = 7 & y = 0
top_x_zero_y:
    sub eax, 1
    add ebx, 1
    imul eax, 8
    add eax, ebx 
    mov dword[ecx + eax], 1
    jmp exit

    ; Special case: x = 0
x_is_zero:
    ; search for the value of y
    cmp ebx, 0
    je x_y_is_zero
    cmp ebx, 7
    je x_zero_y_top
    ; if it's not a corner case, go to middle case 
    jmp back_to_middle_down

    ; Special case: x = y = 0
x_y_is_zero:
    mov dword[ecx + 9], 1
    jmp exit

    ; Special case: x = 0, y = 7
x_zero_y_top:
    mov dword[ecx + 14], 1
    jmp exit

    ; printing those 2 elements for x,y being on south line  
back_to_middle_down:
    inc eax
    sub ebx, 1
    imul eax, 8
    add ebx, eax
    mov dword[ecx + ebx], 1
    ; print right value
    ; get back to initial values of x & y
    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    add eax, 1
    inc ebx
    imul eax, 8
    add eax, ebx
    mov dword[ecx + eax], 1
    ; print left value
    jmp exit
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
exit:
    popa
    leave
    ret
    ;; DO NOT MODIFY