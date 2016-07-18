'ZXUC (C) Uto 2016


'******************************************************************************
'***************************          AUX           ***************************
'******************************************************************************

SUB header()
	PRINT AT 0,0;
	PRINT PAPER 1;"                                "; INK 0; BRIGHT 1; PAPER 6; "   ZX-UNO CONFIG (C) 2016 Uto   "; PAPER 1;"                                ";
END SUB

FUNCTION getKey() as String
 'Repeat until key pressed
 DO 
  LET t$ = INKEY$
 LOOP UNTIL t$<>""
 'Repeat until key released
 DO 
  LET p$ = INKEY$
 LOOP UNTIL p$<>t$
 RETURN t$
END FUNCTION

FUNCTION getZXUnoReg(numreg as UByte) as UByte
  OUT 64571, numreg: RETURN IN 64827
END FUNCTION

SUB setZXUnoReg(numreg as UByte, value as UByte)
  OUT 64571, numreg: OUT 64827, value
END SUB

FUNCTION getULATiming(value as UByte)
	DIM ULATIMINGMODE0, ULATIMINGMODE1 as UByte
	LET ULATIMINGMODE0  = (value bAND 00010000b) >> 4
	LET ULATIMINGMODE1  = (value bAND 01000000b) >> 6
	RETURN ULATIMINGMODE0 bOR (ULATIMINGMODE1 << 1)
END FUNCTION

FUNCTION bitToggle(value as UByte, bitno as UByte) as UByte
   RETURN value bXOR (1 << bitno)
END FUNCTION

FUNCTION bitSet(value as UByte, bitno as UByte) as UByte
   RETURN value bOR (1 << bitno)
END FUNCTION


FUNCTION bitClear(value as UByte, bitno as UByte) as UByte
   RETURN value bAND (bNOT (1 << bitno))
END FUNCTION


FUNCTION bitTest(value as UByte, bitno as UByte) as UByte
    IF value bAND (1<<bitno) <> 0 THEN RETURN 1: END IF
    RETURN 0
END FUNCTION

FUNCTION notBitTest(value as UByte, bitno as UByte) as UByte
    IF value bAND (1<<bitno) <> 0 THEN RETURN 0: END IF
    RETURN 1
END FUNCTION


FUNCTION getCOREID() as String
	DIM B as UByte
	LET B = getZXUnoReg($FF)
	LET c$ = ""
	WHILE B<>0
		IF (B<32) OR (B>127) RETURN "OLD CORE": END IF
	 	LET c$ = c$ + CHR$(B)
	 	LET B = IN 64827
	END WHILE
	RETURN c$
END FUNCTION

FUNCTION BinaryStr(value as UByte) AS string
  LET t$ = ""
  FOR i = 0 to 7
	  IF (value bAND (1 << i))<>0 THEN 
	     LET t$="1"+t$
	  ELSE 
	     LET t$="0"+t$
	  END IF
  NEXT i
  RETURN t$
END FUNCTION

FUNCTION joyType(value as UByte) AS String
	IF value=0 THEN RETURN "Disabled " : END IF
	IF value=1 THEN RETURN "Kempston ": END IF
	IF value=2 THEN RETURN "Sinclair1": END IF
	IF value=3 THEN RETURN "Sinclair2": END IF
	IF value=4 THEN RETURN "Cursor   ": END IF
	RETURN ""
END FUNCTION

FUNCTION ULATimingValue(value as UByte) AS String
	IF value=0 THEN RETURN "48K PAL  " : END IF
	IF value=1 THEN RETURN "128K/2+  " : END IF
	IF value=2 THEN RETURN "Pentagon " : END IF
	IF value=3 THEN RETURN "Reserved " : END IF
	RETURN ""
END FUNCTION


FUNCTION keyBoardType(value as UByte) AS String
	IF value=0 THEN RETURN "Issue 3" : END IF
	IF value=1 THEN RETURN "Issue 2": END IF
	RETURN ""
END FUNCTION


FUNCTION turboDesc(value as UByte) AS String
	IF value=0 THEN RETURN "3.5 Mhz" : END IF
	IF value=1 THEN RETURN "  7 Mhz": END IF
	IF value=2 THEN RETURN " 14 Mhz": END IF
	IF value=3 THEN RETURN "*28 Mhz": END IF
	RETURN ""
END FUNCTION

FUNCTION freqDesc(value as UByte) AS String
 IF value = 0 THEN RETURN "28.125": END IF
 IF value = 1 THEN RETURN "28.571": END IF
 IF value = 2 THEN RETURN "30    ": END IF
 IF value = 3 THEN RETURN "31.25 ": END IF
 IF value = 4 THEN RETURN "32.143": END IF
 IF value = 5 THEN RETURN "33.333": END IF
 IF value = 6 THEN RETURN "34.615": END IF
 IF value = 7 THEN RETURN "35.714": END IF
END FUNCTION

FUNCTION freqDescVert(value, timing as UByte) AS String
	IF timing = 0 THEN
		 IF value = 0 THEN RETURN "50.303": END IF
		 IF value = 1 THEN RETURN "51.102": END IF
		 IF value = 2 THEN RETURN "53.657": END IF
		 IF value = 3 THEN RETURN "55.893": END IF
		 IF value = 4 THEN RETURN "57.490": END IF
		 IF value = 5 THEN RETURN "59.619": END IF
		 IF value = 6 THEN RETURN "61.912": END IF
		 IF value = 7 THEN RETURN "63.878": END IF
	END IF

	IF timing = 1 THEN
		 IF value = 0 THEN RETURN "49.580": END IF
		 IF value = 1 THEN RETURN "50.366": END IF
		 IF value = 2 THEN RETURN "52.885": END IF
		 IF value = 3 THEN RETURN "55.089": END IF
		 IF value = 4 THEN RETURN "56.663": END IF
		 IF value = 5 THEN RETURN "58.761": END IF
		 IF value = 6 THEN RETURN "61.021": END IF
		 IF value = 7 THEN RETURN "62.958": END IF
	END IF

	IF timing = 2 THEN
		 IF value = 0 THEN RETURN "49.046": END IF
		 IF value = 1 THEN RETURN "49.824": END IF
		 IF value = 2 THEN RETURN "52.316": END IF
		 IF value = 3 THEN RETURN "54.496": END IF
		 IF value = 4 THEN RETURN "56.053": END IF
		 IF value = 5 THEN RETURN "58.128": END IF
		 IF value = 6 THEN RETURN "60.364": END IF
		 IF value = 7 THEN RETURN "62.280": END IF
	END IF
	
	RETURN "??.???"

END FUNCTION


FUNCTION onOff(value as UByte) AS String
	IF value=0 THEN RETURN "Off": END IF
	RETURN "On "
END FUNCTION

'******************************************************************************
'***************************        JOYSTICK        ***************************
'******************************************************************************


SUB JoystickMenu()
	CLS
	DIM JOYCONF, JoyKey , JoyKeyAutoFire , JoyDB9, JoyDB9AutoFire as UByte
	joymenu:
	header(): PRINT:PRINT:PRINT
	JOYCONF = getZXUnoReg(6)
	LET JoyKey = JOYCONF bAND 00000111b
	LET JoyDB9 = (JOYCONF bAND 01110000b) >> 4
	LET JoyKeyAutoFire = (JOYCONF bAND 00001000b) >> 3
	LET JoyDB9AutoFire = (JOYCONF bAND 10000000b) >> 7
	
	PRINT
	PRINT "    \{p7}\{i0}1\{p0}\{i7} KEY JOY: "; joyType(JoyKey): PRINT
	PRINT "    \{p7}\{i0}2\{p0}\{i7} DB9 JOY: "; joyType(JoyDB9): PRINT
	PRINT "    \{p7}\{i0}3\{p0}\{i7} KEY Autofire: "; onOff(JoyKeyAutoFire): PRINT
	PRINT "    \{p7}\{i0}4\{p0}\{i7} DB9 Autofire: "; onOff(JoyDB9AutoFire): PRINT
	PRINT "    \{p7}\{i0}B\{p0}\{i7} BACK"
	PRINT
	PRINT "    "; PAPER 5; INK 0; " Reg #06 [ "; BinaryStr(JOYCONF) ; " ] "

	waitkeyJoystick:
	LET a$ = getKey()
	'Change key joystick mode
	IF a$ = "1" THEN 
		LET JoyKey = JoyKey+1
		IF JoyKey = 5 THEN LET JoyKey = 0: END IF
		JOYCONF = (JoyDB9AutoFire << 7) bOR (JoyDB9 << 4) bOR (JoyKeyAutoFire << 3) bOR JoyKey
        setZXUnoReg(6,JOYCONF): GO TO joymenu
    END IF
    'Change DB9 joystick mode
	IF a$ = "2" THEN 
		LET JoyDB9 = JoyDB9+1
		IF JoyDB9 = 5 THEN LET JoyDB9 = 0: END IF
		JOYCONF = (JoyDB9AutoFire << 7) bOR (JoyDB9 << 4) bOR (JoyKeyAutoFire << 3) bOR JoyKey
        setZXUnoReg(6,JOYCONF): GO TO joymenu
    END IF
	'Change key joystick autofire
	IF a$ = "3" THEN 
		LET JoyKeyAutoFire = JoyKeyAutoFire + 1
		IF JoyKeyAutoFire = 2 THEN LET JoyKeyAutoFire = 0: END IF
		JOYCONF = (JoyDB9AutoFire << 7) bOR (JoyDB9 << 4) bOR (JoyKeyAutoFire << 3) bOR JoyKey
        setZXUnoReg(6,JOYCONF): GO TO joymenu
    END IF
	'Change DB9 joystick autofire
	IF a$ = "4" THEN 
		LET JoyDB9AutoFire = JoyDB9AutoFire + 1
		IF JoyDB9AutoFire = 2 THEN LET JoyDB9AutoFire = 0: END IF
		JOYCONF = (JoyDB9AutoFire << 7) bOR (JoyDB9 << 4) bOR (JoyKeyAutoFire << 3) bOR JoyKey
        setZXUnoReg(6,JOYCONF): GO TO joymenu
    END IF
	IF a$ = "b" THEN LET a$ = "" : RETURN: END IF
		GO TO waitkeyJoystick
END SUB  

'******************************************************************************
'***************************          TURBO         ***************************
'******************************************************************************


SUB TurboMenu()
	CLS
	DIM SCANDBLCTRL, TURBO, FREQ, ENSCAN, VGA, ULATIMINGAUX as UByte
	turbomenu:
	header(): PRINT:PRINT:PRINT
	LET SCANDBLCTRL = getZXUnoReg($0b)
	LET TURBO = (SCANDBLCTRL bAND 11000000b) >> 6
	LET FREQ = (SCANDBLCTRL bAND 00011100b) >> 2
	LET ENSCAN = (SCANDBLCTRL bAND 00000010b) >> 1
	LET VGA = SCANDBLCTRL bAND 00000001b 
	LET MASTERCONF = getZXUnoReg($00)
	LET ULATIMINGAUX = getULATiming(MASTERCONF)
	
	PRINT
	PRINT "    \{p7}\{i0}T\{p0}\{i7} TURBO: "; turboDesc(TURBO): PRINT
	PRINT "    \{p7}\{i0}F\{p0}\{i7} MASTER FREQ: "; freqDesc(FREQ); " Hz": PRINT
	PRINT "      VERT   FREQ: "; freqDescVert(FREQ, ULATIMINGAUX); " Hz": PRINT
	PRINT "    \{p7}\{i0}E\{p0}\{i7} ENSCAN: "; onOff(ENSCAN): PRINT
	PRINT "    \{p7}\{i0}V\{p0}\{i7} VGA: "; onOff(VGA): PRINT
	PRINT "    \{p7}\{i0}B\{p0}\{i7} BACK"
	PRINT
	PRINT "    "; PAPER 5; INK 0; " Reg #0B [ "; BinaryStr(SCANDBLCTRL) ; " ] " 

	waitkeyTurbo:
	LET a$ = getKey()
	'Change Turbo Mode
	IF a$ = "t" THEN 
		LET TURBO = TURBO + 1
		IF TURBO = 3 THEN LET TURBO = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10: GO TO turbomenu
    END IF
    'Change FREQ
	IF a$ = "f" THEN 
		LET FREQ = FREQ + 1
		IF FREQ = 8 THEN LET FREQ = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10:  GO TO turbomenu
    END IF
	'Change ENSCAN
	IF a$ = "e" THEN 
		LET ENSCAN = ENSCAN + 1
		IF ENSCAN = 2 THEN LET ENSCAN = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10: GO TO turbomenu
    END IF
	'Change VGA
	IF a$ = "v" THEN 
		LET VGA = VGA + 1
		IF VGA = 2 THEN LET VGA = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): GO TO turbomenu
    END IF
	IF a$ = "b" THEN LET a$ = "" : RETURN: END IF
		GO TO waitkeyTurbo
END SUB  

'******************************************************************************
'***************************        HARDWARE        ***************************
'******************************************************************************


SUB HardwareMenu()
	CLS
	DIM DEVCONTROL,  DEVCTRL2, MASTERCONF, ULATIMING, ULATIMINGMODE1, ULATIMINGMODE0 as UByte
	hardwaremenu:
	header() 
	LET DEVCONTROL = getZXUnoReg($0e)
	LET DEVCTRL2 =  getZXUnoReg($0f)
	LET MASTERCONF =  getZXUnoReg($00)
	LET ULATIMING = getULATiming(MASTERCONF)
	
	PRINT
	PRINT "   \{p7}\{i0}S\{p0}\{i7} SD Card       : "; onOff(notBitTest(DEVCONTROL,7))
	PRINT "   \{p7}\{i0}M\{p0}\{i7} MMU Timex     : "; onOff(bitTest(DEVCONTROL,6))
	PRINT "   \{p7}\{i0}A\{p0}\{i7} AY Chip       : "; onOff(notBitTest(DEVCONTROL,0))
	PRINT "   \{p7}\{i0}Y\{p0}\{i7} AY Chip 2     : "; onOff(notBitTest(DEVCONTROL,1))
	PRINT "   \{p7}\{i0}R\{p0}\{i7} Radastan mode : "; onOff(notBitTest(DEVCTRL2,2))
	PRINT "   \{p7}\{i0}T\{p0}\{i7} Timex modes   : "; onOff(notBitTest(DEVCTRL2,1))
	PRINT "   \{p7}\{i0}U\{p0}\{i7} ULAplus       : "; onOff(notBitTest(DEVCTRL2,0))
	PRINT "   \{p7}\{i0}C\{p0}\{i7} Contended Mem : "; onOff(notBitTest(MASTERCONF,5))
	PRINT "   \{p7}\{i0}K\{p0}\{i7} Keyboard      : "; keyBoardType(bitTest(MASTERCONF,3))
	PRINT "   \{p7}\{i0}L\{p0}\{i7} ULA Timing    : "; ULATimingValue(ULATIMING)

	PRINT "   \{p7}\{i0}B\{p0}\{i7} BACK"
	PRINT
	PRINT "   "; PAPER 5; INK 0; " Reg #00 [ "; BinaryStr(MASTERCONF) ; " ] " 
	PRINT "   "; PAPER 5; INK 0; " Reg #0E [ "; BinaryStr(DEVCONTROL) ; " ] " 
	PRINT "   "; PAPER 5; INK 0; " Reg #0F [ "; BinaryStr(DEVCTRL2) ; " ] " 

	waitkeyHardware:
	LET a$ = getKey()


	'Toggle Contended Memory
	IF a$ = "c" THEN 
		MASTERCONF = bitToggle(MASTERCONF, 5)
        setZXUnoReg($00,MASTERCONF): GO TO hardwaremenu
    END IF

	'Toggle Keyboard emulation
	IF a$ = "k" THEN 
		MASTERCONF = bitToggle(MASTERCONF, 3)
        setZXUnoReg($00,MASTERCONF): GO TO hardwaremenu
    END IF


	'Modify ULATiming
	IF a$ = "l" THEN 
		LET ULATIMING = ULATIMING + 1
		IF ULATIMING = 3 THEN LET ULATIMING= 0: END IF
		LET ULATIMINGMODE1 = (ULATIMING bAND 2) >> 1
		LET ULATIMINGMODE0 = (ULATIMING bAND 1)
		IF ULATIMINGMODE1<>0 THEN 
		 MASTERCONF = bitSet(MASTERCONF, 6)
		ELSE
		 MASTERCONF = bitClear(MASTERCONF, 6)
		END IF 
		IF ULATIMINGMODE0<>0 THEN 
		 MASTERCONF = bitSet(MASTERCONF, 4)
		ELSE
		 MASTERCONF = bitClear(MASTERCONF, 4)
		END IF 
        setZXUnoReg($00,MASTERCONF): GO TO hardwaremenu
    END IF

	'Toggle SD Card
	IF a$ = "s" THEN 
		DEVCONTROL = bitToggle(DEVCONTROL, 7)
        setZXUnoReg($0E,DEVCONTROL): GO TO hardwaremenu
    END IF

	'Toggle MMU Timex
	IF a$ = "m" THEN 
		DEVCONTROL = bitToggle(DEVCONTROL, 6)
        setZXUnoReg($0E,DEVCONTROL): GO TO hardwaremenu
    END IF

	'Toggle AY
	IF a$ = "a" THEN 
		DEVCONTROL = bitToggle(DEVCONTROL, 0)
        setZXUnoReg($0E,DEVCONTROL): GO TO hardwaremenu
    END IF

	'Toggle AY2
	IF a$ = "y" THEN 
		DEVCONTROL = bitToggle(DEVCONTROL, 1)
        setZXUnoReg($0E,DEVCONTROL): GO TO hardwaremenu
    END IF

	'Toggle Radastan mode
	IF a$ = "r" THEN 
		DEVCTRL2 = bitToggle(DEVCTRL2, 2)
        setZXUnoReg($0f,DEVCTRL2): GO TO hardwaremenu
    END IF

	'Toggle Timex Modes
	IF a$ = "t" THEN 
		DEVCTRL2 = bitToggle(DEVCTRL2, 1)
        setZXUnoReg($0f,DEVCTRL2): GO TO hardwaremenu
    END IF

	'Toggle ULAplus
	IF a$ = "u" THEN 
		DEVCTRL2 = bitToggle(DEVCTRL2, 0)
        setZXUnoReg($0f,DEVCTRL2): GO TO hardwaremenu
    END IF

	IF a$ = "b" THEN LET a$ = "" : RETURN: END IF
		GO TO waitkeyHardware
END SUB  




'******************************************************************************
'***************************          MAIN          ***************************
'******************************************************************************
mainmenu:
PAPER 0: BORDER 5: INK 7: BRIGHT 1: CLS
header()
PRINT:PRINT
PRINT "      \{p7}\{i0}J\{p0}\{i7} JOYSTICK SETTINGS": PRINT
PRINT "      \{p7}\{i0}T\{p0}\{i7} TURBO & VGA SETTINGS": PRINT
PRINT "      \{p7}\{i0}H\{p0}\{i7} HARDWARE SETTINGS": PRINT
PRINT "      \{p7}\{i0}R\{p0}\{i7} RESET": PRINT
PRINT "      \{p7}\{i0}E\{p0}\{i7} EXIT"
PRINT AT 21,0; INK 7; BRIGHT 0; " CoreID: "; getCOREID()

waitkey:
LET a$ = getKey()
IF a$ = "j" THEN JoystickMenu(): GOTO mainmenu: END IF
IF a$ = "t" THEN TurboMenu():goto mainmenu: END IF
IF a$ = "h" THEN HardwareMenu():goto mainmenu: END IF
IF (a$ <> "e") and (a$<>"r") THEN GO TO waitkey: END IF

IF (a$="r") THEN RANDOMIZE USR 0: END IF

BORDER 7: PAPER 7: INK 0: BRIGHT 0: CLS
STOP