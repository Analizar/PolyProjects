
.386P
.model flat
.data

    shiftValue db ?                          ; Caesar cipher shift value 


.code

; Decrypt the message using Caesar cipher with a custom shift key
;stored by user in main shiftValue
decryptString PROC near
    push esi

    push ebx

    pop ebx                                ;SHIFT VALUE in bl after pop ebx

    mov ecx, 0                             ; ECX is the counter for the string length

_decryptString:
    mov al, byte ptr [esi + ecx]           ; Load the current character from ESI
    cmp al, 0                              ; Check if it's the null terminator (end of string)
    je exitDecrypt                         ; Exit if null terminator is reached

                                                                                                    ;sub al, bl                             ; Reverse the shift by subtracting the shift value

checkLowerCase:    ; Check if character is lowercase 'a' to 'z'
    cmp al, 'a'
    jl checkUppercase                      ; Skip to uppercase check if below 'a'
    cmp al, 'z'
    jg checkUppercase
    ; No wrap needed if within 'a'-'z'
    
lowerCaseDecryption:     ; Lowercase decryption (shift backward by subtracting shiftValue)
    sub al, bl                             ; Reverse the shift by subtracting shiftValue
    cmp al, 'a'                            ; Check if it goes below 'a'
    jge storeChar                          ; If in range save char
    add al, 26                             ; Wrap around to 'z' if it goes below 'a'
    jmp storeChar

checkUppercase:
    ; Check if character is uppercase 'A' to 'Z'
    cmp al, 'A'
    jl checkNumber                      ; check Nums
    cmp al, 'Z'
    jg checkNumber                          ; No wrap needed if within 'A'-'Z'


upperCaseDecryption:                                                    ;Uppercase decryption ; (shift backward by subtracting shiftValue)
    sub al, bl                             ; Reverse the shift by subtracting shiftValue
    cmp al, 'A'                            ; Check if it goes below 'A'
    jge storeChar                          ; If still within uppercase, skip wraparound
    add al, 26                             ; Wrap around to 'Z' if it goes below 'A'
    jmp storeChar

checkNumber:
    cmp al,'0'
    jl skipDecryption
    cmp al,'9'
    jg skipDecryption

numberDecryption:
    sub al,bl
    cmp al, '0'
    jge storeChar
    add al, 10              ;Integer wrap around

storeChar:
    mov byte ptr [esi + ecx], al           ; Store the shifted character back into inpBuffer

nextDecrypt:
    inc ecx                                ; Move to the next character
    jmp _decryptString                     ; Continue looping

skipDecryption:
    ; Non-alphabetic/Integer characters are skipped
    jmp nextDecrypt

exitDecrypt:
    mov byte ptr [esi + ecx], 0            ; Null-terminate the string at the end   ;KEY TO RUN
    pop esi
    ret                                    ; Return to the caller

decryptString ENDP

END




     