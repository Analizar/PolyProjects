.386P
.model flat
;INCLUDE kernel32.inc
;extern CreateFileA: near
;extern WriteFile: near
;extern CloseHandle: near
extern writeline: near
extern charCount: near
.data
fileHandle DWORD ?
bytesWritten DWORD ?

fileName db "encrypted_output.txt", 0 ; Null-terminated file name
dataSize DWORD 0 ; Placeholder for data size
data DWORD ? ; Pointer to the encrypted string


errorString db "File Not Created", 0 




;;NOTE THIS FILE WIL ONLY WORK IF MASM PROPERLY LINKED WITH KERNAL #@ LIBRARY FUNCTIONS CURRENTLY UNUSED IN BASE CODE
;uses edi/ fileName/ data:/ dataSize/ cleans stack
;CURRENTLY JUST A TEMPLATE FOR ME
.code
writeToFile PROC near
    ;push esi
    ;call charCount
    ;mov dataSize, eax

    ;mov data, esi   ;encryted string to data



    ;push 0                   ; Attributes
    ;push 0                   ; Share mode
    ;push 2                   ; Create mode (CREATE_ALWAYS)
    ;push 0                   ; Security attributes
    ;push 1                   ; Access mode (GENERIC_WRITE)
    ;push offset fileName            ; File name address(offset)
    ;call CreateFileA
    ;mov fileHandle, eax

    ;cmp fileHandle, -1
    ;je writeToFile_Error    ; Jump to error handling if CreateFileA failed


    ; Write to file
    ;push 0                   ; Overlapped
    ;push offset bytesWritten ; Bytes written
    ;push dataSize            ; Size to write
    ;push data                ; Data buffer
    ;push fileHandle          ; File handle
    ;call WriteFile

    ; Close file
    ;push fileHandle
    ;call CloseHandle

    ;pop esi
    ;ret

    ;writeToFile_Error:
                                    ; Handle error
    ;push offset errorString
    ;call charCount                
    ;push eax
    ;push offset errorString
    ;call writeline



    ;pop esi                 ; Restore esi
    ret
writeToFile ENDP
END