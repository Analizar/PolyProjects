.386P
.model flat
extern readline: near
.data
    shiftValue db ?                          ; Caesar cipher shift value 

.code

; Encrypt the message using Caesar cipher (shift by ?)
encryptString PROC near
    push esi
    push ebx                      ;  shift value

    pop ebx                         ; Pop shift value from the stack
    ;value in bl
   
    mov ecx, 0              ; ECX as the index to traverse the string

_encryptString:
    mov al, byte ptr [esi + ecx]  ; Load current character from esi
    cmp al, 0                     ; Check if null terminator (end of string)
    je exit                       ; If so, exit


    ; Check if character is lowercase 'a' to 'z'
    cmp al, 'a'
    jl checkUppercase             ; check uppercase if < 'a'
    cmp al, 'z'
    jg checkUppercase             ; Jump to uppercase check if > 'z'
    
    ; Process lowercase encryption
lowercaseEncryption:
    add al, bl                    ; Shift the character
    cmp al, 'z'
    jle storeChar                 ; No wrap needed if <= 'z'
    sub al, 26                    ; Wrap around for lowercase
    jmp storeChar

checkUppercase:
    ; Check if character is uppercase 'A' to 'Z'
    cmp al, 'A'
    jl checkNumber             ; Skip if character is less than 'A'
    cmp al, 'Z'
    jg checkNumber             ; Skip if character is greater than 'Z'

    ; Process uppercase encryption
uppercaseEncryption:
    add al, bl                    ; Shift the character
    cmp al, 'Z'
    jle storeChar                 ; No wrap needed if <= 'Z'
    sub al, 26                    ; Wrap around for uppercase; 26 = size of set
    jmp storeChar
checkNumber:
    cmp al, '0'
    jl skipEncryption
    cmp al, '9'
    jg skipEncryption

numberEncryption:
    add al, bl
    cmp al,'9'
    jle storeChar
    sub al, 10

storeChar:
    mov byte ptr [esi + ecx], al  ; Store the shifted character

nextChar:
    inc ecx                       ; Move to the next character
    jmp _encryptString            ; Continue loop

skipEncryption:
    ; If not alphanumeric, move to the next character without shifting
    jmp nextChar

exit:
    mov byte ptr [esi + ecx], 0   ; Null-terminate the string
    pop esi
    ret                           ; Return to caller

encryptString ENDP
END
