; Program takes two hex-numbers and compute sum
org 100h
     
.data     
N EQU 4
input_message db "Please enter hex-number with upper-case letters (it will read only first 4 symbols):", 0Dh,0Ah, 24h
wrong_input_message db "Wrong input!", 0Dh,0Ah, 24h
len dw ?
.code

main:
    ;call read_hex
    ;mov bx, ax
    ;call read_hex
    ;add ax, bx
    mov ax, 0ABDh
    call print_hex
    ret

print_hex:
   push cx
   push dx
   push bx
   mov cx, 0
   mov bx, 10h
   mov dx, 0
.more_digit:
   div bx
   cmp dx, 9
   ja .let:
   add dx, '0'
   jmp .save
.let:
   add dx, 37h
.save:
   push dx
   mov dx, 0
   inc cx
   cmp ax, 0
   jne .more_digit
   
   mov ah, 09h
   int 21h
   
   pop bx
   pop dx
   pop cx
   ret
    
read_hex:
   ;read 4 input numbers
   push bp ; save bp input
   push bx ; save bx input 
   push dx ; save dx input
   ; write message for input 
   mov ah, 09h
   mov dx, offset input_message
   int 21h

   mov cx, 0
   mov ah, 1
   
.rd:
   int 21h
   mov bl, al
   cmp al, 0xD ; press enter?
   je .done
   cmp al, '9'
   jle .digit
   cmp al, 'F'
   ja .wrong
   cmp al, 'A'
   jb .wrong
   
.digit:
   push bx
   inc cx
   cmp cx, N ; max length?
   ja .wrong 
   jmp .rd

   .wrong:
   mov ah, 09h
   mov dx, offset wrong_input_message
   int 21h
   mov ax, 1
   mov bx, 0
   int 80h
   
.done:
    mov len, cx
    mov ax, 0
    mov bp, sp
    add bp, cx
    add bp, cx
    .l:
    sub bp, 2
    mov bx, 16
    mul bx
    mov bl, [bp]
    cmp bl, '9'
    ja .letter:
    sub bx, '0'
.letter:
    sub bx, 'A'
    add bx, 10
    add ax, bx         
    loop .l

    mov cx, len  
    add sp, cx
    add sp, cx
    pop dx
    pop bx
    pop bp
    ret
