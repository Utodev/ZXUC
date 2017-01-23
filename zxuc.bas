'ZXUC (C) Uto 2016-2017

'******************************************************************************
'***************************          AUX           ***************************
'******************************************************************************

SUB header()
	PRINT AT 0,0;
	PRINT PAPER 1;"                                "; INK 0; BRIGHT 1; PAPER 6; " ZX-UNO CONFIG 0.6 (C) 2016 Uto "; PAPER 1;"                                ";
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
		IF (B<32) OR (B>127) RETURN "OLD CORE OR NON ZX-UNO": END IF
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
  LET t$ = str$(value) + " " + t$
  RETURN t$
END FUNCTION

FUNCTION joyType(value as UByte) AS String
	IF value=0 THEN RETURN "Disabled  " : END IF
	IF value=1 THEN RETURN "Kempston  ": END IF
	IF value=2 THEN RETURN "SJS1      ": END IF
	IF value=3 THEN RETURN "SJS2      ": END IF
	IF value=4 THEN RETURN "Protek    ": END IF
	IF value=5 THEN RETURN "Fuller     ": END IF
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

FUNCTION coptDESC(value as UByte) AS String
	IF value=0 THEN RETURN "Spectrum" : END IF
	IF value=1 THEN RETURN "PAL     " : END IF
	RETURN ""
END FUNCTION

FUNCTION modelDesc(value as UByte) AS String
 	IF value = 0 THEN RETURN "48K     ": END IF
	IF value = 1 THEN RETURN "128K    ": END IF
	IF value = 2 THEN RETURN "Pentagon": END IF
END FUNCTION

FUNCTION freqDesc(value as UByte) AS String
  RETURN STR$(value)
END FUNCTION

FUNCTION freqDescVert(value as UByte) AS String
	 IF value = 0 THEN RETURN "0-50 48/Pen": END IF
	 IF value = 1 THEN RETURN "1-50 128K  ": END IF
	 IF value = 2 THEN RETURN "2-52       ": END IF
	 IF value = 3 THEN RETURN "3-53       ": END IF
	 IF value = 4 THEN RETURN "4-55       ": END IF
	 IF value = 5 THEN RETURN "5-57       ": END IF
	 IF value = 6 THEN RETURN "6-59       ": END IF
	 IF value = 7 THEN RETURN "7-60       ": END IF
END	FUNCTION




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
		IF JoyKey = 6 THEN LET JoyKey = 0: END IF
		JOYCONF = (JoyDB9AutoFire << 7) bOR (JoyDB9 << 4) bOR (JoyKeyAutoFire << 3) bOR JoyKey
        setZXUnoReg(6,JOYCONF): GO TO joymenu
    END IF
    'Change DB9 joystick mode
	IF a$ = "2" THEN 
		LET JoyDB9 = JoyDB9+1
		IF JoyDB9 = 6 THEN LET JoyDB9 = 0: END IF
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
'***************************        JOYSTICK        ***************************
'******************************************************************************


SUB ScreenAlignmentMenu()
	CLS
	DIM model, HOFFS48K, VOFFS48K, HOFFS128K, VOFFS128K, HOFFSPEN, VOFFSPEN, MASTERCONF as UByte
	LET MASTERCONF =  getZXUnoReg($00)
	LET model = getULATiming(MASTERCONF)
	screenmenu:
	header(): PRINT:PRINT:PRINT
	LET HOFFS48K = getZXUnoReg($80) 
	LET VOFFS48K = getZXUnoReg($81) 
	LET HOFFS128K = getZXUnoReg($82) 
	LET VOFFS128K = getZXUnoReg($83) 
	LET HOFFSPEN = getZXUnoReg($84) 
	LET VOFFSPEN = getZXUnoReg($85)

	
	PRINT
	PRINT "    \{p7}\{i0}M\{p0}\{i7} MODEL: "; modelDesc(model): PRINT
	IF (model=0) THEN
		PRINT "    \{p7}\{i0}Q\{p0}\{i7}-\{p7}\{i0}A\{p0}\{i7} VERTICAL: "; VOFFS48K; "  ": PRINT
		PRINT "    \{p7}\{i0}O\{p0}\{i7}-\{p7}\{i0}P\{p0}\{i7} HORIZONTAL: "; HOFFS48K; "  ": PRINT
	END IF
	IF (model=1) THEN
		PRINT "    \{p7}\{i0}Q\{p0}\{i7}-\{p7}\{i0}A\{p0}\{i7} VERTICAL: "; VOFFS128K; "  ": PRINT
		PRINT "    \{p7}\{i0}O\{p0}\{i7}-\{p7}\{i0}P\{p0}\{i7} HORIZONTAL: "; HOFFS128K; "  ": PRINT
	END IF
	IF (model=2) THEN
		PRINT "    \{p7}\{i0}Q\{p0}\{i7}-\{p7}\{i0}A\{p0}\{i7} VERTICAL: "; VOFFS128K; "  ": PRINT
		PRINT "    \{p7}\{i0}O\{p0}\{i7}-\{p7}\{i0}P\{p0}\{i7} HORIZONTAL: "; HOFFS128K; "  ": PRINT
	END IF

	PRINT "    \{p7}\{i0}B\{p0}\{i7} BACK"
	PRINT
	PRINT "    "; PAPER 5; INK 0; " Reg #80 [ "; BinaryStr(HOFFS48K) ; " ] "
	PRINT "    "; PAPER 5; INK 0; " Reg #81 [ "; BinaryStr(VOFFS48K) ; " ] "
	PRINT "    "; PAPER 5; INK 0; " Reg #82 [ "; BinaryStr(HOFFS128K) ; " ] "
	PRINT "    "; PAPER 5; INK 0; " Reg #83 [ "; BinaryStr(VOFFS128K) ; " ] "
	PRINT "    "; PAPER 5; INK 0; " Reg #84 [ "; BinaryStr(HOFFSPEN) ; " ] "
	PRINT "    "; PAPER 5; INK 0; " Reg #85 [ "; BinaryStr(VOFFSPEN) ; " ] "

	waitkeyScreen:
	LET a$ = inkey$()
	'Toggle model


	IF a$ = "m" THEN 
		LET model = model + 1
		IF model = 3 THEN LET model = 0: END IF
		GO TO screenmenu
    END IF

    'Down
	IF a$ = "a" THEN 
		IF (model=0) THEN LET VOFFS48K = VOFFS48K + 1 : setZXUnoReg($81, VOFFS48K) : END IF
		IF (model=1) THEN LET VOFFS128K = VOFFS128K + 1 : setZXUnoReg($83, VOFFS128K) : END IF
		IF (model=2) THEN LET VOFFSPEN = VOFFSPEN + 1 : setZXUnoReg($85, VOFFSPEN) : END IF
        GO TO screenmenu
    END IF

    'Up
	IF a$ = "q" THEN 
		IF (model=0) THEN LET VOFFS48K = VOFFS48K - 1 : setZXUnoReg($81, VOFFS48K) : END IF
		IF (model=1) THEN LET VOFFS128K = VOFFS128K - 1 : setZXUnoReg($83, VOFFS128K) : END IF
		IF (model=2) THEN LET VOFFSPEN = VOFFSPEN - 1 : setZXUnoReg($85, VOFFSPEN) : END IF
        GO TO screenmenu
    END IF

    'Left
	IF a$ = "o" THEN 
		IF (model=0) THEN LET HOFFS48K = HOFFS48K - 1 : setZXUnoReg($80, HOFFS48K) : END IF
		IF (model=1) THEN LET HOFFS128K = HOFFS128K - 1 : setZXUnoReg($82, HOFFS128K) : END IF
		IF (model=2) THEN LET HOFFSPEN = HOFFSPEN - 1 : setZXUnoReg($84, HOFFSPEN) : END IF
        GO TO screenmenu
    END IF



    'Right
	IF a$ = "p" THEN 
		IF (model=0) THEN LET HOFFS48K = HOFFS48K + 1 : setZXUnoReg($80, HOFFS48K) : END IF
		IF (model=1) THEN LET HOFFS128K = HOFFS128K + 1 : setZXUnoReg($82, HOFFS128K) : END IF
		IF (model=2) THEN LET HOFFSPEN = HOFFSPEN + 1 : setZXUnoReg($84, HOFFSPEN) : END IF
        GO TO screenmenu
    END IF


	IF a$ = "b" THEN LET a$ = "" : RETURN: END IF
	GO TO waitkeyScreen
END SUB  

'******************************************************************************
'***************************          TURBO         ***************************
'******************************************************************************


SUB TurboMenu()
	CLS
	DIM SCANDBLCTRL, TURBO, FREQ, ENSCAN, VGA as UByte
	turbomenu:
	header(): PRINT:PRINT:PRINT
	LET SCANDBLCTRL = getZXUnoReg($0b)
	LET TURBO = (SCANDBLCTRL bAND 11000000b) >> 6
	LET COPT = (SCANDBLCTRL bAND 00100000b) >> 5
	LET FREQ = (SCANDBLCTRL bAND 00011100b) >> 2
	LET ENSCAN = (SCANDBLCTRL bAND 00000010b) >> 1
	LET VGA = SCANDBLCTRL bAND 00000001b 
	
	
	PRINT
	PRINT "    \{p7}\{i0}T\{p0}\{i7} TURBO: "; turboDesc(TURBO): PRINT
	PRINT "    \{p7}\{i0}O\{p0}\{i7}-\{p7}\{i0}P\{p0}\{i7} MASTER FREQ: "; freqDesc(FREQ);: PRINT
	PRINT "        VERT   FREQ: "; freqDescVert(FREQ): PRINT
    PRINT "    \{p7}\{i0}C\{p0}\{i7} COPT:  "; coptDESC(COPT): PRINT 
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
		SCANDBLCTRL = (TURBO << 6) bOR (COPT<<5) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10: GO TO turbomenu
    END IF
    'Change FREQ
	IF a$ = "p" THEN 
		LET FREQ = FREQ + 1
		IF FREQ = 8 THEN LET FREQ = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (COPT<<5) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10:  GO TO turbomenu
    END IF
	IF a$ = "o" THEN 
		LET FREQ = FREQ - 1
		IF FREQ = -1 THEN LET FREQ = 7: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (COPT<<5) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10:  GO TO turbomenu
    END IF
    'Change COPT'
    IF a$ = "c" THEN
    	LET COPT = COPT + 1
    	IF COPT = 2 THEN LET COPT=0: END IF
    	SCANDBLCTRL = (TURBO << 6) bOR (COPT<<5) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
    	setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10: GO TO turbomenu
    END IF
	'Change ENSCAN
	IF a$ = "e" THEN 
		LET ENSCAN = ENSCAN + 1
		IF ENSCAN = 2 THEN LET ENSCAN = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (COPT<<5) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
        setZXUnoReg($0B,SCANDBLCTRL): PAUSE 10: GO TO turbomenu
    END IF
	'Change VGA
	IF a$ = "v" THEN 
		LET VGA = VGA + 1
		IF VGA = 2 THEN LET VGA = 0: END IF
		SCANDBLCTRL = (TURBO << 6) bOR (COPT<<5) bOR (FREQ<<2) bOR (ENSCAN << 1) bOR (VGA)
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
LET c$ = getCOREID()

PRINT:PRINT
PRINT "      \{p7}\{i0}J\{p0}\{i7} JOYSTICK": PRINT
PRINT "      \{p7}\{i0}T\{p0}\{i7} TURBO, VGA & TIMINGS": PRINT
PRINT "      \{p7}\{i0}S\{p0}\{i7} SCREEN ALIGNMENT": PRINT 
PRINT "      \{p7}\{i0}H\{p0}\{i7} HARDWARE SETTINGS": PRINT
PRINT "      \{p7}\{i0}R\{p0}\{i7} RESET": PRINT
PRINT "      \{p7}\{i0}E\{p0}\{i7} EXIT"
LET c$ = getCOREID()
PRINT AT 21,0; INK 7; BRIGHT 0; " CoreID: "; c$


waitkey:
LET a$ = getKey()
IF a$ = "j" THEN JoystickMenu(): GOTO mainmenu: END IF
IF a$ = "t" THEN TurboMenu():goto mainmenu: END IF
IF a$ = "h" THEN HardwareMenu():goto mainmenu: END IF
IF a$ = "s" THEN ScreenAlignmentMenu():goto mainmenu: END IF
IF (a$ <> "e") and (a$<>"r") THEN GO TO waitkey: END IF

IF (a$="r") THEN RANDOMIZE USR 0: END IF

BORDER 7: PAPER 7: INK 0: BRIGHT 0: CLS
STOP
