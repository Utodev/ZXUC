FA_READ   equ   $01
FA_APPEND equ $06
M_GETSETDRV   equ   $89
F_OPEN   equ   $9a
F_CLOSE   equ   $9b
F_READ   equ   $9d
F_WRITE equ $9e


org $2000

Main: ; Set default disk
      XOR a
      RST $08
      db M_GETSETDRV
      RET C
      ld b, FA_READ   
      ld hl, zxucbinfile   
      rst $08
      db F_OPEN      
      RET C
      ld (FHandle),a
      ld HL, 45000
      ld bc, 16384   ; bc=longitud del fichero, en exceso, por asegurar
      ld a,(FHandle)
      rst $08
      db F_READ      ; Leer archivo     
      RET C
      ld a,(FHandle)
      rst $08
      db F_CLOSE
      RET C
      RST $18
      dw 45000
      RET
Print:
      pop hl
      db $3e
Print1:   
      rst $10
      ld a, (hl)
      inc hl
      or a
      jr nz, Print1
      jp (hl)

FHandle: db 0
zxucbinfile: db "/BIN/ZXUC.BIN"
db 0


END $2000
