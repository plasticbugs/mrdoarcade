# Mr. Do Arcade ColecoVision Rom Hack

For folks not familiar with GitHub: Click on the [`mrdo_arcade.rom`](https://github.com/plasticbugs/mrdoarcade/blob/main/mrdo_arcade.rom) link in the list of files here and click the "RAW" button to get the ROM. Play it in your favorite ColecoVision emulator or load it onto a CV Flash Cart and play it on a real ColecoVision.

This work is based on the original Mr. Do game for the ColecoVision and was made possible by the disassembly work done by Captain Cosmos on the Atari Age forums. HUGE shout out to @artrag and @TIX for lending their time and their talents to this project!

![Image](https://github.com/user-attachments/assets/a61487c0-2615-482a-aa27-a5e45f052400)

Changes:
- Arcade Title screen
- Redesigned sprites (created by TIX@AtariAge)
- Full screen image intermission for Extra Mr. Do
- Full screen "Very Good" intermission with music every 3rd, 6th and 9th rounds
- Extra Mr. Do tune (Astro Boy theme song)
- Main background music (the Can Can song)
- Lose a life jingle
- End of round jingle
- "Extra" letter mode/chomper jingle
- Screen stays red for "Extra" alphamonster/chomper mode
- Updated collision detection so Mr. Do doesn't get stuck after intersecting an apple from above or below!
 - Fix final two notes in the "game over" tune
- Two-color Mr. Do sprite with four frames of animation
- Updated phase colors/patterns to match arcade levels
- Ball cool down removed during alpha monster mode.
- Move to screen 2 the game to have high res colors for the playfiled
- improve SAT management to reduce the flickering (5th sprite issue) and reduce the ram usage 
- Add animations for vertical movements of chompers
- Add pushing animations for bad guys
- Icon marker for "how" level was completed on "Very Good" screen
- Wonderful screen every 10th level that shows average score per level along with score and time data for the previous level.
- displays a 500 sign after a set of cherries has been collected 
- a credits screen to be activated by a secret combo of keys
- extended to 24 bits the score (previously at 16 bit)
- average time to complete each level displayed on Wonderful screen

Wish list/To do list:
- display a 1000 signs after an enemy has been smashed by an apple
- cap chomper's max speed after level 11 (or make them walk in tunnels only)
- add patterns to leftover tiles to match those of the play field
- add an alternative version of MrDo's sprites as Snowman to be activated by a secret combo of keys

## Building from source

The ROM is assembled with **tniASM 0.45** (`TNIASM.EXE`) — a 32‑bit DOS assembler, so it only runs under DOS/Windows (e.g. a Windows VM or DOSBox). The full game source lives in **`mrdo_core.asm`** (plus the generated tileset `tilesetscr2.asm`).

There are several build variants. Each is produced by assembling a small **wrapper file** — the wrapper sets the output ROM name and a build flag, then includes the shared core. Run the assembler on the wrapper for the build you want:

| Command | Output ROM | Description |
| --- | --- | --- |
| `TNIASM.EXE mrdo_arcade.asm` | `mrdo_arcade.rom` | Standard game |
| `TNIASM.EXE build_red_nose.asm` | `mrdo_arcade_red_nose.rom` | Alternate red‑nose Mr. Do sprites (by TIX) |
| `TNIASM.EXE build_coleco_boot.asm` | `mrdo_arcade_coleco_boot.rom` | Restores the original ~12‑second Coleco BIOS title/boot screen (needed by some hardware) |
| `TNIASM.EXE build_coleco_red_nose.asm` | `mrdo_arcade_coleco_red_nose.rom` | Coleco boot screen **and** red‑nose sprites |
| `TNIASM.EXE build_invincible.asm` | `invincibility_for_qa.rom` | QA build — Mr. Do ignores all enemy collisions (not for release) |

To change the game itself, edit `mrdo_core.asm` — the wrappers are thin and the variant differences are gated with `IFDEF` (`COLECOBOOT` / `REDNOSE` / `INVINCIBLE`). To add a new variant, copy a `build_*.asm` wrapper, give it a new `FNAME` and flag, and wrap the differing lines in the core with `IFDEF <FLAG> … ELSE … ENDIF`.

