; DISASSEMBLY OF MR. DO! BY CAPTAIN COSMOS
; 100 HUNDRED PERCENT ALL LINKS RESOLVED.
; I SPENT A LOT OF TIME WORKING ON THIS AND IT WOULD SUCK 100% IF SOMEONE USED MY WORK TO MAKE MONEY.
; THIS WAS DONE FOR EDUCATIONAL PURPOSES ONLY AND ALL CREDIT GOES TO ME AND ME ONLY.
; STARTED NOVEMBER 7, 2023
; COMPLETED ON NOVEMBER 10, 2023 (TECHNICALLY NOT COMPLETED...COMPLETED)  THERE CAN ALWAYS BE MORE DONE.
; FOUND A POTENTIAL EASTER EGG THAT REPRESENTS AN EARLY PROTOTYPE SET OF SPRITE PATTERNS DEPICTING THE JAPANESE SNOWMAN.
; MARKED AS MR_DO_UNUSED_PUSH_ANIM_01_PAT, MR_DO_UNUSED_PUSH_ANIM_02_PAT AND MR_DO_UNUSED_PUSH_ANIM_03_PAT
; LET THE HISTORY BOOKS BE KNOWN ON 10 NOVEMBER 2023 CAPTAIN COZMOS, I DISCOVERED THIS AFTER 40 YEARS BEING HIDDEN WITHIN THE CODE...


; BIOS DEFINITIONS **************************
ascii_table: equ 0x006a
number_table: equ 0x006c
play_songs: equ 0x1f61
game_opt: equ 0x1f7c
fill_vram: equ 0x1f82
init_table: equ 0x1fb8
put_vram: equ 0x1fbe
init_spr_nm_tbl: equ 0x1fc1
wr_spr_nm_tbl: equ 0x1fc4
init_timer: equ 0x1fc7
free_signal: equ 0x1fca
request_signal: equ 0x1fcd
test_signal: equ 0x1fd0
time_mgr: equ 0x1fd3
write_register: equ 0x1fd9
read_register: equ 0x1fdc
write_vram: equ 0x1fdf
read_vram: equ 0x1fe2
poller: equ 0x1feb
sound_init: equ 0x1fee
play_it: equ 0x1ff1
sound_man: equ 0x1ff4
rand_gen: equ 0x1ffd
vram_pattern: equ 0x0000
vram_name: equ 0x1800
vram_color: equ 0x2000

; VDP
data_port: equ 0x00be  ; MSX 098h
ctrl_port: equ 0x00bf  ; MSX 099h


coleco_title_on: equ 0x55aa
coleco_title_off: equ 0xaa55


; SOUND DEFINITIONS *************************
opening_tune_snd_0a: equ 0x01
background_tune_0a: equ 0x02
opening_tune_snd_0b: equ 0x03
background_tune_0b: equ 0x04
grab_cherries_snd: equ 0x05
bouncing_ball_snd_0a: equ 0x06
bouncing_ball_snd_0b: equ 0x07
ball_stuck_snd: equ 0x08
ball_return_snd: equ 0x09
apple_falling_snd: equ 0x0a
apple_break_snd_0a: equ 0x0b
apple_break_snd_0b: equ 0x0c
no_extra_tune_0a: equ 0x0d
no_extra_tune_0b: equ 0x0e
no_extra_tune_0c: equ 0x0f
diamond_snd: equ 0x10
extra_walking_tune_0a: equ 0x11
extra_walking_tune_0b: equ 0x12
game_over_tune_0a: equ 0x13
game_over_tune_0b: equ 0x14
win_extra_do_tune_0a: equ 0x15
win_extra_do_tune_0b: equ 0x16
end_of_round_tune_0a: equ 0x17
end_of_round_tune_0b: equ 0x18
lose_life_tune_0a: equ 0x19
lose_life_tune_0b: equ 0x1a
blue_chomper_snd_0a: equ 0x1b
blue_chomper_snd_0b: equ 0x1c


; RAM DEFINITIONS ***************************
    org 0x7000
sprite_order_table:
    org $ + 20  ;EQU $7000
timer_data_block:
    org $ + 23  ;EQU $7014

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
    org $ + 28  ;EQU $713A ; BEHAVIOR TABLE. UP TO 28 ELEMENTS

    org $ + 285  ; ?? 
;EQU $726E ; NMI-ISR CONTROL BYTE (!!)
diamond_ram:
    org $ + 1  ;EQU $7273
current_level_ram:
    org $ + 2  ;EQU $7274
lives_left_p1_ram:
    org $ + 1  ;EQU $7276
lives_left_p2_ram:
    org $ + 1  ;EQU $7277

    org $ + 5  ;EQU $7278 ?? Initialised at 7 by LOC_8573

score_p1_ram:
    org $ + 2  ;EQU $727D ;  $727D/7E  2 BYTES SCORING FOR PLAYER#1. THE LAST DIGIT IS A RED HERRING. I.E. 150 LOOKS LIKE 1500.  SCORE WRAPS AROUND AFTER $FFFF (65535)
score_p2_ram:
    org $ + 2  ;EQU $727F ;  $727F/80  2 BYTES SCORING FOR PLAYER#2

    org $ + 110  ; ??
work_buffer:
    org $ + 215  ;EQU $72EF
defer_writes:
    org $ + 2  ;EQU $73C6

    org $ + 8  ; ??
stored_color_pointer:
    org $ + 2  ;EQU $73D0    ; 2 bytes for storing the pointer
stored_color_data:
    org $ + 12  ;EQU $73D2    ; 12 bytes for actual color data

mode: equ 0x73ff  ; maybe used by OS ??




;	CPU Z80


    org 0x8000

    dw coleco_title_on  ; SET TO COLECO_TITLE_ON FOR TITLES, COLECO_TITLE_OFF TO TURN THEM OFF
    dw sprite_name_table
    dw sprite_order_table
    dw work_buffer
    dw controller_buffer
    dw start

    ret
    nop
    nop
    ret
    nop
    nop
    ret
    nop
    nop
    ret
    nop
    nop
    ret
    nop
    nop
    ret
    nop
    nop
    reti
    nop
;    JP      NMI
    jp nmi_handler

    db "MR. DO!", 0x1e, 0x1f
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
    ld bc, 0x01c2
    call write_register
    call read_register
    ld hl, work_buffer
    ld de, 0x7307
    ld bc, 0x18
    ldir
    ld hl, 0x726e
    bit 5, (hl)
    jr z, loc_807e
    bit 4, (hl)
    jr z, loc_809f
    ld a, 0x14
    call wr_spr_nm_tbl
    call sub_8107
    jr loc_809f
loc_807e:
    ld a, (0x726e)
    bit 3, a
    jr nz, loc_808d
    ld a, 0x14
    call wr_spr_nm_tbl
    call sub_8107
loc_808d:
;     call sub_80d1  ; -mdl

sub_80d1:
    ld hl, 0x7259
    ld bc, 0x1401
loc_80d7:
    ld a, (hl)
    and a
    jr z, loc_80ff
    ld e, c
    push bc
loc_80dd:
    push hl
    push de
    ld hl, 0x7259
    ld a, e
    call sub_ac0b
    jr z, loc_80f7
    pop de
    push de
    ld hl, 0x7259
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
    call sub_8229
    call sub_8251
    call display_extra_01
    call sub_82de
    call time_mgr
loc_809f:
    call poller
    call sub_c952  ; PLAY MUSIC
    ld hl, 0x7307
    ld de, work_buffer
    ld bc, 0x18
    ldir
    ld hl, 0x726e
    bit 7, (hl)
    jr z, loc_80bb
    res 7, (hl)
    jr finish_nmi
loc_80bb:
    ld bc, 0x01e2
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

sub_8107:
    ld hl, byte_8215
    ld de, work_buffer
    ld bc, 0x14
    ldir
    ld a, 3
    ld (0x72e7), a
    ld a, 0x13
    ld (0x72e8), a
    ld hl, 0x72f2
    ld iy, 0x70f5
    ld b, 0x11
loc_8125:
    ld a, (hl)
    and a
    jp nz, loc_81dc
    ld a, (iy + 0)
    cp 0x10
    jr nc, loc_813c
    ld a, (0x72e7)
    ld (hl), a
    inc a
    ld (0x72e7), a
    jp loc_81dc
loc_813c:
    push bc
    push hl
    push iy
    ld de, 0
    ld c, (iy + 0)
    ld a, (0x726d)
    res 6, a
    ld (0x726d), a
    and 3
    cp 1
    jr c, loc_81a1
    jr nz, loc_816f
    ld d, 4
    ld a, (0x70ed)
    sub c
    jr nc, loc_8160
    cpl
    inc a
loc_8160:
    cp 0x10
    jr nc, loc_81a1
    ld a, (0x726d)
    set 6, a
    ld (0x726d), a
    dec d
    jr loc_81a1
loc_816f:
    ld d, 8
    ld a, (0x70ed)
    sub c
    jr nc, loc_8179
    cpl
    inc a
loc_8179:
    cp 0x10
    jr nc, loc_81a1
    ld a, (0x726d)
    set 6, a
    ld (0x726d), a
    ld d, 6
    jr loc_81a1
loc_81b6:
    ld a, (0x72e8)
    ld (hl), a
    dec a
    ld (0x72e8), a
;     JR      LOC_8189  ; -mdl
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
    cp 0x10
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
    ld a, (0x72e7)
    ld (hl), a
    inc a
    ld (0x72e7), a
    jr loc_8189
loc_81c0:
    ld a, e
    cp 9
    jr nc, loc_81d0
    cp 7
    jr c, loc_81d8
    ld a, (0x726d)
    bit 6, a
    jr z, loc_81d8
loc_81d0:
    ld a, (0x726d)
    set 7, a
    ld (0x726d), a
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
    ld hl, 0x726d
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
    ld (0x726d), a
    ld de, sprite_order_table
    ld b, 0x14
    ld iy, work_buffer
    xor a
loop_8208:
    ld h, 0
    ld l, (iy + 0)
    add hl, de
    ld (hl), a
    inc a
    inc iy
    djnz loop_8208
    ret

byte_8215:
    db 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

sub_8229:
    ld hl, 0x7281
    bit 7, (hl)
    jr z, locret_8250
    res 7, (hl)
    ld d, 1
    ld a, (0x7286)
    and a
    jr z, loc_8241
    add a, 0x1b
    call deal_with_sprites
    ld d, 0
loc_8241:
    ld a, (0x7284)
    sub 1
    ld b, a
    ld a, (0x7285)
    ld c, a
    ld a, 0x81
    call sub_b629
locret_8250:
    ret

sub_8251:
    ld hl, 0x727c
    bit 7, (hl)
    jr z, loc_825d
    res 7, (hl)
    xor a
    jr loc_8265
loc_825d:
    bit 6, (hl)
    jr z, locret_8268
    res 6, (hl)
    ld a, 1
loc_8265:
    call patterns_to_vram
locret_8268:
    ret

display_extra_01:
    ld a, (0x72bc)
    and a
    jr z, loc_82aa
    ld hl, byte_82d3
    ld de, 0x2b
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
    ld a, (0x72bc)
    and (hl)
    ld (0x72bc), a
    inc hl
    ld a, (0x726e)
    bit 1, a
    ld a, (0x72b8)
    jr z, loc_8297
    ld a, (0x72b9)
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
    ld a, (0x72bb)
    and a
    jr z, locret_82d2
    ld hl, byte_82d3
    ld de, 0x2b
loc_82b6:
    rrca
    jr c, loc_82bf
    inc hl
    inc hl
    inc de
    inc de
    jr loc_82b6
loc_82bf:
    ld hl, 0x72bb
    ld a, (hl)
    and (hl)
    ld (hl), a
    ld hl, byte_82dd
    ld a, 2
    ld iy, 1
    call put_vram
locret_82d2:
    ret

byte_82d3:
    db 254, 1, 253, 2, 251, 4, 247, 8, 239, 16
byte_82dd:
    db 0

sub_82de:
    ld hl, 0x7272
    bit 0, (hl)
    jr z, loc_8305
    res 0, (hl)
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, loc_82f4
    ld a, (0x7275)
loc_82f4:
    dec a
    cp 0x0a
    jr c, loc_82fb
    ld a, 9
loc_82fb:
    ld hl, byte_8333
    ld c, a
    ld b, 0
    add hl, bc
    ld a, (hl)
    jr loc_830d
loc_8305:
    bit 1, (hl)
    jr z, loc_8310
    res 1, (hl)
    ld a, 0x0e
loc_830d:
    call deal_with_playfield
loc_8310:
    ld hl, diamond_ram
    bit 7, (hl)
    jr z, locret_8332
    ld ix, 0x722c
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
    ld a, 0x8d
    call sub_b629
locret_8332:
    ret

byte_8333:
    db 10, 11, 12, 13, 10, 11, 12, 13, 10, 11

start:
    ld hl, 0x7000
    ld de, 0x7000 + 1
    ld bc, 0x0300
    ld (hl), c
    ldir
    ld hl, mode
    ld (hl), b

    ld de, sprite_order_table
loc_8340:
    xor a
    ld (de), a
    inc de
    ld hl, 0x73b0
    sbc hl, de
    ld a, h
    or l
    jr nz, loc_8340
    ld a, 1
    ld (defer_writes + 1), a
    ld a, 0
    ld (defer_writes), a
    call initialize_the_sound
    ld a, 0x14
    call init_spr_nm_tbl
    ld hl, timer_table
    ld de, timer_data_block
    call init_timer
    ld hl, controller_buffer
    ld a, 0x9b
    ld (hl), a
    inc hl
    ld (hl), a
;     JP      LOC_8372  ; -mdl
loc_8372:
;     call sub_83d4  ; -mdl

sub_83d4:  ; Initialize the game
    call get_game_options
    call cvb_animatedlogo
    call init_vram
    xor a
;     ret  ; -mdl
loc_8375:
;     call sub_84f8  ; -mdl

sub_84f8:  ; Disables NMI, sets up the game
    push af
    ld hl, 0x726e
    set 7, (hl)
loc_84fe:
    bit 7, (hl)
    jr nz, loc_84fe
    pop af
    push af
    and a
    jr nz, loc_850a
    call sub_851c
loc_850a:
    call sub_8585
    pop af
    cp 2
    jr z, loc_8515
    call clear_screen_and_sprites_01
loc_8515:
    call clear_screen_and_sprites_02
    call sub_87f4
;     ret  ; -mdl
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
    jr z, loc_83ab
    and a
    jr nz, loc_83cb
    call sub_a53e
    and a
    jr z, loc_8378
    cp 1
    jr nz, loc_83cb
loc_83ab:
    ld ix, 0x722c
    ld b, 5
loop_83b1:
    bit 3, (ix + 0)
    jr nz, loc_83c0
    ld de, 5
    add ix, de
    djnz loop_83b1
;     JR      LOC_83C5  ; -mdl
loc_83c5:
    or a
    jr nz, loc_83cb
    ld a, 1
loc_83cb:
    call got_diamond
    cp 3
    jr z, loc_8372
    jr loc_8375
loc_83c0:
    call deal_with_apple_falling
    jr loc_83ab

get_game_options:
    call game_opt
loc_83df:
    call poller
    ld a, (keyboard_p1)
    and a
    jr z, loc_83ec
    cp 9
    jr c, loc_83f6
loc_83ec:
    ld a, (keyboard_p2)
    and a
    jr z, loc_83df
    cp 9
    jr nc, loc_83df
loc_83f6:
    ld hl, 0x726e
    res 0, (hl)
    cp 5
    jr c, loc_8403
    set 0, (hl)
    sub 4
loc_8403:
    ld (0x7271), a
    ret

init_vram:
    ld bc, 0
    call write_register
    ld bc, 0x01c2
    call write_register
    ld bc, 0x0700
    call write_register

    xor a
    ld hl, 0x1900
    call init_table
    ld a, 1
    ld hl, 0x2000
    call init_table
    ld a, 2
    ld hl, 0x1000
    call init_table
    ld a, 3
    ld hl, 0
    call init_table
    ld a, 4
    ld hl, 0x1800
    call init_table
    ld hl, 0
    ld de, 0x4000
    xor a
    call fill_vram
    ld ix, variouts_patterns
loc_844e:
    ld a, (ix + 0)
    and a
    jr z, load_fonts
    ld b, 0
    ld c, a
    push bc
    pop iy
    ld d, b
    ld e, (ix + 1)
    ld l, (ix + 2)
    ld h, (ix + 3)
    ld a, 3
    push ix
    call put_vram
    pop ix
    ld bc, 4
    add ix, bc
    jr loc_844e
load_fonts:
    ld hl, (number_table)
    ld de, 0x00d8
    ld iy, 0x0a
    ld a, 3
    call put_vram
    ld hl, (ascii_table)
    ld de, 0x00e2
    ld iy, 0x1a
    ld a, 3
    call put_vram
    ld hl, (number_table)
    ld bc, 0xffe0
    add hl, bc
    ld de, 0x00fc
    ld iy, 3
    ld a, iyl
    call put_vram
    ld hl, (number_table)
    ld bc, 0xff88
    add hl, bc
    ld de, 0x00ff
    ld iy, 1
    ld a, 3
    call put_vram
    ld a, 0x1b
load_graphics:
    push af
    call deal_with_sprites
    pop af
    dec a
    jp p, load_graphics
    ld hl, extra_sprite_pat
    ld de, 0x60
    ld iy, 0x40
    ld a, 1
    call put_vram
    ld hl, ball_sprite_pat
    ld de, 0x00c0
    ld iy, 0x18
    ld a, 1
    call put_vram
    ld hl, phase_01_colors
    ld de, 0
    ld iy, 0x20
    ld a, 4
    call put_vram
    ld bc, 0x01e2
    jp write_register

sub_851c:  ; If we're here, the game just started
    ld hl, 0
    ld (score_p1_ram), hl
    ld (score_p2_ram), hl
    ld a, 1  ; Set the starting level to 1
    ld (current_level_ram), a
    ld (0x7275), a
    xor a
    ld (0x727a), a
    ld (0x727b), a
    ld a, (0x7271)
    cp 2
    ld a, 3  ; Set the number of lives to 3
    jr nc, loc_853f
    ld a, 5  ; Set the number of lives to 5
loc_853f:
    ld (lives_left_p1_ram), a
    ld (lives_left_p2_ram), a
    ld hl, 0x726e
    ld a, (hl)
    and 1
    ld (hl), a
    ld a, 1
    call sub_b286
    ld hl, 0x718a
    ld de, 0x3400
    ld bc, 0x00d4
    call write_vram
    ld hl, 0x718a
    ld de, 0x3600
    ld bc, 0x00d4
    call write_vram
    call sub_866b
    ld hl, 0x72b8
    ld b, 0x0b
    xor a
loc_8573:
    ld (hl), a
    inc hl
    djnz loc_8573
    ld a, 8
    ld (0x72ba), a
    ld a, 7
    ld (0x7278), a
    ld (0x7279), a
    ret

sub_8585:
    xor a
    ld (0x72d9), a
    ld (0x72dd), a
    ld (0x7272), a
    ld (diamond_ram), a
    ld hl, 0x726e
    res 6, (hl)
    ld a, (hl)
    ld de, 0x3400
    bit 1, a
    jr z, loc_85a4
    set 1, d
loc_85a4:
    ld hl, 0x718a
    ld bc, 0x00d4
    call read_vram
    xor a
    ld (badguy_bhvr_cnt_ram), a
    ld hl, badguy_behavior_ram
    ld b, 0x50
loc_85b6:
    ld (hl), a
    inc hl
    djnz loc_85b6
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, loc_85c7
    ld a, (0x7275)
loc_85c7:
    cp 0x0b
    jr c, deal_with_badguy_behavior
    sub 0x0a
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
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, loc_8603
    ld a, (0x7275)
loc_8603:
    cp 0x0b
    jr c, send_phase_colors_to_vram
    sub 0x0a
    jr loc_8603

send_phase_colors_to_vram:
    dec a
    add a, a
    ld c, a
    ld b, 0
    ld iy, playfield_colors
    add iy, bc
    ld l, (iy + 0)
    ld h, (iy + 1)
    ld de, 0
    ld iy, 0x0c
    ld a, 4
    call put_vram
    ld hl, 0x72c3
    ld b, 0x16
    xor a
loc_862e:
    ld (hl), a
    inc hl
    djnz loc_862e
    call sub_866b
    ld hl, 0x72c1
    ld a, (hl)
    and 7
    ld (hl), a
    ld a, (0x72ba)
    and 0x3f
    ld (0x72ba), a
    ld l, 120
    ld a, (0x726e)
    inc a
    and 3
    jr nz, loc_8652
    inc l
loc_8652:
    ld a, (hl)
    cp 7
    jp nc, locret_866a
    ld iy, 0x72b2
loc_865c:
    ld (iy + 4), 0x00c0
    ld de, 0xfffa
    add iy, de
    inc a
    cp 7
    jr nz, loc_865c
locret_866a:
    ret

sub_866b:
    ld hl, 0x728a
    ld b, 0x2e
    xor a
loop_8671:
    ld (hl), a
    inc hl
    djnz loop_8671
    ret

clear_screen_and_sprites_01:
    ld hl, 0x1000
    ld a, l
    ld de, 0x0300
    call fill_vram
    ld hl, 0x1900
    ld a, l
    ld de, 0x80
    call fill_vram
    ld hl, sprite_name_table
    ld b, 0x50
loop_8691:
    ld (hl), 0
    inc hl
    djnz loop_8691
    ld a, (0x726e)
    bit 1, a
    ld a, 4
    jr z, loc_86a1
    inc a
loc_86a1:
    call deal_with_playfield
    ld bc, 0x01e2
    call write_register
    ld hl, 0x00b4
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
    ld hl, 0x726e
    set 7, (hl)
loc_86c0:
    bit 7, (hl)
    jr nz, loc_86c0
    ret

clear_screen_and_sprites_02:
    ld hl, 0x1000
    ld a, l
    ld de, 0x0300
    call fill_vram
    ld hl, 0x1900
    ld a, l
    ld de, 0x80
    call fill_vram
    ld hl, sprite_name_table
    ld b, 0x50
loop_86e0:
    ld (hl), 0
    inc hl
    djnz loop_86e0
    ld a, 0x00a0
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
    ld a, (0x726e)
    rra
    jr nc, loc_8709
    ld a, 0x0f
    call deal_with_playfield
    ld a, 1
    call patterns_to_vram
loc_8709:
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, loc_8716
    ld a, (0x7275)
loc_8716:
    ld hl, 0x72e7
    ld d, 0x00d8
    ld iy, 1
    cp 0x0a
    jr nc, loc_8728
    add a, d
    ld (hl), a
    jr loc_8739
loc_8728:
    cp 0x0a
    jr c, loc_8731
    sub 0x0a
    inc d
    jr loc_8728
loc_8731:
    inc iy
    ld (hl), d
    inc hl
    add a, 0x00d8
    ld (hl), a
    dec hl
loc_8739:
    ld de, 0x3d
    ld a, 2
    call put_vram
    ld a, 2
    call deal_with_playfield
    ld hl, 0x72b8
    ld a, (0x726e)
    bit 1, a
    jr z, loc_8753
    inc l
loc_8753:
    ld de, 0x012b
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
    ld a, (0x726e)
    bit 1, a
    ld hl, lives_left_p1_ram
    jr z, loc_878c
    inc l
loc_878c:
    ld b, (hl)
    ld de, 0x35
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
    ld de, 0x20
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
    ld iy, 0x722c
    ld a, 0x0c
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
    ld iy, 0x7281
    xor a
    ld (iy + 6), a
    ld (iy + 7), a
    ld a, 1
    ld (iy + 1), a  ; Set Mr. Do's starting direction
    ld (iy + 5), a
    ld (iy + 3), 0x00b0  ; Set Mr. Do's starting Y coordinate
    ld (iy + 4), 0x78  ; Set Mr. Do's starting X coordinate
    ld (iy + 0), 0x00c0
    ld bc, 0x01e2
    call write_register
    call play_opening_tune
    ld hl, 1
    xor a
    call request_signal
    ld (0x7283), a
    pop af
    ret

sub_8828:
    ld a, (0x726e)
    bit 1, a
    ld a, (keyboard_p1)
    jr z, check_for_pause
    ld a, (keyboard_p2)
check_for_pause:
    cp 0x0a
    jp nz, locret_88d0
    ld hl, 0x726e
    set 7, (hl)
enter_pause:
    bit 7, (hl)
    jr nz, enter_pause
    set 5, (hl)
    xor a
    ld hl, 0x1900
    ld de, 0x80
    call fill_vram
    ld a, 2
    ld hl, 0x3800
    call init_table
    ld hl, 0x7020
    ld de, 0x3b00
    ld bc, 0x5d
    call write_vram
    ld bc, 0x01e2
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
    ld a, (0x726e)
    bit 1, a
    ld a, (keyboard_p1)
    jr z, check_to_leave_pause
    ld a, (keyboard_p2)
check_to_leave_pause:
    cp 0x0a
    jr nz, loop_till_un_pause
    call initialize_the_sound
    ld hl, 0x726e
    set 7, (hl)
loc_8891:
    bit 7, (hl)
    jr nz, loc_8891
    set 4, (hl)
    ld a, 2
    ld hl, 0x1000
    call init_table
    ld bc, 0x01e2
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
    ld hl, 0x726e
    set 7, (hl)
loc_88b6:
    bit 7, (hl)
    jr nz, loc_88b6
    ld a, (hl)
    and 0x00cf
    ld (hl), a
    ld hl, 0x7020
    ld de, 0x3b00
    ld bc, 0x5d
    call read_vram
    ld bc, 0x01e2
    call write_register
locret_88d0:
    ret

deal_with_apple_falling:
;     call leads_to_falling_apple_03  ; -mdl

leads_to_falling_apple_03:
    ld iy, 0x722c
    ld hl, byte_896c
    ld a, (0x722a)
    ld c, a
    ld b, 0
    add hl, bc
    ld c, (hl)
    add iy, bc
;     ret  ; -mdl
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
    and 0x00cf
    ld c, a
    ld a, b
    add a, 0x10
    and 0x30
    or c
    ld (iy + 4), a
    and 0x30
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
    ld a, (0x722a)
    inc a
    cp 5
    jr c, loc_8954
    xor a
loc_8954:
    ld (0x722a), a
    pop af
    and a
    ret

byte_896c:
    db 0, 5, 10, 15, 20, 25

sub_8972:
    ld hl, 0x0f
    ld a, (iy + 0)
    bit 6, a
    jr nz, loc_8992
    ld l, 4
    bit 5, a
    jr nz, loc_8992
    ld l, 0x19
;     JR      LOC_8992  ; -mdl

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
    ld bc, 0x0808
loc_89c8:
    ld a, (0x722a)
    add a, 0x0c
    jp sub_b629

sub_89d1:
    push iy
    ld a, (iy + 4)
    and 0x0f
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
    ld ix, 0x722c
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
;     ret  ; -mdl
    cp 1
    jr nz, loc_8a2e
    call rand_gen
    and 0x0f
    cp 2
    jr nc, loc_8a2e
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld ix, 0x722c
    ld (ix + 1), b
    ld (ix + 2), c
    ld a, 0x80
    ld (diamond_ram), a
    call play_diamond_sound
loc_8a2e:
    pop iy
    ret

deal_with_apple_hitting_something:
    ld b, (iy + 1)
    ld c, (iy + 2)
    ld a, c
    and 0x0f
    jr z, loc_8a67
    cp 8
    jr z, loc_8a67
    ld a, c
    add a, 8
    and 0x00f0
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
    and 0x0f
    jr nz, apple_fell_on_something
    ld a, (iy + 0)
    and 7
    cp 5
    jr nc, apple_fell_on_something
    ld (iy + 0), 0x80
    ld (iy + 4), 0x10
    xor a
    jr loc_8ad7
apple_fell_on_something:
    res 5, (iy + 0)
    push iy
    call play_apple_breaking_sound
    pop iy
    ld a, (iy + 4)
    add a, 0x10
    ld (iy + 4), a
loc_8ad7:
    and a
    ret

sub_8ad9:
    ld a, b
    and 0x0f
    ret nz
    call sub_ac3f
    dec ix
    dec d
    ld a, (ix + 0x11)
    and 3
    cp 3
    ret nz
    bit 3, c
    jr nz, loc_8af7
    ld a, (ix + 0x10)
    and 3
    cp 3
    ret nz
loc_8af7:
    ld a, (ix + 1)
    and 0x0c
    cp 0x0c
    jr nz, loc_8b09
    ld a, b
    cp 0x00e8
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
    cp 0x00b8
    jr nc, loc_8b54
    ld a, (ix + 1)
    and 0x0c
    cp 0x0c
    jr nz, loc_8b34
    set 4, (ix + 0x11)
loc_8b34:
    ld a, (ix + 0x11)
    cpl
    and 5
    jr nz, loc_8b4e
    ld a, (ix + 0x10)
    cpl
    and 0x0a
    jr nz, loc_8b4e
    bit 3, c
    jr nz, loc_8b4e
    set 7, (ix + 0x11)
loc_8b4e:
    ld a, d
    add a, 0x11
    call sub_8bb1
loc_8b54:
    bit 3, c
    ret nz
    ld a, (ix + 0)
    and 0x0c
    cp 0x0c
    jr nz, loc_8b69
    ld a, b
    cp 0x00b8
    jr nc, loc_8b69
    set 5, (ix + 0)
loc_8b69:
    ld a, (ix + 0)
    and 0x0a
    cp 0x0a
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
    cp 0x00b8
    ret nc
    ld a, (ix + 0)
    and 0x0c
    cp 0x0c
    jr nz, loc_8b94
    set 4, (ix + 0x10)
loc_8b94:
    ld a, (ix + 0x10)
    cpl
    and 0x0a
    jr nz, loc_8baa
    ld a, (ix + 0x11)
    cpl
    and 5
    jr nz, loc_8baa
    set 6, (ix + 0x10)
loc_8baa:
    ld a, d
    add a, 0x10
    jp sub_8bb1

sub_8bb1:
    push bc
    push de
    push ix
    ld hl, 0x7259
    call sub_abe1
    pop ix
    pop de
    pop bc
    ret

sub_8bc0:  ; Mr. Do interesecting with a falling apple
    ld a, (0x7284)
    ld d, a
    bit 7, (iy + 4)
    jr z, loc_8bce
    add a, 4
    jr loc_8be4
loc_8bce:
    ld a, (0x7285)
    ld e, a
    call sub_8cfe
    jr nz, loc_8bf4
    set 7, (iy + 4)
    ld a, (0x726e)
    set 6, a
    ld (0x726e), a
    ld a, d
loc_8be4:
    ld (0x7284), a
    xor a
    ld (0x7286), a
    ld a, (0x7281)
    set 7, a
    ld (0x7281), a
loc_8bf4:
    ret

sub_8bf6:  ; Falling apple
    ld a, (0x72ba)
    ld b, a
    ld a, 1
    bit 7, b
    jr z, loc_8c38
    ld a, (0x72bf)
    ld d, a
    bit 6, (iy + 4)
    jr z, loc_8c0f
    add a, 4
    ld d, a
    jr loc_8c28
loc_8c0f:
    ld a, (0x72be)
    ld e, a
    call sub_8cfe
    jr nz, loc_8c38
    ld a, (0x72bd)
    set 7, a
    ld (0x72bd), a
    set 6, (iy + 4)
    inc (iy + 4)
    ld a, d
loc_8c28:
    ld (0x72bf), a
    ld b, d
    ld a, (0x72be)
    ld c, a
    ld d, 0x0b
    ld a, 3
    call sub_b629
    xor a
loc_8c38:
    and a
    ret

sub_8c3a:  ; Falling apple
    ld b, 7
    ld ix, 0x728e
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
    ld a, (0x722a)
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
    ld a, (0x722a)
    ld (ix + 5), a
    inc (iy + 4)
loc_8c7a:
    ld (ix + 2), d
    ld b, d
    ld c, e
    call sub_b7ef
    add a, 5
    ld d, 0x25
    push ix
    call sub_b629
    pop ix
loc_8c8d:
    ld de, 6
    add ix, de
    pop bc
    djnz loc_8c40
    ret

sub_8c96:  ; Falling apple
    ld b, 3
    ld ix, 0x72c7
loc_8c9c:
    push bc
    bit 7, (ix + 4)
    jr z, loc_8cf5
    ld d, (ix + 2)
    ld e, (ix + 1)
    bit 7, (ix + 0)
    jr z, loc_8cbe
    ld b, (ix + 5)
    ld a, (0x722a)
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
    ld a, (0x722a)
    ld (ix + 5), a
    inc (iy + 4)
loc_8cd0:
    ld (ix + 2), d
    ld b, d
    ld c, e
    push ix
    pop hl
    xor a
    ld de, 0x72c7
    sbc hl, de
    jr z, loc_8cea
    ld de, 6
loc_8ce4:
    inc a
    and a
    sbc hl, de
    jr nz, loc_8ce4
loc_8cea:
    add a, 0x11
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
    ld ix, 0x722c
    ld bc, 0
loc_8d2c:
    ld a, (0x722a)
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
    cp 0x10
    jr nc, loc_8d80
    ld a, (ix + 1)
    sub (iy + 1)
    jr c, loc_8d80
    cp 9
    jr nc, loc_8d80
    res 6, (ix + 0)
    res 5, (ix + 0)
    ld a, (iy + 4)
    and 0x00cf
    or 0x20
    ld (ix + 4), a
    bit 3, (ix + 0)
    jr nz, loc_8d7f
    set 3, (ix + 0)
    ld hl, 0x0f
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
    ld ix, 0x728e
    ld b, 7
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
    ld a, (0x722a)
    cp b
    jr nz, loc_8dc5
    call sub_b7c4
    pop bc
    ld l, 2
    jr z, loc_8e05
    push bc
loc_8dc5:
    ld de, 6
    add ix, de
    pop bc
    djnz loc_8da1
    ld ix, 0x72c7
    ld b, 3
loop_8dd3:
    push bc
    bit 7, (ix + 4)
    jr z, lost_a_life
    bit 7, (ix + 0)
    jr z, lost_a_life
    ld b, (ix + 5)
    ld a, (0x722a)
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
    call play_lose_life_sound
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
    ld a, (0x7284)
    sub (iy + 1)
    jr c, loc_8e32
    cp 0x11
    jr nc, loc_8e32
    ld a, (0x7285)
    sub (iy + 2)
    jr nc, loc_8e2c
    cpl
    inc a
loc_8e2c:
    ld d, 0
    cp 8
    jr c, loc_8e45
loc_8e32:
    ld b, 0x00c8
    dec e
    jr z, loc_8e3b
    res 6, b
    set 5, b
loc_8e3b:
    ld (iy + 0), b
    ld (iy + 4), 0x10
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
    cp 0x00b0
    jr nc, loc_8e76
    ld a, (iy + 2)
    rlca
    rlca
    rlca
    rlca
    and 0x00f0
    ld c, a
    ld a, (iy + 1)
    and 0x0f
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
    ld bc, 0x10
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
    ld bc, 0x10
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
    ld b, 0x00fc
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
    ld bc, 0x10
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
    ld bc, 0x10
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
    ld b, 0x00fc
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
    ld b, 0x00fc
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
    ld b, 0x00fc
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
    db 0x40
    dw loc_8e9a
    db 0x80
    dw loc_8ecf
    db 0x00c0
    dw loc_8ee6
    db 8
    dw loc_8f1b
    db 0x48
    dw loc_8f2a
    db 0x88
    dw loc_8f5a
    db 0x00c8
    dw loc_8f68

sub_8fb0:
;     call sub_8fc4  ; -mdl

sub_8fc4:
    ld a, (iy + 0)
    inc a
    ld (iy + 0), a
    and 3
    cp 3
;     ret  ; -mdl
    jr nz, loc_8fc2
    ld a, (iy + 0)
    and 0x00f8
    res 6, a
    set 5, a
    ld (iy + 0), a
    xor a
loc_8fc2:
    and a
    ret

deal_with_ball:
    ld a, (0x72d9)
    ld iy, 0x72d9
    bit 7, (iy + 0)
    jr z, loc_8ff1
    and 0x7f
    or 0x40
    ld (iy + 0), a
    inc (iy + 4)
    push iy
    call play_bouncing_ball_sound
    pop iy
    jr loc_9005
loc_8ff1:
    and 0x78
    jr z, loc_9071
    ld a, (iy + 3)
    call test_signal
    and a
    jr z, loc_9071
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
    jr z, locret_9073
    dec a
    jr z, ball_gets_stuck
    call sub_936f
    cp 2
    jr nz, loc_9028
    ld a, 3
    jr locret_9073
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
    ld a, 0
locret_9073:
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
    ld ix, 0x722c
    ld b, 5
loc_90a2:
    bit 7, (ix + 0)
    jr z, loc_911e
    ld a, (ix + 1)
    sub 9
    cp (iy + 1)
    jr nc, loc_911e
    add a, 0x11
    cp (iy + 1)
    jr c, loc_911e
    ld a, (ix + 2)
    sub 8
    cp (iy + 2)
    jr z, loc_90c5
    jr nc, loc_911e
loc_90c5:
    add a, 0x10
    jr c, loc_90ce
    cp (iy + 2)
    jr c, loc_911e
loc_90ce:
    bit 5, (ix + 0)
    jr z, loc_90dc
    set 4, (ix + 0)
    ld e, 4
    jr locret_912c
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
    jr z, locret_912c
    res 0, (iy + 0)
    jr loc_911a
loc_9110:
    bit 0, (iy + 0)
    jr nz, loc_911e
    set 0, (iy + 0)
loc_911a:
    set 0, d
    jr locret_912c
loc_911e:
    inc ix
    inc ix
    inc ix
    inc ix
    inc ix
    dec b
    jp nz, loc_90a2
locret_912c:
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
    and 0x0f
    bit 1, (iy + 0)
    jr z, loc_918a
    cp 0x0a
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
    and 0x0f
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
    cp 0x0e
    jr nz, loc_91bb
    set 5, e
    ld a, (iy + 2)
    and 0x0f
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
    and 0x0f
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
    cp 0x0a
    jr nz, loc_922a
    set 4, e
    ld a, (iy + 1)
    and 0x0f
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
    cp 0x0e
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
    and 0x0f
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
    ld ix, 0x728e
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
    jr locret_9336
loc_9324:
    call sub_b7c4
    push af
    ld de, 0x32
    call sub_b601
    pop af
    and a
    ld a, 2
    jr z, locret_9336
    dec a
locret_9336:
    ret

sub_9337:
    ld ix, 0x72c7
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
    jr locret_936e
loc_9363:
    call sub_b832
    ld de, 0x32
    call sub_b601
    ld a, 1
locret_936e:
    ret

sub_936f:
    ld a, (0x72bd)
    bit 6, a
    jr z, locret_9398
    ld a, (0x72bf)
    ld b, a
    ld a, (0x72be)
    ld c, a
    call sub_b5dd
    and a
    jr z, locret_9398
    ld bc, 0x0808
    ld d, 0
    ld a, 3
    call sub_b629
    ld de, 0x32
    call sub_b601
    call sub_b76d
    inc a
locret_9398:
    ret

sub_9399:
    ld a, (0x7284)
    ld b, a
    ld a, (0x7285)
    ld c, a
    call sub_b5dd
    and a
    jr z, locret_93b5
    ld hl, 0x7281
    set 6, (hl)
    push iy
    call sub_c98a
    pop iy
    ld a, 1
locret_93b5:
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
    ld ix, 0x7281
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
    jr locret_944d
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
    ld bc, 0x0808
    ld d, 0
    ld a, 4
    call sub_b629
    jr locret_944d
loc_9444:
    res 3, (iy + 0)
    ld hl, 0x7281
    set 6, (hl)
locret_944d:
    ret

byte_944e:
    db 60, 0, 120, 0, 240, 0, 104, 1, 224, 1, 0

leads_to_cherry_stuff:
    ld a, (0x726e)
    bit 6, a
    jr z, loc_9463
    xor a
    jr locret_94a8
loc_9463:
    ld iy, 0x7281  ; IY points to Mr. Do's sprite data
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
    call sub_9732
    call sub_9807
    and a
    jr nz, locret_94a8
loc_949a:
    ld hl, 0x7245
    ld b, 0x14
    xor a
loc_94a0:
    cp (hl)
    jr nz, locret_94a8
    inc hl
    djnz loc_94a0
    ld a, 2
locret_94a8:
    ret

sub_94a9:
    ld ix, 0x7088
    ld a, (0x726e)
    bit 1, a
    jr z, loc_94b8
    ld ixl, 0x8d
loc_94b8:
    bit 6, (ix + 0)
    jr nz, loc_94c4
    bit 6, (ix + 3)
    jr z, loc_9538
loc_94c4:
    ld a, (0x7281)
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
    ld (0x72db), a
    add a, 3
    jr c, loc_9538
    ld c, a
    ld a, b
    ld (0x72da), a
    jr loc_9524
loc_94ed:
    sub 6
    ld (0x72db), a
    sub 3
    jr c, loc_9538
    ld c, a
    ld a, b
    ld (0x72da), a
    jr loc_9524
loc_94fd:
    cp 3
    ld a, b
    jr nz, loc_9514
    sub 6
    ld (0x72da), a
    sub 3
    cp 0x1c
    jr c, loc_9538
    ld b, a
    ld a, c
    ld (0x72db), a
    jr loc_9524
loc_9514:
    add a, 6
    ld (0x72da), a
    add a, 3
    cp 0x00b5
    jr nc, loc_9538
    ld b, a
    ld a, c
    ld (0x72db), a
loc_9524:
    push ix
    call sub_ac3f
    ld a, (ix + 0)
    pop ix
    and 0x0f
    cp 0x0f
    jr nz, loc_9538
    ld a, 5
    jr locret_9576
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
    jr locret_9576
loc_9566:
    ld a, (iy + 4)
    and 0x0f
    cp 8
    jr z, loc_9575
loc_956f:
    pop af
    ld a, (iy + 1)
    jr locret_9576
loc_9558:
    push af
    cp 3
    jr nc, loc_9566
    ld a, (iy + 3)
    and 0x0f
    jr nz, loc_956f
;     JR      LOC_9575  ; -mdl
loc_9575:
    pop af
locret_9576:
    ret

sub_9577:
    ld ix, 0x72d9
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
loc_95ce:  ; Mr. Do intersects with an apple while facing up or down
    ld d, a
    call sub_b12d  ; Returns A=0 if no collision, A=1 if collision
    and a
    jr z, loc_95d5

    pop bc
    jp loc_961c  ; Treat as a "wall" collision

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
;     JR      LOC_95D5  ; -mdl
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
    jr locret_961e
loc_9617:
    set 5, (iy + 0)
    pop bc
loc_961c:
    ld a, 1
locret_961e:
    ret

sub_961f:  ; Mr. Do's sprite collision logic with the screen bounds
    ld (iy + 1), a
    ld b, (iy + 3)
    ld c, (iy + 4)
    cp 3  ; Check if Mr. Do is facing up or down
    jr nc, loc_964b  ; If facing up or down, jump to LOC_964B
    ld a, b
    and 0x0f
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
    cp 0x18
    jr c, loc_966d
    cp 0x00e9
    jr nc, loc_966d
    jr loc_966a
loc_964b:
    ld a, c
    and 0x0f
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
    cp 0x20
    jr c, loc_966d
    cp 0x00b1
    jr nc, loc_966d
loc_966a:
    xor a
    jr locret_966f
loc_966d:  ; Mr. Do has collided with the bounds of the screen
    ld a, 1
locret_966f:
    ret

deal_with_cherries:
    call sub_b173
    jr c, grab_some_cherries
    bit 1, (iy + 0)
    jr z, locret_96e3
    ld a, (iy + 8)
    call test_signal
    and a
    jr z, locret_96e3
    ld (iy + 7), 0
    res 1, (iy + 0)
    push iy
    call sub_c97f
    pop iy
    jr locret_96e3
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
    ld de, 0x2d  ; final cherry scores 500 not 550
    call sub_b601
    res 1, (iy + 0)
    jr locret_96e3
loc_96ca:
    ld (iy + 7), 1
    push iy
    call play_grab_cherries_sound
    pop iy
loc_96d5:
    xor a
    ld hl, 0x1e
    call request_signal
    ld (iy + 8), a
    set 1, (iy + 0)
locret_96e3:
    ret

sub_96e4:
    ld a, (0x7272)
    rla
    jr nc, locret_9731
    ld a, (iy + 3)
    cp 0x60
    jr nz, locret_9731
    ld a, (iy + 4)
    cp 0x78
    jr nz, locret_9731
    ld hl, 0x7272
    res 7, (hl)
    ld a, (hl)
    or 0x32
    ld (hl), a
    ld a, 0x0a
    ld (0x728c), a
    ld a, (0x726e)
    ld c, a
    ld a, (current_level_ram)
    bit 1, c
    jr z, loc_971b
    ld a, (0x7275)
loc_971b:
    ld hl, 0
    ld de, 0x32
loc_9721:
    add hl, de
    dec a
    jp p, loc_9721
    ex de, hl
    call sub_b601
    nop
    nop
    nop
locret_9731:
    ret

sub_9732:
    and a
    jr nz, loc_973d
    ld a, (iy + 6)
    inc a
    cp 2
    jr c, loc_973e
loc_973d:
    xor a
loc_973e:
    ld (iy + 6), a
    ld c, 1
    add a, c
    bit 5, (iy + 0)
    jr z, loc_974c
    add a, 2
loc_974c:
    ld c, a
    ld a, (iy + 1)
    cp 2
    jr nz, loc_975a
    ld a, c
    add a, 7
    ld c, a
    jr loc_9786
loc_975a:
    cp 3
    jr nz, loc_9771
    ld a, (iy + 4)
    and a
    jp p, loc_976b
    ld a, c
    add a, 0x0e
    ld c, a
    jr loc_9786
loc_976b:
    ld a, c
    add a, 0x1c
    ld c, a
    jr loc_9786
loc_9771:
    cp 4
    jr nz, loc_9786
    ld a, (iy + 4)
    and a
    jp p, loc_9782
    ld a, c
    add a, 0x15
    ld c, a
    jr loc_9786
loc_9782:
    ld a, c
    add a, 0x23
    ld c, a
loc_9786:
    ld (iy + 5), c
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
    ld hl, 0x1e
    bit 3, (iy + 0)
    jr nz, loc_97dd
    ld l, 0x0f
    bit 5, (iy + 0)
    jr nz, loc_97dd
    ld l, 7
loc_97dd:
    xor a
    call request_signal
    ld (iy + 2), a
    ld a, (iy + 0)
    and 0x00e7
    or 0x80
    ld (iy + 0), a
    ret

byte_97ef:
    db 2, 6, 14, 6, 6, 14, 6, 2, 10, 14, 10, 2, 12, 8, 4, 8, 8, 4, 8, 12, 8, 4, 8, 12

sub_9807:
    ld a, (diamond_ram)
    rla
    jr nc, loc_983f
    ld ix, 0x722c
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
    ld de, 0x03e8
    call sub_b601
    ld hl, diamond_ram
    res 7, (hl)
    ld a, 2
    jr locret_9840
loc_983f:
    xor a
locret_9840:
    ret

sub_9842:
    ld a, (0x7272)
    bit 4, a
    jr z, loc_98a2
    ld a, (0x72c3)
    bit 7, a
    jr nz, loc_986c
    ld a, (0x728b)
    call test_signal
    and a
    jr z, loc_986c
    ld hl, 0x1e
    xor a
    call request_signal
    ld (0x728b), a
    ld a, (0x728c)
    dec a
    ld (0x728c), a
    jr z, loc_9892
loc_986c:
    ld iy, 0x728e
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
    ld a, (0x7272)
    res 4, a
    ld (0x7272), a
    ld a, (0x728a)
    set 4, a
    ld (0x728a), a
loc_98a2:
    jp loc_d40b
loc_98a5:
    call sub_98ce
;     call sub_9a12  ; -mdl

sub_9a12:
    ld a, (0x728c)
    ld c, a
    ld b, 0
    ld hl, byte_9a24
    add hl, bc
    ld c, (hl)
    ld iy, 0x728e
    add iy, bc
;     ret  ; -mdl
    ld l, b
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
    ld a, (0x728c)
    inc a
    and 7
    ld (0x728c), a
loc_98cb:
    ld a, l
    and a
    ret

sub_98ce:
    push ix
    ld a, (0x728a)
    bit 3, a
    jr nz, loc_9928
    ld ix, 0x72b2
    ld a, (ix + 3)
    call test_signal
    and a
    jr z, loc_9928
    call sub_9980
    jr z, loc_991e
    call sub_992b
    jr z, loc_98f6
    ld hl, 1
    jr loc_9915
loc_98f6:
;     call sub_9962  ; -mdl

sub_9962:
    ld (iy + 0), 0x28
    ld (iy + 4), 0x81
    xor a
    ld hl, 6
    call request_signal
    ld (iy + 3), a
    ld bc, 0x6078
    ld (iy + 2), b
    ld (iy + 1), c
;     ret  ; -mdl
    ld (iy + 5), 5
    call sub_9980
    jr z, loc_991e
    ld hl, 0x00d2
    ld a, (0x728a)
    bit 2, a
    jr nz, loc_9910
    ld l, 0x1e
loc_9910:
    xor 4
    ld (0x728a), a
loc_9915:
    xor a
    call request_signal
    ld (ix + 3), a
    jr loc_9928
loc_991e:
    ld a, (0x7272)
    set 0, a
    set 7, a
    ld (0x7272), a
loc_9928:
    pop ix
    ret

sub_992b:
    push iy
    ld iy, 0x728e
    ld bc, 0x0700
loc_9934:
    ld a, (iy + 4)
    bit 7, a
    jr z, loc_994d
    bit 6, a
    jr nz, loc_994d
    ld a, (iy + 2)
    sub 0x60
    jr nc, loc_9948
    cpl
    inc a
loc_9948:
    cp 0x0d
    jr nc, loc_994d
    inc c
loc_994d:
    ld de, 6
    add iy, de
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
    ld iy, 0x728e
    ld l, 7
    ld de, 6
loc_9989:
    bit 7, (iy + 4)
    jr z, loc_999c
    add iy, de
    dec l
    jr nz, loc_9989
    ld a, (0x728a)
    set 3, a
    ld (0x728a), a
loc_999c:
    ld a, l
    and a
    ret

sub_999f:
    ld a, (0x728a)
    bit 5, a
    jr nz, loc_99bb
    set 5, a
    ld (0x728a), a
    ld hl, 0x3c
    xor a
    call request_signal
    ld ix, 0x72b2
    ld (ix + 3), a
    jr loc_9a07
loc_99bb:
    ld a, (0x728b)
    call test_signal
    and a
    jr z, locret_9a11
    ld a, (0x728d)
    ld d, a
    ld a, (0x728a)
    set 6, a
    bit 7, a
    jr z, loc_99e4
    res 7, a
    ld (0x728a), a
    inc d
    jr nz, loc_99db
    ld d, 0x00ff
loc_99db:
    ld a, d
    ld (0x728d), a
    ld a, (0x728a)
    jr loc_99e9
loc_99e4:
    set 7, a
    ld (0x728a), a
loc_99e9:
    ld e, 7
    ld bc, 6
    ld iy, 0x728e
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
    ld hl, 0x1e
    xor a
    call request_signal
    ld (0x728b), a
locret_9a11:
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
    and 0x00c7
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
    ld d, 0x0d
    bit 5, h
    jr nz, loc_9b07
    call sub_9b4f
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_ac3f
    ld d, a
    call sub_b173
    ld d, 0x19
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
    cp 0x80
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
    ld a, (0x728c)
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
    and 0x00f8
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
    and 0x3f
    ret

sub_9bb2:
    ld c, a
    ld a, (iy + 5)
    and 0x00c0
    or c
    ld (iy + 5), a
    ret

sub_9bbd:
    ld b, 0
    call sub_9ba8
    jr nz, loc_9bd7
    ld a, (iy + 0)
    and 0x00f8
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
    ld a, (0x7271)
    dec a
    ld c, a
    ld b, 0
    ld ix, byte_9d1a
    add ix, bc
    ld c, (ix + 0)
    ld hl, current_level_ram
    ld a, (0x726e)
    inc a
    and 3
    jr nz, loc_9c05
    inc l
loc_9c05:
    ld a, (hl)
    dec a
    add a, c
    ld c, a
    ld a, (0x728a)
    bit 4, a
    jr z, loc_9c12
    inc c
    inc c
loc_9c12:
    ld a, c
    cp 0x0f
    jr c, loc_9c19
    ld a, 0x0f
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
    and 0x3f
    jr z, loc_9c84
    call sub_9ba8
    jr nz, loc_9ca8
loc_9c84:
    ld a, (iy + 2)
    and 0x0f
    jr nz, loc_9ca8
    ld a, (iy + 1)
    and 0x0f
    cp 8
    jr nz, loc_9ca8
    ld a, (iy + 0)
    and 0x00f8
    res 4, a
    set 5, a
    set 3, a
    ld (iy + 0), a
    ld a, 0x0a
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
    ld a, (0x728d)
    rra
    rra
    rra
    rra
    rra
    and 7
    add a, e
    ld e, a
    call rand_gen
    and 0x0f
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
    ld a, (0x7271)
    dec a
    ld e, a
    ld d, 0
    ld hl, byte_9d1a
    add hl, de
    ld e, (hl)
    ld hl, current_level_ram
    ld a, (0x726e)
    inc a
    and 3
    jr nz, loc_9cfb
    inc l
loc_9cfb:
    ld a, (hl)
    dec a
    add a, e
    ld e, a
    ld a, (0x728a)
    bit 4, a
    jr z, loc_9d08
    inc e
    inc e
loc_9d08:
    ld a, e
    cp 0x0f
    jr c, loc_9d0f
    ld a, 0x0f
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
    jr nz, loc_9d9d
    bit 5, h
    jr nz, loc_9d9d
    push bc
    ld b, (iy + 2)
    ld c, (iy + 1)
    call sub_9e07
    pop bc
    jr nz, loc_9d9d
    dec c
    ld a, c
    cp 4
    ld a, 0
    jr nc, loc_9d9d
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
    ld bc, 0x72b8
    and a
    sbc hl, bc
    pop bc
    pop hl
    jr nc, loc_9d92
    ld a, (iy + 4)
    and 7
    call sub_9da7
    jr nz, loc_9d9d
loc_9d92:
    call sub_9e07
    jr nz, loc_9d9d
    ld (iy + 2), b
    ld (iy + 1), c
loc_9d9d:
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
    ld ix, 0x728e
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
    add a, 0x0c
    cp b
    jr c, loc_9df0
    jr loc_9ddd
loc_9dd5:
    cp b
    jr c, loc_9df0
    sub 0x0d
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
    ld a, 0x00ff
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
    and 0x0f
    ld b, a
    call rand_gen
    and 0x0f
    cp b
    jr nc, loc_9e75
    ld a, (iy + 0)
    and 0x00f8
    res 6, a
    set 5, a
    res 3, a
    ld (iy + 0), a
    ld a, 0x0a
    call sub_9bb2
loc_9e75:
    res 3, (iy + 4)
    ret

sub_9e7a:
    jr loc_9ebd

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
    and 0x0f
    cp 8
    jr c, loc_9f10
    call sub_9f29
    and a
    jr z, loc_9f10
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
    and 0x00f8
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
    and 0x00f0
    ld b, a
    ld a, (iy + 2)
    and 0x0f
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
;     JR      LOC_9FA0  ; -mdl
loc_9fa0:
    ld a, (hl)
    and 0x00f0
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
    and 0x00f0
    jr loc_9faf
loc_9f7e:
    ld a, 0x00c0
    jr loc_9faf
loc_9f82:
    bit 2, (hl)
    jr z, loc_9f8c
    bit 3, (hl)
    jr z, loc_9f8c
    set 5, a
loc_9f8c:
    ld bc, 0xfff0
    add hl, bc
    bit 0, (hl)
    jr z, loc_9faf
    bit 1, (hl)
    jr z, loc_9faf
    set 4, a
    jr loc_9faf
loc_9f9c:
    ld a, 0x30
    jr loc_9faf

unk_9fb3:
    db 0
    dw loc_9f62
    db 0x40
    dw loc_9f7e
    db 0x80
    dw loc_9f79
    db 0x00c0
    dw loc_9f7e
    db 0x88
    dw loc_9f82
    db 0x84
    dw loc_9f9c
    db 0x8c
    dw loc_9f9c

sub_9fc8:
    push iy
    ld b, (iy + 2)
    ld a, (0x7284)
    sub b
    jr nc, loc_9fd5
    cpl
    inc a
loc_9fd5:
    ld l, 0
    cp 5
    jr nc, loc_9fef
    ld b, (iy + 1)
    ld a, (0x7285)
    sub b
    jr nc, loc_9fe6
    cpl
    inc a
loc_9fe6:
    cp 5
    jr nc, loc_9fef
    call play_lose_life_sound
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
    and 0x0f
    ld c, a
    ld a, (iy + 1)
    rlca
    rlca
    rlca
    rlca
    and 0x00f0
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
    ld l, 0x00ff
    call sub_a13f
    jr z, loc_a05e
    ld l, a
loc_a05e:
    jp (ix)

loc_a060:
    ld c, 0x41
    ld a, h
    dec a
    call sub_a13f
    jr z, loc_a06f
    cp l
    jr nc, loc_a06f
    ld c, 0x82
    ld l, a
loc_a06f:
    jp loc_a102
loc_a072:
    ld c, 0x82
    ld a, h
    inc a
    call sub_a13f
    jr z, loc_a081
    cp l
    jr nc, loc_a081
    ld l, a
    ld c, 0x41
loc_a081:
    jp loc_a102
loc_a084:
    ld c, 0x13
    ld a, h
    add a, 0x10
    call sub_a13f
    jr z, loc_a094
    cp l
    jr nc, loc_a094
    ld l, a
    ld c, 0x24
loc_a094:
    jp loc_a102
loc_a097:
    ld c, 0x24
    ld a, h
    sub 0x10
    call sub_a13f
    jr z, loc_a0a7
    cp l
    jr nc, loc_a0a7
    ld l, a
    ld c, 0x13
loc_a0a7:
    jp loc_a102
loc_a0aa:
    ld l, 0x00ff
    ld a, h
    and 0x0f
    jr z, loc_a0bf
    bit 6, b
    jr z, loc_a0bf
    ld a, h
    inc a
    call sub_a13f
    jr z, loc_a0bf
    ld l, a
    ld c, 0x41
loc_a0bf:
    ld a, h
    dec a
    and 0x0f
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
    ld c, 0x82
loc_a0d6:
    ld a, h
    cp 0x11
    jr c, loc_a0ec
    bit 4, b
    jr z, loc_a0ec
    sub 0x10
    call sub_a13f
    jr z, loc_a0ec
    cp l
    jr nc, loc_a0ec
    ld l, a
    ld c, 0x13
loc_a0ec:
    ld a, h
    cp 0x91
    jr nc, loc_a102
    bit 5, b
    jr z, loc_a102
    add a, 0x10
    call sub_a13f
    jr z, loc_a102
    cp l
    jr nc, loc_a102
    ld l, a
    ld c, 0x24
loc_a102:
    ld d, 0
    ld a, l
    inc a
    jr z, loc_a124
    ld a, c
    and 7
    ld l, a
    ld a, (iy + 4)
    and 0x00f8
    or l
    ld (iy + 4), a
    inc d
    ld a, c
    and 0x00f0
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
    db 0x40
    dw loc_a060
    db 0x00c0
    dw loc_a072
    db 0x84
    dw loc_a084
    db 0x88
    dw loc_a097
    db 0x8c
    dw loc_a097
    db 0x80
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
    ld bc, 0x4f
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
    ld c, 0x50
loc_a193:
    dec bc
    add hl, bc
    pop bc
    xor a
    sbc hl, bc
    jr nc, loc_a1a0
    ld e, 0x50
    add hl, de
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
    ld a, (0x7285)
    cp h
    jr z, loc_a1bf
    jr c, loc_a1bd
    set 6, l
    jr loc_a1bf
loc_a1bd:
    set 7, l
loc_a1bf:
    ld h, (iy + 2)
    ld a, (0x7284)
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
    jr loc_a1dd
loc_a1d8:
    call sub_9e7a
    ld a, 1
loc_a1dd:
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
    and 0x0f
    cp c
    jr nc, loc_a254
loc_a21e:
    ld a, (iy + 0)
    and 0x00f8
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
    ld a, (0x72d9)
    ld b, a
    xor a
    bit 6, b
    jr z, loc_a2b9
    push de
    ld a, e
    call sub_abb7
    push bc
    ld a, (0x72da)
    ld b, a
    ld a, (0x72db)
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
    ld a, (0x72d9)
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
    cp 0x21
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
    ld a, 0x70
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
    cp 0x21
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
    ld a, 0x00b0
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
    cp 0x21
    jr nc, loc_a345
    ld a, d
    sub 0x10
    ld d, a
    bit 4, (ix + 0)
    jr z, loc_a345
    ld a, e
    cp d
    jr z, loc_a341
    push bc
    ld bc, 0xfff0
    add ix, bc
    pop bc
    bit 4, (ix + 0)
    jr z, loc_a345
loc_a341:
    ld a, 0x00d0
    jr loc_a346
loc_a345:
    xor a
loc_a346:
    pop ix
    pop hl
    pop de
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
    cp 0x21
    jr nc, loc_a37b
    ld a, d
    add a, 0x10
    ld d, a
    bit 5, (ix + 0)
    jr z, loc_a37b
    ld a, e
    cp d
    jr z, loc_a377
    push bc
    ld bc, 0x10
    add ix, bc
    pop bc
    bit 5, (ix + 0)
    jr z, loc_a37b
loc_a377:
    ld a, 0x00e0
    jr loc_a37c
loc_a37b:
    xor a
loc_a37c:
    pop ix
    pop hl
    pop de
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
    ld iy, 0x722c
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
    ld bc, 0xfff0
    add ix, bc
    pop bc
    ld a, d
    sub 0x10
    ld d, a
    ld a, (ix + 0)
    inc a
    and 0x0f
    jr nz, loc_a3ee
    ld a, h
    cp d
    jr c, loc_a3c1
    ld l, 0x00e0
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
    ld ix, 0x722c
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
    cp 0x21
    jr nc, loc_a44d
    ld a, c
    sub e
    jr nc, loc_a433
    cpl
    inc a
loc_a433:
    cp 0x11
    jr nc, loc_a44d
    ld hl, 224
    ld a, (iy + 1)
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
    jr z, locret_a496
loc_a465:
    ld l, a
    push hl
    call sub_9e7a
    ld a, (iy + 4)
    and 7
    call sub_9d2f
    pop hl
    jr z, locret_a496
    ld a, (iy + 4)
    and 7
    ld c, 0x00c0
    cp 3
    jr nc, loc_a482
    ld c, 0x30
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
;     JR      LOCRET_A496  ; -mdl
locret_a496:
    ret

sub_a497:
    ld a, (iy + 2)
    ld b, a
    and 0x0f
    jr nz, loc_a512
    ld a, (iy + 1)
    ld c, a
    and 0x0f
    cp 8
    jr nz, loc_a512
    ld h, 0
    ld a, (0x7284)
    cp b
    jr z, loc_a4b9
    jr nc, loc_a4b7
    set 4, h
    jr loc_a4b9
loc_a4b7:
    set 5, h
loc_a4b9:
    ld a, (0x7285)
    cp c
    jr z, loc_a520
    ld a, c
    jr c, loc_a4c8
    set 6, h
    add a, 0x10
    jr loc_a4cc
loc_a4c8:
    set 7, h
    sub 0x10
loc_a4cc:
    ld c, a
    ld ix, 0x722c
    ld l, 5
loc_a4d3:
    bit 7, (ix + 0)
    jr z, loc_a4f3
    ld a, (ix + 1)
    sub 9
    cp b
    jr nc, loc_a4f3
    add a, 0x12
    cp b
    jr c, loc_a4f3
    ld a, (ix + 2)
    sub 0x0f
    cp c
    jr nc, loc_a4f3
    add a, 0x1f
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
    and 0x30
    ld h, a
    jr nz, loc_a520
    set 4, h
    ld a, (iy + 2)
    cp 0x30
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
    ld a, (0x726e)
    ld b, a
    ld a, (0x7278)
    bit 0, b
    jr z, loc_a53a
    bit 1, b
    jr z, loc_a53a
    ld a, (0x7279)
loc_a53a:
    cp 1
    pop bc
    ret

sub_a53e:
    ld a, (0x72ba)
    bit 7, a
    jr nz, loc_a551
    set 7, a
    ld (0x72ba), a
    ld a, 0x40
    ld (0x72bd), a
    jr loc_a5a6
loc_a551:
    ld a, (0x72bd)
    bit 7, a
    ld a, 0
    jr nz, loc_a5bb
    ld a, (0x72c0)
    call test_signal
    and a
    jr z, loc_a5bb
    ld a, (0x72ba)
    bit 6, a
    jr z, loc_a56f
    call sub_a6bb
    jr loc_a5aa
loc_a56f:
    ld a, (0x7272)
    bit 5, a
    jr nz, loc_a57b
    call sub_a61f
    jr z, loc_a591
loc_a57b:
    call sub_a5f9
    jr nz, loc_a591
    call sub_a662
    ld hl, 0x7272
    bit 5, (hl)
    jr z, loc_a5a9
    res 5, (hl)
    call sub_b8a3
    jr loc_a5a9
loc_a591:
    jp loc_d309


loc_a596:
    ld a, (0x7272)
    bit 4, a
    jr nz, loc_a5a9
    ld hl, 0x72c2
    dec (hl)
    jr nz, loc_a5a9
loc_a5a6:
    call sub_a5bd
loc_a5a9:
    xor a
loc_a5aa:
    push af
    ld hl, 0x0a
    xor a
    call request_signal
    ld (0x72c0), a
    pop af
    push af
    call sub_a788
    pop af
loc_a5bb:
    and a
    ret

sub_a5bd:
    ld a, (0x72ba)
    inc a
    and 0x00f7
    ld (0x72ba), a
    ld hl, byte_a5f1
    ld a, (0x72ba)
    and 7
    ld c, a
    ld b, 0
    add hl, bc
    ld a, (hl)
    ld (0x72be), a
    ld a, 0x0c
    ld (0x72bf), a
    ld hl, byte_a616
    add hl, bc
    ld a, (hl)
    ld (0x72bc), a
    ld hl, byte_a617
    add hl, bc
    ld a, (hl)
    ld (0x72bb), a
    ld a, 0x18
    ld (0x72c2), a
    ret

byte_a5f1:
    db 91, 107, 123, 139, 155, 139, 123, 107

sub_a5f9:
    ld a, (0x72ba)
    and 7
    ld c, a
    ld b, 0
    ld hl, byte_a617
    add hl, bc
    ld b, (hl)
    ld hl, 0x72b8
    ld a, (0x726e)
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
    ld bc, (score_p1_ram)
    ld hl, 0x727a
    ld a, (0x726e)
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
    sub 0x00f4
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
    ld a, (0x72ba)
    ld b, a
    bit 6, a
    jr nz, loc_a65f
    ld a, (0x72ba)
    set 5, a
    ld (0x72ba), a
    inc e
loc_a65f:
    ld a, e
    and a
    ret

sub_a662:
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, loc_a66f
    ld a, (0x7275)
loc_a66f:
    cp 0x0b
    jr c, loc_a677
    sub 0x0a
    jr loc_a66f
loc_a677:
    cp 4
    jr nz, loc_a67f
    ld a, 0x98
    jr loc_a681
loc_a67f:
    ld a, 0x78
loc_a681:
    ld (0x72be), a
    ld a, 0x20
    ld (0x72bf), a
    ld a, 0x0c
    ld (0x72c2), a
    ld a, (0x72ba)
    set 6, a
    ld (0x72ba), a
    ld a, (0x7272)
    bit 5, a
    jr nz, loc_a6ab
    ld hl, 0x72c4
    set 0, (hl)
    ld hl, 0x05a0
    call request_signal
    ld (0x726f), a
loc_a6ab:
    ld a, (0x72ba)
    bit 5, a
    jr z, locret_a6ba
    res 5, a
    ld (0x72ba), a
    jp loc_d31c
locret_a6ba:
    ret

sub_a6bb:
    push ix
    push iy
    ld a, (0x72c4)
    bit 0, a
    jr z, loc_a6f2
    call sub_a61f
    ld a, (0x726f)
    call test_signal
    and a
    jr z, loc_a6f2
    ld hl, 0x72c4
    res 0, (hl)
    ld a, 0x40
    ld (0x72bd), a
    ld a, 1
    ld (0x72c2), a
    ld a, (0x72ba)
    res 6, a
    res 5, a
    ld (0x72ba), a
    call sub_ca24
    xor a
    jp loc_a77e
loc_a6f2:
    ld iy, 0x72bd
    set 4, (iy + 0)
    call sub_9f29
    ld d, a
    push de
    ld hl, 0x7272
    bit 5, (hl)
    jr z, loc_a70b
    res 5, (hl)
    call sub_b8a3
loc_a70b:
    call sub_a527
    pop de
    jr z, loc_a74b
    ld a, (0x728a)
    bit 4, a
    jr nz, loc_a74b
loc_a718:
    ld a, (0x72c2)
    dec a
    ld (0x72c2), a
    jr nz, loc_a72f
    ld a, 0x0c
    ld (0x72c2), a
    call rand_gen
    and 0x0f
    cp 7
    jr nc, loc_a76b
loc_a72f:
    ld a, (0x72c1)
    and 0x0f
    ld c, a
    ld b, 0
    ld hl, byte_a783
    add hl, bc
    ld a, (hl)
    and d
    jr z, loc_a76b
    ld a, (0x72c1)
    and 0x0f
    call sub_9d2f
    jr z, loc_a77b
    jr loc_a76b
loc_a74b:
    ld a, (0x72bf)
    ld b, a
    ld a, (0x72be)
    ld c, a
    push de
    call sub_ac3f
    pop bc
    call sub_a028
    jr z, loc_a718
    cp 2
    jr z, loc_a76b
    ld a, (0x72c1)
    and 7
    call sub_9d2f
    jr z, loc_a77b
loc_a76b:
    call sub_9f29
    jr z, loc_a77b
    call sub_9e7a
    ld a, (0x72c1)
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
    ld a, (0x7272)
    bit 4, a
    jr z, loc_a796
    ld a, (0x72ba)
    bit 6, a
    jr z, locret_a7db
loc_a796:
    ld a, (0x726e)
    bit 1, a
    ld ix, 0x72b8
    jr z, loc_a7a5
    inc ixl
loc_a7a5:
    ld a, (0x72ba)
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
    ld a, (0x72ba)
    bit 5, a
    jr z, loc_a7c8
    res 5, a
    jr loc_a7cb
loc_a7c8:
    set 5, a
    inc d
loc_a7cb:
    ld (0x72ba), a
    ld a, (0x72bf)
    ld b, a
    ld a, (0x72be)
    ld c, a
    ld a, 3
    call sub_b629
locret_a7db:
    ret

byte_a7dc:
    db 1, 1, 12, 2, 3, 14, 4, 5, 16, 8, 7, 18, 16, 9, 20, 8, 7, 18, 4, 5, 16, 2, 3, 14

sub_a7f4:
    ld a, (0x72c5)
    and 3
    ld iy, 0x72c7
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
    call sub_a92c
    jr loc_a82c
loc_a82b:
    xor a
loc_a82c:
    push af
    ld hl, 0x72c5
    inc (hl)
    ld a, (hl)
    and 3
    cp 3
    jr nz, loc_a83c
    ld a, (hl)
    and 0x00fc
    ld (hl), a
loc_a83c:
    pop af
    ret

sub_a83e:
    jp loc_d383

loc_a853:
    call sub_a460
    jr locret_a8c6
loc_a858:
    ld a, (iy + 2)
    and 0x0f
    jr nz, loc_a868
    ld a, (iy + 1)
    and 0x0f
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
    ld h, 0x00f0
    ld a, (iy + 2)
    cp 0x28
    jr nc, loc_a883
    res 4, h
loc_a883:
    cp 0x00a8
    jr c, loc_a889
    res 5, h
loc_a889:
    ld a, (iy + 1)
    cp 0x20
    jr nc, loc_a892
    res 7, h
loc_a892:
    cp 0x00e0
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
    jr z, locret_a8c6
    ld a, (iy + 4)
    jp loc_d3d5

loc_a8af:
    jr nc, loc_a8b3
    ld c, 0x30
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
locret_a8c6:
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
    ld a, (0x72c5)
    add a, a
    add a, a
    ld c, a
    ld b, 0
    ld hl, 0x712f
    add hl, bc
    ld a, (hl)
    cp 0x00e0
    jr z, loc_a905
    cp 0x00e4
    jr z, loc_a905
    inc d
    inc d
loc_a905:
    ld a, (iy + 5)
    bit 7, a
    jr z, loc_a90d
    inc d
loc_a90d:
    xor 0x80
    ld (iy + 5), a
    ld b, (iy + 2)
    ld c, (iy + 1)
    ld a, (0x72c5)
    add a, 0x11
    jp sub_b629

sub_a921:
    call sub_9be2
    xor a
    call request_signal
    ld (iy + 3), a
    ret

sub_a92c:
    jp sub_9fc8
completed_level:
    push af
    ld hl, 0x1e
    xor a
    call request_signal
    push af
loc_a956:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_a956
    pop af
    pop af
    cp 2
    jr nz, loc_a969
;     call deal_with_end_of_round_tune  ; -mdl

deal_with_end_of_round_tune:
    call play_end_of_round_tune
    ld hl, 0x0103
    call request_signal
    push af
loc_a992:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_a992
    pop af
;     ret  ; -mdl
    jr loc_a96c
loc_a969:
    call sub_a99c
loc_a96c:
;     call sub_aa25  ; -mdl

sub_aa25:
    ld hl, 0x726e
    set 7, (hl)
loc_aa2a:
    bit 7, (hl)
    jr nz, loc_aa2a
    ld hl, current_level_ram
    ld ix, 0x7278
    ld a, (0x726e)
    bit 1, a
    jr z, loc_aa43
    inc ixl
    inc l
loc_aa43:
    ld (ix + 0), 7
    inc (hl)
    ld a, (hl)
    call sub_b286
    ld hl, 0x718a
    ld de, 0x3400
    ld a, (0x726e)
    bit 1, a
    jr z, loc_aa5c
    set 1, d
loc_aa5c:
    ld bc, 0x00d4
    call write_vram
    ld bc, 0x01e2
    call write_register
;     ret  ; -mdl
    ld a, 2
    jr locret_a987

got_diamond:
    ld hl, diamond_ram
    ld (hl), 0
    cp 1
    jr nz, completed_level
    ld hl, 0x78
    xor a
    call request_signal
    push af
no_diamond:
    pop af
    push af
    call test_signal
    and a
    jr z, no_diamond
    pop af
;     JR      LOC_A973  ; -mdl
loc_a973:
    call sub_aa69
    cp 1
    jr z, locret_a987
    and a
    jr z, loc_a984
;     call sub_aadc  ; -mdl

sub_aadc:
    push af
    ld hl, 0x726e
    set 7, (hl)
loc_aae2:
    bit 7, (hl)
    jr nz, loc_aae2
    ld hl, 0x1000
    ld de, 0x0300
    xor a
    call fill_vram
    ld hl, 0x1900
    ld de, 0x80
    xor a
    call fill_vram
    ld hl, sprite_name_table
    ld b, 0x50
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
    ld bc, 0x01e2
    call write_register
    xor a
    ld hl, 0x00b4
    call request_signal
    push af
loc_ab1e:
    pop af
    push af
    call test_signal
    and a
    jr z, loc_ab1e
    pop af
;     ret  ; -mdl
    ld a, 1
    jr locret_a987
loc_a984:
    call sub_ab28
locret_a987:
    ret

sub_a99c:  ; CONGRATULATIONS! YOU WIN AN EXTRA MR. DO! TEXT and MUSIC
    ld hl, 0x726e
    set 7, (hl)
loc_a9a1:
    bit 7, (hl)
    jr nz, loc_a9a1

;     LD      HL, 1000H ; Pattern generator table
;     LD      DE, 300H  ; 768 characters
;     LD      A, 0 ; fill with 0s
;     CALL    FILL_VRAM
;     LD      HL, 1900H ; 
;     LD      DE, 80H ; 128 characters
;     LD      A, 0 ; fill with 0s
;     CALL    FILL_VRAM
;     LD      HL, SPRITE_NAME_TABLE
;     LD      B, 50H
; LOC_A9C0:
;     LD      (HL), 0
;     INC     HL
;     DJNZ    LOC_A9C0
;     LD      A, 6
;     CALL    DEAL_WITH_PLAYFIELD
;     LD      BC, 70CH
;     CALL    WRITE_REGISTER
    xor a
    ld (0x72bc), a
    ld (0x72bb), a
    ld hl, 0x726e
    bit 1, (hl)
    jr nz, deal_with_extra_mr_do
    ld l, lives_left_p1_ram
    ld (0x72b8), a
    jr loc_a9ec
deal_with_extra_mr_do:
    ld (0x72b9), a
    ld hl, lives_left_p2_ram
loc_a9ec:
    ld a, (hl)
    cp 6
    jr nc, loc_a9f2
    inc (hl)
loc_a9f2:
    ld bc, 0x01e2
    call write_register
    call initialize_the_sound
    call play_win_extra_do_tune

; %%%%%%%%%%%%%%%%%%%%%%%%%%
; show the extra screen
    ld hl, mode
    set 7, (hl)  ; switch to intermission  mode

    call cvb_extrascreen

    ld hl, 0x0280
    xor a
    call request_signal
    push af
loc_aa06:  ; wait for music 
    pop af
    push af
    call test_signal
    and a
    jr z, loc_aa06
    pop af

    ld hl, 0x1900  ; remove all sprites 
    ld de, 0x80  ; 128 characters
    xor a  ; fill with 0s
    call fill_vram
    ld hl, sprite_name_table
    ld b, 0x50  ; remove 20 sprites
loc_a9c0:
    ld (hl), 0
    inc hl
    djnz loc_a9c0

    ld hl, mode
    res 7, (hl)  ; switch to game mode

    call init_vram
    ld hl, 0x726e
    set 7, (hl)
loc_aa14:
    bit 7, (hl)
    jr nz, loc_aa14

; Original code's final register writes
    ld bc, 0x0700  ; R7: Border/background color
    call write_register
    ld bc, 0x01e2  ; Original game state register
    jp write_register


sub_aa69:
    ld hl, 0x726e
    set 7, (hl)
loc_aa6e:
    bit 7, (hl)
    jr nz, loc_aa6e
    ld de, 0x3400
    bit 1, (hl)
    jr z, loc_aa7c
    set 1, d
loc_aa7c:
    ld hl, 0x718a
    ld bc, 0x00d4
    call write_vram
    ld bc, 0x01e2
    call write_register
    ld ix, lives_left_p1_ram
    ld iy, lives_left_p2_ram
    ld hl, 0x726e
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
    jr locret_aadb
loc_aabd:
    dec (iy + 0)
    jr z, loc_aace
    ld a, (ix + 0)
    and a
    jr z, loc_aaca
    res 1, (hl)
loc_aaca:
    ld a, 1
    jr locret_aadb
loc_aace:
    ld a, (ix + 0)
    and a
    jr z, loc_aada
    res 1, (hl)
    ld a, 3
    jr locret_aadb
loc_aada:
    xor a
locret_aadb:
    ret

sub_ab28:
    ld hl, 0x726e
    set 7, (hl)
loc_ab2d:
    bit 7, (hl)
    jr nz, loc_ab2d
    ld hl, 0x1900
    ld de, 0x80
    xor a
    call fill_vram
    ld hl, sprite_name_table
    ld b, 0x50
loc_ab40:
    ld (hl), 0
    inc hl
    djnz loc_ab40
    ld a, 9
    call deal_with_playfield
    ld bc, 0x01e2
    call write_register
    call play_game_over_tune
    ld hl, 0x0168
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
    ld hl, 0x04b0
    xor a
    call request_signal
    push af
loc_ab6c:
    ld a, (keyboard_p1)
    cp 0x0a
    jr z, loc_aba5
    cp 0x0b
    jr z, loc_aba9
    ld a, (keyboard_p2)
    cp 0x0a
    jr z, loc_aba5
    cp 0x0b
    jr z, loc_aba9
    pop af
    push af
    call test_signal
    and a
    jr z, loc_ab6c
    ld hl, 0x726e
    set 7, (hl)
loc_ab8f:
    bit 7, (hl)
    jr nz, loc_ab8f
    ld hl, 0x1000
    ld de, 0x0300
    xor a
    call fill_vram
    ld bc, 0x01e2
    call write_register
    jr loc_ab6c
loc_aba5:
    pop af
    xor a
    jr locret_abb5
loc_aba9:
    ld hl, 0x726e
    set 7, (hl)
loc_abae:
    bit 7, (hl)
    jr nz, loc_abae
    pop af
    ld a, 3
locret_abb5:
    ret

sub_abb7:
    ld bc, 8200
    ld d, 0
    dec a
loc_abbe:
    cp 0x10
    jr c, loc_abc7
    sub 0x10
    inc d
    jr loc_abbe
loc_abc7:
    ld e, a
loc_abc8:
    and e
    or e
    jr z, loc_abd4
    ld a, c
    add a, 0x10
    ld c, a
    dec e
    jr loc_abc8
loc_abd4:
    ld a, d
    cp 0
    jr z, locret_abe0
    ld a, b
    add a, 0x10
    ld b, a
    dec d
    jr loc_abc8
locret_abe0:
    ret

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
    sub 0x18
loc_ac45:
    sub 0x10
    jr c, loc_ac51
    push af
    ld a, d
    add a, 0x10
    ld d, a
    pop af
    jr loc_ac45
loc_ac51:
    ld a, c
loc_ac52:
    sub 0x10
    jr c, loc_ac59
    inc d
    jr loc_ac52
loc_ac59:
    ld a, d
    dec a
    ld b, 0
    ld c, a
    ld ix, 0x718a
    add ix, bc
    ld a, d
    pop bc
    ret

deal_with_playfield_map:
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
    jr z, locret_acff
    dec a
    xor (ix + 0)
    jr nz, loc_acf6
    inc ix
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
    ld b, (ix + 0)
    ld (hl), b
    inc hl
    inc ix
    jr loc_acd5
locret_acff:
    ret

deal_with_sprites:
    ld b, 0
    ld c, a
    ld ix, sprite_generator
    add ix, bc
    sla c
    rl b
    rl c
    rl b
    add ix, bc
    ld a, (ix + 0)
    and a
    jr nz, loc_ad32
    ld e, (ix + 1)
    ld d, (ix + 2)
    ld l, (ix + 3)
    ld h, (ix + 4)
    ld iy, 4
    ld a, 1
    call put_vram
    jr locret_ad95
loc_ad32:
    ld l, (ix + 3)
    ld h, (ix + 4)
    ld e, (ix + 1)
    ld d, (ix + 2)
    push de
    pop ix
    ld b, 4
loop_ad43:
    push bc
    push af
    push hl
    push ix
    ld iy, 0x72e7
    cp 1
    jr nz, loc_ad55
;     call sub_ad96  ; -mdl

sub_ad96:
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
    jr loc_ad73
loc_ad55:
    cp 2
    jr nz, loc_ad5e
    call sub_adab
    jr loc_ad73
loc_ad5e:
    cp 3
    jr nz, loc_ad67
    call sub_adca
    jr loc_ad73
loc_ad67:
    cp 4
    jr nz, loc_ad70
    call sub_ade9
    jr loc_ad73
loc_ad70:
    call sub_ae0c
loc_ad73:
    pop ix
    ld e, (ix + 0)
    ld d, 0
    inc ix
    push ix
    ld hl, 0x72e7
    ld iy, 1
    ld a, iyl
    call put_vram
    pop ix
    pop hl
    ld bc, 8
    add hl, bc
    pop af
    pop bc
    djnz loop_ad43
locret_ad95:
    ret

sub_adab:
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
    ret

sub_adca:
    ld c, 8
    push hl
    ld d, 0x80
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
    ret

sub_ade9:
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
    ret

sub_ae0c:
    ld bc, 7
    add hl, bc
    ld d, 0x80
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
    ret

deal_with_playfield:
    dec a
    add a, a
    ld c, a
    ld b, 0
    ld hl, byte_be21
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld ix, playfield_table
    add ix, bc
    ld l, (ix + 0)
    ld h, (ix + 1)
loc_ae47:
    ld a, (hl)
    cp 0x00ff
    jr z, locret_ae87
    cp 0x00fe
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
    cp 0x00fd
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
    ld iy, 1
    ld a, 2
    call put_vram
    pop de
    pop hl
    inc de
    inc hl
    jr loc_ae47
locret_ae87:
    ret

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
    add a, 0x00d8
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
    ld a, 0x4f
loc_aec1:
    ld e, a
    ld d, 0
    ld hl, badguy_behavior_ram
    add hl, de
    ld a, (hl)
    cp b
    jr z, locret_aee0
    ld a, (badguy_bhvr_cnt_ram)
    ld e, a
    ld hl, badguy_behavior_ram
    add hl, de
    ld (hl), b
    inc a
    cp 0x50
    jr c, loc_aedd
    xor a
loc_aedd:
    ld (badguy_bhvr_cnt_ram), a
locret_aee0:
    ret

sub_aee1:  ; Apple Pushing/Intersection logic
    push af
    ld h, 0
loc_aee4:
    ld e, d
    dec e
    ld a, c
    jr nz, loc_aef1
    add a, 0x0c
    jp c, loc_aff5
    jr loc_aef6
loc_af26:
    ld a, (ix + 0)
    and 0x78
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
    and 0x0f
    cp 8
    ld a, (ix + 0)
    jr nc, loc_af60
    and 5
    cp 5
    jr nz, loc_af6e
    jr loc_af66
loc_af60:
    and 0x0a
    cp 0x0a
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
    sub 0x0c
    jp c, loc_aff5
loc_aef6:
    ld c, a
    ld e, 5
    ld ix, 0x722c
loc_aefd:
    bit 7, (ix + 0)
    jr z, loc_af1a
    ld a, (ix + 2)
    cp c
    jr nz, loc_af1a
    ld a, (ix + 1)
    cp b
    jr z, loc_af26
    sub 0x10
    cp b
    jr nc, loc_af1a
    add a, 0x1f
    cp b
    jp nc, loc_b061
loc_af1a:
    push de
    ld de, 5
    add ix, de
    pop de
    dec e
    jr nz, loc_aefd
;     JR      LOC_AF76  ; -mdl
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
    ld ix, 0x728e
    ld l, 7
loc_af8b:
    bit 7, (ix + 4)
    jr z, loc_afbf
    bit 6, (ix + 4)
    jr nz, loc_afbf
    ld a, (0x7272)
    bit 4, a
    jr nz, loc_afa5
    ld a, (ix + 0)
    and 0x30
    jr z, loc_afbf
loc_afa5:
    ld a, (ix + 2)
    sub 0x0c
    cp b
    jr nc, loc_afbf
    add a, 0x18
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
loc_afd7:  ; BADGUY PUshes APPLE
    ld a, (0x7284)
    sub 0x0c
    cp b
    jr nc, loc_aff6
    add a, 0x18
    cp b
    jr c, loc_aff6
    ld a, (0x7285)
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
    sub 0x0c
    jr loc_b008
loc_b006:
    add a, 0x0c
loc_b008:
    ld c, a
    ld ix, 0x722c
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
    cp 0x00e9
    jr nc, loc_b061
    jr loc_b035
loc_b02f:
    sub 4
    cp 0x18
    jr c, loc_b061
loc_b035:
    ld (ix + 2), a
    push bc
    push de
    push hl
    push ix
    ld c, a
    ld b, (ix + 1)
    ld a, 0x11
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
    ld iy, 0x728e
    ld hl, 0x0207
loc_b070:
    ld a, (iy + 4)
    bit 7, a
    jp z, loc_b105
    add a, a
    jp m, loc_b105
    ld a, (iy + 0)
    and 0x30
    jp nz, loc_b105
loc_b085:
    ld a, (iy + 2)
    sub b
    jr nc, loc_b08d
    cpl
    inc a
loc_b08d:
    cp 0x10
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
    ld a, (0x72ba)
    bit 6, a
    jr z, loc_b123
    ld iy, 0x72bd
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
;     JR      LOC_B126  ; -mdl
loc_b126:
    ld a, 1
loc_b128:
    pop hl
    pop iy
    and a
    ret

sub_b12d:  ; Mr. Do sprite intersection with apples from above and below
    ld ix, 0x722c  ; IX points to the first apple's sprite data
    ld e, 5  ; Number of apples to check
; Modified to offset the value used to detect a vertical collision
; with an apple so that Mr. Do doesn't get stuck in the apple from
; above or below.
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
    cp 0x0d
    jr nc, loc_b163
    jr loc_b156
loc_b149:
    sub (ix + 1)
    jr z, loc_b156
    jr nc, loc_b163
    cpl
    inc a
    cp 0x0d
    jr nc, loc_b163
loc_b156:
    ld a, (ix + 2)
    add a, 9
    cp c
    jr c, loc_b163
    sub 0x12
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
    jr locret_b172
loc_b170:
    ld a, 1
locret_b172:
    ret

sub_b173:
    ld a, d
    push af
    ld hl, 0x7245
    call sub_ac0b
    jr z, loc_b198
    pop af
    push af
    dec a
    ld c, a
    ld b, 0
    ld hl, 0x718a
    add hl, bc
    ld a, (hl)
    and 0x0f
    cp 0x0f
    jr nz, loc_b198
    pop af
    ld hl, 0x7245
    call sub_abf6
    scf
    jr locret_b19a
loc_b198:
    pop af
    and a
locret_b19a:
    ret

display_play_field_parts:
    push af
    cp 0x48
    jp z, loc_b24e
    dec a
    ld c, a
    ld b, 0
    ld iy, 0x718a
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
    ld hl, 0x7245
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
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, loc_b1e6
    ld a, (0x7275)
loc_b1e6:
    cp 0x0b
    jr c, loc_b1ee
    sub 0x0a
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
    db 80, 81, 82, 80, 83, 82, 84, 80, 82, 83

sub_b286:
    cp 0x0b
    jr c, loc_b28e
    sub 0x0a
    jr sub_b286
loc_b28e:
    push af
    ld hl, 0x718a
    ld (hl), 0
    ld de, 0x718b
    ld bc, 0x9f
    ldir
    ld hl, 0x718a
    call deal_with_playfield_map
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
    ld de, 0x7245
    ld c, 0x14
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
    ld iy, 0x722c
loop_b2db:
    ld a, (hl)
    push hl
    push bc
    call sub_abb7
    ld (iy + 0), 0x80
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
    and 0x0f
    cp 8
    jr nz, loc_b32c
    ld a, (ix + 0)
    and 0x0a
    cp 0x0a
    jr z, loc_b31d
    ld e, 1
    set 1, (ix + 0)
    set 3, (ix + 0)
loc_b31d:
    push ix
    push de
    ld a, d
    ld hl, 0x7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b399
loc_b32c:
    and a
    jr nz, loc_b370
    ld a, (ix + 0)
    and 0x85
    cp 0x85
    jr z, loc_b342
    ld e, 1
    ld a, (ix + 0)
    or 0x85
    ld (ix + 0), a
loc_b342:
    push de
    push ix
    ld a, d
    ld hl, 0x7259
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
    ld hl, 0x7259
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
    ld c, 0x80
    ld a, (ix + 0)
    dec ix
    and 5
    cp 5
    jr z, loc_b399
    ld b, d
    inc b
    jr loc_b397
loc_b38b:
    ld c, 0x84
    ld a, (ix + 0)
    and 0x0a
    cp 0x0a
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
    and 0x0f
    jr nz, loc_b3ec
    bit 7, (ix + 0)
    jr nz, loc_b3b7
    ld e, 1
    set 7, (ix + 0)
loc_b3b7:
    push de
    push ix
    ld a, d
    ld hl, 0x7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    dec ix
    dec d
    ld a, (ix + 0)
    cpl
    and 0x4a
    jr z, loc_b3e0
    pop de
    ld e, 1
    push de
    dec d
    ld a, (ix + 0)
    or 0x4a
    ld (ix + 0), a
loc_b3e0:
    ld a, d
    ld hl, 0x7259
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
    ld hl, 0x7259
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
    ld c, 0x85
    ld a, (ix + 0)
    and 5
    cp 5
    jr z, loc_b43b
    ld b, d
    jr loc_b439
loc_b428:
    ld c, 0x81
    dec ix
    ld a, (ix + 0)
    inc ix
    and 0x0a
    cp 0x0a
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
    and 0x0f
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
    ld hl, 0x7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    ld bc, 0xfff0
    add ix, bc
    ld a, (ix + 0)
    xor b
    and 0x2c
    jr z, loc_b485
    pop de
    ld e, 1
    push de
    ld a, (ix + 0)
    or 0x2c
    ld (ix + 0), a
loc_b485:
    ld a, d
    sub 0x10
    ld hl, 0x7259
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
    ld hl, 0x7259
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
    ld c, 0x82
    jr loc_b4e3
loc_b4ca:
    ld bc, 0xfff0
    add ix, bc
    ld a, (ix + 0)
    ld bc, 0x10
    add ix, bc
    and 0x0c
    cp 0x0c
    jr z, loc_b4e5
    ld a, d
    sub c
    ld b, a
    ld c, 0x86
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
    and 0x0f
    cp 8
    jr nz, loc_b53b
    ld a, (ix + 0)
    and 0x13
    cp 0x13
    jr z, loc_b50a
    ld e, 1
    ld a, (ix + 0)
    or 0x13
    ld (ix + 0), a
loc_b50a:
    push de
    push ix
    ld a, d
    ld hl, 0x7259
    call sub_abe1
    pop ix
    pop de
    push ix
    push de
    ld bc, 0xfff0
    add ix, bc
    bit 5, (ix + 0)
    jr nz, loc_b52d
    pop de
    ld e, 1
    push de
    set 5, (ix + 0)
loc_b52d:
    ld a, d
    sub 0x10
    ld hl, 0x7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b58d
loc_b53b:
    and a
    jr nz, loc_b560
    ld a, (ix + 0)
    and 0x0c
    cp 0x0c
    jr z, loc_b551
    ld e, 1
    set 2, (ix + 0)
    set 3, (ix + 0)
loc_b551:
    push ix
    push de
    ld a, d
    ld hl, 0x7259
    call sub_abe1
    pop de
    pop ix
    jr loc_b58d
loc_b560:
    cp 4
    jr nz, loc_b57f
    ld bc, 0x10
    add ix, bc
    ld a, (ix + 0)
    ld bc, 0xfff0
    add ix, bc
    and 0x0c
    cp 0x0c
    jr z, loc_b58d
    ld a, d
    add a, 0x10
    ld b, a
    ld c, 0x87
    jr loc_b58b
loc_b57f:
    ld a, (ix + 0)
    and 3
    cp 3
    jr z, loc_b58d
    ld b, d
    ld c, 0x83
loc_b58b:
    ld e, 1
loc_b58d:
    pop hl
    pop iy
    ret

sub_b591:
    ld hl, 0x60
    ld de, 0x40
    dec a
loc_b598:
    cp 0x10
    jr c, loc_b5a1
    add hl, de
    sub 0x10
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
    ld hl, 0x72e7
    call loc_ae88
    ld a, 0x00d8
    ld (0x72ec), a
    ld a, 2
    pop hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld hl, 0x72e7
    ld iy, 6
    jp put_vram

byte_b5d4:
    db 125, 114, 36, 0, 127, 114, 68, 0, 0

sub_b5dd:  ; Ball collision detection
    ld a, b
    sub 7
    cp (iy + 1)
    jr nc, loc_b5ff
    add a, 0x0e
    cp (iy + 1)
    jr c, loc_b5ff
    ld a, c
    sub 7
    cp (iy + 2)
    jr nc, loc_b5ff
    add a, 0x0e
    cp (iy + 2)
    jr c, loc_b5ff
    ld a, 1
    jr locret_b600
loc_b5ff:
    xor a
locret_b600:
    ret

sub_b601:
    ld ix, score_p1_ram
    ld c, 0x80
    ld a, (0x726e)
    bit 1, a
    jr z, loc_b614
    ld c, 0x40
    ld ixl, score_p2_ram
loc_b614:
    ld l, (ix + 0)
    ld h, (ix + 1)
    add hl, de
    ld (ix + 0), l
    ld (ix + 1), h
    ld a, (0x727c)
    or c
    ld (0x727c), a

    ret

sub_b629:
    ld ix, 0x72df
    bit 7, a
    jr z, loc_b637
    and 0x7f
    ld ixl, 0xe7
loc_b637:
    push af
    push de
    add a, a
    ld e, a
    ld d, 0
    ld hl, off_b691
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
    ld a, (0x726e)
    set 3, a
    ld (0x726e), a
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
    ld a, (0x726e)
    res 3, a
    ld (0x726e), a
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
    db 176, 15, 148, 15  ; Patterns 176,148 use White

byte_b6cb:
    db 180, 3, 160, 3  ; Patterns 180,160 use Light Green

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
    ld a, 0x40
    ld (0x72bd), a
    ld hl, 0x72c4
    bit 0, (hl)
    jr z, loc_b781
    res 0, (hl)
    ld a, (score_p1_ram)
    call free_signal
loc_b781:
    call sub_ca24
    ld a, 1
    ld (0x72c2), a
    ld a, (0x72ba)
    res 6, a
    res 5, a
    ld (0x72ba), a
    and 7
    ld c, a
    ld b, 0
    ld hl, byte_b7bc
    add hl, bc
    ld b, (hl)
    ld hl, 0x72b8
    ld a, (0x726e)
    inc a
    and 3
    jr nz, loc_b7aa
    inc l
loc_b7aa:
    ld c, 0
    ld a, (hl)
    or b
    ld (hl), a
    cp 0x1f
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
    ld (ix + 4), 0x00c0
    ld a, 8
    ld b, a
    ld c, a
    call sub_b7ef
    add a, 5
    ld d, 0
    call sub_b629
    ld hl, 0x7278
    ld a, (0x726e)
    and 3
    cp 3
    jr nz, loc_b7e7
    inc hl
loc_b7e7:
    ld a, (hl)
    dec a
    ld (hl), a
    pop ix
    pop hl
    and a
    ret

sub_b7ef:
    push de
    push hl
    push ix
    pop hl
    ld e, 142
    and a
    ld a, l
    sbc a, e
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
    ld ix, 0x72c7
    ld b, 3
loc_b80f:
    bit 7, (ix + 4)
    jr z, loc_b82a
    bit 7, (ix + 0)
    jr nz, loc_b82a
    push bc
    call sub_b832
    push ix
    ld de, 0x32
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
    ld bc, 0x72c7
    ld d, 0x11
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
    ld bc, 0x0808
    ld a, d
    ld d, 0
    call sub_b629
    ld ix, 0x72c7
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
    ld a, (0x72c3)
    bit 0, a
    jr nz, loc_b884
    ld a, (0x72c6)
    call free_signal
loc_b884:
    xor a
    ld (0x72c3), a
    ld a, (0x72ba)
    bit 6, a
    jr z, loc_b89b
    ld hl, 0x72c4
    jp loc_d300
loc_b895:
    call request_signal
    jp loc_d35d
loc_b89b:
    nop
    nop
    nop
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
    ld ix, 0x72c7
    ld b, 3
loc_b8b1:
    ld (ix + 0), 0x10
    ld a, (0x72bf)
    ld (ix + 2), a
    ld a, (0x72be)
    ld (ix + 1), a
    ld a, (0x72c1)
    and 7
    or 0x80
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
    ld hl, 0x78
    call request_signal
    jp loc_d36d
loc_b8ec:
    ld a, 0x80
    ld (0x72c3), a
    pop bc
    pop de
    pop hl
    pop ix
    ret


sub_b8f7:
    push iy
    ld hl, 0x726e
    set 7, (hl)
loc_b8fe:
    bit 7, (hl)
    jr nz, loc_b8fe

; Set red flash colors (original code)
    ld hl, playfield_color_flash_extra
    ld de, 0
    ld iy, 0x0c
    ld a, 4
    call put_vram
    ld bc, 0x01e2
    call write_register

; Store current level's color pointer
    ld a, (current_level_ram)
    dec a  ; Adjust for 0-based index
    add a, a  ; Multiply by 2 for word-sized entries
    ld hl, playfield_colors
    ld b, 0
    ld c, a
    add hl, bc  ; HL now points to the correct pointer
    ld (stored_color_pointer), hl

    pop iy
    ret
playfield_color_flash_extra:
    db 0, 25, 137, 144, 128, 240, 240, 160, 160, 128, 153, 144, 0
restore_playfield_colors:
    push iy

; Calculate correct level colors using original logic
    ld a, (0x726e)
    bit 1, a
    ld a, (current_level_ram)
    jr z, use_current_level
    ld a, (0x7275)
use_current_level:
    cp 0x0b
    jr c, continue_restore
    sub 0x0a
    jr use_current_level
continue_restore:
    dec a
    add a, a
    ld c, a
    ld b, 0
    ld iy, playfield_colors
    add iy, bc
    ld l, (iy + 0)
    ld h, (iy + 1)

; Restore the colors
    ld de, 0
    ld iy, 0x0c
    ld a, 4
    call put_vram

    ld bc, 0x01e2
    call write_register

    pop iy
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

byte_be21:
    db 33, 0, 10, 0, 110, 1, 136, 1, 136, 1, 72, 1, 102, 1, 102, 1, 106, 1, 110, 1, 110, 1, 110, 1, 110, 1, 110, 1, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

playfield_table:
    dw p1st_phase_level_gen
    dw extra_border_gen
    dw badguy_outline_gen
    dw get_ready_p1_gen
    dw get_ready_p2_gen
    dw win_extra_gen
    dw game_over_p1_gen
    dw game_over_p2_gen
    dw game_over_gen
    dw sundae_gen
    dw wheat_square_gen
    dw gumdrop_gen
    dw pie_slice_gen
    dw blank_space_gen
    dw p2nd_gen
;    DB 000,000,000,000,000,000,000,000,000,000

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
    db 228, 240, 239, 232, 243, 226, 245, 246, 237, 226, 245, 234, 240, 239, 244, 0, 253, 1, 255, 254, 76, 250, 240, 246, 0, 248
    db 234, 239, 0, 226, 239, 0, 230, 249, 245, 243, 226, 0, 238, 243, 253, 1, 254, 0, 229, 240, 0, 253, 1, 255, 255
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
    db 24, 25, 254, 30, 26, 27, 255
pie_slice_gen:
    db 44, 45, 254, 30, 36, 37, 255
blank_space_gen:
    db 0, 0, 254, 30, 0, 0, 255
p2nd_gen:
    db 69, 70, 71, 255

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
phase_01_colors:
    db 0, 28, 140, 144, 128, 240, 240, 160, 160, 128, 202, 192, 192, 192, 128, 224, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 240, 240, 240, 240, 240
phase_02_colors:
    db 0, 20, 132, 144, 128, 240, 240, 160, 160, 128, 69, 64
phase_03_colors:
    db 0, 26, 138, 144, 128, 240, 240, 160, 160, 128, 202, 160
phase_04_colors:
    db 0, 29, 141, 144, 128, 240, 240, 160, 160, 128, 209, 208
phase_05_colors:
    db 0, 21, 133, 144, 128, 240, 240, 160, 160, 128, 165, 80
phase_06_colors:
    db 0, 27, 139, 144, 128, 240, 240, 160, 160, 128, 155, 176
phase_07_colors:
    db 0, 28, 140, 144, 128, 240, 240, 160, 160, 128, 60, 192
phase_08_colors:
    db 0, 23, 135, 144, 128, 240, 240, 160, 160, 128, 116, 112
phase_09_colors:
    db 0, 20, 132, 144, 128, 240, 240, 160, 160, 128, 180, 64
phase_10_colors:
    db 0, 28, 140, 144, 128, 240, 240, 160, 160, 128, 220, 192

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
    db 0, 0, 0
    dw badguy_right_walk_01_pat
    db 0, 4, 0
    dw badguy_right_walk_02_pat
    db 1
    dw byte_c234
    dw badguy_right_walk_01_pat
    db 1
    dw byte_c238
    dw badguy_right_walk_02_pat
    db 2
    dw byte_c23c
    dw badguy_right_walk_01_pat
    db 2
    dw byte_c240
    dw badguy_right_walk_02_pat
    db 3
    dw byte_c244
    dw badguy_right_walk_01_pat
    db 3
    dw byte_c248
    dw badguy_right_walk_02_pat
    db 4
    dw byte_c24c
    dw badguy_right_walk_01_pat
    db 4
    dw byte_c250
    dw badguy_right_walk_02_pat
    db 5
    dw byte_c254
    dw badguy_right_walk_01_pat
    db 5
    dw byte_c258
    dw badguy_right_walk_02_pat
    db 0, 48, 0
    dw digger_right_01_pat
    db 0, 52, 0
    dw digger_right_02_pat
    db 1
    dw byte_c25c
    dw digger_right_01_pat
    db 1
    dw byte_c260
    dw digger_right_02_pat
    db 2
    dw byte_c264
    dw digger_right_01_pat
    db 2
    dw byte_c268
    dw digger_right_02_pat
    db 3
    dw byte_c26c
    dw digger_right_01_pat
    db 3
    dw byte_c270
    dw digger_right_02_pat
    db 4
    dw byte_c274
    dw digger_right_01_pat
    db 4
    dw byte_c278
    dw digger_right_02_pat
    db 5
    dw byte_c27c
    dw digger_right_01_pat
    db 5
    dw byte_c280
    dw digger_right_02_pat
    db 0, 224, 0
    dw chomper_right_closed_pat
    db 0, 228, 0
    dw chomper_right_open_pat
    db 1
    dw byte_c298
    dw chomper_right_closed_pat
    db 1
    dw byte_c29c
    dw chomper_right_open_pat
    db 0, 176, 0
    dw mr_do_walk_right_01_pat
    db 0, 176, 0
    dw mr_do_walk_right_02_pat
    db 0, 176, 0
    dw mr_do_push_right_01_pat
    db 0, 176, 0
    dw mr_do_push_right_02_pat
    db 0, 176, 0
    dw mr_do_unused_push_anim_02_pat
    db 0, 176, 0
    dw mr_do_unused_push_anim_03_pat
    db 0, 176, 0
    dw mr_do_push_right_02_pat
    db 1
    dw byte_c284
    dw mr_do_walk_right_01_pat
    db 1
    dw byte_c284
    dw mr_do_walk_right_02_pat
    db 1
    dw byte_c284
    dw mr_do_push_right_01_pat
    db 1
    dw byte_c284
    dw mr_do_push_right_02_pat
    db 1
    dw byte_c284
    dw mr_do_unused_push_anim_02_pat
    db 1
    dw byte_c284
    dw mr_do_unused_push_anim_03_pat
    db 1
    dw byte_c284
    dw mr_do_push_right_02_pat
    db 2
    dw byte_c288
    dw mr_do_walk_right_01_pat
    db 2
    dw byte_c288
    dw mr_do_walk_right_02_pat
    db 2
    dw byte_c288
    dw mr_do_push_right_01_pat
    db 2
    dw byte_c288
    dw mr_do_push_right_02_pat
    db 2
    dw byte_c288
    dw mr_do_unused_push_anim_02_pat
    db 2
    dw byte_c288
    dw mr_do_unused_push_anim_03_pat
    db 2
    dw byte_c288
    dw mr_do_push_right_02_pat
    db 3
    dw byte_c28c
    dw mr_do_walk_right_01_pat
    db 3
    dw byte_c28c
    dw mr_do_walk_right_02_pat
    db 3
    dw byte_c28c
    dw mr_do_push_right_01_pat
    db 3
    dw byte_c28c
    dw mr_do_push_right_02_pat
    db 3
    dw byte_c28c
    dw mr_do_unused_push_anim_02_pat
    db 3
    dw byte_c28c
    dw mr_do_unused_push_anim_03_pat
    db 3
    dw byte_c28c
    dw mr_do_push_right_02_pat
    db 4
    dw byte_c290
    dw mr_do_walk_right_01_pat
    db 4
    dw byte_c290
    dw mr_do_walk_right_02_pat
    db 4
    dw byte_c290
    dw mr_do_push_right_01_pat
    db 4
    dw byte_c290
    dw mr_do_push_right_02_pat
    db 4
    dw byte_c290
    dw mr_do_unused_push_anim_02_pat
    db 4
    dw byte_c290
    dw mr_do_unused_push_anim_03_pat
    db 4
    dw byte_c290
    dw mr_do_push_right_02_pat
    db 5
    dw byte_c294
    dw mr_do_walk_right_01_pat
    db 5
    dw byte_c294
    dw mr_do_walk_right_02_pat
    db 5
    dw byte_c294
    dw mr_do_push_right_01_pat
    db 5
    dw byte_c294
    dw mr_do_push_right_02_pat
    db 5
    dw byte_c294
    dw mr_do_unused_push_anim_02_pat
    db 5
    dw byte_c294
    dw mr_do_unused_push_anim_03_pat
    db 5
    dw byte_c294
    dw mr_do_push_right_02_pat
    db 0, 176, 0
    dw five_hundred_score_pat

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
byte_c284:    db 178, 179, 176, 177
byte_c288:    db 177, 179, 176, 178
byte_c28c:    db 176, 178, 177, 179
byte_c290:    db 179, 177, 178, 176
byte_c294:    db 178, 176, 179, 177
byte_c298:    db 234, 235, 232, 233
byte_c29c:    db 238, 239, 236, 237

mr_do_walk_right_01_pat:
    db 0, 7, 13, 95, 58, 14, 5, 6
    db 1, 2, 7, 13, 15, 5, 3, 0
    db 0, 192, 96, 0, 224, 176, 176, 224
    db 128, 64, 176, 248, 88, 128, 224, 0
mr_do_walk_right_02_pat:
    db 0, 3, 6, 11, 30, 54, 77, 6
    db 25, 126, 103, 11, 62, 25, 12, 0
    db 0, 192, 224, 0, 224, 176, 176, 224
    db 128, 64, 176, 248, 216, 224, 120, 0
mr_do_push_right_01_pat:
    db 0, 15, 26, 190, 117, 29, 11, 5
    db 27, 60, 47, 59, 31, 10, 15, 0
    db 0, 128, 192, 0, 192, 96, 96, 192
    db 0, 136, 248, 248, 0, 0, 128, 0
mr_do_push_right_02_pat:
    db 0, 7, 13, 22, 61, 109, 155, 13
    db 3, 12, 31, 251, 223, 130, 129, 0
    db 0, 128, 192, 0, 192, 96, 96, 192
    db 0, 196, 252, 124, 128, 192, 184, 0

mr_do_unused_push_anim_01_pat:
    db 0, 0, 3, 7, 9, 13, 7, 3
    db 7, 14, 31, 31, 18, 31, 0, 0
    db 0, 0, 192, 224, 144, 176, 224, 200
    db 248, 56, 192, 192, 0, 128, 0, 0
mr_do_unused_push_anim_02_pat:
    db 0, 0, 3, 7, 9, 13, 7, 3
    db 3, 6, 15, 15, 15, 1, 0, 0
    db 0, 0, 192, 224, 144, 176, 224, 200
    db 248, 56, 192, 192, 0, 192, 0, 0
mr_do_unused_push_anim_03_pat:
    db 0, 0, 3, 7, 9, 13, 7, 3
    db 7, 14, 31, 31, 19, 28, 0, 0
    db 0, 0, 192, 224, 144, 176, 224, 200
    db 248, 56, 128, 128, 128, 0, 0, 0

five_hundred_score_pat:
    db 0, 0, 0, 0, 0, 113, 66, 114
    db 10, 74, 49, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 140, 82, 82
    db 82, 82, 140, 0, 0, 0, 0, 0
digger_right_01_pat:
    db 7, 29, 54, 124, 212, 63, 45, 120
    db 215, 55, 120, 222, 33, 126, 0, 0
    db 224, 16, 104, 104, 8, 248, 176, 0
    db 252, 254, 6, 66, 240, 0, 0, 0
digger_right_02_pat:
    db 7, 29, 54, 124, 212, 62, 45, 123
    db 215, 58, 127, 211, 124, 1, 0, 0
    db 224, 16, 104, 0, 120, 252, 196, 160
    db 96, 224, 192, 0, 128, 240, 0, 0
badguy_right_walk_01_pat:
    db 0, 0, 31, 63, 62, 62, 62, 31
    db 6, 29, 63, 125, 16, 62, 0, 0
    db 0, 0, 240, 248, 60, 252, 60, 248
    db 32, 252, 254, 128, 64, 248, 0, 0
badguy_right_walk_02_pat:
    db 0, 31, 63, 62, 62, 63, 30, 5
    db 61, 29, 26, 6, 12, 8, 0, 0
    db 0, 240, 248, 60, 252, 0, 252, 254
    db 128, 100, 108, 248, 16, 16, 0, 0
chomper_right_closed_pat:
    db 0, 0, 14, 31, 25, 14, 17, 63
    db 56, 53, 56, 63, 59, 17, 0, 0
    db 0, 0, 56, 124, 100, 184, 192, 252
    db 0, 84, 0, 252, 220, 136, 0, 0
chomper_right_open_pat:
    db 14, 25, 25, 14, 17, 63, 56, 49
    db 52, 48, 50, 56, 63, 36, 0, 0
    db 56, 100, 100, 184, 192, 252, 0, 84
    db 0, 0, 168, 0, 252, 36, 0, 0
extra_sprite_pat:
    db 6, 25, 57, 63, 96, 71, 68, 71  ; E Left foot down
    db 68, 68, 103, 48, 31, 6, 60, 0
    db 96, 152, 156, 252, 6, 242, 2, 194
    db 2, 2, 246, 12, 240, 62, 0, 0
    db 0, 6, 25, 63, 112, 103, 68, 71  ; E Right foot down
    db 68, 68, 103, 48, 15, 124, 0, 0
    db 0, 96, 152, 252, 14, 246, 2, 194
    db 2, 2, 246, 12, 248, 96, 48, 28
    db 0, 6, 25, 63, 112, 102, 67, 64  ; X Right foot down
    db 65, 67, 102, 48, 15, 124, 0, 0
    db 0, 96, 152, 252, 14, 54, 98, 194
    db 130, 98, 54, 12, 248, 96, 48, 28
    db 6, 25, 57, 63, 96, 70, 67, 64  ; X Left foot down
    db 65, 67, 102, 48, 31, 6, 60, 0
    db 96, 152, 156, 252, 6, 50, 98, 194
    db 130, 98, 54, 12, 240, 62, 0, 0
    db 6, 25, 57, 63, 96, 71, 64, 64  ; T Left foot down
    db 64, 64, 96, 48, 31, 6, 60, 0
    db 96, 152, 156, 252, 6, 242, 130, 130
    db 130, 130, 134, 12, 240, 62, 0, 0
    db 0, 6, 25, 63, 112, 103, 64, 64  ; T Right foot down
    db 64, 64, 96, 48, 15, 124, 0, 0
    db 0, 96, 152, 252, 14, 246, 130, 130
    db 130, 130, 134, 12, 248, 96, 48, 28
    db 0, 6, 25, 63, 112, 103, 68, 68  ; R Right foot down
    db 71, 68, 100, 48, 15, 124, 0, 0
    db 0, 96, 152, 252, 14, 230, 50, 50
    db 226, 66, 118, 12, 248, 96, 48, 28
    db 6, 25, 57, 63, 96, 71, 68, 68  ; R Left Foot Down
    db 71, 68, 100, 48, 31, 6, 60, 0
    db 96, 152, 156, 252, 6, 226, 50, 50
    db 226, 66, 118, 12, 240, 62, 0, 0
    db 6, 25, 57, 63, 96, 65, 67, 70  ; A Left foot down
    db 68, 71, 100, 48, 31, 6, 60, 0
    db 96, 152, 156, 252, 6, 194, 98, 50
    db 18, 242, 22, 12, 240, 62, 0, 0
    db 0, 6, 25, 63, 112, 97, 67, 70  ; A Right foot down
    db 68, 71, 100, 48, 15, 124, 0, 0
    db 0, 96, 152, 252, 14, 198, 98, 50
    db 18, 242, 22, 12, 248, 96, 48, 28
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
    db 0, 0, 31, 63, 31, 63, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 248, 252, 248, 252, 0, 0
    db 0, 0, 7, 9, 18, 36, 56, 39  ; Diamond
    db 20, 18, 9, 4, 2, 1, 0, 0
    db 0, 0, 224, 144, 72, 36, 28, 228
    db 40, 72, 144, 32, 64, 128, 0, 0
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

variouts_patterns:
    db 1, 0
    dw blank_line_pat
    db 2, 8
    dw cherry_top_pat
    db 2, 16
    dw cherry_bottom_pat
    db 4, 24
    dw gumdrop_pat
    db 6, 32
    dw wheat_square_pat
    db 15, 40
    dw hud_pats_01
    db 16, 56
    dw hud_pats_02
    db 5, 72
    dw extra_pats
    db 5, 80
    dw playfield_pats
    db 8, 88
    dw hallway_border_pat
    db 4, 112
    dw badguy_outline_pat
    db 2, 120
    dw hud_pats_01
    db 0
blank_line_pat:
    db 0, 0, 0, 0, 0, 0, 0, 0
cherry_top_pat:
    db 0, 0, 0, 0, 0, 0, 0, 1
    db 0, 0, 0, 16, 40, 72, 136, 16
cherry_bottom_pat:
    db 14, 29, 31, 31, 14, 0, 0, 0
    db 56, 116, 124, 124, 56, 0, 0, 0
gumdrop_pat:
    db 0, 0, 1, 3, 7, 14, 28, 29
    db 0, 0, 128, 192, 224, 240, 248, 248
    db 57, 59, 31, 15, 3, 0, 0, 0
    db 252, 252, 248, 240, 192, 0, 0, 0
wheat_square_pat:
    db 0, 0, 42, 63, 22, 63, 23, 63
    db 0, 0, 192, 128, 192, 128, 108, 248
    db 31, 53, 3, 1, 3, 3, 0, 0
    db 108, 248, 252, 104, 252, 84, 0, 0
    db 63, 62, 49, 15, 63, 56, 0, 0
    db 240, 8, 248, 248, 0, 0, 0, 0
badguy_outline_pat:
    db 0, 0, 31, 48, 33, 34, 34, 49
    db 16, 16, 48, 96, 63, 62, 0, 0
    db 0, 0, 240, 24, 140, 68, 68, 140
    db 24, 16, 16, 48, 224, 248, 0, 0
hud_pats_01:
    db 0, 56, 92, 240, 172, 234, 218, 172  ; Mr. Do extra life sprite
    db 24, 36, 122, 110, 56, 28, 0, 0
    db 0, 0, 0, 0, 1, 3, 13, 30  ; Ice Cream dessert unaligned
    db 0, 0, 0, 0, 128, 192, 176, 120
    db 0, 0, 0, 3, 7, 15, 31, 63
    db 0, 0, 0, 192, 248, 248, 248, 232
    db 0, 0, 7, 9, 18, 36, 56, 39  ; Diamond pieces not lined up
    db 0, 0, 224, 144, 72, 36, 28, 228
    db 20, 18, 9, 4, 2, 1, 0, 0
    db 40, 72, 144, 32, 64, 128, 0, 0
    db 0, 0, 254, 128, 248, 128, 128, 254  ; E
    db 0, 0, 198, 108, 24, 48, 108, 198  ; XTRA
    db 0, 0, 254, 16, 16, 16, 16, 16
    db 0, 0, 252, 134, 134, 252, 136, 142
    db 0, 0, 56, 108, 198, 130, 254, 130
hud_pats_02:
    db 63, 43, 10, 1, 1, 3, 0, 0  ; Bottom of Ice Cream, Extra border
    db 252, 180, 96, 128, 128, 192, 0, 0
    db 255, 255, 192, 192, 192, 192, 192, 192
    db 192, 192, 192, 192, 192, 192, 192, 192
    db 192, 192, 192, 192, 192, 192, 255, 255  ; Extra Border Box
    db 255, 255, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 255, 255
    db 255, 255, 3, 3, 3, 3, 3, 3
    db 3, 3, 3, 3, 3, 3, 3, 3  ; Border box, 1ST Text
    db 3, 3, 3, 3, 3, 3, 255, 255
    db 33, 98, 34, 33, 32, 34, 113, 0
    db 207, 34, 2, 194, 34, 34, 194, 0
    db 128, 0, 0, 0, 0, 0, 0, 0  ; 2ND Text
    db 114, 138, 11, 50, 66, 130, 250, 0
    db 47, 40, 40, 168, 104, 40, 47, 0
    db 0, 128, 128, 128, 128, 128, 0, 0
extra_pats:
    db 0, 0, 254, 128, 248, 128, 128, 254  ; EXTRA TEXT HUD (RED)
    db 0, 0, 198, 108, 24, 48, 108, 198
    db 0, 0, 254, 16, 16, 16, 16, 16
    db 0, 0, 252, 134, 134, 252, 136, 142
    db 0, 0, 56, 108, 198, 130, 254, 130
playfield_pats:
    db 30, 30, 255, 255, 225, 225, 255, 255  ; Brick pattern
    db 241, 227, 199, 143, 31, 62, 124, 248  ; Diagonal Stripes
    db 129, 66, 36, 24, 24, 36, 66, 129  ; cross hatch
    db 51, 102, 204, 136, 204, 102, 51, 17  ; wavy up/down/vertical
    db 195, 102, 60, 0, 195, 102, 60, 0  ; wavy horizontal
hallway_border_pat:
    db 192, 192, 128, 128, 192, 192, 128, 128
    db 1, 1, 3, 3, 1, 1, 3, 3
    db 255, 204, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 51, 255
    db 255, 204, 128, 128, 192, 192, 128, 128
    db 255, 205, 3, 3, 1, 1, 3, 3
    db 192, 192, 128, 128, 192, 192, 179, 255
    db 1, 1, 3, 3, 1, 1, 51, 255
    db 0

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
    and 0x00c0
    or 2
    ld (sound_bank_01_ram), a
    ld a, (sound_bank_02_ram)
    and 0x00c0
    or 4
    ld (sound_bank_02_ram), a
    ret
play_background_tune:
    ld b, background_tune_0a  ; Play first part of background tune
    call play_it
    ld b, background_tune_0b  ; Play second part of background tune
    jp play_it

sub_c97f:
    ld a, 0x00ff
    ld (sound_bank_03_ram), a
    ret

play_grab_cherries_sound:
    ld b, grab_cherries_snd
    jp play_it

sub_c98a:
    ld a, 0x00ff
    ld (sound_bank_04_ram), a
    ld (sound_bank_05_ram), a
    ret

play_bouncing_ball_sound:
    ld b, bouncing_ball_snd_0a
    call play_it
    ld a, (sound_bank_05_ram)
    cp 0x00ff
    ret nz
    ld b, bouncing_ball_snd_0b
    jp play_it

play_ball_stuck_sound_01:
    ld a, (sound_bank_05_ram)
    and 0x3f
    cp 7
    jr nz, play_ball_stuck_sound_02
    ld a, 0x00ff
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
    and 0x3f
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
    ld a, 0x00ff
    ld (sound_bank_07_ram), a
    ld (sound_bank_08_ram), a
    ret

sub_ca2d:
    ld a, 0x00ff
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
; SEcond Highest G#
    db 64, 67, 80, 7, 99
; B Flat (B5)
    db 64, 119, 80, 7, 107
; D# (low)
    db 64, 206, 82, 7, 99
; C (low)
    db 64, 86, 83, 7, 80
lose_life_tune_p2:
    db 128, 56, 96, 7, 162
    db 128, 53, 96, 7, 170
; Middle G#
    db 128, 134, 96, 4, 162
; Middle B (B4)
    db 192, 142, 96, 7, 235
; D# (D5)
    db 192, 89, 96, 7, 227
; F# (middle)
    db 192, 119, 96, 7, 235
; D# (low)
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
    db 64, 107, 48, 22, 118, 118, 64, 85, 48, 11, 107, 64, 80, 48, 11, 80
game_over_tune_p2:
    db 182, 182, 128, 64, 81, 22, 128, 214, 80, 7, 164, 128, 214, 80, 7, 164, 128, 254, 80, 11, 171
    db 128, 64, 81, 11, 171, 128, 64, 81, 22, 128, 214, 80, 7, 164, 128, 214, 80, 7, 164, 128, 240
    db 96, 11, 171, 128, 254, 96, 11, 171, 128, 29, 97, 11, 171, 128, 87, 99, 7, 164, 128, 87, 99
    db 7, 164, 128, 87, 99, 22, 128, 214, 112, 11, 107, 128, 64, 113, 11, 144
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
    ld hl, 0x05a0
    xor a
    jp loc_b895
loc_d309:
    ld hl, 0x7272
    bit 5, (hl)
    jr z, loc_d319
    res 5, (hl)
    push iy
    call play_no_extra_no_chompers
    pop iy
loc_d319:
    jp loc_a596
loc_d31c:
    ld a, (0x7272)
    bit 5, a
    ret nz
    jp play_extra_walking_tune_no_chompers
loc_d326:
    call sub_b8f7
    push iy
    call sub_ca24
    ld hl, 0x726e
    set 7, (hl)
loc_d333:
    bit 7, (hl)
    jr nz, loc_d333
    ld bc, 0x01e2
    call write_register
    call play_blue_chompers_sound
    pop iy
    jp loc_b8ab
loc_d345:
    call sub_ca2d
    ld hl, 0x726e
    set 7, (hl)
loc_d34d:
    bit 7, (hl)
    jr nz, loc_d34d
    ld bc, 0x01e2
    call write_register
    ld hl, 0x7272
    jp loc_b875
loc_d35d:
    ld (0x726f), a
    call play_extra_walking_tune_no_chompers
    jp loc_b89b
loc_d366:
    call sub_9577
    xor a
    jp loc_9481
loc_d36d:
    ld (0x72c6), a
    ld hl, 0x72c4
    bit 0, (hl)
    jp z, loc_b8ec
    res 0, (hl)
    ld a, (0x726f)
    call test_signal
    jp loc_b8ec
loc_d383:
    ld a, (0x72c6)
    call test_signal
    and a
    jp z, loc_d3a6
    ld hl, 0x72c3
    ld a, (hl)
    xor 1
    ld (hl), a
    ld hl, 0x78
    rra
    jr nc, loc_d39f
    ld l, 0x3c
loc_d39f:
    xor a
    call request_signal
    ld (0x72c6), a
loc_d3a6:
    ld a, (0x72c3)
    rra
    jp nc, loc_a853
    jp loc_a858

loc_d3d5:
    and 7
    ld c, 0x00c0
    cp 3
    jp loc_a8af
loc_d3de:
    call play_it
    ld a, 0x00ff
    ld (sound_bank_01_ram), a
    ld (sound_bank_02_ram), a
    ret
loc_d3ea:
    call play_it
    ld a, 0x00ff
    ld (sound_bank_01_ram), a
    ld (sound_bank_02_ram), a
    ld (sound_bank_07_ram), a
    ret

loc_d3f9:
    ld a, (sound_bank_01_ram)
    and 0x0f
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
    cp 0x00ff
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
; Short f#
    db 64, 151, 96, 7, 99  ;10
; Very long g
    db 64, 142, 96, 30, 116  ;50

; BEGIN 2

; very short gf#g
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

; short f#
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

; short f#
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



nmi_handler:
    push af
    push hl
    ld hl, mode
    bit 0, (hl)  ; 0 -> ISR Enabled, 1 -> ISR disabled
    jr z, nmi_handler.1
    set 1, (hl)  ; ISR not executed
    pop hl
    pop af
    retn

nmi_handler.0:    res 1, (hl)

nmi_handler.1:
    bit 7, (hl)
    jr z, nmi_handler.2  ; 0 -> Game Mode, 1 -> intermission mode

    pop hl
    in a, (ctrl_port)
    pop af
;     call fakenmi  ; -mdl


fakenmi:  ; Intermission Mode
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
    call time_mgr
    call poller
    call sub_c952
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
;     ret  ; -mdl
    retn


nmi_handler.2:
    pop hl  ; Game Mode
    pop af
    jp nmi



cvb_animatedlogo:
    ld hl, mode
    set 7, (hl)  ; switch to intermission  mode

    call mymode2
    call mydisscr
    call cvb_mycls
    ld de, 0x0000
    ld hl, cvb_tileset
    call unpack
    ld de, 0x1800
    ld hl, cvb_pnt
    call unpack
    ld hl, cvb_colorset1
    call clrfrm

    ld a, 208
    ld hl, 0x1b00  ; remove all sprites (may be $1900 ??)
    call mywrtvrm

    call myenascr
; 
;     call cvb_mypause  ; -mdl

cvb_mypause:
; 	FOR T=0 TO 120:WAIT: NEXT
    ld b, 120
cv3:
    halt
    djnz cv3
;     ret  ; -mdl
; 	
    ld hl, cvb_colorset1
    call clrfrm
    ld hl, cvb_colorset2
    call clrfrm
    ld hl, cvb_colorset3
    call clrfrm
    ld hl, cvb_colorset4
    call clrfrm
    ld hl, cvb_colorset5
    call clrfrm
    ld hl, cvb_colorset6
    call clrfrm
; 
; 	FOR T=0 TO 10
    ld b, 10
cvb_animatedlogo.mynext:
    push bc

    ld hl, cvb_colorset7
    call clrfrm
    ld hl, cvb_colorset8
    call clrfrm
    ld hl, cvb_colorset9
    call clrfrm
    ld hl, cvb_colorset10
    call clrfrm
    ld hl, cvb_colorset11
    call clrfrm
    ld hl, cvb_colorset12
    call clrfrm

; 	NEXT
    pop bc
    djnz cvb_animatedlogo.mynext

    ld hl, mode
    res 7, (hl)  ; switch to game mode

    ret

; MAKE SURE TO BE IN INTERMISSION MODE BEFORE CALLING

cvb_extrascreen:
    call mymode1
    call mydisscr
    call cvb_mycls

    ld hl, 0
    push hl
    ld hl, cvb_image_char
    call define_char_unpack  ; 	DEFINE CHAR PLETTER 0,204,image_char

    ld hl, 0
    push hl
    ld hl, cvb_image_color
    call define_color_unpack  ; 	DEFINE COLOR PLETTER 0,204,image_color

    ld de, 0x3800
    ld hl, cvb_image_sprites
    call unpack  ; 	DEFINE SPRITE PLETTER 0,24,image_sprites

    ld hl, cvb_image_pattern
    ld de, 0x1805
    call cpyblk22x24

    ld bc, 128
    ld de, 0x1b00
    ld hl, cvb_sprite_overlay
    call mynmi_off
    call myldirvm
    call mynmi_on

    jp myenascr



mynmi_off:
    push hl
    ld hl, mode
    set 0, (hl)
    pop hl
    ret

clrfrm:
    halt
    halt
    halt
    halt
    ld bc, 18
    ld de, 0x2000
    call mynmi_off
    call myldirvm
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

cvb_mycls:
    ld hl, 0x1800
    ld bc, 0x0300
    xor a
    call mynmi_off
    push af
    ld a, l
    out (ctrl_port), a
    ld a, h
    and 0x3f
    or 0x40
    out (ctrl_port), a
    pop af
    dec bc  ; T-states (normal / M1)
cvb_mycls.1:    out (data_port), a  ; 11 12
    dec bc  ;  6  7
    bit 7, b  ;  8 10
    jp z, cvb_mycls.1  ; 10 11

    jp mynmi_on


;	HL->ROM
;	DE->VRAM

cpyblk22x24:
    call mynmi_off
    ld b, 24
cpyblk22x24.1:    push bc

    push hl
    push de
    ld bc, 22
    call myldirvm
    pop de
    pop hl
    ld bc, 22
    add hl, bc

    ld c, 32
    ex de, hl
    add hl, bc
    ex de, hl

    pop bc
    djnz cpyblk22x24.1
    jp mynmi_on

mymode2:
    ld hl, mode
    set 3, (hl)
    ld bc, 0x0000
    ld de, 0x8000  ; $2000 for color table, $0000 for bitmaps.

vdp_chg_mode:
    call mynmi_off
    call mywrtvdp
    ld bc, 0xa201
    call mywrtvdp
    ld bc, 0x0602  ; $1800 for pattern table.
    call mywrtvdp
    ld b, d
    ld c, 0x03  ; for color table.
    call mywrtvdp
    ld b, e
    ld c, 0x04  ; for bitmap table.
    call mywrtvdp
    ld bc, 0x3605  ; $1b00 for sprite attribute table.
    call mywrtvdp
    ld bc, 0x0706  ; $3800 for sprites bitmaps.
    call mywrtvdp
    ld bc, 0x0107
; 	jp MYWRTVDP  ; -mdl

; BIOS HELPER CODE
mywrtvdp:
    ld a, b
    out (ctrl_port), a
    ld a, c
    or 0x80
    out (ctrl_port), a
    ret

mymode1:
    ld hl, mode
    res 3, (hl)
    ld bc, 0x0200
    ld de, 0xff03  ; $2000 for color table, $0000 for bitmaps.
    jp vdp_chg_mode

mydisscr:
    call mynmi_off
    ld a, 0xa2
    out (ctrl_port), a
    ld a, 0x81
    out (ctrl_port), a
    jp mynmi_on

myenascr:
    call mynmi_off
    ld a, 0xe2
    out (ctrl_port), a
    ld a, 0x81
    out (ctrl_port), a
    jp mynmi_on

myldirvm:
    ld a, e
    out (ctrl_port), a
    ld a, d
    or 0x40
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
    or 0x40
    out (ctrl_port), a
    pop af
    out (data_port), a
    ret

define_color_unpack:
    ex de, hl
    pop af
    pop hl
    push af
    add hl, hl  ; x2
    add hl, hl  ; x4
    add hl, hl  ; x8
    ex de, hl
    set 5, d
unpack3:
    call unpack3.1
    call unpack3.1
unpack3.1:
    push de
    push hl
    call unpack
    pop hl
    pop de
    ld a, d
    add a, 8
    ld d, a
    ret


define_char_unpack:
    ex de, hl
    pop af
    pop hl
    push af
    add hl, hl  ; x2
    add hl, hl  ; x4
    add hl, hl  ; x8
    ex de, hl
    ld a, (mode)
    and 8
    jp z, unpack3
; 	jp unpack  ; -mdl

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
    and 0x3f
    out (ctrl_port), a
    in a, (data_port)
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


; 	
; 	' Start tile = 0. Total_tiles = 204
; image_char:
cvb_image_char:
; 	DATA BYTE $3e,$00,$3e,$00,$ff,$00,$02,$7e
    db 0x3e, 0x00, 0x3e, 0x00, 0xff, 0x00, 0x02, 0x7e
; 	DATA BYTE $c0,$80,$80,$c0,$7e,$07,$02,$7c
    db 0xc0, 0x80, 0x80, 0xc0, 0x7e, 0x07, 0x02, 0x7c
; 	DATA BYTE $c6,$82,$82,$c6,$7c,$07,$03,$c2
    db 0xc6, 0x82, 0x82, 0xc6, 0x7c, 0x07, 0x03, 0xc2
; 	DATA BYTE $e2,$b2,$9a,$8e,$86,$86,$0f,$80
    db 0xe2, 0xb2, 0x9a, 0x8e, 0x86, 0x86, 0x0f, 0x80
; 	DATA BYTE $8e,$c2,$01,$17,$fc,$86,$86,$fc
    db 0x8e, 0xc2, 0x01, 0x17, 0xfc, 0x86, 0x86, 0xfc
; 	DATA BYTE $88,$8e,$11,$07,$38,$6c,$20,$fe
    db 0x88, 0x8e, 0x11, 0x07, 0x38, 0x6c, 0x20, 0xfe
; 	DATA BYTE $82,$1d,$07,$fe,$10,$00,$5b,$07
    db 0x82, 0x1d, 0x07, 0xfe, 0x10, 0x00, 0x5b, 0x07
; 	DATA BYTE $2d,$39,$2f,$80,$00,$fe,$9c,$1f
    db 0x2d, 0x39, 0x2f, 0x80, 0x00, 0xfe, 0x9c, 0x1f
; 	DATA BYTE $16,$38,$e3,$37,$70,$1c,$00,$17
    db 0x16, 0x38, 0xe3, 0x37, 0x70, 0x1c, 0x00, 0x17
; 	DATA BYTE $7d,$39,$93,$c7,$ef,$ef,$84,$0e
    db 0x7d, 0x39, 0x93, 0xc7, 0xef, 0xef, 0x84, 0x0e
; 	DATA BYTE $83,$39,$7d,$0a,$83,$af,$07,$05
    db 0x83, 0x39, 0x7d, 0x0a, 0x83, 0xaf, 0x07, 0x05
; 	DATA BYTE $82,$07,$6d,$45,$11,$bb,$07,$c9
    db 0x82, 0x07, 0x6d, 0x45, 0x11, 0xbb, 0x07, 0xc9
; 	DATA BYTE $1c,$00,$c7,$01,$07,$3d,$1d,$4d
    db 0x1c, 0x00, 0xc7, 0x01, 0x07, 0x3d, 0x1d, 0x4d
; 	DATA BYTE $65,$71,$79,$a8,$8d,$3e,$41,$95
    db 0x65, 0x71, 0x79, 0xa8, 0x8d, 0x3e, 0x41, 0x95
; 	DATA BYTE $3c,$07,$40,$07,$5b,$bf,$83,$bf
    db 0x3c, 0x07, 0x40, 0x07, 0x5b, 0xbf, 0x83, 0xbf
; 	DATA BYTE $bf,$80,$00,$ff,$9c,$88,$c1,$e3
    db 0xbf, 0x80, 0x00, 0xff, 0x9c, 0x88, 0xc1, 0xe3
; 	DATA BYTE $e7,$c9,$9c,$c7,$6e,$f7,$00,$00
    db 0xe7, 0xc9, 0x9c, 0xc7, 0x6e, 0xf7, 0x00, 0x00
; 	DATA BYTE $ff,$81,$80,$bc,$80,$81,$bb,$00
    db 0xff, 0x81, 0x80, 0xbc, 0x80, 0x81, 0xbb, 0x00
; 	DATA BYTE $b8,$ff,$e3,$c1,$88,$9c,$be,$80
    db 0xb8, 0xff, 0xe3, 0xc1, 0x88, 0x9c, 0xbe, 0x80
; 	DATA BYTE $00,$be,$ff,$63,$77,$7f,$5d,$49
    db 0x00, 0xbe, 0xff, 0x63, 0x77, 0x7f, 0x5d, 0x49
; 	DATA BYTE $41,$40,$41,$3f,$40,$40,$5e,$73
    db 0x41, 0x40, 0x41, 0x3f, 0x40, 0x40, 0x5e, 0x73
; 	DATA BYTE $40,$b6,$00,$3e,$0e,$60,$60,$43
    db 0x40, 0xb6, 0x00, 0x3e, 0x0e, 0x60, 0x60, 0x43
; 	DATA BYTE $41,$00,$42,$43,$4f,$3c,$26,$63
    db 0x41, 0x00, 0x42, 0x43, 0x4f, 0x3c, 0x26, 0x63
; 	DATA BYTE $07,$00,$63,$3e,$07,$0f,$0f,$0e
    db 0x07, 0x00, 0x63, 0x3e, 0x07, 0x0f, 0x0f, 0x0e
; 	DATA BYTE $0c,$08,$bc,$17,$5f,$69,$01,$05
    db 0x0c, 0x08, 0xbc, 0x17, 0x5f, 0x69, 0x01, 0x05
; 	DATA BYTE $3c,$13,$80,$0e,$46,$03,$03,$f8
    db 0x3c, 0x13, 0x80, 0x0e, 0x46, 0x03, 0x03, 0xf8
; 	DATA BYTE $e0,$30,$62,$a6,$0c,$7f,$3f,$1b
    db 0xe0, 0x30, 0x62, 0xa6, 0x0c, 0x7f, 0x3f, 0x1b
; 	DATA BYTE $3f,$bf,$9f,$1b,$17,$02,$07,$08
    db 0x3f, 0xbf, 0x9f, 0x1b, 0x17, 0x02, 0x07, 0x08
; 	DATA BYTE $07,$e0,$f0,$03,$40,$fb,$fb,$00
    db 0x07, 0xe0, 0xf0, 0x03, 0x40, 0xfb, 0xfb, 0x00
; 	DATA BYTE $f3,$e7,$ef,$c0,$c0,$e0,$60,$70
    db 0xf3, 0xe7, 0xef, 0xc0, 0xc0, 0xe0, 0x60, 0x70
; 	DATA BYTE $18,$70,$38,$b8,$14,$1c,$00,$3e
    db 0x18, 0x70, 0x38, 0xb8, 0x14, 0x1c, 0x00, 0x3e
; 	DATA BYTE $bf,$3f,$7f,$f8,$f0,$e0,$08,$00
    db 0xbf, 0x3f, 0x7f, 0xf8, 0xf0, 0xe0, 0x08, 0x00
; 	DATA BYTE $08,$0f,$9f,$cf,$6e,$4e,$de,$9e
    db 0x08, 0x0f, 0x9f, 0xcf, 0x6e, 0x4e, 0xde, 0x9e
; 	DATA BYTE $20,$be,$3e,$6e,$df,$cf,$c7,$e7
    db 0x20, 0xbe, 0x3e, 0x6e, 0xdf, 0xcf, 0xc7, 0xe7
; 	DATA BYTE $04,$e7,$f3,$fd,$71,$07,$2f,$3f
    db 0x04, 0xe7, 0xf3, 0xfd, 0x71, 0x07, 0x2f, 0x3f
; 	DATA BYTE $80,$1d,$7f,$ff,$f0,$f8,$fc,$fc
    db 0x80, 0x1d, 0x7f, 0xff, 0xf0, 0xf8, 0xfc, 0xfc
; 	DATA BYTE $4d,$f8,$04,$fe,$06,$46,$30,$78
    db 0x4d, 0xf8, 0x04, 0xfe, 0x06, 0x46, 0x30, 0x78
; 	DATA BYTE $7c,$93,$07,$12,$e0,$6f,$76,$ab
    db 0x7c, 0x93, 0x07, 0x12, 0xe0, 0x6f, 0x76, 0xab
; 	DATA BYTE $8f,$73,$63,$06,$08,$18,$23,$14
    db 0x8f, 0x73, 0x63, 0x06, 0x08, 0x18, 0x23, 0x14
; 	DATA BYTE $8c,$06,$3b,$cf,$df,$9f,$40,$5d
    db 0x8c, 0x06, 0x3b, 0xcf, 0xdf, 0x9f, 0x40, 0x5d
; 	DATA BYTE $00,$b8,$bc,$9d,$dd,$df,$b5,$00
    db 0x00, 0xb8, 0xbc, 0x9d, 0xdd, 0xdf, 0xb5, 0x00
; 	DATA BYTE $1c,$a8,$da,$51,$c0,$8d,$a0,$4e
    db 0x1c, 0xa8, 0xda, 0x51, 0xc0, 0x8d, 0xa0, 0x4e
; 	DATA BYTE $07,$03,$01,$99,$96,$c3,$61,$79
    db 0x07, 0x03, 0x01, 0x99, 0x96, 0xc3, 0x61, 0x79
; 	DATA BYTE $82,$75,$11,$0f,$35,$dd,$46,$1f
    db 0x82, 0x75, 0x11, 0x0f, 0x35, 0xdd, 0x46, 0x1f
; 	DATA BYTE $17,$cb,$76,$78,$72,$bd,$55,$7e
    db 0x17, 0xcb, 0x76, 0x78, 0x72, 0xbd, 0x55, 0x7e
; 	DATA BYTE $55,$1c,$a3,$0b,$f0,$c9,$16,$79
    db 0x55, 0x1c, 0xa3, 0x0b, 0xf0, 0xc9, 0x16, 0x79
; 	DATA BYTE $c1,$e6,$07,$d1,$28,$ac,$1b,$4d
    db 0xc1, 0xe6, 0x07, 0xd1, 0x28, 0xac, 0x1b, 0x4d
; 	DATA BYTE $c0,$fc,$7d,$1b,$09,$07,$89,$7f
    db 0xc0, 0xfc, 0x7d, 0x1b, 0x09, 0x07, 0x89, 0x7f
; 	DATA BYTE $0f,$00,$06,$83,$f1,$f9,$fd,$3c
    db 0x0f, 0x00, 0x06, 0x83, 0xf1, 0xf9, 0xfd, 0x3c
; 	DATA BYTE $1c,$1e,$46,$1e,$e5,$d4,$1f,$8b
    db 0x1c, 0x1e, 0x46, 0x1e, 0xe5, 0xd4, 0x1f, 0x8b
; 	DATA BYTE $c1,$c0,$90,$f3,$e3,$57,$81,$20
    db 0xc1, 0xc0, 0x90, 0xf3, 0xe3, 0x57, 0x81, 0x20
; 	DATA BYTE $21,$b0,$c0,$ff,$3b,$f9,$f0,$6d
    db 0x21, 0xb0, 0xc0, 0xff, 0x3b, 0xf9, 0xf0, 0x6d
; 	DATA BYTE $93,$73,$3f,$bb,$80,$45,$38,$18
    db 0x93, 0x73, 0x3f, 0xbb, 0x80, 0x45, 0x38, 0x18
; 	DATA BYTE $90,$d0,$d0,$10,$21,$92,$d0,$0b
    db 0x90, 0xd0, 0xd0, 0x10, 0x21, 0x92, 0xd0, 0x0b
; 	DATA BYTE $f0,$c0,$07,$9c,$24,$c1,$f0,$be
    db 0xf0, 0xc0, 0x07, 0x9c, 0x24, 0xc1, 0xf0, 0xbe
; 	DATA BYTE $f8,$98,$16,$c0,$00,$13,$79,$1f
    db 0xf8, 0x98, 0x16, 0xc0, 0x00, 0x13, 0x79, 0x1f
; 	DATA BYTE $0f,$00,$07,$38,$72,$36,$fe,$03
    db 0x0f, 0x00, 0x07, 0x38, 0x72, 0x36, 0xfe, 0x03
; 	DATA BYTE $e2,$c3,$76,$7d,$03,$22,$93,$62
    db 0xe2, 0xc3, 0x76, 0x7d, 0x03, 0x22, 0x93, 0x62
; 	DATA BYTE $8f,$3e,$90,$4f,$87,$1f,$1d,$15
    db 0x8f, 0x3e, 0x90, 0x4f, 0x87, 0x1f, 0x1d, 0x15
; 	DATA BYTE $fc,$2a,$a1,$b7,$00,$4f,$22,$62
    db 0xfc, 0x2a, 0xa1, 0xb7, 0x00, 0x4f, 0x22, 0x62
; 	DATA BYTE $e2,$e2,$f2,$f2,$f0,$00,$7c,$1f
    db 0xe2, 0xe2, 0xf2, 0xf2, 0xf0, 0x00, 0x7c, 0x1f
; 	DATA BYTE $07,$81,$c1,$c4,$c7,$0f,$e3,$9e
    db 0x07, 0x81, 0xc1, 0xc4, 0xc7, 0x0f, 0xe3, 0x9e
; 	DATA BYTE $27,$64,$92,$cf,$c8,$2a,$00,$5e
    db 0x27, 0x64, 0x92, 0xcf, 0xc8, 0x2a, 0x00, 0x5e
; 	DATA BYTE $03,$2d,$f3,$4f,$03,$1f,$c0,$c1
    db 0x03, 0x2d, 0xf3, 0x4f, 0x03, 0x1f, 0xc0, 0xc1
; 	DATA BYTE $f1,$81,$29,$fc,$72,$90,$e0,$bb
    db 0xf1, 0x81, 0x29, 0xfc, 0x72, 0x90, 0xe0, 0xbb
; 	DATA BYTE $40,$16,$88,$9e,$0f,$72,$38,$68
    db 0x40, 0x16, 0x88, 0x9e, 0x0f, 0x72, 0x38, 0x68
; 	DATA BYTE $2b,$c6,$c4,$ff,$0e,$1c,$11,$07
    db 0x2b, 0xc6, 0xc4, 0xff, 0x0e, 0x1c, 0x11, 0x07
; 	DATA BYTE $1f,$7c,$b0,$cf,$af,$9c,$a1,$a0
    db 0x1f, 0x7c, 0xb0, 0xcf, 0xaf, 0x9c, 0xa1, 0xa0
; 	DATA BYTE $78,$fb,$4d,$dd,$fd,$02,$1c,$0e
    db 0x78, 0xfb, 0x4d, 0xdd, 0xfd, 0x02, 0x1c, 0x0e
; 	DATA BYTE $06,$f1,$f0,$e4,$78,$00,$c7,$b0
    db 0x06, 0xf1, 0xf0, 0xe4, 0x78, 0x00, 0xc7, 0xb0
; 	DATA BYTE $74,$f0,$00,$d2,$11,$50,$78,$c0
    db 0x74, 0xf0, 0x00, 0xd2, 0x11, 0x50, 0x78, 0xc0
; 	DATA BYTE $34,$00,$74,$5e,$53,$3f,$00,$74
    db 0x34, 0x00, 0x74, 0x5e, 0x53, 0x3f, 0x00, 0x74
; 	DATA BYTE $1f,$e7,$92,$8d,$ab,$95,$d9,$81
    db 0x1f, 0xe7, 0x92, 0x8d, 0xab, 0x95, 0xd9, 0x81
; 	DATA BYTE $59,$e0,$71,$9f,$f1,$f3,$92,$bf
    db 0x59, 0xe0, 0x71, 0x9f, 0xf1, 0xf3, 0x92, 0xbf
; 	DATA BYTE $e3,$c3,$00,$cd,$1b,$0b,$00,$11
    db 0xe3, 0xc3, 0x00, 0xcd, 0x1b, 0x0b, 0x00, 0x11
; 	DATA BYTE $05,$ce,$cd,$36,$02,$e0,$18,$19
    db 0x05, 0xce, 0xcd, 0x36, 0x02, 0xe0, 0x18, 0x19
; 	DATA BYTE $8a,$02,$30,$60,$40,$c0,$c7,$0c
    db 0x8a, 0x02, 0x30, 0x60, 0x40, 0xc0, 0xc7, 0x0c
; 	DATA BYTE $e3,$e7,$81,$05,$07,$e3,$e0,$5a
    db 0xe3, 0xe7, 0x81, 0x05, 0x07, 0xe3, 0xe0, 0x5a
; 	DATA BYTE $58,$94,$4e,$0c,$3e,$7f,$3f,$51
    db 0x58, 0x94, 0x4e, 0x0c, 0x3e, 0x7f, 0x3f, 0x51
; 	DATA BYTE $68,$06,$00,$0e,$5f,$0c,$de,$46
    db 0x68, 0x06, 0x00, 0x0e, 0x5f, 0x0c, 0xde, 0x46
; 	DATA BYTE $00,$3f,$f8,$78,$06,$00,$38,$3c
    db 0x00, 0x3f, 0xf8, 0x78, 0x06, 0x00, 0x38, 0x3c
; 	DATA BYTE $3c,$74,$17,$00,$70,$30,$00,$7d
    db 0x3c, 0x74, 0x17, 0x00, 0x70, 0x30, 0x00, 0x7d
; 	DATA BYTE $fc,$00,$f5,$2f,$a4,$c4,$90,$50
    db 0xfc, 0x00, 0xf5, 0x2f, 0xa4, 0xc4, 0x90, 0x50
; 	DATA BYTE $7f,$58,$18,$b4,$30,$78,$79,$43
    db 0x7f, 0x58, 0x18, 0xb4, 0x30, 0x78, 0x79, 0x43
; 	DATA BYTE $33,$9d,$8f,$12,$f4,$f0,$70,$ab
    db 0x33, 0x9d, 0x8f, 0x12, 0xf4, 0xf0, 0x70, 0xab
; 	DATA BYTE $10,$e7,$00,$e3,$c1,$c1,$c7,$d9
    db 0x10, 0xe7, 0x00, 0xe3, 0xc1, 0xc1, 0xc7, 0xd9
; 	DATA BYTE $4d,$00,$1b,$ef,$0e,$32,$04,$c9
    db 0x4d, 0x00, 0x1b, 0xef, 0x0e, 0x32, 0x04, 0xc9
; 	DATA BYTE $00,$f9,$40,$60,$38,$bf,$ff,$df
    db 0x00, 0xf9, 0x40, 0x60, 0x38, 0xbf, 0xff, 0xdf
; 	DATA BYTE $cf,$09,$cf,$03,$0f,$7f,$1f,$8f
    db 0xcf, 0x09, 0xcf, 0x03, 0x0f, 0x7f, 0x1f, 0x8f
; 	DATA BYTE $df,$73,$05,$4d,$60,$f0,$18,$18
    db 0xdf, 0x73, 0x05, 0x4d, 0x60, 0xf0, 0x18, 0x18
; 	DATA BYTE $62,$4d,$00,$8c,$71,$dd,$00,$e7
    db 0x62, 0x4d, 0x00, 0x8c, 0x71, 0xdd, 0x00, 0xe7
; 	DATA BYTE $77,$00,$db,$1f,$5a,$b8,$20,$ed
    db 0x77, 0x00, 0xdb, 0x1f, 0x5a, 0xb8, 0x20, 0xed
; 	DATA BYTE $03,$ef,$8f,$c7,$c3,$09,$e1,$c1
    db 0x03, 0xef, 0x8f, 0xc7, 0xc3, 0x09, 0xe1, 0xc1
; 	DATA BYTE $7f,$1e,$5d,$7f,$18,$6e,$3f,$e0
    db 0x7f, 0x1e, 0x5d, 0x7f, 0x18, 0x6e, 0x3f, 0xe0
; 	DATA BYTE $d5,$16,$1c,$08,$a4,$18,$66,$10
    db 0xd5, 0x16, 0x1c, 0x08, 0xa4, 0x18, 0x66, 0x10
; 	DATA BYTE $6e,$63,$41,$af,$1e,$12,$f0,$fc
    db 0x6e, 0x63, 0x41, 0xaf, 0x1e, 0x12, 0xf0, 0xfc
; 	DATA BYTE $51,$9d,$0b,$9f,$9f,$1a,$2e,$70
    db 0x51, 0x9d, 0x0b, 0x9f, 0x9f, 0x1a, 0x2e, 0x70
; 	DATA BYTE $1f,$39,$b2,$c1,$74,$1f,$76,$f0
    db 0x1f, 0x39, 0xb2, 0xc1, 0x74, 0x1f, 0x76, 0xf0
; 	DATA BYTE $a6,$21,$22,$60,$6c,$84,$83,$07
    db 0xa6, 0x21, 0x22, 0x60, 0x6c, 0x84, 0x83, 0x07
; 	DATA BYTE $8e,$f0,$de,$b6,$ce,$54,$e3,$04
    db 0x8e, 0xf0, 0xde, 0xb6, 0xce, 0x54, 0xe3, 0x04
; 	DATA BYTE $78,$78,$d2,$87,$d3,$a4,$c0,$d3
    db 0x78, 0x78, 0xd2, 0x87, 0xd3, 0xa4, 0xc0, 0xd3
; 	DATA BYTE $3e,$0c,$22,$04,$fc,$9d,$2d,$75
    db 0x3e, 0x0c, 0x22, 0x04, 0xfc, 0x9d, 0x2d, 0x75
; 	DATA BYTE $c0,$20,$2b,$b4,$b5,$38,$3e,$70
    db 0xc0, 0x20, 0x2b, 0xb4, 0xb5, 0x38, 0x3e, 0x70
; 	DATA BYTE $f8,$94,$1b,$3f,$8f,$93,$24,$fa
    db 0xf8, 0x94, 0x1b, 0x3f, 0x8f, 0x93, 0x24, 0xfa
; 	DATA BYTE $f7,$3f,$86,$54,$fa,$9b,$fd,$f0
    db 0xf7, 0x3f, 0x86, 0x54, 0xfa, 0x9b, 0xfd, 0xf0
; 	DATA BYTE $e2,$1f,$c6,$60,$8f,$a8,$2f,$64
    db 0xe2, 0x1f, 0xc6, 0x60, 0x8f, 0xa8, 0x2f, 0x64
; 	DATA BYTE $a3,$24,$00,$87,$e0,$f0,$ce,$0b
    db 0xa3, 0x24, 0x00, 0x87, 0xe0, 0xf0, 0xce, 0x0b
; 	DATA BYTE $56,$a8,$04,$b8,$63,$01,$e9,$5a
    db 0x56, 0xa8, 0x04, 0xb8, 0x63, 0x01, 0xe9, 0x5a
; 	DATA BYTE $ec,$b2,$79,$f8,$6c,$1f,$c6,$31
    db 0xec, 0xb2, 0x79, 0xf8, 0x6c, 0x1f, 0xc6, 0x31
; 	DATA BYTE $7f,$7f,$01,$c0,$22,$81,$c1,$3c
    db 0x7f, 0x7f, 0x01, 0xc0, 0x22, 0x81, 0xc1, 0x3c
; 	DATA BYTE $60,$f8,$14,$ec,$c4,$13,$93,$70
    db 0x60, 0xf8, 0x14, 0xec, 0xc4, 0x13, 0x93, 0x70
; 	DATA BYTE $13,$78,$30,$ff,$1f,$3f,$cf,$b8
    db 0x13, 0x78, 0x30, 0xff, 0x1f, 0x3f, 0xcf, 0xb8
; 	DATA BYTE $24,$a4,$7c,$a3,$ce,$07,$1d,$96
    db 0x24, 0xa4, 0x7c, 0xa3, 0xce, 0x07, 0x1d, 0x96
; 	DATA BYTE $79,$3f,$c0,$b0,$60,$e0,$f8,$e0
    db 0x79, 0x3f, 0xc0, 0xb0, 0x60, 0xe0, 0xf8, 0xe0
; 	DATA BYTE $96,$5c,$f9,$74,$05,$3e,$81,$81
    db 0x96, 0x5c, 0xf9, 0x74, 0x05, 0x3e, 0x81, 0x81
; 	DATA BYTE $83,$c7,$31,$1a,$ca,$59,$cf,$85
    db 0x83, 0xc7, 0x31, 0x1a, 0xca, 0x59, 0xcf, 0x85
; 	DATA BYTE $85,$3c,$7e,$7e,$3c,$31,$59,$06
    db 0x85, 0x3c, 0x7e, 0x7e, 0x3c, 0x31, 0x59, 0x06
; 	DATA BYTE $00,$37,$71,$25,$89,$69,$34,$d4
    db 0x00, 0x37, 0x71, 0x25, 0x89, 0x69, 0x34, 0xd4
; 	DATA BYTE $31,$1c,$c1,$54,$60,$13,$08,$bc
    db 0x31, 0x1c, 0xc1, 0x54, 0x60, 0x13, 0x08, 0xbc
; 	DATA BYTE $4e,$02,$01,$ae,$09,$40,$e0,$37
    db 0x4e, 0x02, 0x01, 0xae, 0x09, 0x40, 0xe0, 0x37
; 	DATA BYTE $d8,$c6,$f3,$03,$12,$1f,$ef,$e7
    db 0xd8, 0xc6, 0xf3, 0x03, 0x12, 0x1f, 0xef, 0xe7
; 	DATA BYTE $e1,$0f,$e2,$ce,$48,$e3,$e5,$67
    db 0xe1, 0x0f, 0xe2, 0xce, 0x48, 0xe3, 0xe5, 0x67
; 	DATA BYTE $8c,$c0,$f4,$fc,$f8,$5f,$60,$48
    db 0x8c, 0xc0, 0xf4, 0xfc, 0xf8, 0x5f, 0x60, 0x48
; 	DATA BYTE $40,$a1,$fe,$7e,$3e,$1c,$fc,$31
    db 0x40, 0xa1, 0xfe, 0x7e, 0x3e, 0x1c, 0xfc, 0x31
; 	DATA BYTE $04,$ff,$84,$eb,$fe,$9b,$61,$d0
    db 0x04, 0xff, 0x84, 0xeb, 0xfe, 0x9b, 0x61, 0xd0
; 	DATA BYTE $58,$8c,$93,$f1,$d8,$f7,$f0,$b0
    db 0x58, 0x8c, 0x93, 0xf1, 0xd8, 0xf7, 0xf0, 0xb0
; 	DATA BYTE $97,$f8,$99,$87,$e4,$bb,$73,$67
    db 0x97, 0xf8, 0x99, 0x87, 0xe4, 0xbb, 0x73, 0x67
; 	DATA BYTE $c9,$17,$30,$e0,$97,$00,$35,$ff
    db 0xc9, 0x17, 0x30, 0xe0, 0x97, 0x00, 0x35, 0xff
; 	DATA BYTE $ff,$ff,$fe
    db 0xff, 0xff, 0xfe
; 
; image_color:
cvb_image_color:
; 	DATA BYTE $3e,$f1,$3e,$00,$51,$00,$69,$b5
    db 0x3e, 0xf1, 0x3e, 0x00, 0x51, 0x00, 0x69, 0xb5
; 	DATA BYTE $00,$ba,$b7,$07,$bb,$3f,$00,$a5
    db 0x00, 0xba, 0xb7, 0x07, 0xbb, 0x3f, 0x00, 0xa5
; 	DATA BYTE $b7,$07,$53,$38,$cf,$00,$bd,$08
    db 0xb7, 0x07, 0x53, 0x38, 0xcf, 0x00, 0xbd, 0x08
; 	DATA BYTE $bb,$15,$17,$db,$00,$c7,$36,$c5
    db 0xbb, 0x15, 0x17, 0xdb, 0x00, 0xc7, 0x36, 0xc5
; 	DATA BYTE $8f,$07,$c1,$1b,$0e,$c5,$5e,$0d
    db 0x8f, 0x07, 0xc1, 0x1b, 0x0e, 0xc5, 0x5e, 0x0d
; 	DATA BYTE $00,$c7,$5d,$85,$85,$c9,$07,$c5
    db 0x00, 0xc7, 0x5d, 0x85, 0x85, 0xc9, 0x07, 0xc5
; 	DATA BYTE $00,$c1,$bd,$00,$df,$2d,$7e,$07
    db 0x00, 0xc1, 0xbd, 0x00, 0xdf, 0x2d, 0x7e, 0x07
; 	DATA BYTE $72,$17,$2f,$81,$31,$ef,$00,$bc
    db 0x72, 0x17, 0x2f, 0x81, 0x31, 0xef, 0x00, 0xbc
; 	DATA BYTE $07,$47,$ef,$07,$4a,$00,$8f,$fe
    db 0x07, 0x47, 0xef, 0x07, 0x4a, 0x00, 0x8f, 0xfe
; 	DATA BYTE $cd,$2c,$03,$69,$ef,$6c,$59,$00
    db 0xcd, 0x2c, 0x03, 0x69, 0xef, 0x6c, 0x59, 0x00
; 	DATA BYTE $ca,$9e,$00,$09,$07,$a1,$ca,$81
    db 0xca, 0x9e, 0x00, 0x09, 0x07, 0xa1, 0xca, 0x81
; 	DATA BYTE $00,$c8,$d8,$00,$07,$a8,$c7,$00
    db 0x00, 0xc8, 0xd8, 0x00, 0x07, 0xa8, 0xc7, 0x00
; 	DATA BYTE $a1,$8e,$07,$a8,$7b,$ee,$00,$55
    db 0xa1, 0x8e, 0x07, 0xa8, 0x7b, 0xee, 0x00, 0x55
; 	DATA BYTE $ef,$4e,$eb,$52,$79,$db,$07,$be
    db 0xef, 0x4e, 0xeb, 0x52, 0x79, 0xdb, 0x07, 0xbe
; 	DATA BYTE $27,$07,$ed,$09,$c3,$fd,$71,$bd
    db 0x27, 0x07, 0xed, 0x09, 0xc3, 0xfd, 0x71, 0xbd
; 	DATA BYTE $3e,$a1,$a1,$10,$ae,$05,$7e,$00
    db 0x3e, 0xa1, 0xa1, 0x10, 0xae, 0x05, 0x7e, 0x00
; 	DATA BYTE $fe,$a8,$34,$14,$f2,$07,$9d,$3c
    db 0xfe, 0xa8, 0x34, 0x14, 0xf2, 0x07, 0x9d, 0x3c
; 	DATA BYTE $0f,$ed,$0b,$0c,$95,$05,$e2,$a0
    db 0x0f, 0xed, 0x0b, 0x0c, 0x95, 0x05, 0xe2, 0xa0
; 	DATA BYTE $46,$e3,$a7,$42,$a9,$21,$6c,$c8
    db 0x46, 0xe3, 0xa7, 0x42, 0xa9, 0x21, 0x6c, 0xc8
; 	DATA BYTE $bf,$65,$08,$36,$73,$03,$24,$a1
    db 0xbf, 0x65, 0x08, 0x36, 0x73, 0x03, 0x24, 0xa1
; 	DATA BYTE $bc,$04,$00,$fb,$3f,$63,$5d,$fc
    db 0xbc, 0x04, 0x00, 0xfb, 0x3f, 0x63, 0x5d, 0xfc
; 	DATA BYTE $f1,$5b,$07,$c7,$84,$c7,$21,$a8
    db 0xf1, 0x5b, 0x07, 0xc7, 0x84, 0xc7, 0x21, 0xa8
; 	DATA BYTE $d7,$00,$55,$9d,$04,$61,$cf,$9c
    db 0xd7, 0x00, 0x55, 0x9d, 0x04, 0x61, 0xcf, 0x9c
; 	DATA BYTE $db,$00,$5d,$39,$16,$12,$77,$2f
    db 0xdb, 0x00, 0x5d, 0x39, 0x16, 0x12, 0x77, 0x2f
; 	DATA BYTE $64,$71,$13,$63,$a8,$ca,$ad,$00
    db 0x64, 0x71, 0x13, 0x63, 0xa8, 0xca, 0xad, 0x00
; 	DATA BYTE $d1,$5c,$00,$f8,$f8,$cc,$03,$f8
    db 0xd1, 0x5c, 0x00, 0xf8, 0xf8, 0xcc, 0x03, 0xf8
; 	DATA BYTE $3f,$d3,$04,$71,$07,$fc,$e7,$00
    db 0x3f, 0xd3, 0x04, 0x71, 0x07, 0xfc, 0xe7, 0x00
; 	DATA BYTE $df,$2f,$6d,$3b,$55,$77,$07,$79
    db 0xdf, 0x2f, 0x6d, 0x3b, 0x55, 0x77, 0x07, 0x79
; 	DATA BYTE $6b,$08,$77,$71,$00,$8b,$0b,$c8
    db 0x6b, 0x08, 0x77, 0x71, 0x00, 0x8b, 0x0b, 0xc8
; 	DATA BYTE $45,$ed,$0f,$6e,$6f,$7c,$f4,$7f
    db 0x45, 0xed, 0x0f, 0x6e, 0x6f, 0x7c, 0xf4, 0x7f
; 	DATA BYTE $e2,$80,$7d,$73,$f1,$00,$81,$db
    db 0xe2, 0x80, 0x7d, 0x73, 0xf1, 0x00, 0x81, 0xdb
; 	DATA BYTE $00,$c3,$83,$f8,$87,$f7,$b6,$00
    db 0x00, 0xc3, 0x83, 0xf8, 0x87, 0xf7, 0xb6, 0x00
; 	DATA BYTE $6f,$2a,$31,$31,$71,$2b,$03,$3c
    db 0x6f, 0x2a, 0x31, 0x31, 0x71, 0x2b, 0x03, 0x3c
; 	DATA BYTE $f3,$f8,$00,$d1,$91,$8d,$11,$c3
    db 0xf3, 0xf8, 0x00, 0xd1, 0x91, 0x8d, 0x11, 0xc3
; 	DATA BYTE $c3,$af,$25,$1f,$b6,$07,$55,$34
    db 0xc3, 0xaf, 0x25, 0x1f, 0xb6, 0x07, 0x55, 0x34
; 	DATA BYTE $f3,$f3,$6e,$d9,$82,$63,$f1,$06
    db 0xf3, 0xf3, 0x6e, 0xd9, 0x82, 0x63, 0xf1, 0x06
; 	DATA BYTE $f1,$6f,$0f,$8c,$7d,$b8,$b8,$24
    db 0xf1, 0x6f, 0x0f, 0x8c, 0x7d, 0xb8, 0xb8, 0x24
; 	DATA BYTE $c3,$41,$83,$83,$fb,$3f,$51,$00
    db 0xc3, 0x41, 0x83, 0x83, 0xfb, 0x3f, 0x51, 0x00
; 	DATA BYTE $83,$44,$00,$04,$c3,$31,$97,$dd
    db 0x83, 0x44, 0x00, 0x04, 0xc3, 0x31, 0x97, 0xdd
; 	DATA BYTE $63,$00,$9d,$6c,$31,$77,$71,$35
    db 0x63, 0x00, 0x9d, 0x6c, 0x31, 0x77, 0x71, 0x35
; 	DATA BYTE $36,$00,$f3,$00,$ea,$28,$05,$59
    db 0x36, 0x00, 0xf3, 0x00, 0xea, 0x28, 0x05, 0x59
; 	DATA BYTE $fb,$34,$43,$9d,$3a,$15,$74,$79
    db 0xfb, 0x34, 0x43, 0x9d, 0x3a, 0x15, 0x74, 0x79
; 	DATA BYTE $3a,$fb,$fb,$6c,$05,$9e,$00,$b8
    db 0x3a, 0xfb, 0xfb, 0x6c, 0x05, 0x9e, 0x00, 0xb8
; 	DATA BYTE $65,$00,$39,$04,$9b,$14,$57,$2d
    db 0x65, 0x00, 0x39, 0x04, 0x9b, 0x14, 0x57, 0x2d
; 	DATA BYTE $07,$67,$b2,$00,$f8,$4c,$d1,$43
    db 0x07, 0x67, 0xb2, 0x00, 0xf8, 0x4c, 0xd1, 0x43
; 	DATA BYTE $83,$e6,$4e,$9d,$56,$67,$f6,$08
    db 0x83, 0xe6, 0x4e, 0x9d, 0x56, 0x67, 0xf6, 0x08
; 	DATA BYTE $3e,$00,$f1,$00,$c3,$0b,$b8,$b3
    db 0x3e, 0x00, 0xf1, 0x00, 0xc3, 0x0b, 0xb8, 0xb3
; 	DATA BYTE $c6,$00,$b1,$d7,$00,$6b,$db,$00
    db 0xc6, 0x00, 0xb1, 0xd7, 0x00, 0x6b, 0xdb, 0x00
; 	DATA BYTE $77,$0e,$73,$8f,$87,$69,$0a,$04
    db 0x77, 0x0e, 0x73, 0x8f, 0x87, 0x69, 0x0a, 0x04
; 	DATA BYTE $df,$7f,$9a,$76,$6c,$73,$b1,$ed
    db 0xdf, 0x7f, 0x9a, 0x76, 0x6c, 0x73, 0xb1, 0xed
; 	DATA BYTE $0e,$a6,$68,$db,$6f,$96,$79,$07
    db 0x0e, 0xa6, 0x68, 0xdb, 0x6f, 0x96, 0x79, 0x07
; 	DATA BYTE $69,$69,$0f,$f6,$07,$d7,$6b,$19
    db 0x69, 0x69, 0x0f, 0xf6, 0x07, 0xd7, 0x6b, 0x19
; 	DATA BYTE $8f,$74,$f1,$ae,$a0,$6e,$de,$70
    db 0x8f, 0x74, 0xf1, 0xae, 0xa0, 0x6e, 0xde, 0x70
; 	DATA BYTE $fe,$6c,$be,$21,$13,$6b,$f3,$3e
    db 0xfe, 0x6c, 0xbe, 0x21, 0x13, 0x6b, 0xf3, 0x3e
; 	DATA BYTE $ce,$63,$67,$47,$b3,$c1,$e1,$fb
    db 0xce, 0x63, 0x67, 0x47, 0xb3, 0xc1, 0xe1, 0xfb
; 	DATA BYTE $9f,$c7,$3b,$56,$f1,$4f,$8d,$d0
    db 0x9f, 0xc7, 0x3b, 0x56, 0xf1, 0x4f, 0x8d, 0xd0
; 	DATA BYTE $b4,$35,$7c,$ca,$95,$04,$e0,$0d
    db 0xb4, 0x35, 0x7c, 0xca, 0x95, 0x04, 0xe0, 0x0d
; 	DATA BYTE $c3,$f3,$c1,$c3,$b9,$05,$0e,$c3
    db 0xc3, 0xf3, 0xc1, 0xc3, 0xb9, 0x05, 0x0e, 0xc3
; 	DATA BYTE $e6,$07,$7e,$00,$3f,$97,$3c,$0e
    db 0xe6, 0x07, 0x7e, 0x00, 0x3f, 0x97, 0x3c, 0x0e
; 	DATA BYTE $31,$13,$fe,$17,$ff,$ff,$ff,$ff
    db 0x31, 0x13, 0xfe, 0x17, 0xff, 0xff, 0xff, 0xff
; 	DATA BYTE $c0
    db 0xc0
; 
; 	' Width = 22, height = 24
; image_pattern:
cvb_image_pattern:
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$07,$08,$0b,$03,$04,$0c,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
    db 0x08, 0x09, 0x0a, 0x07, 0x08, 0x0b, 0x03, 0x04
    db 0x0c, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$0d,$0e,$0f,$01,$10,$11,$12,$01,$01,$13,$01,$01,$14,$01,$15,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x0d, 0x0e, 0x0f, 0x01, 0x10, 0x11
    db 0x12, 0x01, 0x01, 0x13, 0x01, 0x01, 0x14, 0x01
    db 0x15, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$16,$17,$18,$19,$1a,$01,$1b,$1c,$1d,$1e,$1f,$20,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x16, 0x17, 0x18
    db 0x19, 0x1a, 0x01, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
    db 0x20, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$22,$01,$23,$24,$25,$26,$27,$01,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x21, 0x22, 0x01, 0x23
    db 0x24, 0x25, 0x26, 0x27, 0x01, 0x01
; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$01
    db 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    db 0x01, 0x01, 0x01, 0x01, 0x28, 0x29, 0x2a, 0x2b
    db 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x01
; 	DATA BYTE $01,$01,$31,$32,$33,$01,$01,$01,$34,$01,$01,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
    db 0x01, 0x01, 0x31, 0x32, 0x33, 0x01, 0x01, 0x01
    db 0x34, 0x01, 0x01, 0x35, 0x36, 0x37, 0x38, 0x39
    db 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f
; 	DATA BYTE $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$38,$38,$4d,$4e,$4f,$50,$51,$52,$53
    db 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47
    db 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x38, 0x38, 0x4d
    db 0x4e, 0x4f, 0x50, 0x51, 0x52, 0x53
; 	DATA BYTE $38,$38,$38,$38,$38,$38,$54,$55,$56,$56,$57,$38,$38,$38,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
    db 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x54, 0x55
    db 0x56, 0x56, 0x57, 0x38, 0x38, 0x38, 0x58, 0x59
    db 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f
; 	DATA BYTE $38,$38,$38,$38,$38,$38,$60,$61,$62,$63,$64,$38,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e
    db 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x60, 0x61
    db 0x62, 0x63, 0x64, 0x38, 0x65, 0x66, 0x67, 0x68
    db 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e
; 	DATA BYTE $38,$38,$6f,$70,$71,$38,$38,$72,$73,$74,$38,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$38
    db 0x38, 0x38, 0x6f, 0x70, 0x71, 0x38, 0x38, 0x72
    db 0x73, 0x74, 0x38, 0x75, 0x76, 0x77, 0x78, 0x79
    db 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x38
; 	DATA BYTE $7f,$7f,$80,$81,$82,$7f,$7f,$83,$7f,$84,$7f,$85,$86,$87,$88,$89,$8a,$7f,$8b,$8c,$7f,$7f
    db 0x7f, 0x7f, 0x80, 0x81, 0x82, 0x7f, 0x7f, 0x83
    db 0x7f, 0x84, 0x7f, 0x85, 0x86, 0x87, 0x88, 0x89
    db 0x8a, 0x7f, 0x8b, 0x8c, 0x7f, 0x7f
; 	DATA BYTE $8d,$8e,$8f,$90,$91,$8d,$8d,$8d,$8d,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$8d,$8d,$8d
    db 0x8d, 0x8e, 0x8f, 0x90, 0x91, 0x8d, 0x8d, 0x8d
    db 0x8d, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98
    db 0x99, 0x9a, 0x9b, 0x8d, 0x8d, 0x8d
; 	DATA BYTE $8d,$8d,$9c,$9d,$9e,$9f,$8d,$8d,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$8d,$8d,$8d
    db 0x8d, 0x8d, 0x9c, 0x9d, 0x9e, 0x9f, 0x8d, 0x8d
    db 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7
    db 0xa8, 0xa9, 0xaa, 0x8d, 0x8d, 0x8d
; 	DATA BYTE $8d,$8d,$ab,$ac,$ad,$ae,$8d,$8d,$8d,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$8d,$8d,$8d
    db 0x8d, 0x8d, 0xab, 0xac, 0xad, 0xae, 0x8d, 0x8d
    db 0x8d, 0xaf, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5
    db 0xb6, 0xb7, 0xb8, 0x8d, 0x8d, 0x8d
; 	DATA BYTE $8d,$8d,$b9,$ba,$bb,$bc,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$bd,$be,$bf,$c0,$c1,$8d,$8d,$8d,$8d
    db 0x8d, 0x8d, 0xb9, 0xba, 0xbb, 0xbc, 0x8d, 0x8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0xbd, 0xbe, 0xbf
    db 0xc0, 0xc1, 0x8d, 0x8d, 0x8d, 0x8d
; 	DATA BYTE $8d,$c2,$c3,$c4,$c5,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$c6,$c7,$c8,$c9,$ca,$cb,$8d,$8d,$8d,$8d
    db 0x8d, 0xc2, 0xc3, 0xc4, 0xc5, 0x8d, 0x8d, 0x8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0xc6, 0xc7, 0xc8, 0xc9
    db 0xca, 0xcb, 0x8d, 0x8d, 0x8d, 0x8d
; 	DATA BYTE $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d
; 	DATA BYTE $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d
    db 0x8d, 0x8d, 0x8d, 0x8d, 0x8d, 0x8d
; image_sprites:
cvb_image_sprites:
; 	DATA BYTE $24,$03,$0e,$00,$00,$60,$2b,$c0
    db 0x24, 0x03, 0x0e, 0x00, 0x00, 0x60, 0x2b, 0xc0
; 	DATA BYTE $e0,$00,$07,$80,$00,$80,$c0,$00
    db 0xe0, 0x00, 0x07, 0x80, 0x00, 0x80, 0xc0, 0x00
; 	DATA BYTE $10,$10,$18,$82,$00,$1c,$1c,$1e
    db 0x10, 0x10, 0x18, 0x82, 0x00, 0x1c, 0x1c, 0x1e
; 	DATA BYTE $0e,$00,$1e,$0f,$0f,$00,$10,$00
    db 0x0e, 0x00, 0x1e, 0x0f, 0x0f, 0x00, 0x10, 0x00
; 	DATA BYTE $e0,$60,$00,$3c,$38,$30,$37,$20
    db 0xe0, 0x60, 0x00, 0x3c, 0x38, 0x30, 0x37, 0x20
; 	DATA BYTE $00,$07,$00,$58,$08,$00,$f0,$00
    db 0x00, 0x07, 0x00, 0x58, 0x08, 0x00, 0xf0, 0x00
; 	DATA BYTE $90,$07,$06,$1e,$06,$04,$00,$b3
    db 0x90, 0x07, 0x06, 0x1e, 0x06, 0x04, 0x00, 0xb3
; 	DATA BYTE $00,$8c,$dc,$1b,$c3,$64,$e2,$80
    db 0x00, 0x8c, 0xdc, 0x1b, 0xc3, 0x64, 0xe2, 0x80
; 	DATA BYTE $d4,$1b,$08,$40,$78,$fc,$fe,$9d
    db 0xd4, 0x1b, 0x08, 0x40, 0x78, 0xfc, 0xfe, 0x9d
; 	DATA BYTE $7b,$80,$83,$3d,$f0,$e0,$c0,$53
    db 0x7b, 0x80, 0x83, 0x3d, 0xf0, 0xe0, 0xc0, 0x53
; 	DATA BYTE $1f,$fb,$27,$7e,$15,$7f,$c0,$03
    db 0x1f, 0xfb, 0x27, 0x7e, 0x15, 0x7f, 0xc0, 0x03
; 	DATA BYTE $0b,$20,$30,$38,$3c,$3e,$64,$00
    db 0x0b, 0x20, 0x30, 0x38, 0x3c, 0x3e, 0x64, 0x00
; 	DATA BYTE $3c,$ef,$46,$f0,$aa,$70,$41,$00
    db 0x3c, 0xef, 0x46, 0xf0, 0xaa, 0x70, 0x41, 0x00
; 	DATA BYTE $93,$38,$3e,$37,$78,$70,$47,$19
    db 0x93, 0x38, 0x3e, 0x37, 0x78, 0x70, 0x47, 0x19
; 	DATA BYTE $ce,$86,$9a,$bc,$1b,$03,$c7,$00
    db 0xce, 0x86, 0x9a, 0xbc, 0x1b, 0x03, 0xc7, 0x00
; 	DATA BYTE $01,$30,$76,$e0,$79,$01,$03,$e2
    db 0x01, 0x30, 0x76, 0xe0, 0x79, 0x01, 0x03, 0xe2
; 	DATA BYTE $12,$0f,$07,$fc,$74,$1b,$00,$0e
    db 0x12, 0x0f, 0x07, 0xfc, 0x74, 0x1b, 0x00, 0x0e
; 	DATA BYTE $c7,$83,$06,$0c,$0c,$1c,$9e,$27
    db 0xc7, 0x83, 0x06, 0x0c, 0x0c, 0x1c, 0x9e, 0x27
; 	DATA BYTE $c0,$17,$0b,$67,$3a,$99,$f2,$78
    db 0xc0, 0x17, 0x0b, 0x67, 0x3a, 0x99, 0xf2, 0x78
; 	DATA BYTE $01,$57,$70,$f8,$07,$19,$31,$31
    db 0x01, 0x57, 0x70, 0xf8, 0x07, 0x19, 0x31, 0x31
; 	DATA BYTE $f4,$9f,$1a,$80,$b2,$a6,$e0,$5f
    db 0xf4, 0x9f, 0x1a, 0x80, 0xb2, 0xa6, 0xe0, 0x5f
; 	DATA BYTE $30,$6e,$c6,$ca,$4d,$f1,$07,$53
    db 0x30, 0x6e, 0xc6, 0xca, 0x4d, 0xf1, 0x07, 0x53
; 	DATA BYTE $14,$de,$eb,$2e,$9b,$e0,$7f,$4b
    db 0x14, 0xde, 0xeb, 0x2e, 0x9b, 0xe0, 0x7f, 0x4b
; 	DATA BYTE $bf,$5c,$9f,$b3,$d9,$7d,$c0,$c1
    db 0xbf, 0x5c, 0x9f, 0xb3, 0xd9, 0x7d, 0xc0, 0xc1
; 	DATA BYTE $69,$05,$db,$9e,$01,$c1,$11,$18
    db 0x69, 0x05, 0xdb, 0x9e, 0x01, 0xc1, 0x11, 0x18
; 	DATA BYTE $3c,$18,$84,$16,$64,$00,$e9,$7a
    db 0x3c, 0x18, 0x84, 0x16, 0x64, 0x00, 0xe9, 0x7a
; 	DATA BYTE $9e,$73,$c5,$c5,$00,$fb,$7e,$7f
    db 0x9e, 0x73, 0xc5, 0xc5, 0x00, 0xfb, 0x7e, 0x7f
; 	DATA BYTE $c9,$3f,$c0,$3d,$fa,$fd,$13,$ff
    db 0xc9, 0x3f, 0xc0, 0x3d, 0xfa, 0xfd, 0x13, 0xff
; 	DATA BYTE $ff,$ff,$ff,$80
    db 0xff, 0xff, 0xff, 0x80
; 
; 
; 
; sprite_overlay:
cvb_sprite_overlay:
    db 0x4a, 0xa5, 0x00, 0x0c
    db 0x46, 0x95, 0x04, 0x05
    db 0x52, 0x7b, 0x08, 0x05
    db 0x46, 0xb0, 0x0c, 0x01
    db 0x54, 0x78, 0x10, 0x05
    db 0x5a, 0x5f, 0x14, 0x08
    db 0x6a, 0x88, 0x18, 0x0c
    db 0x64, 0xc0, 0x1c, 0x0a
    db 0x72, 0x9e, 0x20, 0x08
    db 0x65, 0x70, 0x24, 0x08
    db 0x73, 0x88, 0x28, 0x08
    db 0x77, 0x9c, 0x2c, 0x0f
    db 0x7e, 0x3d, 0x30, 0x0f
    db 0x82, 0x38, 0x34, 0x08
    db 0x84, 0x47, 0x38, 0x03
    db 0x81, 0x74, 0x3c, 0x08
    db 0x80, 0x80, 0x40, 0x03
    db 0x84, 0xb8, 0x44, 0x0b
    db 0x85, 0xa0, 0x48, 0x0b
    db 0x98, 0x3b, 0x4c, 0x0f
    db 0x9a, 0x4a, 0x50, 0x0f
    db 0x96, 0x90, 0x54, 0x03
    db 0x95, 0xb0, 0x58, 0x0b
    db 0x9d, 0x38, 0x5c, 0x0c
    db 208

; 
; TILESET:
cvb_tileset:
; 	DATA BYTE $3e,$00,$86,$00,$01,$03,$89,$00
    db 0x3e, 0x00, 0x86, 0x00, 0x01, 0x03, 0x89, 0x00
; 	DATA BYTE $07,$00,$0e,$e1,$11,$0f,$07,$c6
    db 0x07, 0x00, 0x0e, 0xe1, 0x11, 0x0f, 0x07, 0xc6
; 	DATA BYTE $00,$03,$01,$21,$1b,$01,$17,$0f
    db 0x00, 0x03, 0x01, 0x21, 0x1b, 0x01, 0x17, 0x0f
; 	DATA BYTE $1f,$1f,$9c,$10,$22,$3f,$ca,$08
    db 0x1f, 0x1f, 0x9c, 0x10, 0x22, 0x3f, 0xca, 0x08
; 	DATA BYTE $05,$13,$b0,$12,$13,$3f,$7f,$6c
    db 0x05, 0x13, 0xb0, 0x12, 0x13, 0x3f, 0x7f, 0x6c
; 	DATA BYTE $7f,$2d,$80,$69,$c0,$2b,$34,$06
    db 0x7f, 0x2d, 0x80, 0x69, 0xc0, 0x2b, 0x34, 0x06
; 	DATA BYTE $f0,$0e,$5a,$ff,$00,$6d,$55,$07
    db 0xf0, 0x0e, 0x5a, 0xff, 0x00, 0x6d, 0x55, 0x07
; 	DATA BYTE $6c,$3f,$07,$03,$6c,$0f,$07,$04
    db 0x6c, 0x3f, 0x07, 0x03, 0x6c, 0x0f, 0x07, 0x04
; 	DATA BYTE $65,$0e,$07,$5c,$3c,$41,$3f,$27
    db 0x65, 0x0e, 0x07, 0x5c, 0x3c, 0x41, 0x3f, 0x27
; 	DATA BYTE $69,$80,$07,$39,$52,$9f,$07,$03
    db 0x69, 0x80, 0x07, 0x39, 0x52, 0x9f, 0x07, 0x03
; 	DATA BYTE $d6,$16,$00,$19,$5b,$ff,$3f,$73
    db 0xd6, 0x16, 0x00, 0x19, 0x5b, 0xff, 0x3f, 0x73
; 	DATA BYTE $cc,$1e,$f0,$0f,$0e,$20,$78,$fe
    db 0xcc, 0x1e, 0xf0, 0x0f, 0x0e, 0x20, 0x78, 0xfe
; 	DATA BYTE $ff,$00,$36,$18,$fc,$07,$0c,$ff
    db 0xff, 0x00, 0x36, 0x18, 0xfc, 0x07, 0x0c, 0xff
; 	DATA BYTE $7f,$3f,$3f,$94,$1c,$0f,$09,$60
    db 0x7f, 0x3f, 0x3f, 0x94, 0x1c, 0x0f, 0x09, 0x60
; 	DATA BYTE $c0,$24,$e0,$e0,$c0,$80,$f1,$7a
    db 0xc0, 0x24, 0xe0, 0xe0, 0xc0, 0x80, 0xf1, 0x7a
; 	DATA BYTE $ff,$f4,$07,$3e,$02,$6d,$00,$2a
    db 0xff, 0xf4, 0x07, 0x3e, 0x02, 0x6d, 0x00, 0x2a
; 	DATA BYTE $77,$29,$07,$69,$20,$3b,$f1,$07
    db 0x77, 0x29, 0x07, 0x69, 0x20, 0x3b, 0xf1, 0x07
; 	DATA BYTE $07,$01,$b2,$07,$1f,$08,$d1,$07
    db 0x07, 0x01, 0xb2, 0x07, 0x1f, 0x08, 0xd1, 0x07
; 	DATA BYTE $81,$7c,$17,$5c,$ff,$f2,$08,$d2
    db 0x81, 0x7c, 0x17, 0x5c, 0xff, 0xf2, 0x08, 0xd2
; 	DATA BYTE $06,$c0,$e0,$f8,$2d,$08,$c0,$5e
    db 0x06, 0xc0, 0xe0, 0xf8, 0x2d, 0x08, 0xc0, 0x5e
; 	DATA BYTE $0b,$00,$f8,$f0,$68,$ba,$0a,$1c
    db 0x0b, 0x00, 0xf8, 0xf0, 0x68, 0xba, 0x0a, 0x1c
; 	DATA BYTE $72,$db,$07,$9e,$39,$c0,$19,$00
    db 0x72, 0xdb, 0x07, 0x9e, 0x39, 0xc0, 0x19, 0x00
; 	DATA BYTE $ff,$fe,$21,$95,$22,$05,$00,$51
    db 0xff, 0xfe, 0x21, 0x95, 0x22, 0x05, 0x00, 0x51
; 	DATA BYTE $07,$08,$02,$f0,$f8,$e1,$b1,$24
    db 0x07, 0x08, 0x02, 0xf0, 0xf8, 0xe1, 0xb1, 0x24
; 	DATA BYTE $00,$fc,$12,$ff,$20,$fe,$0d,$fc
    db 0x00, 0xfc, 0x12, 0xff, 0x20, 0xfe, 0x0d, 0xfc
; 	DATA BYTE $fc,$f8,$f8,$af,$10,$0a,$9e,$1a
    db 0xfc, 0xf8, 0xf8, 0xaf, 0x10, 0x0a, 0x9e, 0x1a
; 	DATA BYTE $00,$b8,$00,$08,$74,$06,$b3,$0c
    db 0x00, 0xb8, 0x00, 0x08, 0x74, 0x06, 0xb3, 0x0c
; 	DATA BYTE $7d,$10,$c3,$73,$d1,$7d,$07,$51
    db 0x7d, 0x10, 0xc3, 0x73, 0xd1, 0x7d, 0x07, 0x51
; 	DATA BYTE $cd,$be,$93,$44,$85,$6b,$78,$11
    db 0xcd, 0xbe, 0x93, 0x44, 0x85, 0x6b, 0x78, 0x11
; 	DATA BYTE $78,$30,$00,$b2,$c2,$c9,$e0,$7f
    db 0x78, 0x30, 0x00, 0xb2, 0xc2, 0xc9, 0xe0, 0x7f
; 	DATA BYTE $f3,$78,$e7,$32,$3f,$8d,$00,$7f
    db 0xf3, 0x78, 0xe7, 0x32, 0x3f, 0x8d, 0x00, 0x7f
; 	DATA BYTE $96,$cf,$00,$dc,$0d,$8f,$71,$ba
    db 0x96, 0xcf, 0x00, 0xdc, 0x0d, 0x8f, 0x71, 0xba
; 	DATA BYTE $4e,$00,$07,$f0,$be,$37,$33,$57
    db 0x4e, 0x00, 0x07, 0xf0, 0xbe, 0x37, 0x33, 0x57
; 	DATA BYTE $54,$c7,$bf,$bc,$29,$4e,$c3,$65
    db 0x54, 0xc7, 0xbf, 0xbc, 0x29, 0x4e, 0xc3, 0x65
; 	DATA BYTE $fd,$fd,$b5,$79,$f8,$cf,$65,$01
    db 0xfd, 0xfd, 0xb5, 0x79, 0xf8, 0xcf, 0x65, 0x01
; 	DATA BYTE $00,$f4,$fd,$f6,$f0,$00,$06,$06
    db 0x00, 0xf4, 0xfd, 0xf6, 0xf0, 0x00, 0x06, 0x06
; 	DATA BYTE $04,$7c,$04,$1d,$7c,$dc,$00,$87
    db 0x04, 0x7c, 0x04, 0x1d, 0x7c, 0xdc, 0x00, 0x87
; 	DATA BYTE $99,$7e,$79,$05,$00,$c4,$1d,$20
    db 0x99, 0x7e, 0x79, 0x05, 0x00, 0xc4, 0x1d, 0x20
; 	DATA BYTE $60,$99,$61,$9f,$67,$73,$8b,$21
    db 0x60, 0x99, 0x61, 0x9f, 0x67, 0x73, 0x8b, 0x21
; 	DATA BYTE $d2,$60,$60,$20,$20,$c6,$8f,$dc
    db 0xd2, 0x60, 0x60, 0x20, 0x20, 0xc6, 0x8f, 0xdc
; 	DATA BYTE $1f,$d3,$c9,$fb,$c0,$00,$aa,$c0
    db 0x1f, 0xd3, 0xc9, 0xfb, 0xc0, 0x00, 0xaa, 0xc0
; 	DATA BYTE $87,$18,$3c,$3e,$6c,$7e,$4f,$80
    db 0x87, 0x18, 0x3c, 0x3e, 0x6c, 0x7e, 0x4f, 0x80
; 	DATA BYTE $cb,$a3,$e2,$df,$3c,$cb,$bf,$33
    db 0xcb, 0xa3, 0xe2, 0xdf, 0x3c, 0xcb, 0xbf, 0x33
; 	DATA BYTE $a8,$f1,$f1,$a9,$c5,$08,$f0,$ed
    db 0xa8, 0xf1, 0xf1, 0xa9, 0xc5, 0x08, 0xf0, 0xed
; 	DATA BYTE $00,$da,$22,$55,$08,$7b,$7c,$00
    db 0x00, 0xda, 0x22, 0x55, 0x08, 0x7b, 0x7c, 0x00
; 	DATA BYTE $a8,$ee,$3a,$fb,$04,$10,$df,$e8
    db 0xa8, 0xee, 0x3a, 0xfb, 0x04, 0x10, 0xdf, 0xe8
; 	DATA BYTE $cf,$07,$1f,$87,$03,$1c,$3e,$7f
    db 0xcf, 0x07, 0x1f, 0x87, 0x03, 0x1c, 0x3e, 0x7f
; 	DATA BYTE $31,$cb,$04,$8f,$07,$da,$12,$55
    db 0x31, 0xcb, 0x04, 0x8f, 0x07, 0xda, 0x12, 0x55
; 	DATA BYTE $a8,$00,$0c,$b3,$e7,$86,$8e,$9f
    db 0xa8, 0x00, 0x0c, 0xb3, 0xe7, 0x86, 0x8e, 0x9f
; 	DATA BYTE $f1,$87,$56,$df,$e0,$01,$00,$e1
    db 0xf1, 0x87, 0x56, 0xdf, 0xe0, 0x01, 0x00, 0xe1
; 	DATA BYTE $e3,$e7,$e7,$ef,$ef,$a9,$7c,$de
    db 0xe3, 0xe7, 0xe7, 0xef, 0xef, 0xa9, 0x7c, 0xde
; 	DATA BYTE $d1,$ff,$75,$bb,$35,$58,$79,$57
    db 0xd1, 0xff, 0x75, 0xbb, 0x35, 0x58, 0x79, 0x57
; 	DATA BYTE $00,$86,$ff,$80,$48,$7f,$1f,$03
    db 0x00, 0x86, 0xff, 0x80, 0x48, 0x7f, 0x1f, 0x03
; 	DATA BYTE $c3,$c1,$39,$c1,$80,$1f,$7f,$a5
    db 0xc3, 0xc1, 0x39, 0xc1, 0x80, 0x1f, 0x7f, 0xa5
; 	DATA BYTE $0f,$94,$cf,$f9,$0c,$81,$60,$11
    db 0x0f, 0x94, 0xcf, 0xf9, 0x0c, 0x81, 0x60, 0x11
; 	DATA BYTE $3b,$03,$1f,$13,$3a,$08,$b8,$6d
    db 0x3b, 0x03, 0x1f, 0x13, 0x3a, 0x08, 0xb8, 0x6d
; 	DATA BYTE $83,$45,$0a,$b5,$0f,$00,$b6,$ed
    db 0x83, 0x45, 0x0a, 0xb5, 0x0f, 0x00, 0xb6, 0xed
; 	DATA BYTE $86,$3e,$dd,$17,$c9,$6b,$f7,$7f
    db 0x86, 0x3e, 0xdd, 0x17, 0xc9, 0x6b, 0xf7, 0x7f
; 	DATA BYTE $ff,$ff,$ff,$fe
    db 0xff, 0xff, 0xff, 0xfe

; COLORSET1:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b
cvb_colorset1:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b
    db 0x0b, 0x0b
; COLORSET2:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$cb,$cb,$b,$b
cvb_colorset2:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0xcb, 0xcb
    db 0x0b, 0x0b
; COLORSET3:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$cb,$cb,$b,$b,$4b,$4b,$b,$b
cvb_colorset3:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b
    db 0x0b, 0x0b, 0xcb, 0xcb, 0x0b, 0x0b, 0x4b, 0x4b
    db 0x0b, 0x0b
; COLORSET4:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$cb,$b,$b,$4b,$4b,$b,$b,$7b,$7b,$b,$b
cvb_colorset4:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0xcb
    db 0x0b, 0x0b, 0x4b, 0x4b, 0x0b, 0x0b, 0x7b, 0x7b
    db 0x0b, 0x0b
; COLORSET5:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$4b,$b,$b,$7b,$7b,$cb,$cb,$3b,$3b,$b,$b
cvb_colorset5:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x4b
    db 0x0b, 0x0b, 0x7b, 0x7b, 0xcb, 0xcb, 0x3b, 0x3b
    db 0x0b, 0x0b
; COLORSET6:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$7b,$cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b,$b,$b
cvb_colorset6:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x7b
    db 0xcb, 0xcb, 0x3b, 0x3b, 0x4b, 0x4b, 0x6b, 0x6b
    db 0x0b, 0x0b
; COLORSET7:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$3b,$4b,$4b,$6b,$6b,$7b,$7b,$ab,$ab,$cb,$cb
cvb_colorset7:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x3b
    db 0x4b, 0x4b, 0x6b, 0x6b, 0x7b, 0x7b, 0xab, 0xab
    db 0xcb, 0xcb
; COLORSET8:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$6b,$7b,$7b,$ab,$ab,$3b,$3b,$cb,$cb,$4b,$4b
cvb_colorset8:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x6b
    db 0x7b, 0x7b, 0xab, 0xab, 0x3b, 0x3b, 0xcb, 0xcb
    db 0x4b, 0x4b
; COLORSET9:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$ab,$3b,$3b,$cb,$cb,$6b,$6b,$4b,$4b,$7b,$7b
cvb_colorset9:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0xab
    db 0x3b, 0x3b, 0xcb, 0xcb, 0x6b, 0x6b, 0x4b, 0x4b
    db 0x7b, 0x7b
; COLORSET10:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$cb,$6b,$6b,$4b,$4b,$ab,$ab,$7b,$7b,$3b,$3b
cvb_colorset10:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0xcb
    db 0x6b, 0x6b, 0x4b, 0x4b, 0xab, 0xab, 0x7b, 0x7b
    db 0x3b, 0x3b
; COLORSET11:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$4b,$ab,$ab,$7b,$7b,$cb,$cb,$3b,$3b,$6b,$6b
cvb_colorset11:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x4b
    db 0xab, 0xab, 0x7b, 0x7b, 0xcb, 0xcb, 0x3b, 0x3b
    db 0x6b, 0x6b
; COLORSET12:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$7b,$cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b,$ab,$ab
cvb_colorset12:
    db 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x7b
    db 0xcb, 0xcb, 0x3b, 0x3b, 0x4b, 0x4b, 0x6b, 0x6b
    db 0xab, 0xab


cvb_pnt:
; 	DATA BYTE $1b,$31,$ae,$c0,$00,$28,$1c,$1e
    db 0x1b, 0x31, 0xae, 0xc0, 0x00, 0x28, 0x1c, 0x1e
; 	DATA BYTE $1d,$29,$11,$29,$2e,$1f,$00,$20
    db 0x1d, 0x29, 0x11, 0x29, 0x2e, 0x1f, 0x00, 0x20
; 	DATA BYTE $24,$c3,$0f,$30,$22,$23,$78,$1e
    db 0x24, 0xc3, 0x0f, 0x30, 0x22, 0x23, 0x78, 0x1e
; 	DATA BYTE $2f,$8a,$00,$44,$60,$03,$53,$70
    db 0x2f, 0x8a, 0x00, 0x44, 0x60, 0x03, 0x53, 0x70
; 	DATA BYTE $87,$46,$62,$1c,$3b,$58,$07,$10
    db 0x87, 0x46, 0x62, 0x1c, 0x3b, 0x58, 0x07, 0x10
; 	DATA BYTE $27,$37,$71,$06,$80,$1f,$2c,$89
    db 0x27, 0x37, 0x71, 0x06, 0x80, 0x1f, 0x2c, 0x89
; 	DATA BYTE $4a,$69,$3e,$55,$00,$72,$83,$48
    db 0x4a, 0x69, 0x3e, 0x55, 0x00, 0x72, 0x83, 0x48
; 	DATA BYTE $67,$3c,$5c,$73,$19,$03,$1b,$21
    db 0x67, 0x3c, 0x5c, 0x73, 0x19, 0x03, 0x1b, 0x21
; 	DATA BYTE $31,$50,$79,$02,$78,$1f,$26,$85
    db 0x31, 0x50, 0x79, 0x02, 0x78, 0x1f, 0x26, 0x85
; 	DATA BYTE $00,$42,$64,$3d,$54,$01,$09,$41
    db 0x00, 0x42, 0x64, 0x3d, 0x54, 0x01, 0x09, 0x41
; 	DATA BYTE $65,$00,$00,$5a,$77,$86,$45,$61
    db 0x65, 0x00, 0x00, 0x5a, 0x77, 0x86, 0x45, 0x61
; 	DATA BYTE $18,$51,$37,$75,$08,$80,$1f,$25
    db 0x18, 0x51, 0x37, 0x75, 0x08, 0x80, 0x1f, 0x25
; 	DATA BYTE $0d,$11,$0f,$0b,$0b,$30,$0a,$1a
    db 0x0d, 0x11, 0x0f, 0x0b, 0x0b, 0x30, 0x0a, 0x1a
; 	DATA BYTE $1f,$56,$78,$03,$80,$47,$68,$04
    db 0x1f, 0x56, 0x78, 0x03, 0x80, 0x47, 0x68, 0x04
; 	DATA BYTE $52,$05,$5c,$a4,$00,$2b,$88,$43
    db 0x52, 0x05, 0x5c, 0xa4, 0x00, 0x2b, 0x88, 0x43
; 	DATA BYTE $66,$3a,$5c,$76,$81,$06,$40,$6a
    db 0x66, 0x3a, 0x5c, 0x76, 0x81, 0x06, 0x40, 0x6a
; 	DATA BYTE $38,$57,$14,$b8,$1f,$2a,$00,$84
    db 0x38, 0x57, 0x14, 0xb8, 0x1f, 0x2a, 0x00, 0x84
; 	DATA BYTE $4b,$6b,$3f,$5b,$74,$82,$49,$0d
    db 0x4b, 0x6b, 0x3f, 0x5b, 0x74, 0x82, 0x49, 0x0d
; 	DATA BYTE $63,$39,$59,$10,$71,$1f,$2d,$40
    db 0x63, 0x39, 0x59, 0x10, 0x71, 0x1f, 0x2d, 0x40
; 	DATA BYTE $62,$00,$0e,$16,$15,$0c,$13,$1b
    db 0x62, 0x00, 0x0e, 0x16, 0x15, 0x0c, 0x13, 0x1b
; 	DATA BYTE $17,$12,$31,$eb,$e7,$00,$ff,$ff
    db 0x17, 0x12, 0x31, 0xeb, 0xe7, 0x00, 0xff, 0xff
; 	DATA BYTE $ff,$fe
    db 0xff, 0xfe
; 
; 	
; 
