;ZXUC (C) Uto 2016

; --- ESXDOS FUNCTIONS
      M_GETSETDRV   equ   $89
      F_OPEN   equ   $9a
      F_CLOSE   equ   $9b
      F_READ   equ   $9d
      F_WRITE equ $9e
      F_MKDIR equ 170
; --- FILE OPEN MODES
      FA_CREATE_AL   equ   12
; --- ZXUNO details
      zxuno_port equ 64571
      REGISTERS_TO_SAVE_COUNT equ FHandle - RegistersToSave


org $2000

Main: 

;---- Check if params

      ld a,h
      or l
      jr nz, saveConfig

; -----------------------------
; +++ NO PARAMS - SHOW HELP +++
; -----------------------------

      ld hl, usage
      call Print
      ret


; --------------------------------------------------
; +++ SAVE A CONFIGURATION FILE - DON'T OPEN GUI +++
; --------------------------------------------------

saveConfig:
; --- Preserve HL, pointer to parameters
      push hl
; --- Set default disk    
      xor a
      rst $08
      db M_GETSETDRV
      ret c     
; --- Make sure config folder exists
      ld hl, cfgpath
      rst $08
      db F_MKDIR     
; --- Put a slash where the previous zero ender was, so path continues with a slash      
      ld a, '/'
      ld (cfgpathslash), a
; --- Restore HL, pointer to parameters      
      pop hl    

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
      ld a, b
      or a
      jr z, saveFile; exit if already 8 characters
      inc de
      inc hl
      jp filenameLoop
addZero:   ; name shorter than 8 characters, set zero for ASCIIZ string
      xor a
      ld (de),a


saveFile: 
; --- Put all regs in buffer
      call getRegs
; --- Set default disk    
      xor a
      rst $08
      db M_GETSETDRV
      ret c     
; --- Open cfg file      
      ld hl, cfgpath
      ld b, FA_CREATE_AL
      rst $08
      db F_OPEN      
      ret C
; --- Save data at cfgbuffer
      ld (FHandle),a
      ld hl, cfgbuffer
      ld bc, REGISTERS_TO_SAVE_COUNT
      rst $08
      db F_WRITE      ; Escribir archivo     
      ret C
; --- Close file      
      ld a,(FHandle)
      rst $08
      db F_CLOSE
      ret c
      ret

getRegs:
; --- Write config to ZX-Uno registers
      ld hl, cfgbuffer
      ld bc, zxuno_port
      ld a, REGISTERS_TO_SAVE_COUNT  ; A register contains number of ZX-Uno records to save
      ld de, RegistersToSave         ; DE keeps the list of records
getRegsLoop:
      push af                        ; Preserve record count
      ld a, (de)                     ; Get first record to save  
      inc de                         ; Point to next one in the list
      out (c), a                     ; Select record
      inc b                          ; Point to ZX-Uno data port (non casually, 256 bytes above the other one)
      in a, (c)                      ; Read value
      ld (hl),a                      ; Store value in buffer
      inc hl                         ; Move pointer to buffer as well
      dec b                          ; Point again to ZX-Un select port   
      pop af                         ; Restore record count
      dec a                           
      or a
      ret z                          ; Dec count and if zero, return
      jr getRegsLoop
      ret


Print:  ld a, (hl)
        or a
        ret z
        rst $10
        inc hl
        jp Print


;--- Variables
; IMPORTANT: NEVER EVER CHANGE THE ORDER OF THESE RECORDS, IF YOU HAVE TO ADD NEW ONE, ADD IT AS LAST RECORD INSTEAD OF INSERTING IT TO KEEP 
;            NUMERIC ORDER. OTHERWISE, WHEN LOADING OLD SAVED CONFIGS VALUES FOR SOME ZX-UNO RECORDS WILL BE LOADED INTO DIFFERENT ONES
RegistersToSave: db $00, $06, $0B,$0E, $0F,$80, $81, $82, $83, $84, $85
FHandle: db 0
usage:   db "USAGE: .ZXUCSAVE <configname>"
         db $0D, $0D
         db "configname: filename up to 8 characters without extension"
         db $0D, $0D
         db "Example: .ZXUCSAVE turbo7"
         db $0D, $0D
         db "Notes:"
         db $0D
         db "- If configname is larger than 8 characters it will be truncated"
         db $0D
         db "- If config already exists it will be overwritten"
         db $0D, 0
cfgpath: db "/SYS/CONFIG/ZXUCCFG"
cfgpathslash: db 0
cfgfile: db 0
         ds 7
         db 0   
cfgbuffer: ds 256


END $2000      

    