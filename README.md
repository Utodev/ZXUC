# ZXCU
A menu guided setup utility for ZX-Uno and settings set configurator. Allows to change several settings in the ZX-Uno on the fly, without reseting, and allows saving those sets and restore them later.

Compile options
===============

BAS file to be compiled with ZX-Basic (http://www.boriel.com/wiki/en/index.php/ZXBasic)

python zxbc.py  ZXUC.BAS -O9 -S 45000

ASM files to be compiled with pasmo:

pasmo zxuc.asm ZXUC
pasmo zxucsave.asm ZXUCSAVE

Put all ZXUC, ZXUCSAVE and ZXUC.BIN files at you SD card /BIN folder 

Usage
=====
- You can call the GUI by typing

.zxuc

- You can save the current settings by typing 

.zxucsave xxxxxxxx

where xxxxxxxx is a string with up to 8 characters valid for a file name.

- You can restore  previously saved settings typing:

.zxuc xxxxxxxx

- Setting files are stored at /SYS/CONFIG/ZXUCCFG folder.

