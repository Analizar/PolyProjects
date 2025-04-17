; MASM caesaer Encryption/Decryptiopn with console (WINDOWS)
; Aj Bowman
; 2024/20/10
; user input to encryption to File/ Decryption for ceaser cipher with proper shift value
;       
;
;Libraries Used 
;           kernel32.lib //\\ Windows API
;INCLUDE kernel32.inc   ;CURRENTLY UNUSED DUE TO LINK ISSUE IF LINKED on system workspace // FILE_IO should WORK


;;CHECK WRAPAROUND WITH lower case z (inproper ASCII)
.386P
.model flat


extern initialize_console: near
extern   _ExitProcess@4: near



extern encryptString: near
extern decryptString: near

extern   readline: near

extern writeNumber: near
extern writeToFile: near
extern writeline: near

extern charCount: near


.data
menuPrompt db "Choose an option: ", 10, "1. Encrypt", 10, "2. Decrypt", 10, 0
encryptPrompt   db "Encrypted Message: ", 0
decryptPrompt   db "Decrypted Message: ", 0



invalidOption db "Invalid option, please try again.", 10, 0
choicePrompt db "Enter your choice (1 or 2): ", 0
encryptMessagePrompt db "Enter the message to encrypt: ", 0
decryptMessagePrompt db "Enter the message to decrypt: ", 0

numCharsToRead dword 1024            ; Number of characters to read
inpBuffer db 1024 dup(0)             ; Buffer for user input

choice db 0                          ; Stores the ENCRY/DECRY (1 or 2)

keyPrompt db "Enter the shift key (1-25): ", 0
invalidKeyPrompt db "Invalid key. Please enter a value between 1 and 25.", 10, 0
shiftValue db 0                          ; User shift value
.code
main PROC
    ; Display the menu

        ; Initialize the console
    call initialize_console   


askForKey:
    ; Display the key prompt
    push offset keyPrompt
    call charCount
    push eax
    push offset keyPrompt
    call writeline

    ; Read the key from the user
    call readline
    mov esi, eax                         ; ESI points to the input buffer

    ; Convert string input to integer (ASCII '0' -> numeric 0)
    xor eax, eax                         ; Clear EAX
    xor ebx, ebx                         ; EBX will hold the numeric key
parseKey:
    mov al, byte ptr [esi + ebx]         ; Load a character
    cmp al, 0                            ; Check for null terminator
    je validateKey                       ; End of string, validate key
    sub al, '0'                          ; Convert ASCII to number
    add ebx, eax                         ; Accumulate the number
    shl ebx, 4                           ; Shift for next digit
    inc esi                              ; Move to next character
    jmp parseKey                         ; Repeat

validateKey:
    shr ebx, 4                           ; Correct EBX after last unnecessary shift ;shiftRight 4
    mov eax,ebx
    cmp eax, 1
    jl invalidKey                        ; Key < 1
    cmp eax, 25
    jg invalidKey                        ; Key > 25

    ; Save the valid key
    mov byte ptr [shiftValue], bl        ; Store the key in shiftValue
    jmp showMenu                             ; Go to the main menu

invalidKey:
    ; Display invalid key message
    push offset invalidKeyPrompt
    call charCount
    push eax
    push offset invalidKeyPrompt
    call writeline
    jmp askForKey                        ; Retry asking for a valid key




showMenu:
    push offset menuPrompt
    call charCount
    push eax
    push offset menuPrompt
    call writeline

    ; Prompt for user choice
    push offset choicePrompt
    call charCount
    push eax
    push offset choicePrompt
    call writeline

    ; Read the user's choice
    call readline
    mov esi, eax                     ; ESI points to the buffer containing the choice
    mov al, byte ptr [esi]           ; Get the first character
    sub al, '0'                      ; Convert ASCII digit to integer (1 = Encrypt, 2 = Decrypt)
    mov byte ptr choice, al          ; Store the numeric value in 'choice'

    ; check choice
    cmp choice, 1
    je doEncrypt                     ; If 1, go to encrypt
    cmp choice, 2
    je doDecrypt                     ; If 2, go to decrypt

    ; Invalid choice handling
    push offset invalidOption
    call charCount
    push eax
    push offset invalidOption
    call writeline
    jmp showMenu                     ; Redisplay the menu

doEncrypt:
    ; Prompt for the message to encrypt
    push offset encryptMessagePrompt
    call charCount
    push eax
    push offset encryptMessagePrompt
    call writeline

    ; Read the input to encrypt
    call readline
    mov esi, eax                     ; ESI points to the buffer containing the message

    movzx ebx, byte ptr [shiftValue]    ; Load shift value into EBX
    push ebx                            ; Push the entire EBX register, not just BL 



    call encryptString  ;ENCRY

    ; Display the encrypted message
    push offset encryptPrompt
    call charCount
    push eax
    push offset encryptPrompt
    call writeline

    push numCharsToRead
    push esi                    ;ENCRYPTED ME$SSAGE
    call writeline
    jmp programEnd                   ; End the program

doDecrypt:
    ; Prompt for the message to decrypt
    push offset decryptMessagePrompt
    call charCount
    push eax
    push offset decryptMessagePrompt
    call writeline

    ; Read the input to decrypt
    call readline
    mov esi, eax                     ; ESI points to the buffer containing the encrypted message

   movzx ebx, byte ptr [shiftValue]    ; Load shift value into EBX

    push ebx                        ;SHIFT VALUE Param

    ; Call the decryption function
    call decryptString

    ; Display the decrypted message
    push offset decryptPrompt
    call charCount
    push eax
    push offset decryptPrompt
    call writeline

    push numCharsToRead
    push esi
    call writeline
    jmp programEnd                   ; End the program

programEnd:
    ; Exit the program
    push 3                           ; Exit code
    call _ExitProcess@4
main ENDP
END
