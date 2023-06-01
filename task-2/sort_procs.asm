%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .data
    ; 
    entry dd 0
    index dd 0
    length dd 0
    current_priority dw 0
    next_priority dw 0

section .text
    global sort_procs
    extern printf

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    mov dword[length], eax
    ; we decrement the length because we will compare the current elem with the next one
    sub dword[length], 1
; reinit entry, index & the starting point after we make more than 0 swap
setup:
    mov dword[entry], 0
    mov dword[index], 0
    mov edx, [ebp + 8]
; we iterate through each process and make the swap when it's needed 
while_loop:
    ; move in al the priority of current element
    mov al, byte[edx + 2]
    ; move in cl the priority of next element
    mov cl, byte[edx + 7]
    ; compare first & second process by priority
    cmp al, cl
    ; if first is greater, swap them
    jg swap
    ; if first is less, go to next element from array
    jl next_step
    ; else, go to the next criterium of sorting
    mov ebx, dword[index]
    ; move in ax, time of first process
    mov ax, [edx + 3]
    ; move in cx time of 2nd process
    mov cx, [edx+ 8]
    ; compare and swap if needed
    cmp ax, cx
    jg swap
    ; if first is less, go to next element from array
    jl next_step
    ; if first is greater, swap them
    mov ebx, dword[index]
    ; move id of 1st process in ax
    mov ax, [edx]
    ; move id of 2nd process in cx
    mov cx, [edx + 5]
    ; compare and swap if first is greater than 2nd id
    cmp ax, cx
    jg swap
next_step:
    ; add the size of struct to continue comparing from next element
    add edx, proc_size
    ; increment the index bc we are at next elem
    inc dword[index]
    mov ebx, [length]
    ; verify if the index is still less than ebx=length
    cmp dword[index], ebx
    ; if true, continue the comparing
    jl while_loop
    ; verify if any changes were made
    cmp dword[entry], 0
    ; if yes, recompare all the elements again
    jg setup
    ; else exit the program
    jmp exit_from_program

swap:
    ; increment entry to show that we've made a change(swap)
    inc dword[entry]
    ; move in eax the first element
    mov eax, [edx]
    ; move in ecx the second element
    mov ecx, [edx + 5]
    ; change their places
    mov [edx], ecx
    mov [edx + 5], eax
    jmp next_step
    
exit_from_program:
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY