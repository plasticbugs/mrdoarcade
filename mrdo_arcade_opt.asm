; BASED ON THE  ASM CODE DISASSEMBLY OF MR. DO! BY CAPTAIN COSMOS (November 10, 2023)
;
; About moving the game to screen 2.... 
; The layout of the VRAM in the original game is:
; 
; Pattern Table: 	0000h-07FFh (256*8 bytes in screen 1)
; Name Table: 		1000h-12FFh - 256*3 tiles
; Color Table: 		1800h (32 bytes)
; SAT: 				1900h
; SPT: 				2000h (256*8 bytes)

; in game VRAM tables
; PT:		EQU	$0000
; PNT:		EQU	$1000
; CT:		EQU	$1800
; SAT:		EQU	$1900
; SPT:		EQU	$2000

; VRAM areas used for data
; 3400H		212 bytes for saving P1 game data
; 3600H		212 bytes for saving P2 game data
; 3800h 	768 bytes for alternative PNT during pause
; 3B00H		93 bytes for sound data

; Possible screen 2 layout
; Pattern Table: 	0000h-17FFh (3*256*8 bytes in screen 2)
; Name Table: 		1800h-1AFFh (3*256 tiles)
; SAT:				1B00h-1B7Fh (4*32 bytes)
; Color Table: 		2000h-27FFh (256*8 bytes - screen 2 mirrored)
; SPT: 				2800h-2FFFh (256*8 bytes)

pt: equ $0000
pnt: equ $1800
ct: equ $2000
sat: equ $1B00
spt: equ $2800



; BIOS DEFINITIONS **************************
ascii_table: equ $006A
number_table: equ $006C
play_songs: equ $1F61

fill_vram: equ $1F82
init_table: equ $1FB8
put_vram: equ $1FBE
init_spr_nm_tbl: equ $1FC1
wr_spr_nm_tbl: equ $1FC4
init_timer: equ $1FC7
free_signal: equ $1FCA
request_signal: equ $1FCD
test_signal: equ $1FD0
time_mgr: equ $1FD3
write_register: equ $1FD9
read_register: equ $1FDC
write_vram: equ $1FDF
read_vram: equ $1FE2
poller: equ $1FEB
sound_init: equ $1FEE
play_it: equ $1FF1
sound_man: equ $1FF4
rand_gen: equ $1FFD

; VDP
data_port: equ $00BE
ctrl_port: equ $00BF


coleco_title_on: equ $55AA
coleco_title_off: equ $AA55


; SOUND DEFINITIONS *************************
opening_tune_snd_0a: equ $01
background_tune_0a: equ $02
opening_tune_snd_0b: equ $03
background_tune_0b: equ $04
grab_cherries_snd: equ $05
bouncing_ball_snd_0a: equ $06
bouncing_ball_snd_0b: equ $07
ball_stuck_snd: equ $08
ball_return_snd: equ $09
apple_falling_snd: equ $0A
apple_break_snd_0a: equ $0B
apple_break_snd_0b: equ $0C
no_extra_tune_0a: equ $0D
no_extra_tune_0b: equ $0E
no_extra_tune_0c: equ $0F
diamond_snd: equ $10
extra_walking_tune_0a: equ $11
extra_walking_tune_0b: equ $12
game_over_tune_0a: equ $13
game_over_tune_0b: equ $14
win_extra_do_tune_0a: equ $15
win_extra_do_tune_0b: equ $16
end_of_round_tune_0a: equ $17
end_of_round_tune_0b: equ $18
lose_life_tune_0a: equ $19
lose_life_tune_0b: equ $1A
blue_chomper_snd_0a: equ $1B
blue_chomper_snd_0b: equ $1C
very_good_tune_0a: equ $1D
very_good_tune_0b: equ $1E
very_good_tune_0c: equ $1F
sfx_coin_insert_snd: equ $20


; RAM DEFINITIONS ***************************
    org $7000
sprite_order_table:
    org $ + 20  ;EQU $7000	; used by the sprite rotation system
timer_data_block:
    org $ + 12  ;EQU $7014
statestart:
    org $ + 11  ;EQU $7020 	; Sound Buffer Start
sound_bank_01_ram:
    org $ + 10  ;EQU $702B
sound_bank_02_ram:
    org $ + 10  ;EQU $7035
sound_bank_03_ram:
    org $ + 10  ;EQU $703F
sound_bank_04_ram:
    org $ + 10  ;EQU $7049
sound_bank_05_ram:
    org $ + 10  ;EQU $7053
sound_bank_06_ram:
    org $ + 10  ;EQU $705D
sound_bank_07_ram:
    org $ + 10  ;EQU $7067
sound_bank_08_ram:
    org $ + 10  ;EQU $7071
sound_bank_09_ram:
    org $ + 10  ;EQU $707B

    org $ + 1  ; ??

controller_buffer:
    org $ + 6  ;EQU $7086
keyboard_p1:
    org $ + 1  ;EQU $708C

    org $ + 4  ;EQU $708D ?? some kind of struct used in SUB_94A9
keyboard_p2:
    org $ + 1  ;EQU $7091

    org $ + 12  ;EQU $7092 ??
timer_table:
    org $ + 75  ;EQU $709E
sprite_name_table:
    org $ + 80  ;EQU $70E9	; SAT

badguy_bhvr_cnt_ram:
    org $ + 1  ;EQU $7139 ; HOW MANY BYTES IN TABLE
badguy_behavior_ram:
    org $ + 28  ;EQU $713A ; BEHAVIOR TABLE. UP TO 7*4=28 ELEMENTS

    org $ + 52  ; ??
gamestate:
    org $ + 160  ;EQU $718A ; Level (16x10) and game state (52 bytes) total 212 byte saved in VRAM

    org $ + 2  ;EQU $722A
appledata:
    org $ + 25  ;EQU $722C ; Apple sprite data 5x5 bytes

    org $ + 25  ;EQU $7245

    org $ + 16  ;EQU $725E ; ??
gamecontrol:
    org $ + 1  ;EQU $726E ; GAME CONTROL BYTE (All bits have a meaning!) B0->1/2 Players B5-> Pause/Game
gametimer:
    org $ + 1  ;EQU $726F  ??

    org $ + 1  ; ??
skilllevel:
    org $ + 1  ;EQU $7271 ; Skill Level 1-4

    org $ + 1  ; ??
diamond_ram:
    org $ + 1  ;EQU $7273
current_level_p1:
    org $ + 1  ;EQU $7274
current_level_p2:
    org $ + 1  ;EQU $7275
lives_left_p1_ram:
    org $ + 1  ;EQU $7276
lives_left_p2_ram:
    org $ + 1  ;EQU $7277
enemy_num_p1:
    org $ + 1  ;EQU $7278 Initialised at 7 by LOC_8573
enemy_num_p2:
    org $ + 1  ;EQU $7279 Initialised at 7 by LOC_8573

    org $ + 2  ;EQU $727A ?? 

    org $ + 1  ;EQU $727C FLAG about SCORE ???

score_p1_ram:
    org $ + 2  ;EQU $727D ;  $727D/7E	2 BYTES SCORING FOR PLAYER$1. THE LAST DIGIT IS A RED HERRING. I.E. 150 LOOKS LIKE 1500.  SCORE WRAPS AROUND AFTER $FFFF (65535)
score_p2_ram:
    org $ + 2  ;EQU $727F ;  $727F/80	2 BYTES SCORING FOR PLAYER$2
mrdo_data:
    org $ + 3  ;EQU $7281 ;+0	; Mr. Do's sprite data
mrdo_data.y:
    org $ + 1  ;EQU $7284 ;+3
mrdo_data.x:
    org $ + 1  ;EQU $7285 ;+4
mrdo_data.frame:
    org $ + 1  ;EQU $7286 ;+5

    org $ + 1  ;EQU $7287 ;+6

    org $ + 1  ;EQU $7288 ;+7

    org $ + 5  ;EQU $7289	; ??
enemy_data_array:
    org $ + 49  ;EQU $728E	; enemy data starts here = 7*6 bytes (7 enemies)

    org $ + 4  ;EQU $72BE	??
gameflags:
    org $ + 1  ;EQU $72C3	Game Flag B7 = chomper mode, B0 ???

    org $ + 2  ;??
timerchomp1:
    org $ + 1  ;EQU $72C6  Game timer chomper mode
chompdata:
    org $ + 18  ;EQU $72C7  3x6 = 18 bytes (3 chompers)
balldata:
    org $ + 6  ;EQU $72D9
satbuff1:  ; MULTIPLE USE
sptbuff1:
    org $ + 8  ;EQU $72DF	; ?? SPT buffer
satbuff2:  ; MULTIPLE USE
sptbuff2:
    org $ + 8  ;EQU $72E7	; ?? SPT buffer
work_buffer:
    org $ + 24  ;EQU $72EF
work_buffer2:
    org $ + 24  ;EQU $7307	; ??
savebuff:
    org $ + 16  ;EQU $731F	;  Free ram ??
freebuff:
    org $ + 16  ; work ram

defer_writes: equ $73C6  ; System flag

mode: equ $73FD  ; maybe unused used by OS 
; B0==0 -> ISR Enabled, B0==1 -> ISR disabled
; B1==0 -> ISR served 	B1==1 -> ISR pending
; B3-B6 spare
; B7==0 -> game mode, 	B7==1 -> intermission mode



;	CPU Z80


    org $8000

    dw coleco_title_on  ; SET TO COLECO_TITLE_ON FOR TITLES, COLECO_TITLE_OFF TO TURN THEM OFF
    dw sprite_name_table
    dw sprite_order_table
    dw work_buffer
    dw controller_buffer
    dw start

; RST 08H vector
; RST 10H vector
; RST 20H vector
; RST 28H vector
; RST 30H vector
; RST 38H vector
    ds 20, 0
    ret
    jp nmi_handler

    db "MR. DO!", $1E, $1F
    db "/PRESENTS UNIVERSAL'S/1983"

nmi:
    push af
    push bc
    push de
    push hl
    ex af, af'
    exx
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    ld bc, $01C2
    call write_register
    call read_register
    ld hl, work_buffer
    ld de, work_buffer2
    ld bc, $18
    ldir
    ld hl, gamecontrol
    bit 5, (hl)
    jr z, loc_807e
    bit 4, (hl)
    jr z, loc_809f
    ld a, $14
    call wr_spr_nm_tbl
    call sub_8107
    jr loc_809f
loc_807e:
    ld a, (gamecontrol)
    bit 3, a
    jr nz, loc_808d
    ld a, $14
    call wr_spr_nm_tbl
    call sub_8107
loc_808d:
;     call sub_80d1  ; -mdl

sub_80d1:
    ld hl, $7259
    ld bc, $1401  ; B = 20 sprites
loc_80d7:
    ld a, (hl)
    and a
    jr z, loc_80ff
    ld e, c
    push bc
loc_80dd:
    push hl
    push de
    ld hl, $7259
    ld a, e
    call sub_ac0b
    jr z, loc_80f7
    pop de
    push de
    ld hl, $7259
    ld a, e
    call sub_abf6
    pop de
    push de
    ld a, e
    call display_play_field_parts
loc_80f7:
    pop de
    inc e
    pop hl
    ld a, (hl)
    and a
    jr nz, loc_80dd
    pop bc
loc_80ff:
    ld a, c
    add a, 8
    ld c, a
    inc hl
    djnz loc_80d7
;     ret  ; -mdl
    call sub_8229  ; UPDATE MR DO SPRITE
    call sub_8251
    call display_extra_01
    call sub_82de
    call time_mgr
loc_809f:
    call poller
    call sub_c952  ; PLAY MUSIC
    ld hl, work_buffer2  ; related to sprite rotation
    ld de, work_buffer
    ld bc, $18
    ldir
    ld hl, gamecontrol
    bit 7, (hl)
    jr z, loc_80bb
    res 7, (hl)
    jr finish_nmi
loc_80bb:
    ld bc, $01E2
    call write_register
finish_nmi:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    exx
    ex af, af'
    pop hl
    pop de
    pop bc
    pop af
    retn

sub_8107:  ; sprite rotation system: Very cumbersome and applied only to enemies
    ld hl, byte_8215
    ld de, work_buffer
    ld bc, $14  ; only 20 sprites on screen = 7 enemies + 3 chompers + 5 apples + 1 letter + 1 ball + 2 MrDo + 1 diamond
    ldir
    ld a, 3
    ld ($72E7), a
    ld a, $13
    ld ($72E8), a
    ld hl, $72F2
    ld iy, $70F5
    ld b, $11  ; number of actual sprites rotated. Sprites from 0 to 3 are fixed (MrDo and letter)
loc_8125:  ; PROBABLY INTRODUCING IN THE ROTATION MRDO's SPRITES WOULD IMPROVE THE FINAL RESULT
    ld a, (hl)
    and a
    jp nz, loc_81dc
    ld a, (iy + 0)
    cp $10
    jr nc, loc_813c
    ld a, ($72E7)
    ld (hl), a
    inc a
    ld ($72E7), a
    jp loc_81dc
loc_813c:
    push bc
    push hl
    push iy
    ld de, 0
    ld c, (iy + 0)
    ld a, ($726D)
    res 6, a
    ld ($726D), a
    and 3
    cp 1
    jr c, loc_81a1
    jr nz, loc_816f
    ld d, 4
    ld a, ($70ED)
    sub c
    jr nc, loc_8160
    cpl
    inc a
loc_8160:
    cp $10
    jr nc, loc_81a1
    ld a, ($726D)
    set 6, a
    ld ($726D), a
    dec d
    jr loc_81a1
loc_816f:
    ld d, 8
    ld a, ($70ED)
    sub c
    jr nc, loc_8179
    cpl
    inc a
loc_8179:
    cp $10
    jr nc, loc_81a1
    ld a, ($726D)
    set 6, a
    ld ($726D), a
    ld d, 6
    jr loc_81a1
loc_81b6:
    ld a, ($72E8)
    ld (hl), a
    dec a
    ld ($72E8), a
; 	JR		LOC_8189  ; -mdl
loc_8189:
    dec b
    jr z, loc_81c0
    inc hl
    inc iy
    inc iy
    inc iy
    inc iy
    ld a, (iy + 0)
    sub c
    jr nc, loc_819d
    cpl
    inc a
loc_819d:
    cp $10
    jr nc, loc_8189
loc_81a1:
    inc e
    ld a, (hl)
    and a
    jr nz, loc_8189
    ld a, e
    cp d
    jr c, loc_81b6
    jr z, loc_81b6
    ld a, ($72E7)
    ld (hl), a
    inc a
    ld ($72E7), a
    jr loc_8189
loc_81c0:
    ld a, e
    cp 9
    jr nc, loc_81d0
    cp 7
    jr c, loc_81d8
    ld a, ($726D)
    bit 6, a
    jr z, loc_81d8
loc_81d0:
    ld a, ($726D)
    set 7, a
    ld ($726D), a
loc_81d8:
    pop iy
    pop hl
    pop bc
loc_81dc:
    inc hl
    inc iy
    inc iy
    inc iy
    inc iy
    dec b
    jp nz, loc_8125
    ld hl, $726D
    ld a, (hl)
    inc a
    and 3
    cp 2
    jr c, loc_81fb
    jr nz, loc_81fa
    bit 7, (hl)
    jr nz, loc_81fb
loc_81fa:
    xor a
loc_81fb:
    ld ($726D), a
    ld de, sprite_order_table
    ld b, $14
    ld iy, work_buffer
    xor a
    ld c, a
loop_8208:
    ld h, a
    ld l, (iy + 0)
    add hl, de
    ld (hl), c
    inc c
    inc iy
    djnz loop_8208
    ret

byte_8215:
    db 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

sub_8229:
    ld hl, mrdo_data  ; Mr. Do's sprite data
    bit 7, (hl)
    ret z
    res 7, (hl)
    ld d, 1
    ld a, (mrdo_data.frame)  ; if >0 update the MrDo sprite (CURRENT FRAME ?)
    and a
    jr z, loc_8241
; 1 walk right01
; 2 walk right02
; 3 PUSH right01
; 4 PUSH right02
; 
    add a, $1B  ; MrDo Position offeset = 27+1 in SPRITE_GENERATOR
    ld iy, 8  ; number of 8x8 tiles to process (8 <=> 2 layers)
    call deal_with_sprites  ; rotate the current frame of the player

    ld d, 0
loc_8241:
    ld hl, (mrdo_data.y)  ; HL = MrDo's X,Y
    dec l
    ld b, l
    ld c, h
    ld a, $81
    call sub_b629  ; put sprite A at BC = Y-1	,X with step D

; HACK TO ADD A SECOND COLOR LAYER
    ld hl, sprite_name_table + 8
    ld a, (ix + 2)
    cp 148  ; smashed player
    jp nz, loc_8241.patch  ; patch only if the player is not smashed
    ld (hl), 209  ; hide the second layer if player is smashed
    ret
loc_8241.patch:
    ld a, (ix + 0)
    ld (hl), a
    inc hl
    ld a, (ix + 1)
    ld (hl), a
    inc hl
    ld (hl), 45 * 4
    inc hl
    ld (hl), 15
    ret

sub_8251:
    ld hl, $727C
    bit 7, (hl)
    jr z, loc_825d
    res 7, (hl)
    xor a
    jr loc_8265
loc_825d:
    bit 6, (hl)
    ret z
    res 6, (hl)
    ld a, 1
loc_8265:
    jp patterns_to_vram

display_extra_01:
    ld a, ($72BC)
    and a
    jr z, loc_82aa
    ld hl, byte_82d3
    ld de, $2B
    ld bc, extra_01_txt
loc_8278:
    rrca
    jr c, loc_8282
    inc hl
    inc hl
    inc de
    inc de
    inc bc
    jr loc_8278
loc_8282:
    ld a, ($72BC)
    and (hl)
    ld ($72BC), a
    inc hl
    ld a, (gamecontrol)
    bit 1, a
    ld a, ($72B8)
    jr z, loc_8297
    ld a, ($72B9)
loc_8297:
    and (hl)
    ld hl, 0
    jr z, loc_82a0
    ld l, 5
loc_82a0:
    add hl, bc
    ld a, 2
    ld iy, 1
    call put_vram
loc_82aa:
    ld a, ($72BB)
    and a
    ret z
    ld hl, byte_82d3
    ld de, $2B
loc_82b6:
    rrca
    jr c, loc_82bf
    inc hl
    inc hl
    inc de
    inc de
    jr loc_82b6
loc_82bf:
    ld hl, $72BB
    ld a, (hl)
    and (hl)
    ld (hl), a
    ld hl, byte_82dd
    ld a, 2
    ld iy, 1
    jp put_vram

byte_82d3:
    db 254, 1, 253, 2, 251, 4, 247, 8, 239, 16
byte_82dd:
    db 0

sub_82de:
    ld hl, $7272
    bit 0, (hl)
    jr z, loc_8305
    res 0, (hl)
    ld a, (gamecontrol)
    bit 1, a
    ld a, (current_level_p1)
    jr z, loc_82f4
    ld a, (current_level_p2)
loc_82f4:
    dec a
    cp $0A
    jr c, loc_82fb
    ld a, 9
loc_82fb:
    ld hl, bonus_obj_list
    ld c, a
    ld b, 0
    add hl, bc
    ld a, (hl)
    jr loc_830d
loc_8305:
    bit 1, (hl)
    jr z, loc_8310
    res 1, (hl)
    ld a, $0E
loc_830d:
    call deal_with_playfield
loc_8310:
    ld hl, diamond_ram
    bit 7, (hl)
    ret z
    ld ix, appledata
    ld b, (ix + 1)
    ld c, (ix + 2)
    ld d, 0
    bit 0, (hl)
    jr nz, loc_8329
    ld d, 4
loc_8329:
    ld a, (hl)
    xor 1
    ld (hl), a
    ld a, $8D
    jp sub_b629

; BONUS ITEM LIST
bonus_obj_list:
    db 10, 11, 12, 13, 16, 17, 18, 19, 20, 21

start:
    ld hl, $7000  ; clean user ram
    ld de, $7000 + 1
    ld (hl), l
    ld bc, $03B0 - 1
    ldir
    ld hl, mode
    ld (hl), b

    ld a, 1
    ld (defer_writes + 1), a
    ld a, b
    ld (defer_writes), a
    call initialize_the_sound
    ld a, $14
    call init_spr_nm_tbl
    ld hl, timer_table
    ld de, timer_data_block
    call init_timer
    ld hl, controller_buffer
    ld a, $9B
    ld (hl), a
    inc hl
    ld (hl), a

loc_8372:
; DEBUGGER
; CALL 	EXTRASCREEN		; TEST EXTRA MRDO SCREEN
; CALL 	INTERMISSION	; TEST INTERMISSION
; CALL 	CONGRATULATION	; CONGRATULATION

; Initialize the game

    call cvb_animatedlogo
    call init_vram
    xor a
loc_8375:  ; GAME MAIN LOOP
    call sub_84f8
loc_8378:
    call sub_8828
    call deal_with_apple_falling
    cp 1
    jr z, loc_83ab
    and a
    jr nz, loc_83cb
    call deal_with_ball
    and a
    jr nz, loc_83cb
    call leads_to_cherry_stuff
    and a
    jr nz, loc_83cb
    call sub_a7f4
    and a
    jr nz, loc_83ab
    call sub_9842
    cp 1
    jr z, loc_83ab  ; if Z MrDo collided an enemy
    and a
    jr nz, loc_83cb
    call sub_a53e
    and a
    jr z, loc_8378
    cp 1
    jr nz, loc_83cb
loc_83ab:

; animate here the MrDo death
    call mrdodeathsequence

loc_83abx:
    ld ix, appledata  ; apple data array
    ld b, 5  ; apple number
loop_83b1:  ; MrDo is dead, let apples fall if any
    bit 3, (ix + 0)
    jr nz, loc_83c0  ; if this apple is falling make it fall
    ld de, 5
    add ix, de
    djnz loop_83b1  ; ?? probably only one apple falling at time...

loc_83c5:
    and a  ; if Z you have an extra MrDo ?
    jr nz, loc_83cb
    ld a, 1
loc_83cb:
    call got_diamond  ; this is dealing with more than Diamonds
    cp 3
    jr z, loc_8372
    jr loc_8375
loc_83c0:
    call deal_with_apple_falling
    jr loc_83abx

mrdodeathsequence:
    push af
    ld bc, 4 * 256 + 28 + 48  ; C is the pointer to the current frame
mrdodeathsequence.nextframe:
    push bc
    ld hl, 20  ; 20 x 4 = 80 /60 = 1.33 sec
    xor a
    call request_signal
    push af
mrdodeathsequence.wait:

    ld ix, appledata  ; apple data array
    ld b, 5  ; apple number
mrdodeathsequence.nextapple:  ; MrDo is dead, let apples fall if any
    bit 3, (ix + 0)
    push ix
    push bc
    call nz, deal_with_apple_falling  ; if this apple is falling make it fall
    pop bc
    pop ix
    ld de, 5
    add ix, de
    djnz mrdodeathsequence.nextapple

    pop af
    push af
    call test_signal
    and a
    jr z, mrdodeathsequence.wait
    pop af
    pop bc
    ld a, c
    inc c
    push bc
    ld iy, 8  ; number of 8x8 tiles to process (8 <=> 2 layers)
    call deal_with_sprites  ; Update the current frame of the player
    pop bc
    djnz mrdodeathsequence.nextframe
    pop af
    ret

init_vram:
    ld bc, 0
    call write_register
    ld bc, $01C2
    call write_register
    ld bc, $0700
    call write_register

    ld hl, ct  ; avoid glitches during screen transition
    ld de, 256 * 3
    xor a  ; CLEAR CT
    call fill_vram

    xor a  ; SAT
    ld hl, sat
    call init_table
    ld a, 1  ; SPT
    ld hl, spt
    call init_table
    ld a, 2  ; PNT
    ld hl, pnt
    call init_table
    ld a, 3  ; PT
    ld hl, pt
    call init_table
    ld a, 4  ; CT
    ld hl, ct
    call init_table

    ld hl, 0
    ld de, $2000
    xor a  ; CLEAR PT,PNT,SAT
    call fill_vram


    ld a, $1B  ; Load enemies in the SPT
load_graphics:
    push af
    ld iy, 4  ; number of 8x8 tiles to process 
    call deal_with_sprites
    pop af
    dec a
    jp p, load_graphics
    ld hl, extra_sprite_pat
    ld de, $60
    ld iy, $40
    ld a, 1
    call put_vram
    ld hl, ball_sprite_pat
    ld de, $00C0
    ld iy, $18
    ld a, 1
    call put_vram

    call mydisscr  ; LOAD ARCADE FONTS

; screen 2 hack

    call mynmi_off
    ld bc, $0200  ; move to screen 2
    call mywrtvdp
    ld bc, $9F03
    call mywrtvdp  ; color mirrored at 2000h
    ld bc, $0304  ; $0304 for non mirrored patterns ar 0000h, $0004 for mirrored patterns
    call mywrtvdp

; load graphics	
;  IS UNPACK SAFE ONLY IN INTREMISSION MODE ?
    ld de, pt
    ld hl, tileset_bitmap
    call unpack
    ld de, pt + 256 * 8
    ld hl, tileset_bitmap
    call unpack
    ld de, pt + 256 * 8 * 2
    ld hl, tileset_bitmap
    call unpack

    ld de, ct
    ld hl, tileset_color
    call unpack

; load fonts	
    ld de, pt + 8 * $00D7  ; start fonts here
    ld hl, arcadefonts
    call unpack
    ld de, pt + 256 * 8 + 8 * $00D7  ; start fonts here
    ld hl, arcadefonts
    call unpack
    ld de, pt + 256 * 8 * 2 + 8 * $00D7  ; start fonts here
    ld hl, arcadefonts
    call unpack


    ld b, 64
    ld de, ct + 6 * 32 * 8
load_graphics.1:    push bc
    ld hl, fontcolor
    ld bc, 8
    push de
    call mynmi_off
    call myldirvm
    call mynmi_on
    pop de
    ld hl, 8
    add hl, de
    ex de, hl
    pop bc
    djnz load_graphics.1

    jp myenascr

fontcolor:
    db $41, $41, $71, $E1, $F1, $71, $41, $41


sub_84f8:  ; Disables NMI, sets up the game
    push af
    ld hl, gamecontrol
    set 7, (hl)
loc_84fe:
    bit 7, (hl)
    jr nz, loc_84fe
    pop af
    push af
    and a
    call z, sub_851c
    call sub_8585
    pop af
    cp 2
    call nz, clear_screen_and_sprites_01
    call clear_screen_and_sprites_02
    jp sub_87f4

sub_851c:  ; If we're here, the game just started
    ld hl, 0
    ld (score_p1_ram), hl
    ld (score_p2_ram), hl
    ld a, 1  ; Set the starting level to 1
    ld (current_level_p1), a
    ld (current_level_p2), a
    xor a
    ld ($727A), a
    ld ($727B), a
    ld a, (skilllevel)
    cp 2
    ld a, 3  ; Set the number of lives to 3
    jr nc, loc_853f
    ld a, 5  ; Set the number of lives to 5
loc_853f:
    ld (lives_left_p1_ram), a
    ld (lives_left_p2_ram), a
    ld hl, gamecontrol
    ld a, (hl)
    and 1
    ld (hl), a
    ld a, 1
    call sub_b286  ; build level 1
    ld hl, gamestate
    ld de, $3400  ; VRAM area for P1 data
    ld bc, $00D4  ; save in VRAM 212 bytes of game state for P1 
    call write_vram
    ld hl, gamestate
    ld de, $3600  ; VRAM area for P2 data
    ld bc, $00D4  ; save in VRAM 212 bytes of game state for P2 
    call write_vram
    call sub_866b
    ld hl, $72B8
    ld b, $0B
    xor a
loc_8573:
    ld (hl), a
    inc hl
    djnz loc_8573
    ld a, 8
    ld ($72BA), a
    ld a, 7  ; Enemy Number
    ld (enemy_num_p1), a
    ld (enemy_num_p2), a
    ret

sub_8585:
    xor a
    ld (balldata), a
    ld ($72DD), a
    ld ($7272), a
    ld (diamond_ram), a
    ld hl, gamecontrol
    res 6, (hl)
    ld a, (hl)
    ld de, $3400
    bit 1, a
    jr z, loc_85a4
    set 1, d
loc_85a4:
    ld hl, gamestate
    ld bc, $00D4
    call read_vram
    xor a
    ld (badguy_bhvr_cnt_ram), a
    ld hl, badguy_behavior_ram
    ld b, $50
loc_85b6:
    ld (hl), a
    inc hl
    djnz loc_85b6
    ld a, (gamecontrol)
    bit 1, a
    ld a, (current_level_p1)
    jr z, loc_85c7
    ld a, (current_level_p2)
loc_85c7:
    cp $0B
    jr c, deal_with_badguy_behavior
    sub $0A
    jr loc_85c7

deal_with_badguy_behavior:
    dec a
    add a, a
    ld e, a
    ld d, 0
    ld ix, badguy_behavior
    add ix, de
    ld l, (ix + 0)
    ld h, (ix + 1)
    ld a, (hl)
    ld (badguy_bhvr_cnt_ram), a
    ld c, (hl)
    ld b, d
    inc hl
    ld de, badguy_behavior_ram
    ldir
    ld hl, timer_table
    ld de, timer_data_block
    call init_timer

    call set_level_colors

    ld hl, gameflags
    ld b, $16  ; 22 bytes of GAMEFLAGS ?
    xor a
loc_862e:
    ld (hl), a  ; Reset GAMEFLAGS ??
    inc hl
    djnz loc_862e
    call sub_866b
    ld hl, $72C1
    ld a, (hl)
    and 7
    ld (hl), a
    ld l, 186
    ld a, (hl)
    and $3F
    ld (hl), a
    ld hl, enemy_num_p1
    ld a, (gamecontrol)
    inc a
    and 3
    jr nz, loc_8652
    inc l
loc_8652:
    ld a, (hl)
    cp 7
    ret nc
    ld iy, $72B2
loc_865c:
    ld (iy + 4), $00C0
    ld de, $FFFA
    add iy, de
    inc a
    cp 7
    jr nz, loc_865c
    ret

sub_866b:
    ld hl, $728A
    ld b, $2E
    xor a
loop_8671:
    ld (hl), a
    inc hl
    djnz loop_8671
    ret

clear_screen_and_sprites_01:
    ld hl, pnt
    ld de, $0300
    xor a
    call fill_vram
    ld hl, sat
    ld de, $80
    xor a
    call fill_vram
    ld hl, sprite_name_table
    ld b, $50
loop_8691:
    ld (hl), 0
    inc hl
    djnz loop_8691
    ld a, (gamecontrol)
    bit 1, a
    ld a, 4
    jr z, loc_86a1
    inc a
loc_86a1:
    call deal_with_playfield
    ld bc, $01E2
    call write_register
    ld hl, $00B4
    xor a
    call request_signal
    push af
loc_86b2:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_86b2
    pop af
    ld hl, gamecontrol
    set 7, (hl)
loc_86c0:
    bit 7, (hl)
    jr nz, loc_86c0
    ret

clear_screen_and_sprites_02:
    ld hl, pnt  ; vram PATTERN_NAME_TABLE
    ld de, $0300
    xor a
    call fill_vram
    ld hl, sat  ; vram SPRITE_ATTRIBUTE_TABLE
    ld de, $80
    xor a
    call fill_vram
    ld hl, sprite_name_table
    ld b, $50
loop_86e0:
    ld (hl), 0
    inc hl
    djnz loop_86e0
    ld a, $00A0
loop_till_playfield_parts_are_done:
    push af
    call display_play_field_parts
    pop af
    dec a
    jr nz, loop_till_playfield_parts_are_done
    ld a, 1
    call deal_with_playfield
    xor a
    call patterns_to_vram
    ld a, (gamecontrol)
    rra
    jr nc, loc_8709
    ld a, $0F
    call deal_with_playfield
    ld a, 1
    call patterns_to_vram
loc_8709:
    ld a, (gamecontrol)
    bit 1, a
    ld a, (current_level_p1)
    jr z, loc_8716
    ld a, (current_level_p2)
loc_8716:
    ld hl, $72E7
    ld d, $00D8
    ld iy, 1
    cp $0A
    jr nc, loc_8728
    add a, d
    ld (hl), a
    jr loc_8739
loc_8728:
    cp $0A
    jr c, loc_8731
    sub $0A
    inc d
    jr loc_8728
loc_8731:
    inc iy
    ld (hl), d
    inc hl
    add a, $00D8
    ld (hl), a
    dec hl
loc_8739:
    ld de, $3D
    ld a, 2
    call put_vram
    ld a, 2
    call deal_with_playfield
    ld hl, $72B8
    ld a, (gamecontrol)
    bit 1, a
    jr z, loc_8753
    inc l
loc_8753:
    ld de, $012B
    ld bc, 0
loc_8759:
    ld a, (hl)
    push hl
    ld hl, extra_01_txt
    and d
    jr z, send_extra_to_vram
    ld hl, extra_02_txt
send_extra_to_vram:
    add hl, bc
    push bc
    push de
    ld d, 0
    ld iy, 1
    ld a, 2
    call put_vram
    pop de
    pop bc
    pop hl
    inc e
    inc e
    rlc d
    inc c
    ld a, c
    cp 5
    jr nz, loc_8759
    ld a, (gamecontrol)
    bit 1, a
    ld hl, lives_left_p1_ram
    jr z, loc_878c
    inc l
loc_878c:
    ld b, (hl)
    ld de, $35
send_lives_to_vram:
    dec b
    jr z, loc_87b9
    push bc
    push de
    ld hl, mr_do_upper
    ld iy, 1
    ld a, 2
    call put_vram
    pop hl
    push hl
    ld de, $20
    add hl, de
    ex de, hl
    ld hl, mr_do_lower
    ld iy, 1
    ld a, 2
    call put_vram
    pop de
    pop bc
    inc de
    jr send_lives_to_vram
loc_87b9:
    ld a, 3
    call deal_with_playfield
    ld b, 5
    ld iy, appledata
    ld a, $0C
loop_87c6:
    bit 7, (iy + 0)
    jr z, loc_87df
    push bc
    push ix
    push af
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld d, 1
    call sub_b629
    pop af
    pop ix
    pop bc
loc_87df:
    ld de, 5
    add iy, de
    inc a
    djnz loop_87c6
    ret

extra_01_txt:
    db 50, 51, 52, 53, 54
extra_02_txt:
    db 72, 73, 74, 75, 76
mr_do_upper:
    db 120
mr_do_lower:
    db 121

sub_87f4:  ; Start the level
    ld iy, mrdo_data
    xor a
    ld (iy + 6), a  ; $7287 = ??
    ld (iy + 7), a  ; $7288 = ??
    ld a, 1
    ld (iy + 1), a  ; $7282 = Set Mr. Do's starting direction 1=Right,2=Left,3=Up,4=Down
    ld (iy + 5), a  ; $7286 = ?? CURRENT MRDO FRAME !!!
    ld (iy + 3), $00B0  ; $7284 = Set Mr. Do's starting Y coordinate
    ld (iy + 4), $0078  ; $7285 = Set Mr. Do's starting X coordinate
    ld (iy + 0), $00C0  ; $7281 = flag
    ld bc, $01E2
    call write_register

    call play_opening_tune
    ld hl, 1
    xor a
    call request_signal
    ld ($7283), a  ; $7283 = Mr Do's Timer ?
;	POP	AF	; WTF??? Potential critical bug
    ret

sub_8828:
    ld a, (gamecontrol)
    bit 1, a
    ld a, (keyboard_p1)
    jr z, check_for_pause
    ld a, (keyboard_p2)
check_for_pause:
    cp $0A
    ret nz
    ld hl, gamecontrol
    set 7, (hl)
enter_pause:
    bit 7, (hl)
    jr nz, enter_pause
    set 5, (hl)
    xor a
    ld hl, sat  ; remove sprites
    ld de, $80
    call fill_vram
    ld a, 2
    ld hl, $3800
    call init_table  ; enable alternative PNT at 3800H
    ld hl, statestart  ; save to VRAM the sound state
    ld de, $3B00
    ld bc, $5D  ; 93 bytes of sound state saved at 3B00h in VRAM
    call write_vram
    ld bc, $01E2
    call write_register
    call play_end_of_round_tune
    ld b, 2
loop_886e:
    ld hl, 0
loc_8871:
    dec hl
    ld a, l
    or h
    jr nz, loc_8871
    djnz loop_886e
loop_till_un_pause:
    ld a, (gamecontrol)
    bit 1, a
    ld a, (keyboard_p1)
    jr z, check_to_leave_pause
    ld a, (keyboard_p2)
check_to_leave_pause:
    cp $0A
    jr nz, loop_till_un_pause
    call initialize_the_sound
    ld hl, gamecontrol
    set 7, (hl)
loc_8891:
    bit 7, (hl)
    jr nz, loc_8891
    set 4, (hl)
    ld a, 2
    ld hl, pnt
    call init_table
    ld bc, $01E2
    call write_register
    ld b, 4
loc_88a7:
    ld hl, 0
loc_88aa:
    dec hl
    ld a, l
    or h
    jr nz, loc_88aa
    djnz loc_88a7
    ld hl, gamecontrol
    set 7, (hl)
loc_88b6:
    bit 7, (hl)
    jr nz, loc_88b6
    ld a, (hl)
    and $00CF
    ld (hl), a
    ld hl, statestart  ; restore from VRAM the sound state
    ld de, $3B00
    ld bc, $5D
    call read_vram
    ld bc, $01E2
    jp write_register

deal_with_apple_falling:
    ld iy, appledata
    ld hl, byte_896c
    ld a, ($722A)
    ld c, a
    ld b, 0
    add hl, bc
    ld c, (hl)
    add iy, bc

    xor a
    bit 7, (iy + 0)
    jr z, leads_to_falling_apple_04
    ld a, (iy + 0)
    bit 3, a
    jr nz, leads_to_falling_apple_01
    xor a
    call sub_8e10
    jr z, leads_to_falling_apple_04
    jr loc_8941
leads_to_falling_apple_01:
    ld a, (iy + 3)
    call test_signal
    and a
    jr z, leads_to_falling_apple_04
    ld a, (iy + 0)
    bit 6, a
    jr z, leads_to_falling_apple_02
    call sub_8fb0
    jr nz, loc_8941
leads_to_falling_apple_02:
    ld a, (iy + 0)
    bit 4, a
    jr z, leads_to_falling_apple_05
    push iy
    call play_apple_breaking_sound
    pop iy
    jr leads_to_falling_apple_07
leads_to_falling_apple_05:
    bit 5, a
    jr nz, leads_to_falling_apple_06
leads_to_falling_apple_07:
    ld a, (iy + 4)
    ld b, a
    and $00CF
    ld c, a
    ld a, b
    add a, $10
    and $30
    or c
    ld (iy + 4), a
    and $30
    jr z, loc_892a
    jr loc_8941
loc_892a:
    call sub_89d1
    call deal_with_random_diamond
    call deal_with_loosing_life
    jr loc_8945
leads_to_falling_apple_06:
    push iy
    call play_apple_falling_sound
    pop iy
    call deal_with_apple_hitting_something
    jr z, loc_8945
loc_8941:
    call sub_8972
    xor a
loc_8945:
    push af
    call sub_899a
    pop af
leads_to_falling_apple_04:
    push af
    ld a, ($722A)
    inc a
    cp 5
    jr c, loc_8954
    xor a
loc_8954:
    ld ($722A), a
    pop af
    and a
    ret


byte_896c:
    db 0, 5, 10, 15, 20, 25

sub_8972:
    ld hl, $0F
    ld a, (iy + 0)
    bit 6, a
    jr nz, loc_8992
    ld l, 4
    bit 5, a
    jr nz, loc_8992
    ld l, $19

loc_8992:
    xor a
    call request_signal
    ld (iy + 3), a
    ret

sub_899a:
    ld a, (iy + 4)
    rrca
    rrca
    rrca
    rrca
    and 3
    ld d, a
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld a, (iy + 0)
    bit 6, a
    jr z, loc_89c1
    and 7
    cp 2
    jr z, loc_89c1
    dec a
    jr nz, loc_89bf
    dec c
    dec c
    jr loc_89c1
loc_89bf:
    inc c
    inc c
loc_89c1:
    ld a, d
    and a
    jr nz, loc_89c8
    ld bc, $0808
loc_89c8:
    ld a, ($722A)
    add a, $0C
    jp sub_b629

sub_89d1:
    push iy
    ld a, (iy + 4)
    and $0F
    jr z, loc_89e9
    dec a
    add a, a
    ld c, a
    ld b, 0
    ld hl, byte_89ec
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)
    call sub_b601
loc_89e9:
    pop iy
    ret

byte_89ec:
    db 100, 0, 200, 0, 144, 1, 88, 2, 32, 3, 232, 3, 176, 4, 120, 5, 64, 6, 8, 7, 208, 7, 152, 8

deal_with_random_diamond:
    push iy
;     call sub_8a31  ; -mdl

sub_8a31:
    push bc
    push de
    push ix
    ld ix, appledata
    ld de, 5
    ld b, e
    ld c, d
loop_8a40:
    bit 7, (ix + 0)
    jr z, loc_8a47
    inc c
loc_8a47:
    add ix, de
    djnz loop_8a40
    ld a, c
    pop ix
    pop de
    pop bc
;	AND		A	; unused
;     ret  ; -mdl
    cp 1
    jr nz, loc_8a2e
    call rand_gen
    and $0F
    cp 2
    jr nc, loc_8a2e
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld ix, appledata
    ld (ix + 1), b
    ld (ix + 2), c
    ld a, $80
    ld (diamond_ram), a
    call play_diamond_sound
loc_8a2e:
    pop iy
    ret

deal_with_apple_hitting_something:
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld a, c
    and $0F
    jr z, loc_8a67
    cp 8
    jr z, loc_8a67
    ld a, c
    add a, 8
    and $00F0
    ld c, a
loc_8a67:
    call sub_8ad9
    ld a, (iy + 1)
    add a, 4
    ld (iy + 1), a
    ld a, (iy + 0)
    inc a
    ld b, a
    and 7
    cp 6
    jr nc, loc_8a80
    ld (iy + 0), b
loc_8a80:
    call sub_8bf6
    call sub_8c3a
    call sub_8c96
    call sub_8bc0
    ld a, (iy + 1)
    and 7
    jr nz, loc_8ad7
    call sub_8d25
    jr nz, apple_fell_on_something
    ld a, 1
    call sub_8e48
    jr nz, loc_8ad7
    ld a, (iy + 4)
    bit 7, a
    jr nz, apple_fell_on_something
    bit 6, a
    jr nz, apple_fell_on_something
    and $0F
    jr nz, apple_fell_on_something
    ld a, (iy + 0)
    and 7
    cp 5
    jr nc, apple_fell_on_something
;	LD		A, 80H
;	LD		(IY+0), A
    ld (iy + 0), $80
;	LD		A, 10H
;	LD		(IY+4), A
    ld (iy + 4), $10
    xor a
    jr loc_8ad7
apple_fell_on_something:
    res 5, (iy + 0)
    push iy
    call play_apple_breaking_sound
    pop iy
    ld a, (iy + 4)
    add a, $10
    ld (iy + 4), a
loc_8ad7:
    and a
    ret

sub_8ad9:
    ld a, b
    and $0F
    ret nz
    call sub_ac3f
    dec ix
    dec d
    ld a, (ix + $11)
    and 3
    cp 3
    ret nz
    bit 3, c
    jr nz, loc_8af7
    ld a, (ix + $10)
    and 3
    cp 3
    ret nz
loc_8af7:
    ld a, (ix + 1)
    and $0C
    cp $0C
    jr nz, loc_8b09
    ld a, b
    cp $00E8
    jr nc, loc_8b09
    set 5, (ix + 1)
loc_8b09:
    bit 0, (ix + 1)
    jr z, loc_8b1d
    bit 1, (ix + 0)
    jr z, loc_8b1d
    bit 3, c
    jr nz, loc_8b1d
    set 7, (ix + 1)
loc_8b1d:
    ld a, d
    inc a
    call sub_8bb1
    ld a, b
    cp $00B8
    jr nc, loc_8b54
    ld a, (ix + 1)
    and $0C
    cp $0C
    jr nz, loc_8b34
    set 4, (ix + $11)
loc_8b34:
    ld a, (ix + $11)
    cpl
    and 5
    jr nz, loc_8b4e
    ld a, (ix + $10)
    cpl
    and $0A
    jr nz, loc_8b4e
    bit 3, c
    jr nz, loc_8b4e
    set 7, (ix + $11)
loc_8b4e:
    ld a, d
    add a, $11
    call sub_8bb1
loc_8b54:
    bit 3, c
    ret nz
    ld a, (ix + 0)
    and $0C
    cp $0C
    jr nz, loc_8b69
    ld a, b
    cp $00B8
    jr nc, loc_8b69
    set 5, (ix + 0)
loc_8b69:
    ld a, (ix + 0)
    and $0A
    cp $0A
    jr nz, loc_8b7f
    ld a, (ix + 1)
    and 5
    cp 5
    jr nz, loc_8b7f
    set 6, (ix + 0)
loc_8b7f:
    ld a, d
    call sub_8bb1
    ld a, b
    cp $00B8
    ret nc
    ld a, (ix + 0)
    and $0C
    cp $0C
    jr nz, loc_8b94
    set 4, (ix + $10)
loc_8b94:
    ld a, (ix + $10)
    cpl
    and $0A
    jr nz, loc_8baa
    ld a, (ix + $11)
    cpl
    and 5
    jr nz, loc_8baa
    set 6, (ix + $10)
loc_8baa:
    ld a, d
    add a, $10
    jp sub_8bb1

sub_8bb1:
    push bc
    push de
    push ix
    ld hl, $7259
    call sub_abe1
    pop ix
    pop de
    pop bc
    ret

sub_8bc0:  ; Mr. Do interesecting with a falling apple
    ld a, (mrdo_data.y)  ; A = MrDo's Y
    ld d, a
    bit 7, (iy + 4)
    jr z, loc_8bce
    add a, 4
    jr loc_8be4
loc_8bce:
    ld a, (mrdo_data.x)  ; A = MrDo's X
    ld e, a
    call sub_8cfe
    ret nz  ;	JR		NZ, LOC_8BF4
    set 7, (iy + 4)
    ld a, (gamecontrol)
    set 6, a
    ld (gamecontrol), a
    ld a, d
loc_8be4:
    ld (mrdo_data.y), a
    xor a
    ld (mrdo_data.frame), a  ; Mr Do current frame
    ld a, (mrdo_data)
    set 7, a
    ld (mrdo_data), a
    xor a
;LOC_8BF4:
;	AND		A
    ret

sub_8bf6:  ; Falling apple
    ld a, ($72BA)
    ld b, a
    ld a, 1
    bit 7, b
    jr z, loc_8c38
    ld a, ($72BF)
    ld d, a
    bit 6, (iy + 4)
    jr z, loc_8c0f
    add a, 4
    ld d, a
    jr loc_8c28
loc_8c0f:
    ld a, ($72BE)
    ld e, a
    call sub_8cfe
    jr nz, loc_8c38
    ld a, ($72BD)
    set 7, a
    ld ($72BD), a
    set 6, (iy + 4)
    inc (iy + 4)
    ld a, d
loc_8c28:
    ld ($72BF), a
    ld b, d
    ld a, ($72BE)
    ld c, a
    ld d, $0B
    ld a, 3
    call sub_b629
    xor a
loc_8c38:
    and a
    ret

sub_8c3a:  ; Falling apple
    ld b, 7
    ld ix, enemy_data_array
loc_8c40:
    push bc
    bit 7, (ix + 4)
    jr z, loc_8c8d
    bit 6, (ix + 4)
    jr nz, loc_8c8d
    ld d, (ix + 2)
    ld e, (ix + 1)
    bit 7, (ix + 0)
    jr z, loc_8c68
    ld b, (ix + 5)
    ld a, ($722A)
    cp b
    jr nz, loc_8c8d
    ld a, d
    add a, 4
    ld d, a
    jr loc_8c7a
loc_8c68:
    call sub_8cfe
    jr nz, loc_8c8d
    set 7, (ix + 0)
    ld a, ($722A)
    ld (ix + 5), a
    inc (iy + 4)
loc_8c7a:
    ld (ix + 2), d
    ld b, d
    ld c, e
    call sub_b7ef
    add a, 5
    ld d, $25
    push ix
    call sub_b629
    pop ix
loc_8c8d:
    ld de, 6
    add ix, de
    pop bc
    djnz loc_8c40
    ret

sub_8c96:  ; Falling apple ?
    ld b, 3  ; chomper number
    ld ix, chompdata  ; chomper data
loc_8c9c:
    push bc
    bit 7, (ix + 4)
    jr z, loc_8cf5
    ld d, (ix + 2)
    ld e, (ix + 1)
    bit 7, (ix + 0)
    jr z, loc_8cbe
    ld b, (ix + 5)
    ld a, ($722A)
    cp b
    jr nz, loc_8cf5
    ld a, d
    add a, 4
    ld d, a
    jr loc_8cd0
loc_8cbe:
    call sub_8cfe
    jr nz, loc_8cf5
    set 7, (ix + 0)
    ld a, ($722A)
    ld (ix + 5), a
    inc (iy + 4)
loc_8cd0:
    ld (ix + 2), d
    ld b, d
    ld c, e
    push ix
    pop hl
    xor a
    ld de, chompdata
;	AND		A		; CF==0  already
    sbc hl, de
    jr z, loc_8cea
    ld de, 6
loc_8ce4:
    inc a
    and a
    sbc hl, de
    jr nz, loc_8ce4
loc_8cea:
    add a, $11
    ld d, 5
    push ix
    call sub_b629
    pop ix
loc_8cf5:
    ld de, 6
    add ix, de
    pop bc
    djnz loc_8c9c
    ret

sub_8cfe:  ; Check if Mr. Do is intersecting with a falling apple
    push bc
    ld c, 1
    ld a, (iy + 1)
    sub d
    jr nc, loc_8d09
    cpl
    inc a
loc_8d09:
    cp 8
    jr nc, loc_8d21
    ld a, (iy + 2)
    sub e
    jr nc, loc_8d15
    cpl
    inc a
loc_8d15:
    cp 9
    jr nc, loc_8d21
    ld a, (iy + 1)
    add a, 4
    ld d, a
    ld c, 0
loc_8d21:
    ld a, c
    pop bc
    or a
    ret

sub_8d25:
    ld ix, appledata
    ld bc, 0
loc_8d2c:
    ld a, ($722A)
    cp c
    jr z, loc_8d80
    ld a, (ix + 0)
    bit 7, a
    jr z, loc_8d80
    bit 6, a
    jr nz, loc_8d80
    ld a, (iy + 2)
    sub (ix + 2)
    jr nc, loc_8d47
    cpl
    inc a
loc_8d47:
    cp $10
    jr nc, loc_8d80
    ld a, (ix + 1)
    sub (iy + 1)
    jr c, loc_8d80
    cp 9
    jr nc, loc_8d80
    res 6, (ix + 0)
    res 5, (ix + 0)
    ld a, (iy + 4)
    and $00CF
    or $20
    ld (ix + 4), a
    bit 3, (ix + 0)
    jr nz, loc_8d7f
    set 3, (ix + 0)
    ld hl, $0F
    xor a
    push bc
    call request_signal
    pop bc
    ld (ix + 3), a
loc_8d7f:
    inc b
loc_8d80:
    ld de, 5
    add ix, de
    inc c
    ld a, c
    cp e
    jr c, loc_8d2c
    ld a, b
    and a
    ret

deal_with_loosing_life:
    bit 6, (iy + 4)
    jr z, loc_8d9b
    call sub_b76d
    ld l, 3
    jr nz, loc_8e05
loc_8d9b:
    ld ix, enemy_data_array  ; enemy data starts here = 6*7 bytes
    ld b, 7  ; test each enemy 
loc_8da1:
    push bc
    ld a, (ix + 4)
    bit 7, a
    jr z, loc_8dc5
    bit 6, a
    jr nz, loc_8dc5
    bit 7, (ix + 0)
    jr z, loc_8dc5
    ld b, (ix + 5)
    ld a, ($722A)
    cp b
    jr nz, loc_8dc5
    call sub_b7c4  ; outupt = ZF and A 
    pop bc
    ld l, 2
    jr z, loc_8e05
    push bc
loc_8dc5:
    ld de, 6
    add ix, de  ; next enemy
    pop bc
    djnz loc_8da1

    ld ix, chompdata  ; chompers start here ?
    ld b, 3  ; test each chompers
loop_8dd3:
    push bc
    bit 7, (ix + 4)
    jr z, lost_a_life
    bit 7, (ix + 0)
    jr z, lost_a_life
    ld b, (ix + 5)
    ld a, ($722A)
    cp b
    jr nz, lost_a_life
    call sub_b832
lost_a_life:
    pop bc
    ld de, 6
    add ix, de
    djnz loop_8dd3
    ld l, 0
    bit 7, (iy + 4)
    jr z, loc_8e05
    push iy
    call play_lose_life_sound  ; smashed: no DEATH SEQUENCE HERE 
    pop iy
    ld l, 1
loc_8e05:
    res 7, (iy + 0)
    res 3, (iy + 0)
    ld a, l
    and a
    ret

sub_8e10:  ; Falling apple logic
    call sub_8e48
    jr z, loc_8e46
    ld e, a
    ld a, (mrdo_data.y)
    sub (iy + 1)
    jr c, loc_8e32
    cp $11
    jr nc, loc_8e32
    ld a, (mrdo_data.x)
    sub (iy + 2)
    jr nc, loc_8e2c
    cpl
    inc a
loc_8e2c:
    ld d, 0
    cp 8
    jr c, loc_8e45
loc_8e32:
    ld b, $00C8
    dec e
    jr z, loc_8e3b
    res 6, b
    set 5, b
loc_8e3b:
    ld (iy + 0), b

    ld (iy + 4), $10
    ld d, 1
loc_8e45:
    ld a, d
loc_8e46:
    and a
    ret

sub_8e48:
    ld d, a
    ld b, (iy + 1)
    ld c, (iy + 2)
    push de
    call sub_ac3f
    pop de
    ld a, b
    cp $00B0
    jr nc, loc_8e76
    ld a, (iy + 2)
    rlca
    rlca
    rlca
    rlca
    and $00F0
    ld c, a
    ld a, (iy + 1)
    and $0F
    or c
    ld b, 8
    ld hl, unk_8f98
loop_8e6e:
    cp (hl)
    jr z, loc_8e7a
    inc hl
    inc hl
    inc hl
    djnz loop_8e6e
loc_8e76:
    xor a
    jp loc_8f96
loc_8e7a:
    inc hl
    push de
    ld e, (hl)
    inc hl
    ld d, (hl)
    push ix
    push de
    pop ix
    pop hl
    pop de
    jp (ix)
loc_8e88:
    ld bc, $10
    add hl, bc
    xor a
    bit 0, (hl)
    jr z, loc_8e97
    dec hl
    bit 1, (hl)
    jr z, loc_8e97
    inc a
loc_8e97:
    jp loc_8f96
loc_8e9a:
    ld bc, $10
    add hl, bc
    xor a
    bit 0, (hl)
    jr z, loc_8ecc
    ld a, d
    and a
    jr nz, loc_8eb4
    bit 1, (hl)
    jr z, loc_8ecc
    dec hl
    bit 1, (hl)
    jr z, loc_8ecc
    ld a, 1
    jr loc_8ecc
loc_8eb4:
    ld b, $00FC
    bit 1, (hl)
    jr z, loc_8ec3
    ld b, 4
    dec hl
    bit 1, (hl)
    jr z, loc_8ec3
    ld b, 0
loc_8ec3:
    ld a, (iy + 2)
    add a, b
    ld (iy + 2), a
    ld a, 2
loc_8ecc:
    jp loc_8f96
loc_8ecf:
    ld a, 2
    bit 5, (hl)
    jr nz, loc_8ee3
    ld bc, $10
    add hl, bc
    xor a
    bit 0, (hl)
    jr z, loc_8ee3
    bit 1, (hl)
    jr z, loc_8ee3
    inc a
loc_8ee3:
    jp loc_8f96
loc_8ee6:
    ld bc, $10
    add hl, bc
    xor a
    bit 1, (hl)
    jr z, loc_8f18
    ld a, d
    and a
    jr nz, loc_8f00
    bit 0, (hl)
    jr z, loc_8f18
    inc hl
    bit 0, (hl)
    jr z, loc_8f18
    ld a, 1
    jr loc_8f18
loc_8f00:
    ld b, 4
    bit 0, (hl)
    jr z, loc_8f0f
    ld b, $00FC
    inc hl
    bit 0, (hl)
    jr z, loc_8f0f
    ld b, 0
loc_8f0f:
    ld a, (iy + 2)
    add a, b
    ld (iy + 2), a
    ld a, 2
loc_8f18:
    jp loc_8f96
loc_8f1b:
    xor a
    bit 2, (hl)
    jr z, loc_8f27
    dec hl
    bit 3, (hl)
    jr z, loc_8f27
    ld a, 2
loc_8f27:
    jp loc_8f96
loc_8f2a:
    xor a
    bit 2, (hl)
    jr z, loc_8f57
    ld a, d
    and a
    jr nz, loc_8f40
    bit 3, (hl)
    jr z, loc_8f57
    dec hl
    bit 3, (hl)
    jr z, loc_8f57
    ld a, 2
    jr loc_8f57
loc_8f40:
    ld b, $00FC
    bit 3, (hl)
    jr z, loc_8f4e
    ld b, 4
    bit 3, (hl)
    jr z, loc_8f4e
    ld b, 0
loc_8f4e:
    ld a, (iy + 2)
    add a, b
    ld (iy + 2), a
    ld a, 2
loc_8f57:
    jp loc_8f96
loc_8f5a:
    xor a
    bit 2, (hl)
    jr z, loc_8f65
    bit 3, (hl)
    jr z, loc_8f65
    ld a, 2
loc_8f65:
    jp loc_8f96
loc_8f68:
    xor a
    bit 3, (hl)
    jr z, loc_8f96
    ld a, d
    and a
    jr nz, loc_8f7e
    bit 2, (hl)
    jr z, loc_8f96
    inc hl
    bit 2, (hl)
    jr z, loc_8f96
    ld a, 2
    jr loc_8f96
loc_8f7e:
    ld b, 4
    bit 2, (hl)
    jr z, loc_8f8d
    ld b, $00FC
    inc hl
    bit 2, (hl)
    jr z, loc_8f8d
    ld b, 0
loc_8f8d:
    ld a, (iy + 2)
    add a, b
    ld (iy + 2), a
    ld a, 2
loc_8f96:
    and a
    ret

unk_8f98:
    db 0
    dw loc_8e88
    db $40
    dw loc_8e9a
    db $80
    dw loc_8ecf
    db $00C0
    dw loc_8ee6
    db 8
    dw loc_8f1b
    db $48
    dw loc_8f2a
    db $88
    dw loc_8f5a
    db $00C8
    dw loc_8f68

sub_8fb0:
    ld a, (iy + 0)
    inc a
    ld (iy + 0), a
    and 3
    cp 3
    jr nz, loc_8fc2
    ld a, (iy + 0)
    and $00F8
    res 6, a
    set 5, a
    ld (iy + 0), a
    xor a
loc_8fc2:
    and a
    ret


deal_with_ball:
    ld a, (balldata)
    ld iy, balldata
    bit 7, (iy + 0)
    jr z, loc_8ff1
    and $7F
    or $40
    ld (iy + 0), a

    ld a, (gameflags)
    and $80
    jr z, deal_with_ball.normal_mode

    ld (iy + 4), 0  ; Fast cooldown in chomper mode

deal_with_ball.normal_mode:
    inc (iy + 4)  ; In chomper mode SET to 1 the ball cooldown counter
    push iy
    call play_bouncing_ball_sound
    pop iy
    jr loc_9005
loc_8ff1:
    and $78
    jr z, loc_9071
    ld a, (iy + 3)
    call test_signal
    and a
    ret z  ;JR		Z, LOC_9071
    ld a, (iy + 0)
    bit 6, a
    jr z, ball_returns_to_do
loc_9005:
    call sub_9074
    call sub_9099
    bit 2, e
    jr nz, ball_gets_stuck
    call sub_912d
    call sub_92f2
    cp 2
    ret z
    dec a
    jr z, ball_gets_stuck
    call sub_936f
    cp 2
    jr nz, loc_9028
    ld a, 3
    ret
loc_9028:
    cp 1
    jr z, ball_gets_stuck
    call sub_9337
    and a
    jr nz, ball_gets_stuck
    call sub_9399
    and a
    jr z, loc_903e
    res 6, (iy + 0)
    jr loc_9071
loc_903e:
    call sub_93b6
    jr loc_9071
ball_gets_stuck:
    res 6, (iy + 0)
    set 4, (iy + 0)
    ld (iy + 5), 0
    push iy
    call play_ball_stuck_sound_01
    pop iy
    jr loc_906e
ball_returns_to_do:
    bit 5, a
    jr z, loc_906e
    res 5, a
    set 3, a
    ld (iy + 0), a
    ld (iy + 5), 0
    push iy
    call play_ball_return_sound
    pop iy
loc_906e:
    call sub_93ce
loc_9071:
    xor a
    ret

sub_9074:
    ld b, (iy + 1)
    ld c, (iy + 2)
    bit 1, (iy + 0)
    jr nz, loc_9084
    inc b
    inc b
    jr loc_9086
loc_9084:
    dec b
    dec b
loc_9086:
    bit 0, (iy + 0)
    jr nz, loc_9090
    inc c
    inc c
    jr loc_9092
loc_9090:
    dec c
    dec c
loc_9092:
    ld (iy + 1), b
    ld (iy + 2), c
    ret

sub_9099:
    ld de, 0
    ld ix, appledata
    ld b, 5
loc_90a2:
    bit 7, (ix + 0)
    jr z, loc_911e
    ld a, (ix + 1)
    sub 9
    cp (iy + 1)
    jr nc, loc_911e
    add a, $11
    cp (iy + 1)
    jr c, loc_911e
    ld a, (ix + 2)
    sub 8
    cp (iy + 2)
    jr z, loc_90c5
    jr nc, loc_911e
loc_90c5:
    add a, $10
    jr c, loc_90ce
    cp (iy + 2)
    jr c, loc_911e
loc_90ce:
    bit 5, (ix + 0)
    jr z, loc_90dc
    set 4, (ix + 0)
    ld e, 4
    ret
loc_90dc:
    ld a, (iy + 1)
    cp (ix + 1)
    jr c, loc_90f0
    bit 1, (iy + 0)
    jr z, loc_90fc
    res 1, (iy + 0)
    jr loc_90fa
loc_90f0:
    bit 1, (iy + 0)
    jr nz, loc_90fc
    set 1, (iy + 0)
loc_90fa:
    set 1, d
loc_90fc:
    ld a, (iy + 2)
    cp (ix + 2)
    jr c, loc_9110
    bit 0, (iy + 0)
    ret z
    res 0, (iy + 0)
    jr loc_911a
loc_9110:
    bit 0, (iy + 0)
    jr nz, loc_911e
    set 0, (iy + 0)
loc_911a:
    set 0, d
    ret
loc_911e:
    inc ix
    inc ix
    inc ix
    inc ix
    inc ix
    dec b
    jp nz, loc_90a2
    ret

sub_912d:
    ld b, (iy + 1)
    ld c, (iy + 2)
    dec b
    dec c
    bit 1, (iy + 0)
    jr nz, loc_913d
    inc b
    inc b
loc_913d:
    bit 0, (iy + 0)
    jr nz, loc_9145
    inc c
    inc c
loc_9145:
    ld e, 0
    push de
    call sub_ac3f
    pop de
    ld a, (iy + 1)
    and $0F
    bit 1, (iy + 0)
    jr z, loc_918a
    cp $0A
    jr nz, loc_9167
    set 7, e
    bit 4, (ix + 0)
    jr nz, loc_91bb
    set 1, e
    jr loc_91bb
loc_9167:
    cp 2
    jr nz, loc_91bb
    set 5, e
    ld a, (iy + 2)
    and $0F
    cp 8
    jr nc, loc_9180
    bit 0, (ix + 0)
    jr nz, loc_91bb
    set 1, e
    jr loc_91bb
loc_9180:
    bit 1, (ix + 0)
    jr nz, loc_91bb
    set 1, e
    jr loc_91bb
loc_918a:
    cp 6
    jr nz, loc_919a
    set 7, e
    bit 5, (ix + 0)
    jr nz, loc_91bb
    set 1, e
    jr loc_91bb
loc_919a:
    cp $0E
    jr nz, loc_91bb
    set 5, e
    ld a, (iy + 2)
    and $0F
    cp 8
    jr nc, loc_91b3
    bit 2, (ix + 0)
    jr nz, loc_91bb
    set 1, e
    jr loc_91bb
loc_91b3:
    bit 3, (ix + 0)
    jr nz, loc_91bb
    set 1, e
loc_91bb:
    ld a, (iy + 2)
    and $0F
    bit 0, (iy + 0)
    jr z, loc_91f9
    cp 2
    jr nz, loc_91d6
    set 6, e
    bit 7, (ix + 0)
    jr nz, loc_922a
    set 0, e
    jr loc_922a
loc_91d6:
    cp $0A
    jr nz, loc_922a
    set 4, e
    ld a, (iy + 1)
    and $0F
    cp 8
    jr c, loc_91ef
    bit 2, (ix + 0)
    jr nz, loc_922a
    set 0, e
    jr loc_922a
loc_91ef:
    bit 0, (ix + 0)
    jr nz, loc_922a
    set 0, e
    jr loc_922a
loc_91f9:
    cp $0E
    jr nz, loc_9209
    set 6, e
    bit 6, (ix + 0)
    jr nz, loc_922a
    set 0, e
    jr loc_922a
loc_9209:
    cp 6
    jr nz, loc_922a
    set 4, e
    ld a, (iy + 1)
    and $0F
    cp 8
    jr c, loc_9222
    bit 3, (ix + 0)
    jr nz, loc_922a
    set 0, e
    jr loc_922a
loc_9222:
    bit 1, (ix + 0)
    jr nz, loc_922a
    set 0, e
loc_922a:
    bit 7, e
    jr z, loc_92a3
    bit 6, e
    jr z, loc_92a3
    ld a, e
    and 3
    jp nz, loc_92e8
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld a, b
    bit 1, (iy + 0)
    jr z, loc_9275
    sub 4
    ld b, a
    ld a, c
    bit 0, (iy + 0)
    jr z, loc_9263
    sub 4
    ld c, a
    push de
    call sub_ac3f
    pop de
    bit 3, (ix + 0)
    jp nz, loc_92e8
    ld e, 3
    jp loc_92e8
loc_9263:
    add a, 4
    ld c, a
    push de
    call sub_ac3f
    pop de
    bit 2, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
    jr loc_92e8
loc_9275:
    add a, 4
    ld b, a
    ld a, c
    bit 0, (iy + 0)
    jr z, loc_9291
    sub 4
    ld c, a
    push de
    call sub_ac3f
    pop de
    bit 1, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
    jr loc_92e8
loc_9291:
    add a, 4
    ld c, a
    push de
    call sub_ac3f
    pop de
    bit 0, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
    jr loc_92e8
loc_92a3:
    bit 5, e
    jr z, loc_92e8
    bit 4, e
    jr z, loc_92e8
    ld a, e
    and 3
    jr nz, loc_92e8
    bit 1, (iy + 0)
    jr z, loc_92d0
    bit 0, (iy + 0)
    jr z, loc_92c6
    bit 0, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
    jr loc_92e8
loc_92c6:
    bit 1, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
    jr loc_92e8
loc_92d0:
    bit 0, (iy + 0)
    jr z, loc_92e0
    bit 2, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
    jr loc_92e8
loc_92e0:
    bit 3, (ix + 0)
    jr nz, loc_92e8
    ld e, 3
loc_92e8:
    ld a, e
    and 3
    xor (iy + 0)
    ld (iy + 0), a
    ret

sub_92f2:
    ld ix, enemy_data_array
    ld c, 0
loc_92f8:
    bit 7, (ix + 4)
    jr z, loc_9316
    bit 6, (ix + 4)
    jr nz, loc_9316
    push bc
    push ix
    ld b, (ix + 2)
    ld c, (ix + 1)
    call sub_b5dd
    pop ix
    pop bc
    and a
    jr nz, loc_9324
loc_9316:
    ld de, 6
    add ix, de
    inc c
    ld a, c
    cp 7
    jr c, loc_92f8
    xor a
    ret
loc_9324:
    call sub_b7c4  ; outupt = ZF and A 
    push af
    ld de, $32
    call sub_b601
    pop af
;	AND	A			; already in AF
    ld a, 2
    ret z
    ld a, 1
    ret

sub_9337:
    ld ix, chompdata
    ld c, 0
loc_933d:
    bit 7, (ix + 4)
    jr z, loc_9355
    push bc
    push ix
    ld b, (ix + 2)
    ld c, (ix + 1)
    call sub_b5dd
    pop ix
    pop bc
    and a
    jr nz, loc_9363
loc_9355:
    ld de, 6
    add ix, de
    inc c
    ld a, c
    cp 3
    jr c, loc_933d
    xor a
    ret
loc_9363:
    call sub_b832
    ld de, $32
    call sub_b601
    ld a, 1
    ret

sub_936f:
    ld a, ($72BD)
    bit 6, a
    ret z
    ld a, ($72BF)
    ld b, a
    ld a, ($72BE)
    ld c, a
    call sub_b5dd
    and a
    ret z
    ld bc, $0808
    ld d, 0
    ld a, 3
    call sub_b629
    ld de, $32
    call sub_b601
    call sub_b76d
    inc a
    ret

sub_9399:
    ld a, (mrdo_data.y)
    ld b, a
    ld a, (mrdo_data.x)
    ld c, a
    call sub_b5dd
    and a
    ret z
    ld hl, mrdo_data
    set 6, (hl)
    push iy
    call sub_c98a
    pop iy
    ld a, 1
    ret

sub_93b6:
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld d, 1
    ld a, 4
    call sub_b629
    ld hl, 1
    xor a
    call request_signal
    ld (iy + 3), a
    ret

sub_93ce:  ; Ball intersecting with sprite
    ld a, (iy + 5)
    add a, 2
    ld b, (iy + 1)
    ld c, (iy + 2)
    bit 3, (iy + 0)
    jr z, loc_93ed
    ld c, a
    ld a, 9
    sub c
    ld ix, mrdo_data
    ld b, (ix + 3)
    ld c, (ix + 4)
loc_93ed:
    ld d, a
    ld a, 4
    call sub_b629
    inc (iy + 5)
    ld a, (iy + 5)
    cp 6
    jr z, loc_9409
    ld hl, 5
    xor a
    call request_signal
    ld (iy + 3), a
    ret
loc_9409:
    bit 4, (iy + 0)
    jr z, loc_9444
    res 4, (iy + 0)
    set 5, (iy + 0)
    ld a, (iy + 4)
    dec a
    cp 4
    jr c, loc_9421
    ld a, 4
loc_9421:  ; Ball intersects with sprite
    add a, a
    ld e, a
    ld d, 0
    ld ix, byte_944e
    add ix, de
    ld l, (ix + 0)
    ld h, (ix + 1)
    xor a
    call request_signal
    ld (iy + 3), a
    ld bc, $0808
    ld d, 0
    ld a, 4
    jp sub_b629
loc_9444:
    res 3, (iy + 0)
    ld hl, mrdo_data
    set 6, (hl)
    ret

byte_944e:
    db 60, 0, 120, 0, 240, 0, 104, 1, 224, 1, 0

leads_to_cherry_stuff:
    ld a, (gamecontrol)
    bit 6, a
    jr z, loc_9463
    xor a
    ret
loc_9463:
    ld iy, mrdo_data  ; IY points to Mr. Do's sprite data
    ld a, (iy + 2)
    call test_signal
    and a
    jr z, loc_949a
    call sub_94a9
    and a
    jr nz, loc_947a
    ld a, 1
    jr loc_9489
loc_947a:
    cp 5
    jr nz, loc_9483
    jp loc_d366
loc_9481:
    jr loc_9491
loc_9483:
    ld (iy + 1), a
    call sub_95a1  ; Mr. Do sprite intersection logic
loc_9489:
    push af
    call deal_with_cherries
    call sub_96e4
    pop af
loc_9491:
    call sub_9732  ; MrDo movements
    call sub_9807
    and a
    ret nz
loc_949a:
    ld hl, $7245
    ld b, $14
    xor a
loc_94a0:
    cp (hl)
    ret nz
    inc hl
    djnz loc_94a0
    ld a, 2
    ret

sub_94a9:
    ld ix, $7088
    ld a, (gamecontrol)
    bit 1, a
    jr z, loc_94b8
    ld ixl, $8D
loc_94b8:
    bit 6, (ix + 0)
    jr nz, loc_94c4
    bit 6, (ix + 3)
    jr z, loc_9538
loc_94c4:
    ld a, (mrdo_data)
    bit 6, a
    jr z, loc_9538
    ld b, (iy + 3)
    ld c, (iy + 4)
    ld a, (iy + 1)
    cp 3
    jr nc, loc_94fd
    dec a
    ld a, c
    jr nz, loc_94ed
    add a, 6
    ld ($72DB), a
    add a, 3
    jr c, loc_9538
    ld c, a
    ld a, b
    ld ($72DA), a
    jr loc_9524
loc_94ed:
    sub 6
    ld ($72DB), a
    sub 3
    jr c, loc_9538
    ld c, a
    ld a, b
    ld ($72DA), a
    jr loc_9524
loc_94fd:
    cp 3
    ld a, b
    jr nz, loc_9514
    sub 6
    ld ($72DA), a
    sub 3
    cp $1C
    jr c, loc_9538
    ld b, a
    ld a, c
    ld ($72DB), a
    jr loc_9524
loc_9514:
    add a, 6
    ld ($72DA), a
    add a, 3
    cp $00B5
    jr nc, loc_9538
    ld b, a
    ld a, c
    ld ($72DB), a
loc_9524:
    push ix
    call sub_ac3f
    ld a, (ix + 0)
    pop ix
    and $0F
    cp $0F
    jr nz, loc_9538
    ld a, 5
    ret
loc_9538:
    ld a, 1
    bit 1, (ix + 1)
    jr nz, loc_9558
    inc a
    bit 3, (ix + 1)
    jr nz, loc_9558
    inc a
    bit 0, (ix + 1)
    jr nz, loc_9558
    inc a
    bit 2, (ix + 1)
    jr nz, loc_9558
    xor a
    ret

loc_9566:
    ld a, (iy + 4)
    and $0F
    cp 8
    jr z, loc_9575
loc_956f:
    pop af
    ld a, (iy + 1)
    ret
loc_9558:
    push af
    cp 3
    jr nc, loc_9566
    ld a, (iy + 3)
    and $0F
    jr nz, loc_956f
loc_9575:
    pop af
    ret

sub_9577:
    ld ix, balldata
    ld a, (iy + 1)
    dec a
    ld b, a
    cp 2
    jr c, loc_9593
    ld b, 3
    cp 2
    jr z, loc_958c
    ld b, 1
loc_958c:
    bit 7, (iy + 4)
    jr z, loc_9593
    dec b
loc_9593:
    set 7, b
    ld (ix + 0), b
    set 3, (iy + 0)
    res 6, (iy + 0)
    ret

sub_95a1:  ; Mr. Do Sprite intersection logic
    call sub_961f  ; Mr. Do's sprite collision logic with the screen bounds
    and a
    jp nz, loc_961c
    push bc
    res 5, (iy + 0)
    ld b, (iy + 3)
    ld c, (iy + 4)
    ld a, (iy + 1)
    cp 3
    jr nc, loc_95ce
    ld d, a
    ld a, 1
    call sub_aee1  ; Mr do is pushing an apple
    bit 0, a
    jr z, loc_95c8
    set 5, (iy + 0)
loc_95c8:
    cp 2
    jr nc, loc_9617
loc_95d5:
    pop bc
    ld (iy + 3), b
    ld (iy + 4), c
    ld a, (iy + 1)
    ld d, a
    cp 1
    jr nz, loc_95e9
    call sub_b2fa
    jr loc_95fe
loc_95e9:
    cp 2
    jr nz, loc_95f2
    call sub_b39d
    jr loc_95fe
loc_95f2:
    cp 3
    jr nz, loc_95fb
    call sub_b43f
    jr loc_95fe
loc_95fb:
    call sub_b4e9
loc_95fe:
    bit 0, e
    jr z, loc_9606
    set 4, (iy + 0)
loc_9606:
    ld b, (iy + 3)
    ld c, (iy + 4)
    push de
    call sub_ac3f
    call sub_aeb7
    pop de
    xor a
    ret
loc_9617:
    set 5, (iy + 0)
    pop bc
loc_961c:
    ld a, 1
    ret
loc_95ce:  ; Mr. Do intersects with an apple while facing up or down
    ld d, a
    scf  ; CF==1 Mr. Do collision offset to fix stuck in apple bug
    call sub_b12d  ; Returns A=0 if no collision, A=1 if collision
    and a
    jr z, loc_95d5
    pop bc  ; here A==1
    ret  ; Treat as a "wall" collision

sub_961f:  ; Mr. Do's sprite collision logic with the screen bounds
    ld (iy + 1), a
    ld b, (iy + 3)
    ld c, (iy + 4)
    cp 3  ; Check if Mr. Do is facing up or down
    jr nc, loc_964b  ; If facing up or down, jump to LOC_964B
    ld a, b
    and $0F
    jr nz, loc_966d
    ld a, c
    add a, 4
    ld c, a
    ld a, (iy + 1)
    dec a
    jr z, loc_9640
    ld a, c
    sub 8
    ld c, a
loc_9640:
    ld a, c
    cp $18
    jr c, loc_966d
    cp $00E9
    jr nc, loc_966d
    jr loc_966a
loc_964b:
    ld a, c
    and $0F
    cp 8
    jr nz, loc_966d
    ld a, b
    add a, 4
    ld b, a
    ld a, (iy + 1)
    cp 4
    jr z, loc_9661
    ld a, b
    sub 8
    ld b, a
loc_9661:
    ld a, b
    cp $20
    jr c, loc_966d
    cp $00B1
    jr nc, loc_966d
loc_966a:
    xor a
    ret
loc_966d:  ; Mr. Do has collided with the bounds of the screen
    ld a, 1
    ret

deal_with_cherries:
    call sub_b173
    jr c, grab_some_cherries
    bit 1, (iy + 0)
    ret z
    ld a, (iy + 8)
    call test_signal
    and a
    ret z
    ld (iy + 7), 0
    res 1, (iy + 0)
    push iy
    call sub_c97f
    pop iy
    ret
grab_some_cherries:
    ld de, 5
    call sub_b601
    bit 1, (iy + 0)
    jr z, loc_96ca
    ld a, (iy + 8)
    call test_signal
    and a
    jr nz, loc_96ca
    ld a, (iy + 8)
    call free_signal
    inc (iy + 7)
    ld a, (iy + 7)
    cp 8
    jr c, loc_96d5
    ld (iy + 7), 0
    ld de, $2D  ; final cherry scores 500 not 550
    call sub_b601
    res 1, (iy + 0)
    ret
loc_96ca:
    ld (iy + 7), 1
    push iy
    call play_grab_cherries_sound
    pop iy
loc_96d5:
    xor a
    ld hl, $1E
    call request_signal
    ld (iy + 8), a
    set 1, (iy + 0)
    ret

sub_96e4:
    ld a, ($7272)
    bit 7, a
    ret z
    ld a, (iy + 3)
    cp $60
    ret nz
    ld a, (iy + 4)
    cp $78
    ret nz
    ld hl, $7272
    res 7, (hl)
    ld a, (hl)
    or $32
    ld (hl), a
    ld a, $0A
    ld ($728C), a
;	LD		HL, (SCORE_P1_RAM)		; unused
    ld a, (gamecontrol)
    ld c, a
    ld a, (current_level_p1)
    bit 1, c
    jr z, loc_971b
;	LD		HL, (SCORE_P2_RAM)		; unused
    ld a, (current_level_p2)
loc_971b:
    ld hl, 0
    ld de, $32
loc_9721:
    add hl, de
    dec a
    jp p, loc_9721
    ex de, hl
    jp sub_b601
;	PUSH	IY
;	NOP
;	NOP
;	NOP
;	POP		IY

sub_9732:
    and a  ; if MrDo is halted reset animation
    jr nz, loc_973d
    ld a, (iy + 6)
    inc a
    cp 4  ; Number of steps in the animation
    jr c, loc_973e
loc_973d:
    xor a
loc_973e:
    ld (iy + 6), a
    ld c, 1
    add a, c
    bit 5, (iy + 0)
    jr z, loc_974c
    add a, 4  ; PUSH/WALK offset <-> add 4 if PUSHING
loc_974c:
    ld c, a
    ld a, (iy + 1)  ; MrDo Direction
    cp 2
    jr nz, loc_975a
    ld a, c
    add a, 8  ; walk left offset
    ld c, a
    jr loc_9786
loc_975a:
    cp 3
    jr nz, loc_9771
    ld a, (iy + 4)
    and a
    jp p, loc_976b
    ld a, c
    add a, 16  ;0EH		; walk up offset
    ld c, a
    jr loc_9786
loc_976b:
    ld a, c
    add a, 32  ;1CH		; walk up-mirror offset
    ld c, a
    jr loc_9786
loc_9771:
    cp 4
    jr nz, loc_9786
    ld a, (iy + 4)
    and a
    jp p, loc_9782
    ld a, c
    add a, 24  ;15H		; walk down offset
    ld c, a
    jr loc_9786
loc_9782:
    ld a, c
    add a, 40  ;23H			; walk down-mirror offset
    ld c, a
loc_9786:
    ld (iy + 5), c  ; !!!!! MODIFY HERE TO HAVE 4 MrDO STEPS
    bit 6, (iy + 0)
    jr z, loc_97c8
    ld a, (iy + 1)
    cp 3
    jr c, loc_97a1
    ld e, a
    ld a, (iy + 4)
    and a
    ld a, e
    jp m, loc_97a1
    add a, 2
loc_97a1:
    bit 5, (iy + 0)
    jr z, loc_97a9
    add a, 6
loc_97a9:
    dec a
    add a, a
    ld e, a
    ld d, 0
    ld hl, byte_97ef
    add hl, de
    ld a, (iy + 4)
    add a, 8
    sub (hl)
    ld c, a
    inc hl
    ld a, (iy + 3)
    add a, 8
    sub (hl)
    inc d
    ld b, a
    ld a, 4
    call sub_b629
loc_97c8:
    ld hl, $1E
    bit 3, (iy + 0)
    jr nz, loc_97dd
    ld l, $0F
    bit 5, (iy + 0)
    jr nz, loc_97dd
    ld l, 7
loc_97dd:
    xor a
    call request_signal
    ld (iy + 2), a
    ld a, (iy + 0)
    and $00E7
    or $80
    ld (iy + 0), a
    ret

byte_97ef:
    db 2, 6, 14, 6, 6, 14, 6, 2, 10, 14, 10, 2, 12, 8, 4, 8, 8, 4, 8, 12, 8, 4, 8, 12

sub_9807:
    ld a, (diamond_ram)
    rla
    jr nc, loc_983f
    ld ix, appledata
    ld b, (ix + 1)
    ld c, (ix + 2)
    ld a, (iy + 3)
    sub b
    jr nc, loc_9820
    cpl
    inc a
loc_9820:
    cp 6
    jr nc, loc_983f
    ld a, (iy + 4)
    sub c
    jr nc, loc_982c
    cpl
    inc a
loc_982c:
    cp 6
    jr nc, loc_983f
    ld de, $03E8
    call sub_b601
    ld hl, diamond_ram
    res 7, (hl)
    ld a, 2
    ret
loc_983f:
    xor a
    ret

sub_9842:  ; TEST MRDO COLLISION AGAINST ENEMIES
    ld a, ($7272)
    bit 4, a
    jr z, loc_98a2
    ld a, (gameflags)
    bit 7, a  ; test chomper mode 
    jr nz, loc_986c
    ld a, ($728B)
    call test_signal
    and a
    jr z, loc_986c
    ld hl, $1E
    xor a
    call request_signal
    ld ($728B), a
    ld a, ($728C)
    dec a
    ld ($728C), a
    jr z, loc_9892
loc_986c:
    ld iy, enemy_data_array
    ld b, 7
loc_9872:
    bit 7, (iy + 4)
    jr z, loc_9887
    bit 6, (iy + 4)
    jr nz, loc_9887
    push bc
    call sub_9fc8
    ld l, 1
    pop bc
    jr nz, loc_98cb
loc_9887:
    ld de, 6
    add iy, de
    djnz loc_9872
    ld l, d
    jr loc_98cb
loc_9892:
    ld a, ($7272)
    res 4, a
    ld ($7272), a
    ld a, ($728A)
    set 4, a
    ld ($728A), a
loc_98a2:
    jp loc_d40b
loc_98a5:
    call sub_98ce
    ld a, ($728C)
    ld c, a
    ld b, 0
    ld hl, byte_9a24
    add hl, bc
    ld c, (hl)
    ld iy, enemy_data_array
    ld l, b
    add iy, bc
    ld a, (iy + 4)
    bit 7, a
    jr z, loc_98c2
    bit 6, a
    jr nz, loc_98c2
    bit 7, (iy + 0)
    jr nz, loc_98c2
    call sub_9a2c
    ld l, a
loc_98c2:
    ld a, ($728C)
    inc a
    and 7
    ld ($728C), a
loc_98cb:
    ld a, l
    and a  ; return L=A=1 if collison
    ret

sub_98ce:
    push ix
    ld a, ($728A)
    bit 3, a
    jr nz, loc_9928
    ld ix, $72B2
    ld a, (ix + 3)
    call test_signal
    and a
    jr z, loc_9928
    call sub_9980
    jr z, loc_991e
;	LD		BC, 6078H	; unused
    call sub_992b
    jr z, loc_98f6
    ld hl, 1
    jr loc_9915
loc_98f6:
    ld (iy + 0), $28
    ld (iy + 4), $81
    xor a
    ld hl, 6
    call request_signal
    ld (iy + 3), a
    ld bc, $6078
    ld (iy + 2), b
    ld (iy + 1), c
    ld (iy + 5), 5
    call sub_9980
    jr z, loc_991e
    ld hl, $00D2
    ld a, ($728A)
    bit 2, a
    jr nz, loc_9910
    ld l, $1E
loc_9910:
    xor 4
    ld ($728A), a
loc_9915:
    xor a
    call request_signal
    ld (ix + 3), a
    jr loc_9928
loc_991e:
    ld a, ($7272)
    set 0, a
    set 7, a
    ld ($7272), a
loc_9928:
    pop ix
    ret

sub_992b:
    push iy
    ld iy, enemy_data_array  ; enemy data starts here = 6*7 bytes
    ld bc, $0700  ; B = enemy number
loc_9934:
    ld a, (iy + 4)
    bit 7, a
    jr z, loc_994d
    bit 6, a
    jr nz, loc_994d
    ld a, (iy + 2)
    sub $60
    jr nc, loc_9948
    cpl
    inc a
loc_9948:
    cp $0D
    jr nc, loc_994d
    inc c
loc_994d:
    ld de, 6
    add iy, de  ; next enemy
    djnz loc_9934
    ld a, c
    cp 2
    jr nc, loc_995c
    xor a
    jr loc_995e
loc_995c:
    ld a, 1
loc_995e:
    pop iy
    and a
    ret

sub_9980:
    ld iy, enemy_data_array
    ld l, 7
    ld de, 6
loc_9989:
    bit 7, (iy + 4)
    jr z, loc_999c
    add iy, de
    dec l
    jr nz, loc_9989
    ld a, ($728A)
    set 3, a
    ld ($728A), a
loc_999c:
    ld a, l
    and a
    ret

sub_999f:
    ld a, ($728A)
    bit 5, a
    jr nz, loc_99bb
    set 5, a
    ld ($728A), a
    ld hl, $3C
    xor a
    call request_signal
    ld ix, $72B2
    ld (ix + 3), a
    jr loc_9a07
loc_99bb:
    ld a, ($728B)
    call test_signal
    and a
    ret z
    ld a, ($728D)
    ld d, a
    ld a, ($728A)
    set 6, a
    bit 7, a
    jr z, loc_99e4
    res 7, a
    ld ($728A), a
    inc d
    jr nz, loc_99db
    ld d, $00FF
loc_99db:
    ld a, d
    ld ($728D), a
    ld a, ($728A)
    jr loc_99e9
loc_99e4:
    set 7, a
    ld ($728A), a
loc_99e9:
    ld e, 7
    ld bc, 6
    ld iy, enemy_data_array
loc_99f2:
    ld h, (iy + 4)
    set 5, h
    set 4, h
    bit 7, a
    jr z, loc_99ff
    res 4, h
loc_99ff:
    ld (iy + 4), h
    add iy, bc
    dec e
    jr nz, loc_99f2
loc_9a07:
    ld hl, $1E
    xor a
    call request_signal
    ld ($728B), a
    ret


byte_9a24:
    db 0, 6, 12, 18, 24, 30, 36, 42

sub_9a2c:
    push ix
    ld a, (iy + 3)
    call test_signal
    and a
    jr z, loc_9ab1
    ld a, (iy + 0)
    bit 5, a
    jr z, loc_9a50
    bit 3, a
    jr z, loc_9a49
    call sub_9b91
    jr nz, loc_9a5e
    jr loc_9a75
loc_9a49:
    call sub_9bbd
    jr nz, loc_9a59
    jr loc_9a75
loc_9a50:
    bit 4, a
    jr z, loc_9a5e
    call sub_9c76
    jr nz, loc_9a75
loc_9a59:
    call sub_a460
    jr loc_9aa0
loc_9a5e:
    call sub_a1df
    jr nz, loc_9a75
    call sub_9cab
    jr nz, loc_9a6d
    call sub_9e7c
    jr loc_9a75
loc_9a6d:
    call sub_9ff4
    jr z, loc_9aa0
    call sub_9e3f
loc_9a75:
    ld a, (iy + 4)
    and 7
    call sub_9d2f
    jr z, loc_9aa0
    ld a, (iy + 4)
    and 7
    dec a
    ld c, a
    ld b, 0
    ld hl, byte_9ab5
    add hl, bc
    ld b, (hl)
    push bc
    call sub_9f29
    pop bc
    and b
    jr z, loc_9aa0
    call sub_9e7a
    ld a, (iy + 4)
    and 7
    call sub_9d2f
loc_9aa0:
    call sub_9ab9
    call sub_9ae2
    ld a, (iy + 4)
    and $00C7
    ld (iy + 4), a
    call sub_9fc8
loc_9ab1:
    pop ix
    and a
    ret

byte_9ab5:
    db 176, 112, 224, 208

sub_9ab9:
    push de
    push hl
    ld e, (iy + 0)
    ld hl, 6
    bit 5, e
    jr nz, loc_9ad8
    bit 4, e
    jr z, loc_9ace
    call sub_9be2
    jr loc_9ad8
loc_9ace:
    call sub_9bda
    bit 3, (iy + 4)
    jr z, loc_9ad8
    add hl, hl
loc_9ad8:
    xor a
    call request_signal
    ld (iy + 3), a
    pop hl
    pop de
    ret

sub_9ae2:
    push ix
    push iy
    ld h, (iy + 0)
    ld d, 1
    bit 6, h
    jr nz, loc_9b07
    ld d, $0D
    bit 5, h
    jr nz, loc_9b07
    call sub_9b4f
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_ac3f
    ld d, a
    call sub_b173
    ld d, $19
loc_9b07:
    ld a, (iy + 4)
    and 7
    ld l, 0
    dec a
    jr z, loc_9b28
    ld l, 2
    dec a
    jr z, loc_9b28
    ld l, 4
    ld b, a
    ld a, (iy + 1)
    cp $80
    jr nc, loc_9b22
    ld l, 8
loc_9b22:
    dec b
    jr z, loc_9b28
    inc l
    inc l
loc_9b28:
    ld c, (iy + 5)
    bit 7, c
    jr z, loc_9b33
    res 7, c
    jr loc_9b36
loc_9b33:
    set 7, c
    inc l
loc_9b36:
    ld (iy + 5), c
    ld a, d
    add a, l
    ld d, a
    ld a, ($728C)
    add a, 5
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_b629
    pop iy
    pop ix
    ret

sub_9b4f:
    push bc
    push de
    push hl
    push ix
    ld a, (iy + 0)
    bit 0, a
    jr nz, loc_9b83
    bit 5, a
    jr nz, loc_9b83
    ld a, (iy + 4)
    and 7
    dec a
    cp 4
    jr nc, loc_9b83
    ld hl, off_9b89
    add a, a
    ld c, a
    ld b, 0
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)
    push de
    pop ix
    ld b, (iy + 2)
    ld c, (iy + 1)
    ld de, loc_9b83
    push de
    jp (ix)
loc_9b83:
    pop ix
    pop hl
    pop de
    pop bc
    ret

off_9b89:
    dw sub_b2fa
    dw sub_b39d
    dw sub_b43f
    dw sub_b4e9

sub_9b91:
    call sub_9ba8
    ld b, 0
    jr nz, loc_9ba5
    ld a, (iy + 0)
    res 5, a
    set 6, a
    and $00F8
    ld (iy + 0), a
    inc b
loc_9ba5:
    ld a, b
    and a
    ret

sub_9ba8:
    ld a, (iy + 5)
    dec a
    ld (iy + 5), a
    and $3F
    ret

sub_9bb2:
    ld c, a
    ld a, (iy + 5)
    and $00C0
    or c
    ld (iy + 5), a
    ret

sub_9bbd:
    ld b, 0
    call sub_9ba8
    jr nz, loc_9bd7
    ld a, (iy + 0)
    and $00F8
    res 5, a
    set 4, a
    ld (iy + 0), a
    call sub_9be2
    call sub_9bb2
    inc b
loc_9bd7:
    ld a, b
    or a
    ret

sub_9bda:
    push bc
    push de
    push ix
    ld d, 0
    jr loc_9be8

sub_9be2:
    push bc
    push de
    push ix
    ld d, 1
loc_9be8:
    ld a, (skilllevel)
    dec a
    ld c, a
    ld b, 0
    ld ix, byte_9d1a
    add ix, bc
    ld c, (ix + 0)
    ld hl, current_level_p1
    ld a, (gamecontrol)
    inc a
    and 3
    jr nz, loc_9c05
    inc l
loc_9c05:
    ld a, (hl)
    dec a
    add a, c
    ld c, a
    ld a, ($728A)
    bit 4, a
    jr z, loc_9c12
    inc c
    inc c
loc_9c12:
    ld a, c
    cp $0F
    jr c, loc_9c19
    ld a, $0F
loc_9c19:
    add a, a
    ld c, a
    ld ix, byte_9c56
    ld a, d
    and a
    jr z, loc_9c27
    ld ix, byte_9c36
loc_9c27:
    add ix, bc
    ld l, (ix + 0)
    ld h, 0
    ld a, (ix + 1)
    pop ix
    pop de
    pop bc
    ret

byte_9c36:
    db 13, 9, 13, 9, 13, 9, 10, 12, 10, 12, 10, 12, 8, 15, 8, 15, 6, 20, 6, 20, 5, 24, 5, 24, 5, 24, 4, 30, 4, 30, 4, 30
byte_9c56:
    db 8, 1, 8, 1, 8, 1, 6, 1, 6, 1, 6, 1, 5, 1, 5, 1, 5, 1, 5, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1

sub_9c76:
    ld b, 0
    ld a, (iy + 5)
    and $3F
    jr z, loc_9c84
    call sub_9ba8
    jr nz, loc_9ca8
loc_9c84:
    ld a, (iy + 2)
    and $0F
    jr nz, loc_9ca8
    ld a, (iy + 1)
    and $0F
    cp 8
    jr nz, loc_9ca8
    ld a, (iy + 0)
    and $00F8
    res 4, a
    set 5, a
    set 3, a
    ld (iy + 0), a
    ld a, $0A
    call sub_9bb2
    inc b
loc_9ca8:
    ld a, b
    and a
    ret

sub_9cab:
    ld b, (iy + 0)
    bit 5, (iy + 4)
    jr nz, loc_9cba
    bit 2, b
    jr nz, loc_9cd4
    jr loc_9cda
loc_9cba:
    call sub_9ce0
    ld e, a
    ld a, ($728D)
    rra
    rra
    rra
    rra
    rra
    and 7
    add a, e
    ld e, a
    call rand_gen
    and $0F
    res 2, b
    cp e
    jr nc, loc_9cda
loc_9cd4:
    set 2, b
    res 0, b
    res 1, b
loc_9cda:
    ld (iy + 0), b
    bit 2, b
    ret

sub_9ce0:
    push de
    push hl
    ld a, (skilllevel)
    dec a
    ld e, a
    ld d, 0
    ld hl, byte_9d1a
    add hl, de
    ld e, (hl)
    ld hl, current_level_p1
    ld a, (gamecontrol)
    inc a
    and 3
    jr nz, loc_9cfb
    inc l
loc_9cfb:
    ld a, (hl)
    dec a
    add a, e
    ld e, a
    ld a, ($728A)
    bit 4, a
    jr z, loc_9d08
    inc e
    inc e
loc_9d08:
    ld a, e
    cp $0F
    jr c, loc_9d0f
    ld a, $0F
loc_9d0f:
    ld e, a
    ld d, 0
    ld hl, byte_9d1e
    add hl, de
    ld a, (hl)
    pop hl
    pop de
    ret

byte_9d1a:
    db 0, 3, 5, 7
byte_9d1e:
    db 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 14, 14

sub_9d2f:
    ld c, a
    xor a
    ld h, (iy + 0)
    bit 0, h
    ret nz
    bit 5, h
    ret nz
    push bc
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_9e07
    pop bc
    ret nz
    dec c
    ld a, c
    cp 4
    ld a, 0
    ret nc
    ld a, c
    rlca
    ld c, a
    ld b, 0
    ld hl, off_9d9f
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    ld b, (iy + 2)
    ld c, (iy + 1)
    ld e, 4
    jp (hl)
loc_9d67:
    ld a, c
    add a, e
    ld c, a
    jr loc_9d79
loc_9d6c:
    ld a, c
    sub e
    ld c, a
    jr loc_9d79
loc_9d71:
    ld a, b
    sub e
    ld b, a
    jr loc_9d79
loc_9d76:
    ld a, b
    add a, e
    ld b, a
loc_9d79:
    push hl
    push bc
    push iy
    pop hl
    ld bc, $72B8
    and a
    sbc hl, bc
    pop bc
    pop hl
    jr nc, loc_9d92
    ld a, (iy + 4)
    and 7
    call sub_9da7
    ret nz
loc_9d92:
    call sub_9e07
    ret nz
    ld (iy + 2), b
    ld (iy + 1), c
    and a
    ret

off_9d9f:
    dw loc_9d67
    dw loc_9d6c
    dw loc_9d71
    dw loc_9d76

sub_9da7:
    push bc
    push ix
    cp 3
    jr c, loc_9e01
    ld c, a
    ld ix, enemy_data_array
    ld hl, 7
loc_9db6:
    bit 7, (ix + 4)
    jr z, loc_9df0
    bit 6, (ix + 4)
    jr nz, loc_9df0
    ld a, (ix + 2)
    bit 2, c
    jr nz, loc_9dd5
    cp b
    jr z, loc_9dce
    jr nc, loc_9df0
loc_9dce:
    add a, $0C
    cp b
    jr c, loc_9df0
    jr loc_9ddd
loc_9dd5:
    cp b
    jr c, loc_9df0
    sub $0D
    cp b
    jr nc, loc_9df0
loc_9ddd:
    inc h
    ld a, h
    cp 1
    jr nz, loc_9df0
    push hl
    push iy
    pop de
    push ix
    pop hl
    and a
    sbc hl, de
    pop hl
    jr nc, loc_9e01
loc_9df0:
    ld de, 6
    add ix, de
    dec l
    jr nz, loc_9db6
    ld a, h
    cp 2
    jr c, loc_9e01
    ld a, $00FF
    jr loc_9e02
loc_9e01:
    xor a
loc_9e02:
    pop ix
    pop bc
    and a
    ret

sub_9e07:
    push bc
    ld a, (iy + 4)
    and 7
    ld d, a
    ld a, 3
    bit 4, (iy + 0)
    jr z, loc_9e17
    dec a
loc_9e17:
    ld e, a
    ld a, d
    cp 3
    ld a, e
    jr nc, loc_9e31
    call sub_aee1
    cp 2
    jr nc, loc_9e39
    dec a
    ld l, 0
    jr nz, loc_9e3b
    set 3, (iy + 4)
    jr loc_9e3b
loc_9e31:
    and a  ; CF==0 Monster collision offset
    call sub_b12d  ; Returns A=1 if vertical apple collision
    ld l, 0
    and a
    jr z, loc_9e3b
loc_9e39:
    ld l, 1
loc_9e3b:
    pop bc
    ld a, l
    and a
    ret

sub_9e3f:
    set 0, (iy + 0)
    bit 4, (iy + 4)
    jr z, loc_9e75
    call sub_a527
    jr z, loc_9e54
    bit 3, (iy + 4)
    jr z, loc_9e75
loc_9e54:
    call sub_9ce0
    and $0F
    ld b, a
    call rand_gen
    and $0F
    cp b
    jr nc, loc_9e75
    ld a, (iy + 0)
    and $00F8
    res 6, a
    set 5, a
    res 3, a
    ld (iy + 0), a
    ld a, $0A
    call sub_9bb2
loc_9e75:
    res 3, (iy + 4)
    ret


sub_9e7c:
    bit 4, (iy + 4)
    jr nz, loc_9eaa
    bit 0, (iy + 0)
    jp nz, loc_9f10
    ld a, (iy + 4)
    and 7
    dec a
    cp 4
    jr nc, loc_9eaa
    ld hl, byte_9f25
    ld c, a
    ld b, 0
    add hl, bc
    ld b, (hl)
    push bc
    call sub_9f29
    pop bc
    and a
    jr z, loc_9eaa
    ld c, a
    and b
    jr nz, loc_9f10
    ld a, c
    jr loc_9ebd
loc_9eaa:
    set 0, (iy + 0)
    call rand_gen
    and $0F
    cp 8
    jr c, loc_9f10
    call sub_9f29
    and a
    jr z, loc_9f10

sub_9e7a:
loc_9ebd:
    ld ix, byte_9f15
    ld c, 4
loc_9ec3:
    ld e, (ix + 1)
    cp (ix + 0)
    jr z, loc_9f03
    inc ix
    inc ix
    dec c
    jr nz, loc_9ec3
    ld b, a
loc_9ed3:
    call rand_gen
    and 3
    rlca
    ld hl, off_9f1d
    ld e, a
    ld d, 0
    add hl, de
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    jp (hl)
loc_9ee5:
    ld e, 3
    bit 4, b
    jr nz, loc_9f03
    jr loc_9ed3
loc_9eed:
    ld e, 4
    bit 5, b
    jr nz, loc_9f03
    jr loc_9ed3
loc_9ef5:
    ld e, 1
    bit 6, b
    jr nz, loc_9f03
    jr loc_9ed3
loc_9efd:
    ld e, 2
    bit 7, b
    jr z, loc_9ed3
loc_9f03:
    res 0, (iy + 0)
    ld a, (iy + 4)
    and $00F8
    or e
    ld (iy + 4), a
loc_9f10:
    bit 0, (iy + 0)
    ret

byte_9f15:
    db 16, 3, 32, 4, 64, 1, 128, 2

off_9f1d:
    dw loc_9ee5
    dw loc_9eed
    dw loc_9ef5
    dw loc_9efd

byte_9f25:
    db 64, 128, 16, 32

sub_9f29:
    push ix
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_ac3f
    ld c, a
    ld hl, unk_9fb3
    ld a, (iy + 1)
    rlca
    rlca
    rlca
    rlca
    and $00F0
    ld b, a
    ld a, (iy + 2)
    and $0F
    or b
    ld e, 7
loc_9f4a:
    cp (hl)
    jr z, loc_9f55
    inc hl
    inc hl
    inc hl
    dec e
    jr nz, loc_9f4a
; 	JR		LOC_9FA0  ; -mdl
loc_9fa0:
    ld a, (hl)
    and $00F0
    push af
    ld a, c
    call sub_abb7
    ld (iy + 2), b
    ld (iy + 1), c
    pop af
loc_9faf:
    and a
    pop ix
    ret
loc_9f55:
    xor a
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    push ix
    push de
    pop ix
    pop hl
    jp (ix)
loc_9f62:
    bit 1, (hl)
    jr z, loc_9f6c
    bit 3, (hl)
    jr z, loc_9f6c
    set 6, a
loc_9f6c:
    dec hl
    bit 0, (hl)
    jr z, loc_9faf
    bit 2, (hl)
    jr z, loc_9faf
    set 7, a
    jr loc_9faf
loc_9f79:
    ld a, (hl)
    and $00F0
    jr loc_9faf
loc_9f7e:
    ld a, $00C0
    jr loc_9faf
loc_9f82:
    bit 2, (hl)
    jr z, loc_9f8c
    bit 3, (hl)
    jr z, loc_9f8c
    set 5, a
loc_9f8c:
    ld bc, $FFF0
    add hl, bc
    bit 0, (hl)
    jr z, loc_9faf
    bit 1, (hl)
    jr z, loc_9faf
    set 4, a
    jr loc_9faf
loc_9f9c:
    ld a, $30
    jr loc_9faf

unk_9fb3:
    db 0
    dw loc_9f62
    db $40
    dw loc_9f7e
    db $80
    dw loc_9f79
    db $00C0
    dw loc_9f7e
    db $88
    dw loc_9f82
    db $84
    dw loc_9f9c
    db $8C
    dw loc_9f9c

sub_9fc8:
    push iy
    ld b, (iy + 2)
    ld a, (mrdo_data.y)
    sub b
    jr nc, loc_9fd5
    cpl
    inc a
loc_9fd5:
    ld l, 0
    cp 5
    jr nc, loc_9fef
    ld b, (iy + 1)
    ld a, (mrdo_data.x)
    sub b
    jr nc, loc_9fe6
    cpl
    inc a
loc_9fe6:
    cp 5
    jr nc, loc_9fef
    call play_lose_life_sound  ; XXX DEATH SEQUENCE HERE 
    ld l, 1
loc_9fef:
    pop iy
    ld a, l
    and a
    ret

sub_9ff4:
    push ix
    call sub_9f29
    push af
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_ac3f
    pop bc
    call sub_a028
    jr nz, loc_a00c
    call sub_a1ac
loc_a00c:
    cp 2
    jr z, loc_a01e
    ld a, (iy + 4)
    and 7
    call sub_9d2f
    jr z, loc_a024
    inc a
    jr z, loc_a022
loc_a01e:
    set 3, (iy + 4)
loc_a022:
    ld a, 1
loc_a024:
    and a
    pop ix
    ret

sub_a028:
    push bc
    push ix
    push af
    ld a, (iy + 2)
    and $0F
    ld c, a
    ld a, (iy + 1)
    rlca
    rlca
    rlca
    rlca
    and $00F0
    or c
    ld c, 7
    ld hl, unk_a12a
loc_a041:
    cp (hl)
    jr z, loc_a04d
    inc hl
    inc hl
    inc hl
    dec c
    jr nz, loc_a041
    dec hl
    dec hl
    dec hl
loc_a04d:
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    push de
    pop ix
    pop hl
    ld a, h
    ld l, $00FF
    call sub_a13f
    jr z, loc_a05e
    ld l, a
loc_a05e:
    jp (ix)

loc_a060:
    ld c, $41
    ld a, h
    dec a
    call sub_a13f
    jr z, loc_a06f
    cp l
    jr nc, loc_a06f
    ld c, $82
    ld l, a
loc_a06f:
    jp loc_a102
loc_a072:
    ld c, $82
    ld a, h
    inc a
    call sub_a13f
    jr z, loc_a081
    cp l
    jr nc, loc_a081
    ld l, a
    ld c, $41
loc_a081:
    jp loc_a102
loc_a084:
    ld c, $13
    ld a, h
    add a, $10
    call sub_a13f
    jr z, loc_a094
    cp l
    jr nc, loc_a094
    ld l, a
    ld c, $24
loc_a094:
    jp loc_a102
loc_a097:
    ld c, $24
    ld a, h
    sub $10
    call sub_a13f
    jr z, loc_a0a7
    cp l
    jr nc, loc_a0a7
    ld l, a
    ld c, $13
loc_a0a7:
    jp loc_a102
loc_a0aa:
    ld l, $00FF
    ld a, h
    and $0F
    jr z, loc_a0bf
    bit 6, b
    jr z, loc_a0bf
    ld a, h
    inc a
    call sub_a13f
    jr z, loc_a0bf
    ld l, a
    ld c, $41
loc_a0bf:
    ld a, h
    dec a
    and $0F
    jr z, loc_a0d6
    bit 7, b
    jr z, loc_a0d6
    ld a, h
    dec a
    call sub_a13f
    jr z, loc_a0d6
    cp l
    jr nc, loc_a0d6
    ld l, a
    ld c, $82
loc_a0d6:
    ld a, h
    cp $11
    jr c, loc_a0ec
    bit 4, b
    jr z, loc_a0ec
    sub $10
    call sub_a13f
    jr z, loc_a0ec
    cp l
    jr nc, loc_a0ec
    ld l, a
    ld c, $13
loc_a0ec:
    ld a, h
    cp $91
    jr nc, loc_a102
    bit 5, b
    jr z, loc_a102
    add a, $10
    call sub_a13f
    jr z, loc_a102
    cp l
    jr nc, loc_a102
    ld l, a
    ld c, $24
loc_a102:
    ld d, 0
    ld a, l
    inc a
    jr z, loc_a124
    ld a, c
    and 7
    ld l, a
    ld a, (iy + 4)
    and $00F8
    or l
    ld (iy + 4), a
    ld a, c
    inc d
    and $00F0
    and b
    jr nz, loc_a124
    set 0, (iy + 0)
    inc d
loc_a124:
    pop ix
    pop bc
    ld a, d
    and a
    ret

unk_a12a:
    db 0
    dw loc_a060
    db $40
    dw loc_a060
    db $00C0
    dw loc_a072
    db $84
    dw loc_a084
    db $88
    dw loc_a097
    db $8C
    dw loc_a097
    db $80
    dw loc_a0aa

sub_a13f:
    push bc
    push de
    push hl
    push ix
    ld d, a
    ld a, (badguy_bhvr_cnt_ram)
    and a
    jr z, loc_a159
    ld c, a
    ld b, 0
    dec bc
    ld hl, badguy_behavior_ram
    add hl, bc
    inc bc
    ld a, d
    cpdr
    jr z, loc_a182
loc_a159:
    ld hl, badguy_behavior_ram
    ld bc, $4F
    add hl, bc
    push hl
    pop ix
    ld hl, badguy_behavior_ram
    ld a, (badguy_bhvr_cnt_ram)
    ld c, a
    add hl, bc
    ld b, h
    ld c, l
    push ix
    pop hl
    xor a
    sbc hl, bc
    jr z, loc_a1a4
    inc hl
    ld b, h
    ld c, l
    push ix
    pop hl
    ld a, d
    cpdr
    jr nz, loc_a1a4
loc_a182:
    inc hl
    push hl
    ld hl, badguy_behavior_ram
    ld a, (badguy_bhvr_cnt_ram)
    ld c, a
    ld b, 0
    and a
    jr nz, loc_a193
    ld c, $50
loc_a193:
    dec bc
    add hl, bc
    pop bc
    xor a
    sbc hl, bc
    jr nc, loc_a1a0
    ld e, $50
    add hl, de
;	XOR		A	; unused
loc_a1a0:
    inc l
    ld a, l
    jr loc_a1a5
loc_a1a4:
    xor a
loc_a1a5:
    pop ix
    pop hl
    pop de
    pop bc
    and a
    ret

sub_a1ac:
    ld l, 0
    ld h, (iy + 1)
    ld a, (mrdo_data.x)
    cp h
    jr z, loc_a1bf
    jr c, loc_a1bd
    set 6, l
    jr loc_a1bf
loc_a1bd:
    set 7, l
loc_a1bf:
    ld h, (iy + 2)
    ld a, (mrdo_data.y)
    cp h
    jr z, loc_a1d0
    jr c, loc_a1ce
    set 5, l
    jr loc_a1d0
loc_a1ce:
    set 4, l
loc_a1d0:
    ld a, l
    and b
    jr nz, loc_a1d8
    ld a, 2
    ret  ;JR		LOC_A1DD
loc_a1d8:
    call sub_9e7a
    ld a, 1
;LOC_A1DD:
;	AND		A	; unused
    ret

sub_a1df:
    push ix
    ld b, 0
    bit 5, (iy + 4)
    jr nz, loc_a20e
    bit 1, (iy + 0)
    jr z, loc_a254
    ld a, (iy + 4)
    and 7
    dec a
    cp 4
    jr nc, loc_a254
    ld hl, byte_9f25
    ld c, a
    add hl, bc
    ld c, (hl)
    push bc
    call sub_9f29
    pop bc
    and a
    jr z, loc_a254
    and c
    jr nz, loc_a252
    jr loc_a21e
loc_a20e:
    res 1, (iy + 0)
    call sub_9ce0
    ld c, a
    call rand_gen
    and $0F
    cp c
    jr nc, loc_a254
loc_a21e:
    ld a, (iy + 0)
    and $00F8
    ld (iy + 0), a
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_ac3f
    ld e, a
    call sub_a259
    jr nz, loc_a241
    call sub_a382
    jr z, loc_a241
    call sub_a402
    ld b, 0
    jr nz, loc_a254
loc_a241:
    push hl
    call sub_9f29
    pop hl
    ld b, 0
    and l
    jr z, loc_a254
    call sub_9e7a
    set 1, (iy + 0)
loc_a252:
    ld b, 1
loc_a254:
    ld a, b
    pop ix
    and a
    ret

sub_a259:
    push ix
    push de
    push bc
    ld a, (balldata)
    ld b, a
    xor a
    bit 6, b
    jr z, loc_a2b9
    push de
    ld a, e
    call sub_abb7
    push bc
    ld a, ($72DA)
    ld b, a
    ld a, ($72DB)
    ld c, a
    call sub_ac3f
    push af
    push ix
    call sub_abb7
    pop ix
    pop af
    pop hl
    pop de
    ld d, a
    sub e
    jr z, loc_a2b9
    ld a, (balldata)
    and 3
    jr nz, loc_a297
    call sub_a2c0
    jr nz, loc_a2b9
    call sub_a34c
    jr loc_a2b9
loc_a297:
    dec a
    jr nz, loc_a2a4
    call sub_a2e8
    jr nz, loc_a2b9
    call sub_a34c
    jr loc_a2b9
loc_a2a4:
    dec a
    jr nz, loc_a2b1
    call sub_a2c0
    jr nz, loc_a2b9
    call sub_a316
    jr loc_a2b9
loc_a2b1:
    call sub_a2e8
    jr nz, loc_a2b9
    call sub_a316
loc_a2b9:
    ld l, a
    pop bc
    pop de
    pop ix
    and a
    ret

sub_a2c0:
    push de
    push hl
    ld a, b
    cp h
    jr nz, loc_a2e3
    ld a, l
    sub c
    jr c, loc_a2e3
    cp $21
    jr nc, loc_a2e3
    inc d
    bit 6, (ix + 0)
    jr z, loc_a2e3
    ld a, e
    cp d
    jr z, loc_a2df
    bit 6, (ix + 1)
    jr z, loc_a2e3
loc_a2df:
    ld a, $70
    jr loc_a2e4
loc_a2e3:
    xor a
loc_a2e4:
    pop hl
    pop de
    and a
    ret

sub_a2e8:
    push de
    push hl
    push ix
    ld a, b
    cp h
    jr nz, loc_a30f
    ld a, c
    sub l
    jr c, loc_a30f
    cp $21
    jr nc, loc_a30f
    dec d
    bit 7, (ix + 0)
    jr z, loc_a30f
    ld a, e
    cp d
    jr z, loc_a30b
    dec ix
    bit 7, (ix + 0)
    jr z, loc_a30f
loc_a30b:
    ld a, $00B0
    jr loc_a310
loc_a30f:
    xor a
loc_a310:
    pop ix
    pop hl
    pop de
    and a
    ret

sub_a316:
    push de
    push hl
    push ix
    ld a, c
    cp l
    jr nz, loc_a345
    ld a, b
    sub h
    jr c, loc_a345
    cp $21
    jr nc, loc_a345
    ld a, d
    sub $10
    ld d, a
    bit 4, (ix + 0)
    jr z, loc_a345
    ld a, e
    cp d
    jr z, loc_a341
    push bc
    ld bc, $FFF0
    add ix, bc
    pop bc
    bit 4, (ix + 0)
    jr z, loc_a345
loc_a341:
    ld a, $00D0
    jr loc_a346
loc_a345:
    xor a
loc_a346:
    pop ix
    pop hl
    pop de
;	AND		A		; unused
    ret

sub_a34c:
    push de
    push hl
    push ix
    ld a, c
    cp l
    jr nz, loc_a37b
    ld a, h
    sub b
    jr c, loc_a37b
    cp $21
    jr nc, loc_a37b
    ld a, d
    add a, $10
    ld d, a
    bit 5, (ix + 0)
    jr z, loc_a37b
    ld a, e
    cp d
    jr z, loc_a377
    push bc
    ld bc, $10
    add ix, bc
    pop bc
    bit 5, (ix + 0)
    jr z, loc_a37b
loc_a377:
    ld a, $00E0
    jr loc_a37c
loc_a37b:
    xor a
loc_a37c:
    pop ix
    pop hl
    pop de
;	AND		A	; unused
    ret

sub_a382:
    push bc
    push de
    push ix
    push iy
    ld a, e
    push de
    call sub_abb7
    pop de
    ld l, 5
    ld iy, appledata
loc_a394:
    bit 7, (iy + 0)
    jr z, loc_a3ee
    bit 5, (iy + 0)
    jr z, loc_a3ee
    ld a, c
    cp (iy + 2)
    jr nz, loc_a3ee
    ld a, b
    cp (iy + 1)
    jr c, loc_a3ee
    push bc
    push de
    push hl
    push ix
    ld b, (iy + 1)
    ld c, (iy + 2)
    call sub_ac3f
    pop ix
    pop hl
    pop de
    pop bc
    ld h, a
    ld d, e
loc_a3c1:
    push bc
    ld bc, $FFF0
    add ix, bc
    pop bc
    ld a, d
    sub $10
    ld d, a
    ld a, (ix + 0)
    inc a
    and $0F
    jr nz, loc_a3ee
    ld a, h
    cp d
    jr c, loc_a3c1
    ld l, $00E0
    pop iy
    ld a, (iy + 1)
    cp c
    jr z, loc_a3eb
    res 7, l
    jr nc, loc_a3eb
    set 7, l
    res 6, l
loc_a3eb:
    xor a
    jr loc_a3fc
loc_a3ee:
    push bc
    ld bc, 5
    add iy, bc
    pop bc
    dec l
    jr nz, loc_a394
    ld a, 1
    pop iy
loc_a3fc:
    pop ix
    pop de
    pop bc
    and a
    ret

sub_a402:
    push bc
    push de
    push ix
    ld b, (iy + 2)
    ld c, (iy + 1)
    ld l, 5
    ld ix, appledata
loc_a412:
    bit 7, (ix + 0)
    jr z, loc_a44d
    bit 6, (ix + 0)
    jr z, loc_a44d
    ld d, (ix + 1)
    ld e, (ix + 2)
    ld a, b
    cp d
    jr c, loc_a44d
    sub d
    cp $21
    jr nc, loc_a44d
    ld a, c
    sub e
    jr nc, loc_a433
    cpl
    inc a
loc_a433:
    cp $11
    jr nc, loc_a44d
; LD		H, 0
    ld a, (iy + 1)
; LD		L, 0E0H
    ld hl, $00E0
    cp (ix + 2)
    jr z, loc_a459
    res 7, l
    jr nc, loc_a459
    set 7, l
    res 6, l
    jr loc_a459
loc_a44d:
    push bc
    ld bc, 5
    add ix, bc
    pop bc
    dec l
    jr nz, loc_a412
    ld h, 1
loc_a459:
    pop ix
    pop de
    pop bc
    ld a, h
    and a
    ret

sub_a460:
    call sub_a497
    ret z
loc_a465:
    ld l, a
    push hl
    call sub_9e7a
    ld a, (iy + 4)
    and 7
    call sub_9d2f
    pop hl
    ret z
    ld a, (iy + 4)
    and 7
    ld c, $00C0
    cp 3
    jr nc, loc_a482
    ld c, $30
loc_a482:
    ld a, l
    and c
    jr nz, loc_a465
    ld a, (iy + 4)
    bit 0, a
    jr z, loc_a490
    inc a
    jr loc_a491
loc_a490:
    dec a
loc_a491:
    ld (iy + 4), a
    ret

sub_a497:
    ld a, (iy + 2)
    ld b, a
    and $0F
    jr nz, loc_a512
    ld a, (iy + 1)
    ld c, a
    and $0F
    cp 8
    jr nz, loc_a512
    ld h, 0
    ld a, (mrdo_data.y)
    cp b
    jr z, loc_a4b9
    jr nc, loc_a4b7
    set 4, h
    jr loc_a4b9
loc_a4b7:
    set 5, h
loc_a4b9:
    ld a, (mrdo_data.x)
    cp c
    jr z, loc_a520
    ld a, c
    jr c, loc_a4c8
    set 6, h
    add a, $10
    jr loc_a4cc
loc_a4c8:
    set 7, h
    sub $10
loc_a4cc:
    ld c, a
    ld ix, appledata
    ld l, 5
loc_a4d3:
    bit 7, (ix + 0)
    jr z, loc_a4f3
    ld a, (ix + 1)
    sub 9
    cp b
    jr nc, loc_a4f3
    add a, $12
    cp b
    jr c, loc_a4f3
    ld a, (ix + 2)
    sub $0F
    cp c
    jr nc, loc_a4f3
    add a, $1F
    cp c
    jr nc, loc_a4fd
loc_a4f3:
    ld de, 5
    add ix, de
    dec l
    jr nz, loc_a4d3
    jr loc_a520
loc_a4fd:
    ld a, h
    and $30
    ld h, a
    jr nz, loc_a520
    set 4, h
    ld a, (iy + 2)
    cp $30
    jr nc, loc_a520
    res 4, h
    set 5, h
    jr loc_a520
loc_a512:
    ld a, (iy + 4)
    and 7
    dec a
    ld e, a
    ld d, 0
    ld hl, byte_a523
    add hl, de
    ld h, (hl)
loc_a520:
    ld a, h
    and a
    ret

byte_a523:
    db 64, 128, 16, 32

sub_a527:
    push bc
    ld a, (gamecontrol)
    ld b, a
    ld a, (enemy_num_p1)
    bit 0, b
    jr z, loc_a53a
    bit 1, b
    jr z, loc_a53a
    ld a, (enemy_num_p2)
loc_a53a:
    cp 1
    pop bc
    ret

sub_a53e:
    ld a, ($72BA)
    bit 7, a
    jr nz, loc_a551
    set 7, a
    ld ($72BA), a
    ld a, $40
    ld ($72BD), a
    jr loc_a5a6
loc_a551:
    ld a, ($72BD)
    bit 7, a
    ld a, 0
    jr nz, loc_a5bb
    ld a, ($72C0)
    call test_signal
    and a
    jr z, loc_a5bb
    ld a, ($72BA)
    bit 6, a
    jr z, loc_a56f
    call sub_a6bb
    jr loc_a5aa
loc_a56f:
    ld a, ($7272)
    bit 5, a
    jr nz, loc_a57b
    call sub_a61f
    jr z, loc_a591
loc_a57b:
    call sub_a5f9
    jr nz, loc_a591
    call sub_a662
    ld hl, $7272
    bit 5, (hl)
    jr z, loc_a5a9
    res 5, (hl)
    call sub_b8a3
    jr loc_a5a9
loc_a591:
    jp loc_d309


loc_a596:
    ld a, ($7272)
    bit 4, a
    jr nz, loc_a5a9
    ld hl, $72C2
    dec (hl)
    jr nz, loc_a5a9
loc_a5a6:
    call sub_a5bd
loc_a5a9:
    xor a
loc_a5aa:
    push af
    ld hl, $0A
    xor a
    call request_signal
    ld ($72C0), a
    pop af
    push af
    call sub_a788
    pop af
loc_a5bb:
    and a
    ret

sub_a5bd:
    ld a, ($72BA)
    inc a
    and $00F7
    ld ($72BA), a
    ld hl, byte_a5f1
    ld a, ($72BA)
    and 7
    ld c, a
    ld b, 0
    add hl, bc
    ld a, (hl)
    ld ($72BE), a
    ld a, $0C
    ld ($72BF), a
    ld hl, byte_a616
    add hl, bc
    ld a, (hl)
    ld ($72BC), a
    ld hl, byte_a617
    add hl, bc
    ld a, (hl)
    ld ($72BB), a
    ld a, $18
    ld ($72C2), a
    ret

byte_a5f1:
    db 91, 107, 123, 139, 155, 139, 123, 107

sub_a5f9:
    ld a, ($72BA)
    and 7
    ld c, a
    ld b, 0
    ld hl, byte_a617
    add hl, bc
    ld b, (hl)
    ld hl, $72B8
    ld a, (gamecontrol)
    inc a
    and 3
    jr nz, loc_a613
    inc l
loc_a613:
    ld a, (hl)
    and b
    ret

byte_a616:
    db 2
byte_a617:
    db 1, 2, 4, 8, 16, 8, 4, 2

sub_a61f:
;    LD      HL, $727A ; duplicated
    ld bc, (score_p1_ram)
    ld hl, $727A
    ld a, (gamecontrol)
    inc a
    and 3
    jr nz, loc_a637
    inc l
    ld bc, (score_p2_ram)
loc_a637:
    ld d, (hl)
    ld e, 0
loc_a63a:
    ld a, c
    sub $00F4
    ld c, a
    ld a, b
    sbc a, 1
    ld b, a
    jr c, loc_a647
    inc e
    jr loc_a63a
loc_a647:
    ld a, e
    ld e, 0
    cp d
    jr z, loc_a65f
    ld (hl), a
    ld a, ($72BA)
    ld b, a
    bit 6, a
    jr nz, loc_a65f
    ld a, ($72BA)
    set 5, a
    ld ($72BA), a
    inc e
loc_a65f:
    ld a, e
    and a
    ret

sub_a662:
    ld a, (gamecontrol)
    bit 1, a
    ld a, (current_level_p1)
    jr z, loc_a66f
    ld a, (current_level_p2)
loc_a66f:
    cp $0B
    jr c, loc_a677
    sub $0A
    jr loc_a66f
loc_a677:
    cp 4
    jr nz, loc_a67f
    ld a, $98
    jr loc_a681
loc_a67f:
    ld a, $78
loc_a681:
    ld ($72BE), a
    ld a, $20
    ld ($72BF), a
    ld a, $0C
    ld ($72C2), a
    ld a, ($72BA)
    set 6, a
    ld ($72BA), a
    ld a, ($7272)
    bit 5, a
    jr nz, loc_a6ab
    ld hl, $72C4
    set 0, (hl)
    ld hl, $05A0
    call request_signal
    ld (gametimer), a
loc_a6ab:
    ld a, ($72BA)
    bit 5, a
    ret z
    res 5, a
    ld ($72BA), a
    jp loc_d31c

sub_a6bb:
    push ix
    push iy
    ld a, ($72C4)
    bit 0, a
    jr z, loc_a6f2
    call sub_a61f
    ld a, (gametimer)
    call test_signal
    and a
    jr z, loc_a6f2
    ld hl, $72C4
    res 0, (hl)
    ld a, $40
    ld ($72BD), a
    ld a, 1
    ld ($72C2), a
    ld a, ($72BA)
    res 6, a
    res 5, a
    ld ($72BA), a
    call sub_ca24
    xor a
    jp loc_a77e
loc_a6f2:
    ld iy, $72BD
    set 4, (iy + 0)
    call sub_9f29
    ld d, a
    push de
    ld hl, $7272
    bit 5, (hl)
    jr z, loc_a70b
    res 5, (hl)
    call sub_b8a3
loc_a70b:
    call sub_a527
    pop de
    jr z, loc_a74b
    ld a, ($728A)
    bit 4, a
    jr nz, loc_a74b
loc_a718:
    ld a, ($72C2)
    dec a
    ld ($72C2), a
    jr nz, loc_a72f
    ld a, $0C
    ld ($72C2), a
    call rand_gen
    and $0F
    cp 7
    jr nc, loc_a76b
loc_a72f:
    ld a, ($72C1)
    and $0F
    ld c, a
    ld b, 0
    ld hl, byte_a783
    add hl, bc
    ld a, (hl)
    and d
    jr z, loc_a76b
    ld a, ($72C1)
    and $0F
    call sub_9d2f
    jr z, loc_a77b
    jr loc_a76b
loc_a74b:
    ld a, ($72BF)
    ld b, a
    ld a, ($72BE)
    ld c, a
    push de
    call sub_ac3f
    pop bc
    call sub_a028
    jr z, loc_a718
    cp 2
    jr z, loc_a76b
    ld a, ($72C1)
    and 7
    call sub_9d2f
    jr z, loc_a77b
loc_a76b:
    call sub_9f29
    jr z, loc_a77b
    call sub_9e7a
    ld a, ($72C1)
    and 7
    call sub_9d2f
loc_a77b:
    call sub_9fc8
loc_a77e:
    pop iy
    pop ix
    ret

byte_a783:
    db 0, 64, 128, 16, 32

sub_a788:
    ld a, ($7272)
    bit 4, a
    jr z, loc_a796
    ld a, ($72BA)
    bit 6, a
    ret z
loc_a796:
    ld a, (gamecontrol)
    bit 1, a
    ld ix, $72B8
    jr z, loc_a7a5
    inc ixl
loc_a7a5:
    ld a, ($72BA)
    and 7
    ld hl, byte_a7dc
    ld c, a
    add a, a
    add a, c
    ld c, a
    ld b, 0
    add hl, bc
    ld a, (hl)
    inc hl
    and (ix + 0)
    jr z, loc_a7bc
    inc hl
loc_a7bc:
    ld d, (hl)
    ld a, ($72BA)
    bit 5, a
    jr z, loc_a7c8
    res 5, a
    jr loc_a7cb
loc_a7c8:
    set 5, a
    inc d
loc_a7cb:
    ld ($72BA), a
    ld a, ($72BF)
    ld b, a
    ld a, ($72BE)
    ld c, a
    ld a, 3
    jp sub_b629

byte_a7dc:
    db 1, 1, 12, 2, 3, 14, 4, 5, 16, 8, 7, 18, 16, 9, 20, 8, 7, 18, 4, 5, 16, 2, 3, 14

sub_a7f4:
    ld a, ($72C5)
    and 3
    ld iy, chompdata
    ld bc, 6
loc_a800:
    dec a
    jp m, loc_a808
    add iy, bc
    jr loc_a800
loc_a808:
    bit 7, (iy + 4)
    jr z, loc_a82b
    bit 7, (iy + 0)
    jr nz, loc_a82b
    ld a, (iy + 3)
    call test_signal
    and a
    jr z, loc_a82b
    call sub_a83e
    call sub_a8cb
    call sub_a921
    call sub_9fc8
    jr loc_a82c
loc_a82b:
    xor a
loc_a82c:
    push af
    ld hl, $72C5
    inc (hl)
    ld a, (hl)
    and 3
    cp 3
    jr nz, loc_a83c
    ld a, (hl)
    and $00FC
    ld (hl), a
loc_a83c:
    pop af
    ret


loc_a853:
    jp sub_a460
loc_a858:
    ld a, (iy + 2)
    and $0F
    jr nz, loc_a868
    ld a, (iy + 1)
    and $0F
    cp 8
    jr z, loc_a878
loc_a868:
    ld a, (iy + 4)
    and 7
    dec a
    ld e, a
    ld d, 0
    ld hl, byte_a8c7
    add hl, de
    ld h, (hl)
    jr loc_a898
loc_a878:
    ld h, $00F0
    ld a, (iy + 2)
    cp $28
    jr nc, loc_a883
    res 4, h
loc_a883:
    cp $00A8
    jr c, loc_a889
    res 5, h
loc_a889:
    ld a, (iy + 1)
    cp $20
    jr nc, loc_a892
    res 7, h
loc_a892:
    cp $00E0
    jr c, loc_a898
    res 6, h
loc_a898:
    ld a, h
    push hl
    call sub_9e7a
    ld a, (iy + 4)
    and 7
    call sub_9d2f
    pop hl
    ret z
    ld a, (iy + 4)
    jp loc_d3d5

loc_a8af:
    jr nc, loc_a8b3
    ld c, $30
loc_a8b3:
    ld a, h
    and c
    ld h, a
    jr nz, loc_a898
    ld a, (iy + 4)
    bit 0, a
    jr z, loc_a8c2
    inc a
    jr loc_a8c3
loc_a8c2:
    dec a
loc_a8c3:
    ld (iy + 4), a
    ret

byte_a8c7:
    db 64, 128, 16, 32

sub_a8cb:
    call sub_9b4f
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_ac3f
    ld d, a
    call sub_b173
    ld d, 1
    ld a, (iy + 4)
    and 7
    cp d
    jr z, loc_a905
    cp 2
    jr nz, loc_a8ee
    inc d
    inc d
    jr loc_a905
loc_a8ee:
    ld a, ($72C5)
    add a, a
    add a, a
    ld c, a
    ld b, 0
    ld hl, $712F
    add hl, bc
    ld a, (hl)
    cp $00E0
    jr z, loc_a905
    cp $00E4
    jr z, loc_a905
    inc d
    inc d
loc_a905:
    ld a, (iy + 5)
    bit 7, a
    jr z, loc_a90d
    inc d
loc_a90d:
    xor $80
    ld (iy + 5), a
    ld b, (iy + 2)
    ld c, (iy + 1)
    ld a, ($72C5)
    add a, $11
    jp sub_b629

sub_a921:
    call sub_9be2
    xor a
    call request_signal
    ld (iy + 3), a
    ret
completed_level:
    push af
    ld hl, $1E
    xor a
    call request_signal
    push af
completed_level.wait:
    pop af
    push af
    call test_signal
    and a
    jr z, completed_level.wait
    pop af
    pop af
    cp 2
    jr nz, loc_a969
    call play_end_of_round_tune
    ld hl, $0103
    call request_signal
    push af
loc_a992:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_a992
    pop af
    jr loc_a96c
loc_a969:
    call extramrdo
loc_a96c:
    call sub_aa25
    ld a, 2
    ret


got_diamond:
    ld hl, diamond_ram
    ld (hl), 0
    cp 1
    jr nz, completed_level
    ld hl, $78
    xor a
    call request_signal
    push af
got_diamond.wait:
    pop af
    push af
    call test_signal
    and a
    jr z, got_diamond.wait
    pop af
; 	JR		LOC_A973  ; -mdl
loc_a973:
    call sub_aa69
    cp 1
    ret z
    and a
    jr z, loc_a984
    push af
    ld hl, gamecontrol
    set 7, (hl)
loc_aae2:
    bit 7, (hl)
    jr nz, loc_aae2
    ld hl, pnt
    ld de, $0300
    xor a
    call fill_vram
    ld hl, sat
    ld de, $80
    xor a
    call fill_vram
    ld hl, sprite_name_table
    ld b, $50
loc_aaff:
    ld (hl), 0
    inc hl
    djnz loc_aaff
    pop af
    cp 2
    ld a, 7
    jr z, loc_ab0d
    inc a
loc_ab0d:
    call deal_with_playfield
    ld bc, $01E2
    call write_register
    xor a
    ld hl, $00B4
    call request_signal
    push af
loc_ab1e:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_ab1e
    pop af
    ld a, 1
    ret
loc_a984:
    jp sub_ab28


extramrdo:  ; CONGRATULATIONS! YOU WIN AN EXTRA MR. DO! TEXT and MUSIC
    ld hl, gamecontrol
    set 7, (hl)
loc_a9a1:
    bit 7, (hl)
    jr nz, loc_a9a1

    xor a
    ld ($72BC), a
    ld ($72BB), a
    ld hl, gamecontrol
    bit 1, (hl)
    jr nz, deal_with_extra_mr_do
    ld ($72B8), a
    ld l, lives_left_p1_ram and 255
    jr loc_a9ec
deal_with_extra_mr_do:
    ld ($72B9), a
    ld hl, lives_left_p2_ram
loc_a9ec:
    ld a, (hl)
    cp 6  ; max number of lives
    jr nc, loc_a9f2
    inc (hl)
loc_a9f2:
    ld bc, $01E2
    call write_register

; %%%%%%%%%%%%%%%%%%%%%%%%%%
; show the extra screen
    ld hl, mode
    set 7, (hl)  ; switch to intermission  mode

    call cvb_extrascreen
    call initialize_the_sound
    call play_win_extra_do_tune

    ld hl, $0280  ; music duration
    xor a
    call request_signal

    push af  ; wait for music to finish
loc_a9f2.1:
    call cvb_extrascreen_frm1  ; animate the FLAG
    call wait8
    call cvb_extrascreen_frm2
    call wait8
    pop af
    push af
    call test_signal
    and a
    jr z, loc_a9f2.1
    pop af

    call mydisscr

    ld hl, sprite_name_table
    ld b, $50  ; remove 20 sprites
loc_a9c0:
    ld (hl), 0
    inc hl
    djnz loc_a9c0

    ld hl, $0000  ; do not delete playar data in VRAM
    ld de, $3000
    xor a  ; fill with space
    call fill_vram

    ld hl, mode
    res 7, (hl)  ; switch to game mode

    call init_vram

    ld hl, gamecontrol
    set 7, (hl)
loc_aa14:
    bit 7, (hl)
    jr nz, loc_aa14

;	; Original code's final register writes
    ld bc, $01E2  ; Original game state register
    jp write_register

wait8:
    ld b, 8
wait8.1:    halt
    djnz wait8.1
    ret


sub_aa25:  ; Level complete, load next level
    ld hl, gamecontrol
    set 7, (hl)
loc_aa2a:
    bit 7, (hl)
    jr nz, loc_aa2a
    ld hl, current_level_p1  ; Player 1
    ld ix, enemy_num_p1
    ld a, (gamecontrol)
    bit 1, a
    jr z, loc_aa2a.playerone
    inc ixl
    inc l
loc_aa2a.playerone:

; Current level (either p1 or p2) is loaded into HL
    ld a, (hl)  ; Load level number
    ld b, 10
    call mod_b  ; Get modulo B

; test if we completed level 10xN
; if A==0 then go to WONDERFUL SCREEN

    jr nz, loc_aa2a.test_intermission
    push ix  ; Save Player data pointer 
    push hl  ; Save Level Pointer
    call wonderful
    pop hl
    pop ix
    jr loc_aa2a.continue_next_level

loc_aa2a.test_intermission:
; here A is in 0-9
    ld b, 3
    call mod_b  ; Get modulo B

; now A contains just 0,1,2
; if A==0 the level Number is multiple of 3

    push ix  ; Save Player data pointer 
    push hl  ; Save Level Pointer
    call z, intermission
    pop hl
    pop ix

loc_aa2a.continue_next_level:
    ld (ix + 0), 7
    inc (hl)  ; Increment the level number
    ld a, (hl)
    call sub_b286  ; buld level in A
    ld hl, gamestate
    ld de, $3400
    ld a, (gamecontrol)
    bit 1, a
    jr z, loc_aa5c
    set 1, d
loc_aa5c:
    ld bc, $00D4
    call write_vram
    ld bc, $01E2
    jp write_register


; Get A modulo B
mod_b:
    sub b  ; Subtract B
    jr nc, mod_b  ; If result >= 0, continue
    add a, b  ; Add back B to get remainder in 0-(B-1)
    ret


sub_aa69:
    ld hl, gamecontrol
    set 7, (hl)
loc_aa6e:
    bit 7, (hl)
    jr nz, loc_aa6e
    ld de, $3400
    bit 1, (hl)
    jr z, loc_aa7c
    set 1, d
loc_aa7c:
    ld hl, gamestate
    ld bc, $00D4
    call write_vram
    ld bc, $01E2
    call write_register
    ld ix, lives_left_p1_ram
    ld iy, lives_left_p2_ram
    ld hl, gamecontrol
    bit 1, (hl)
    jr nz, loc_aabd
    dec (ix + 0)
    jr z, loc_aaad
    bit 0, (hl)
    jr z, loc_aaca
    ld a, (iy + 0)
    and a
    jr z, loc_aaca
    set 1, (hl)
    jr loc_aaca
loc_aaad:
    bit 0, (hl)
    jr z, loc_aada
    ld a, (iy + 0)
    and a
    jr z, loc_aada
    set 1, (hl)
    ld a, 2
    ret
loc_aabd:
    dec (iy + 0)
    jr z, loc_aace
    ld a, (ix + 0)
    and a
    jr z, loc_aaca
    res 1, (hl)
loc_aaca:
    ld a, 1
    ret
loc_aace:
    ld a, (ix + 0)
    and a
    jr z, loc_aada
    res 1, (hl)
    ld a, 3
    ret
loc_aada:
    xor a
    ret


sub_ab28:
    ld hl, gamecontrol
    set 7, (hl)
loc_ab2d:
    bit 7, (hl)
    jr nz, loc_ab2d
    ld hl, sat
    ld de, $80
    xor a
    call fill_vram
    ld hl, sprite_name_table
    ld b, $50
loc_ab40:
    ld (hl), 0
    inc hl
    djnz loc_ab40
    ld a, 9
    call deal_with_playfield
    ld bc, $01E2
    call write_register
    call play_game_over_tune
    ld hl, $0168
    xor a
    call request_signal
    push af
loc_ab5b:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_ab5b
    pop af
    ld hl, $04B0
    xor a
    call request_signal
    push af
loc_ab6c:
    ld a, (keyboard_p1)
    cp $0A
    jr z, loc_aba5
    cp $0B
    jr z, loc_aba9
    ld a, (keyboard_p2)
    cp $0A
    jr z, loc_aba5
    cp $0B
    jr z, loc_aba9
    pop af
    push af
    call test_signal
    and a
    jr z, loc_ab6c
    ld hl, gamecontrol
    set 7, (hl)
loc_ab8f:
    bit 7, (hl)
    jr nz, loc_ab8f
    ld hl, pnt
    ld de, $0300
    xor a
    call fill_vram
    ld bc, $01E2
    call write_register
    jr loc_ab6c
loc_aba5:
    pop af
    xor a
    ret
loc_aba9:
    ld hl, gamecontrol
    set 7, (hl)
loc_abae:
    bit 7, (hl)
    jr nz, loc_abae
    pop af
    ld a, 3
    ret

sub_abb7:
    ld bc, 8200
    ld d, 0
    dec a
loc_abbe:
    cp $10
    jr c, loc_abc7
    sub $10
    inc d
    jr loc_abbe
loc_abc7:
    ld e, a
loc_abc8:
    ld a, e
    and a  ;	CP		0
    jr z, loc_abd4
    ld a, c
    add a, $10
    ld c, a
    dec e
    jr loc_abc8
loc_abd4:
    ld a, d
    and a  ;	CP		0
    ret z
    ld a, b
    add a, $10
    ld b, a
    dec d
    jr loc_abc8

sub_abe1:
    push ix
    call sub_ac1f
    ld ix, byte_ac2f
    ld e, a
    add ix, de
    ld e, (ix + 0)
    ld a, (hl)
    or e
    ld (hl), a
    pop ix
    ret

sub_abf6:
    push ix
    call sub_ac1f
    ld ix, byte_ac37
    ld e, a
    add ix, de
    ld e, (ix + 0)
    ld a, (hl)
    and e
    ld (hl), a
    pop ix
    ret

sub_ac0b:
    push ix
    call sub_ac1f
    ld ix, byte_ac2f
    ld e, a
    add ix, de
    ld e, (ix + 0)
    ld a, (hl)
    and e
    pop ix
    ret

sub_ac1f:
    ld e, 0
    dec a
loc_ac22:
    cp 8
    jr c, loc_ac2b
    sub 8
    inc e
    jr loc_ac22
loc_ac2b:
    ld d, 0
    add hl, de
    ret

byte_ac2f:
    db 128, 64, 32, 16, 8, 4, 2, 1
byte_ac37:
    db 127, 191, 223, 239, 247, 251, 253, 254

sub_ac3f:
    push bc
    ld d, 1
    ld a, b
    sub $18
loc_ac45:
    sub $10
    jr c, loc_ac51
    push af
    ld a, d
    add a, $10
    ld d, a
    pop af
    jr loc_ac45
loc_ac51:
    ld a, c
loc_ac52:
    sub $10
    jr c, loc_ac59
    inc d
    jr loc_ac52
loc_ac59:
    ld a, d
    dec a
    ld b, 0
    ld c, a
    ld ix, gamestate
    add ix, bc
    ld a, d
    pop bc
    ret

init_playfield_map:
    dec a
    add a, a
    ld b, 0
    ld c, a
    ld ix, playfield_map
    add ix, bc
    ld b, (ix + 1)
    ld c, (ix + 0)
    push bc
    pop ix
loc_acd5:
    ld a, 2
    cp (ix + 0)
    ret z  ; 2 == END of data
    dec a
    cp (ix + 0)
    jr nz, loc_acf6
    inc ix  ; 1 == Encode a RUN of tiles
    ld b, (ix + 0)
    inc ix
    ld a, (ix + 0)
loc_aced:
    ld (hl), b
    inc hl
    dec a
    jr nz, loc_aced
    inc ix
    jr loc_acd5
loc_acf6:
    ld b, (ix + 0)  ; single tiles
    ld (hl), b
    inc hl
    inc ix
    jr loc_acd5

deal_with_sprites:
    ld l, a
    ld h, 0
    ld e, a
    ld d, h
    add hl, hl
    add hl, hl
    add hl, de  ; 5 bytes per entry 
    ex de, hl
    ld ix, sprite_generator
    add ix, de  ; +28*5 for MrDo

; expect in IY the number of 8x8 tiles to process

    ld a, (ix + 0)  ; flag
    ld e, (ix + 1)  ; Position in the SPT in VRAM
    ld d, (ix + 2)
    ld l, (ix + 3)  ; pointer to sprite pattern
    ld h, (ix + 4)
    and a
    jp nz, rotation
norotation:
    ld a, 1  ; write the SPT
    jp put_vram
rotation:

    push de
    exx
    pop de  ; save DE pointer to SPT positions
    exx
    ld b, iyl

    dec a  ; 1 mirror frame left
    jp z, mirrorleft
    dec a  ; 2 rotate face down 
    jp z, rotatedwn
    dec a  ; 3 rotate face up
    jp z, rotateup
    dec a  ; 4 rotate face down-mirror
    jp z, rotatedwnmirror
; rotate face up-mirror
rotateupmirror:
rotateupmirror.nextpattern:
    push bc
    push hl
    ld iy, sptbuff2
;     call sub_ae0c  ; -mdl

sub_ae0c:  ; rotate face down-mirror
    ld bc, 7
    add hl, bc
    ld d, $80
    push hl
    inc c
loc_ae15:
    pop hl
    push hl
    ld b, 8
loc_ae19:
    ld a, (hl)
    and d
    jr z, loc_ae1e
    scf
loc_ae1e:
    rl e
    dec hl
    djnz loc_ae19
    ld (iy + 0), e
    inc iy
    rrc d
    dec c
    jr nz, loc_ae15
    pop hl
;     ret  ; -mdl
    exx
    ld a, (de)
    inc de
    exx
    ld e, a
    ld d, 0
    ld hl, sptbuff2
    ld iy, 1
    ld a, iyl
    call put_vram
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz rotateupmirror.nextpattern
    ret

mirrorleft:
mirrorleft.nextpattern:
    push bc
    push hl
    ld iy, sptbuff2
;     call sub_ad96  ; -mdl


sub_ad96:  ; mirror frame left
    ld b, 8
loc_ad98:
    ld d, (hl)
    ld c, 8
loc_ad9b:
    srl d
    rl e
    dec c
    jr nz, loc_ad9b
    ld (iy + 0), e
    inc hl
    inc iy
    djnz loc_ad98
;     ret  ; -mdl
    exx
    ld a, (de)
    inc de
    exx
    ld e, a
    ld d, 0
    ld hl, sptbuff2
    ld iy, 1
    ld a, iyl
    call put_vram
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz mirrorleft.nextpattern
    ret

rotatedwn:
rotatedwn.nextpattern:
    push bc
    push hl
    ld iy, sptbuff2
;     call sub_adab  ; -mdl

sub_adab:  ; rotate face down 
    ld c, 8
    push hl
    ld d, 1
loc_adb0:
    pop hl
    push hl
    ld b, 8
loc_adb4:
    ld a, (hl)
    and d
    jr z, loc_adb9
    scf
loc_adb9:
    rl e
    inc hl
    djnz loc_adb4
    ld (iy + 0), e
    inc iy
    rlc d
    dec c
    jr nz, loc_adb0
    pop hl
;     ret  ; -mdl
    exx
    ld a, (de)
    inc de
    exx
    ld e, a
    ld d, 0
    ld hl, sptbuff2
    ld iy, 1
    ld a, iyl
    call put_vram
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz rotatedwn.nextpattern
    ret

rotateup:
rotateup.nextpattern:
    push bc
    push hl
    ld iy, sptbuff2
;     call sub_adca  ; -mdl

sub_adca:  ; rotate face up
    ld c, 8
    push hl
    ld d, $80
loc_adcf:
    pop hl
    push hl
    ld b, 8
loc_add3:
    ld a, (hl)
    and d
    jr z, loc_add8
    scf
loc_add8:
    rl e
    inc hl
    djnz loc_add3
    ld (iy + 0), e
    inc iy
    rrc d
    dec c
    jr nz, loc_adcf
    pop hl
;     ret  ; -mdl
    exx
    ld a, (de)
    inc de
    exx
    ld e, a
    ld d, 0
    ld hl, sptbuff2
    ld iy, 1
    ld a, iyl
    call put_vram
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz rotateup.nextpattern
    ret

rotatedwnmirror:
rotatedwnmirror.nextpattern:
    push bc
    push hl
    ld iy, sptbuff2
;     call sub_ade9  ; -mdl

sub_ade9:  ; rotate face up-mirror
    ld bc, 7
    add hl, bc
    inc c
    ld d, 1
    push hl
loc_adf2:
    pop hl
    push hl
    ld b, 8
loc_adf6:
    ld a, (hl)
    and d
    jr z, loc_adfb
    scf
loc_adfb:
    rl e
    dec hl
    djnz loc_adf6
    ld (iy + 0), e
    inc iy
    rlc d
    dec c
    jr nz, loc_adf2
    pop hl
;     ret  ; -mdl
    exx
    ld a, (de)
    inc de
    exx
    ld e, a
    ld d, 0
    ld hl, sptbuff2
    ld iy, 1
    ld a, iyl
    call put_vram
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz rotatedwnmirror.nextpattern
    ret

deal_with_playfield:  ; Print strings to the playfield
    dec a
    add a, a
    ld c, a
    ld b, 0
    ld hl, obj_position_list
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld ix, obj_description_list
    add ix, bc
    ld l, (ix + 0)
    ld h, (ix + 1)
loc_ae47:
    ld a, (hl)
    cp $00FF
    ret z
    cp $00FE
    jr nz, loc_ae5a
    inc hl
    ld c, (hl)
    inc hl
    ld b, 0
    ex de, hl
    add hl, bc
    ex de, hl
    jr loc_ae47
loc_ae5a:
    cp $00FD
    jr nz, loc_ae76
    inc hl
    ld b, (hl)
    inc hl
loop_ae61:
    push bc
    push hl
    push de
    ld a, 2
    ld iy, 1
    call put_vram
    pop de
    pop hl
    pop bc
    inc de
    djnz loop_ae61
    inc hl
    jr loc_ae47
loc_ae76:
    push hl
    push de
    ld a, 2
    ld iy, 1
    call put_vram
    pop de
    pop hl
    inc de
    inc hl
    jr loc_ae47

loc_ae88:
    ld ix, byte_aead
    ld b, 5
loop_ae8e:
    push bc
    xor a
    ex de, hl
    ld c, (ix + 0)
    ld b, (ix + 1)
loc_ae97:
    and a
    sbc hl, bc
    jr c, loc_ae9f
    inc a
    jr loc_ae97
loc_ae9f:
    add hl, bc
    ex de, hl
    add a, $00D8
    ld (hl), a
    inc hl
    inc ix
    inc ix
    pop bc
    djnz loop_ae8e
    ret

byte_aead:
    db 16, 39, 232, 3, 100, 0, 10, 0, 1, 0

sub_aeb7:
    ld b, a
    ld a, (badguy_bhvr_cnt_ram)
    dec a
    jp p, loc_aec1
    ld a, $4F
loc_aec1:
    ld e, a
    ld d, 0
    ld hl, badguy_behavior_ram
    add hl, de
    ld a, (hl)
    cp b
    ret z
    ld a, (badguy_bhvr_cnt_ram)
    ld e, a
    ld hl, badguy_behavior_ram
    add hl, de
    ld (hl), b
    inc a
    cp $50
    jr c, loc_aedd
    xor a
loc_aedd:
    ld (badguy_bhvr_cnt_ram), a
    ret

sub_aee1:  ; Apple Pushing/Intersection logic
    push af
    ld h, 0
loc_aee4:
    ld e, d
    dec e
    ld a, c
    jr nz, loc_aef1
    add a, $0C
    jp c, loc_aff5
    jr loc_aef6
loc_af26:
    ld a, (ix + 0)
    and $78
    jp nz, loc_afd2
    inc h
    pop af
    push af
    cp 2
    jp z, loc_aee4
    cp 3
    jr nz, loc_aee4
    push bc
    push de
    push hl
    push ix
    ld a, c
    bit 0, d
    jr z, loc_af48
    add a, 6
    jr loc_af4a
loc_af48:
    sub 6
loc_af4a:
    ld c, a
    call sub_ac3f
    ld a, c
    and $0F
    cp 8
    ld a, (ix + 0)
    jr nc, loc_af60
    and 5
    cp 5
    jr nz, loc_af6e
    jr loc_af66
loc_af60:
    and $0A
    cp $0A
    jr nz, loc_af6e
loc_af66:
    pop ix
    pop hl
    pop de
    pop bc
    jp loc_aee4
loc_af6e:
    pop ix
    pop hl
    pop de
    pop bc
    jp loc_b061
loc_aef1:
    sub $0C
    jp c, loc_aff5
loc_aef6:
    ld c, a
    ld e, 5
    ld ix, appledata
loc_aefd:
    bit 7, (ix + 0)
    jr z, loc_af1a
    ld a, (ix + 2)
    cp c
    jr nz, loc_af1a
    ld a, (ix + 1)
    cp b
    jr z, loc_af26
    sub $10
    cp b
    jr nc, loc_af1a
    add a, $1F
    cp b
    jp nc, loc_b061
loc_af1a:
    push de
    ld de, 5
    add ix, de
    pop de
    dec e
    jr nz, loc_aefd
; 	JR		LOC_AF76  ; -mdl
loc_af76:
    ld e, 0
    ld a, h
    and a
    jp z, loc_b063
    pop af
    push af
    cp 1
    jr nz, loc_afd7
    push de
    push hl
    ld ix, enemy_data_array
    ld l, 7
loc_af8b:
    bit 7, (ix + 4)
    jr z, loc_afbf
    bit 6, (ix + 4)
    jr nz, loc_afbf
    ld a, ($7272)
    bit 4, a
    jr nz, loc_afa5
    ld a, (ix + 0)
    and $30
    jr z, loc_afbf
loc_afa5:
    ld a, (ix + 2)
    sub $0C
    cp b
    jr nc, loc_afbf
    add a, $18
    cp b
    jr c, loc_afbf
    ld a, (ix + 1)
    sub 4
    cp c
    jr nc, loc_afbf
    add a, 8
    cp c
    jr nc, loc_afd0
loc_afbf:
    ld de, 6
    add ix, de
    dec l
    jr nz, loc_af8b
    pop hl
    pop de
    call sub_b066
    jr nz, loc_afd2
    jr loc_aff6
loc_afd0:
    pop hl
    pop de
loc_afd2:
    ld e, 3
    jp loc_b063
loc_afd7:  ; BADGUY Pushes APPLE
    ld a, (mrdo_data.y)
    sub $0C
    cp b
    jr nc, loc_aff6
    add a, $18
    cp b
    jr c, loc_aff6
    ld a, (mrdo_data.x)
    sub 4
    cp c
    jr nc, loc_aff6
    add a, 8
    cp c
    jr c, loc_aff6
    ld e, 3
    jr loc_b063
loc_aff5:
    ld c, a
loc_aff6:
    ld e, 0
    ld a, h
    and a
    jr z, loc_b063
loc_affc:
    ld e, d
    dec e
    ld a, c
    jr nz, loc_b006
    sub $0C
    jr loc_b008
loc_b006:
    add a, $0C
loc_b008:
    ld c, a
    ld ix, appledata
    ld e, 5
loc_b00f:
    bit 7, (ix + 0)
    jr z, loc_b050
    ld a, (ix + 1)
    cp b
    jr nz, loc_b050
    ld a, (ix + 2)
    cp c
    jr nz, loc_b050
    ld a, d
    dec a
    ld a, c
    jr nz, loc_b02f
    add a, 4
    cp $00E9
    jr nc, loc_b061
    jr loc_b035
loc_b02f:
    sub 4
    cp $18
    jr c, loc_b061
loc_b035:
    ld (ix + 2), a
    push bc
    push de
    push hl
    push ix
    ld c, a
    ld b, (ix + 1)
    ld a, $11
    sub e
    ld d, 1
    call sub_b629
    pop ix
    pop hl
    pop de
    pop bc
    jr loc_b05a
loc_b050:
    push de
    ld de, 5
    add ix, de
    pop de
    dec e
    jr nz, loc_b00f
loc_b05a:  ; Mr. Do pushing an apple from the bottom
    dec h
    jr nz, loc_affc
    ld e, 1
    jr loc_b063
loc_b061:
    ld e, 2
loc_b063:
    pop af
    ld a, e
    ret

sub_b066:
    push iy
    push hl
    ld iy, enemy_data_array
    ld hl, $0207
loc_b070:
    ld a, (iy + 4)
    bit 7, a
    jp z, loc_b105
    add a, a
    jp m, loc_b105
    ld a, (iy + 0)
    and $30
    jp nz, loc_b105
loc_b085:
    ld a, (iy + 2)
    sub b
    jr nc, loc_b08d
    cpl
    inc a
loc_b08d:
    cp $10
    jr nc, loc_b105
    ld a, (iy + 1)
    bit 0, d
    jr nz, loc_b0b7
    cp c
    jr c, loc_b105
    sub 9
    cp c
    jr nc, loc_b105
    push bc
    push de
    push hl
    call sub_9f29
    pop hl
    pop de
    pop bc
    bit 7, a
    jr z, loc_b0d8
    ld a, (iy + 1)
    sub 4
    ld (iy + 1), a
    jr loc_b085
loc_b0b7:
    cp c
    jr z, loc_b0bc
    jr nc, loc_b105
loc_b0bc:
    add a, 9
    cp c
    jr c, loc_b105
    push bc
    push de
    push hl
    call sub_9f29
    pop hl
    pop de
    pop bc
    bit 6, a
    jr z, loc_b0d8
    ld a, (iy + 1)
    add a, 4
    ld (iy + 1), a
    jr loc_b085
loc_b0d8:
    push af
    ld a, (iy + 2)
    cp b
    jr c, loc_b0f8
    pop af
    bit 5, a
    jr z, loc_b0ee
    ld a, (iy + 2)
    add a, 4
    ld (iy + 2), a
    jr loc_b105

loc_b0f8:
    pop af
    bit 4, a
    jr z, loc_b126
    ld a, (iy + 2)
    sub 4
    ld (iy + 2), a
loc_b105:
    push de
    ld de, 6
    add iy, de
    pop de
    dec l
    jp nz, loc_b070
    dec h
    jr z, loc_b123
    ld a, ($72BA)
    bit 6, a
    jr z, loc_b123
    ld iy, $72BD
    ld l, 1
    jp loc_b085
loc_b123:
    xor a
    jr loc_b128
loc_b0ee:
    push af
    ld a, (iy + 2)
    cp b
    jr z, loc_b0f8
    pop af
loc_b126:
    ld a, 1
loc_b128:
    pop hl
    pop iy
    and a
    ret

sub_b12d:  ; Mr. Do sprite intersection with apples from above and below
    ld ix, appledata  ; IX points to the first apple's sprite data
    ld e, 5  ; Number of apples to check
; Modified to offset the value used to detect a vertical collision
; with an apple so that Mr. Do doesn't get stuck in the apple from
; above or below.

    jr nc, loc_b133  ; CF==0 -> monsters, CF==1 ->MrDo

    ld a, (iy + 3)  ; Get Y position of Mr. Do
    bit 1, d  ; Check if moving down
    jr z, check_up
    sub 4  ; Moving down, so sub 4 from Y position
    jr start_check
check_up:
    add a, 4  ; Moving up, so add 4 to Y position
start_check:
    ld b, a  ; Store the new Y position in B for checks

loc_b133:
    bit 7, (ix + 0)  ; Check if the apple is active
    jr z, loc_b163
    ld a, b
    bit 1, d
    jr z, loc_b149
    sub (ix + 1)
    jr c, loc_b163
    cp $0D
    jr nc, loc_b163
    jr loc_b156
loc_b149:
    sub (ix + 1)
    jr z, loc_b156
    jr nc, loc_b163
    cpl
    inc a
    cp $0D
    jr nc, loc_b163
loc_b156:
    ld a, (ix + 2)
    add a, 9
    cp c
    jr c, loc_b163
    sub $12
    cp c
    jr c, loc_b170
loc_b163:
    ex de, hl
    ld de, 5
    add ix, de
    ex de, hl
    dec e
    jr nz, loc_b133
    xor a
    ret
loc_b170:
    ld a, 1
    ret

sub_b173:
    ld a, d
    push af
    ld hl, $7245
    call sub_ac0b
    jr z, loc_b198
    pop af
    push af
    dec a
    ld c, a
    ld b, 0
    ld hl, gamestate
    add hl, bc
    ld a, (hl)
    and $0F
    cp $0F
    jr nz, loc_b198
    pop af
    ld hl, $7245
    call sub_abf6
    scf
    ret
loc_b198:
    pop af
    and a
    ret

display_play_field_parts:
    push af
    cp $48
    jp z, loc_b24e
    dec a
    ld c, a
    ld b, 0
    ld iy, gamestate
    add iy, bc
    pop af
    push af
    call sub_b591
    ld ix, tunnel_wall_patterns
    ld bc, 3
display_cherries:
    ld a, (ix + 0)
    and (iy + 0)
    jr nz, display_tunnels
    pop af
    push af
    push de
    push ix
    push bc
    ld hl, $7245
    call sub_ac0b
    pop bc
    pop ix
    pop de
    jr z, display_playfield
    ld hl, cherries_txt
    add hl, bc
    jr playfield_to_vram
display_playfield:
    push bc
    ld a, (gamecontrol)
    bit 1, a
    ld a, (current_level_p1)
    jr z, loc_b1e6
    ld a, (current_level_p2)
loc_b1e6:
    cp $0B
    jr c, loc_b1ee
    sub $0A
    jr loc_b1e6
loc_b1ee:
    dec a
    ld c, a
    ld b, 0
    ld hl, playfield_patterns
    add hl, bc
    pop bc
    jr playfield_to_vram
display_tunnels:
    ld hl, tunnel_patterns
    ld a, (iy + 0)
    and (ix + 1)
    jr z, loc_b20a
    push bc
    ld bc, 8
    add hl, bc
    pop bc
loc_b20a:
    ld a, (iy + 0)
    and (ix + 2)
    jr z, loc_b216
    inc hl
    inc hl
    inc hl
    inc hl
loc_b216:
    ld a, (iy + 0)
    and (ix + 3)
    jr z, loc_b220
    inc hl
    inc hl
loc_b220:
    ld a, (iy + 0)
    and (ix + 4)
    jr z, playfield_to_vram
    inc hl
playfield_to_vram:
    push bc
    push de
    push ix
    push iy
    ld iy, 1
    ld a, 2
    call put_vram
    pop iy
    pop ix
    pop de
    ld l, (ix + 5)
    ld h, 0
    add hl, de
    ex de, hl
    ld bc, 6
    add ix, bc
    pop bc
    dec c
    jp p, display_cherries
loc_b24e:
    pop af
    ret

tunnel_wall_patterns:
    db 1, 16, 4, 2, 128, 1, 2, 16, 8, 64, 1, 31, 4, 1, 32, 8, 128, 1, 8, 2, 32, 64, 4, 0
tunnel_patterns:
    db 0, 0, 0, 0, 0, 93, 92, 90, 0, 95, 94, 91, 0, 89, 88, 0
cherries_txt:
    db 17, 16, 9, 8
playfield_patterns:
    db 80, 81, 82, 82, 82, 82, 83, 83, 83, 80

sub_b286:  ; build level in A
    cp $0B
    jr c, loc_b28e
    sub $0A
    jr sub_b286
loc_b28e:
    push af
    ld hl, gamestate
    ld (hl), 0
    ld de, $718B
    ld bc, $9F
    ldir
    ld hl, gamestate
    call init_playfield_map
    pop af
    dec a
    add a, a
    ld c, a
    ld b, 0
    push bc
    ld ix, cherry_placement_table
    add ix, bc
    ld l, (ix + 0)
    ld h, (ix + 1)
    ld c, $14
    ld de, $7245
    ldir
    call rand_gen
    ld ix, extra_behavior
    rra
    jr nc, loc_b2cc
    ld ix, apple_placement_table
loc_b2cc:
    pop bc
    add ix, bc
    ld l, (ix + 0)
    ld h, (ix + 1)
    ld b, 5
    ld iy, appledata
loop_b2db:
    ld a, (hl)
    push hl
    push bc
    call sub_abb7
    ld (iy + 0), $80
    ld (iy + 1), b
    ld (iy + 2), c
    ld (iy + 3), 0
    ld de, 5
    add iy, de
    pop bc
    pop hl
    inc hl
    djnz loop_b2db
    ret

sub_b2fa:
    push iy
    push hl
    call sub_ac3f
    ld d, a
    ld e, 0
    ld a, c
    and $0F
    cp 8
    jr nz, loc_b32c
    ld a, (ix + 0)
    and $0A
    cp $0A
    jr z, loc_b31d
    ld e, 1
    set 1, (ix + 0)
    set 3, (ix + 0)
loc_b31d:
    push ix
    push de
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b399
loc_b32c:
    and a
    jr nz, loc_b370
    ld a, (ix + 0)
    and $85
    cp $85
    jr z, loc_b342
    ld e, 1
    ld a, (ix + 0)
    or $85
    ld (ix + 0), a
loc_b342:
    push de
    push ix
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    dec ix
    dec d
    bit 6, (ix + 0)
    jr nz, loc_b360
    pop de
    ld e, 1
    push de
    dec d
loc_b360:
    set 6, (ix + 0)
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b399
loc_b370:
    pop iy
    push iy
    cp 4
    jr z, loc_b38b
    inc ix
    ld c, $80
    ld a, (ix + 0)
    dec ix
    and 5
    cp 5
    jr z, loc_b399
    ld b, d
    inc b
    jr loc_b397
loc_b38b:
    ld c, $84
    ld a, (ix + 0)
    and $0A
    cp $0A
    jr z, loc_b399
    ld b, d
loc_b397:
    ld e, 1
loc_b399:
    pop hl
    pop iy
    ret

sub_b39d:
    push iy
    push hl
    call sub_ac3f
    ld d, a
    ld e, 0
    ld a, c
    and $0F
    jr nz, loc_b3ec
    bit 7, (ix + 0)
    jr nz, loc_b3b7
    ld e, 1
    set 7, (ix + 0)
loc_b3b7:
    push de
    push ix
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    dec ix
    dec d
    ld a, (ix + 0)
    cpl
    and $4A
    jr z, loc_b3e0
    pop de
    ld e, 1
    push de
    dec d
    ld a, (ix + 0)
    or $4A
    ld (ix + 0), a
loc_b3e0:
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b43b
loc_b3ec:
    cp 8
    jr nz, loc_b412
    ld a, (ix + 0)
    and 5
    cp 5
    jr z, loc_b403
    ld e, 1
    set 0, (ix + 0)
    set 2, (ix + 0)
loc_b403:
    ld a, d
    ld hl, $7259
    push ix
    push de
    call sub_abe1
    pop de
    pop ix
    jr loc_b43b
loc_b412:
    pop iy
    push iy
    cp 4
    jr nz, loc_b428
    ld c, $85
    ld a, (ix + 0)
    and 5
    cp 5
    jr z, loc_b43b
    ld b, d
    jr loc_b439
loc_b428:
    ld c, $81
    dec ix
    ld a, (ix + 0)
    inc ix
    and $0A
    cp $0A
    jr z, loc_b43b
    ld b, d
    dec b
loc_b439:
    ld e, 1
loc_b43b:
    pop hl
    pop iy
    ret

sub_b43f:
    push iy
    push hl
    call sub_ac3f
    ld d, a
    ld e, 0
    ld a, b
    and $0F
    cp 8
    jr nz, loc_b493
    bit 4, (ix + 0)
    jr nz, loc_b45b
    ld e, 1
    set 4, (ix + 0)
loc_b45b:
    push de
    push ix
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    ld bc, $FFF0
    add ix, bc
    ld a, (ix + 0)
    xor b
    and $2C
    jr z, loc_b485
    pop de
    ld e, 1
    push de
    ld a, (ix + 0)
    or $2C
    ld (ix + 0), a
loc_b485:
    ld a, d
    sub $10
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b4e5
loc_b493:
    and a
    jr nz, loc_b4b8
    ld a, (ix + 0)
    and 3
    cp 3
    jr z, loc_b4a9
    ld e, 1
    set 0, (ix + 0)
    set 1, (ix + 0)
loc_b4a9:
    push ix
    push de
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b4e5
loc_b4b8:
    cp 4
    jr nz, loc_b4ca
    ld a, (ix + 0)
    and 3
    cp 3
    jr z, loc_b4e5
    ld b, d
    ld c, $82
    jr loc_b4e3
loc_b4ca:
    ld bc, $FFF0
    add ix, bc
    ld a, (ix + 0)
    ld bc, $10
    add ix, bc
    and $0C
    cp $0C
    jr z, loc_b4e5
    ld a, d
    sub c
    ld b, a
    ld c, $86
loc_b4e3:
    ld e, 1
loc_b4e5:
    pop hl
    pop iy
    ret

sub_b4e9:
    push iy
    push hl
    call sub_ac3f
    ld d, a
    ld a, b
    and $0F
    cp 8
    jr nz, loc_b53b
    ld a, (ix + 0)
    and $13
    cp $13
    jr z, loc_b50a
    ld e, 1
    ld a, (ix + 0)
    or $13
    ld (ix + 0), a
loc_b50a:
    push de
    push ix
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    ld bc, $FFF0
    add ix, bc
    bit 5, (ix + 0)
    jr nz, loc_b52d
    pop de
    ld e, 1
    push de
    set 5, (ix + 0)
loc_b52d:
    ld a, d
    sub $10
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b58d
loc_b53b:
    and a
    jr nz, loc_b560
    ld a, (ix + 0)
    and $0C
    cp $0C
    jr z, loc_b551
    ld e, 1
    set 2, (ix + 0)
    set 3, (ix + 0)
loc_b551:
    push ix
    push de
    ld a, d
    ld hl, $7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b58d
loc_b560:
    cp 4
    jr nz, loc_b57f
    ld bc, $10
    add ix, bc
    ld a, (ix + 0)
    ld bc, $FFF0
    add ix, bc
    and $0C
    cp $0C
    jr z, loc_b58d
    ld a, d
    add a, $10
    ld b, a
    ld c, $87
    jr loc_b58b
loc_b57f:
    ld a, (ix + 0)
    and 3
    cp 3
    jr z, loc_b58d
    ld b, d
    ld c, $83
loc_b58b:
    ld e, 1
loc_b58d:
    pop hl
    pop iy
    ret

sub_b591:
    ld hl, $60
    ld de, $40
    dec a
loc_b598:
    cp $10
    jr c, loc_b5a1
    add hl, de
    sub $10
    jr loc_b598
loc_b5a1:
    add a, a
    ld e, a
    add hl, de
    ex de, hl
    ret

patterns_to_vram:
    add a, a
    add a, a
    ld c, a
    ld b, 0
    ld hl, byte_b5d4
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push hl
    ex de, hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld hl, $72E7
    call loc_ae88
    ld a, $00D8
    ld ($72EC), a
    ld a, 2
    pop hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld hl, $72E7
    ld iy, 6
    jp put_vram

byte_b5d4:
    db 125, 114, 36, 0, 127, 114, 68, 0, 0

sub_b5dd:  ; Ball collision detection
    ld a, b
    sub 7
    cp (iy + 1)
    jr nc, loc_b5ff
    add a, $0E
    cp (iy + 1)
    jr c, loc_b5ff
    ld a, c
    sub 7
    cp (iy + 2)
    jr nc, loc_b5ff
    add a, $0E
    cp (iy + 2)
    jr c, loc_b5ff
    ld a, 1
    ret
loc_b5ff:
    xor a
    ret

sub_b601:  ; add DE to the SCORE of the active player
    ld ix, score_p1_ram
    ld c, $80
    ld a, (gamecontrol)
    bit 1, a
    jr z, loc_b614
    ld c, $40
    ld ixl, score_p2_ram and 255
loc_b614:
    ld l, (ix + 0)
    ld h, (ix + 1)
    add hl, de
    ld (ix + 0), l
    ld (ix + 1), h
    ld a, ($727C)
    or c
    ld ($727C), a
    ret

sub_b629:  ; put sprite A with step D at  BC = Y,X
    ld ix, satbuff1  ; SAT buffer in RAM (8 bytes)
    bit 7, a
    jr z, loc_b637
    ld ixl, satbuff2 and 255
    and $7F
loc_b637:
    push af
    push de
    add a, a
    ld e, a
    ld d, 0
    ld hl, off_b691  ; color table (pointer)
    add hl, de
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    pop de
    ld a, d
    add a, a
    ld e, a
    ld d, 0
    add hl, de
    ld a, b
    sub 8
    jr nc, loc_b655
    ld e, 1
    add a, 8
loc_b655:
    ld (ix + 0), a
    ld a, c
    sub 8
    ld (ix + 1), a
    ld a, (hl)
    ld (ix + 2), a
    inc hl
    ld a, (hl)
    bit 0, e
    jr z, loc_b66a
    set 7, a
loc_b66a:
    ld (ix + 3), a
    ld a, (gamecontrol)
    set 3, a
    ld (gamecontrol), a
    pop af
    add a, a
    add a, a
    ld e, a
    ld d, 0
    ld hl, sprite_name_table
    add hl, de
    ex de, hl
    push ix
    pop hl
    ld bc, 4
    ldir
    ld a, (gamecontrol)
    res 3, a
    ld (gamecontrol), a
    ret

off_b691:  ; Sprite color data
    dw byte_b6c3
    dw byte_b6c7
    dw byte_b6cb
    dw byte_b6cf
    dw byte_b6fb
    dw byte_b70b
    dw byte_b70b
    dw byte_b70b
    dw byte_b70b
    dw byte_b70b
    dw byte_b70b
    dw byte_b70b
    dw byte_b757
    dw byte_b757
    dw byte_b757
    dw byte_b757
    dw byte_b757
    dw byte_b761
    dw byte_b761
    dw byte_b761
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
byte_b6c3:
    db 0, 0, 184, 10  ; Pattern 184 uses Dark Yellow (Yellow)

byte_b6c7:
    db 44 * 4, 6, 148, 15  ; Patterns 176,148 use White

byte_b6cb:
    db 180, 15, 160, 3  ; Patterns 180,160 use Light Green

byte_b6cf:
    db 0, 0, 96, 11, 100, 11, 104, 11, 108, 11, 112, 11, 116, 11, 120, 11, 124, 11, 128, 11, 132, 11  ; Series using Light Yellow
    db 148, 11, 96, 8, 100, 8, 104, 8, 108, 8, 112, 8, 116, 8, 120, 8, 124, 8, 128, 8, 132, 8  ; Series using Medium Red

byte_b6fb:
    db 0, 0, 156, 10, 192, 10, 196, 10, 200, 10, 204, 10, 208, 10, 212, 10  ; Series using Dark Yellow

byte_b70b:
    db 0, 0, 0, 8, 4, 8, 8, 8, 12, 8, 16, 8, 20, 8, 24, 8, 28, 8, 32, 8, 36, 8, 40, 8, 44, 8  ; Badguy sprite color (Red)
    db 0, 7, 4, 7, 8, 7, 12, 7, 16, 7, 20, 7, 24, 7, 28, 7, 32, 7, 36, 7, 40, 7, 44, 7, 48, 15  ; Series using Cyan, ending in White
    db 52, 5, 56, 5, 60, 5, 64, 5, 68, 5, 72, 5, 76, 5, 80, 5, 84, 5, 88, 5, 92, 5, 148, 13  ; Digger sprite color (Light Blue), last one defines enemy splat color

byte_b757:
    db 0, 0, 136, 8, 140, 8, 144, 8, 152, 15  ; Apple Sprite colors (Medium Red), ending in White

byte_b761:
    db 0, 0, 224, 5, 228, 5, 232, 5, 236, 5, 148, 5  ; Series using Light Blue

sub_b76d:
    ld a, $40
    ld ($72BD), a
    ld hl, $72C4
    bit 0, (hl)
    jr z, loc_b781
    res 0, (hl)
    ld a, (score_p1_ram)
    call free_signal
loc_b781:
    call sub_ca24
    ld a, 1
    ld ($72C2), a
    ld a, ($72BA)
    res 6, a
    res 5, a
    ld ($72BA), a
    and 7
    ld c, a
    ld b, 0
    ld hl, byte_b7bc
    add hl, bc
    ld b, (hl)
    ld hl, $72B8
    ld a, (gamecontrol)
    inc a
    and 3
    jr nz, loc_b7aa
    inc l
loc_b7aa:
    ld c, 0
    ld a, (hl)
    or b
    ld (hl), a
    cp $1F
    jr nz, loc_b7b4
    inc c
loc_b7b4:
    ld a, c
    push af
    call sub_b809
    pop af
    and a
    ret

byte_b7bc:
    db 1, 2, 4, 8, 16, 8, 4, 2

sub_b7c4:
    push hl
    push ix
;	LD		A, 0C0H
    ld (ix + 4), $00C0  ;	LD		(IX+4), A
;	LD		A, 8	; unused
;	LD		B, A
    ld bc, $0808  ;	LD		C, A
    call sub_b7ef
    add a, 5
    ld d, 0
    call sub_b629
    ld hl, enemy_num_p1
    ld a, (gamecontrol)
    and 3
    cp 3
    jr nz, loc_b7e7
    inc hl  ; point to ENEMY_NUM_P2
loc_b7e7:
    ld a, (hl)
    dec a
    ld (hl), a  ; one enemy killed 
    pop ix  ; This seems fine 
    pop hl  ; maybe the problem is in the enemy generation ?
    and a  ; Needed -> ZF is tested from the caller
    ret

sub_b7ef:
    push de
    push hl
    push ix
    pop hl
;	LD		DE, ENEMY_DATA_ARRAY
    ld e, -enemy_data_array and 255
    ld a, l
    add a, e
    ld h, 0
    and a
    jr z, loc_b805
loc_b800:
    inc h
    sub 6
    jr nz, loc_b800
loc_b805:
    ld a, h
    pop hl
    pop de
    ret

sub_b809:
    ld ix, chompdata
    ld b, 3
loc_b80f:
    bit 7, (ix + 4)
    jr z, loc_b82a
    bit 7, (ix + 0)
    jr nz, loc_b82a
    push bc
    call sub_b832
    push ix
    ld de, $32
    call sub_b601
    pop ix
    pop bc
loc_b82a:
    ld de, 6
    add ix, de
    djnz loc_b80f
    ret

sub_b832:
    push iy
    push ix
    ld (ix + 4), 0
    ld a, (ix + 3)
    call free_signal
    ld bc, chompdata
    ld d, $11
    and a
    push ix
    pop hl
    sbc hl, bc
    jr z, loc_b856
    ld bc, 6
loc_b850:
    inc d
    and a
    sbc hl, bc
    jr nz, loc_b850
loc_b856:
    ld bc, $0808
    ld a, d
    ld d, 0
    call sub_b629
    ld ix, chompdata
    ld b, 3
loc_b865:
    bit 7, (ix + 4)
    jr nz, loc_b89e
    ld de, 6
    add ix, de
    djnz loc_b865
    jp loc_d345
loc_b875:
    res 4, (hl)
    ld a, (gameflags)
    bit 0, a  ; b0 in GAMEFLAGS ??
    jr nz, loc_b884
    ld a, (timerchomp1)
    call free_signal
loc_b884:
    xor a
    ld (gameflags), a
    ld a, ($72BA)
    bit 6, a
    jr z, loc_b89b
    ld hl, $72C4
    jp loc_d300
loc_b895:
    call request_signal
    jp loc_d35d
loc_b89b:
;	NOP
;	NOP
;	NOP
loc_b89e:
    pop ix
    pop iy
    ret

sub_b8a3:
    push ix
    push hl
    push de
    push bc
    jp loc_d326

loc_b8ab:
    ld ix, chompdata  ; chomper data
    ld b, 3  ; chomper number
loc_b8b1:
    ld (ix + 0), $10
    ld a, ($72BF)
    ld (ix + 2), a
    ld a, ($72BE)
    ld (ix + 1), a
    ld a, ($72C1)
    and 7
    or $80
    ld (ix + 4), a
    ld (ix + 5), 0
    push bc
    xor a
    ld hl, 1
    call request_signal
    ld (ix + 3), a
    pop bc
    ld de, 6
    add ix, de
    djnz loc_b8b1
    xor a
    ld hl, $78
    call request_signal
    jp loc_d36d
loc_b8ec:
    ld a, $80
    ld (gameflags), a  ; b7 in GAMEFLAGS -> chomper mode

; immediately return the ball when in chomper mode
; only if Mr. Do is in cool down mode (Bit 6 is SET)
    ld iy, balldata  ; Load ball state pointer
    bit 5, (iy + 0)  ; Check if BIT 5 is SET
    jr z, loc_b8ec.skip_ball_return  ; Skip ball return if not in cooldown phase

    ld (iy + 0), $20  ; Set BIT 5, reset direction flags 
    ld (iy + 1), 0  ; reset ball's X
    ld (iy + 2), 0  ; reset ball's Y

    ld hl, 1
    xor a
    call request_signal
    ld (iy + 3), a  ; Store signal result	
    res 5, (iy + 0)
    set 3, (iy + 0)
    ld (iy + 5), 0
    call play_ball_return_sound
loc_b8ec.skip_ball_return:
; Ensure balls in flight are returned immediately after they strike an enemy
    ld (iy + 4), 1  ; Set cooldown to 1
    pop bc
    pop de
    pop hl
    pop ix
    ret


sub_b8f7:
    push iy
    ld hl, gamecontrol
    set 7, (hl)
loc_b8fe:
    bit 7, (hl)
    jr nz, loc_b8fe

    ld a, 11
    call set_level_colors.restore_colors

    ld bc, $01E2
    call write_register

    pop iy
    ret


restore_playfield_colors:
    push iy  ; Calculate correct level colors using original logic
    call set_level_colors
    ld bc, $01E2
    call write_register
    pop iy
    ret

set_level_colors:
    ld a, (gamecontrol)
    bit 1, a
    ld a, (current_level_p1)
    jr z, set_level_colors.ply1
    ld a, (current_level_p2)
set_level_colors.ply1:
    cp $0B
    jr c, set_level_colors.restore_colors
    sub $0A
    jr set_level_colors.ply1
set_level_colors.restore_colors:
    dec a
    push af

    add a, a
    add a, a
    add a, a  ;x8
    ld l, a
    ld h, 0

    call mynmi_off

    push hl

    ld de, pt + 32 * 3 * 8  ; copy background
    add hl, de
    ex de, hl
    ld hl, freebuff
    ld bc, 8
    call myinirvm

    ld b, 5
    ld de, pt + (32 * 2 + 16) * 8
    call repcol  ; plot background 5 times
    ld b, 5
    ld de, pt + (32 * 2 + 16) * 8 + 256 * 8
    call repcol  ; plot background 5 times
    ld b, 5
    ld de, pt + (32 * 2 + 16) * 8 + 256 * 2 * 8
    call repcol  ; plot background 5 times

    pop hl
    push hl

    ld de, ct + 32 * 3 * 8  ; copy background
    add hl, de
    ex de, hl
    ld hl, freebuff
    ld bc, 8
    call myinirvm

    ld b, 5
    ld de, ct + (32 * 2 + 16) * 8
    call repcol  ; plot background 5 times

    pop hl
    add hl, hl  ; a*16
    push hl

    ld de, pt + 32 * 4 * 8  ; cherry top  tiles
    add hl, de
    ex de, hl
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myinirvm

    ld de, pt + (8) * 8
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myldirvm
    ld de, pt + (8) * 8 + 256 * 8
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myldirvm
    ld de, pt + (8) * 8 + 256 * 2 * 8
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myldirvm

    pop hl
    push hl

    ld de, ct + 32 * 4 * 8
    add hl, de
    ex de, hl
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myinirvm

    ld hl, freebuff
    ld de, ct + (8) * 8
    ld bc, 16  ; using FREEBUFF
    call myldirvm

    pop hl
    push hl

    ld de, pt + 32 * 5 * 8
    add hl, de
    ex de, hl
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myinirvm

    ld hl, freebuff
    ld de, pt + (16) * 8
    ld bc, 16  ; using FREEBUFF
    call myldirvm
    ld hl, freebuff
    ld de, pt + (16) * 8 + 256 * 8
    ld bc, 16  ; using FREEBUFF
    call myldirvm
    ld hl, freebuff
    ld de, pt + (16) * 8 + 256 * 2 * 8
    ld bc, 16  ; using FREEBUFF
    call myldirvm

    pop hl

    ld de, ct + 32 * 5 * 8
    add hl, de
    ex de, hl
    ld hl, freebuff
    ld bc, 16  ; using FREEBUFF
    call myinirvm

    ld hl, freebuff
    ld de, ct + (16) * 8
    ld bc, 16  ; using FREEBUFF
    call myldirvm

    pop af  ; level number
    ld e, a
    ld d, 0
    ld hl, staticcolors
    add hl, de
    ld a, (hl)
    ld e, 8 * 8
    ld hl, ct + (2 * 32 + 24) * 8
    call fill_vram

    jp mynmi_on

staticcolors:
    db $21, $71, $41, $D1, $A1, $71, $A1, $31, $B1, $71, $91

repcol:  ; In B $ of times, DE VRAM addr
repcol.1:    push bc
    ld hl, freebuff
    ld bc, 8
    push de
    call myldirvm
    pop de
    ld hl, 8
    add hl, de
    ex de, hl
    pop bc
    djnz repcol.1
    ret

extra_behavior:
    dw phase_01_ex
    dw phase_02_ex
    dw phase_03_ex
    dw phase_04_ex
    dw phase_05_ex
    dw phase_06_ex
    dw phase_07_ex
    dw phase_08_ex
    dw phase_09_ex
    dw phase_10_ex
phase_01_ex:
    db 4, 23, 52, 61, 75, 106
phase_02_ex:
    db 22, 26, 29, 36, 42, 104
phase_03_ex:
    db 21, 25, 35, 70, 105, 108
phase_04_ex:
    db 3, 28, 42, 57, 86, 94
phase_05_ex:
    db 19, 26, 28, 40, 86, 91
phase_06_ex:
    db 22, 25, 27, 43, 100, 106
phase_07_ex:
    db 20, 22, 23, 26, 91, 102
phase_08_ex:
    db 27, 35, 38, 59, 103, 109
phase_09_ex:
    db 20, 23, 28, 39, 58, 103
phase_10_ex:
    db 25, 27, 36, 76, 83, 105

apple_placement_table:
    dw apples_phase_01
    dw apples_phase_02
    dw apples_phase_03
    dw apples_phase_04
    dw apples_phase_05
    dw apples_phase_06
    dw apples_phase_07
    dw apples_phase_08
    dw apples_phase_09
    dw apples_phase_10
apples_phase_01:
    db 27, 36, 39, 68, 76, 77
apples_phase_02:
    db 23, 25, 26, 35, 108, 109
apples_phase_03:
    db 23, 26, 45, 52, 69, 106
apples_phase_04:
    db 4, 14, 27, 37, 58, 74
apples_phase_05:
    db 20, 24, 29, 85, 89, 107
apples_phase_06:
    db 23, 26, 35, 44, 102, 109
apples_phase_07:
    db 19, 25, 27, 37, 101, 108
apples_phase_08:
    db 22, 24, 43, 54, 102, 107
apples_phase_09:
    db 23, 28, 36, 45, 55, 106
apples_phase_10:
    db 24, 26, 35, 45, 71, 92

cherry_placement_table:
    dw cherries_phase_01
    dw cherries_phase_02
    dw cherries_phase_03
    dw cherries_phase_04
    dw cherries_phase_05
    dw cherries_phase_06
    dw cherries_phase_07
    dw cherries_phase_08
    dw cherries_phase_09
    dw cherries_phase_10
cherries_phase_01:
    db 108, 0, 108, 0, 108, 240, 108, 240, 0, 0, 120, 48, 120, 48, 0, 48, 0, 48, 0, 0
cherries_phase_02:
    db 0, 0, 0, 48, 15, 48, 111, 48, 96, 48, 96, 6, 96, 6, 7, 134, 7, 134, 0, 0
cherries_phase_03:
    db 0, 0, 0, 48, 15, 48, 111, 48, 96, 48, 102, 0, 102, 0, 6, 120, 6, 120, 0, 0
cherries_phase_04:
    db 15, 0, 111, 6, 96, 54, 96, 54, 96, 54, 0, 48, 0, 0, 0, 0, 30, 0, 30, 0
cherries_phase_05:
    db 0, 0, 0, 0, 30, 60, 30, 60, 0, 0, 48, 24, 51, 216, 51, 216, 48, 24, 0, 0
cherries_phase_06:
    db 0, 0, 24, 12, 27, 204, 27, 204, 24, 12, 0, 0, 0, 0, 30, 120, 30, 120, 0, 0
cherries_phase_07:
    db 0, 0, 0, 0, 51, 192, 51, 192, 48, 0, 48, 12, 0, 108, 60, 108, 60, 108, 0, 96
cherries_phase_08:
    db 0, 0, 24, 216, 24, 216, 24, 216, 24, 216, 0, 0, 0, 0, 30, 120, 30, 120, 0, 0
cherries_phase_09:
    db 0, 0, 13, 224, 13, 224, 12, 60, 12, 60, 96, 0, 96, 0, 96, 240, 96, 240, 0, 0
cherries_phase_10:
    db 0, 0, 0, 0, 0, 240, 60, 240, 60, 12, 30, 12, 30, 12, 3, 204, 3, 192, 0, 0

playfield_map:
    dw phase_01_map
    dw phase_02_map
    dw phase_03_map
    dw phase_04_map
    dw phase_05_map
    dw phase_06_map
    dw phase_07_map
    dw phase_08_map
    dw phase_09_map
    dw phase_10_map
phase_01_map:
    db 1, 0, 6, 79, 239, 1, 207, 4, 175, 1, 0, 10, 63, 1, 0, 4, 95, 175, 1, 0, 9, 63, 1, 0, 5, 95, 175, 1, 0, 8, 63, 1, 0, 6, 63
    db 1, 0, 8, 63, 1, 0, 6, 63, 1, 0, 8, 63, 1, 0, 6, 63, 1, 0, 8, 63, 1, 0, 6, 63, 0, 0, 111, 207, 175, 1, 0, 3, 63, 1, 0
    db 5, 111, 159, 0, 0, 63, 0, 63, 1, 0, 3, 63, 1, 0, 4, 111, 159, 1, 0, 3, 95, 207, 223, 1, 207, 3, 223, 1, 207, 4, 159, 1, 0, 3, 2
phase_02_map:
    db 0, 0, 111, 1, 207, 10, 175, 1, 0, 3, 111, 159, 1, 0, 10, 95, 175, 0, 0, 31, 1, 0, 12, 63, 1, 0
    db 14, 111, 159, 1, 0, 8, 47, 1, 0, 4, 111, 159, 1, 0, 6, 111, 207, 207, 223, 1, 207, 4, 159, 1, 0, 6
    db 111, 159, 1, 0, 12, 111, 207, 159, 1, 0, 13, 63, 1, 0, 15, 95, 1, 207, 12, 143, 0, 2
phase_03_map:
    db 0, 0, 111, 1, 207, 10, 175, 1, 0, 3, 111, 159, 1, 0, 10, 95, 175, 0, 0, 31, 1, 0, 12, 63, 1, 0, 15, 63, 1, 0
    db 8, 47, 1, 0, 6, 63, 1, 0, 8, 95, 1, 207, 6, 191, 1, 0, 15, 63, 0, 0, 47, 1, 0, 12, 63, 0, 0, 95, 175, 1
    db 0, 10, 111, 159, 1, 0, 3, 95, 1, 207, 10, 159, 0, 0, 2
phase_04_map:
    db 1, 0, 9, 111, 207, 207, 175, 1, 0, 11, 111, 159, 0, 0, 63, 1, 0, 8, 111, 207, 207, 159, 1, 0, 3, 63, 1, 0, 8, 63
    db 1, 0, 6, 63, 1, 0, 6, 111, 207, 223, 207, 143, 1, 0, 4, 63, 1, 0, 4, 111, 207, 159, 1, 0, 8, 63, 1, 0, 4, 63
    db 1, 0, 10, 63, 1, 0, 4, 95, 1, 207, 10, 255, 207, 143, 1, 0, 13, 63, 1, 0, 10, 79, 1, 207, 4, 159, 1, 0, 3, 2
phase_05_map:
    db 0, 111, 1, 207, 12, 143, 0, 0, 63, 1, 0, 15, 63, 1, 0, 15, 63, 1, 0, 15, 95, 1, 207, 11, 175, 1, 0, 15, 95, 175
    db 1, 0, 15, 63, 1, 0, 15, 63, 0, 0, 47, 1, 0, 11, 111, 159, 0, 0, 95, 1, 207, 11, 159, 0, 0, 2
phase_06_map:
    db 0, 0, 111, 1, 207, 11, 143, 0, 0, 111, 159, 1, 0, 14, 63, 1, 0, 15, 63, 1, 0, 15, 63, 1, 0, 5, 47, 1, 0, 9
    db 127, 1, 207, 5, 223, 1, 207, 6, 175, 0, 0, 63, 1, 0, 12, 63, 0, 0, 63, 1, 0, 12, 63, 0, 0, 95, 175, 1, 0, 10
    db 111, 159, 1, 0, 3, 95, 1, 207, 10, 159, 0, 0, 2
phase_07_map:
    db 0, 111, 1, 207, 12, 175, 0, 0, 31, 1, 0, 12, 63, 1, 0, 14, 111, 159, 1, 0, 12, 111, 207, 159, 1, 0, 9, 47, 0, 111
    db 207, 159, 1, 0, 11, 127, 207, 159, 1, 0, 13, 63, 1, 0, 15, 63, 1, 0, 15, 63, 1, 0, 15, 31, 1, 0, 8, 2
phase_08_map:
    db 0, 0, 111, 1, 207, 10, 175, 1, 0, 3, 111, 159, 1, 0, 10, 95, 175, 0, 0, 63, 1, 0, 12, 63, 0, 0, 63, 1, 0, 12, 63
    db 0, 0, 95, 175, 1, 0, 4, 47, 1, 0, 5, 111, 159, 1, 0, 3, 127, 1, 207, 4, 223, 1, 207, 5, 191, 1, 0, 3, 111, 159, 1
    db 0, 10, 95, 175, 0, 0, 63, 1, 0, 12, 63, 0, 0, 95, 175, 1, 0, 10, 111, 159, 1, 0, 3, 95, 1, 207, 10, 159, 0, 0, 2
phase_09_map:
    db 0, 0, 111, 1, 207, 10, 175, 1, 0, 3, 111, 159, 1, 0, 10, 95, 175, 0, 0, 63, 1, 0, 12, 63, 0, 0, 63, 1, 0, 12
    db 63, 0, 0, 95, 207, 175, 1, 0, 3, 47, 1, 0, 6, 63, 1, 0, 4, 95, 1, 207, 3, 223, 1, 207, 6, 191, 1, 0, 15, 63
    db 1, 0, 15, 63, 1, 0, 14, 111, 159, 0, 0, 79, 1, 207, 11, 159, 0, 0, 2
phase_10_map:
    db 0, 0, 111, 1, 207, 10, 175, 1, 0, 3, 111, 223, 207, 175, 1, 0, 8, 95, 175, 0, 0, 63, 0, 0, 95, 207, 175, 1, 0, 7
    db 63, 0, 0, 63, 1, 0, 4, 95, 175, 1, 0, 6, 63, 0, 0, 63, 1, 0, 5, 95, 175, 1, 0, 5, 63, 0, 0, 63, 1, 0
    db 6, 95, 175, 1, 0, 4, 63, 0, 0, 63, 1, 0, 7, 95, 175, 1, 0, 3, 63, 0, 0, 63, 1, 0, 8, 95, 175, 0, 0, 63
    db 0, 0, 95, 175, 1, 0, 8, 95, 207, 239, 159, 1, 0, 3, 95, 1, 207, 10, 159, 0, 0, 2, 0

obj_position_list:
    dw $0021, $000A, $016E, $0188, $0188, $0148, $0166, $0166, $016A, $016E, $016E, $016E, $016E, $016E, $0041, $016E, $016E, $016E, $016E, $016E, $016E

obj_description_list:
    dw p1st_phase_level_gen  ; 1 
    dw extra_border_gen  ; 2
    dw badguy_outline_gen  ; 3
    dw get_ready_p1_gen  ; 4
    dw get_ready_p2_gen  ; 5
    dw win_extra_gen  ; 6
    dw game_over_p1_gen  ; 7
    dw game_over_p2_gen  ; 8
    dw game_over_gen  ; 9

    dw sundae_gen  ;10
    dw wheat_square_gen  ;11
    dw gumdrop_gen  ;12
    dw pie_slice_gen  ;13

    dw blank_space_gen  ;14
    dw p2nd_gen  ;15

    dw eggs  ;16
    dw burger  ;17
    dw drink  ;18
    dw sandwich  ;19
    dw milk  ;20
    dw bagel  ;21


p1st_phase_level_gen:
    db 66, 67, 68, 254, 23, 241, 233, 255
extra_border_gen:
    db 58, 253, 9, 61, 63, 254, 21, 59, 254, 9, 64, 254, 21, 60, 253, 9, 62, 65, 255
badguy_outline_gen:
    db 112, 114, 254, 30, 113, 115, 255
get_ready_p1_gen:
    db 232, 230, 245, 0, 243, 230, 226, 229, 250, 0, 241, 237, 226, 250, 230, 243, 0, 217, 255
get_ready_p2_gen:
    db 232, 230, 245, 0, 243, 230, 226, 229, 250, 0, 241, 237, 226, 250, 230, 243, 0, 218, 255
win_extra_gen:  ; CONGRATULATIONS! YOU WIN AN EXTRA MR. DO! TEXT
;	DB 228,240,239,232,243,226,245,246,237,226,245,234,240,239,244,000,253,001,255,254,076,250,240,246,000,248
;	DB 234,239,000,226,239,000,230,249,245,243,226,000,238,243,253,001,254,000,229,240,000,253,001,255,255
game_over_p1_gen:
    db 253, 20, 0, 254, 12, 0, 232, 226, 238, 230, 0, 240, 247, 230, 243, 0, 241, 237, 226, 250, 230, 243, 0, 217, 0, 254, 12, 253, 20, 0, 255
game_over_p2_gen:
    db 253, 20, 0, 254, 12, 0, 232, 226, 238, 230, 0, 240, 247, 230, 243, 0, 241, 237, 226, 250, 230, 243, 0, 218, 0, 254, 12, 253, 20, 0, 255
game_over_gen:
    db 253, 11, 0, 254, 21, 0, 232, 226, 238, 230, 0, 240, 247, 230, 243, 0, 254, 21, 253, 11, 0, 255
sundae_gen:
    db 42, 43, 254, 30, 56, 57, 255
wheat_square_gen:
    db 32, 33, 254, 30, 34, 35, 255
gumdrop_gen:
    db 38, 39, 254, 30, 40, 41, 255
pie_slice_gen:
    db 44, 45, 254, 30, 36, 37, 255
blank_space_gen:
    db 0, 0, 254, 30, 0, 0, 255
p2nd_gen:
    db 69, 70, 71, 255

eggs:    db 46, 47, 254, 30, 48, 49, 255
burger:    db 150, 151, 254, 30, 182, 183, 255
drink:    db 152, 153, 254, 30, 184, 185, 255
sandwich:    db 154, 155, 254, 30, 186, 187, 255
milk:    db 156, 157, 254, 30, 188, 189, 255
bagel:    db 158, 159, 254, 30, 190, 191, 255


playfield_colors:
    dw phase_01_colors
    dw phase_02_colors
    dw phase_03_colors
    dw phase_04_colors
    dw phase_05_colors
    dw phase_06_colors
    dw phase_07_colors
    dw phase_08_colors
    dw phase_09_colors
    dw phase_10_colors
; CONTROL_BYTE,BLACK CHERRY STEM+BG, MED RED CHERRY+BG,.......BG1+BG2,BG Walls + Invisible Corridor)
phase_01_colors:  ; Med Green + Light Green
    db $00, $12, $82, $90, $80, $F0, $F0, $A0, $A0, $80, $23, $20, $C0, $C0, $80, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $B1, $F0, $F0, $F0, $F0, $F0  ; NOTE the $B1 is for the 500/1000 bonus in the tileset
phase_02_colors:  ; Dark Blue + Cyan  
    db $00, $17, $87, $90, $80, $F0, $F0, $A0, $A0, $80, $47, $70
phase_03_colors:  ; Magenta + Cyan
    db $00, $14, $84, $90, $80, $F0, $F0, $A0, $A0, $80, $D7, $70
phase_04_colors:  ; Dark Yellow + Magenta
    db $00, $1D, $8D, $90, $80, $F0, $F0, $A0, $A0, $80, $AD, $D0
phase_05_colors:  ; Cyan + Dark Yellow
    db $00, $1A, $8A, $90, $80, $F0, $F0, $A0, $A0, $80, $7A, $A0
phase_06_colors:  ; Magenta + Cyan (repeat of phase 3)
    db $00, $17, $87, $90, $80, $F0, $F0, $A0, $A0, $80, $D7, $70
phase_07_colors:  ; Dark Red + Dark Yellow
    db $00, $1A, $8A, $90, $80, $F0, $F0, $A0, $A0, $80, $6A, $A0
phase_08_colors:  ; Light Gray + Light Green
    db $00, $13, $83, $90, $80, $F0, $F0, $A0, $A0, $80, $E3, $30
phase_09_colors:  ; Light Gray + Dark Yellow
    db $00, $1A, $8A, $90, $80, $F0, $F0, $A0, $A0, $80, $EA, $A0
phase_10_colors:
    db $00, $17, $87, $90, $80, $F0, $F0, $A0, $A0, $80, $74, $70

badguy_behavior:
    dw phase_01_bgb
    dw phase_02_bgb
    dw phase_03_bgb
    dw phase_04_bgb
    dw phase_05_bgb
    dw phase_06_bgb
    dw phase_07_bgb
    dw phase_08_bgb
    dw phase_09_bgb
    dw phase_10_bgb
phase_01_bgb:
    db 6, 72, 88, 104, 120, 136, 152
phase_02_bgb:
    db 18, 72, 88, 87, 86, 85, 101, 100, 116, 115, 114, 130, 146, 147, 148, 149, 150, 151, 152
phase_03_bgb:
    db 20, 72, 88, 89, 90, 91, 92, 93, 94, 95, 111, 127, 143, 142, 158, 157, 156, 155, 154, 153, 152
phase_04_bgb:
    db 28, 72, 71, 70, 69, 68, 84, 83, 82, 98, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 141, 157, 156, 155, 154, 153, 152
phase_05_bgb:
    db 20, 72, 73, 74, 75, 76, 77, 78, 94, 95, 111, 127, 143, 142, 158, 157, 156, 155, 154, 153, 152
phase_06_bgb:
    db 20, 72, 88, 89, 90, 91, 92, 93, 94, 95, 111, 127, 143, 142, 158, 157, 156, 155, 154, 153, 152
phase_07_bgb:
    db 6, 72, 88, 104, 120, 136, 152
phase_08_bgb:
    db 20, 72, 88, 89, 90, 91, 92, 93, 94, 110, 111, 127, 143, 142, 158, 157, 156, 155, 154, 153, 152
phase_09_bgb:
    db 20, 72, 88, 89, 90, 91, 92, 93, 94, 95, 111, 127, 143, 142, 158, 157, 156, 155, 154, 153, 152
phase_10_bgb:
    db 18, 72, 73, 89, 90, 106, 107, 123, 124, 140, 141, 142, 158, 157, 156, 155, 154, 153, 152, 0



sprite_generator:
    db 0  ;0
    dw 0, badguy_right_walk_01_pat
    db 0  ;1
    dw 4, badguy_right_walk_02_pat
    db 1  ;2
    dw byte_c234, badguy_right_walk_01_pat
    db 1  ;3
    dw byte_c238, badguy_right_walk_02_pat
    db 2  ;4
    dw byte_c23c, badguy_right_walk_01_pat
    db 2  ;5
    dw byte_c240, badguy_right_walk_02_pat
    db 3  ;6
    dw byte_c244, badguy_right_walk_01_pat
    db 3  ;7
    dw byte_c248, badguy_right_walk_02_pat
    db 4  ;8
    dw byte_c24c, badguy_right_walk_01_pat
    db 4  ;9
    dw byte_c250, badguy_right_walk_02_pat
    db 5  ;10
    dw byte_c254, badguy_right_walk_01_pat
    db 5  ;11
    dw byte_c258, badguy_right_walk_02_pat
    db 0  ;12
    dw 48, digger_right_01_pat
    db 0  ;13
    dw 52, digger_right_02_pat
    db 1  ;14
    dw byte_c25c, digger_right_01_pat
    db 1  ;15
    dw byte_c260, digger_right_02_pat
    db 2  ;16
    dw byte_c264, digger_right_01_pat
    db 2  ;17
    dw byte_c268, digger_right_02_pat
    db 3  ;18
    dw byte_c26c, digger_right_01_pat
    db 3  ;19
    dw byte_c270, digger_right_02_pat
    db 4  ;20
    dw byte_c274, digger_right_01_pat
    db 4  ;21
    dw byte_c278, digger_right_02_pat
    db 5  ;22
    dw byte_c27c, digger_right_01_pat
    db 5  ;23
    dw byte_c280, digger_right_02_pat
    db 0  ;24
    dw 224, chomper_right_closed_pat
    db 0  ;25
    dw 228, chomper_right_open_pat
    db 1  ;26
    dw byte_c298, chomper_right_closed_pat
    db 1  ;27
    dw byte_c29c, chomper_right_open_pat

; MrDo 4 frames

    db 0  ; 0	right	0	; MrDo sprites start from here
    dw 44 * 4, mr_do_walk_right_00_pat
    db 0  ; 1
    dw 44 * 4, mr_do_walk_right_01_pat
    db 0  ; 2
    dw 44 * 4, mr_do_walk_right_02_pat
    db 0  ; 3
    dw 44 * 4, mr_do_walk_right_01_pat

    db 0  ; 0 right 4
    dw 44 * 4, mr_do_push_right_00_pat
    db 0  ; 1
    dw 44 * 4, mr_do_push_right_01_pat
    db 0  ; 2
    dw 44 * 4, mr_do_push_right_02_pat
    db 0  ; 3
    dw 44 * 4, mr_do_push_right_01_pat

    db 1  ; 0 left 8
    dw byte_c284, mr_do_walk_right_00_pat
    db 1  ; 1
    dw byte_c284, mr_do_walk_right_01_pat
    db 1  ; 2
    dw byte_c284, mr_do_walk_right_02_pat
    db 1  ; 3
    dw byte_c284, mr_do_walk_right_01_pat

    db 1  ; 0 left 12
    dw byte_c284, mr_do_push_right_00_pat
    db 1  ; 1 
    dw byte_c284, mr_do_push_right_01_pat
    db 1  ; 2 
    dw byte_c284, mr_do_push_right_02_pat
    db 1  ; 3 
    dw byte_c284, mr_do_push_right_01_pat

    db 2  ; 0 up 	16
    dw byte_c288, mr_do_walk_right_00_pat
    db 2  ; 1 
    dw byte_c288, mr_do_walk_right_01_pat
    db 2  ; 2 
    dw byte_c288, mr_do_walk_right_02_pat
    db 2  ; 3 
    dw byte_c288, mr_do_walk_right_01_pat

    db 2  ; 0 up 20
    dw byte_c288, mr_do_push_right_00_pat
    db 2  ; 1 
    dw byte_c288, mr_do_push_right_01_pat
    db 2  ; 2 
    dw byte_c288, mr_do_push_right_02_pat
    db 2  ; 3 
    dw byte_c288, mr_do_push_right_01_pat

    db 3  ; 0 down	24
    dw byte_c28c, mr_do_walk_right_00_pat
    db 3  ; 1 
    dw byte_c28c, mr_do_walk_right_01_pat
    db 3  ; 2 
    dw byte_c28c, mr_do_walk_right_02_pat
    db 3  ; 3 
    dw byte_c28c, mr_do_walk_right_01_pat

    db 3  ; 0 down 28
    dw byte_c28c, mr_do_push_right_00_pat
    db 3  ; 1 
    dw byte_c28c, mr_do_push_right_01_pat
    db 3  ; 2 
    dw byte_c28c, mr_do_push_right_02_pat
    db 3  ; 3 
    dw byte_c28c, mr_do_push_right_01_pat

    db 4  ; 0 up-mirror 32
    dw byte_c290, mr_do_walk_right_00_pat
    db 4  ; 1 
    dw byte_c290, mr_do_walk_right_01_pat
    db 4  ; 2 
    dw byte_c290, mr_do_walk_right_02_pat
    db 4  ; 3 
    dw byte_c290, mr_do_walk_right_01_pat

    db 4  ; 0 up-mirror 36
    dw byte_c290, mr_do_push_right_00_pat
    db 4  ; 1 
    dw byte_c290, mr_do_push_right_01_pat
    db 4  ; 2 
    dw byte_c290, mr_do_push_right_02_pat
    db 4  ; 3 
    dw byte_c290, mr_do_push_right_01_pat

    db 5  ; 0 down-mirror 40
    dw byte_c294, mr_do_walk_right_00_pat
    db 5  ; 1 
    dw byte_c294, mr_do_walk_right_01_pat
    db 5  ; 2 
    dw byte_c294, mr_do_walk_right_02_pat
    db 5  ; 3 
    dw byte_c294, mr_do_walk_right_01_pat

    db 5  ; 0 down-mirror 44
    dw byte_c294, mr_do_push_right_00_pat
    db 5  ; 1 
    dw byte_c294, mr_do_push_right_01_pat
    db 5  ; 2 
    dw byte_c294, mr_do_push_right_02_pat
    db 5  ; 3 
    dw byte_c294, mr_do_push_right_01_pat

    db 0  ; 0	Death 48
    dw 44 * 4, mr_do_death_f0
    db 0  ; 1
    dw 44 * 4, mr_do_death_f1
    db 0  ; 2
    dw 44 * 4, mr_do_death_f2
    db 0  ; 3
    dw 44 * 4, mr_do_death_f3


byte_c284:    db 178, 179, 176, 177, 45 * 4 + 2, 45 * 4 + 3, 45 * 4 + 0, 45 * 4 + 1
byte_c288:    db 177, 179, 176, 178, 45 * 4 + 1, 45 * 4 + 3, 45 * 4 + 0, 45 * 4 + 2
byte_c28c:    db 176, 178, 177, 179, 45 * 4 + 0, 45 * 4 + 2, 45 * 4 + 1, 45 * 4 + 3
byte_c290:    db 179, 177, 178, 176, 45 * 4 + 3, 45 * 4 + 1, 45 * 4 + 2, 45 * 4 + 0
byte_c294:    db 178, 176, 179, 177, 45 * 4 + 2, 45 * 4 + 0, 45 * 4 + 3, 45 * 4 + 1


mr_do_walk_right_00_pat:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$03,$01,$20,$00,$1e,$00,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$e0,$c0,$00,$00,$c0,$f0,$00,$00,$0f,$1f,$3e,$3e,$3b,$3c,$1f,$0e,$1c,$1e,$1f,$1f,$01,$00,$00,$00,$80,$c0,$a0,$a0,$00,$60,$c0,$80,$00,$00,$c0,$c0,$00,$00
    db $00, $03, $05, $0F, $1D, $36, $00, $00, $2C, $3B, $07, $1D, $17, $01, $00, $00, $00, $C0, $A0, $E0, $00, $00, $00, $00, $40, $E0, $D8, $78, $C0, $60, $C0, $00, $00, $00, $02, $00, $02, $08, $41, $00, $51, $44, $00, $62, $68, $40, $40, $00, $00, $00, $40, $00, $E0, $B0, $B0, $E0, $80, $00, $24, $84, $00, $80, $3C, $00
mr_do_walk_right_01_pat:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$06,$06,$06,$04,$03,$03,$00,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$00,$00,$00,$00,$c0,$00,$00,$0f,$1f,$3f,$3f,$3e,$3b,$1c,$0b,$19,$19,$19,$1b,$0c,$00,$00,$00,$80,$c0,$e0,$e0,$a0,$00,$40,$80,$c0,$c0,$c0,$c0,$80,$00
    db $00, $07, $0B, $1F, $35, $0E, $00, $00, $00, $03, $0F, $1D, $1F, $09, $03, $00, $00, $C0, $60, $E0, $00, $00, $00, $00, $40, $E0, $B8, $E8, $60, $C0, $80, $00, $00, $00, $04, $40, $0A, $00, $01, $00, $01, $04, $00, $02, $00, $06, $00, $00, $00, $00, $80, $00, $E0, $B0, $B0, $E0, $80, $00, $44, $14, $80, $00, $78, $00
mr_do_walk_right_02_pat:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$1e,$3c,$00,$00,$19,$1e,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$00,$20,$00,$00,$e0,$00,$00,$00,$0f,$1f,$3e,$3e,$3b,$3c,$1f,$0b,$01,$03,$1f,$1f,$04,$00,$00,$00,$80,$c0,$a0,$a0,$00,$60,$c0,$80,$c0,$c0,$c0,$c0,$00,$00
    db $00, $03, $0D, $3F, $15, $0E, $00, $00, $06, $0F, $2E, $3B, $07, $07, $00, $00, $00, $C0, $60, $E0, $00, $00, $00, $00, $78, $E8, $A0, $F0, $40, $00, $00, $00, $00, $00, $42, $00, $0A, $00, $01, $00, $01, $00, $51, $44, $00, $00, $07, $00, $00, $00, $80, $00, $E0, $B0, $B0, $E0, $84, $14, $40, $00, $BC, $00, $C0, $00

mr_do_push_right_00_pat:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1e,$00,$00,$00,$00,$00,$00,$00,$00,$78,$00,$01,$3f,$7f,$00,$00,$c0,$f0,$00,$00,$07,$8f,$1f,$1e,$1f,$1d,$0e,$07,$0f,$1f,$1f,$1f,$01,$00,$00,$00,$c0,$e4,$f0,$02,$50,$80,$20,$c0,$c0,$80,$c0,$c0,$00,$00
    db $00, $01, $02, $07, $0E, $1B, $00, $00, $00, $03, $05, $1F, $16, $01, $00, $00, $00, $E0, $D0, $F0, $80, $00, $00, $00, $20, $F0, $EC, $BC, $C0, $E0, $C0, $00, $00, $00, $01, $00, $01, $04, $20, $00, $00, $00, $02, $60, $69, $40, $40, $00, $00, $00, $20, $00, $70, $58, $D8, $70, $C0, $01, $13, $43, $00, $00, $3C, $00
mr_do_push_right_01_pat:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$00,$00,$00,$00,$00,$00,$00,$78,$00,$01,$3f,$7f,$00,$00,$00,$c0,$00,$00,$07,$0f,$1f,$1f,$1f,$1d,$0e,$07,$0f,$1f,$1f,$1f,$0c,$00,$00,$00,$c0,$e0,$f0,$50,$50,$80,$20,$c0,$c0,$80,$c0,$c0,$80,$00
    db $00, $01, $02, $07, $0D, $03, $00, $00, $07, $0F, $0A, $0F, $05, $03, $00, $00, $00, $F0, $D8, $F8, $40, $80, $00, $00, $00, $E0, $FC, $BC, $C0, $80, $00, $00, $00, $00, $01, $10, $02, $00, $00, $00, $00, $00, $05, $00, $02, $00, $03, $00, $00, $00, $20, $00, $B8, $2C, $6C, $38, $60, $01, $03, $43, $00, $00, $E0, $00
mr_do_push_right_02_pat:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$1e,$00,$00,$00,$00,$00,$00,$00,$00,$3c,$01,$3f,$7f,$00,$00,$e0,$00,$00,$00,$23,$07,$0f,$0f,$0f,$0f,$07,$0c,$0f,$1f,$1f,$1f,$04,$00,$00,$00,$e4,$f1,$f8,$20,$88,$a8,$c0,$20,$c0,$80,$c0,$c0,$00,$00
    db $00, $07, $03, $01, $01, $00, $00, $00, $01, $02, $07, $0D, $17, $3C, $00, $00, $00, $E0, $58, $FC, $A0, $C0, $00, $00, $80, $F0, $FC, $5C, $E0, $C0, $00, $00, $00, $00, $08, $00, $00, $00, $00, $00, $00, $01, $00, $02, $08, $00, $3E, $00, $00, $00, $A0, $00, $5C, $16, $36, $1C, $30, $01, $03, $A3, $00, $3C, $00, $00

mr_do_death_f0:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$22,$66,$c6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1f,$1f,$19,$0e,$03,$19,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$f8,$f8,$98,$70,$c0,$98,$38
    db $00, $38, $68, $F8, $58, $E0, $8A, $1F, $1A, $07, $0A, $1F, $1A, $04, $00, $00, $00, $00, $00, $00, $00, $00, $06, $FE, $A8, $F0, $B0, $E8, $78, $28, $30, $00, $00, $00, $10, $01, $A3, $01, $04, $A0, $21, $00, $05, $00, $04, $78, $00, $00, $00, $F0, $F0, $F8, $6C, $68, $F1, $01, $50, $00, $40, $10, $00, $10, $0F, $00
mr_do_death_f1:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$22,$66,$c6,$00,$00,$00,$00,$00,$0f,$1f,$3f,$3f,$3f,$3f,$39,$1e,$03,$19,$1c,$00,$00,$00,$00,$00,$f0,$f8,$fc,$fc,$fc,$fc,$9c,$78,$c0,$98,$38
    db $00, $00, $03, $0D, $3F, $7A, $6F, $34, $08, $08, $18, $2C, $38, $00, $00, $00, $00, $00, $60, $B0, $F8, $A8, $FC, $0C, $06, $06, $04, $00, $00, $E0, $40, $00, $00, $00, $00, $02, $00, $85, $90, $81, $81, $83, $06, $12, $01, $30, $01, $00, $00, $00, $00, $40, $00, $50, $00, $E0, $E0, $F0, $DA, $D2, $E2, $02, $80, $00
mr_do_death_f2:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$22,$66,$c6,$07,$1f,$3f,$7f,$ff,$ff,$ff,$ff,$ff,$7f,$3d,$1a,$0f,$03,$19,$1c,$e0,$f8,$fc,$fe,$ff,$ff,$ff,$ff,$ff,$fe,$bc,$58,$f0,$c0,$98,$38
    db $00, $00, $06, $05, $07, $0A, $0F, $0D, $0F, $08, $00, $00, $50, $78, $00, $00, $00, $00, $00, $1C, $34, $DC, $F8, $50, $F0, $10, $00, $00, $0E, $1A, $00, $00, $00, $0F, $38, $02, $00, $05, $00, $02, $00, $03, $03, $07, $AD, $85, $03, $00, $00, $00, $06, $03, $0B, $21, $01, $A1, $00, $C0, $C0, $E0, $B1, $A5, $C0, $00
mr_do_death_f3:
; DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$22,$66,$c6,$08,$4c,$70,$24,$86,$c0,$24,$0e,$05,$0d,$0c,$07,$02,$03,$19,$1c,$10,$32,$0e,$24,$61,$03,$24,$70,$a0,$b0,$30,$e0,$40,$c0,$98,$38
    db $00, $00, $00, $00, $00, $00, $06, $0A, $5F, $78, $00, $00, $50, $78, $00, $00, $00, $00, $00, $00, $00, $00, $60, $B0, $F6, $1C, $00, $00, $0E, $1A, $00, $00, $00, $03, $04, $03, $00, $00, $80, $85, $A0, $83, $03, $07, $AD, $85, $03, $00, $00, $C0, $20, $C0, $00, $00, $01, $41, $09, $C1, $C0, $E0, $B1, $A5, $C0, $00


byte_c234:    db 10, 11, 8, 9
byte_c238:    db 14, 15, 12, 13
byte_c23c:    db 17, 19, 16, 18
byte_c240:    db 21, 23, 20, 22
byte_c244:    db 24, 26, 25, 27
byte_c248:    db 28, 30, 29, 31
byte_c24c:    db 35, 33, 34, 32
byte_c250:    db 39, 37, 38, 36
byte_c254:    db 42, 40, 43, 41
byte_c258:    db 46, 44, 47, 45
byte_c25c:    db 58, 59, 56, 57
byte_c260:    db 62, 63, 60, 61
byte_c264:    db 65, 67, 64, 66
byte_c268:    db 69, 71, 68, 70
byte_c26c:    db 72, 74, 73, 75
byte_c270:    db 76, 78, 77, 79
byte_c274:    db 83, 81, 82, 80
byte_c278:    db 87, 85, 86, 84
byte_c27c:    db 90, 88, 91, 89
byte_c280:    db 94, 92, 95, 93

byte_c298:    db 234, 235, 232, 233
byte_c29c:    db 238, 239, 236, 237




digger_right_01_pat:
    db 7, 29, 54, 124, 212, 63, 45, 120
    db 215, 55, 120, 222, 33, 126, 0, 0
    db 224, 16, 104, 72, 8, 248, 176, 0
    db 252, 254, 6, 66, 240, 0, 0, 0
digger_right_02_pat:
    db 7, 29, 54, 124, 212, 62, 45, 123
    db 215, 58, 127, 211, 124, 1, 0, 0
    db 224, 16, 104, 0, 120, 252, 196, 160
    db 96, 224, 192, 0, 128, 240, 0, 0
badguy_right_walk_01_pat:
    db 0, 0, 31, 63, 62, 62, 63, 31
    db 6, 29, 63, 125, 16, 62, 0, 0
    db 0, 0, 240, 56, 220, 156, 28, 248
    db 32, 252, 254, 128, 64, 248, 0, 0
badguy_right_walk_02_pat:
    db 0, 31, 63, 62, 62, 63, 30, 5
    db 61, 29, 26, 6, 12, 8, 0, 0
    db 0, 240, 56, 220, 156, 0, 252, 254
    db 128, 100, 108, 248, 16, 16, 0, 0
chomper_right_closed_pat:
    db 0, 14, 31, 25, 14, 17, 63, 56
    db 53, 56, 63, 59, 17, 0, 0, 0
    db 0, 56, 124, 100, 184, 192, 252, 0
    db 84, 0, 252, 220, 136, 0, 0, 0
chomper_right_open_pat:
    db 14, 25, 25, 14, 17, 63, 56, 53
    db 48, 48, 50, 56, 63, 36, 0, 0
    db 56, 100, 100, 184, 192, 252, 0, 84
    db 0, 0, 168, 0, 252, 36, 0, 0
extra_sprite_pat:
    db 30, 57, 57, 96, 71, 68, 71, 68  ; E Left foot down
    db 68, 39, 48, 15, 6, 60, 0, 0
    db 120, 156, 156, 6, 242, 2, 194, 2
    db 2, 244, 12, 240, 126, 0, 0, 0
    db 0, 30, 57, 32, 64, 64, 64, 64  ; Right foot down
    db 64, 96, 48, 31, 126, 0, 0, 0
    db 0, 120, 156, 4, 2, 2, 2, 2
    db 2, 6, 12, 248, 96, 60, 0, 0
    db 0, 30, 57, 32, 64, 64, 64, 64  ; Right foot down
    db 64, 96, 48, 31, 126, 0, 0, 0
    db 0, 120, 156, 4, 2, 2, 2, 2
    db 2, 6, 12, 248, 96, 60, 0, 0
    db 30, 57, 57, 96, 70, 67, 64, 65  ; X Left foot down
    db 67, 38, 48, 15, 6, 60, 0, 0
    db 120, 156, 156, 6, 50, 98, 194, 130
    db 98, 52, 12, 240, 126, 0, 0, 0
    db 30, 57, 57, 96, 71, 64, 64, 64  ; T Left foot down
    db 64, 32, 48, 15, 6, 60, 0, 0
    db 120, 156, 156, 6, 242, 130, 130, 130
    db 130, 132, 12, 240, 126, 0, 0, 0
    db 0, 30, 57, 32, 64, 64, 64, 64  ; Right foot down
    db 64, 96, 48, 31, 126, 0, 0, 0
    db 0, 120, 156, 4, 2, 2, 2, 2
    db 2, 6, 12, 248, 96, 60, 0, 0
    db 0, 30, 57, 32, 64, 64, 64, 64  ; Right foot down
    db 64, 96, 48, 31, 126, 0, 0, 0
    db 0, 120, 156, 4, 2, 2, 2, 2
    db 2, 6, 12, 248, 96, 60, 0, 0
    db 30, 57, 57, 96, 71, 68, 68, 71  ; R Left foot down
    db 68, 36, 48, 15, 6, 60, 0, 0
    db 120, 156, 156, 6, 226, 50, 50, 226
    db 66, 116, 12, 240, 126, 0, 0, 0
    db 30, 57, 57, 96, 65, 67, 70, 68  ; A Left foot down
    db 71, 36, 48, 15, 6, 60, 0, 0
    db 120, 156, 156, 6, 194, 98, 50, 18
    db 242, 20, 12, 240, 126, 0, 0, 0
    db 0, 30, 57, 32, 64, 64, 64, 64  ; Right foot down
    db 64, 96, 48, 31, 126, 0, 0, 0
    db 0, 120, 156, 4, 2, 2, 2, 2
    db 2, 6, 12, 248, 96, 60, 0, 0
    db 0, 1, 1, 13, 30, 63, 63, 63  ; Apple
    db 63, 63, 31, 15, 15, 6, 0, 0
    db 0, 128, 0, 112, 200, 228, 244, 244
    db 252, 252, 248, 240, 240, 96, 0, 0
    db 0, 0, 1, 1, 13, 30, 60, 60  ; Half Split apple
    db 62, 63, 62, 30, 15, 7, 0, 0
    db 0, 0, 128, 0, 56, 100, 242, 250
    db 122, 62, 126, 124, 56, 48, 0, 0
    db 0, 0, 0, 0, 0, 50, 84, 244  ; Fully split apple
    db 248, 252, 124, 124, 62, 15, 0, 0
    db 0, 0, 0, 0, 0, 8, 14, 29
    db 29, 59, 62, 62, 124, 120, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0  ; Squished character from apple
    db 0, 0, 48, 126, 51, 124, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 12, 126, 204, 62, 0, 0
    db 0, 0, 14, 21, 59, 76, 55, 31  ; Diamond
    db 11, 5, 2, 1, 0, 0, 0, 0
    db 0, 0, 224, 80, 184, 100, 216, 240
    db 160, 64, 128, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 1  ; Mr Do Ball
    db 1, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 128
    db 128, 0, 0, 0, 0, 0, 0, 0
ball_sprite_pat:
    db 0, 0, 0, 0, 0, 0, 1, 2
    db 1, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 128
    db 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 1, 2, 4
    db 2, 1, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 128, 64
    db 128, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 1, 4, 0, 8
    db 0, 4, 1, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 64, 0, 32
    db 0, 64, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 1, 8, 0, 0, 16
    db 0, 0, 128, 1, 0, 0, 0, 0
    db 0, 0, 0, 0, 32, 0, 0, 16
    db 0, 0, 32, 0, 0, 0, 0, 0
    db 0, 0, 1, 16, 0, 0, 0, 32
    db 0, 0, 0, 16, 1, 0, 0, 0
    db 0, 0, 0, 16, 0, 0, 0, 8
    db 0, 0, 0, 16, 0, 0, 0, 0
    db 0, 1, 32, 0, 0, 0, 0, 64
    db 0, 0, 0, 0, 32, 0, 1, 0
    db 0, 0, 8, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 8, 0, 0, 0

;%%%%%%%%%%%%%%%%%%%%%%%%
; Multicolor Compressed Tileset

tileset_bitmap:
    db $5A, $00, $AA, $A0, $00, $36, $3F, $16
    db $10, $38, $3B, $13, $07, $C0, $C0, $80
    db $00, $00, $6C, $FC, $39, $33, $03, $01
    db $03, $42, $03, $0D, $68, $FC, $FC, $02
    db $41, $6C, $07, $30, $0C, $33, $0C, $41
    db $0E, $00, $1C, $64, $98, $60, $70, $1F
    db $00, $03, $07, $03, $18, $0C, $0F, $1F
    db $2F, $E0, $04, $C0, $30, $F0, $B8, $1F
    db $1D, $06, $E0, $1F, $58, $D0, $00, $B0
    db $18, $78, $68, $30, $09, $01, $84, $40
    db $0E, $0F, $1E, $07, $80, $05, $48, $90
    db $20, $50, $B8, $2F, $0E, $1F, $13, $3C
    db $1F, $22, $0E, $80, $3C, $FC, $F0, $42
    db $00, $0E, $3F, $7F, $7F, $F3, $00, $7C
    db $FE, $00, $FF, $FF, $E7, $C3, $C3, $E1
    db $E1, $F3, $12, $7F, $7E, $1C, $14, $E7
    db $0D, $38, $7E, $3C, $5E, $FE, $80, $08
    db $F8, $80, $80, $FE, $07, $C6, $6C, $0C
    db $18, $30, $6C, $C6, $0F, $74, $10, $00
    db $07, $FC, $04, $86, $86, $FC, $88, $8E
    db $07, $38, $86, $14, $82, $FE, $82, $A0
    db $BD, $02, $20, $1F, $07, $01, $02, $07
    db $07, $02, $04, $F8, $E0, $80, $40, $E0
    db $07, $9A, $46, $C0, $E5, $00, $15, $6F
    db $00, $0E, $F3, $0F, $6B, $03, $98, $00
    db $25, $47, $04, $CC, $47, $41, $4C, $E7
    db $22, $CF, $04, $61, $01, $C1, $61, $C1
    db $07, $E0, $F0, $32, $7C, $C6, $18, $06
    db $7C, $C0, $97, $00, $C2, $E2, $B2, $9A
    db $8E, $86, $E0, $8F, $82, $43, $82, $91
    db $D5, $06, $AF, $BF, $D2, $00, $B5, $B9
    db $7D, $03, $01, $8B, $B5, $8D, $03, $FF
    db $CC, $E2, $1D, $33, $FF, $0F, $D8, $1F
    db $FF, $CD, $DB, $1F, $63, $2F, $B3, $FF
    db $68, $2F, $1F, $70, $8F, $8C, $22, $0E
    db $F1, $03, $00, $1C, $38, $70, $E0, $C1
    db $83, $07, $0F, $00, $66, $F0, $9F, $F0
    db $66, $0F, $F9, $E0, $C2, $13, $1F, $0E
    db $03, $F8, $07, $70, $70, $CA, $23, $07
    db $03, $01, $E3, $38, $8F, $E0, $3E, $83
    db $F8, $FC, $1F, $F0, $00, $99, $0F, $60
    db $0F, $99, $F0, $06, $FF, $F3, $00, $77
    db $00, $C2, $1F, $30, $21, $11, $22, $22
    db $31, $B3, $0E, $30, $60, $3F, $3E, $0F
    db $01, $F0, $18, $8C, $44, $44, $8C, $18
    db $86, $10, $E0, $F8, $AB, $00, $3D, $1C
    db $2E, $78, $56, $75, $6D, $56, $03, $CC
    db $12, $3D, $37, $1C, $0E, $D5, $8F, $BF
    db $81, $FF, $FE, $80, $07, $EF, $D7, $B7
    db $77, $EF, $F0, $87, $B3, $FE, $07, $4D
    db $0F, $89, $8F, $0E, $FE, $9A, $07, $78
    db $0F, $EF, $19, $FE, $07, $BA, $78, $0F
    db $A7, $57, $FE, $07, $9B, $4F, $1A, $AF
    db $4F, $07, $D7, $4D, $3F, $89, $C7, $F1
    db $FE, $9A, $07, $78, $0F, $CE, $72, $AC
    db $ED, $1F, $09, $B1, $A2, $14, $1B, $1F
    db $F4, $C8, $98, $B0, $14, $F8, $78, $F8
    db $9D, $90, $C4, $1F, $10, $14, $00, $10
    db $1F, $F0, $98, $08, $88, $98, $F0, $3A
    db $40, $C0, $FF, $85, $03, $0D, $1E, $3F
    db $07, $25, $E6, $40, $91, $91, $FC, $DD
    db $B0, $AB, $36, $09, $1F, $80, $0F, $F8
    db $D0, $F8, $6C, $10, $F8, $71, $FC, $3F
    db $1E, $1E, $61, $14, $3F, $F0, $78, $03
    db $3F, $F0, $0E, $1D, $E0, $1F, $90, $FF
    db $38, $74, $83, $32, $7C, $38, $07, $0F
    db $49, $1F, $0F, $CF, $87, $C9, $0F, $7C
    db $0F, $F9, $68, $07, $0F, $7F, $9E, $8F
    db $88, $0F, $7E, $07, $F1, $E2, $43, $E0
    db $AA, $10, $EF, $C7, $8B, $83, $33, $83
    db $C7, $07, $FA, $0F, $4F, $AE, $0F, $06
    db $4F, $8F, $0F, $38, $FF, $13, $1F, $30
    db $AF, $D1, $1F, $06, $77, $07, $0F, $37
    db $C7, $38, $A9, $3F, $89, $6F, $80, $C7
    db $E8, $6F, $81, $B4, $07, $1F, $79, $FF
    db $1F, $C0, $57, $07, $18, $07, $08, $07
    db $C4, $F6, $E0, $19, $18, $E0, $10, $9B
    db $81, $0D, $0F, $07, $02, $02, $82, $CD
    db $D5, $9D, $E1, $F1, $CC, $86, $27, $28
    db $15, $38, $10, $9E, $F8, $E4, $14, $A8
    db $61, $1C, $9E, $06, $3F, $2B, $15, $15
    db $3F, $10, $8D, $5C, $54, $4C, $54, $60
    db $FC, $FD, $1C, $17, $08, $17, $3E, $00
    db $2E, $E8, $10, $01, $DA, $DF, $FF, $FF
    db $FF, $F8

tileset_color:
    db $5A, $F1, $AA, $A0, $00, $B1, $B1, $A1
    db $96, $00, $91, $07, $28, $05, $F1, $07
    db $00, $81, $81, $2F, $61, $61, $0D, $AC
    db $07, $04, $01, $6B, $F1, $71, $07, $19
    db $61, $B1, $65, $00, $11, $10, $95, $32
    db $09, $29, $D9, $17, $3C, $B7, $30, $67
    db $39, $52, $47, $1F, $00, $D1, $D1, $2A
    db $39, $E1, $04, $02, $00, $FB, $07, $9B
    db $00, $FA, $69, $05, $00, $F7, $10, $FA
    db $34, $00, $E1, $00, $E1, $C5, $BF, $6F
    db $00, $7B, $2D, $9F, $25, $6A, $2C, $7A
    db $07, $6A, $32, $CD, $07, $81, $35, $00
    db $5B, $07, $77, $C6, $00, $21, $A9, $00
    db $FB, $7F, $1D, $0D, $00, $C3, $32, $C1
    db $0D, $03, $75, $74, $8D, $01, $E7, $73
    db $82, $01, $BA, $EA, $B1, $E1, $03, $81
    db $E0, $A7, $A3, $C1, $03, $71, $31, $B7
    db $A7, $2E, $D3, $03, $36, $B3, $CB, $01
    db $09, $E3, $B3, $E1, $B1, $03, $31, $25
    db $17, $B3, $EC, $46, $03, $1F, $73, $A7
    db $CF, $01, $91, $37, $00, $70, $C2, $37
    db $81, $3F, $00, $B5, $0F, $F9, $F8, $79
    db $00, $EA, $C7, $BF, $E1, $FF, $D0, $03
    db $CD, $D4, $87, $2E, $71, $03, $EF, $00
    db $0F, $8F, $69, $07, $0F, $F1, $97, $EE
    db $07, $B8, $BF, $1E, $9F, $07, $B5, $00
    db $8F, $A7, $5A, $03, $2D, $85, $AF, $B1
    db $DD, $03, $00, $F1, $B7, $EB, $07, $01
    db $58, $BF, $F5, $07, $00, $A8, $C7, $5D
    db $71, $03, $DF, $00, $1D, $CF, $63, $D7
    db $A6, $98, $ED, $A1, $D5, $06, $07, $62
    db $A6, $94, $ED, $C5, $71, $4D, $81, $8E
    db $05, $21, $B1, $12, $B4, $06, $07, $76
    db $D1, $84, $F3, $07, $43, $A1, $DB, $3E
    db $6E, $D9, $00, $06, $83, $83, $C9, $82
    db $83, $0F, $FB, $85, $07, $87, $87, $97
    db $02, $87, $81, $D3, $07, $0F, $81, $C0
    db $07, $A8, $E8, $B9, $E8, $A8, $C1, $FF
    db $CE, $07, $B8, $07, $2C, $A8, $A9, $02
    db $FF, $1F, $43, $07, $24, $B9, $A8, $87
    db $07, $F7, $C2, $07, $B8, $B8, $B9, $02
    db $C3, $81, $F4, $07, $34, $E9, $30, $B8
    db $83, $FF, $31, $83, $07, $E8, $9A, $07
    db $60, $17, $FF, $FB, $07, $4C, $67, $81
    db $3F, $0B, $07, $98, $98, $96, $02, $07
    db $F7, $DD, $07, $EF, $F8, $BD, $1B, $C1
    db $C1, $7B, $EE, $0D, $E7, $86, $DD, $04
    db $A7, $A1, $F6, $DB, $9F, $EF, $07, $EE
    db $9F, $61, $B4, $40, $D5, $7F, $7F, $07
    db $FF, $FF, $FF, $E0



;%%%%%%%%%%%%%%%%%%%%%%%%
; sound
sub_c952:
    call play_songs
    jp sound_man

initialize_the_sound:
    ld hl, sound_table
    ld b, 9
    jp sound_init

play_opening_tune:
    ld b, opening_tune_snd_0a  ; Play first part of opening tune
    call play_it
    ld b, opening_tune_snd_0b  ; Play second part of opening tune
    call play_it
    ld a, (sound_bank_01_ram)
    and $00C0
    or 2
    ld (sound_bank_01_ram), a
    ld a, (sound_bank_02_ram)
    and $00C0
    or 4
    ld (sound_bank_02_ram), a
    ret
play_background_tune:
    ld b, background_tune_0a  ; Play first part of background tune
    call play_it
    ld b, background_tune_0b  ; Play second part of background tune
    jp play_it

sub_c97f:
    ld a, $00FF
    ld (sound_bank_03_ram), a
    ret

play_grab_cherries_sound:
    ld b, grab_cherries_snd
    jp play_it

sub_c98a:
    ld a, $00FF
    ld (sound_bank_04_ram), a
    ld (sound_bank_05_ram), a
    ret

play_bouncing_ball_sound:
    ld b, bouncing_ball_snd_0a
    call play_it
    ld a, (sound_bank_05_ram)
    cp $00FF
    ret nz
    ld b, bouncing_ball_snd_0b
    jp play_it

play_ball_stuck_sound_01:
    ld a, (sound_bank_05_ram)
    and $3F
    cp 7
    jr nz, play_ball_stuck_sound_02
    ld a, $00FF
    ld (sound_bank_05_ram), a
play_ball_stuck_sound_02:
    ld b, ball_stuck_snd
    jp play_it

play_ball_return_sound:
    ld b, ball_return_snd
    jp play_it

play_apple_falling_sound:
    ld b, apple_falling_snd
    jp play_it

play_apple_breaking_sound:
    ld b, apple_break_snd_0a
    call play_it
    ld a, (sound_bank_05_ram)
    and $3F
    cp 7
    ret z
    ld b, apple_break_snd_0b
    jp play_it

play_no_extra_no_chompers:
    ld b, no_extra_tune_0a
    call play_it
    ld b, no_extra_tune_0b
    call play_it
    ld b, no_extra_tune_0c
    jp loc_d3de

play_diamond_sound:
    call initialize_the_sound
    ld b, diamond_snd
    jp play_it

play_extra_walking_tune_no_chompers:
    ld b, extra_walking_tune_0a
    call play_it
    ld b, extra_walking_tune_0b
    jp play_it

play_game_over_tune:
    call initialize_the_sound
    ld b, game_over_tune_0a
    call play_it
    ld b, game_over_tune_0b
    jp play_it

play_win_extra_do_tune:
    ld b, win_extra_do_tune_0a
    call play_it
    ld b, win_extra_do_tune_0b
    jp play_it

play_very_good_tune:
    ld b, very_good_tune_0a
    call play_it
    ld b, very_good_tune_0b
    call play_it
    ld b, very_good_tune_0c
    jp play_it

play_coin_insert_sfx:
    ld b, sfx_coin_insert_snd
    jp play_it

play_end_of_round_tune:
    call initialize_the_sound
    ld b, end_of_round_tune_0a
    call play_it
    ld b, end_of_round_tune_0b
    jp play_it

play_lose_life_sound:
    call initialize_the_sound
    ld b, lose_life_tune_0a
    call play_it
    ld b, lose_life_tune_0b
    jp play_it

sub_ca24:
    ld a, $00FF
    ld (sound_bank_07_ram), a
    ld (sound_bank_08_ram), a
    ret

sub_ca2d:
    ld a, $00FF
    ld (sound_bank_08_ram), a
    ld (sound_bank_09_ram), a
    ret

play_blue_chompers_sound:
    ld b, blue_chomper_snd_0a
    call play_it
    ld b, blue_chomper_snd_0b
    jp loc_d3ea

sound_table:
    dw new_opening_tune_p1
    dw sound_bank_01_ram
    dw new_background_tune_p1
    dw sound_bank_01_ram
    dw new_opening_tune_p2
    dw sound_bank_02_ram
    dw new_background_tune_p2
    dw sound_bank_02_ram
    dw grab_cherries_sound
    dw sound_bank_03_ram
    dw bouncing_ball_sound_p1
    dw sound_bank_04_ram
    dw bouncing_ball_sound_p2
    dw sound_bank_05_ram
    dw ball_stuck_sound
    dw sound_bank_04_ram
    dw ball_return_sound
    dw sound_bank_04_ram
    dw apple_falling_sound
    dw sound_bank_06_ram
    dw apple_break_sound_p1
    dw sound_bank_06_ram
    dw apple_break_sound_p2
    dw sound_bank_05_ram
    dw no_extra_tune_p1
    dw sound_bank_09_ram
    dw no_extra_tune_p2
    dw sound_bank_07_ram
    dw no_extra_tune_p3
    dw sound_bank_08_ram
    dw diamond_sound
    dw sound_bank_09_ram
    dw extra_walking_tune_p1
    dw sound_bank_07_ram
    dw extra_walking_tune_p2
    dw sound_bank_08_ram
    dw game_over_tune_p1
    dw sound_bank_01_ram
    dw game_over_tune_p2
    dw sound_bank_02_ram
    dw new_win_extra_do_tune_p1
    dw sound_bank_01_ram
    dw new_win_extra_do_tune_p2
    dw sound_bank_02_ram
    dw end_of_round_tune_p1
    dw sound_bank_01_ram
    dw end_of_round_tune_p2
    dw sound_bank_02_ram
    dw lose_life_tune_p1
    dw sound_bank_01_ram
    dw lose_life_tune_p2
    dw sound_bank_02_ram
    dw new_blue_chomper_sound_0a
    dw sound_bank_08_ram
    dw new_blue_chomper_sound_0b
    dw sound_bank_09_ram
    dw very_good_tune_p1
    dw sound_bank_01_ram
    dw very_good_tune_p2
    dw sound_bank_02_ram
    dw very_good_tune_p3
    dw sound_bank_03_ram
    dw sfx_coin_insert
    dw sound_bank_01_ram

grab_cherries_sound:
    db 193, 214, 48, 2, 51, 149, 193, 214, 48, 2, 51, 149, 193, 214, 48, 2, 51, 149, 234, 193, 190, 48
    db 2, 51, 161, 193, 190, 48, 2, 51, 161, 193, 190, 48, 2, 51, 161, 234, 193, 170, 48, 2, 51, 171
    db 193, 170, 48, 2, 51, 171, 193, 170, 48, 2, 51, 171, 234, 193, 160, 48, 2, 51, 176, 193, 160, 48
    db 2, 51, 176, 193, 160, 48, 2, 51, 176, 234, 193, 143, 48, 2, 51, 185, 193, 143, 48, 2, 51, 185
    db 193, 143, 48, 2, 51, 185, 234, 193, 127, 48, 2, 51, 193, 193, 127, 48, 2, 51, 193, 193, 127, 48
    db 2, 51, 193, 234, 193, 113, 48, 2, 51, 200, 193, 113, 48, 2, 51, 200, 193, 113, 48, 2, 51, 200
    db 234, 193, 107, 48, 2, 51, 203, 193, 107, 48, 2, 51, 203, 193, 107, 48, 2, 51, 203, 208
bouncing_ball_sound_p1:
    db 130, 75, 129, 6, 194, 51, 152
bouncing_ball_sound_p2:
    db 194, 138, 129, 6, 194, 51, 216
ball_stuck_sound:
    db 192, 64, 1, 3, 193, 127, 16, 2, 51, 127, 193, 107, 16, 2, 51, 107, 193, 80, 32, 2, 51, 80
    db 193, 64, 32, 2, 51, 64, 193, 53, 48, 2, 51, 53, 193, 40, 64, 2, 51, 40, 193, 32, 80, 2
    db 51, 32, 193, 24, 96, 2, 51, 24, 193, 20, 112, 2, 51, 20, 193, 16, 128, 2, 51, 16, 208
ball_return_sound:
    db 193, 16, 128, 2, 51, 16, 193, 20, 112, 2, 51, 20, 193, 24, 96, 2, 51, 24, 193, 32, 80, 2
    db 51, 32, 193, 40, 80, 2, 51, 40, 193, 53, 64, 2, 51, 53, 193, 64, 64, 2, 51, 64, 193, 80
    db 48, 2, 51, 80, 193, 107, 48, 2, 51, 107, 193, 127, 32, 2, 51, 127, 192, 64, 17, 3, 208
apple_falling_sound:
    db 129, 57, 80, 7, 68, 4, 129, 89, 48, 7, 68, 7, 129, 145, 112, 7, 68, 11, 129, 233, 176, 7, 68, 16, 144
apple_break_sound_p1:
    db 128, 172, 17, 8, 167, 129, 107, 48, 2, 71, 250, 144
apple_break_sound_p2:
    db 192, 29, 17, 8, 231, 193, 127, 48, 2, 71, 249, 208
no_extra_tune_p1:
    db 65, 27, 0, 2, 102, 1, 65, 32, 32, 2, 102, 4, 64, 40, 48, 6, 111, 64, 107, 48, 7
    db 99, 64, 107, 48, 7, 99, 64, 85, 48, 7, 99, 64, 85, 48, 7, 99, 64, 71, 48, 7, 99
    db 64, 71, 48, 7, 99, 64, 85, 48, 10, 106, 64, 80, 48, 7, 99, 64, 80, 48, 7, 99, 64
    db 95, 48, 7, 99, 64, 95, 48, 7, 99, 64, 113, 48, 7, 99, 64, 113, 48, 7, 99, 64, 143
    db 48, 10, 106, 64, 170, 64, 7, 99, 64, 170, 64, 7, 99, 64, 143, 64, 7, 99, 64, 143, 64
    db 7, 99, 64, 107, 64, 7, 99, 64, 107, 64, 7, 99, 64, 85, 64, 10, 106, 64, 95, 64, 7
    db 99, 64, 95, 64, 7, 99, 65, 107, 64, 2, 85, 6, 65, 127, 64, 2, 85, 242, 64, 107, 64
    db 7, 99, 64, 107, 64, 7, 99, 64, 107, 64, 10, 80
no_extra_tune_p2:
    db 129, 60, 0, 2, 102, 16, 128, 50, 32, 6, 129, 101, 48, 2, 102, 231, 175, 128, 214, 64, 7
    db 163, 128, 170, 64, 10, 170, 128, 143, 64, 7, 163, 128, 170, 64, 10, 170, 128, 127, 64, 10, 170
    db 128, 143, 64, 7, 163, 128, 113, 64, 10, 170, 128, 95, 64, 7, 163, 128, 71, 64, 20, 180, 128
    db 71, 48, 7, 163, 128, 64, 48, 7, 163, 128, 71, 48, 7, 163, 128, 64, 48, 7, 163, 128, 71
    db 48, 7, 163, 128, 71, 48, 7, 163, 128, 85, 48, 10, 170, 128, 80, 48, 7, 163, 128, 80, 48
    db 7, 163, 128, 95, 48, 7, 163, 128, 95, 48, 7, 163, 128, 107, 48, 10, 144
no_extra_tune_p3:
    db 193, 64, 0, 2, 102, 16, 192, 53, 32, 6, 193, 107, 48, 2, 102, 229, 208
lose_life_tune_p1:
; High B
    db 64, 56, 80, 7, 99
; High C
    db 64, 53, 90, 7, 107
; Sec F
    db 64, 160, 80, 4, 99
; Sec G
    db 64, 142, 80, 7, 107
; SEcond Highest G$
    db 64, 67, 80, 7, 99
; B Flat (B5)
    db 64, 119, 80, 7, 107
; D$ (low)
    db 64, 206, 82, 7, 99
; C (low)
    db 64, 86, 83, 7, 80
lose_life_tune_p2:
    db 128, 56, 96, 7, 162
    db 128, 53, 96, 7, 170
; Middle G$
    db 128, 134, 96, 4, 162
; Middle B (B4)
    db 192, 142, 96, 7, 235
; D$ (D5)
    db 192, 89, 96, 7, 227
; F$ (middle)
    db 192, 119, 96, 7, 235
; D$ (low)
    db 192, 206, 98, 7, 227
; C (low)
    db 192, 86, 99, 7, 144
diamond_sound:
    db 130, 23, 80, 8, 27, 17, 152

extra_walking_tune_p1:
    db 64, 107, 48, 7, 99, 64, 143, 48, 7, 99, 64, 143, 48, 7, 99, 64, 143, 48, 7, 99, 64
    db 107, 48, 7, 99, 64, 143, 48, 7, 99, 64, 143, 48, 7, 99, 64, 143, 48, 7, 99, 64, 127
    db 48, 7, 99, 64, 160, 48, 7, 99, 64, 160, 48, 7, 99, 64, 160, 48, 7, 99, 64, 127, 48
    db 7, 99, 64, 160, 48, 7, 99, 64, 160, 48, 7, 99, 64, 160, 48, 7, 99, 64, 143, 48, 7
    db 99, 64, 113, 48, 7, 99, 64, 113, 48, 7, 99, 64, 113, 48, 7, 99, 64, 143, 48, 7, 99
    db 64, 113, 48, 7, 99, 64, 113, 48, 7, 99, 64, 113, 48, 7, 99, 64, 113, 48, 7, 99, 64
    db 95, 48, 7, 99, 64, 113, 48, 7, 99, 64, 95, 48, 7, 99, 64, 95, 48, 7, 99, 64, 107
    db 48, 7, 99, 64, 107, 48, 10, 88
extra_walking_tune_p2:
    db 128, 143, 80, 5, 129, 107, 128, 3, 85, 228, 128, 170, 80, 5, 129, 107, 128, 3, 85, 228, 128
    db 143, 80, 5, 129, 107, 128, 3, 85, 228, 128, 85, 80, 5, 129, 107, 128, 3, 85, 228, 128, 95
    db 80, 5, 129, 95, 128, 3, 85, 226, 128, 127, 80, 5, 129, 95, 128, 3, 85, 226, 128, 80, 80
    db 5, 129, 95, 128, 3, 85, 226, 128, 107, 80, 5, 129, 95, 128, 3, 85, 226, 128, 113, 80, 5
    db 129, 113, 128, 3, 85, 214, 128, 71, 80, 5, 129, 113, 128, 3, 85, 214, 128, 127, 80, 5, 129
    db 113, 128, 3, 85, 214, 128, 80, 80, 5, 129, 113, 128, 3, 85, 214, 128, 85, 80, 5, 129, 113
    db 128, 3, 85, 214, 128, 95, 80, 5, 129, 113, 128, 3, 85, 214, 128, 107, 80, 5, 129, 71, 128
    db 3, 85, 71, 128, 214, 80, 10, 152
game_over_tune_p1:
    db 64, 160, 48, 22, 64, 107, 48, 7, 100, 64, 107, 48, 7, 100, 64, 127, 48, 11, 107, 64, 160
    db 48, 11, 107, 64, 160, 48, 22, 64, 107, 48, 7, 100, 64, 107, 48, 7, 100, 64, 127, 48, 11
    db 107, 64, 160, 48, 11, 107, 64, 143, 48, 11, 107, 64, 107, 48, 7, 100, 64, 107, 48, 7, 100
    db 64, 107, 48, 22, 118, 118, 64, 213, 48, 11, 107, 64, 160, 48, 11, 80
; GAME_OVER_TUNE_P1:
; 	DB 064,$50,096,010,106 ; F
;   DB 064,$35,096,007,099 ; C
;   DB 064,$35,096,007,099 ; C
;   DB 064,$3F,096,017,099 ; A
;   DB 064,$50,096,017,099 ; F
;   DB 064,$50,096,010,106 ; F

;   DB 064,$35,096,007,099 ; C
;   DB 064,$35,096,007,099 ; C
;   DB 064,$3F,096,017,099 ; A
;   DB 064,$50,096,017,099 ; F

;   DB 064,$47,096,010,106 ; G
;   DB 064,$35,096,007,099 ; C
;   DB 064,$35,096,007,099 ; C
;   DB 064,$35,096,040,116 ; C
;   DB 096,$6A,096,010,106 ; lower C
;   DB 064,$50,096,010,106,080 ; F

; GAME_OVER_TUNE_P2:
;   DB 128,$7F,096,017,163
;   DB 128,$6A,096,017,163
;   DB 128,$7F,096,017,163
;   DB 128,$6A,096,017,163
;   DB 128,$7F,096,017,163
;   DB 128,$6A,096,017,163
;   DB 128,$7F,096,017,163
;   DB 128,$6A,096,017,163
;   DB 128,$8E,096,017,163
;   DB 128,$6A,096,017,163
;   DB 128,$8E,096,017,163
;   DB 128,$6A,096,020,180
;   DB 128,171,097,010,170
;   DB 128,064,097,020,144


game_over_tune_p2:
    db 182, 182, 128, 64, 81, 22, 128, 214, 80, 7, 164, 128, 214, 80, 7, 164, 128, 254, 80, 11, 171
    db 128, 64, 81, 11, 171, 128, 64, 81, 22, 128, 214, 80, 7, 164, 128, 214, 80, 7, 164, 128, 240
    db 96, 11, 171, 128, 254, 96, 11, 171, 128, 29, 97, 11, 171, 128, 87, 99, 7, 164, 128, 87, 99
    db 7, 164, 128, 87, 99, 22, 128, 86, 115, 11, 107, 128, 128, 114, 11, 144
win_extra_do_tune_p1:
    db 65, 170, 48, 2, 170, 20, 65, 214, 48, 2, 170, 232, 66, 170, 48, 10, 52, 21, 65, 190, 48
    db 2, 245, 24, 66, 254, 48, 10, 52, 21, 65, 202, 48, 2, 170, 24, 65, 254, 48, 2, 170, 228
    db 66, 202, 48, 10, 52, 21, 65, 226, 48, 2, 245, 28, 65, 214, 48, 2, 170, 12, 65, 240, 48
    db 2, 165, 242, 65, 254, 48, 2, 165, 31, 66, 202, 48, 10, 52, 21, 65, 214, 48, 2, 165, 244
    db 65, 226, 48, 2, 165, 28, 66, 190, 48, 10, 52, 21, 65, 254, 48, 2, 165, 228, 65, 254, 48
    db 2, 165, 48, 66, 125, 49, 20, 52, 21, 66, 190, 48, 20, 52, 21, 80
win_extra_do_tune_p2:
    db 130, 172, 49, 20, 52, 21, 130, 29, 49, 20, 52, 21, 130, 172, 49, 20, 52, 21, 129, 252, 49
    db 2, 170, 228, 130, 197, 49, 20, 52, 21, 130, 46, 49, 20, 52, 21, 130, 197, 49, 20, 52, 21
    db 129, 46, 49, 2, 170, 18, 130, 83, 49, 20, 52, 21, 130, 197, 49, 20, 52, 21, 130, 252, 49
    db 20, 52, 21, 130, 148, 49, 20, 52, 21, 130, 125, 49, 20, 52, 21, 130, 252, 49, 20, 52, 21
    db 129, 125, 49, 2, 170, 127, 130, 125, 49, 20, 52, 21, 144
end_of_round_tune_p1:
; LOW NOTES
    db 128, 106, 129, 7, 163
    db 128, 80, 129, 7, 163
    db 128, 63, 129, 7, 163
    db 128, 53, 129, 10, 170
    db 128, 63, 129, 7, 163
    db 128, 53, 129, 30, 163, 144

end_of_round_tune_p2:
; HIGH NOTES
; C4 Middle
    db 192, 213, 64, 7, 227  ;+3
; F4
    db 192, 160, 64, 7, 227  ;+3
; A4
    db 192, 127, 64, 7, 227  ;+3
; C5
    db 192, 106, 64, 10, 234  ;+10
; A4
    db 192, 127, 64, 7, 227  ;+3
; C5
    db 192, 106, 64, 30, 227, 80  ;+3

blue_chomper_sound_0a:
    db 65, 255, 115, 4, 20, 17, 104, 88
blue_chomper_sound_0b:
    db 2, 18, 4, 20, 17, 2, 80, 12, 83, 19, 24

loc_d300:
    set 0, (hl)
    ld hl, $05A0
    xor a
    jp loc_b895
loc_d309:
    ld hl, $7272
    bit 5, (hl)
    jr z, loc_d319
    res 5, (hl)
    push iy
    call play_no_extra_no_chompers
    pop iy
loc_d319:
    jp loc_a596
loc_d31c:
    ld a, ($7272)
    bit 5, a
    ret nz
    jp play_extra_walking_tune_no_chompers
loc_d326:
    call sub_b8f7
    push iy
    call sub_ca24
    ld hl, gamecontrol
    set 7, (hl)
loc_d333:
    bit 7, (hl)
    jr nz, loc_d333
    ld bc, $01E2
    call write_register
    call play_blue_chompers_sound
    pop iy
    jp loc_b8ab
loc_d345:
    call sub_ca2d
    ld hl, gamecontrol
    set 7, (hl)
loc_d34d:
    bit 7, (hl)
    jr nz, loc_d34d
    ld bc, $01E2
    call write_register
    ld hl, $7272
    jp loc_b875
loc_d35d:
    ld (gametimer), a
    call play_extra_walking_tune_no_chompers
    jp loc_b89b
loc_d366:
    call sub_9577
    xor a
    jp loc_9481
loc_d36d:
    ld (timerchomp1), a  ; save signal timer for chomper mode
    ld hl, $72C4
    bit 0, (hl)
    jp z, loc_b8ec
    res 0, (hl)
    ld a, (gametimer)
    call test_signal
    jp loc_b8ec
sub_a83e:
loc_d383:
    ld a, (timerchomp1)
    call test_signal
    and a
    jp z, loc_d3a6
    ld hl, gameflags
    ld a, (hl)
    xor 1
    ld (hl), a
    ld hl, $78
    rra
    jr nc, loc_d39f
    ld l, $3C
loc_d39f:
    xor a
    call request_signal
    ld (timerchomp1), a
loc_d3a6:
    ld a, (gameflags)
    rra
    jp nc, loc_a853
    jp loc_a858

loc_d3d5:
    and 7
    ld c, $00C0
    cp 3
    jp loc_a8af
loc_d3de:
    call play_it
    ld a, $00FF
    ld (sound_bank_01_ram), a
    ld (sound_bank_02_ram), a
    ret
loc_d3ea:
    call play_it
    ld a, $00FF
    ld (sound_bank_01_ram), a
    ld (sound_bank_02_ram), a
    ld (sound_bank_07_ram), a
    ret

loc_d3f9:
    ld a, (sound_bank_01_ram)
    and $0F
    cp 2
    jr z, loc_d405
    call restore_playfield_colors
    call play_background_tune
loc_d405:
    call sub_999f
    jp loc_98a5
loc_d40b:
    ld a, (diamond_ram)
    rla
    jp nc, loc_d3f9
    ld a, (sound_bank_09_ram)
    cp $00FF
    jp nz, loc_d405
    call play_diamond_sound
    jp loc_d405

new_opening_tune_p1:
    db 64, 143, 96, 7, 99, 64, 214, 96, 7, 99, 64, 214, 96, 7, 99, 64, 214, 96, 7, 99, 64, 160
    db 96, 7, 99, 64, 226, 96, 7, 99, 64, 226, 96, 7, 99, 64, 226, 96, 7, 99, 64, 143, 96, 7
    db 99, 64, 160, 96, 7, 99, 64, 170, 96, 7, 99, 64, 190, 96, 7, 99, 64, 214, 96, 30, 106
new_background_tune_p1:
; OVER LONG D
; F4 10
    db 64, 160, 128, 7, 99
; G4 10
    db 64, 142, 128, 7, 99
; OVER LONG D
; F4 10
    db 64, 160, 128, 7, 99
; G4 10
    db 64, 142, 128, 7, 99

; D4 (short) 10
    db 64, 160, 128, 7, 99
; D4 (complements lower F) 10
    db 64, 190, 128, 7, 99
; C (complements lower E) 10
    db 64, 142, 128, 7, 99
; D4 (complements lower D) 10
    db 64, 160, 128, 7, 99
; C4 (complements lower C) 10
    db 64, 168, 160, 7, 99
; E5 (complements lower C) 10
    db 64, 71, 128, 7, 99
; G on the B 10
    db 64, 190, 128, 7, 99
; F on the A 10
    db 64, 160, 128, 7, 99
; E on the G 10
    db 64, 169, 128, 7, 99
; D on the F 10
    db 64, 190, 128, 7, 99
; C on the E 10
    db 64, 213, 128, 7, 99
; B on the D 20
    db 64, 160, 128, 7, 99

; E2 33
; DB 064,169,128,030,106
; E4 10
    db 64, 169, 128, 10, 106
; E4 10
    db 64, 169, 128, 7, 99
; G4 16
    db 64, 142, 128, 7, 99

; D4 10
    db 64, 160, 128, 7, 99
; F4 10
    db 64, 190, 128, 7, 99
; E4 10
    db 64, 142, 128, 7, 99
; D4 10
    db 64, 160, 128, 7, 99
; G4 20
; DB 064,142,128,010,106
; G4 20
; DB 064,142,128,010,106
; E4 (complements lower G) 10

; OVER LONG G
; E4 10
    db 64, 169, 128, 7, 99
; C4 10
    db 64, 213, 128, 7, 99
; OVER LONG G
; E4 10
    db 64, 169, 128, 7, 99
; C4 10
    db 64, 213, 128, 7, 99

    db 64, 169, 128, 7, 99
; F4 (complements lower A) 10
    db 64, 160, 128, 7, 99
; C4 (complements lower E) 10
    db 64, 213, 128, 7, 99
; D4 (complements lower F) 10
    db 64, 190, 128, 7, 99, 88
; B4 (over long D) 20
; DB 064,226,128,010,106
; B4 (over long D) 20
; DB 064,226,128,010,106
new_opening_tune_p2:
    db 128, 170, 128, 7, 163, 128, 170, 128, 10, 170, 128, 170, 128, 7, 163, 128, 190, 128, 7, 163, 128
    db 190, 128, 10, 170, 128, 190, 128, 7, 163, 128, 170, 128, 7, 163, 128, 190, 128, 7, 163, 128, 214
    db 128, 7, 163, 128, 226, 128, 7, 163, 128, 214, 128, 7, 163, 128, 226, 128, 7, 163, 128, 254, 128
    db 7, 163, 128, 29, 129, 7, 163
new_background_tune_p2:
; Note 12: D3
    db 128, 124, 97, 10, 170
; Note 13: D3
    db 128, 124, 97, 10, 170

; Note 14: D3
    db 128, 124, 97, 7, 163

; Note 15: F3
    db 128, 64, 97, 7, 163
; Note 16: E3
    db 128, 83, 97, 7, 163
; Note 17: D3
    db 128, 124, 97, 7, 163
; Note 18: C3
    db 128, 171, 97, 7, 163
; Note 19: C4
    db 128, 213, 96, 7, 163
; Note 20: B4
    db 128, 226, 96, 7, 163
; Note 21: A4
    db 128, 254, 96, 7, 163
; Note 22: G3
    db 128, 29, 97, 7, 163
; Note 23: F3
    db 128, 64, 97, 7, 163
; Note 24: E3
    db 128, 83, 97, 7, 163
; Note 25: D3
    db 128, 124, 97, 7, 163
; Note 1: C3
    db 128, 171, 97, 30, 170
; Note 2: D3
    db 128, 62, 97, 7, 163
; Note 3: F3
    db 128, 64, 97, 7, 163
; Note 4: E3
    db 128, 83, 97, 7, 163
; Note 5: D3
    db 128, 124, 97, 7, 163
; Note 6: G3 (longer duration)
    db 128, 29, 97, 10, 170
; Note 7: G3 (longer duration)
    db 128, 29, 97, 10, 170
; Note 8: G3
    db 128, 29, 97, 7, 163
; Note 9: A4
    db 128, 254, 96, 7, 163
; Note 10: E3
    db 128, 83, 97, 7, 163
; Note 11: F3
    db 128, 64, 97, 7, 163, 152

new_blue_chomper_sound_0a:
; F3
    db 64, 64, 97, 7, 99
; D3
    db 64, 124, 97, 7, 99
; B flat 10 (below C4)
    db 64, 238, 96, 7, 99
; B flat 10 (below C4)
    db 64, 238, 96, 7, 99
; G3
    db 64, 29, 97, 7, 99
; B flat 10 (below C4)
    db 64, 238, 96, 7, 99
; B flat 10 (below C4)
    db 64, 238, 96, 7, 99
; G3
    db 64, 29, 97, 7, 99, 88
new_blue_chomper_sound_0b:
; D3 20
    db 128, 124, 129, 10, 170
; B flat 10
    db 128, 223, 129, 7, 163
; D3 10
    db 128, 124, 129, 7, 163
; E flat 10
    db 128, 103, 129, 7, 163
; B flat 10
    db 128, 223, 129, 7, 163
; E flat 10
    db 128, 103, 129, 7, 163, 152


new_win_extra_do_tune_p1:
; Long e x2
    db 64, 169, 96, 10, 106  ;20
    db 64, 169, 96, 10, 106  ;20
; Short e
    db 64, 169, 96, 7, 99  ;10
; Long f
    db 64, 160, 96, 10, 106  ;20
; Short f$
    db 64, 151, 96, 7, 99  ;10
; Very long g
    db 64, 142, 96, 30, 116  ;50

; BEGIN 2

; very short gf$g
    db 64, 142, 96, 7, 99  ;10
    db 64, 151, 96, 7, 99  ;10
    db 64, 142, 96, 7, 99  ;10

;long a
    db 64, 127, 96, 10, 106  ;20
;long a
    db 64, 127, 96, 10, 106  ;20
;short a
    db 64, 127, 96, 7, 99  ;10
;--------------------------------
;long b
    db 64, 113, 96, 10, 106  ;20

;short c
    db 64, 106, 96, 7, 99  ;10

;very long e
    db 64, 84, 96, 30, 106  ;30 + 10 pad
;++++++++++++++++++++++++++++++++

; BEGIN 3 (at end of long e)

    db 116  ; 20 pad

; short f (plays over the c pad)
    db 64, 80, 96, 7, 99  ;10

; short e
    db 64, 84, 96, 7, 99  ;10

; long D
    db 64, 95, 96, 20, 106  ;30

; short a (over end of long f)
    db 64, 127, 80, 10, 106  ;20

; e over 20 pad after long f
    db 64, 84, 96, 7, 99  ;10
; d over 20 pad after long f
    db 64, 95, 96, 7, 99  ;10

; (((((((())))))))

; long c
    db 64, 106, 96, 20, 106  ;30

; short g
    db 64, 142, 64, 10, 106  ;20

; short f$
    db 64, 151, 96, 7, 99  ;10

; short g
    db 64, 142, 96, 7, 99  ;10

; long a
    db 64, 127, 96, 10, 106  ;20

;********************************
; long a
    db 64, 127, 96, 10, 106  ;20
; short b
    db 64, 113, 96, 7, 99  ;10
; long a
    db 64, 127, 96, 10, 106  ;20


; short g
    db 64, 142, 96, 7, 99  ;10

; very long c
    db 64, 106, 96, 30, 116  ;50
; short c
    db 64, 106, 96, 10, 80  ;10

new_win_extra_do_tune_p2:
; C
    db 128, 171, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 163  ;10
; E
    db 128, 83, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 163  ;10

; C
    db 128, 171, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 163  ;10
; E
    db 128, 83, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 163  ;10

; C
    db 128, 171, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 163  ;10
; E
    db 128, 83, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 163  ;10

; C
    db 128, 171, 113, 7, 163  ;10

; BEGIN 2
; G
    db 128, 29, 113, 7, 163  ;10
; E
    db 128, 83, 113, 7, 163  ;10
; G
    db 128, 29, 113, 7, 173  ;20

; A (over second half of first long a)
    db 128, 254, 112, 7, 163  ;10
; Short f (first half of second long a)
    db 128, 64, 113, 7, 163  ;10
; A (over second half of second long a)
    db 128, 254, 112, 7, 173  ;20
;--------------------------------

; short a - long pause
    db 128, 254, 112, 7, 173  ;20

; short a - short pause
    db 128, 254, 112, 7, 163  ;10

; C
    db 128, 171, 113, 10, 170  ;20

; C (up an octave)
    db 128, 106, 112, 10, 170  ;20

;++++++++++++++++++++++++++++++++

; BEGIN 3 (at end of C)

; over first half of 20 pad
; E
    db 128, 83, 113, 7, 163  ;10

; over second half of 20 pad
; C
    db 128, 106, 112, 7, 173  ;20


; short c (over short e)
    db 128, 106, 112, 7, 163  ;10


; very long f (over d and a)
    db 128, 64, 113, 50, 180  ;50 + 20 pad


; (((((((())))))))

; very long e
    db 128, 83, 113, 50, 190  ;50 + 30 pad

; very short a
    db 128, 254, 112, 7, 163  ;10

;********************************

; short f$
    db 128, 46, 113, 7, 163  ;10
; very short a
    db 128, 254, 112, 7, 163  ;10
; very short e
    db 128, 83, 113, 7, 163  ;10

; short g
    db 128, 29, 113, 7, 163  ;10
; short f
    db 128, 64, 113, 7, 163  ;10


; complementary G
    db 128, 29, 113, 10, 190  ;40

; short c
    db 128, 171, 113, 10, 170  ;20
; short c
    db 128, 171, 113, 10, 144  ;10

very_good_tune_p1:
; F Sharp
    db 64, $4B, 64, 5, 98  ;7
; G
    db 64, $47, 64, 5, 98  ;7
; E
    db 64, $54, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 99  ;14

; F Sharp
    db 64, $4B, 64, 5, 98  ;7
; G
    db 64, $47, 64, 5, 98  ;7
; E
    db 64, $54, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 99  ;14
;--------------------------------

; Highest E
    db 64, $2A, 64, 11, 99  ;14
; D
    db 64, $2F, 64, 5, 98  ;7
; C
    db 64, $35, 64, 5, 98  ;7
; B
    db 64, $38, 64, 5, 98  ;7
; A
    db 64, $3F, 64, 5, 98  ;7

; G
    db 64, $47, 64, 11, 99  ;14
; F
    db 64, $50, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 99  ;14
; Short F
    db 64, $50, 64, 11, 99  ;14
; G
    db 64, $47, 64, 25, 99  ;28

;--------------------------------
; F Sharp
    db 64, $4B, 64, 5, 98  ;7
; G
    db 64, $47, 64, 5, 98  ;7
; E
    db 64, $54, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 99  ;14

; F Sharp
    db 64, $4B, 64, 5, 98  ;7
; G
    db 64, $47, 64, 5, 98  ;7
; E
    db 64, $54, 64, 11, 99  ;14
; E
    db 64, $54, 64, 11, 98  ;14


; Highest E
    db 64, $2A, 64, 11, 99  ;14
; D
    db 64, $2F, 64, 5, 98  ;7
; C
    db 64, $35, 64, 5, 98  ;7
; B
    db 64, $38, 64, 5, 98  ;7
; A
    db 64, $3F, 64, 5, 98  ;7

; G
    db 64, $47, 64, 11, 99  ;14

; B
    db 64, $38, 64, 11, 99  ; 14
; C
    db 64, $35, 64, 11, 99  ; 14
; Highest E
    db 64, $2A, 64, 11, 99  ;14
; C
    db 64, $35, 64, 14, 80  ; 14

;32
very_good_tune_p2:
; F$
    db 128, 46, 81, 5, 162  ;7
; G
    db 128, 29, 81, 5, 162  ;7
; E
    db 128, 83, 81, 11, 163  ;14
; Low E
    db 128, 166, 82, 11, 163  ;14
; C
    db 128, 171, 81, 11, 163  ;14

; F$
    db 128, 46, 81, 5, 162  ;7
; G
    db 128, 29, 81, 5, 162  ;7
; E
    db 128, 83, 81, 11, 163  ;14
; Low E
    db 128, 166, 82, 11, 163  ;14

;--------------------------------

; C
    db 128, 171, 81, 11, 163  ;14
; B
    db 128, 196, 81, 5, 162  ;7
; A
    db 128, 252, 81, 5, 162  ;7
; G
    db 128, 58, 82, 5, 162  ;7
; F
    db 128, 128, 82, 5, 162  ;7
; E
    db 128, 166, 82, 11, 163  ;14
; D
    db 128, 249, 82, 11, 163  ;14
; Short E
    db 128, 166, 82, 11, 163  ;14
; Short D
    db 128, 249, 82, 11, 163  ;14
; Short E
    db 128, 166, 82, 11, 163  ;14
; Short E
    db 128, 166, 82, 11, 163  ;14
;--------------------------------
; F$
    db 128, 46, 65, 5, 162  ;7
; G
    db 128, 29, 65, 5, 162  ;7
; E
    db 128, 83, 65, 11, 163  ;14
; Low E
    db 128, 166, 66, 11, 163  ;14
; C
    db 128, 171, 65, 11, 163  ;14

; F$
    db 128, 46, 65, 5, 162  ;7
; G
    db 128, 29, 65, 5, 162  ;7
; E
    db 128, 83, 65, 11, 163  ;14
; Low E
    db 128, 166, 66, 11, 163  ;14

; C
    db 128, 171, 65, 11, 163  ;14
; B
    db 128, 196, 65, 5, 162  ;7
; A
    db 128, 252, 65, 5, 162  ;7
; G
    db 128, 58, 66, 5, 162  ;7
; F
    db 128, 128, 66, 5, 162  ;7
; E
    db 128, 166, 66, 11, 163  ;14
; D
    db 128, 249, 66, 11, 163  ;14
; Short E
    db 128, 166, 66, 11, 163  ;14
; Short E
    db 128, 166, 66, 11, 163  ;14
; E
    db 128, 166, 66, 14, 144  ;14

very_good_tune_p3:
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14

; G
    db 192, 58, 146, 11, 227  ; 14
; F
    db 192, 128, 146, 11, 227  ; 14

    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14

; G
    db 192, 58, 146, 11, 227  ; 14
; F
    db 192, 128, 146, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 11, 227  ; 14
    db 192, 86, 147, 14, 208  ; 14

sfx_coin_insert:
; AY volume to SN volume: SN_vol = 0xF - AY_vol
; AY period to SN period: SN_period = AY_period / 2 (integer division)
; Pos 000: AY period 0x05F(95) → SN period 95/2=47=0x2F

; Pos 000: SN=0x2F → doubled=0x5E
    db $40, $5E, $A0, 1

; 001: 0x32→0x64
    db $40, $64, $90, 2

; 002: 0x23→0x46
    db $40, $46, $80, 1

; 003: 0x25→0x4A
    db $40, $4A, $70, 2

; 004: 0x25→0x4A
    db $40, $4A, $60, 1

; 005: 0x20→0x40
    db $40, $40, $60, 2

; 006: 0x20→0x40
    db $40, $40, $60, 1

; 007: 0x23→0x46
    db $40, $46, $60, 2

; 008: 0x25→0x4A
    db $40, $4A, $60, 1

; 009: 0x1B→0x36
    db $40, $36, $60, 2

; 00A: 0x1E→0x3C
    db $40, $3C, $60, 1

; 00B: 0x1E→0x3C
    db $40, $3C, $60, 2

; 00C: 0x19→0x32
    db $40, $32, $60, 1

; 00D: 0x19→0x32
    db $40, $32, $70, 2

; 00E: 0x1B→0x36
    db $40, $36, $80, 1

; 00F: 0x1F→0x3E
    db $40, $3E, $90, 2

; 010: 0x14→0x28
    db 64, 40, $A0, 1
    db 64, 40, $B0, 1
    db 64, 40, $C0, 1

    db $50

nmi_handler:
    push af
    push hl
    ld hl, mode
    bit 0, (hl)  ; B0==0 -> ISR Enabled, B0==1 -> ISR disabled
    jr z, nmi_handler.1
; here ISR is disabled

    set 1, (hl)  ; ISR pending
; B1==0 -> ISR served 	B1==1 -> ISR pending
    pop hl
    pop af
    retn

nmi_handler.0:    res 1, (hl)  ; ISR served
nmi_handler.1:  ; ISR enabled
    bit 7, (hl)
    jr z, nmi_handler.2  ; B7==0 -> game Mode, 	B7==1 -> intermission mode

; Intermission Mode
    pop hl
    in a, (ctrl_port)
    pop af

    push af
    push bc
    push de
    push hl
    ex af, af'
    exx
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    call time_mgr  ; udate timers
;	CALL	POLLER			; update controllers
    call sub_c952  ; PLAY MUSIC
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    exx
    ex af, af'
    pop hl
    pop de
    pop bc
    pop af
    retn

nmi_handler.2:    pop hl  ; Game Mode
    pop af
    jp nmi


; select 1/2 players
showplyrnum:
    call mynmi_off
    ld de, $1800 + 11 + 32 * 15
    ld hl, plyr1slct
    call myprint
    ld de, $1800 + 11 + 32 * 17
    ld hl, plyr2slct
    call myprint
    jp mynmi_on

; Proper text

plyr1slct:    db "1.PLAYE", "R" or 128
plyr2slct:    db "2.PLAYER", "s" or 128

; select skill 1-4
showskill:
    call mynmi_off
    ld de, $1800 + 11 + 32 * 13
    ld hl, skill1
    call myprint
    ld de, $1800 + 11 + 32 * 15
    ld hl, skill2
    call myprint
    ld de, $1800 + 11 + 32 * 17
    ld hl, skill3
    call myprint
    ld de, $1800 + 11 + 32 * 19
    ld hl, skill4
    call myprint
    jp mynmi_on

skill1:    db "1.EAS", "Y" or 128
skill2:    db "2.ADVANCE", "D" or 128
skill3:    db "3.ARCADE", " " or 128  ; " " needed to remove the S from "PLAYERS"
skill4:    db "4.PR", "O" or 128

; Select  Number of Players and Skill

get_game_options:
    call showplyrnum  ; Show 1 or 2 Players
get_game_options.plyrnumwait:
    call poller
    ld a, (keyboard_p1)
    dec a  ; 0-1	valid range
    cp 2
    jr c, get_game_options.setplyrnum
    ld a, (keyboard_p2)
    dec a
    cp 2
    jr nc, get_game_options.plyrnumwait
get_game_options.setplyrnum:
    push af
    call play_coin_insert_sfx
    pop af
    ld hl, gamecontrol
    res 0, (hl)
    dec a  ; If A==1 -> SET 2 players
    jr nz, get_game_options.oneplyr
    set 0, (hl)
get_game_options.oneplyr:

get_game_options.waitkeyrelease:
    call poller
    ld a, (keyboard_p1)
    cp 15
    jr nz, get_game_options.waitkeyrelease
    ld a, (keyboard_p2)
    cp 15
    jr nz, get_game_options.waitkeyrelease

    call showskill  ; Show Select skill 1-4
get_game_options.skillwait:
    call poller
    ld a, (keyboard_p1)
    dec a  ; 0-3 valid range
    cp 4
    jr c, get_game_options.setskill
    ld a, (keyboard_p2)
    dec a
    cp 4
    jr nc, get_game_options.skillwait
get_game_options.setskill:
    push af
    call play_coin_insert_sfx
    pop af
    inc a  ; The game is expecting 1-4
    ld (skilllevel), a
    ret

strinsertcoin:    db "INSERT COIN", " " or 128

cvb_animatedlogo:
    ld hl, mode
    set 7, (hl)  ; switch to intermission  mode

    call mymode2
    call mydisscr
    call cvb_mycls

    ld de, $0000
    ld hl, cvb_tileset
    call unpack
    ld de, $1800
    ld hl, cvb_pnt
    call unpack
; LOAD ARCADE FONTS
    ld de, $0000 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack

    ld hl, cvb_colorset0
    call nxtfrm

    call mynmi_off
    ld hl, strinsertcoin
    ld de, $1800 + 23 * 32
    call myprint
    call mynmi_on

    ld hl, $1B00  ; needed (some times) to remove all sprites 
    ld a, 208  ; for hacked Colecovision Bios
    call mynmi_off
    call mywrtvrm
    call mynmi_on


    call myenascr
;
    call get_game_options
;
    ld hl, cvb_colorset1
    call nxtfrm
    ld hl, cvb_colorset2
    call nxtfrm
    ld hl, cvb_colorset3
    call nxtfrm
    ld hl, cvb_colorset4
    call nxtfrm
    ld hl, cvb_colorset5
    call nxtfrm
    ld hl, cvb_colorset6
    call nxtfrm
;
;	FOR T=0 TO 10
    ld b, 10
cvb_animatedlogo.mynext:
    push bc

    ld hl, cvb_colorset7
    call nxtfrm
    ld hl, cvb_colorset8
    call nxtfrm
    ld hl, cvb_colorset9
    call nxtfrm
    ld hl, cvb_colorset10
    call nxtfrm
    ld hl, cvb_colorset11
    call nxtfrm
    ld hl, cvb_colorset12
    call nxtfrm

;	NEXT
    pop bc
    djnz cvb_animatedlogo.mynext

    call mydisscr

    ld hl, sat  ; remove sprites in the new position of the SAT
    ld a, 208
    call mynmi_off
    call mywrtvrm
    call mynmi_on


    ld hl, mode
    res 7, (hl)  ; switch to game mode

    ret

nxtfrm:
    halt
    halt
    halt
    halt
    ld bc, 23
    ld de, $2000
    call mynmi_off
    call myldirvm

    ld hl, $2000 + 6 * 32 / 8
    ld de, 8
    ld a, $F1
    call fill_vram

    jp mynmi_on



; MAKE SURE TO BE IN INTERMISSION MODE BEFORE CALLING

cvb_extrascreen:
    call mymode1
    call mydisscr
    call cvb_mycls

    ld de, $2000  ; Mirror mode for colors
    ld hl, cvb_image_color
    call unpack

    ld de, $0000  ; Normal mode for patterns
    ld hl, cvb_image_char
    call unpack
    ld de, $0800
    ld hl, cvb_image_char
    call unpack
    ld de, $1000
    ld hl, cvb_image_char
    call unpack

    ld de, $2800
    ld hl, cvb_image_sprites
    call unpack  ; 22 sprites

    ld hl, $1800
    ld de, 3 * 256
    ld a, 1  ; black tile
    call mynmi_off
    call fill_vram
    call mynmi_on

    ld hl, cvb_image_pattern
    ld de, $1800 + 5
    ld bc, 24 * 256 + 22
    ld a, c
    call cpyblk_mxn

    ld bc, 128
    ld de, $1B00
    ld hl, cvb_sprite_overlay
    call mynmi_off
    call myldirvm
    call mynmi_on
    jp myenascr

cvb_extrascreen_frm1:
    ld hl, cvb_image_pattern_fr1
    ld de, $1800 + 13 + 17 * 32
    ld bc, 5 * 256 + 4
    ld a, c
    call cpyblk_mxn
    call mynmi_off
    ld a, 2 + 17 * 8
    ld hl, $1B00  ; SET in place sprite 0
    call mywrtvrm
    jp mynmi_on


cvb_extrascreen_frm2:
    ld hl, cvb_image_pattern_fr2
    ld de, $1800 + 13 + 17 * 32
    ld bc, 5 * 256 + 4
    ld a, c
    call cpyblk_mxn
    call mynmi_off
    ld a, 209
    ld hl, $1B00  ; remove sprite 0
    call mywrtvrm
    jp mynmi_on

;% place here the other intermission each 10xN levels
wonderful:
    jp congratulation

intermission:
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; Show the intermission screen 
;
    ld hl, mode
    set 7, (hl)  ; switch to intermission  mode

;     call cvb_intermission  ; -mdl

cvb_intermission:
    call mymode1
    call mydisscr
    call cvb_mycls

    ld hl, $2000 + 6 * 32 * 8
    ld de, 32 * 8 * 2
    ld a, $F0
    call fill_vram

; LOAD ARCADE FONTS
    ld de, $0000 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack
    ld de, $0800 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack
    ld de, $1000 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack

    ld de, $0000
    ld hl, intermission_char
    call unpack
    ld de, $0800
    ld hl, intermission_char
    call unpack
    ld de, $1000
    ld hl, intermission_char
    call unpack

    ld de, $2000
    ld hl, intermission_color
    call unpack

    ld de, $2800
    ld hl, intermission_sprites
    call unpack

    ld de, $1800 + 12 + 32 * 10
    ld hl, verygood
    call myprint

    call myenascr

;     ret  ; -mdl
    call initialize_the_sound
    call play_very_good_tune

    ld hl, $0200  ; music duration
    xor a
    call request_signal

    push af  ; wait for music to finish
intermission.1:
    call cvb_intermission_frm1  ; animate the monsters
    call wait8
    call cvb_intermission_frm2
    call wait8
    pop af
    push af
    call test_signal
    and a
    jr z, intermission.1
    pop af

    call mydisscr

    ld hl, sprite_name_table
    ld b, $50  ; remove 20 sprites
intermission.2:
    ld (hl), 0
    inc hl
    djnz intermission.2

    ld hl, $0000  ; do not delete player data in VRAM
    ld de, $3000
    xor a  ; fill with space
    call fill_vram

    ld hl, mode
    res 7, (hl)  ; switch to game mode

    call init_vram
    ld hl, gamecontrol
    set 7, (hl)
intermission.3:
    bit 7, (hl)
    jr nz, intermission.3
    ret

verygood:    db "VERY GOOD !", "!" or 128

cvb_intermission_frm1:
    ld bc, 41
    ld de, $1B00
    ld hl, cvb_sp1
    call mynmi_off
    call myldirvm
    call mynmi_on

    ld bc, 5 * 256 + 14
    ld de, $1800 + 10 + 13 * 32
    ld hl, cvb_fr1
    ld a, 14
    jp cpyblk_mxn

cvb_intermission_frm2:
    ld bc, 41
    ld de, $1B00
    ld hl, cvb_sp2
    call mynmi_off
    call myldirvm
    call mynmi_on

    ld bc, 5 * 256 + 14
    ld de, $1800 + 10 + 13 * 32
    ld hl, cvb_fr2
    ld a, 14
    jp cpyblk_mxn


; 61 tiles - compressed
intermission_char:

    db $3F, $00, $03, $00, $03, $30, $78, $78  ;	DB $3f,$00,$03,$00,$03,$30,$78,$78
    db $30, $00, $07, $FF, $06, $66, $60, $7F  ;	DB $30,$00,$07,$ff,$06,$66,$60,$7f
    db $06, $00, $EF, $00, $C0, $C0, $C2, $18  ;	DB $06,$00,$ef,$00,$c0,$c0,$c2,$18
    db $FF, $FF, $68, $1F, $1B, $80, $3C, $C0  ;	DB $ff,$ff,$68,$1f,$1b,$80,$3c,$c0
    db $80, $24, $00, $F9, $EF, $06, $0F, $F9  ;	DB $80,$24,$00,$f9,$ef,$06,$0f,$f9
    db $F9, $03, $E0, $04, $F0, $7F, $F8, $F0  ;	DB $f9,$03,$e0,$04,$f0,$7f,$f8,$f0
    db $E0, $00, $A0, $20, $80, $20, $04, $70  ;	DB $e0,$00,$a0,$20,$80,$20,$04,$70
    db $30, $18, $38, $70, $38, $1D, $07, $0F  ;	DB $30,$18,$38,$70,$38,$1d,$07,$0f
    db $1F, $74, $3F, $41, $00, $19, $00, $04  ;	DB $1f,$74,$3f,$41,$00,$19,$00,$04
    db $0E, $3C, $60, $BF, $3F, $7F, $98, $70  ;	DB $0e,$3c,$60,$bf,$3f,$7f,$98,$70
    db $26, $3D, $E0, $F8, $FC, $71, $FC, $1F  ;	DB $26,$3d,$e0,$f8,$fc,$71,$fc,$1f
    db $01, $03, $04, $21, $03, $F7, $CF, $1F  ;	DB $01,$03,$04,$21,$03,$f7,$cf,$1f
    db $17, $7F, $1C, $FF, $FC, $FF, $00, $3E  ;	DB $17,$7f,$1c,$ff,$fc,$ff,$00,$1e
    db $62, $F0, $5B, $E0, $4D, $00, $F0, $F8  ;	DB $62,$e0,$5b,$e0,$4d,$00,$f0,$f8
    db $0C, $0E, $0F, $0F, $07, $03, $82, $23  ;	DB $0c,$0e,$0f,$0f,$07,$03,$82,$23
    db $F8, $78, $38, $9F, $7A, $08, $7F, $07  ;	DB $f8,$78,$38,$9f,$7a,$08,$7f,$07
    db $7F, $C0, $26, $0C, $20, $00, $71, $21  ;	DB $7f,$c0,$26,$0c,$20,$00,$71,$21
    db $30, $E0, $E3, $C3, $02, $C6, $3B, $F7  ;	DB $30,$e0,$e3,$c3,$02,$c6,$3b,$f7
    db $10, $33, $8D, $00, $03, $FF, $80, $00  ;	DB $10,$33,$8d,$00,$03,$ff,$80,$00
    db $C7, $03, $03, $01, $01, $FF, $9C, $02  ;	DB $c7,$03,$03,$01,$01,$ff,$9c,$02
    db $FE, $3F, $60, $03, $FF, $E0, $1F, $C1  ;	DB $fe,$3f,$60,$03,$ff,$e0,$1f,$c1
    db $83, $02, $0A, $1D, $F1, $01, $00, $2A  ;	DB $83,$02,$19,$1d,$f1,$1a,$28,$2a
    db $58, $F9, $50, $54, $FF, $01, $7E, $FF  ;	DB $f9,$50,$43,$f0,$ff,$01,$7e,$ff
    db $CF, $CF, $78, $7C, $7C, $4B, $7C, $00  ;	DB $cf,$cf,$78,$7c,$7c,$4b,$7c,$00
    db $F8, $16, $88, $9D, $00, $40, $E0, $04  ;	DB $f8,$29,$88,$9d,$00,$40,$e0,$04
    db $40, $0C, $0C, $FF, $C0, $00, $70, $11  ;	DB $40,$0c,$0c,$ff,$c0,$00,$70,$11
    db $1C, $FC, $60, $26, $60, $CF, $5A, $29  ;	DB $1c,$fc,$60,$26,$60,$cf,$16,$c6
    db $74, $16, $B4, $60, $3C, $1E, $1F, $5E  ;	DB $74,$85,$b4,$60,$8f,$1e,$1f,$14
    db $64, $EF, $47, $AE, $64, $51, $28, $80  ;	DB $5e,$ef,$2f,$00,$03,$c8,$51,$28
    db $12, $80, $FE, $FE, $40, $E1, $55, $B1  ;	DB $80,$80,$25,$fe,$fe,$40,$e1,$55
    db $5D, $41, $F9, $18, $B3, $56, $87, $02  ;	DB $60,$5d,$41,$f9,$ff,$3e,$c0,$56
    db $CF, $1C, $3F, $BF, $BF, $1F, $B1, $02  ;	DB $87,$cf,$1c,$3f,$10,$bf,$bf,$1f
    db $81, $E0, $C0, $F0, $DD, $15, $FE, $27  ;	DB $b1,$81,$50,$e0,$67,$dd,$fe,$a2
    db $6E, $20, $BE, $08, $3E, $1F, $07, $01  ;	DB $27,$c3,$be,$41,$08,$3e,$1f,$07
    db $AC, $45, $16, $00, $68, $E0, $B3, $81  ;	DB $01,$58,$45,$16,$00,$e0,$d1,$b3
    db $F0, $FC, $1F, $F3, $F1, $07, $10, $A9  ;	DB $02,$f0,$fc,$1f,$f3,$f1,$07,$a9
    db $09, $CF, $C7, $C7, $30, $C3, $40, $64  ;	DB $20,$09,$cf,$c7,$c7,$c3,$60,$40
    db $BE, $BC, $31, $18, $10, $5F, $FE, $37  ;	DB $64,$be,$bc,$18,$62,$10,$5f,$fe
    db $BE, $78, $57, $21, $55, $56, $09, $7F  ;	DB $be,$6e,$78,$21,$ae,$55,$56,$7f
    db $38, $7C, $FE, $1C, $0F, $55, $0A, $66  ;	DB $12,$38,$7c,$fe,$1c,$0f,$0a,$aa
    db $6C, $51, $03, $00, $FD, $FC, $6C, $60  ;	DB $66,$6c,$51,$00,$06,$fd,$fc,$6c
    db $60, $30, $17, $B6, $31, $7F, $E0, $EE  ;	DB $60,$60,$60,$17,$b6,$7f,$63,$e0
    db $D6, $7F, $3B, $3C, $7C, $7F, $C1, $CE  ;	DB $ee,$ac,$7f,$3c,$77,$7c,$7f,$83
    db $1E, $92, $7A, $7E, $F6, $7C, $28, $7F  ;	DB $ce,$1e,$24,$7a,$7e,$f6,$7c,$7f
    db $78, $83, $18, $18, $D6, $4F, $52, $FE  ;	DB $51,$78,$83,$18,$18,$ac,$4f,$fe
    db $15, $C3, $1F, $8A, $8A, $54, $09, $67  ;	DB $a5,$15,$c3,$1f,$14,$8a,$54,$09
    db $8C, $24, $FF, $FF, $FF, $FE  ;	DB $8c,$cf,$24,$ff,$ff,$ff,$fc

intermission_color:
    db $3F, $F1, $03, $00, $81, $C8, $C8, $C1  ;	DB $3f,$f1,$03,$00,$81,$c8,$c8,$c1
    db $C1, $96, $07, $F8, $00, $55, $03, $07  ;	DB $c1,$96,$07,$f8,$00,$55,$03,$07
    db $00, $07, $6C, $14, $1B, $81, $78, $C1  ;	DB $00,$07,$6c,$14,$1b,$81,$78,$c1
    db $25, $FC, $B8, $1C, $28, $FC, $FC, $B6  ;	DB $25,$fc,$b8,$1c,$28,$fc,$fc,$b6
    db $2C, $00, $6D, $81, $1F, $F3, $06, $81  ;	DB $2c,$00,$6d,$81,$1f,$f3,$06,$81
    db $61, $06, $B8, $F8, $21, $2B, $00, $82  ;	DB $61,$06,$b8,$f8,$21,$2b,$00,$82
    db $00, $07, $CF, $16, $A7, $1F, $48, $C8  ;	DB $00,$07,$cf,$16,$a7,$1f,$48,$c8
    db $7C, $00, $3D, $FC, $BE, $14, $09, $78  ;	DB $7c,$00,$3d,$fc,$be,$14,$09,$78
    db $FC, $60, $FC, $AA, $02, $00, $25, $60  ;	DB $fc,$60,$fc,$aa,$02,$00,$25,$60
    db $CE, $09, $8A, $3C, $9D, $3E, $00, $7D  ;	DB $ce,$09,$8a,$3c,$9d,$3e,$00,$7d
    db $F8, $07, $D9, $00, $05, $F3, $08, $81  ;	DB $f8,$07,$d9,$00,$05,$f3,$08,$81
    db $33, $54, $16, $2E, $35, $39, $00, $EB  ;	DB $33,$54,$16,$b4,$58,$60,$eb,$4b
    db $4B, $46, $EB, $68, $00, $E7, $3F, $FC  ;	DB $46,$eb,$68,$00,$e7,$3f,$fc,$99
    db $99, $37, $19, $A6, $5A, $7B, $4F, $6C  ;	DB $37,$19,$a6,$5a,$7b,$4f,$6c,$60
    db $60, $00, $82, $EB, $56, $28, $6E, $67  ;	DB $00,$82,$d3,$56,$36,$1c,$05,$ee
    db $10, $CE, $48, $BD, $2E, $51, $53, $AF  ;	DB $58,$42,$ce,$5c,$53,$c7,$5f,$fc
    db $5F, $67, $3E, $00, $98, $78, $D3, $AD  ;	DB $9f,$00,$3c,$98,$d3,$56,$0c,$00
    db $0C, $00, $1D, $B8, $1E, $97, $58, $C9  ;	DB $8e,$b8,$8f,$97,$64,$58,$07,$84
    db $07, $84, $C6, $8A, $09, $C7, $8C, $4F  ;	DB $e3,$8a,$63,$09,$8c,$a7,$09,$8c
    db $09, $19, $06, $21, $25, $A7, $17, $6C  ;	DB $06,$21,$25,$d3,$17,$b6,$55,$f7
    db $55, $F7, $6C, $80, $E7, $46, $DA, $52  ;	DB $36,$80,$73,$46,$ed,$52,$43,$97
    db $86, $97, $5E, $5B, $17, $1F, $98, $DF  ;	DB $2f,$5b,$17,$0f,$98,$ef,$7f,$b6
    db $7F, $6C, $27, $E5, $6D, $2F, $B5, $47  ;	DB $27,$e5,$36,$2f,$da,$47,$22,$d3
    db $22, $A7, $17, $9F, $4F, $FF, $FF, $FF  ;	DB $17,$cf,$4f,$ff,$ff,$ff,$fc
    db $F8  ;

intermission_sprites:
    db $26, $C8, $86, $00, $B0, $00, $F8, $F0
    db $F0, $E0, $06, $C0, $E0, $E0, $F0, $80
    db $0B, $F8, $00, $1C, $0C, $04, $06, $38
    db $70, $78, $11, $07, $0C, $00, $1C, $38
    db $30, $38, $BD, $FD, $01, $72, $D9, $28
    db $80, $A1, $26, $80, $80, $6F, $07, $03
    db $00, $72, $FF, $F0, $30, $06, $59, $0E
    db $3E, $1F, $02, $02, $01, $5C, $0C, $2C
    db $2B, $F0, $8F, $58, $C0, $00, $C0, $00
    db $10, $00, $60, $00, $7C, $BE, $0C, $7C
    db $F8, $08, $E0, $00, $2B, $98, $08, $66
    db $1A, $F2, $2C, $3D, $F5, $9C, $00, $80
    db $03, $77, $8D, $AB, $D0, $1C, $78, $F8
    db $C1, $04, $3C, $7C, $FC, $A8, $10, $01
    db $73, $01, $04, $02, $DB, $25, $8F, $FF
    db $70, $00, $83, $00, $7F, $C3, $6A, $12
    db $AB, $30, $BF, $C2, $0C, $39, $00, $17
    db $B0, $A7, $03, $77, $0F, $91, $2D, $7B
    db $00, $13, $4A, $3B, $DA, $8C, $0B, $D4
    db $42, $63, $CE, $03, $DE, $B7, $7B, $F9
    db $BF, $72, $C0, $73, $40, $00, $AF, $05
    db $56, $C7, $1A, $1C, $FC, $BF, $FF, $FF
    db $FF, $FF, $E0

cvb_sp1:
    db 64 + 41, 80, 0, 1
    db 64 + 41, 97, 4, 15
    db 64 + 46, 92, 8, 8
    db 64 + 48, 160, 12, 1
    db 64 + 57, 88, 16, 8
    db 64 + 42, 88, 20, 12
    db 64 + 62, 95, 24, 15
    db 64 + 56, 161, 28, 8
    db 64 + 58, 112, 32, 1
    db 64 + 60, 80, 36, 1
    db 208
cvb_fr1:
    db $01, $02, $03, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $06, $07, $08, $09, $0A, $0B, $0C, $00, $00, $0D, $0E, $0F, $10
    db $11, $12, $13, $14, $15, $16, $17, $18, $00, $00, $19, $1A, $1B, $1C
    db $1D, $1E, $1F, $20, $21, $22, $23, $24, $00, $00, $25, $26, $27, $28
    db $29, $2A, $2B, $00, $2C, $2D, $2E, $2F, $00, $00, $30, $31, $32, $33

cvb_sp2:
    db 105, 80, 40, 1
    db 105, 97, 44, 15
    db 110, 92, 48, 8
    db 112, 160, 52, 1
    db 121, 85, 56, 8
    db 119, 81, 60, 12
    db 126, 95, 64, 15
    db 124, 166, 68, 12
    db 122, 112, 72, 1
    db 208
cvb_fr2:
    db $01, $02, $03, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $06, $07, $08, $09, $0A, $0B, $0C, $00, $00, $0D, $0E, $0F, $10
    db $11, $12, $13, $14, $15, $16, $17, $18, $00, $00, $19, $1A, $1B, $1C
    db $34, $1E, $1F, $20, $21, $22, $23, $24, $00, $00, $35, $36, $37, $38
    db $39, $2A, $2B, $00, $2C, $2D, $2E, $2F, $00, $00, $3A, $3B, $3C, $00


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

congratulation:
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; Show the congratulation screen 
;
    ld hl, mode
    set 7, (hl)  ; switch to intermission  mode

;     call cvb_congratulation  ; -mdl

cvb_congratulation:
    call mymode1
    call mydisscr
    call cvb_mycls

    ld hl, $2000 + 6 * 32 * 8
    ld de, 32 * 2 * 8
    ld a, $F0
    call fill_vram
; LOAD ARCADE FONTS
    ld de, $0000 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack
    ld de, $0800 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack
    ld de, $1000 + 8 * $00D7  ; start tiles here
    ld hl, arcadefonts
    call unpack

    ld de, $0000
    ld hl, congratulation_char
    call unpack
    ld de, $0800
    ld hl, congratulation_char
    call unpack
    ld de, $1000
    ld hl, congratulation_char
    call unpack

    ld de, $2000
    ld hl, congratulation_color
    call unpack

    ld de, $2800
    ld hl, congratulation_sprites
    call unpack

    ld bc, 4 * 256 + 21
    ld de, $1800 + 17 * 32 + 7
    ld hl, cvb_universal
    ld a, c
    call cpyblk_mxn

    ld bc, 10 * 256 + 7
    ld de, $1800 + 1
    ld hl, cvb_congratulation_pattern
    ld a, c
    call cpyblk_mxn

    ld bc, 4 * 10 + 1
    ld de, $1B00
    ld hl, cvb_fsb
    call mynmi_off
    call myldirvm
    call mynmi_on


    ld de, $1800 + 10 + 32 * 10
    ld hl, congratulations
    call myprint

    call myenascr

;     ret  ; -mdl
    call initialize_the_sound
    call play_very_good_tune

    ld hl, $0200  ; music duration
    xor a
    call request_signal

    push af  ; wait for music to finish
congratulation.1:
    call cvb_congratulation_frm0  ; animate the diamond
    call wait8
    call cvb_congratulation_frm1
    call wait8
    call cvb_congratulation_frm2
    call wait8
    pop af
    push af
    call test_signal
    and a
    jr z, congratulation.1
    pop af

    call mydisscr

    ld hl, sprite_name_table
    ld b, $50  ; remove 20 sprites
congratulation.2:
    ld (hl), 0
    inc hl
    djnz congratulation.2

    ld hl, $0000
    ld de, $3000  ; do not delete the game data
    xor a  ; fill with space
    call fill_vram

    ld hl, mode
    res 7, (hl)  ; switch to game mode

    call init_vram
    ld hl, gamecontrol
    set 7, (hl)
congratulation.3:
    bit 7, (hl)
    jr nz, congratulation.3
    ret

congratulations:    db "CONGRATULATIONS !", "!" or 128

cvb_congratulation_frm0:
    ld bc, 4 * 5 + 1
    ld de, $1B00 + 10 * 4
    ld hl, cvb_fs0
    call mynmi_off
    call myldirvm
    call mynmi_on

    ld bc, 3 * 256 + 4
    ld de, $1800 + 10 * 32
    ld hl, cvb_frc0
    ld a, c
    jp cpyblk_mxn

cvb_congratulation_frm1:
    ld bc, 4 * 5 + 1
    ld de, $1B00 + 10 * 4
    ld hl, cvb_fs1
    call mynmi_off
    call myldirvm
    call mynmi_on

    ld bc, 3 * 256 + 4
    ld de, $1800 + 10 * 32
    ld hl, cvb_frc1
    ld a, c
    jp cpyblk_mxn

cvb_congratulation_frm2:
    ld bc, 4 * 5 + 1
    ld de, $1B00 + 10 * 4
    ld hl, cvb_fs2
    call mynmi_off
    call myldirvm
    call mynmi_on

    ld bc, 3 * 256 + 4
    ld de, $1800 + 10 * 32
    ld hl, cvb_frc2
    ld a, c
    jp cpyblk_mxn

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cvb_fs0:
    db 79, 9, 40, 2
    db 81, 1, 44, 3
    db 83, 18, 48, 3
    db 86, 8, 52, 1
    db 85, 8, 56, 2
    db 208
cvb_fs1:
    db 119 - 40, 9, 60, 3
    db 121 - 40, 1, 64, 4
    db 123 - 40, 11, 68, 3
    db 126 - 40, 12, 72, 2
    db 125 - 40, 8, 76, 1
    db 208
cvb_fs2:
    db 159 - 80, 7, 80, 3
    db 161 - 80, 21, 84, 4
    db 163 - 80, 5, 88, 3
    db 166 - 80, 8, 92, 1
    db 165 - 80, 8, 96, 2
    db 208

cvb_frc0:
    db $33, $34, $35, $36
    db $37, $38, $39, $3A
    db $00, $3B, $3C, $00
cvb_frc1:
    db $3D, $3E, $3F, $40
    db $41, $42, $43, $3A
    db $00, $44, $45, $00
cvb_frc2:
    db $6D, $6E, $3E, $6F
    db $37, $42, $43, $75
    db $00, $76, $77, $00


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cvb_universal:
    db $46, $47, $48, $49, $4A, $46, $47, $48, $4B, $4C, $46, $47, $4D, $4E, $4F, $50, $51, $46, $51, $4A, $00
    db $52, $53, $51, $54, $55, $52, $56, $57, $00, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $00, $55, $00
    db $52, $53, $51, $61, $55, $52, $62, $63, $00, $64, $65, $53, $66, $67, $68, $69, $6A, $6B, $00, $55, $6C
    db $70, $71, $48, $72, $4A, $46, $51, $46, $51, $4C, $46, $47, $73, $4B, $74, $71, $47, $48, $4B, $4C, $46

cvb_fsb:
    db 255, 16, 0, 1
    db 15, 8, 4, 1
    db 19, 44, 8, 8
    db 23, 22, 12, 8
    db 32, 16, 16, 1
    db 35, 36, 20, 2
    db 41, 29, 24, 1
    db 47, 18, 28, 15
    db 42, 48, 32, 2
    db 56, 16, 36, 8
    db 208

; Width = 7, height = 10
cvb_congratulation_pattern:
    db $00, $01, $02, $00, $00, $00, $00
    db $03, $04, $05, $00, $00, $00, $00
    db $06, $07, $08, $00, $09, $0A, $00
    db $0B, $0C, $0D, $0E, $0F, $10, $11
    db $00, $12, $13, $14, $15, $16, $17
    db $18, $19, $1A, $1B, $00, $1C, $1D
    db $1E, $1F, $20, $21, $22, $23, $24
    db $25, $26, $27, $28, $29, $2A, $2B
    db $2C, $2D, $2E, $2F, $00, $00, $00
    db $30, $31, $32, $00, $00, $00, $00

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; Start tile = 0. Total_tiles = 120
congratulation_char:
    db $3B, $00, $C3, $00, $01, $03, $07, $45
    db $07, $FC, $00, $A0, $07, $03, $0F, $1F
    db $00, $0C, $18, $19, $C1, $FF, $FF, $FE
    db $FC, $00, $F8, $F8, $F0, $E0, $F8, $7F
    db $7F, $3F, $08, $E3, $C1, $3F, $7F, $00
    db $81, $C3, $A2, $0F, $00, $FC, $FE, $19
    db $21, $C0, $E0, $00, $C0, $C0, $80, $E1
    db $40, $07, $1F, $B1, $07, $20, $70, $41
    db $24, $2B, $1E, $0E, $06, $02, $0C, $39
    db $87, $03, $01, $00, $2C, $1F, $7F, $2B
    db $47, $04, $F8, $00, $C1, $F7, $FC, $37
    db $1F, $14, $07, $7F, $03, $00, $6D, $0F
    db $02, $FF, $7C, $7E, $80, $C0, $E1, $18
    db $C3, $37, $3C, $7C, $04, $00, $78, $03
    db $04, $38, $1C, $4E, $0C, $04, $F0, $56
    db $59, $C0, $5D, $3C, $A5, $38, $47, $88
    db $36, $C0, $25, $0F, $07, $01, $07, $F8
    db $04, $06, $06, $03, $F0, $31, $7E, $78
    db $00, $F0, $F1, $B8, $A0, $4D, $1F, $77
    db $77, $58, $E0, $18, $95, $71, $B1, $66
    db $0D, $43, $6C, $3F, $21, $F0, $9A, $0C
    db $40, $16, $D2, $3F, $0C, $02, $02, $00
    db $27, $05, $AE, $13, $00, $C3, $02, $FB
    db $FB, $71, $20, $08, $19, $8C, $73, $80
    db $00, $00, $51, $7F, $BF, $70, $78, $7C
    db $7F, $C0, $81, $48, $F7, $F3, $E3, $C3
    db $03, $96, $39, $69, $69, $02, $61, $80
    db $33, $30, $10, $E0, $0F, $0F, $80, $DA
    db $3F, $71, $DF, $70, $30, $DF, $FF, $D7
    db $C6, $31, $70, $DB, $37, $02, $FA, $87
    db $CF, $E7, $24, $53, $06, $07, $3E, $70
    db $4B, $0F, $0C, $30, $70, $84, $A0, $31
    db $F1, $C7, $83, $32, $83, $C7, $43, $9A
    db $23, $2E, $00, $80, $71, $F3, $A6, $00
    db $47, $C0, $01, $87, $FD, $FC, $DC, $98
    db $96, $11, $1D, $D1, $16, $C0, $2C, $33
    db $07, $0C, $84, $68, $4C, $95, $C2, $73
    db $1F, $1F, $07, $80, $0E, $60, $70, $40
    db $40, $60, $1F, $AA, $8B, $0E, $8B, $6E
    db $58, $C3, $22, $9D, $15, $64, $0F, $00
    db $1F, $E1, $08, $E3, $1F, $1E, $3C, $90
    db $9C, $BA, $26, $80, $A9, $08, $04, $02
    db $01, $A0, $35, $00, $9F, $BF, $7F, $80
    db $F1, $4F, $F8, $B5, $47, $2B, $F7, $57
    db $0D, $4F, $38, $3C, $1E, $F2, $4F, $00
    db $64, $3C, $17, $47, $03, $84, $47, $06
    db $0C, $08, $47, $40, $3C, $80, $FC, $00
    db $78, $3F, $00, $0F, $F3, $00, $46, $9E
    db $DF, $0F, $C3, $F0, $1E, $00, $C3, $3C
    db $00, $FF, $00, $E7, $E7, $A2, $00, $D8
    db $25, $E7, $17, $FE, $86, $17, $3C, $3C
    db $CF, $4F, $03, $1E, $00, $30, $3C, $00
    db $0C, $00, $E1, $A5, $70, $07, $A1, $38
    db $C0, $9A, $00, $0F, $14, $0E, $0E, $07
    db $26, $8E, $0E, $D5, $15, $47, $14, $D5
    db $E3, $00, $B6, $35, $1A, $90, $5A, $21
    db $17, $09, $84, $C1, $D1, $EE, $CD, $E3
    db $8B, $FF, $3F, $6F, $9D, $F5, $99, $FE
    db $F5, $B6, $21, $EF, $03, $9C, $0C, $18
    db $1C, $AE, $55, $34, $36, $A4, $17, $1B
    db $0E, $44, $9C, $AB, $17, $1B, $41, $6E
    db $61, $27, $AA, $15, $14, $05, $F4, $E9
    db $43, $B0, $DA, $BC, $B3, $2B, $67, $30
    db $2D, $A5, $8C, $5C, $FC, $7C, $18, $D0
    db $94, $D0, $83, $3B, $FE, $FE, $4B, $AB
    db $25, $16, $00, $E8, $CF, $7E, $7E, $8D
    db $0B, $18, $18, $45, $F7, $E0, $B3, $C5
    db $3B, $FA, $34, $85, $70, $AB, $34, $C1
    db $6F, $AE, $11, $00, $B9, $F6, $A5, $46
    db $CF, $C7, $1F, $4D, $D3, $80, $E9, $D7
    db $C0, $B5, $D7, $FF, $FF, $FF, $FF, $80

congratulation_color:
    db $3E, $F1, $F2, $00, $81, $00, $C4, $05
    db $F8, $05, $82, $74, $82, $0F, $09, $F2
    db $4C, $F2, $09, $21, $00, $79, $82, $00
    db $74, $19, $0D, $00, $81, $F9, $30, $21
    db $B6, $07, $66, $11, $00, $DF, $21, $6C
    db $29, $11, $F1, $F3, $3C, $CC, $42, $3F
    db $DB, $24, $EF, $72, $35, $31, $3B, $61
    db $0B, $EB, $71, $1A, $97, $1F, $F2, $63
    db $F7, $00, $D6, $54, $20, $A7, $6B, $76
    db $11, $0D, $AD, $29, $D5, $00, $42, $46
    db $71, $00, $08, $F8, $F8, $F5, $77, $32
    db $5E, $12, $00, $3B, $7F, $81, $1A, $B7
    db $00, $1F, $8A, $8B, $EB, $14, $A6, $57
    db $95, $1B, $CE, $1F, $45, $DB, $3F, $4C
    db $06, $12, $D5, $B9, $6F, $C6, $CB, $5A
    db $2B, $34, $37, $52, $CF, $0F, $F8, $00
    db $31, $31, $73, $41, $00, $43, $D8, $00
    db $32, $32, $AC, $17, $00, $52, $1B, $32
    db $43, $41, $5D, $00, $11, $00, $7D, $19
    db $07, $F1, $17, $42, $42, $A2, $2F, $21
    db $07, $EA, $09, $07, $11, $E2, $BC, $0E
    db $F6, $00, $D4, $2E, $BB, $08, $58, $52
    db $4F, $19, $D4, $07, $BA, $39, $1C, $38
    db $6C, $41, $07, $A1, $FF, $C3, $00, $F1
    db $A1, $77, $E9, $00, $B3, $D7, $6D, $76
    db $1D, $DE, $37, $05, $FB, $4B, $7B, $15
    db $6B, $A5, $55, $BE, $79, $25, $F3, $F7
    db $6C, $32, $F7, $CF, $D9, $8D, $0F, $42
    db $7E, $DD, $3E, $9F, $BE, $CF, $AD, $01
    db $BF, $07, $FF, $FF, $FF, $F0


congratulation_sprites:
    db $3A, $00, $C7, $00, $C0, $00, $F0, $00
    db $07, $0F, $1F, $68, $E0, $15, $80, $70
    db $80, $05, $E0, $F0, $F8, $7F, $FC, $41
    db $23, $00, $0C, $F8, $78, $08, $AA, $3A
    db $14, $08, $00, $06, $37, $60, $40, $94
    db $5D, $C0, $00, $05, $30, $7A, $3D, $39
    db $28, $80, $5C, $80, $F1, $0D, $54, $24
    db $FD, $5F, $E3, $25, $40, $1C, $3A, $E0
    db $57, $0F, $F4, $17, $12, $F0, $FF, $01
    db $04, $01, $00, $EE, $0B, $05, $92, $28
    db $60, $25, $E0, $00, $E5, $0F, $10, $00
    db $18, $03, $20, $94, $09, $38, $01, $38
    db $30, $20, $30, $38, $3A, $00, $5A, $7B
    db $00, $C7, $3B, $2E, $02, $B4, $4A, $E9
    db $57, $3D, $63, $F7, $79, $88, $94, $31
    db $39, $78, $31, $00, $C6, $07, $3E, $FC
    db $1F, $FC, $1A, $FC, $78, $78, $C0, $55
    db $0F, $0F, $02, $02, $07, $4F, $07, $05
    db $01, $80, $3D, $C0, $0C, $1C, $38, $78
    db $F0, $8B, $08, $0E, $06, $18, $5C, $D7
    db $0D, $78, $38, $0E, $06, $03, $03, $1D
    db $E1, $82, $C0, $34, $E3, $68, $94, $EE
    db $8B, $83, $C0, $D9, $FF, $14, $39, $33
    db $37, $9E, $3F, $DE, $21, $0F, $C3, $E3
    db $F1, $F9, $C7, $33, $80, $B0, $9F, $F0
    db $7C, $70, $9F, $73, $B5, $1E, $05, $3C
    db $38, $11, $9F, $75, $3C, $1C, $CE, $C3
    db $A9, $73, $BC, $0D, $01, $13, $E1, $61
    db $61, $3F, $03, $0D, $AF, $88, $CB, $AE
    db $B7, $5F, $39, $87, $6A, $18, $3F, $00
    db $00, $48, $00, $C0, $F6, $0F, $04, $8F
    db $9F, $40, $40, $E0, $D6, $36, $F0, $85
    db $E8, $05, $84, $03, $3F, $3F, $1E, $1E
    db $0C, $0C, $51, $CF, $54, $0E, $C4, $53
    db $1C, $C5, $71, $07, $0A, $87, $0F, $60
    db $C0, $CF, $D8, $D7, $78, $3F, $7B, $D8
    db $65, $E6, $07, $03, $89, $FA, $03, $BD
    db $87, $86, $86, $D6, $BF, $5A, $00, $A3
    db $BF, $6A, $00, $CF, $BF, $FF, $FF, $FF
    db $FE


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mynmi_off:
    push hl
    ld hl, mode
    set 0, (hl)
    pop hl
    ret


cvb_mycls:
    ld bc, $0300
    xor a
    call mynmi_off
    push af
    xor a
    out (ctrl_port), a
    ld a, $18 + $40
    out (ctrl_port), a  ; 	addr $1800
    pop af
    dec bc  ; T-states (normal / M1)
cvb_mycls.1:    out (data_port), a  ; 11 12
    dec bc  ;  6  7
    bit 7, b  ;  8 10
    jp z, cvb_mycls.1  ; 10 11

; 	JP MyNMI_on  ; -mdl

mynmi_on:
    push af
    push hl
    ld hl, mode
    res 0, (hl)
    nop
    bit 1, (hl)
    jp nz, nmi_handler.0
    pop hl
    pop af
    ret


;	HL->ROM
;	DE->VRAM
;	B -> Y size
;	C -> X size
;	A -> source width

cpyblk_mxn:
    call mynmi_off
cpyblk_mxn.1:    push bc
    push af
    push hl
    push de
    ld b, 0
    call myldirvm
    pop hl
    ld bc, 32
    add hl, bc
    ex de, hl
    pop hl
    pop af
    ld c, a
    add hl, bc
    pop bc
    djnz cpyblk_mxn.1
    jp mynmi_on

mymode2:  ; screen 1 no mirroring
    ld hl, mode
    set 7, (hl)  ; intermission mode
    ld bc, $0000
    ld de, $8000  ; $2000 for color table, $0000 for bitmaps.

vdp_chg_mode:
    call mynmi_off
    call mywrtvdp
    ld bc, $A201
    call mywrtvdp
    ld bc, $0602  ; $1800 for pattern table.
    call mywrtvdp
    ld b, d
    ld c, $03  ; for color table.
    call mywrtvdp
    ld b, e
    ld c, $04  ; for bitmap table.
    call mywrtvdp
    ld bc, $3605  ; $1b00 for sprite attribute table.
    call mywrtvdp
    ld bc, $0506  ; $2800 for sprites patterns.
    call mywrtvdp
    ld bc, $0107
; 	JP MYWRTVDP  ; -mdl

; BIOS HELPER CODE
mywrtvdp:  ; write value B in the VDP register C 
    ld a, b
    out (ctrl_port), a
    ld a, c
    or $80
    out (ctrl_port), a
    ret

mymode1:  ; screen 2 with mirror mode for patterns
    ld hl, mode
    set 7, (hl)  ; intermission mode
    ld bc, $0200
    ld de, $9F03  ; $2000 for color table - Mirror Mode, $0000 for bitmaps  - Normal mode
    jp vdp_chg_mode

mydisscr:
    call mynmi_off
    ld a, $A2
    out (ctrl_port), a
    ld a, $81
    out (ctrl_port), a
    jp mynmi_on

myenascr:
    call mynmi_off
    ld a, $E2
    out (ctrl_port), a
    ld a, $81
    out (ctrl_port), a
    jp mynmi_on

myprint:
    ld a, e
    out (ctrl_port), a
    ld a, d
    or $40
    out (ctrl_port), a

myprint.1:    ld a, (hl)
    and $7F
    sub "0"
    cp "9" - "0" + 1
    jr nc, myprint.2  ; not in range 0-9
    add a, 216  ; position of "0" in the tileset
    jr myprint.99
myprint.2:    add a, "0" - "A"
    cp "Z" - "A" + 1
    jr nc, myprint.3  ; not in range A-Z
    add a, 226  ; position of "A" in the tileset
    jr myprint.99
myprint.3:    add a, "A"
    cp " "
    jr nz, myprint.4
    ld a, 215  ; position of " " in the tileset
    jr myprint.99
myprint.4:    cp "!"
    jr nz, myprint.5
    ld a, 255  ; position of "!" in the tileset
    jr myprint.99
myprint.5:    cp "."
    jr nz, myprint.6
    ld a, 254  ; position of "." in the tileset
    jr myprint.99
myprint.6:    cp "-"
    jr nz, myprint.7
    ld a, 253  ; position of "-" in the tileset
    jr myprint.99
myprint.7:    cp ","
    jr nz, myprint.8
    ld a, 252  ; position of "," in the tileset
    jr myprint.99
myprint.8:    ld a, 215  ; any other tile is mapped by " "	
myprint.99:
    out (data_port), a
    ld a, (hl)
    bit 7, a
    ret nz
    inc hl
    jr myprint.1


myinirvm:  ; read from DE (VRAM) to HL (RAM) BC bytes
    ld a, e
    out (ctrl_port), a
    ld a, d
    out (ctrl_port), a
    dec bc
    inc c
    ld a, b
    ld b, c
    inc a
    ld c, data_port
myinirvm.1:
    ini
    jp nz, myinirvm.1
    dec a
    jp nz, myinirvm.1
    ret

myldirvm:
    ld a, e
    out (ctrl_port), a
    ld a, d
    or $40
    out (ctrl_port), a
    dec bc
    inc c
    ld a, b
    ld b, c
    inc a
    ld c, data_port
myldirvm.1:
    outi
    jp nz, myldirvm.1
    dec a
    jp nz, myldirvm.1
    ret

mywrtvrm:
    push af
    ld a, l
    out (ctrl_port), a
    ld a, h
    or $40
    out (ctrl_port), a
    pop af
    out (data_port), a
    ret


;
; Pletter-0.5c decompressor (XL2S Entertainment & Team Bomba)
;
unpack:
; Initialization
    ld a, (hl)
    inc hl
    exx
    ld de, 0
    add a, a
    inc a
    rl e
    add a, a
    rl e
    add a, a
    rl e
    rl e
    ld hl, unpack.modes
    add hl, de
    ld c, (hl)
    inc hl
    ld b, (hl)
    push bc
    pop ix
    ld e, 1
    exx
    ld iy, unpack.loop

; Main depack loop
unpack.literal:
    ex af, af'
    call mynmi_off
    ld a, (hl)
    ex de, hl
    call mywrtvrm
    ex de, hl
    inc hl
    inc de
    call mynmi_on
    ex af, af'
unpack.loop:    add a, a
    call z, unpack.getbit
    jr nc, unpack.literal

; Compressed data
    exx
    ld h, d
    ld l, e
unpack.getlen:    add a, a
    call z, unpack.getbitexx
    jr nc, unpack.lenok
unpack.lus:    add a, a
    call z, unpack.getbitexx
    adc hl, hl
    ret c
    add a, a
    call z, unpack.getbitexx
    jr nc, unpack.lenok
    add a, a
    call z, unpack.getbitexx
    adc hl, hl
    ret c
    add a, a
    call z, unpack.getbitexx
    jr c, unpack.lus
unpack.lenok:    inc hl
    exx
    ld c, (hl)
    inc hl
    ld b, 0
    bit 7, c
    jr z, unpack.offsok
    jp (ix)

unpack.mode6:    add a, a
    call z, unpack.getbit
    rl b
unpack.mode5:    add a, a
    call z, unpack.getbit
    rl b
unpack.mode4:    add a, a
    call z, unpack.getbit
    rl b
unpack.mode3:    add a, a
    call z, unpack.getbit
    rl b
unpack.mode2:    add a, a
    call z, unpack.getbit
    rl b
    add a, a
    call z, unpack.getbit
    jr nc, unpack.offsok
    or a
    inc b
    res 7, c
unpack.offsok:    inc bc
    push hl
    exx
    push hl
    exx
    ld l, e
    ld h, d
    sbc hl, bc
    pop bc
    ex af, af'
unpack.loop2:
    call mynmi_off
;     call myrdvrm  ; -mdl

myrdvrm:
    ld a, l
    out (ctrl_port), a
    ld a, h
    and $3F
    out (ctrl_port), a
    LD a,(ix)			; 21 cycles of delay
    nop  ;  5 cycles of delay
    in a, (data_port)  ; 12 cycles of delay
;     ret  ; -mdl
    ex de, hl
    call mywrtvrm
    ex de, hl  ; 4
    call mynmi_on
    inc hl  ; 6
    inc de  ; 6
    dec bc  ; 6
    ld a, b  ; 4
    or c  ; 4
    jr nz, unpack.loop2  ; 10
    ex af, af'
    pop hl
    jp (iy)

unpack.getbit:    ld a, (hl)
    inc hl
    rla
    ret

unpack.getbitexx:
    exx
    ld a, (hl)
    inc hl
    exx
    rla
    ret

unpack.modes:
    dw unpack.offsok
    dw unpack.mode2
    dw unpack.mode3
    dw unpack.mode4
    dw unpack.mode5
    dw unpack.mode6

;	EXTRA MrDo Intermission Screen - Compressed data
;
;	' Start tile = 0. Total_tiles = 204
; image_char:
cvb_image_char:
    db $3E, $FF, $3C, $00, $00, $00, $F8, $0F
    db $0F, $1F, $0B, $3F, $3F, $1F, $07, $04
    db $63, $0D, $03, $1F, $A8, $04, $0F, $0E
    db $3F, $C3, $18, $0F, $C0, $80, $00, $FF
    db $61, $7E, $06, $C0, $7E, $01, $15, $7C
    db $C6, $82, $82, $C6, $7C, $01, $07, $C2
    db $E2, $B2, $9A, $8E, $86, $C3, $0F, $80
    db $8E, $C2, $00, $17, $FC, $86, $86, $FC
    db $88, $8E, $88, $07, $38, $6C, $20, $FE
    db $82, $8E, $07, $FE, $10, $00, $AD, $07
    db $2D, $9C, $2F, $80, $00, $FE, $CE, $1F
    db $16, $71, $38, $37, $70, $1C, $97, $17
    db $68, $B7, $00, $73, $6A, $00, $01, $8F
    db $00, $03, $03, $16, $15, $F8, $4E, $30
    db $00, $F0, $1A, $7D, $39, $08, $93, $C7
    db $EF, $EF, $07, $83, $39, $4A, $7D, $0A
    db $83, $0F, $05, $F8, $07, $6D, $45, $2C
    db $11, $BB, $07, $1C, $90, $00, $C7, $07
    db $3D, $1D, $4D, $1A, $65, $71, $79, $8F
    db $56, $41, $1E, $07, $7E, $05, $07, $07
    db $FF, $C0, $F8, $01, $E0, $0C, $E0, $F8
    db $E0, $FB, $0A, $00, $E4, $BF, $83, $BF
    db $BF, $80, $68, $9C, $88, $C1, $E3, $E7
    db $C9, $60, $9C, $8F, $F7, $E0, $00, $FF
    db $81, $80, $BC, $00, $80, $81, $BB, $B8
    db $FF, $E3, $C1, $88, $00, $9C, $BE, $80
    db $BE, $FF, $63, $77, $7F, $08, $5D, $49
    db $41, $41, $57, $40, $40, $16, $5E, $73
    db $40, $00, $C1, $3E, $60, $60, $43, $41
    db $C8, $00, $43, $67, $3C, $26, $40, $63
    db $07, $63, $3E, $07, $0F, $0F, $16, $0E
    db $0C, $08, $17, $C4, $CE, $00, $FE, $FC
    db $EF, $75, $0F, $E2, $1E, $89, $E7, $09
    db $3C, $0C, $07, $3B, $AD, $18, $A3, $8E
    db $B1, $34, $0F, $80, $E6, $0E, $46, $1C
    db $B4, $0C, $9A, $A6, $0C, $46, $7F, $49
    db $BF, $9F, $C7, $17, $02, $07, $81, $D1
    db $F0, $03, $00, $78, $FB, $FB, $F3, $E7
    db $EF, $C0, $C0, $03, $E0, $60, $70, $70
    db $38, $B8, $00, $14, $1C, $3E, $BF, $3F
    db $7F, $F8, $00, $F0, $E0, $08, $08, $0F
    db $9F, $CF, $6E, $04, $4E, $DE, $9E, $BE
    db $3E, $A6, $00, $DF, $CF, $C7, $E7, $E7
    db $F3, $FD, $24, $71, $07, $2F, $3F, $1D
    db $7F, $02, $FF, $F0, $F8, $FC, $FC, $F8
    db $04, $D8, $A6, $1A, $30, $78, $7C, $4D
    db $07, $12, $E0, $BE, $76, $AF, $ED, $73
    db $8E, $06, $08, $18, $A9, $A8, $6B, $3B
    db $CF, $DF, $64, $9F, $5D, $00, $B8, $0B
    db $BC, $9D, $DD, $DF, $00, $50, $B8, $63
    db $EF, $D3, $1A, $8D, $09, $4E, $07, $03
    db $01, $CE, $A6, $93, $79, $17, $82, $11
    db $5D, $0F, $35, $46, $D5, $1F, $80, $77
    db $76, $72, $D2, $8F, $FE, $55, $B4, $1C
    db $0B, $79, $F0, $16, $3C, $79, $C1, $07
    db $DA, $28, $AC, $23, $4D, $C0, $FC, $6F
    db $1B, $A0, $09, $89, $7F, $0F, $E0, $06
    db $83, $F1, $F9, $FD, $08, $3C, $1C, $1E
    db $1E, $E5, $FB, $D3, $60, $C1, $90, $0C
    db $75, $1C, $83, $7A, $72, $03, $C0, $FF
    db $F9, $F0, $B9, $6D, $73, $3F, $38, $BB
    db $45, $38, $01, $18, $90, $D0, $D0, $21
    db $92, $D0, $08, $0B, $F0, $C0, $07, $24
    db $C1, $80, $D3, $FD, $FB, $9D, $B0, $00
    db $79, $1F, $0F, $99, $00, $07, $72, $C7
    db $36, $FE, $03, $5A, $50, $76, $96, $AC
    db $D4, $E7, $CD, $EF, $58, $D3, $C0, $F6
    db $2A, $84, $B7, $4F, $22, $01, $62, $E2
    db $E2, $F2, $F2, $F0, $7C, $40, $FD, $81
    db $C1, $C4, $C7, $0F, $E3, $9E, $27, $64
    db $92, $6A, $29, $39, $00, $AB, $5E, $03
    db $2D, $CC, $4F, $1F, $0C, $C0, $C1, $F1
    db $81, $FC, $A7, $72, $90, $80, $BB, $40
    db $88, $9E, $58, $0F, $72, $68, $2B, $E3
    db $C6, $12, $FF, $0E, $1C, $CA, $D1, $7C
    db $B0, $CF, $AF, $9C, $A1, $A0, $78, $FB
    db $4D, $DD, $FD, $02, $1C, $0E, $06, $F1
    db $F0, $E4, $78, $00, $C7, $B0, $74, $F0
    db $00, $D2, $11, $50, $78, $C0, $34, $00
    db $74, $5E, $53, $3F, $00, $74, $1F, $E7
    db $92, $8D, $AB, $95, $D9, $81, $59, $E0
    db $71, $9F, $F1, $F3, $0B, $F3, $E3, $E3
    db $C3, $00, $34, $1B, $00, $2F, $11, $05
    db $CE, $34, $36, $E0, $08, $18, $19, $8A
    db $08, $30, $60, $40, $C0, $C7, $30, $E3
    db $E7, $81, $15, $07, $E3, $E0, $5A, $94
    db $60, $4E, $0C, $7F, $3F, $F9, $51, $06
    db $A1, $00, $0E, $0C, $7D, $DE, $00, $18
    db $3F, $F8, $78, $00, $38, $18, $3C, $3C
    db $74, $00, $70, $5D, $30, $00, $FC, $F7
    db $00, $D7, $2F, $A4, $11, $90, $50, $7F
    db $18, $61, $B4, $30, $78, $79, $33, $0C
    db $9D, $8F, $F4, $48, $F0, $70, $AB, $43
    db $E7, $00, $E3, $C1, $C1, $1D, $D9, $34
    db $00, $EF, $6C, $0E, $04, $C8, $C9, $F9
    db $40, $00, $60, $38, $BF, $FF, $DF, $CF
    db $CF, $03, $27, $0F, $7F, $1F, $8F, $7C
    db $73, $4D, $60, $15, $F0, $18, $18, $62
    db $00, $37, $8C, $71, $75, $00, $E7, $DB
    db $00, $5A, $B0, $20, $E5, $03, $EF, $8F
    db $C7, $C3, $09, $E1, $C1, $7F, $1E, $55
    db $7F, $18, $66, $3F, $E0, $CD, $16, $1C
    db $08, $9C, $9F, $4B, $9F, $16, $70, $67
    db $97, $92, $E0, $7C, $F5, $CA, $56, $15
    db $87, $F0, $64, $60, $E4, $83, $C8, $07
    db $D0, $EB, $BE, $65, $AE, $E3, $4D, $04
    db $58, $78, $1D, $E7, $3C, $84, $B3, $02
    db $3E, $0C, $04, $FC, $7D, $9D, $2D, $C0
    db $20, $67, $2B, $68, $1F, $23, $70, $F8
    db $78, $B0, $F6, $2B, $C6, $40, $70, $CA
    db $44, $E3, $C8, $00, $C7, $33, $E0, $F0
    db $0B, $A9, $36, $04, $F8, $3A, $63, $01
    db $3A, $AC, $6C, $59, $B8, $B8, $F5, $8B
    db $C8, $35, $1D, $5F, $01, $22, $60, $C3
    db $3C, $60, $F8, $EC, $C4, $48, $13, $D3
    db $70, $78, $30, $64, $FF, $D8, $C0, $D8
    db $48, $E0, $F8, $4B, $E0, $44, $F9, $5C
    db $02, $26, $81, $81, $83, $C7, $19, $8D
    db $92, $1C, $F7, $AD, $81, $3C, $7E, $7E
    db $3C, $18, $8B, $06, $3C, $05, $BE, $F7
    db $71, $B4, $34, $FC, $51, $1C, $F1, $55
    db $72, $13, $08, $D7, $4E, $02, $01, $96
    db $09, $40, $E0, $37, $D8, $C5, $BB, $12
    db $07, $77, $EF, $E7, $1F, $0F, $C5, $B6
    db $48, $DE, $88, $C7, $D4, $DD, $B3, $72
    db $7C, $48, $D1, $81, $FE, $7E, $3E, $1C
    db $FC, $04, $57, $A6, $31, $5C, $A6, $61
    db $D0, $BA, $7D, $26, $9C, $B4, $C0, $3E
    db $98, $F6, $97, $11, $F8, $EF, $37, $AC
    db $73, $79, $67, $17, $32, $30, $E0, $00
    db $35, $FF, $FF, $FF, $FF, $C0
;
; image_color:
cvb_image_color:
    db $5E, $31, $3C, $00, $F1, $00, $78, $51
    db $00, $B3, $F3, $00, $63, $1D, $83, $83
    db $40, $04, $F8, $F8, $F1, $B3, $0C, $B8
    db $B8, $83, $F3, $00, $34, $51, $B5, $00
    db $6B, $51, $FD, $07, $7B, $61, $66, $00
    db $6A, $83, $81, $BB, $73, $0B, $CF, $15
    db $27, $0F, $17, $51, $BB, $3F, $00, $A5
    db $B6, $07, $DD, $17, $00, $77, $6B, $0A
    db $76, $74, $0A, $EA, $79, $50, $00, $F7
    db $08, $B7, $15, $7B, $17, $3C, $00, $F3
    db $00, $F8, $EF, $47, $D6, $63, $EF, $7C
    db $11, $8F, $B7, $85, $F7, $07, $F2, $8A
    db $F1, $6E, $C5, $E3, $07, $C1, $C6, $0E
    db $C5, $D7, $0D, $00, $B0, $95, $3E, $85
    db $85, $07, $4D, $C5, $00, $C1, $EE, $00
    db $2D, $FB, $07, $F3, $17, $97, $2F, $81
    db $31, $7D, $00, $07, $E7, $47, $7A, $07
    db $4F, $00, $AF, $F8, $85, $D9, $03, $69
    db $DE, $6C, $B3, $00, $CA, $3C, $00, $07
    db $13, $A1, $CA, $81, $00, $C8, $B1, $00
    db $07, $A8, $8F, $00, $A1, $1D, $07, $A8
    db $7B, $DD, $00, $55, $DF, $4E, $D7, $52
    db $79, $B7, $07, $7D, $27, $07, $DB, $09
    db $83, $FD, $70, $F5, $9F, $A1, $A1, $77
    db $10, $05, $0E, $88, $56, $FE, $9C, $0F
    db $CA, $21, $07, $9D, $E7, $0F, $68, $0B
    db $95, $33, $05, $85, $A0, $46, $C3, $A7
    db $41, $A9, $36, $21, $C8, $BF, $19, $08
    db $5C, $36, $03, $24, $A1, $EF, $04, $3E
    db $00, $3F, $D8, $5D, $FC, $F1, $D6, $07
    db $F0, $84, $F8, $21, $A8, $FA, $00, $55
    db $F3, $04, $B8, $61, $9C, $FD, $00, $B5
    db $39, $16, $D7, $12, $2F, $77, $64, $13
    db $1A, $63, $A8, $CA, $DD, $00, $5C, $53
    db $00, $BF, $99, $03, $F8, $3F, $A6, $04
    db $E3, $07, $FC, $CF, $00, $BE, $2F, $3B
    db $DA, $55, $07, $EE, $79, $08, $D6, $71
    db $EF, $00, $17, $0B, $C8, $45, $DA, $0F
    db $DB, $6F, $9E, $7C, $0E, $E7, $5F, $DA
    db $D7, $3D, $81, $BC, $00, $83, $1F, $C3
    db $87, $DE, $00, $DA, $6F, $F7, $95, $71
    db $2B, $57, $03, $AE, $CD, $00, $0C, $91
    db $11, $C3, $6D, $C3, $25, $7D, $1F, $07
    db $B5, $55, $B1, $74, $6E, $D8, $82, $B1
    db $F1, $06, $F1, $B7, $0F, $D5, $7D, $ED
    db $CC, $24, $41, $B7, $E9, $F5, $3F, $FC
    db $A8, $00, $04, $C3, $31, $8D, $8F, $5B
    db $D9, $00, $64, $D6, $29, $69, $96, $2D
    db $00, $99, $7D, $8F, $BA, $54, $59, $3A
    db $FB, $FB, $4C, $05, $9E, $00, $B8, $65
    db $00, $22, $04, $9B, $14, $7A, $C7, $07
    db $4F, $F6, $00, $9A, $3B, $F3, $3C, $43
    db $83, $E8, $FF, $63, $E4, $B3, $B1, $6B
    db $00, $4B, $ED, $00, $BB, $0E, $53, $C1
    db $C7, $DA, $0A, $77, $04, $5F, $E6, $56
    db $9B, $53, $0F, $F1, $B3, $66, $00, $3E
    db $58, $B7, $FB, $5E, $53, $0F, $3E, $5C
    db $F1, $C8, $3D, $56, $BD, $58, $FD, $54
    db $7C, $21, $13, $F3, $DB, $05, $4E, $57
    db $B2, $1D, $4B, $36, $5C, $F1, $00, $62
    db $FB, $EF, $E7, $56, $F1, $70, $4F, $B8
    db $DB, $35, $4C, $7C, $C5, $37, $04, $05
    db $0D, $C3, $F3, $C1, $C3, $05, $CF, $0E
    db $C3, $31, $07, $00, $B3, $E7, $00, $83
    db $FF, $E7, $0E, $31, $9F, $13, $DF, $17
    db $FF, $FF, $FF, $F8

; Width = 22, height = 24
; image_pattern:
cvb_image_pattern_fr1:
    db $00, $00, $00, $00
    db $00, $00, $00, $03
    db $00, $04, $05, $06
    db $00, $12, $13, $14
    db $15, $16, $17, $00
cvb_image_pattern_fr2:
    db $00, $21, $22, $23
    db $2F, $13, $30, $31
    db $32, $33, $34, $35
    db $00, $00, $00, $00
    db $00, $00, $00, $00

cvb_image_pattern:
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $0C, $0D, $10, $08, $09, $11, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $18, $19, $1A, $02, $1B, $1C, $1D, $02, $02, $1E, $02, $02, $1F, $02, $20, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $24, $25, $26, $27, $28, $02, $29, $2A, $2B, $2C, $2D, $2E, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $36, $37, $02, $38, $39, $3A, $3B, $3C, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $02
    db $02, $02, $46, $47, $48, $02, $02, $02, $49, $02, $02, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53, $54
    db $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $4D, $4D, $62, $63, $64, $65, $66, $67, $68
    db $4D, $4D, $4D, $4D, $4D, $4D, $69, $6A, $6B, $6B, $6C, $4D, $4D, $4D, $6D, $6E, $6F, $70, $71, $72, $73, $74
    db $4D, $4D, $4D, $4D, $4D, $4D, $75, $76, $77, $78, $79, $4D, $7A, $7B, $7C, $7D, $7E, $7F, $80, $81, $82, $83
    db $4D, $4D, $84, $85, $86, $4D, $4D, $87, $88, $89, $4D, $8A, $8B, $8C, $8D, $8E, $8F, $90, $91, $92, $93, $4D
    db $94, $94, $95, $96, $97, $94, $94, $98, $94, $99, $94, $9A, $9B, $9C, $9D, $9E, $9F, $94, $A0, $A1, $94, $94
    db $00, $A2, $A3, $A4, $A5, $00, $00, $00, $00, $00, $00, $00, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $00, $00, $00
    db $00, $00, $AD, $AE, $AF, $B0, $00, $00, $00, $00, $00, $03, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $00, $00, $00
    db $00, $00, $B8, $B9, $BA, $BB, $00, $00, $00, $00, $00, $35, $BC, $BD, $BE, $BF, $C0, $C1, $C2, $00, $00, $00
    db $00, $00, $C3, $C4, $C5, $C6, $00, $00, $00, $00, $00, $00, $00, $C7, $C8, $C9, $CA, $CB, $00, $00, $00, $00
    db $00, $CC, $CD, $CE, $CF, $00, $00, $00, $00, $00, $00, $00, $D0, $D1, $D2, $D3, $D4, $D5, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; image_sprites:
cvb_image_sprites:
    db $3E, $00, $83, $00, $C0, $0C, $00, $F0
    db $00, $03, $0E, $C1, $04, $60, $C0, $E0
    db $6C, $00, $0F, $80, $04, $C0, $00, $10
    db $10, $18, $00, $1C, $11, $1C, $1E, $0E
    db $00, $0F, $0F, $F1, $27, $E0, $60, $06
    db $00, $3C, $38, $30, $20, $F1, $3B, $58
    db $08, $EC, $4B, $E0, $0F, $C0, $C0, $80
    db $00, $D9, $00, $8C, $EA, $05, $19, $40
    db $78, $FC, $FE, $7D, $EF, $2D, $3F, $F0
    db $5F, $4F, $1F, $ED, $27, $F9, $15, $C0
    db $FC, $0B, $20, $0D, $30, $38, $3C, $3E
    db $91, $00, $3C, $CF, $1A, $D0, $A9, $41
    db $C0, $00, $93, $38, $3E, $78, $70, $DD
    db $1E, $19, $CE, $1A, $9A, $F3, $1B, $03
    db $1C, $00, $01, $76, $E0, $C3, $79, $01
    db $03, $89, $12, $0F, $07, $DC, $D0, $1B
    db $0E, $C7, $00, $83, $06, $0C, $0C, $1C
    db $9E, $C0, $17, $9C, $0B, $67, $BA, $EB
    db $C9, $78, $01, $57, $F8, $C3, $07, $19
    db $31, $31, $D0, $9F, $7A, $80, $CF, $A6
    db $E8, $FF, $B5, $80, $52, $9F, $D5, $B3
    db $58, $99, $7D, $C0, $A1, $68, $05, $06
    db $71, $04, $98, $B0, $00, $18, $3C, $18
    db $C2, $16, $64, $00, $C9, $35, $D2, $7F
    db $00, $BD, $4C, $E4, $1D, $C0, $1D, $FA
    db $FE, $13, $FF, $FF, $FF, $FF, $C0

;
; sprite_overlay:
cvb_sprite_overlay:
;	DB 2+17*8,24+13*8,0,3
    db 208, 24 + 13 * 8, 0, 3  ; hide
    db 74, 165, 4, 12
    db 70, 149, 8, 5
    db 70, 136, 12, 5
    db 70, 176, 16, 1
    db 90, 95, 20, 8
    db 106, 136, 24, 12
    db 100, 192, 28, 10
    db 114, 158, 32, 8
    db 101, 112, 36, 8
    db 115, 136, 40, 8
    db 119, 156, 44, 15
    db 126, 61, 48, 15
    db 130, 56, 52, 8
    db 132, 71, 56, 3
    db 124, 136, 60, 3
    db 132, 184, 64, 11
    db 133, 160, 68, 11
    db 152, 59, 72, 15
    db 154, 74, 76, 15
    db 149, 144, 80, 3
    db 157, 56, 84, 12
    db 208

;	ANIMATED LOGO - Compressed data
;
; TILESET:
cvb_tileset:
    db $5A, $00, $1A, $00, $01, $03, $23, $00
    db $07, $00, $0E, $00, $63, $00, $0F, $07
    db $8C, $00, $03, $01, $1B, $43, $01, $17
    db $0F, $1F, $1F, $39, $10, $22, $3F, $95
    db $08, $05, $13, $60, $12, $13, $3F, $7F
    db $7F, $D8, $2D, $80, $C0, $D2, $2B, $06
    db $68, $F0, $0E, $FF, $B4, $00, $55, $DA
    db $07, $3F, $D8, $07, $03, $0F, $D8, $07
    db $04, $0E, $CA, $07, $5C, $41, $78, $3F
    db $27, $80, $D2, $07, $52, $73, $9F, $07
    db $03, $AC, $16, $00, $5B, $33, $FF, $3F
    db $73, $98, $1E, $F0, $0F, $20, $1C, $78
    db $FE, $FF, $00, $18, $6C, $FC, $07, $FF
    db $18, $7F, $3F, $3F, $94, $1C, $0F, $09
    db $60, $C0, $24, $E0, $E0, $C0, $80, $F1
    db $7A, $FF, $F4, $07, $3E, $02, $6D, $00
    db $2A, $77, $29, $07, $69, $20, $3B, $F1
    db $07, $07, $01, $B2, $07, $1F, $08, $D1
    db $07, $81, $7C, $17, $5C, $FF, $F2, $08
    db $D2, $03, $C0, $E0, $F8, $16, $08, $C0
    db $5E, $85, $00, $F8, $F0, $68, $DD, $0A
    db $1C, $6D, $72, $07, $CF, $39, $C0, $0C
    db $00, $FF, $FE, $21, $CA, $22, $05, $00
    db $A8, $07, $08, $02, $F0, $F8, $F0, $B1
    db $49, $00, $FC, $12, $FF, $03, $20, $FE
    db $FC, $FC, $F8, $F8, $6B, $10, $0A, $E7
    db $1A, $00, $BE, $11, $00, $09, $01, $00
    db $79, $7F, $16, $88, $31, $3C, $00, $7B
    db $00, $E6, $0B, $18, $00, $00, $DD, $FD
    db $3D, $3C, $1F, $0E, $06, $07, $06, $C6
    db $E6, $E6, $0F, $31, $0F, $BD, $00, $60
    db $88, $00, $F7, $00, $F0, $3D, $1D, $3D
    db $FD, $DD, $13, $10, $C5, $9F, $9E, $86
    db $C6, $83, $21, $C3, $E1, $F9, $79, $10
    db $4A, $43, $89, $19, $9F, $9F, $1F, $00
    db $5D, $23, $00, $2B, $C8, $33, $81, $00
    db $C3, $8C, $C4, $00, $DE, $00, $CC, $2E
    db $ED, $C0, $04, $0B, $21, $CE, $CE, $34
    db $E3, $E3, $E9, $84, $00, $EC, $EC, $09
    db $C7, $30, $C7, $E1, $00, $F3, $F3, $2B
    db $E1, $ED, $13, $00, $8B, $3B, $ED, $ED
    db $0E, $98, $13, $F0, $0B, $E0, $CD, $00
    db $F8, $BF, $00, $C1, $BE, $A2, $AE, $A2
    db $BE, $C1, $81, $76, $C1, $9C, $9E, $C0
    db $FC, $A5, $07, $01, $74, $02, $07, $0D
    db $9F, $C2, $DE, $F7, $63, $E7, $41, $E3
    db $F4, $9F, $27, $08, $06, $43, $BB, $0C
    db $10, $E9, $CB, $CE, $D9, $07, $F8, $D9
    db $F3, $C6, $A4, $9B, $8D, $A2, $F3, $78
    db $12, $78, $30, $00, $BA, $E5, $D1, $78
    db $00, $1B, $FE, $F9, $32, $3F, $E3, $00
    db $7F, $66, $D7, $00, $DB, $0D, $97, $97
    db $2A, $C2, $00, $07, $72, $F0, $C6, $DC
    db $57, $CF, $54, $1F, $C7, $79, $29, $4E
    db $87, $65, $FD, $FD, $6B, $79, $F2, $D7
    db $C3, $F3, $E5, $FC, $EB, $FE, $D2, $00
    db $AF, $3E, $04, $04, $1D, $6E, $7C, $41
    db $00, $99, $7E, $DE, $05, $71, $00, $1D
    db $20, $60, $0C, $99, $9F, $16, $73, $59
    db $93, $DA, $C8, $AB, $20, $20, $E1, $8F
    db $B7, $1F, $3A, $DB, $83, $1A, $C0, $00
    db $AC, $87, $03, $18, $3C, $3E, $7E, $66
    db $4F, $80, $4F, $AB, $85, $DF, $3C, $93
    db $C7, $29, $B0, $F1, $F1, $D2, $CD, $08
    db $7B, $F0, $76, $00, $22, $95, $08, $7B
    db $7C, $6A, $00, $07, $EE, $FB, $5B, $04
    db $10, $FD, $D7, $08, $07, $1F, $03, $1C
    db $3E, $71, $7F, $CB, $9D, $04, $8F, $F4
    db $B6, $A8, $55, $00, $0C, $B1, $E7, $C1
    db $8E, $A5, $F9, $F0, $56, $DF, $E0, $E0
    db $00, $E1, $E3, $E7, $E7, $35, $EF, $EF
    db $3A, $7C, $D9, $BD, $00, $FC, $00, $BB
    db $75, $91, $F9, $00, $87, $BF, $6E, $B5
    db $1F, $07, $03, $C3, $C1, $C1, $80, $34
    db $1F, $7F, $0F, $9C, $D4, $B9, $B8, $C1
    db $30, $60, $11, $03, $1F, $EC, $13, $08
    db $E4, $F8, $83, $DA, $45, $F5, $0A, $0F
    db $00, $F6, $73, $C6, $77, $3E, $17, $3D
    db $89, $7E, $7F, $FF, $FF, $FF, $FF, $C0


cvb_colorset0:
cvb_colorset1:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $BB, $0B, $0B
cvb_colorset2:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $CB, $CB, $BB, $0B, $0B
cvb_colorset3:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $0B, $0B, $0B, $CB, $CB, $0B, $0B, $4B, $4B, $BB, $0B, $0B
cvb_colorset4:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $CB, $0B, $0B, $4B, $4B, $0B, $0B, $7B, $7B, $BB, $0B, $0B
cvb_colorset5:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $4B, $0B, $0B, $7B, $7B, $CB, $CB, $3B, $3B, $BB, $0B, $0B
cvb_colorset6:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $7B, $CB, $CB, $3B, $3B, $4B, $4B, $6B, $6B, $BB, $0B, $0B
cvb_colorset7:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $3B, $4B, $4B, $6B, $6B, $7B, $7B, $AB, $AB, $BB, $CB, $CB
cvb_colorset8:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $6B, $7B, $7B, $AB, $AB, $3B, $3B, $CB, $CB, $BB, $4B, $4B
cvb_colorset9:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $AB, $3B, $3B, $CB, $CB, $6B, $6B, $4B, $4B, $BB, $7B, $7B
cvb_colorset10:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $CB, $6B, $6B, $4B, $4B, $AB, $AB, $7B, $7B, $BB, $3B, $3B
cvb_colorset11:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $4B, $AB, $AB, $7B, $7B, $CB, $CB, $3B, $3B, $BB, $6B, $6B
cvb_colorset12:    db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $08, $7B, $CB, $CB, $3B, $3B, $4B, $4B, $6B, $6B, $BB, $AB, $AB


cvb_pnt:
    db $1E, $30, $BB, $00, $00, $27, $1B, $1D
    db $1C, $28, $28, $2D, $47, $1E, $00, $1F
    db $23, $0D, $0F, $2F, $21, $22, $E0, $1E
    db $2E, $B2, $64, $80, $00, $02, $73, $90
    db $AF, $66, $82, $5B, $78, $70, $06, $10
    db $26, $91, $05, $DE, $1F, $00, $2B, $B1
    db $6A, $89, $5E, $75, $92, $AB, $00, $68
    db $87, $5C, $7C, $93, $18, $1A, $20, $0D
    db $30, $70, $99, $01, $E0, $1F, $25, $AD
    db $62, $84, $00, $5D, $74, $00, $08, $61
    db $85, $A0, $7A, $00, $97, $AE, $65, $81
    db $17, $71, $95, $07, $DE, $1F, $00, $24
    db $0C, $10, $0E, $0A, $0A, $09, $19, $C0
    db $1F, $76, $98, $A8, $67, $0D, $88, $03
    db $72, $04, $70, $A4, $2A, $B0, $00, $63
    db $86, $5A, $7C, $96, $A9, $60, $8A, $1A
    db $58, $77, $13, $E0, $1F, $29, $AC, $6B
    db $00, $8B, $5F, $7B, $94, $AA, $69, $83
    db $59, $35, $79, $0F, $C5, $1F, $2C, $62
    db $00, $00, $0D, $15, $14, $0B, $12, $16
    db $11, $6F, $30, $EE, $C0, $00, $3D, $47
    db $39, $45, $3E, $06, $3B, $3C, $38, $49
    db $4A, $EC, $1F, $44, $00, $48, $3A, $4B
    db $4C, $3F, $40, $41, $46, $00, $43, $42
    db $30, $50, $54, $51, $52, $53, $FF, $FF
    db $FF, $FF, $C0



arcadefonts:
    db $1F, $00, $01, $00, $7C, $C6, $82, $82
    db $C6, $7C, $09, $07, $10, $30, $10, $00
    db $38, $C1, $0F, $06, $7C, $C0, $FE, $07
    db $07, $FE, $06, $3C, $06, $01, $17, $1C
    db $34, $64, $C4, $FE, $04, $0D, $07, $FC
    db $80, $FC, $23, $0F, $1C, $FC, $86, $A0
    db $07, $1F, $0C, $18, $30, $60, $EB, $2F
    db $01, $A2, $17, $05, $C2, $7E, $39, $88
    db $07, $38, $6C, $50, $FE, $82, $AA, $2F
    db $25, $01, $02, $80, $07, $7E, $C0, $80
    db $80, $C0, $7E, $EB, $0F, $67, $84, $0F
    db $FE, $80, $F8, $10, $FE, $F1, $07, $80
    db $C5, $37, $80, $8E, $39, $55, $07, $1D
    db $35, $00, $8D, $3F, $10, $96, $87, $02
    db $00, $80, $97, $86, $8C, $98, $B0, $EC
    db $59, $C6, $07, $2C, $A4, $37, $14, $EE
    db $30, $BA, $92, $27, $C2, $E2, $0D, $B2
    db $9A, $8E, $86, $6E, $BF, $6D, $D8, $4F
    db $82, $9A, $36, $CC, $76, $0F, $38, $88
    db $8E, $0F, $70, $1C, $D1, $AF, $10, $DD
    db $00, $67, $B6, $2F, $0E, $05, $44, $6C
    db $38, $07, $08, $92, $BA, $EE, $44, $07
    db $C6, $6C, $AE, $CE, $BA, $5F, $B9, $15
    db $27, $FE, $D9, $DE, $6F, $C3, $00, $60
    db $60, $40, $BC, $06, $0D, $E8, $0F, $03
    db $18, $18, $CB, $25, $01, $FF, $FF, $FF
    db $FF
