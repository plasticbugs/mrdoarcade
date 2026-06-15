; ============================================================
;  Mr. Do! Arcade -- COLECO BOOT + RED NOSE build
;  Assemble this with:  TNIASM.exe build_coleco_red_nose.asm
;  Output:              mrdo_arcade_coleco_red_nose.rom
;
;  Combines the ~12s Coleco BIOS boot screen with the TIX
;  red-nose sprites.
; ============================================================

COLECOBOOT:                         ; both flags declared -> both IFDEF blocks true
REDNOSE:
FNAME "mrdo_arcade_coleco_red_nose.rom"
INCLUDE "mrdo_core.asm"
