# ZXCU
A menu-guided setup utility for ZX-Uno and settings set configurator.
Provides methods to change several ZX-Uno settings on the fly, without reseting, and allows those settings to be saved and restored.

## Build instructions
* Compile the BAS file with [ZX-Basic](http://www.boriel.com/wiki/en/index.php/ZXBasic) (requires Python to run):

  `python zxbc.py ZXUC.BAS -O9 -S 45000`

* Compile the ASM files with [Pasmo](http://pasmo.speccy.org/):

  `pasmo zxuc.asm ZXUC`
  `pasmo zxucsave.asm ZXUCSAVE`

* Copy the `ZXUC`, `ZXUCSAVE` and `ZXUC.BIN` files in the `/BIN` folder of your SD card. 

## Usage
* Launch the GUI:

  `.zxuc`

* Save the current settings to the named file (normal filename restrictions apply):

  `.zxucsave filename`

* Restore previously saved settings:

  `.zxuc filename`

Settings files are stored in the `/SYS/CONFIG/ZXUCCFG` folder.
