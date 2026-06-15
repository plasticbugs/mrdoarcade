; ============================================================
;  Mr. Do! Arcade -- STOCK build
;  Assemble this with:  TNIASM.exe mrdo_arcade.asm
;  Output:              mrdo_arcade.rom
;
;  This is a thin wrapper: it names the output ROM and pulls in
;  the shared source (mrdo_core.asm). No variant flags are
;  declared, so you get the standard game.
;
;  Other builds (assemble the matching file instead):
;    build_coleco_boot.asm -> mrdo_arcade_coleco_boot.rom
;    build_invincible.asm  -> invincibility_for_qa.rom
; ============================================================

FNAME "mrdo_arcade.rom"
INCLUDE "mrdo_core.asm"
