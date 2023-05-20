[org 0x0100]

jmp start
messageScore: db 'Score : '
messageGameOver: db '--- Game Over ---'
score : dw 0
flagGround : db 0
flagJump : db 0
flagDown : db 0
flagGameOver : db 0
dinosourPosition: dw 1930 ;1920->col_10 && row_12 (mid)
h1 : dw 2078
h2 : dw 2050
h3 : dw 2002

clrscrAndSet:
push es
push ax
push cx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x0720 ; space char in normal attribute
mov cx, 2000 ; number of screen locations
cld ; auto increment mode
rep stosw ; clear the whole screen

mov di , word[cs:dinosourPosition]
mov word[es:di], 0x07D7

mov si , di
sub si , 160; 1770 = 1930 - 160
mov word[es:si], 0x079D

mov si , di
add si , 158;1930 + 160 - 2
mov word[es:si], 0x0721

mov si , di
add si, 162;1930 + 160 + 2
mov word[es:si], 0x0721

pop di
pop cx
pop ax
pop es
ret

; subroutine to print a number
; takes the number to be printed as its parameter
printnum:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit:
mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 180 ; point di to 1st row , 10th column
nextpos:
pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2

;subroutine to print a string
; takes the x position, y position, attribute, address of string and
; its length as parameters
printstr: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+10] ; multiply with y position
add ax, [bp+12] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
mov si, [bp+6] ; point si to string
mov cx, [bp+4] ; load length of string in cx
mov ah, [bp+8] ; load attribute in ah
cld ; auto increment mode
nextchar: lodsb ; load next char in al
stosw ; print char/attribute pair
loop nextchar ; repeat for the whole string
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 10

runGame:

push es
push ax
push bx
push cx
push dx
push di
push si

cmp byte[cs:flagGameOver] , 1
je near exit

mov ax , 0x0b800
mov es , ax



;-------Ground_Action-------
cmp byte[cs:flagGround] , 0
jne position2

mov di , 2242 ;row_14 (mid+2)
growndLineEraseP1:
mov word[es:di], 0x0720
add di , 4
cmp di , 2402
jne growndLineEraseP1

mov di , 2240 ;row_14 (mid+2)
growndLineDrawP1:
mov word[es:di], 0x075F
add di , 4
cmp di , 2400
jne growndLineDrawP1

mov byte[cs:flagGround] , 1
jmp skipGP2

;call delay
position2:

mov di , 2240 ;row_14 (mid+2)
growndLineEraseP2:
mov word[es:di], 0x0720
add di , 4
cmp di , 2400
jne growndLineEraseP2

mov di , 2242 ;row_14 (mid+2)
growndLineDrawP2:
mov word[es:di], 0x075F
add di , 4
cmp di , 2402
jne growndLineDrawP2

mov byte[cs:flagGround] , 0

skipGP2:

;-------Hurdles_Action-------

;   --- h1 --- 
cmp word[cs:h1] , 1920
je resetH1 
sub word[cs:h1] , 2
jmp skipResetH1

resetH1:
mov di, 1764
mov word[es:di],  0x0720
mov di, 1760
mov word[es:di],  0x0720
mov word[cs:h1] ,2078

skipResetH1:
mov di , word[cs:h1] ;h1 center
mov word[es:di] , 0x07B2

mov si , di
add si , 160
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
sub si , 160
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
add si , 4
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
add si , 164
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
sub si , 156
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

add di , 2
mov word[es:di],  0x0720



;   --- h2 --- 
cmp word[cs:h2] , 1920
je resetH2 
sub word[cs:h2] , 2
jmp skipResetH2

resetH2:
mov di, 1764
mov word[es:di],  0x0720
mov di, 1760
mov word[es:di],  0x0720
mov word[cs:h2] ,2078

skipResetH2:
mov di , word[cs:h2] ;h2 center
mov word[es:di] , 0x07B2

mov si , di
add si , 160
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
sub si , 160
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

add di , 2
mov word[es:di],  0x0720



;   --- h3 --- 
cmp word[cs:h3] , 1920
je resetH3
sub word[cs:h3] , 2
jmp skipResetH3

resetH3:
mov di, 1764
mov word[es:di],  0x0720
mov di, 1760
mov word[es:di],  0x0720
mov word[cs:h3] , 2078

skipResetH3:
mov di , word[cs:h3] ;h3 center
mov word[es:di] , 0x07B2

mov si , di
add si , 160
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
add si , 4
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
add si , 164
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720

mov si , di
sub si , 156
mov word[es:si] , 0x07B2
add si , 2
mov word[es:si],  0x0720


add di , 2
mov word[es:di],  0x0720


;-------Dinosaur_Action-------

cmp byte[cs:flagJump] , 1
je jump

;-------Game_Over_Check-------

mov di , word[cs:dinosourPosition]
cmp word[es:di] , 0x07D7
jne near gameOver

mov si , di
sub si , 160; 1770 = 1930 - 160
cmp word[es:si], 0x079D
jne near gameOver

mov si , di
add si , 158;1930 + 160 - 2
cmp word[es:si], 0x0721
jne near gameOver

mov si , di
add si, 162;1930 + 160 + 2
cmp word[es:si], 0x0721
jne near gameOver


;--------------------------------

mov di , word[cs:dinosourPosition]
mov word[es:di], 0x07D7

mov si , di
sub si , 160; 1770 = 1930 - 160
mov word[es:si], 0x079D

mov si , di
add si , 158;1930 + 160 - 2
mov word[es:si], 0x0721

mov si , di
add si, 162;1930 + 160 + 2
mov word[es:si], 0x0721

jmp endJump

;       ---jump---
jump:

cmp byte[cs:flagDown] , 1
je movDown

;movUp
mov di , word[cs:dinosourPosition]
mov word[es:di], 0x07D7

mov si , di
sub si , 160; 1770 = 1930 - 160
mov word[es:si], 0x079D

mov si , di
add si , 158;1930 + 160 - 2
mov word[es:si], 0x0721
add si , 160
mov word[es:si], 0x0720

mov si , di
add si, 162;1930 + 160 + 2
mov word[es:si], 0x0721
add si , 160
mov word[es:si], 0x0720


add di , 160
mov word[es:di], 0x0720

sub word[cs:dinosourPosition] , 160
cmp word[cs:dinosourPosition] ,970;1130
jne endJump
setDownflag:
mov byte[cs:flagDown] , 1

jmp endJump

movDown:
mov di , word[cs:dinosourPosition]
mov word[es:di], 0x07D7

mov si , di
sub si , 160; 1770 = 1930 - 160
mov word[es:si], 0x079D
sub si , 160
mov word[es:si], 0x0720

mov si , di
add si , 158;1930 + 160 - 2
mov word[es:si], 0x0721
sub si , 160
mov word[es:si], 0x0720

mov si , di
add si, 162;1930 + 160 + 2
mov word[es:si], 0x0721
sub si , 160
mov word[es:si], 0x0720

add word[cs:dinosourPosition] , 160
cmp word[cs:dinosourPosition] , 2090
jne endJump
resetDownflag:
mov byte[cs:flagDown] , 0
mov byte[cs:flagJump] , 0
mov word[cs:dinosourPosition] , 1930

endJump:
jmp skipGameOver

gameOver:
mov byte[cs:flagGameOver] , 1

mov ax, 30
push ax ; push x position
mov ax, 20
push ax ; push y position
mov ax, 1 ; blue on black attribute
push ax ; push attribute
mov ax, messageGameOver
push ax ; push address of message
push 17 ; push message length
call printstr ; call the printstr subroutine

skipGameOver:

inc word [cs:score]; increment score count
push word [cs:score]
call printnum ; print score count

exit:

pop si
pop di
pop dx
pop cx
pop bx
pop ax
pop es

mov al, 0x20
out 0x20, al ; end of interrupt
iret ; return from interrupt

inputSpace:
push ax
in al , 0x60
cmp al , 57
jne skip
mov word[cs:flagJump] , 1
skip:
mov al, 0x20
out 0x20, al ; end of interrupt
pop ax
iret ; return from interrupt

start: 
call clrscrAndSet
;   ---print score text---
mov ah, 0x13 ; service 13 - print string
mov al, 0 ; subservice 01 – update cursor
mov bh, 0 ; output on page 0
mov bl, 7 ; normal attrib
mov dx, 0x0102 ; row 10 column 3
mov cx, 7 ; length of string
push cs
pop es ; segment of string
mov bp, messageScore ; offset of string
int 0x10 ; call BIOS video service

xor ax, ax
mov es, ax ; point es to IVT base
cli ; disable interrupts
mov word [es:8*4], runGame; store offset at n*4
mov [es:8*4+2], cs ; store segment at n*4+2
mov word [es:9*4], inputSpace; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
sti ; enable interrupts
loop1: jmp loop1
mov ax, 0x400 ; terminate program
int 0x21