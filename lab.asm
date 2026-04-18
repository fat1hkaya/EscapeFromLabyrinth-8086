data segment
    map1 db "map1.txt",0
    map2 db "map2.txt",0
    map3 db "map3.txt",0
    handle dw ?
    real_address_filename dw ?
    address_filename dw ?
    temp_char db ?
    tittle db "High Scores", '$'
    check_n db ?
    check_n_copy db ?
    positive_n db ?
    Number dw ?
    file_data 440 dup("$")
    address_file_data dw ?
    finished db "FINISH",10,13,"Press any key to exit...",'$'
    data1 db 60d
    data2 db 60d
    initial_row db ?
    initial_column db ?
    second_copy dw 1 dup('00')
    time_p db "Time past = "
    min db '0',':'
    second dw 1 dup(?)," sec",'$'
    score dw 1 dup(?),'$'
    score_p db "Score = "
    sign db ?
    score2 dw 1 dup(?)
    score3 dw 1 dup(?)," pts",'$'
    l1 db " New Game ",'$'
    l2 db " Map Selection ",'$'
    l3 db " Hardness ",'$'
    l4 db " High Scores ",'$'
    l5 db " Credits ",'$'
    credits_menu db "Fatih Kaya",10,13,"1111111111",10,13,"(C)MARMARA UNI",'$'
    map_menu db " 1 => Map 1 ",10,13," 2 => Map 2 ",10,13," 3 => Map 3 ",10,13," Enter the Map Number...",'$'
    hardness_menu db " E => Easy (15 prizes) ",10,13," M => Medium (10 prizes) ",10,13," H => Hard (5 prizes) ",10,13," Enter the Hardness Letter...",'$'
    blue db 12
    white db 15
    initial_x db 0
    initial_y db 0
    temp_y db ?
    temp_y_copy db ?
    easy db 0Fh
    mediumm db 0Ah
    hardd db 05h
    load db "LOADING. ",'$'
    error_str db "Invalid Input.Please Provide Valid Input!",'$'
    scorefile db "scorefl.txt",0
    score_data db 50 dup('$')
    N1 db 6 dup(?)
    N2 db 6 dup(?)
    N3 db 6 dup(?)
    N4 db 6 dup(?)
    N5 db 6 dup(?)
    A1 db 6 dup('$')
    A2 db 6 dup('$')
    A3 db 6 dup('$')
    A4 db 6 dup('$')
    A5 db 6 dup('$')
    A6 db 6 dup('$')
    A7 db 6 dup('$')
    A8 db 6 dup('$')
    A9 db 6 dup('$')
    A10 db 6 dup('$'),'$','f'
    score_table db "1................................",10,13,10,13,"2................................",10,13,10,13,"3................................",10,13,10,13,"4................................",10,13,10,13,"5................................",10,13,10,13,'$'
ends

function1 macro N
    local lp
    lea DI,N
    lp:
    mov al,[SI]
    mov [DI],al
    inc SI
    inc DI
    cmp [SI],' '
    jne lp
    mov al,[SI]
    mov [DI],al
    inc SI
endm

check macro N
    mov ax,0
    mov al,N
    mov bl,al
    dec bl
    mul bl
    mov bl,2
    div bl
    mov positive_n,al
endm

ranking macro N, number
    local bck4, bck5, gr1
    mov SI, N
bck4:
    inc SI
    mov DI, SI
    add DI, number
    mov al, [DI]
    cmp [SI], al
    je bck4
    cmp [SI], al
    ja gr1
    mov SI, N
    inc SI
    mov DI, SI
    add DI, number
bck5:
    mov al, [DI]
    xchg [SI], al
    mov [DI], al
    inc SI
    inc DI
    cmp [SI], ' '
    jne bck5
gr1:
endm

ranking_neg macro N, number
    local bck4, bck5, gr1
    mov SI, N
bck4:
    inc SI
    mov DI, SI
    add DI, number
    mov al, [DI]
    cmp [SI], al
    je bck4
    cmp [SI], al
    jb gr1
    mov SI, N
    inc SI
    mov DI, SI
    add DI, number
bck5:
    mov al, [DI]
    xchg [SI], al
    mov [DI], al
    inc SI
    inc DI
    cmp [SI], ' '
    jne bck5
gr1:
endm

menu macro str, colorb, colorw
    local wrt, cnt, fnsh
    mov dl, initial_x
    inc dh
    mov bl, colorw
    cmp dh, temp_y
    jne cnt
    mov bl, colorb
cnt:
    lea SI, str
    mov cx, 0
wrt:
    cmp [SI], '$'
    je fnsh
    inc dl
    mov ah, 02
    mov bh, 0
    int 10h
    mov ah, 09h
    mov al, [SI]
    mov bh, 0
    mov cx, 1
    int 10h
    inc SI
    jmp wrt
fnsh:
endm

read macro filename
    mov ah, 3Dh
    mov dx, filename
    mov al, 00h
    int 21h
    mov handle, ax
    mov ah, 3Fh
    mov bx, handle
    mov cx, 01B7h
    lea dx, file_data
    int 21h
    mov ah, 3Eh
    mov bx, handle
    int 21h
endm

clear_screen macro
    mov ax, 03h
    int 10h
    call clear_buffer
endm

hard macro mapname, number
    local lp, lp2, bck, ct, fnshl, wrtl
    mov DI, mapname
    read DI
    lea SI, file_data
    dec SI
lp:
    inc SI
    cmp SI, address_file_data
    je lp2
    cmp [SI], 'U'
    jne lp
    mov [SI], 'X'
    jmp lp
lp2:
    mov ah, 3ch
    mov dx, mapname
    mov cx, 00h
    int 21h
    mov handle, ax
    mov ah, 40h
    mov bx, handle
    mov cx, 01B7h
    lea dx, file_data
    int 21h
    mov ah, 3Eh
    mov bx, handle
    int 21h
    mov DI, mapname
    read DI
    mov bl, 0
bck:
    mov ah, 2ch
    int 21h
    mov dh, dl
    xor ax, ax
    xchg dx, ax
    mov cx, 393d
    div cx
    add dx, 59d
    mov SI, dx
    cmp [SI], 'X'
    jne bck
    cmp [SI-1], 0Ah
    je bck
    cmp [SI+1], 0Dh
    je bck
    cmp [SI-1], 'X'
    jne ct
    cmp [SI+1], 'X'
    jne ct
    cmp [SI-22], 'X'
    jne ct
    cmp [SI+22], 'X'
    jne ct
    jmp bck
ct:
    mov [SI], 'U'
    inc bl
    cmp bl, number
    jne bck
    mov ah, 3ch
    mov dx, mapname
    mov cx, 00h
    int 21h
    mov handle, ax
    mov ah, 40h
    mov bx, handle
    mov cx, 01B6h
    lea dx, file_data
    int 21h
    mov ah, 3Eh
    mov bx, handle
    int 21h
endm

code segment
start:
    mov ax, @data
    mov ds, ax
    lea ax, sign
    lea bx, file_data
    mov address_file_data, bx
    add address_file_data, 440d
    mov real_address_filename, offset map1
    mov ah, 0
    mov al, 12h
    int 10h
    call arrow_menu
    clear_screen
    mov ah, 0
    mov al, 12h
    int 10h
    read real_address_filename
    mov ah, 09h
    lea dx, file_data
    int 21h
    call starting_point
    mov ah, 2ch
    int 21h
    sub data2, dh
    call game
    hlt        
    
game proc
    mov dl, initial_column
    mov dh, initial_row
    push dx
again:
    call clear_buffer
    mov DI, SI
    pop dx
    push dx
    mov bp, dx
tkr:
    call time
    mov ah, 1
    int 16h
    jz tkr
    pop dx
    cmp al, 1bh
    je esc_key
    cmp al, 0
    jne error
    push ax
    mov ah, 02h
    mov bh, 0
    int 10h
    mov dl, 0
    int 21h
    mov dx, bp
    pop ax
    mov cl, ah
    sub score, 5d
    cmp cl, 48h
    je up
    cmp cl, 50h
    je down
    cmp cl, 4Bh
    je left
    cmp cl, 4Dh
    je right
up:
    sub SI, 22d
    cmp [SI], 'X'
    je error
    cmp SI, address_file_data
    jnb error
    dec dh
    cmp [SI], 'U'
    je scoring
    cmp [SI], 'E'
    je finish
    jmp final
down:
    add SI, 22d
    cmp [SI], 'X'
    je error
    cmp SI, address_file_data
    jnb error
    inc dh
    cmp [SI], 'U'
    je scoring
    cmp [SI], 'E'
    je finish
    jmp final
left:
    dec SI
    cmp [SI], 'X'
    je error
    cmp SI, address_file_data
    jnb error
    dec dl
    cmp [SI], 'U'
    je scoring
    cmp [SI], 'E'
    je finish
    jmp final
right:
    inc SI
    cmp [SI], 'X'
    je error
    cmp SI, address_file_data
    jnb error
    inc dl
    cmp [SI], 'U'
    je scoring
    cmp [SI], 'E'
    je finish
    jmp final
scoring:
    mov [SI], ' '
    add score, 50d
final:
    mov ah, 02
    mov bh, 0
    int 10h
    push dx
    mov bp, dx
    mov ah, 09h
    mov al, 'A'
    mov bh, 0
    mov bl, 3
    mov cx, 1
    int 10h
    jmp again
error:
    push dx
    mov SI, DI
    mov ah, 02
    int 10h
    mov ah, 09h
    mov al, 'A'
    mov bh, 0
    mov bl, 3
    mov cx, 1
    int 10h
    jmp again
finish:
    mov ah, 3dh
    mov al, 02
    lea dx, scorefile
    int 21h
    mov handle, ax
    mov ah, 3fh
    mov bx, handle
    mov cx, 30d
    lea dx, score_data
    int 21h
    lea SI, score_data
    function1 N1
    function1 N2
    function1 N3
    function1 N4
    function1 N5
    call function5
    lea SI, N5
    lea DI, sign
    mov al, [DI]
    cmp [SI], al
    ja change
    cmp [SI], al
    jb not_change
    cmp [SI], '-'
    je nege
pos:
    dec SI
    dec DI
nxt_p:
    inc SI
    inc DI
    mov al, [DI]
    cmp [SI], al
    je nxt_p
    cmp [SI], al
    ja not_change
    jmp change
nege:
    dec SI
    dec DI
nxt:
    inc SI
    inc DI
    mov al, [DI]
    cmp [SI], al
    je nxt
    cmp [SI], al
    jb not_change
change:
    mov al, [DI]
    xchg [SI], al
    mov [DI], al
    inc SI
    inc DI
    cmp [SI], ' '
    jne change
not_change:
    call function5
    mov ah, 3dh
    mov al, 02
    lea dx, scorefile
    int 21h
    mov handle, ax
    mov ah, 40h
    mov bx, handle
    mov cx, 30d
    lea dx, N1
    int 21h
    clear_screen
    mov ah, 09h
    lea dx, finished
    int 21h
    mov ah, 0
    int 16h
esc_key:
    clear_screen
    mov ax, 4c00h
    int 21h
    ret
game endp

starting_point proc
    xor dx, dx
    lea SI, file_data
back:
    cmp [SI], 'U'
    jne go
    mov dl, initial_column
    mov dh, initial_row
    mov ah, 02
    mov bh, 0
    int 10h
    mov ah, 09h
    mov al, [SI]
    mov bh, 0
    mov cx, 1
    mov bl, 5
    int 10h
go:
    cmp [SI], 0Dh
    je inc_row
    cmp [SI], 'A'
    jne inc_cloumn
    ret
inc_row:
    inc initial_row
    add SI, 2
    mov initial_column, 0
    jmp back
inc_cloumn:
    inc initial_column
    inc SI
    jmp back
starting_point endp

clear_buffer proc
    mov ax, 0c00h
    int 21h
    ret
clear_buffer endp

time proc
    mov ah, 2ch
    int 21h
    mov al, dh
    add al, data2
    mov ah, 0
    div data1
    xchg ah, al
    aam
    xchg ah, al
    add ax, 3030h
    mov second, ax
    cmp ax, second_copy
    jne check_min
ct1:
    mov dl, 10
    mov dh, 24
    mov bh, 0
    mov ah, 02h
    int 10h
    mov ah, 09h
    lea dx, time_p
    int 21h
scored:
    mov dl, 10
    mov dh, 25
    mov bh, 0
    mov ah, 02h
    int 10h
    mov ax, 0
    add ax, score
    jns score_print
    sub ax, 1
    xor ax, 0ffffh
    push ax
    mov sign, '-'
    pop ax
wrt:
    mov cl, 10d
    div cl
    xchg ah, al
    cmp ah, 9h
    ja grt
    xchg ah, al
    add ax, 3030h
    mov score2, 0h
    mov score3, ax
ct:
    mov ah, 09h
    lea dx, score_p
    int 21h
    ret
score_print:
    push ax
    mov sign, '+'
    pop ax
    jmp wrt
grt:
    mov bh, al
    mov al, ah
    mov ah, 0
    aam
    ror al, 4
    add bh, al
    mov al, ah
    rol ah, 4
    and ax, 0f0fh
    add ax, 3030h
    xchg ah, al
    mov score2, ax
    mov al, bh
    mov ah, al
    rol ah, 4
    and ax, 0f0fh
    add ax, 3030h
    xchg ah, al
    mov score3, ax
    jmp ct
check_min:
    mov ax, second
    mov second_copy, ax
    cmp ax, 3030h
    jne ct1
    inc min
    jmp ct1
time endp

wrt_menu proc
    mov al, temp_y
    mov temp_y_copy, al
    mov dh, initial_y
    menu l1, blue, white
    menu l2, blue, white
    menu l3, blue, white
    menu l4, blue, white
    menu l5, blue, white
    ret
wrt_menu endp

arrow_menu proc
start_m:
    mov al, initial_y
    inc al
    mov temp_y, al
    mov temp_y_copy, al
    mov ah, 0
    mov al, 12h
    int 10h
    call wrt_menu
arrow_m:
    mov al, temp_y_copy
    mov temp_y, al
    mov ah, 0
    int 16h
    cmp al, 1bh
    je esc_key_m
    cmp ah, 1Ch
    je selection
    cmp al, 0
    jne arrow_m
    cmp ah, 48h
    je up_m
    cmp ah, 50h
    je down_m
    jmp arrow_m
selection:
    cmp temp_y, 1
    je new_game_ret
    cmp temp_y, 2
    je map_selection
    cmp temp_y, 3
    je hardness
    cmp temp_y, 4
    je high_scores
    cmp temp_y, 5
    je credits_
new_game_ret:
    ret
high_scores:
    mov ah, 3dh
    mov al, 02
    lea dx, scorefile
    int 21h
    mov handle, ax
    mov ah, 3fh
    mov bx, handle
    mov cx, 30d
    lea dx, score_data
    int 21h
    lea SI, score_data
    function1 N1
    function1 N2
    function1 N3
    function1 N4
    function1 N5
    call function5
    clear_screen
    mov dx, 0200h
    mov ah, 02h
    mov bh, 0
    int 10h
    mov ah, 09h
    lea dx, score_table
    int 21h
    lea SI, A1
    mov dx, 0223h
bck_chk:
    cmp [SI], 'f'
    je fns_scores
    cmp [SI], '$'
    je inc_data
    cmp [SI], ' '
    je inc_dh
ct_scores:
    inc dl
    mov ah, 02
    mov bh, 0
    int 10h
    mov ah, 09
    mov al, [SI]
    mov bh, 0
    mov bl, 10
    mov cx, 1
    int 10h
inc_data:
    inc SI
    jmp bck_chk
inc_dh:
    add dh, 2
    mov dl, 22h
    jmp ct_scores
fns_scores:
    mov ah, 0
    int 16h
    jmp start_m
hardness:
    mov ax, 03h
    int 10h
    mov ah, 09h
    lea dx, hardness_menu
    int 21h
    mov ah, 01
    int 21h
    mov temp_char, al
    mov ah, 0
    int 16h
    cmp [SI], 'e'
    je easyc
    cmp [SI], 'E'
    je easyc
    cmp [SI], 'm'
    je mediumc
    cmp [SI], 'M'
    je mediumc
    cmp [SI], 'h'
    je hardc
    cmp [SI], 'H'
    je hardc
    jmp start_m
easyc:
    mov address_filename, offset map1
    hard address_filename, easy
    jmp start_m
mediumc:
    mov address_filename, offset map1
    hard address_filename, mediumm
    jmp start_m
hardc:
    mov address_filename, offset map1
    hard address_filename, hardd
    jmp start_m
map_selection:
    mov ax, 03h
    int 10h
    mov ah, 09h
    lea dx, map_menu
    int 21h
    mov ah, 01
    int 21h
    cmp al, '1'
    je m1
    cmp al, '2'
    je m2
    cmp al, '3'
    je m3
    jmp start_m
m1:
    mov real_address_filename, offset map1
    jmp start_m
m2:
    mov real_address_filename, offset map2
    jmp start_m
m3:
    mov real_address_filename, offset map3
    jmp start_m
credits_:
    mov ax, 03h
    int 10h
    mov ah, 09h
    lea dx, credits_menu
    int 21h
    mov ah, 0
    int 16h
    jmp start_m
down_m:
    inc temp_y
    cmp temp_y, 5
    ja arrow_m
    call wrt_menu
    jmp arrow_m
up_m:
    dec temp_y
    cmp temp_y, 1
    jb arrow_m
    call wrt_menu
    jmp arrow_m
esc_key_m:
    mov ax, 4c00h
    int 21h
arrow_menu endp

error_message proc
    mov ax, 03h
    int 10h
    lea SI, error_str
    mov dx, 0515h
wrtf:
    cmp [SI], '$'
    je fnshf
    inc dl
    mov ah, 02
    int 10h
    mov ah, 09h
    mov al, [SI]
    mov bl, 4
    mov cx, 1
    int 10h
    inc SI
    jmp wrtf
fnshf:
    mov cx, 0Fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    ret
error_message endp

load_message proc
    lea DI, load
    mov dx, 0616h
wrtl:
    cmp [DI], '$'
    je fnshl
    inc dl
    mov ah, 02
    int 10h
    mov ah, 09h
    mov al, [DI]
    mov bl, 4
    mov cx, 1
    int 10h
    inc DI
    jmp wrtl
fnshl:
    ret
load_message endp

function2n proc
bckn:
    cmp cl, 5
    je trn
    add SI, 6
    inc cl
    cmp [SI], '-'
    jne bckn
trn:
    ret
function2n endp

function2 proc
bck:
    cmp cl, 5
    je tr
    add SI, 6
    inc cl
    cmp [SI], '+'
    jne bck
tr:
    ret
function2 endp

function3 proc
    inc check_n
bck1:
    mov al, [SI]
    mov [DI], al
    inc SI
    inc DI
    cmp [SI], ' '
    jne bck1
    mov al, [SI]
    mov [DI], al
    inc SI
    inc DI
    ret
function3 endp

function5 proc
    lea DI, A1
    lea SI, N1
    mov cl, 0
bck3:
    sub SI, 6
    call function2
    cmp [SI], '-'
    je inc_check_n_call
    call function3
    cmp cl, 5
    jne bck3
    jmp cont
inc_check_n_call:
    inc check_n
    jmp bck3
cont:
    check check_n
    mov al, check_n
    mov check_n_copy, al
    lea BX, A1
lp2:
    push BX
    mov al, check_n_copy
    mov check_n, al
    mov Number, 0
lp:
    pop BX
    add Number, 6
    dec check_n
    push BX
    cmp check_n, 0
    jle cnt
    ranking BX, Number
    jmp lp
cnt:
    pop BX
    add BX, 6
    dec check_n_copy
    cmp check_n_copy, 0
    jg lp2
    lea DI, A6
    lea SI, N1
    mov cl, 0
bckn3:
    sub SI, 6
    call function2n
    cmp [SI], '+'
    je bckn3_next
    call function3
    cmp cl, 5
    jne bckn3
    jmp contn
bckn3_next:
    jmp bckn3
contn:
    check check_n
    mov al, check_n
    mov check_n_copy, al
    lea BX, A6
lpn2:
    push BX
    mov al, check_n_copy
    mov check_n, al
    mov Number, 0
lpn:
    pop BX
    add Number, 6
    dec check_n
    push BX
    cmp check_n, 0
    jle cntn
    ranking_neg BX, Number
    jmp lpn
cntn:
    pop BX
    add BX, 6
    dec check_n_copy
    cmp check_n_copy, 0
    jg lpn2
    lea SI, N1
    lea DI, A1
chk:
    cmp [DI], 'f'
    je write_on_file
    cmp [DI], '$'
    je inc_DI
    mov al, [DI]
    mov [SI], al
    inc SI
    inc DI
    jmp chk
inc_DI:
    inc DI
    jmp chk
write_on_file:
    ret
function5 endp

code ends
end start