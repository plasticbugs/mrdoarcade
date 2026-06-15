; ============================================================
;  Mr. Do! Arcade -- COLECO BOOT-SCREEN build
;  Assemble this with:  TNIASM.exe build_coleco_boot.asm
;  Output:              mrdo_arcade_coleco_boot.rom
;
;  Restores the original ~12-second Coleco BIOS title/boot
;  screen. Needed by certain hardware that won't launch the
;  game without it.
; ============================================================

COLECOBOOT:                         ; declared -> IFDEF COLECOBOOT is true in the core
FNAME "mrdo_arcade_coleco_boot.rom"
INCLUDE "mrdo_core.asm"
