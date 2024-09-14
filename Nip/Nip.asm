; Autor: Ramirez Diez Brian Michel
; Nombre de programa: Validacion de nip
.org 0000h
	ld a,89h
	ld hl, Cont
	ld (HL), 3
	out (CW),a
	ld SP, 27ffh
	ld hl, tex1
	call disp_text
cal:
	call read_pasw
	call Real
	call erfinal

; sub rutinas

disp_text:
; Emicion de 1er mensaje
repeat1:
	ld a,(hl)
 	cp "&"
	jp z, FT1
	out (LCD), a
	inc hl
	jp repeat1
FT1:
	ret

read_pasw:
; Introduccion de pasword
	ld hl, passw
	ld b, 4
readt_other:
	in a,(KEYB)
; comprobacion de ingresos
; unicamente de numeros
	cp 30h
	jp C, hal
	cp 39h
	jp NC, hal
; salida en pantalla de "*"
	ld (hl),a
	ld a, 2ah
	out (LCD), a
	inc hl
        djnz readt_other
	ret
; reiniciar el ingreso del nip
hal:
	ld hl, tex3
rd2:
	ld a, (hl)
 	cp "&"
	jp z, read_pasw
	out (LCD), a
	inc hl
	jp rd2

; inicio de
; comprobacion de contraseña
Real:
	ld hl, passw
	ld de, patron
	ld b, 4
lec:
	ld a, (DE)
	ld c, (HL)
	cp c
	jp NZ, equi
	inc DE
	inc HL
	djnz lec
; display de final
	ld hl, tex2
rd4:
	ld a, (hl)
 	cp "&"
	jp z, Fin
	out (LCD), a
	inc hl
	jp rd4
; comienzo de errores

equi:
	ld HL, tex3
; decremento de contador intterno
; que maneja los intentos
	ld DE, cont
	ld a, (DE)
	dec a
	ld (DE), a
	cp 0
	jp NZ, Ni_idea
	ret
Ni_idea:
	ld a, (hl)
 	cp "&"
	jp z, cal
	out (LCD), a
	inc hl
	jp Ni_idea

; fin de intentos
erfinal:
	ld hl, tex4
rd3:
	ld a, (hl)
 	cp "&"
	jp z, Fin
	out (LCD), a
	inc hl
	jp rd3
Fin:
	halt

;segmento de datos
 .org 2000h
tex1:   .db "Introducir NIP &"
patron  .db 31h,32h,33h,34h
passw   .db 00h,00h,00h,00h
tex2:   .db "Acceso Exitoso &"
tex3:	.db "Try again &"
tex4:   .db "fallo total &"
Cont:   .db 03h


;constante

LCD: .equ 00h
KEYB: .equ 01h
CW:    .equ 03h


end


