; ============================================================
;  Mr. Do! Arcade -- INVINCIBLE QA build
;  Assemble this with:  TNIASM.exe build_invincible.asm
;  Output:              invincibility_for_qa.rom
;
;  Disables Mr. Do <-> enemy collision (SUB_9FC8 returns "no
;  collision" immediately). For QA only -- do not ship.
; ============================================================

INVINCIBLE:                         ; declared -> IFDEF INVINCIBLE is true in the core
FNAME "invincibility_for_qa.rom"
INCLUDE "mrdo_core.asm"
