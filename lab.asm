data segment
    harita1 db "harita1.txt",0
    harita2 db "harita2.txt",0
    harita3 db "harita3.txt",0
    tutucu dw ?
    aktif_harita_adresi dw ?
    harita_adresi dw ?
    gecici_karakter db ?

    harita_verisi 440 dup("$")
    harita_son_adresi dw ?

    bitis_mesaji db "BITIS",10,13,"Cikmak icin bir tusa basiniz...",'$'
    dakika_bolen db 60d
    baslangic_saniye db 60d
    baslangic_satir db ?
    baslangic_sutun db ?
    saniye_kopya dw 1 dup('00')

    zaman_metni db "Gecen Sure = "
    dakika db '0',':'
    saniye dw 1 dup(?)," saniye",'$'
    puan dw 1 dup(?),'$'
    puan_metni db "Puan = "
    isaret db ?
    puan2 dw 1 dup(?)
    puan3 dw 1 dup(?)," pts",'$'

    l1 db " Yeni Oyun ",'$'
    l2 db " Harita Secimi ",'$'
    l3 db " Zorluk Seviyesi ",'$'

    map_menu db " 1 => Harita 1 ",10,13," 2 => Harita 2 ",10,13," 3 => Harita 3 ",10,13," Harita Numarasini Giriniz...",'$'
    hardness_menu db " E => Kolay (15 odul) ",10,13," M => Orta (10 odul) ",10,13," H => Zor (5 odul) ",10,13," Zorluk Harfini Giriniz...",'$'

    mavi db 12
    beyaz db 15
    baslangic_x db 0
    baslangic_y db 0
    gecici_y db ?
    gecici_y_kopya db ?

    kolay db 0Fh
    orta db 0Ah
    zor db 05h
    yukleme_mesaji db "YUKLENIYOR.",'$'
    hata_mesaji db "Gecersiz Giris.Lutfen Gecerli Bir Giris Yapiniz!",'$'
ends

menu macro str, colorb, colorw
    local wrt, cnt, fnsh

    mov dl, baslangic_x
    inc dh
    mov bl, colorw

    cmp dh, gecici_y
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

oku macro filename
    mov ah, 3Dh
    mov dx, filename
    mov al, 00h
    int 21h

    mov tutucu, ax

    mov ah, 3Fh
    mov bx, tutucu
    mov cx, 01B7h
    lea dx, harita_verisi
    int 21h

    mov ah, 3Eh
    mov bx, tutucu
    int 21h
endm

ekrani_temizle macro
    mov ax, 03h
    int 10h
    call tamponu_temizle
endm

zorluk macro mapname, number
    local lp, lp2, bck, ct, fnshl, wrtl

    mov DI, mapname

    oku DI
    lea SI, harita_verisi
    dec SI
lp:
    inc SI
    cmp SI, harita_son_adresi
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

    mov tutucu, ax

    mov ah, 40h
    mov bx, tutucu
    mov cx, 01B7h
    lea dx, harita_verisi
    int 21h

    mov ah, 3Eh
    mov bx, tutucu
    int 21h

    mov DI, mapname
    oku DI
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

    mov tutucu, ax

    mov ah, 40h
    mov bx, tutucu
    mov cx, 01B6h
    lea dx, harita_verisi
    int 21h

    mov ah, 3Eh
    mov bx, tutucu
    int 21h
endm

code segment
start:
    mov ax, @data
    mov ds, ax
    lea bx, harita_verisi
    mov harita_son_adresi, bx
    add harita_son_adresi, 440d
    mov aktif_harita_adresi, offset harita1

    mov ah, 0
    mov al, 12h
    int 10h

    call yon_menusu
    ekrani_temizle

    mov ah, 0
    mov al, 12h
    int 10h

    oku aktif_harita_adresi

    mov ah, 09h
    lea dx, harita_verisi
    int 21h

    call baslangic_noktasi

    mov ah, 2ch
    int 21h
    sub baslangic_saniye, dh

    call oyun_baslat
    hlt
ends

oyun_baslat proc
    mov dl, baslangic_sutun
    mov dh, baslangic_satir
    push dx

again:
    call tamponu_temizle
    mov DI, SI

    pop dx
    push dx
    mov bp, dx

tkr:
    call zaman_hesapla
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

    sub puan, 5d

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
    cmp SI, harita_son_adresi
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
    cmp SI, harita_son_adresi
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
    cmp SI, harita_son_adresi
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
    cmp SI, harita_son_adresi
    jnb error
    inc dl
    cmp [SI], 'U'
    je scoring
    cmp [SI], 'E'
    je finish
    jmp final

scoring:
    mov [SI], ' '
    add puan, 50d

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
    ekrani_temizle
    mov ah, 09h
    lea dx, bitis_mesaji
    int 21h
    mov ah, 0
    int 16h

esc_key:
    ekrani_temizle
    mov ax, 4c00h
    int 21h
    ret
oyun_baslat endp

baslangic_noktasi proc
    xor dx, dx
    lea SI, harita_verisi

back:
    cmp [SI], 'U'
    jne go
    mov dl, baslangic_sutun
    mov dh, baslangic_satir
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
    inc baslangic_satir
    add SI, 2
    mov baslangic_sutun, 0
    jmp back

inc_cloumn:
    inc baslangic_sutun
    inc SI
    jmp back

baslangic_noktasi endp

tamponu_temizle proc
    mov ax, 0c00h
    int 21h
    ret
tamponu_temizle endp

zaman_hesapla proc
    mov ah, 2ch
    int 21h
    mov al, dh
    add al, baslangic_saniye
    mov ah, 0
    div dakika_bolen
    xchg ah, al
    aam
    xchg ah, al
    add ax, 3030h
    mov saniye, ax

    cmp ax, saniye_kopya
    jne check_dakika

ct1:
    mov dl, 10
    mov dh, 24
    mov bh, 0
    mov ah, 02h
    int 10h
    mov ah, 09h
    lea dx, zaman_metni
    int 21h

scored:
    mov dl, 10
    mov dh, 25
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ax, 0
    add ax, puan
    jns score_print

    sub ax, 1
    xor ax, 0ffffh
    push ax
    mov isaret, '-'
    pop ax

wrt:
    mov cl, 10d
    div cl
    xchg ah, al
    cmp ah, 9h
    ja grt
    xchg ah, al
    add ax, 3030h
    mov puan2, 0h
    mov puan3, ax

ct:
    mov ah, 09h
    lea dx, puan_metni
    int 21h
    ret

score_print:
    push ax
    mov isaret, '+'
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
    mov puan2, ax

    mov al, bh
    mov ah, al
    rol ah, 4
    and ax, 0f0fh
    add ax, 3030h
    xchg ah, al
    mov puan3, ax
    jmp ct

check_dakika:
    mov ax, saniye
    mov saniye_kopya, ax
    cmp ax, 3030h
    jne ct1
    inc dakika
    jmp ct1

zaman_hesapla endp

menuyu_yaz proc
    mov al, gecici_y
    mov gecici_y_kopya, al
    mov dh, baslangic_y

    menu l1, mavi, beyaz
    menu l2, mavi, beyaz
    menu l3, mavi, beyaz
    ret
menuyu_yaz endp

yon_menusu proc
start_m:
    mov al, baslangic_y
    inc al
    mov gecici_y, al
    mov gecici_y_kopya, al
    mov ah, 0
    mov al, 12h
    int 10h

    call menuyu_yaz

arrow_m:
    mov al, gecici_y_kopya
    mov gecici_y, al

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
    cmp gecici_y, 1
    je new_game
    cmp gecici_y, 2
    je map_selection
    cmp gecici_y, 3
    je hardness

new_game:
    ret

hardness_error:
    call hata_mesaji_goster

hardness:
    mov ax, 03h
    int 10h
    mov ah, 09h
    lea dx, hardness_menu
    int 21h
    mov ah, 01
    int 21h
    cmp al, 1Bh
    je esc_key_m
    mov gecici_karakter, al
    lea SI, gecici_karakter
    mov ah, 0
    int 16h
    cmp ah, 1Ch
    jne hardness_error

    cmp [SI], 'e'
    je easyc
    cmp [SI], 'E'
    jne medium

easyc:
    call yukleme_mesaji_goster
    mov harita_adresi, offset harita1
    zorluk harita_adresi, kolay
    mov ah, 02
    mov dl, '.'
    int 21h
    mov harita_adresi, offset harita2
    zorluk harita_adresi, kolay
    mov ah, 02
    mov dl, '.'
    int 21h
    mov harita_adresi, offset harita3
    zorluk harita_adresi, kolay
    mov ah, 02
    mov dl, '.'
    int 21h
    jmp start_m

medium:
    cmp [SI], 'm'
    je mediumc
    cmp [SI], 'M'
    jne hardn

mediumc:
    call yukleme_mesaji_goster
    mov harita_adresi, offset harita1
    zorluk harita_adresi, orta
    mov ah, 02
    mov dl, '.'
    int 21h
    mov harita_adresi, offset harita2
    zorluk harita_adresi, orta
    mov ah, 02
    mov dl, '.'
    int 21h
    mov harita_adresi, offset harita3
    zorluk harita_adresi, orta
    mov ah, 02
    mov dl, '.'
    int 21h
    jmp start_m

hardn:
    cmp [SI], 'h'
    je hardc
    cmp [SI], 'H'
    jne hardness_error

hardc:
    call yukleme_mesaji_goster
    mov harita_adresi, offset harita1
    zorluk harita_adresi, zor
    mov ah, 02
    mov dl, '.'
    int 21h
    mov harita_adresi, offset harita2
    zorluk harita_adresi, zor
    mov ah, 02
    mov dl, '.'
    int 21h
    mov harita_adresi, offset harita3
    zorluk harita_adresi, zor
    mov ah, 02
    mov dl, '.'
    int 21h
    jmp start_m

map_selection_error:
    call hata_mesaji_goster

map_selection:
    mov ax, 03h
    int 10h
    mov ah, 09h
    lea dx, map_menu
    int 21h
    mov ah, 01
    int 21h
    cmp al, 1Bh
    je esc_key_m
    mov gecici_karakter, al
    lea SI, gecici_karakter
    mov ah, 0
    int 16h
    cmp ah, 1Ch
    jne map_selection_error

    cmp [SI], 31h
    jne check_harita2
    mov harita_adresi, offset harita1
    mov aktif_harita_adresi, offset harita1
    jmp start_m

check_harita2:
    cmp [SI], 32h
    jne check_harita3
    mov harita_adresi, offset harita2
    mov aktif_harita_adresi, offset harita2
    jmp start_m

check_harita3:
    cmp [SI], 33h
    jne map_selection_error
    mov harita_adresi, offset harita3
    mov aktif_harita_adresi, offset harita3
    jmp start_m

down_m:
    inc gecici_y
    cmp gecici_y, 3
    ja arrow_m
    call menuyu_yaz
    jmp arrow_m

up_m:
    dec gecici_y
    cmp gecici_y, 1
    jb arrow_m
    call menuyu_yaz
    jmp arrow_m

esc_key_m:
    mov ax, 03h
    int 10h
    mov ax, 4c00h
    int 21h

yon_menusu endp

hata_mesaji_goster proc
    mov ax, 03h
    int 10h
    lea SI, hata_mesaji
    mov cx, 0
    mov dx, 0515h
wrtf:
    cmp [SI], '$'
    je fnshf
    inc dl
    mov ah, 02
    mov bh, 0
    int 10h
    mov ah, 09h
    mov al, [SI]
    mov bh, 0
    mov cx, 1
    mov bl, 4
    int 10h
    inc SI
    jmp wrtf

fnshf:
    mov cx, 0Fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    ret
hata_mesaji_goster endp

yukleme_mesaji_goster proc
    lea DI, yukleme_mesaji
    mov cx, 0
    mov dx, 0616h
wrtl:
    cmp [DI], '$'
    je fnshl
    inc dl
    mov ah, 02
    mov bh, 0
    int 10h
    mov ah, 09h
    mov al, [DI]
    mov bh, 0
    mov cx, 1
    mov bl, 4
    int 10h
    inc DI
    jmp wrtl

fnshl:
    ret
yukleme_mesaji_goster endp

end start
