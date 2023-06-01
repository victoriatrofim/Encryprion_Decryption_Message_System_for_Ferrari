%include "../include/io.mac"

struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0
    index dd 0
    length dd 0
    ; we declare the array of structs
    avg_array: times avg_size * 5 dw 0

section .text
    global run_procs
    extern printf

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here
    ; set index to zero
    mov dword[index], 0
    ; move in variable length value from ebx that contain length
    mov dword[length], ebx
array_iterating:
    xor edx, edx
    ; move in dl byte of priority
    mov dl, byte[ecx + 2]
    ; decrement edx because priority have interval 1-5 but possition's in array are 0-4
    dec edx
    ; increment prio_result for read priority using formula prio_result + 4 * edx
    inc dword[prio_result + 4 * edx]
    xor ebx, ebx
    ; move in bx value of time
    mov bx, [ecx + 3]
    ; add in to array of time_result at position 4 * edx new read value from ebx
    add dword[time_result + 4 * edx], ebx
    ; add to ecx 5 => go to next structure
    add ecx, 5
    inc dword[index]
    mov ebx, [length]
    ; compare index with length for iterate all array of processes
    cmp dword[index], ebx
    jl array_iterating
    ; set index to 0
    mov dword[index], 0
; create array of avg structures
create_avg_array:
    ; save eax address for prov_avg output
    push eax
    ; use ecx like iterator for time_result array & prio_result array
    mov ecx, [index]
    cmp dword[time_result + 4 * ecx], 0
    ; if time result is zero for some priority jmp to zero_case that mov in ecx & ebx 0
    je zero_case
    ; ready edx for div
    xor edx, edx
    ; mov in eax value from time_result
    mov eax, [time_result + 4 * ecx]
    ; mov in ebx value from prio_result
    mov ebx, [prio_result + 4 * ecx]
    ; divide eax by ebx
    div ebx
    ; move value from eax in ecx to save it
    mov ecx, eax
; return function from zero case
back:
    ; take back value for eax array output
    pop eax
    ; mov in array of avg in quo value from cx
    mov word[avg_array], cx
    ; mov in output array in quo value from cx
    mov word [eax], cx
    ; add 2 for increment array position
    add eax, 2
    add word[avg_array], 2
    ; mov in array of avg in remain value from dx
    mov word[avg_array], dx
    ; mov in output array in remain value from dx
    mov word [eax], dx
    ; add 2 for increment array position
    add eax, 2
    add word[avg_array], 2
    inc dword[index]
    ; iterate all array of time_result & prio_result
    cmp dword[index], 5
    jl create_avg_array
    jmp exit
; zero case set ecx & ebx to 0
zero_case:
    mov ecx, 0
    mov edx, 0
    jmp back
; use for exit from program
exit:
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY