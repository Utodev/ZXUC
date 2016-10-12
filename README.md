# ZXCU
A menu guided setup utility for ZX-Uno.

It can be compiled as standalone tap file, or as a two file solution with an ESXDOS dot command and a binary file.

Option A: ESXDOS Command + binary file
======================================

BAS file to be compiled with ZX-Basic (http://www.boriel.com/wiki/en/index.php/ZXBasic)

python zxbc.py  ZXUC.BAS -O9 -S 45000

ASM file to be compiled with pasmo:

pasmo zxuc.asm ZXUC

Put both ZXUC and ZXUC.BIN files at you SD card /BIN folder 

Option B: just tap file
=======================

BAS file to be compiled with ZX-Basic (http://www.boriel.com/wiki/en/index.php/ZXBasic)

python zxbc.py ZXUC.BAS -t -o zxuc.tap -a -O9 -B

Put the ZXUC.TAP file wherever you prefer in your SD card

Looking for binaries?
=====================

- Download ZXUC and ZXUC.BIN files and put them in your SDCARD /BIN folder if you want to use ZXUC as .ZXUC ESXDOS dot command. Beware, .ZXUC is not a pure dot command and it will corrupt anything on the memory above address 45000.

- Download ZXUC.TAP and put it wherever you want in your SDCard if you want to use an standalone tap file.