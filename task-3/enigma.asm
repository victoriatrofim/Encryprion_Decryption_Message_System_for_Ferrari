%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain
    x dd 0
    rotor dd 0
    forward dd 0
    idx dd 0
    unusual_variable dd 0
    character db 0
    plain_character dd 0
    chr_idx dd 0
    enc_character dd 0
    len_idx dd 0

section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE

    ;; Save x, rotor number & direction to rotate
    mov dword[x], eax
    mov dword[rotor], ebx
    mov dword[forward], edx
    ;; In config matrix go to first rotor element
    imul ebx, 52
    add ecx, ebx
    ;; Check if number of rotating is 0, exit from program
    cmp dword[x], 0
    je stop

    ;; Check if direction to rotate is left or right
    mov dword[idx], 0
    cmp dword[forward], 0
    je left_shift
    jne right_shift

    ;; Loop for left shifting
left_shift:
    mov al, byte[ecx]
    mov dl, byte[ecx + 26]
    ;; Save first character from first rotor line in stive
    push eax
    ;; Save first character from second rotor line in stive
    push edx
    ;; Save index for number of rotating
    push dword[idx]
    mov dword[idx], 1
    ;; Go to shift rotor lines with one position
    jmp move_all_character_left
back_to_left_shift:
    ;; Take back index for number of rotating
    pop dword[idx]
    ;; Take first character for second line from stive
    pop edx
    ;; Take first character for first line from stive
    pop eax
    ;; Put saved character from eax at the end of the first line
    mov [ecx + 25], al
    ;; Put saved character from edx at the end of the second line
    mov [ecx + 51], dl
    mov eax, dword[x]
    inc dword[idx]
    ;; While idx is less than number of rotating repeat loop
    cmp dword[idx], eax
    jl left_shift
    jmp stop
    ;; Loop for shift all character with one position
move_all_character_left:
    mov eax, dword[idx]
    ;; Move characater from first line
    mov bl, [ecx + eax]
    mov [ecx + eax - 1], bl
    ;; Move character from second line
    mov bl, [ecx + eax + 26]
    mov [ecx + eax + 25], bl
    ;; Increment index and repeat loop
    add dword[idx], 1
    cmp eax, 25
    jl move_all_character_left
    jmp back_to_left_shift

    ;; Loop for right shifting
right_shift:
    mov al, [ecx + 25]
    mov dl, [ecx + 51]
    ;; Save last character from first rotor line in stive
    push eax
    ;; Save last character from second rotor line in stive
    push edx
    ;; Save index for number of rotating
    push dword[idx]
    mov dword[idx], 24
    ;; Go to shift rotor lines with one position
    jmp move_all_character_right
back_to_right_shift:
    ;; Take back index for number of rotating
    pop dword[idx]
    ;; Take last character for second line from stive
    pop edx
    ;; Take last character for first line from stive
    pop eax
    ;; Put saved character from eax at the start of the first line
    mov [ecx], al
    ;; Put saved character from edx at the start of the second line
    mov [ecx + 26], dl
    mov eax, dword[x]
    inc dword[idx]
    ;; While idx is less than number of rotating repeat loop
    cmp dword[idx], eax
    jl right_shift
    jmp stop

    ;; Loop for shift all character with one position
move_all_character_right:
    mov eax, dword[idx]
    ;; Move characater from first line
    mov bl, [ecx + eax]
    mov [ecx + eax + 1], bl
    ;; Move character from second line
    mov bl, [ecx + eax + 26]
    mov [ecx + eax + 27], bl
    ;; Decrement index and repeat loop
    sub dword[idx], 1
    cmp eax, 0
    jge move_all_character_right
    jmp back_to_right_shift

stop:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE
    mov dword[plain_character], 0
    mov dword[unusual_variable], 0
    mov dword[enc_character], -1
    mov dword[len_idx], 0

    ;; Loop for encrypt all character from plain
encryption_loop:
    ;; Save eax address
    push eax
    ;; Compare third key with third notche
    mov al, byte[ebx + 2]
    cmp byte[ecx + 2], al
    je rotate_second_rotor
    ;; Compare second key with second notche
    mov al, byte[ebx + 1]
    cmp byte[ecx + 1], al
    je rotate_first_rotor
back_to_loop:
    ;; Take back in eax address for plain
    pop eax
    ;; Push 0, config_matrix, 2 & 1 for call rotate_x_positions function
    ;; that will rotate third rotor left with one position
    push 0
    push edx
    push 2
    push 1
    call rotate_x_positions
    ;; Take back just changed matrix
    pop dword[unusual_variable]
    pop dword[unusual_variable]
    pop edx
    pop dword[unusual_variable]
    ;; Save eax address
    push eax
    ;; Increment third byte from key
    add byte[ebx + 2], 1
    ;; Check if character is greter than "Z"
    cmp byte[ebx + 2], "Z"
    pop eax
    ;; If true then jump to function that transform it in A
    jg change_third_key
    jmp start_encrypt

    ;; Function that rotate second rotor with one position
rotate_second_rotor:
    ;; Increment secont byte from key
    add byte[ebx + 1], 1
    ;; Check if character is greter than "Z"
    cmp byte[ebx + 1], "Z"
    ;; If true then jump to function that transform it in A
    je change_second_key
continue_rotate_second_rotor:
    ;; Push 0, config_matrix, 1 & 1 for call rotate_x_positions function
    ;; that will rotate second rotor left with one position
    push 0
    push edx
    push 1
    push 1
    call rotate_x_positions
    ;; Take back just changed matrix
    pop dword[unusual_variable]
    pop dword[unusual_variable]
    pop edx
    pop dword[unusual_variable]
    jmp back_to_loop

    ;; Function that rotate first rotor with one position
rotate_first_rotor:
    ;; Increment first byte from key
    add byte[ebx], 1
    ;; Check if character is greter than "Z"
    cmp byte[ebx], "Z"
    ;; If true then jump to function that transform it in A
    je change_first_key
continue_rotate_first_rotor:
    ;; Push 0, config_matrix, 0 & 1 for call rotate_x_positions function
    ;; that will rotate first rotor left with one position
    push 0
    push edx
    push 0
    push 1
    call rotate_x_positions
    ;; Take back just changed matrix
    pop dword[unusual_variable]
    pop dword[unusual_variable]
    pop edx
    pop dword[unusual_variable]
    ;; Increment second byte from key
    add byte[ebx + 1], 1
    ;; Check if character is greter than "Z"
    cmp byte[ebx + 1], "Z"
    ;; If true then jump to function that transform it in A
    je change_second_key
    jmp continue_rotate_second_rotor


change_first_key:
    mov byte[ebx], "A"
    jmp continue_rotate_first_rotor


change_second_key:
    mov byte[ebx + 1], "A"
    jmp continue_rotate_second_rotor


change_third_key:
    mov byte[ebx + 2], "A"

    ;; After rotate third rotor an verify 
    ;; if keys are equal with notches start encrypting
start_encrypt:
    ;; Save ebx address
    push ebx
    ;; Set in ebx position for next character
    mov ebx, [plain_character]
    add dword[plain_character], 1
    ;; Save ecx address
    push ecx
    ;; Move in cl register character from plain
    mov cl, byte[eax + ebx]
    ;; Move in chr_idx -1 because in function find_on_plugboard 
    ;; we start with line "inc chr_idx"
    mov dword[chr_idx], -1
    jmp find_on_plugboard
    ;; Function that will start after we encrypt character
encrypt_character:
    ;; Increment position for index that save position for character in edi
    inc dword[enc_character]
    ;; Save enctrypted character in bl
    mov bl, cl
    ;; Check if we read all plain or not
    inc dword[len_idx]    
    mov ecx, [len_plain]
    cmp dword[len_idx], ecx
    ;; If we don't read all plain jump to function that put character in edi
    jle write_character
    ;; If we finish to read clean steve en exit from program
    pop ecx
    pop ebx
    jmp exit_program

write_character:
    ;; Move encrypted character from bl to cl
    mov cl, bl
    ;; Move in ebx position for put character in edi
    mov ebx, [enc_character]
    ;; Write character in edi
    mov byte[edi + ebx], cl
    ;; Take back address for ecx
    pop ecx
    ;; Take back address for ebx
    pop ebx
    jmp encryption_loop


    ;; First we find elemnt on plugboard and save he's position in chr_idx
find_on_plugboard:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 234], cl
    jne find_on_plugboard
    ;; From the same position move in cl byte from third rotor from second line
    mov cl, [edx + ebx + 130]
    mov dword[chr_idx], -1
    ;; Find same character in third rotor in first line and save he's position
find_on_third_rotor:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 104], cl
    jne find_on_third_rotor
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from second rotor from second line
    mov cl, [edx + ebx + 78]
    mov dword[chr_idx], -1
    ;; Find same character in second rotor in first line and save he's position
find_on_second_rotor:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 52], cl
    jne find_on_second_rotor
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from first rotor from second line
    mov cl, [edx + ebx + 26]
    mov dword[chr_idx], -1
    ;; Find same character in first rotor in first line and save he's position
find_on_first_rotor:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx], cl
    jne find_on_first_rotor
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from reflector from second line
    mov cl, [edx + ebx + 182]
    mov dword[chr_idx], -1
    ;; Find same character in reflector in first line and save he's position
find_on_reflector:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 156], cl
    jne find_on_reflector
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from first rotor from first line
    mov cl, [edx + ebx]
    mov dword[chr_idx], -1
    ;; Find same character in first rotor in second line and save he's position
find_on_first_rotor_back:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 26], cl
    jne find_on_first_rotor_back
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from second rotor from first line
    mov cl, [edx + ebx + 52]
    mov dword[chr_idx], -1
    ;; Find same character in second rotor in second line and save he's position
find_on_second_rotor_back:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 78], cl
    jne find_on_second_rotor_back
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from third rotor from first line
    mov cl, [edx + ebx + 104]
    mov dword[chr_idx], -1
    ;; Find same character in third rotor in second line and save he's position
find_on_third_rotor_back:
    inc dword[chr_idx]
    mov ebx, dword[chr_idx]
    cmp [edx + ebx + 130], cl
    jne find_on_third_rotor_back
    mov ebx, dword[chr_idx]
    ;; From the same position move in cl byte from plugboard from second line
    mov cl, [edx + ebx + 234]
    ;; Now we have encrypted character
    jmp encrypt_character

exit_program:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY