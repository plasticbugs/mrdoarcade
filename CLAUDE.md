# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ColecoVision ROM hack of Mr. Do! written in Z80 assembly. Based on Captain Cosmos's disassembly. Single main source file (`mrdo_arcade.asm`, ~14K lines) plus a generated tileset (`tilesetscr2.asm`). Output is a 32KB ROM (`mrdo_arcade.rom`).

## Build

The assembler is a **32-bit DOS application that only runs on Windows**. There is no way to assemble from macOS/Linux. Do not attempt to build — only edit the `.asm` source. The user will build and test separately.

Do **not** read `.rom` files — they are binary.

## ROM Size Constraint

The ROM has a hard limit of **32,768 bytes (32KB)**. Current usage is ~32,491 bytes with ~277 bytes free. Every byte matters — always prefer minimal-byte solutions and note approximate byte cost of changes.

## Architecture

### VDP (TMS9918 — Screen 2 mode)
- Pattern Table: `$0000-$17FF` (3×256×8 bytes)
- Name Table (PNT): `$1800-$1AFF` (3×256 tiles, 32 columns × 24 rows)
- SAT: `$1B00-$1B7F` (sprite attributes, 4 bytes each)
- Color Table: `$2000-$27FF`
- Sprite Pattern Table: `$2800-$2FFF`

### Memory Map
- RAM: `$7000-$73FF` (1KB)
- ROM: `$8000-$FFFF` (32KB)
- Key RAM structures: LEVELMAP (160 bytes, 16×10 playfield), APPLEDATA (5×5 bytes), ENEMY_DATA_ARRAY (7×6 bytes), CHOMPDATA (3×6 bytes)

### Score System (24-bit)
- Internal score × 10 = displayed score (trailing "0" tile appended)
- Storage: `SCORE_Px` (1 byte, high) + `SCORE_Px_RAM` (2 bytes, low 16-bit little-endian)
- Max displayed: 99,999,990 (internal cap 9,999,994 = `$98967A`)
- `num2str24`: converts A:HL → 7 ASCII digits + `"0"+$80` terminator
- `num2str16`: converts HL → 5 ASCII digits + `"0"+$80` terminator
- Tile `$D8` = digit "0"; tile `$00` = blank

### Key BIOS/OS Routines (at fixed ROM addresses)
- `MYPRINT` ($custom): Writes ASCII string at (HL) to VDP address in DE. Terminates on bit 7 set. **Does not modify DE.**
- `PUT_VRAM` ($1FBE): Writes tile data. IY=count, A=mode, DE=VDP addr, HL=data
- `PUTSPRITE`: A=slot, B=Y, C=X, D=frame
- `REQUEST_SIGNAL` ($1FCD): Timer setup, HL=duration (frames), returns timer ID in A
- `TEST_SIGNAL` ($1FD0): Check timer, A=ID, returns NZ when expired
- `PEEKMAP`: B=Y, C=X → IX=pointer into LEVELMAP, A/D=tile data
- `SUB_9F29`: Returns open tunnel directions as bitmask (bit4=up, bit5=down, bit6=right, bit7=left)

### Data Structure Coordinate Conventions
Apple data (IX): `IX+0`=flags, `IX+1`=**Y**, `IX+2`=**X** (Y first)
Enemy/Chomper data (IY): `IY+1`=**X**, `IY+2`=**Y** (X first — **inverted from apples**)

### Intermission Screens
- **VERY GOOD**: Every 3rd level (not multiples of 10). Shows per-level score/time/icon for 3 levels.
- **WONDERFUL**: Every 10th level. Shows one level's stats plus total score and average.
- Screen positions flow through functions via DE register: `PRINT_SINGLE_SCORE` → `PRINT_SINGLE_TIME` → `PRINT_ICON`. Changing offsets in one function affects all downstream positions including sprite X coordinates.

### Entity System
- `GET_SLOT_OFFSET`: Returns ×2 byte offset (0, 2, or 4) for the 3-level slot system. Used by timers (2 bytes/slot), icons (1 byte/slot), and scores (3 bytes/slot — callers handle ×3 locally).
- Regular enemies use `SUB_9E7C`/`SUB_9F29` for wall-respecting pathfinding
- Digger enemies and chompers use `SUB_A460`/`SUB_A497` for direct-toward-Mr.Do pathfinding (ignores walls)
- Bit 4 of entity flags (IY+0) = digger/chomper type
