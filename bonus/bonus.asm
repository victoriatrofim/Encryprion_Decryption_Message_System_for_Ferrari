%include "../include/io.mac"

section .data
    entry dd 0
    idx_for_looping_shift dd 0
section .text
    global bonus
    extern printf

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE
    
    mov dword[ecx], 0
    mov dword[ecx + 4], 0
    ;; Entry variable is using for step's jump in function write_one
    mov dword[entry], 0
    ;; idx_for_looping_shift variable is using for shift number
    mov dword[idx_for_looping_shift], 0
    ;; Push eax & ebx for save value
    push eax
    push ebx
    ;; Check down-left corner to write 1
    dec eax
    dec ebx
    inc dword[entry]
    cmp eax, 0
    ;; If first validation passed, go to second validation
    jge verify_1
next_1:
    mov dword[idx_for_looping_shift], 0
    ;; Take back saved values in eax & ebx
    pop ebx
    pop eax
    ;; Push eax & ebx for save value
    push eax
    push ebx
    ;; Check up-left corner to write 1
    inc eax
    dec ebx
    inc dword[entry]
    cmp eax, 7
    ;; If first validation passed, go to second validation
    jle verify_2
next_2:
    mov dword[idx_for_looping_shift], 0
    ;; Take back saved values in eax & ebx
    pop ebx
    pop eax
    ;; Push eax & ebx for save value
    push eax
    push ebx
    ;; Check up-right corner to write 1
    inc eax
    inc ebx
    inc dword[entry]
    cmp eax, 7
    ;; If first validation passed, go to second validation
    jle verify_3
next_3:
    mov dword[idx_for_looping_shift], 0
    ;; Take back saved values in eax & ebx
    pop ebx
    pop eax
    ;; Push eax & ebx for save value
    push eax
    push ebx
    ;; Check down-right corner to write 1
    dec eax
    inc ebx
    inc dword[entry]
    cmp eax, 0
    ;; If first validation passed, go to second validation
    jge verify_4
    jmp stop

    ;; Function for shift number from board[1]
shift_bord_1:
    ;; If eax is great then 3 that mean we need to shift number from board[0]
    cmp eax, 3
    jg shift_bord_0
    ;; Mult eax with 8 for go to corresponding line
    imul eax, 8
    ;; Add in eax value of ebx for go to corresponding column
    add eax, ebx
    ;; Set ebx to 1 for shift bit 1 in number
    mov ebx, 1
    ;; Shift bit 1 with eax positions
shift_left_loop:
    shl ebx, 1
    inc dword[idx_for_looping_shift]
    cmp dword[idx_for_looping_shift], eax
    jl shift_left_loop
    ;; Do or operand for saving another bit 1 what we placed
    or [ecx + 4], ebx
    ;; Compare value of entry to continue program from the appropriate place
    cmp dword[entry], 1
    je next_1
    cmp dword[entry], 2
    je next_2
    cmp dword[entry], 3
    je next_3
    cmp dword[entry], 4
    je stop

shift_bord_0:
    ;; Substract from eax 4 unity for set range from 0 to 3
    sub eax, 4
    ;; Mult eax with 8 for go to corresponding line
    imul eax, 8
    ;; Add in eax value of ebx for go to corresponding column
    add eax, ebx
    ;; Set ebx to 1 for shift bit 1 in number
    mov ebx, 1
    ;; Shift bit 1 with eax positions
shift_left_loop_2:
    shl ebx, 1
    inc dword[idx_for_looping_shift]
    cmp dword[idx_for_looping_shift], eax
    jl shift_left_loop_2
    ;; Do or operand for saving another bit 1 what we placed
    or [ecx], ebx
    ;; Compare value of entry to continue program from the appropriate place
    cmp dword[entry], 1
    je next_1
    cmp dword[entry], 2
    je next_2
    cmp dword[entry], 3
    je next_3
    cmp dword[entry], 4
    je stop

    ;; Function for second step validation
verify_1:
    cmp ebx, 0
    jge shift_bord_1
    jmp next_1

    ;; Function for second step validation
verify_2:
    cmp ebx, 0
    jge shift_bord_1
    jmp next_2

    ;; Function for second step validation
verify_3:
    cmp ebx, 7
    jle shift_bord_1
    jmp next_3

    ;; Function for second step validation
verify_4:
    cmp ebx, 7
    jle shift_bord_1

stop:
    pop eax
    pop ebx
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY