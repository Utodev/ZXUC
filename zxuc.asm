;ZXUC (C) Uto 2017

; --- ESXDOS FUNCTIONS
      M_GETSETDRV   equ   $89
      F_OPEN   equ   $9a
      F_CLOSE   equ   $9b
      F_READ   equ   $9d
      F_WRITE equ $9e
; --- FILE OPEN MODES
      FA_READ   equ   $01
; --- ZXUNO details
      zxuno_port equ 64571
      REGISTERS_TO_LOAD_COUNT equ FHandle - RegistersToLoad

org $2000

Main: 

;---- Check if params

      ld a,h
      or l
      jr nz, loadConfig

; ----------------------------
; +++ NO PARAMS - OPEN GUI +++
; ----------------------------

; --- Set default disk    
      xor a
      rst $08
      db M_GETSETDRV
      ret c
      ld (UnoD +1), A ; Save current drive just in case UnoDOs is being used
; --- Open ZXCU.BIN file for ESXDOS
      ld b, FA_READ   
      ld hl, zxucbinfile   
      rst $08
      db F_OPEN      
      jr nc, load
; --- Open ZXCU.BIN file for UnoDOS
UnoD  ld a, 0 
      ld b, FA_READ   
      ld hl, zxucdosfile   
      rst $08
      db F_OPEN      
      jr nc, load
; --- Load ZXCU.BIN at address 45000
load  ld (FHandle),a
      ld HL, 45000
      ld bc, 16384   ; bc=file length ,in excess just to be sure
      ld a,(FHandle)
      rst $08
      db F_READ      ; read file
      ret c
; --- Close file      
      ld a,(FHandle)
      rst $08
      db F_CLOSE
      ret c
; --- Jump to address 45000 forcing exit from ESXDOS ROM so standard ROM is avaliable
      rst $18
      dw 45000
      ret

; --------------------------------------------------
; +++ LOAD A CONFIGURATION FILE - DON'T OPEN GUI +++
; --------------------------------------------------

loadConfig:
; --- Copy param to filename position
      ld b, 8
      ld de, cfgfile 
filenameLoop:      
      ld a, (hl)
      cp ':'
      jr z, addZero  ; exit if ':' found
      cp $0D
      jr z, addZero  ; exit if carriage return found
      ld (de), a
      dec b
      jp pe, loadFile; exit if already 8 characters
      inc de
      inc hl
      jp filenameLoop
addZero:   ; name shorter than 8 characters, set zero for ASCIIZ string
      xor a
      ld (de),a
loadFile: 
; --- Set default disk    
      xor a
      rst $08
      db M_GETSETDRV
      ret c
; --- Open cfg file      
      ld hl, cfgpath   
      ld b, FA_READ   
      rst $08
      db F_OPEN      
      ret C
; --- Load data at cfgbuffer
      ld (FHandle),a
      ld hl, cfgbuffer
      ld bc, REGISTERS_TO_LOAD_COUNT
      rst $08
      db F_READ      ; Leer archivo     
      ret C
; --- Close file      
      ld a,(FHandle)
      rst $08
      db F_CLOSE
      ret c

; --- Write config to ZX-Uno registers
      ld hl, cfgbuffer
      ld bc, zxuno_port
      ld a, REGISTERS_TO_LOAD_COUNT
      ld de, RegistersToLoad
setRegsLoop:
      push af                        ; Preserve record count
      ld a, (de)                     ; Get first record to save  
      inc de                         ; Point to next one in the list
      out (c), a                     ; Select record
      inc b                          ; Point to ZX-Uno data port (non casually, 256 bytes above the other one)
      ld a, (hl)
      out (c), a
      inc hl                         ; Move pointer to buffer as well
      dec b                          ; Point again to ZX-Un select port   
      pop af                         ; Restore record count
      dec a                           
      or a
      ret z                          ; Dec count and if zero, return
      jr setRegsLoop
      ret




;--- Variables
; IMPORTANT: NEVER EVER CHANGE THE ORDER OF THESE RECORDS, IF YOU HAVE TO ADD NEW ONE, ADD IT AS LAST RECORD INSTEAD OF INSERTING IT TO KEEP 
;            NUMERIC ORDER. OTHERWISE, WHEN LOADING OLD SAVED CONFIGS VALUES FOR SOME ZX-UNO RECORDS WILL BE LOADED INTO DIFFERENT ONES
RegistersToLoad: db $00, $06, $0B,$0E, $0F,$80, $81, $82, $83, $84, $85
FHandle: db 0
zxucbinfile: db "/BIN/ZXUC.BIN"
             db 0
zxucdosfile: db "/DOS/ZXUC.BIN"
             db 0
cfgpath: db "/SYS/CONFIG/ZXUCCFG/" ; Config files should be at /SYS/CONFIG and that folder should exist even for UnoDOS
cfgfile: ds 8
         db 0   
cfgbuffer: ds 256



    
