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
ASCII_TABLE:        EQU $006A
NUMBER_TABLE:       EQU $006C
PLAY_SONGS:         EQU $1F61
GAME_OPT:           EQU $1F7C
FILL_VRAM:          EQU $1F82
INIT_TABLE:         EQU $1FB8
PUT_VRAM:           EQU $1FBE
INIT_SPR_NM_TBL:    EQU $1FC1
WR_SPR_NM_TBL:      EQU $1FC4
INIT_TIMER:         EQU $1FC7
FREE_SIGNAL:        EQU $1FCA
REQUEST_SIGNAL:     EQU $1FCD
TEST_SIGNAL:        EQU $1FD0
TIME_MGR:           EQU $1FD3
WRITE_REGISTER:     EQU $1FD9
READ_REGISTER:      EQU $1FDC
WRITE_VRAM:         EQU $1FDF
READ_VRAM:          EQU $1FE2
POLLER:             EQU $1FEB
SOUND_INIT:         EQU $1FEE
PLAY_IT:            EQU $1FF1
SOUND_MAN:          EQU $1FF4
RAND_GEN:           EQU $1FFD

COLECO_TITLE_ON:    EQU $55AA
COLECO_TITLE_OFF:   EQU $AA55


; SOUND DEFINITIONS *************************
OPENING_TUNE_SND_0A:   EQU $01
BACKGROUND_TUNE_0A:    EQU $02
OPENING_TUNE_SND_0B:   EQU $03
BACKGROUND_TUNE_0B:    EQU $04
GRAB_CHERRIES_SND:     EQU $05
BOUNCING_BALL_SND_0A:  EQU $06
BOUNCING_BALL_SND_0B:  EQU $07
BALL_STUCK_SND:        EQU $08
BALL_RETURN_SND:       EQU $09
APPLE_FALLING_SND:     EQU $0A
APPLE_BREAK_SND_0A:    EQU $0B
APPLE_BREAK_SND_0B:    EQU $0C
NO_EXTRA_TUNE_0A:      EQU $0D
NO_EXTRA_TUNE_0B:      EQU $0E
NO_EXTRA_TUNE_0C:      EQU $0F
DIAMOND_SND:           EQU $10
EXTRA_WALKING_TUNE_0A: EQU $11
EXTRA_WALKING_TUNE_0B: EQU $12
GAME_OVER_TUNE_0A:     EQU $13
GAME_OVER_TUNE_0B:     EQU $14
WIN_EXTRA_DO_TUNE_0A:  EQU $15
WIN_EXTRA_DO_TUNE_0B:  EQU $16
END_OF_ROUND_TUNE_0A:  EQU $17
END_OF_ROUND_TUNE_0B:  EQU $18
LOSE_LIFE_TUNE_0A:     EQU $19
LOSE_LIFE_TUNE_0B:     EQU $1A
BLUE_CHOMPER_SND_0A:   EQU $1B
BLUE_CHOMPER_SND_0B:   EQU $1C


; RAM DEFINITIONS ***************************
SPRITE_ORDER_TABLE:  EQU $7000
TIMER_DATA_BLOCK:    EQU $7014

SOUND_BANK_01_RAM:   EQU $702B
SOUND_BANK_02_RAM:   EQU $7035
SOUND_BANK_03_RAM:   EQU $703F
SOUND_BANK_04_RAM:   EQU $7049
SOUND_BANK_05_RAM:   EQU $7053
SOUND_BANK_06_RAM:   EQU $705D
SOUND_BANK_07_RAM:   EQU $7067
SOUND_BANK_08_RAM:   EQU $7071
SOUND_BANK_09_RAM:   EQU $707B

CONTROLLER_BUFFER:   EQU $7086
KEYBOARD_P1:         EQU $708C
KEYBOARD_P2:         EQU $7091
TIMER_TABLE:         EQU $709E
SPRITE_NAME_TABLE:   EQU $70E9

BADGUY_BHVR_CNT_RAM: EQU $7139 ; HOW MANY BYTES IN TABLE
BADGUY_BEHAVIOR_RAM: EQU $713A ; BEHAVIOR TABLE. UP TO 28 ELEMENTS
DIAMOND_RAM:         EQU $7273
CURRENT_LEVEL_RAM:   EQU $7274
LIVES_LEFT_P1_RAM:   EQU $7276
LIVES_LEFT_P2_RAM:   EQU $7277
SCORE_P1_RAM:        EQU $727D ;  $727D/7E  2 BYTES SCORING FOR PLAYER#1. THE LAST DIGIT IS A RED HERRING. I.E. 150 LOOKS LIKE 1500.  SCORE WRAPS AROUND AFTER $FFFF (65535)
SCORE_P2_RAM:        EQU $727F ;  $727F/80  2 BYTES SCORING FOR PLAYER#2

WORK_BUFFER:         EQU $72EF
DEFER_WRITES:        EQU $73C6

FNAME "MR. Do! v1.rom"
CPU Z80


	ORG $8000

    DW COLECO_TITLE_ON         ; SET TO COLECO_TITLE_ON FOR TITLES, COLECO_TITLE_OFF TO TURN THEM OFF
    DW SPRITE_NAME_TABLE
    DW SPRITE_ORDER_TABLE
    DW WORK_BUFFER
    DW CONTROLLER_BUFFER
    DW START

	RET
    NOP
    NOP
	RET
    NOP
    NOP
	RET
    NOP
    NOP
	RET
    NOP
    NOP
	RET
    NOP
    NOP
	RET
    NOP
    NOP
	RETI
    NOP
    JP      NMI

	DB "MR. DO!",1EH,1FH
	DB "/PRESENTS UNIVERSAL'S/1983"

NMI:
    PUSH    AF
    PUSH    BC
    PUSH    DE
    PUSH    HL
    EX      AF, AF'
    EXX
    PUSH    AF
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    PUSH    IY
    LD      BC, 1C2H
    CALL    WRITE_REGISTER
    CALL    READ_REGISTER
    LD      HL, WORK_BUFFER
    LD      DE, $7307
    LD      BC, 18H
    LDIR
    LD      HL, $726E
    BIT     5, (HL)
    JR      Z, LOC_807E
    BIT     4, (HL)
    JR      Z, LOC_809F
    LD      A, 14H
    CALL    WR_SPR_NM_TBL
    CALL    SUB_8107
    JR      LOC_809F
LOC_807E:
    LD      A, ($726E)
    BIT     3, A
    JR      NZ, LOC_808D
    LD      A, 14H
    CALL    WR_SPR_NM_TBL
    CALL    SUB_8107
LOC_808D:
    CALL    SUB_80D1
    CALL    SUB_8229
    CALL    SUB_8251
    CALL    DISPLAY_EXTRA_01
    CALL    SUB_82DE
    CALL    TIME_MGR
LOC_809F:
    CALL    POLLER
    CALL    SUB_C952
    LD      HL, $7307
    LD      DE, WORK_BUFFER
    LD      BC, 18H
    LDIR
    LD      HL, $726E
    BIT     7, (HL)
    JR      Z, LOC_80BB
    RES     7, (HL)
    JR      FINISH_NMI
LOC_80BB:
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
FINISH_NMI:
    POP     IY
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    POP     AF
    EXX
    EX      AF, AF'
    POP     HL
    POP     DE
    POP     BC
    POP     AF
RETN

SUB_80D1:
    LD      HL, $7259
    LD      BC, 1401H
LOC_80D7:
    LD      A, (HL)
    AND     A
    JR      Z, LOC_80FF
    LD      E, C
    PUSH    BC
LOC_80DD:
    PUSH    HL
    PUSH    DE
    LD      HL, $7259
    LD      A, E
    CALL    SUB_AC0B
    JR      Z, LOC_80F7
    POP     DE
    PUSH    DE
    LD      HL, $7259
    LD      A, E
    CALL    SUB_ABF6
    POP     DE
    PUSH    DE
    LD      A, E
    CALL    DISPLAY_PLAY_FIELD_PARTS
LOC_80F7:
    POP     DE
    INC     E
    POP     HL
    LD      A, (HL)
    AND     A
    JR      NZ, LOC_80DD
    POP     BC
LOC_80FF:
    LD      A, C
    ADD     A, 8
    LD      C, A
    INC     HL
    DJNZ    LOC_80D7
RET

SUB_8107:
    LD      HL, BYTE_8215
    LD      DE, WORK_BUFFER
    LD      BC, 14H
    LDIR
    LD      A, 3
    LD      ($72E7), A
    LD      A, 13H
    LD      ($72E8), A
    LD      HL, $72F2
    LD      IY, $70F5
    LD      B, 11H
LOC_8125:
    LD      A, (HL)
    AND     A
    JP      NZ, LOC_81DC
    LD      A, (IY+0)
    CP      10H
    JR      NC, LOC_813C
    LD      A, ($72E7)
    LD      (HL), A
    INC     A
    LD      ($72E7), A
    JP      LOC_81DC
LOC_813C:
    PUSH    BC
    PUSH    HL
    PUSH    IY
    LD      DE, 0
    LD      C, (IY+0)
    LD      A, ($726D)
    RES     6, A
    LD      ($726D), A
    AND     3
    CP      1
    JR      C, LOC_81A1
    JR      NZ, LOC_816F
    LD      D, 4
    LD      A, ($70ED)
    SUB     C
    JR      NC, LOC_8160
    CPL
    INC     A
LOC_8160:
    CP      10H
    JR      NC, LOC_81A1
    LD      A, ($726D)
    SET     6, A
    LD      ($726D), A
    DEC     D
    JR      LOC_81A1
LOC_816F:
    LD      D, 8
    LD      A, ($70ED)
    SUB     C
    JR      NC, LOC_8179
    CPL
    INC     A
LOC_8179:
    CP      10H
    JR      NC, LOC_81A1
    LD      A, ($726D)
    SET     6, A
    LD      ($726D), A
    LD      D, 6
    JR      LOC_81A1
LOC_8189:
    DEC     B
    JR      Z, LOC_81C0
    INC     HL
    INC     IY
    INC     IY
    INC     IY
    INC     IY
    LD      A, (IY+0)
    SUB     C
    JR      NC, LOC_819D
    CPL
    INC     A
LOC_819D:
    CP      10H
    JR      NC, LOC_8189
LOC_81A1:
    INC     E
    LD      A, (HL)
    AND     A
    JR      NZ, LOC_8189
    LD      A, E
    CP      D
    JR      C, LOC_81B6
    JR      Z, LOC_81B6
    LD      A, ($72E7)
    LD      (HL), A
    INC     A
    LD      ($72E7), A
    JR      LOC_8189
LOC_81B6:
    LD      A, ($72E8)
    LD      (HL), A
    DEC     A
    LD      ($72E8), A
    JR      LOC_8189
LOC_81C0:
    LD      A, E
    CP      9
    JR      NC, LOC_81D0
    CP      7
    JR      C, LOC_81D8
    LD      A, ($726D)
    BIT     6, A
    JR      Z, LOC_81D8
LOC_81D0:
    LD      A, ($726D)
    SET     7, A
    LD      ($726D), A
LOC_81D8:
    POP     IY
    POP     HL
    POP     BC
LOC_81DC:
    INC     HL
    INC     IY
    INC     IY
    INC     IY
    INC     IY
    DEC     B
    JP      NZ, LOC_8125
    LD      HL, $726D
    LD      A, (HL)
    INC     A
    AND     3
    CP      2
    JR      C, LOC_81FB
    JR      NZ, LOC_81FA
    BIT     7, (HL)
    JR      NZ, LOC_81FB
LOC_81FA:
    XOR     A
LOC_81FB:
    LD      ($726D), A
    LD      DE, SPRITE_ORDER_TABLE
    LD      B, 14H
    LD      IY, WORK_BUFFER
    XOR     A
LOOP_8208:
    LD      H, 0
    LD      L, (IY+0)
    ADD     HL, DE
    LD      (HL), A
    INC     A
    INC     IY
    DJNZ    LOOP_8208
RET

BYTE_8215:
	DB 000,001,002,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000

SUB_8229:
    LD      HL, $7281
    BIT     7, (HL)
    JR      Z, LOCRET_8250
    RES     7, (HL)
    LD      D, 1
    LD      A, ($7286)
    AND     A
    JR      Z, LOC_8241
    ADD     A, 1BH
    CALL    DEAL_WITH_SPRITES
    LD      D, 0
LOC_8241:
    LD      A, ($7284)
    SUB     1
    LD      B, A
    LD      A, ($7285)
    LD      C, A
    LD      A, 81H
    CALL    SUB_B629
LOCRET_8250:
RET

SUB_8251:
    LD      HL, $727C
    BIT     7, (HL)
    JR      Z, LOC_825D
    RES     7, (HL)
    XOR     A
    JR      LOC_8265
LOC_825D:
    BIT     6, (HL)
    JR      Z, LOCRET_8268
    RES     6, (HL)
    LD      A, 1
LOC_8265:
    CALL    PATTERNS_TO_VRAM
LOCRET_8268:
RET

DISPLAY_EXTRA_01:
    LD      A, ($72BC)
    AND     A
    JR      Z, LOC_82AA
    LD      HL, BYTE_82D3
    LD      DE, 2BH
    LD      BC, EXTRA_01_TXT
LOC_8278:
    RRCA
    JR      C, LOC_8282
    INC     HL
    INC     HL
    INC     DE
    INC     DE
    INC     BC
    JR      LOC_8278
LOC_8282:
    LD      A, ($72BC)
    AND     (HL)
    LD      ($72BC), A
    INC     HL
    LD      A, ($726E)
    BIT     1, A
    LD      A, ($72B8)
    JR      Z, LOC_8297
    LD      A, ($72B9)
LOC_8297:
    AND     (HL)
    LD      HL, 0
    JR      Z, LOC_82A0
    LD      HL, 5
LOC_82A0:
    ADD     HL, BC
    LD      A, 2
    LD      IY, 1
    CALL    PUT_VRAM
LOC_82AA:
    LD      A, ($72BB)
    AND     A
    JR      Z, LOCRET_82D2
    LD      HL, BYTE_82D3
    LD      DE, 2BH
LOC_82B6:
    RRCA
    JR      C, LOC_82BF
    INC     HL
    INC     HL
    INC     DE
    INC     DE
    JR      LOC_82B6
LOC_82BF:
    LD      A, ($72BB)
    AND     (HL)
    LD      ($72BB), A
    LD      HL, BYTE_82DD
    LD      A, 2
    LD      IY, 1
    CALL    PUT_VRAM
LOCRET_82D2:
RET

BYTE_82D3:
	DB 254,001,253,002,251,004,247,008,239,016
BYTE_82DD:
	DB 000

SUB_82DE:
    LD      HL, $7272
    BIT     0, (HL)
    JR      Z, LOC_8305
    RES     0, (HL)
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_82F4
    LD      A, ($7275)
LOC_82F4:
    DEC     A
    CP      0AH
    JR      C, LOC_82FB
    LD      A, 9
LOC_82FB:
    LD      HL, BYTE_8333
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      A, (HL)
    JR      LOC_830D
LOC_8305:
    BIT     1, (HL)
    JR      Z, LOC_8310
    RES     1, (HL)
    LD      A, 0EH
LOC_830D:
    CALL    DEAL_WITH_PLAYFIELD
LOC_8310:
    LD      HL, DIAMOND_RAM
    BIT     7, (HL)
    JR      Z, LOCRET_8332
    LD      IX, $722C
    LD      B, (IX+1)
    LD      C, (IX+2)
    LD      D, 0
    BIT     0, (HL)
    JR      NZ, LOC_8329
    LD      D, 4
LOC_8329:
    LD      A, (HL)
    XOR     1
    LD      (HL), A
    LD      A, 8DH
    CALL    SUB_B629
LOCRET_8332:
RET

BYTE_8333:
	DB 010,011,012,013,010,011,012,013,010,011

START:
	LD      HL, $7000
	LD      DE, $7000+1
	LD      BC, $300
	LD      (HL), 0
	LDIR



    LD      DE, SPRITE_ORDER_TABLE
LOC_8340:
    XOR     A
    LD      (DE), A
    INC     DE
    LD      HL, $73B0
    SBC     HL, DE
    LD      A, H
    OR      L
    JR      NZ, LOC_8340
    LD      A, 1
    LD      (DEFER_WRITES+1), A
    LD      A, 0
    LD      (DEFER_WRITES), A
    CALL    INITIALIZE_THE_SOUND
    LD      A, 14H
    CALL    INIT_SPR_NM_TBL
    LD      HL, TIMER_TABLE
    LD      DE, TIMER_DATA_BLOCK
    CALL    INIT_TIMER
    LD      HL, CONTROLLER_BUFFER
    LD      A, 9BH
    LD      (HL), A
    INC     HL
    LD      (HL), A
    JP      LOC_8372
LOC_8372:
    CALL    SUB_83D4
LOC_8375:
    CALL    SUB_84F8
LOC_8378:
    CALL    SUB_8828
    CALL    DEAL_WITH_APPLE_FALLING
    CP      1
    JR      Z, LOC_83AB
    AND     A
    JR      NZ, LOC_83CB
    CALL    DEAL_WITH_BALL
    AND     A
    JR      NZ, LOC_83CB
    CALL    LEADS_TO_CHERRY_STUFF
    AND     A
    JR      NZ, LOC_83CB
    CALL    SUB_A7F4
    AND     A
    JR      NZ, LOC_83AB
    CALL    SUB_9842
    CP      1
    JR      Z, LOC_83AB
    AND     A
    JR      NZ, LOC_83CB
    CALL    SUB_A53E
    AND     A
    JR      Z, LOC_8378
    CP      1
    JR      NZ, LOC_83CB
LOC_83AB:
    LD      IX, $722C
    LD      B, 5
LOOP_83B1:
    BIT     3, (IX+0)
    JR      NZ, LOC_83C0
    LD      DE, 5
    ADD     IX, DE
    DJNZ    LOOP_83B1
    JR      LOC_83C5
LOC_83C0:
    CALL    DEAL_WITH_APPLE_FALLING
    JR      LOC_83AB
LOC_83C5:
    CP      0
    JR      NZ, LOC_83CB
    LD      A, 1
LOC_83CB:
    CALL    GOT_DIAMOND
    CP      3
    JR      Z, LOC_8372
    JR      LOC_8375

SUB_83D4:
    CALL    GET_GAME_OPTIONS
    CALL    INIT_VRAM
    XOR     A
RET

GET_GAME_OPTIONS:
    CALL    GAME_OPT
LOC_83DF:
    CALL    POLLER
    LD      A, (KEYBOARD_P1)
    AND     A
    JR      Z, LOC_83EC
    CP      9
    JR      C, LOC_83F6
LOC_83EC:
    LD      A, (KEYBOARD_P2)
    AND     A
    JR      Z, LOC_83DF
    CP      9
    JR      NC, LOC_83DF
LOC_83F6:
    LD      HL, $726E
    RES     0, (HL)
    CP      5
    JR      C, LOC_8403
    SET     0, (HL)
    SUB     4
LOC_8403:
    LD      ($7271), A
RET

INIT_VRAM:
    LD      BC, 0
    CALL    WRITE_REGISTER
    LD      BC, 1C2H
    CALL    WRITE_REGISTER
    LD      BC, 700H
    CALL    WRITE_REGISTER
    XOR     A
    LD      HL, 1900H
    CALL    INIT_TABLE
    LD      A, 1
    LD      HL, 2000H
    CALL    INIT_TABLE
    LD      A, 2
    LD      HL, 1000H
    CALL    INIT_TABLE
    LD      A, 3
    LD      HL, 0
    CALL    INIT_TABLE
    LD      A, 4
    LD      HL, 1800H
    CALL    INIT_TABLE
    LD      HL, 0
    LD      DE, 4000H
    XOR     A
    CALL    FILL_VRAM
    LD      IX, VARIOUTS_PATTERNS
LOC_844E:
    LD      A, (IX+0)
    AND     A
    JR      Z, LOAD_FONTS
    LD      B, 0
    LD      C, A
    PUSH    BC
    POP     IY
    LD      D, 0
    LD      E, (IX+1)
    LD      L, (IX+2)
    LD      H, (IX+3)
    LD      A, 3
    PUSH    IX
    CALL    PUT_VRAM
    POP     IX
    LD      BC, 4
    ADD     IX, BC
    JR      LOC_844E
LOAD_FONTS:
    LD      HL, (NUMBER_TABLE)
    LD      DE, 0D8H
    LD      IY, 0AH
    LD      A, 3
    CALL    PUT_VRAM
    LD      HL, (ASCII_TABLE)
    LD      DE, 0E2H
    LD      IY, 1AH
    LD      A, 3
    CALL    PUT_VRAM
    LD      HL, (NUMBER_TABLE)
    LD      BC, 0FFE0H
    ADD     HL, BC
    LD      DE, 0FCH
    LD      IY, 3
    LD      A, 3
    CALL    PUT_VRAM
    LD      HL, (NUMBER_TABLE)
    LD      BC, 0FF88H
    ADD     HL, BC
    LD      DE, 0FFH
    LD      IY, 1
    LD      A, 3
    CALL    PUT_VRAM
    LD      A, 1BH
LOAD_GRAPHICS:
    PUSH    AF
    CALL    DEAL_WITH_SPRITES
    POP     AF
    DEC     A
    JP      P, LOAD_GRAPHICS
    LD      HL, EXTRA_SPRITE_PAT
    LD      DE, 60H
    LD      IY, 40H
    LD      A, 1
    CALL    PUT_VRAM
    LD      HL, BALL_SPRITE_PAT
    LD      DE, 0C0H
    LD      IY, 18H
    LD      A, 1
    CALL    PUT_VRAM
    LD      HL, PHASE_01_COLORS
    LD      DE, 0
    LD      IY, 20H
    LD      A, 4
    CALL    PUT_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
RET

SUB_84F8:
    PUSH    AF
    LD      HL, $726E
    SET     7, (HL)
LOC_84FE:
    BIT     7, (HL)
    JR      NZ, LOC_84FE
    POP     AF
    PUSH    AF
    AND     A
    JR      NZ, LOC_850A
    CALL    SUB_851C
LOC_850A:
    CALL    SUB_8585
    POP     AF
    CP      2
    JR      Z, LOC_8515
    CALL    CLEAR_SCREEN_AND_SPRITES_01
LOC_8515:
    CALL    CLEAR_SCREEN_AND_SPRITES_02
    CALL    SUB_87F4
RET

SUB_851C:
    LD      HL, 0
    LD      (SCORE_P1_RAM), HL
    LD      (SCORE_P2_RAM), HL
    LD      A, 1
    LD      (CURRENT_LEVEL_RAM), A
    LD      ($7275), A
    XOR     A
    LD      ($727A), A
    LD      ($727B), A
    LD      A, ($7271)
    CP      2
    LD      A, 3
    JR      NC, LOC_853F
    LD      A, 5
LOC_853F:
    LD      (LIVES_LEFT_P1_RAM), A
    LD      (LIVES_LEFT_P2_RAM), A
    LD      A, ($726E)
    AND     1
    LD      ($726E), A
    LD      A, 1
    CALL    SUB_B286
    LD      HL, $718A
    LD      DE, 3400H
    LD      BC, 0D4H
    CALL    WRITE_VRAM
    LD      HL, $718A
    LD      DE, 3600H
    LD      BC, 0D4H
    CALL    WRITE_VRAM
    CALL    SUB_866B
    LD      HL, $72B8
    LD      B, 0BH
    XOR     A
LOC_8573:
    LD      (HL), A
    INC     HL
    DJNZ    LOC_8573
    LD      A, 8
    LD      ($72BA), A
    LD      A, 7
    LD      ($7278), A
    LD      ($7279), A
RET

SUB_8585:
    XOR     A
    LD      ($72D9), A
    LD      ($72DD), A
    LD      ($7272), A
    LD      (DIAMOND_RAM), A
    LD      HL, $726E
    RES     6, (HL)
    LD      DE, 3400H
    LD      A, ($726E)
    BIT     1, A
    JR      Z, LOC_85A4
    LD      DE, 3600H
LOC_85A4:
    LD      HL, $718A
    LD      BC, 0D4H
    CALL    READ_VRAM
    XOR     A
    LD      (BADGUY_BHVR_CNT_RAM), A
    LD      HL, BADGUY_BEHAVIOR_RAM
    LD      B, 50H
LOC_85B6:
    LD      (HL), A
    INC     HL
    DJNZ    LOC_85B6
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_85C7
    LD      A, ($7275)
LOC_85C7:
    CP      0BH
    JR      C, DEAL_WITH_BADGUY_BEHAVIOR
    SUB     0AH
    JR      LOC_85C7

DEAL_WITH_BADGUY_BEHAVIOR:
    DEC     A
    ADD     A, A
    LD      E, A
    LD      D, 0
    LD      IX, BADGUY_BEHAVIOR
    ADD     IX, DE
    LD      L, (IX+0)
    LD      H, (IX+1)
    LD      A, (HL)
    LD      (BADGUY_BHVR_CNT_RAM), A
    LD      C, (HL)
    LD      B, 0
    INC     HL
    LD      DE, BADGUY_BEHAVIOR_RAM
    LDIR
    LD      HL, TIMER_TABLE
    LD      DE, TIMER_DATA_BLOCK
    CALL    INIT_TIMER
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_8603
    LD      A, ($7275)
LOC_8603:
    CP      0BH
    JR      C, SEND_PHASE_COLORS_TO_VRAM
    SUB     0AH
    JR      LOC_8603

SEND_PHASE_COLORS_TO_VRAM:
    DEC     A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      IY, PLAYFIELD_COLORS
    ADD     IY, BC
    LD      L, (IY+0)
    LD      H, (IY+1)
    LD      DE, 0
    LD      IY, 0CH
    LD      A, 4
    CALL    PUT_VRAM
    LD      HL, $72C3
    LD      B, 16H
    XOR     A
LOC_862E:
    LD      (HL), A
    INC     HL
    DJNZ    LOC_862E
    CALL    SUB_866B
    LD      A, ($72C1)
    AND     7
    LD      ($72C1), A
    LD      A, ($72BA)
    AND     3FH
    LD      ($72BA), A
    LD      HL, $7278
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_8652
    INC     HL
LOC_8652:
    LD      A, (HL)
    CP      7
    JP      NC, LOCRET_866A
    LD      IY, $72B2
LOC_865C:
    LD      (IY+4), 0C0H
    LD      DE, 0FFFAH
    ADD     IY, DE
    INC     A
    CP      7
    JR      NZ, LOC_865C
LOCRET_866A:
RET

SUB_866B:
    LD      HL, $728A
    LD      B, 2EH
    XOR     A
LOOP_8671:
    LD      (HL), A
    INC     HL
    DJNZ    LOOP_8671
RET

CLEAR_SCREEN_AND_SPRITES_01:
    LD      HL, 1000H
    LD      DE, 300H
    LD      A, 0
    CALL    FILL_VRAM
    LD      HL, 1900H
    LD      DE, 80H
    LD      A, 0
    CALL    FILL_VRAM
    LD      HL, SPRITE_NAME_TABLE
    LD      B, 50H
LOOP_8691:
    LD      (HL), 0
    INC     HL
    DJNZ    LOOP_8691
    LD      A, ($726E)
    BIT     1, A
    LD      A, 4
    JR      Z, LOC_86A1
    LD      A, 5
LOC_86A1:
    CALL    DEAL_WITH_PLAYFIELD
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    LD      HL, 0B4H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_86B2:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_86B2
    POP     AF
    LD      HL, $726E
    SET     7, (HL)
LOC_86C0:
    BIT     7, (HL)
    JR      NZ, LOC_86C0
RET

CLEAR_SCREEN_AND_SPRITES_02:
    LD      HL, 1000H
    LD      DE, 300H
    LD      A, 0
    CALL    FILL_VRAM
    LD      HL, 1900H
    LD      DE, 80H
    LD      A, 0
    CALL    FILL_VRAM
    LD      HL, SPRITE_NAME_TABLE
    LD      B, 50H
LOOP_86E0:
    LD      (HL), 0
    INC     HL
    DJNZ    LOOP_86E0
    LD      A, 0A0H
LOOP_TILL_PLAYFIELD_PARTS_ARE_DONE:
    PUSH    AF
    CALL    DISPLAY_PLAY_FIELD_PARTS
    POP     AF
    DEC     A
    JR      NZ, LOOP_TILL_PLAYFIELD_PARTS_ARE_DONE
    LD      A, 1
    CALL    DEAL_WITH_PLAYFIELD
    XOR     A
    CALL    PATTERNS_TO_VRAM
    LD      A, ($726E)
    BIT     0, A
    JR      Z, LOC_8709
    LD      A, 0FH
    CALL    DEAL_WITH_PLAYFIELD
    LD      A, 1
    CALL    PATTERNS_TO_VRAM
LOC_8709:
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_8716
    LD      A, ($7275)
LOC_8716:
    LD      HL, $72E7
    LD      D, 0D8H
    LD      IY, 1
    CP      0AH
    JR      NC, LOC_8728
    ADD     A, 0D8H
    LD      (HL), A
    JR      LOC_8739
LOC_8728:
    CP      0AH
    JR      C, LOC_8731
    SUB     0AH
    INC     D
    JR      LOC_8728
LOC_8731:
    INC     IY
    LD      (HL), D
    INC     HL
    ADD     A, 0D8H
    LD      (HL), A
    DEC     HL
LOC_8739:
    LD      DE, 3DH
    LD      A, 2
    CALL    PUT_VRAM
    LD      A, 2
    CALL    DEAL_WITH_PLAYFIELD
    LD      HL, $72B8
    LD      A, ($726E)
    BIT     1, A
    JR      Z, LOC_8753
    LD      HL, $72B9
LOC_8753:
    LD      DE, 12BH
    LD      BC, 0
LOC_8759:
    LD      A, (HL)
    PUSH    HL
    LD      HL, EXTRA_01_TXT
    AND     D
    JR      Z, SEND_EXTRA_TO_VRAM
    LD      HL, EXTRA_02_TXT
SEND_EXTRA_TO_VRAM:
    ADD     HL, BC
    PUSH    BC
    PUSH    DE
    LD      D, 0
    LD      IY, 1
    LD      A, 2
    CALL    PUT_VRAM
    POP     DE
    POP     BC
    POP     HL
    INC     E
    INC     E
    RLC     D
    INC     C
    LD      A, C
    CP      5
    JR      NZ, LOC_8759
    LD      A, ($726E)
    BIT     1, A
    LD      HL, LIVES_LEFT_P1_RAM
    JR      Z, LOC_878C
    LD      HL, LIVES_LEFT_P2_RAM
LOC_878C:
    LD      B, (HL)
    LD      DE, 35H
SEND_LIVES_TO_VRAM:
    DEC     B
    JR      Z, LOC_87B9
    PUSH    BC
    PUSH    DE
    LD      HL, MR_DO_UPPER
    LD      IY, 1
    LD      A, 2
    CALL    PUT_VRAM
    POP     HL
    PUSH    HL
    LD      DE, 20H
    ADD     HL, DE
    EX      DE, HL
    LD      HL, MR_DO_LOWER
    LD      IY, 1
    LD      A, 2
    CALL    PUT_VRAM
    POP     DE
    POP     BC
    INC     DE
    JR      SEND_LIVES_TO_VRAM
LOC_87B9:
    LD      A, 3
    CALL    DEAL_WITH_PLAYFIELD
    LD      B, 5
    LD      IY, $722C
    LD      A, 0CH
LOOP_87C6:
    BIT     7, (IY+0)
    JR      Z, LOC_87DF
    PUSH    BC
    PUSH    IX
    PUSH    AF
    LD      B, (IY+1)
    LD      C, (IY+2)
    LD      D, 1
    CALL    SUB_B629
    POP     AF
    POP     IX
    POP     BC
LOC_87DF:
    LD      DE, 5
    ADD     IY, DE
    INC     A
    DJNZ    LOOP_87C6
RET

EXTRA_01_TXT:
	DB 050,051,052,053,054
EXTRA_02_TXT:
	DB 072,073,074,075,076
MR_DO_UPPER:
	DB 120
MR_DO_LOWER:
    DB 121

SUB_87F4:
    LD      IY, $7281
    XOR     A
    LD      (IY+6), A
    LD      (IY+7), A
    LD      A, 1
    LD      (IY+1), A
    LD      (IY+5), A
    LD      (IY+3), 0B0H
    LD      (IY+4), 78H
    LD      (IY+0), 0C0H
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    CALL    PLAY_OPENING_TUNE
    LD      HL, 1
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      ($7283), A
    POP     AF
RET

SUB_8828:
    LD      A, ($726E)
    BIT     1, A
    LD      A, (KEYBOARD_P1)
    JR      Z, CHECK_FOR_PAUSE
    LD      A, (KEYBOARD_P2)
CHECK_FOR_PAUSE:
    CP      0AH
    JP      NZ, LOCRET_88D0
    LD      HL, $726E
    SET     7, (HL)
ENTER_PAUSE:
    BIT     7, (HL)
    JR      NZ, ENTER_PAUSE
    SET     5, (HL)
    XOR     A
    LD      HL, 1900H
    LD      DE, 80H
    CALL    FILL_VRAM
    LD      A, 2
    LD      HL, 3800H
    CALL    INIT_TABLE
    LD      HL, $7020
    LD      DE, 3B00H
    LD      BC, 5DH
    CALL    WRITE_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    CALL    PLAY_END_OF_ROUND_TUNE
    LD      B, 2
LOOP_886E:
    LD      HL, 0
LOC_8871:
    DEC     HL
    LD      A, L
    OR      H
    JR      NZ, LOC_8871
    DJNZ    LOOP_886E
LOOP_TILL_UN_PAUSE:
    LD      A, ($726E)
    BIT     1, A
    LD      A, (KEYBOARD_P1)
    JR      Z, CHECK_TO_LEAVE_PAUSE
    LD      A, (KEYBOARD_P2)
CHECK_TO_LEAVE_PAUSE:
    CP      0AH
    JR      NZ, LOOP_TILL_UN_PAUSE
    CALL    INITIALIZE_THE_SOUND
    LD      HL, $726E
    SET     7, (HL)
LOC_8891:
    BIT     7, (HL)
    JR      NZ, LOC_8891
    SET     4, (HL)
    LD      A, 2
    LD      HL, 1000H
    CALL    INIT_TABLE
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    LD      B, 4
LOC_88A7:
    LD      HL, 0
LOC_88AA:
    DEC     HL
    LD      A, L
    OR      H
    JR      NZ, LOC_88AA
    DJNZ    LOC_88A7
    LD      HL, $726E
    SET     7, (HL)
LOC_88B6:
    BIT     7, (HL)
    JR      NZ, LOC_88B6
    LD      A, (HL)
    AND     0CFH
    LD      (HL), A
    LD      HL, $7020
    LD      DE, 3B00H
    LD      BC, 5DH
    CALL    READ_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
LOCRET_88D0:
RET

DEAL_WITH_APPLE_FALLING:
    CALL    LEADS_TO_FALLING_APPLE_03
    XOR     A
    BIT     7, (IY+0)
    JR      Z, LEADS_TO_FALLING_APPLE_04
    LD      A, (IY+0)
    BIT     3, A
    JR      NZ, LEADS_TO_FALLING_APPLE_01
    XOR     A
    CALL    SUB_8E10
    JR      Z, LEADS_TO_FALLING_APPLE_04
    JR      LOC_8941
LEADS_TO_FALLING_APPLE_01:
    LD      A, (IY+3)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LEADS_TO_FALLING_APPLE_04
    LD      A, (IY+0)
    BIT     6, A
    JR      Z, LEADS_TO_FALLING_APPLE_02
    CALL    SUB_8FB0
    JR      NZ, LOC_8941
LEADS_TO_FALLING_APPLE_02:
    LD      A, (IY+0)
    BIT     4, A
    JR      Z, LEADS_TO_FALLING_APPLE_05
    PUSH    IY
    CALL    PLAY_APPLE_BREAKING_SOUND
    POP     IY
    JR      LEADS_TO_FALLING_APPLE_07
LEADS_TO_FALLING_APPLE_05:
    BIT     5, A
    JR      NZ, LEADS_TO_FALLING_APPLE_06
LEADS_TO_FALLING_APPLE_07:
    LD      A, (IY+4)
    LD      B, A
    AND     0CFH
    LD      C, A
    LD      A, B
    ADD     A, 10H
    AND     30H
    OR      C
    LD      (IY+4), A
    AND     30H
    JR      Z, LOC_892A
    JR      LOC_8941
LOC_892A:
    CALL    SUB_89D1
    CALL    DEAL_WITH_RANDOM_DIAMOND
    CALL    DEAL_WITH_LOOSING_LIFE
    JR      LOC_8945
LEADS_TO_FALLING_APPLE_06:
    PUSH    IY
    CALL    PLAY_APPLE_FALLING_SOUND
    POP     IY
    CALL    DEAL_WITH_APPLE_HITTING_SOMETHING
    JR      Z, LOC_8945
LOC_8941:
    CALL    SUB_8972
    XOR     A
LOC_8945:
    PUSH    AF
    CALL    SUB_899A
    POP     AF
LEADS_TO_FALLING_APPLE_04:
    PUSH    AF
    LD      A, ($722A)
    INC     A
    CP      5
    JR      C, LOC_8954
    XOR     A
LOC_8954:
    LD      ($722A), A
    POP     AF
    AND     A
RET

LEADS_TO_FALLING_APPLE_03:
    LD      IY, $722C
    LD      HL, BYTE_896C
    LD      A, ($722A)
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      C, (HL)
    ADD     IY, BC
RET

BYTE_896C:
	DB 000,005,010,015,020,025

SUB_8972:
    LD      HL, 0FH
    LD      A, (IY+0)
    BIT     6, A
    JR      NZ, LOC_8992
    LD      HL, 4
    BIT     5, A
    JR      NZ, LOC_8992
    LD      HL, 19H
    LD      A, (IY+4)
    AND     30H
    CP      20H
    JR      LOC_8992

LOC_8992:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
RET

SUB_899A:
    LD      A, (IY+4)
    RRCA
    RRCA
    RRCA
    RRCA
    AND     3
    LD      D, A
    LD      B, (IY+1)
    LD      C, (IY+2)
    LD      A, (IY+0)
    BIT     6, A
    JR      Z, LOC_89C1
    AND     7
    CP      2
    JR      Z, LOC_89C1
    CP      1
    JR      NZ, LOC_89BF
    DEC     C
    DEC     C
    JR      LOC_89C1
LOC_89BF:
    INC     C
    INC     C
LOC_89C1:
    LD      A, D
    AND     A
    JR      NZ, LOC_89C8
    LD      BC, 808H
LOC_89C8:
    LD      A, ($722A)
    ADD     A, 0CH
    CALL    SUB_B629
RET

SUB_89D1:
    PUSH    IY
    LD      A, (IY+4)
    AND     0FH
    JR      Z, LOC_89E9
    DEC     A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_89EC
    ADD     HL, BC
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    CALL    SUB_B601
LOC_89E9:
    POP     IY
RET

BYTE_89EC:
	DB 100,000,200,000,144,001,088,002,032,003,232,003,176,004,120,005,064,006,008,007,208,007,152,008

DEAL_WITH_RANDOM_DIAMOND:
    PUSH    IY
    CALL    SUB_8A31
    CP      1
    JR      NZ, LOC_8A2E
    CALL    RAND_GEN
    AND     0FH
    CP      2
    JR      NC, LOC_8A2E
    LD      B, (IY+1)
    LD      C, (IY+2)
    LD      IX, $722C
    LD      (IX+1), B
    LD      (IX+2), C
    LD      A, 80H
    LD      (DIAMOND_RAM), A
    CALL    PLAY_DIAMOND_SOUND
LOC_8A2E:
    POP     IY
RET

SUB_8A31:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      IX, $722C
    LD      B, 5
    LD      C, 0
    LD      DE, 5
LOOP_8A40:
    BIT     7, (IX+0)
    JR      Z, LOC_8A47
    INC     C
LOC_8A47:
    ADD     IX, DE
    DJNZ    LOOP_8A40
    LD      A, C
    POP     IX
    POP     DE
    POP     BC
    AND     A
RET

DEAL_WITH_APPLE_HITTING_SOMETHING:
    LD      B, (IY+1)
    LD      C, (IY+2)
    LD      A, C
    AND     0FH
    JR      Z, LOC_8A67
    CP      8
    JR      Z, LOC_8A67
    LD      A, C
    ADD     A, 8
    AND     0F0H
    LD      C, A
LOC_8A67:
    CALL    SUB_8AD9
    LD      A, (IY+1)
    ADD     A, 4
    LD      (IY+1), A
    LD      A, (IY+0)
    INC     A
    LD      B, A
    AND     7
    CP      6
    JR      NC, LOC_8A80
    LD      (IY+0), B
LOC_8A80:
    CALL    SUB_8BF6
    CALL    SUB_8C3A
    CALL    SUB_8C96
    CALL    SUB_8BC0
    LD      A, (IY+1)
    AND     7
    JR      NZ, LOC_8AD7
    CALL    SUB_8D25
    JR      NZ, APPLE_FELL_ON_SOMETHING
    LD      A, 1
    CALL    SUB_8E48
    JR      NZ, LOC_8AD7
    LD      A, (IY+4)
    BIT     7, A
    JR      NZ, APPLE_FELL_ON_SOMETHING
    BIT     6, A
    JR      NZ, APPLE_FELL_ON_SOMETHING
    AND     0FH
    JR      NZ, APPLE_FELL_ON_SOMETHING
    LD      A, (IY+0)
    AND     7
    CP      5
    JR      NC, APPLE_FELL_ON_SOMETHING
    LD      A, 80H
    LD      (IY+0), A
    LD      A, 10H
    LD      (IY+4), A
    XOR     A
    JR      LOC_8AD7
APPLE_FELL_ON_SOMETHING:
    RES     5, (IY+0)
    PUSH    IY
    CALL    PLAY_APPLE_BREAKING_SOUND
    POP     IY
    LD      A, (IY+4)
    ADD     A, 10H
    LD      (IY+4), A
LOC_8AD7:
    AND     A
RET

SUB_8AD9:
    LD      A, B
    AND     0FH
    RET     NZ
    CALL    SUB_AC3F
    DEC     IX
    DEC     D
    LD      A, (IX+11H)
    AND     3
    CP      3
    RET     NZ
    BIT     3, C
    JR      NZ, LOC_8AF7
    LD      A, (IX+10H)
    AND     3
    CP      3
    RET     NZ
LOC_8AF7:
    LD      A, (IX+1)
    AND     0CH
    CP      0CH
    JR      NZ, LOC_8B09
    LD      A, B
    CP      0E8H
    JR      NC, LOC_8B09
    SET     5, (IX+1)
LOC_8B09:
    BIT     0, (IX+1)
    JR      Z, LOC_8B1D
    BIT     1, (IX+0)
    JR      Z, LOC_8B1D
    BIT     3, C
    JR      NZ, LOC_8B1D
    SET     7, (IX+1)
LOC_8B1D:
    LD      A, D
    INC     A
    CALL    SUB_8BB1
    LD      A, B
    CP      0B8H
    JR      NC, LOC_8B54
    LD      A, (IX+1)
    AND     0CH
    CP      0CH
    JR      NZ, LOC_8B34
    SET     4, (IX+11H)
LOC_8B34:
    LD      A, (IX+11H)
    AND     5
    CP      5
    JR      NZ, LOC_8B4E
    LD      A, (IX+10H)
    AND     0AH
    CP      0AH
    JR      NZ, LOC_8B4E
    BIT     3, C
    JR      NZ, LOC_8B4E
    SET     7, (IX+11H)
LOC_8B4E:
    LD      A, D
    ADD     A, 11H
    CALL    SUB_8BB1
LOC_8B54:
    BIT     3, C
    RET     NZ
    LD      A, (IX+0)
    AND     0CH
    CP      0CH
    JR      NZ, LOC_8B69
    LD      A, B
    CP      0B8H
    JR      NC, LOC_8B69
    SET     5, (IX+0)
LOC_8B69:
    LD      A, (IX+0)
    AND     0AH
    CP      0AH
    JR      NZ, LOC_8B7F
    LD      A, (IX+1)
    AND     5
    CP      5
    JR      NZ, LOC_8B7F
    SET     6, (IX+0)
LOC_8B7F:
    LD      A, D
    CALL    SUB_8BB1
    LD      A, B
    CP      0B8H
    RET     NC
    LD      A, (IX+0)
    AND     0CH
    CP      0CH
    JR      NZ, LOC_8B94
    SET     4, (IX+10H)
LOC_8B94:
    LD      A, (IX+10H)
    AND     0AH
    CP      0AH
    JR      NZ, LOC_8BAA
    LD      A, (IX+11H)
    AND     5
    CP      5
    JR      NZ, LOC_8BAA
    SET     6, (IX+10H)
LOC_8BAA:
    LD      A, D
    ADD     A, 10H
    CALL    SUB_8BB1
RET

SUB_8BB1:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    POP     BC
RET

SUB_8BC0:
    LD      A, ($7284)
    LD      D, A
    BIT     7, (IY+4)
    JR      Z, LOC_8BCE
    ADD     A, 4
    JR      LOC_8BE4
LOC_8BCE:
    LD      A, ($7285)
    LD      E, A
    CALL    SUB_8CFE
    JR      NZ, LOC_8BF4
    SET     7, (IY+4)
    LD      A, ($726E)
    SET     6, A
    LD      ($726E), A
    LD      A, D
LOC_8BE4:
    LD      ($7284), A
    XOR     A
    LD      ($7286), A
    LD      A, ($7281)
    SET     7, A
    LD      ($7281), A
    XOR     A
LOC_8BF4:
    AND     A
RET

SUB_8BF6:
    LD      A, ($72BA)
    LD      B, A
    LD      A, 1
    BIT     7, B
    JR      Z, LOC_8C38
    LD      A, ($72BF)
    LD      D, A
    BIT     6, (IY+4)
    JR      Z, LOC_8C0F
    ADD     A, 4
    LD      D, A
    JR      LOC_8C28
LOC_8C0F:
    LD      A, ($72BE)
    LD      E, A
    CALL    SUB_8CFE
    JR      NZ, LOC_8C38
    LD      A, ($72BD)
    SET     7, A
    LD      ($72BD), A
    SET     6, (IY+4)
    INC     (IY+4)
    LD      A, D
LOC_8C28:
    LD      ($72BF), A
    LD      B, D
    LD      A, ($72BE)
    LD      C, A
    LD      D, 0BH
    LD      A, 3
    CALL    SUB_B629
    XOR     A
LOC_8C38:
    AND     A
RET

SUB_8C3A:
    LD      B, 7
    LD      IX, $728E
LOC_8C40:
    PUSH    BC
    BIT     7, (IX+4)
    JR      Z, LOC_8C8D
    BIT     6, (IX+4)
    JR      NZ, LOC_8C8D
    LD      D, (IX+2)
    LD      E, (IX+1)
    BIT     7, (IX+0)
    JR      Z, LOC_8C68
    LD      B, (IX+5)
    LD      A, ($722A)
    CP      B
    JR      NZ, LOC_8C8D
    LD      A, D
    ADD     A, 4
    LD      D, A
    JR      LOC_8C7A
LOC_8C68:
    CALL    SUB_8CFE
    JR      NZ, LOC_8C8D
    SET     7, (IX+0)
    LD      A, ($722A)
    LD      (IX+5), A
    INC     (IY+4)
LOC_8C7A:
    LD      (IX+2), D
    LD      B, D
    LD      C, E
    CALL    SUB_B7EF
    ADD     A, 5
    LD      D, 25H
    PUSH    IX
    CALL    SUB_B629
    POP     IX
LOC_8C8D:
    LD      DE, 6
    ADD     IX, DE
    POP     BC
    DJNZ    LOC_8C40
RET

SUB_8C96:
    LD      B, 3
    LD      IX, $72C7
LOC_8C9C:
    PUSH    BC
    BIT     7, (IX+4)
    JR      Z, LOC_8CF5
    LD      D, (IX+2)
    LD      E, (IX+1)
    BIT     7, (IX+0)
    JR      Z, LOC_8CBE
    LD      B, (IX+5)
    LD      A, ($722A)
    CP      B
    JR      NZ, LOC_8CF5
    LD      A, D
    ADD     A, 4
    LD      D, A
    JR      LOC_8CD0
LOC_8CBE:
    CALL    SUB_8CFE
    JR      NZ, LOC_8CF5
    SET     7, (IX+0)
    LD      A, ($722A)
    LD      (IX+5), A
    INC     (IY+4)
LOC_8CD0:
    LD      (IX+2), D
    LD      B, D
    LD      C, E
    PUSH    IX
    POP     HL
    XOR     A
    LD      DE, $72C7
    AND     A
    SBC     HL, DE
    JR      Z, LOC_8CEA
    LD      DE, 6
LOC_8CE4:
    INC     A
    AND     A
    SBC     HL, DE
    JR      NZ, LOC_8CE4
LOC_8CEA:
    ADD     A, 11H
    LD      D, 5
    PUSH    IX
    CALL    SUB_B629
    POP     IX
LOC_8CF5:
    LD      DE, 6
    ADD     IX, DE
    POP     BC
    DJNZ    LOC_8C9C
RET

SUB_8CFE:
    PUSH    BC
    LD      C, 1
    LD      A, (IY+1)
    SUB     D
    JR      NC, LOC_8D09
    CPL
    INC     A
LOC_8D09:
    CP      8
    JR      NC, LOC_8D21
    LD      A, (IY+2)
    SUB     E
    JR      NC, LOC_8D15
    CPL
    INC     A
LOC_8D15:
    CP      9
    JR      NC, LOC_8D21
    LD      A, (IY+1)
    ADD     A, 4
    LD      D, A
    LD      C, 0
LOC_8D21:
    LD      A, C
    POP     BC
    OR      A
RET

SUB_8D25:
    LD      IX, $722C
    LD      BC, 0
LOC_8D2C:
    LD      A, ($722A)
    CP      C
    JR      Z, LOC_8D80
    LD      A, (IX+0)
    BIT     7, A
    JR      Z, LOC_8D80
    BIT     6, A
    JR      NZ, LOC_8D80
    LD      A, (IY+2)
    SUB     (IX+2)
    JR      NC, LOC_8D47
    CPL
    INC     A
LOC_8D47:
    CP      10H
    JR      NC, LOC_8D80
    LD      A, (IX+1)
    SUB     (IY+1)
    JR      C, LOC_8D80
    CP      9
    JR      NC, LOC_8D80
    RES     6, (IX+0)
    RES     5, (IX+0)
    LD      A, (IY+4)
    AND     0CFH
    OR      20H
    LD      (IX+4), A
    BIT     3, (IX+0)
    JR      NZ, LOC_8D7F
    SET     3, (IX+0)
    LD      HL, 0FH
    XOR     A
    PUSH    BC
    CALL    REQUEST_SIGNAL
    POP     BC
    LD      (IX+3), A
LOC_8D7F:
    INC     B
LOC_8D80:
    LD      DE, 5
    ADD     IX, DE
    INC     C
    LD      A, C
    CP      5
    JR      C, LOC_8D2C
    LD      A, B
    AND     A
RET

DEAL_WITH_LOOSING_LIFE:
    BIT     6, (IY+4)
    JR      Z, LOC_8D9B
    CALL    SUB_B76D
    LD      L, 3
    JR      NZ, LOC_8E05
LOC_8D9B:
    LD      IX, $728E
    LD      B, 7
LOC_8DA1:
    PUSH    BC
    LD      A, (IX+4)
    BIT     7, A
    JR      Z, LOC_8DC5
    BIT     6, A
    JR      NZ, LOC_8DC5
    BIT     7, (IX+0)
    JR      Z, LOC_8DC5
    LD      B, (IX+5)
    LD      A, ($722A)
    CP      B
    JR      NZ, LOC_8DC5
    CALL    SUB_B7C4
    POP     BC
    LD      L, 2
    JR      Z, LOC_8E05
    PUSH    BC
LOC_8DC5:
    LD      DE, 6
    ADD     IX, DE
    POP     BC
    DJNZ    LOC_8DA1
    LD      IX, $72C7
    LD      B, 3
LOOP_8DD3:
    PUSH    BC
    BIT     7, (IX+4)
    JR      Z, LOST_A_LIFE
    BIT     7, (IX+0)
    JR      Z, LOST_A_LIFE
    LD      B, (IX+5)
    LD      A, ($722A)
    CP      B
    JR      NZ, LOST_A_LIFE
    CALL    SUB_B832
LOST_A_LIFE:
    POP     BC
    LD      DE, 6
    ADD     IX, DE
    DJNZ    LOOP_8DD3
    LD      L, 0
    BIT     7, (IY+4)
    JR      Z, LOC_8E05
    PUSH    IY
    CALL    PLAY_LOSE_LIFE_SOUND
    POP     IY
    LD      L, 1
LOC_8E05:
    RES     7, (IY+0)
    RES     3, (IY+0)
    LD      A, L
    AND     A
RET

SUB_8E10:
    CALL    SUB_8E48
    JR      Z, LOC_8E46
    LD      E, A
    LD      A, ($7284)
    SUB     (IY+1)
    JR      C, LOC_8E32
    CP      11H
    JR      NC, LOC_8E32
    LD      A, ($7285)
    SUB     (IY+2)
    JR      NC, LOC_8E2C
    CPL
    INC     A
LOC_8E2C:
    LD      D, 0
    CP      8
    JR      C, LOC_8E45
LOC_8E32:
    LD      B, 0C8H
    DEC     E
    JR      Z, LOC_8E3B
    RES     6, B
    SET     5, B
LOC_8E3B:
    LD      (IY+0), B
    LD      A, 10H
    LD      (IY+4), A
    LD      D, 1
LOC_8E45:
    LD      A, D
LOC_8E46:
    AND     A
RET

SUB_8E48:
    LD      D, A
    LD      B, (IY+1)
    LD      C, (IY+2)
    PUSH    DE
    CALL    SUB_AC3F
    POP     DE
    LD      A, B
    CP      0B0H
    JR      NC, LOC_8E76
    LD      A, (IY+2)
    RLCA
    RLCA
    RLCA
    RLCA
    AND     0F0H
    LD      C, A
    LD      A, (IY+1)
    AND     0FH
    OR      C
    LD      B, 8
    LD      HL, UNK_8F98
LOOP_8E6E:
    CP      (HL)
    JR      Z, LOC_8E7A
    INC     HL
    INC     HL
    INC     HL
    DJNZ    LOOP_8E6E
LOC_8E76:
    XOR     A
    JP      LOC_8F96
LOC_8E7A:
    INC     HL
    PUSH    DE
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    PUSH    IX
    PUSH    DE
    POP     IX
    POP     HL
    POP     DE
    JP      (IX)
LOC_8E88:
    LD      BC, 10H
    ADD     HL, BC
    XOR     A
    BIT     0, (HL)
    JR      Z, LOC_8E97
    DEC     HL
    BIT     1, (HL)
    JR      Z, LOC_8E97
    INC     A
LOC_8E97:
    JP      LOC_8F96
LOC_8E9A:
    LD      BC, 10H
    ADD     HL, BC
    XOR     A
    BIT     0, (HL)
    JR      Z, LOC_8ECC
    LD      A, D
    AND     A
    JR      NZ, LOC_8EB4
    BIT     1, (HL)
    JR      Z, LOC_8ECC
    DEC     HL
    BIT     1, (HL)
    JR      Z, LOC_8ECC
    LD      A, 1
    JR      LOC_8ECC
LOC_8EB4:
    LD      B, 0FCH
    BIT     1, (HL)
    JR      Z, LOC_8EC3
    LD      B, 4
    DEC     HL
    BIT     1, (HL)
    JR      Z, LOC_8EC3
    LD      B, 0
LOC_8EC3:
    LD      A, (IY+2)
    ADD     A, B
    LD      (IY+2), A
    LD      A, 2
LOC_8ECC:
    JP      LOC_8F96
LOC_8ECF:
    LD      A, 2
    BIT     5, (HL)
    JR      NZ, LOC_8EE3
    LD      BC, 10H
    ADD     HL, BC
    XOR     A
    BIT     0, (HL)
    JR      Z, LOC_8EE3
    BIT     1, (HL)
    JR      Z, LOC_8EE3
    INC     A
LOC_8EE3:
    JP      LOC_8F96
LOC_8EE6:
    LD      BC, 10H
    ADD     HL, BC
    XOR     A
    BIT     1, (HL)
    JR      Z, LOC_8F18
    LD      A, D
    AND     A
    JR      NZ, LOC_8F00
    BIT     0, (HL)
    JR      Z, LOC_8F18
    INC     HL
    BIT     0, (HL)
    JR      Z, LOC_8F18
    LD      A, 1
    JR      LOC_8F18
LOC_8F00:
    LD      B, 4
    BIT     0, (HL)
    JR      Z, LOC_8F0F
    LD      B, 0FCH
    INC     HL
    BIT     0, (HL)
    JR      Z, LOC_8F0F
    LD      B, 0
LOC_8F0F:
    LD      A, (IY+2)
    ADD     A, B
    LD      (IY+2), A
    LD      A, 2
LOC_8F18:
    JP      LOC_8F96
LOC_8F1B:
    XOR     A
    BIT     2, (HL)
    JR      Z, LOC_8F27
    DEC     HL
    BIT     3, (HL)
    JR      Z, LOC_8F27
    LD      A, 2
LOC_8F27:
    JP      LOC_8F96
LOC_8F2A:
    XOR     A
    BIT     2, (HL)
    JR      Z, LOC_8F57
    LD      A, D
    AND     A
    JR      NZ, LOC_8F40
    BIT     3, (HL)
    JR      Z, LOC_8F57
    DEC     HL
    BIT     3, (HL)
    JR      Z, LOC_8F57
    LD      A, 2
    JR      LOC_8F57
LOC_8F40:
    LD      B, 0FCH
    BIT     3, (HL)
    JR      Z, LOC_8F4E
    LD      B, 4
    BIT     3, (HL)
    JR      Z, LOC_8F4E
    LD      B, 0
LOC_8F4E:
    LD      A, (IY+2)
    ADD     A, B
    LD      (IY+2), A
    LD      A, 2
LOC_8F57:
    JP      LOC_8F96
LOC_8F5A:
    XOR     A
    BIT     2, (HL)
    JR      Z, LOC_8F65
    BIT     3, (HL)
    JR      Z, LOC_8F65
    LD      A, 2
LOC_8F65:
    JP      LOC_8F96
LOC_8F68:
    XOR     A
    BIT     3, (HL)
    JR      Z, LOC_8F96
    LD      A, D
    AND     A
    JR      NZ, LOC_8F7E
    BIT     2, (HL)
    JR      Z, LOC_8F96
    INC     HL
    BIT     2, (HL)
    JR      Z, LOC_8F96
    LD      A, 2
    JR      LOC_8F96
LOC_8F7E:
    LD      B, 4
    BIT     2, (HL)
    JR      Z, LOC_8F8D
    LD      B, 0FCH
    INC     HL
    BIT     2, (HL)
    JR      Z, LOC_8F8D
    LD      B, 0
LOC_8F8D:
    LD      A, (IY+2)
    ADD     A, B
    LD      (IY+2), A
    LD      A, 2
LOC_8F96:
    AND     A
RET

UNK_8F98:
	DB    0
    DW LOC_8E88
    DB  40H
    DW LOC_8E9A
    DB  80H
    DW LOC_8ECF
    DB 0C0H
    DW LOC_8EE6
    DB    8
    DW LOC_8F1B
    DB  48H
    DW LOC_8F2A
    DB  88H
    DW LOC_8F5A
    DB 0C8H
    DW LOC_8F68

SUB_8FB0:
    CALL    SUB_8FC4
    JR      NZ, LOC_8FC2
    LD      A, (IY+0)
    AND     0F8H
    RES     6, A
    SET     5, A
    LD      (IY+0), A
    XOR     A
LOC_8FC2:
    AND     A
RET

SUB_8FC4:
    LD      A, (IY+0)
    INC     A
    LD      (IY+0), A
    AND     3
    CP      3
RET

DEAL_WITH_BALL:
    LD      IY, $72D9
    LD      A, (IY+0)
    BIT     7, (IY+0)
    JR      Z, LOC_8FF1
    AND     7FH
    OR      40H
    LD      (IY+0), A
    INC     (IY+4)
    PUSH    IY
    CALL    PLAY_BOUNCING_BALL_SOUND
    POP     IY
    JR      LOC_9005
LOC_8FF1:
    AND     78H
    JR      Z, LOC_9071
    LD      A, (IY+3)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_9071
    LD      A, (IY+0)
    BIT     6, A
    JR      Z, BALL_RETURNS_TO_DO
LOC_9005:
    CALL    SUB_9074
    CALL    SUB_9099
    BIT     2, E
    JR      NZ, BALL_GETS_STUCK
    CALL    SUB_912D
    CALL    SUB_92F2
    CP      2
    JR      Z, LOCRET_9073
    CP      1
    JR      Z, BALL_GETS_STUCK
    CALL    SUB_936F
    CP      2
    JR      NZ, LOC_9028
    LD      A, 3
    JR      LOCRET_9073
LOC_9028:
    CP      1
    JR      Z, BALL_GETS_STUCK
    CALL    SUB_9337
    AND     A
    JR      NZ, BALL_GETS_STUCK
    CALL    SUB_9399
    AND     A
    JR      Z, LOC_903E
    RES     6, (IY+0)
    JR      LOC_9071
LOC_903E:
    CALL    SUB_93B6
    JR      LOC_9071
BALL_GETS_STUCK:
    RES     6, (IY+0)
    SET     4, (IY+0)
    LD      (IY+5), 0
    PUSH    IY
    CALL    PLAY_BALL_STUCK_SOUND_01
    POP     IY
    JR      LOC_906E
BALL_RETURNS_TO_DO:
    BIT     5, A
    JR      Z, LOC_906E
    RES     5, A
    SET     3, A
    LD      (IY+0), A
    LD      (IY+5), 0
    PUSH    IY
    CALL    PLAY_BALL_RETURN_SOUND
    POP     IY
LOC_906E:
    CALL    SUB_93CE
LOC_9071:
    LD      A, 0
LOCRET_9073:
RET

SUB_9074:
    LD      B, (IY+1)
    LD      C, (IY+2)
    BIT     1, (IY+0)
    JR      NZ, LOC_9084
    INC     B
    INC     B
    JR      LOC_9086
LOC_9084:
    DEC     B
    DEC     B
LOC_9086:
    BIT     0, (IY+0)
    JR      NZ, LOC_9090
    INC     C
    INC     C
    JR      LOC_9092
LOC_9090:
    DEC     C
    DEC     C
LOC_9092:
    LD      (IY+1), B
    LD      (IY+2), C
RET

SUB_9099:
    LD      DE, 0
    LD      IX, $722C
    LD      B, 5
LOC_90A2:
    BIT     7, (IX+0)
    JR      Z, LOC_911E
    LD      A, (IX+1)
    SUB     9
    CP      (IY+1)
    JR      NC, LOC_911E
    ADD     A, 11H
    CP      (IY+1)
    JR      C, LOC_911E
    LD      A, (IX+2)
    SUB     8
    CP      (IY+2)
    JR      Z, LOC_90C5
    JR      NC, LOC_911E
LOC_90C5:
    ADD     A, 10H
    JR      C, LOC_90CE
    CP      (IY+2)
    JR      C, LOC_911E
LOC_90CE:
    BIT     5, (IX+0)
    JR      Z, LOC_90DC
    SET     4, (IX+0)
    LD      E, 4
    JR      LOCRET_912C
LOC_90DC:
    LD      A, (IY+1)
    CP      (IX+1)
    JR      C, LOC_90F0
    BIT     1, (IY+0)
    JR      Z, LOC_90FC
    RES     1, (IY+0)
    JR      LOC_90FA
LOC_90F0:
    BIT     1, (IY+0)
    JR      NZ, LOC_90FC
    SET     1, (IY+0)
LOC_90FA:
    SET     1, D
LOC_90FC:
    LD      A, (IY+2)
    CP      (IX+2)
    JR      C, LOC_9110
    BIT     0, (IY+0)
    JR      Z, LOCRET_912C
    RES     0, (IY+0)
    JR      LOC_911A
LOC_9110:
    BIT     0, (IY+0)
    JR      NZ, LOC_911E
    SET     0, (IY+0)
LOC_911A:
    SET     0, D
    JR      LOCRET_912C
LOC_911E:
    INC     IX
    INC     IX
    INC     IX
    INC     IX
    INC     IX
    DEC     B
    JP      NZ, LOC_90A2
LOCRET_912C:
RET

SUB_912D:
    LD      B, (IY+1)
    LD      C, (IY+2)
    DEC     B
    DEC     C
    BIT     1, (IY+0)
    JR      NZ, LOC_913D
    INC     B
    INC     B
LOC_913D:
    BIT     0, (IY+0)
    JR      NZ, LOC_9145
    INC     C
    INC     C
LOC_9145:
    LD      E, 0
    PUSH    DE
    CALL    SUB_AC3F
    POP     DE
    LD      A, (IY+1)
    AND     0FH
    BIT     1, (IY+0)
    JR      Z, LOC_918A
    CP      0AH
    JR      NZ, LOC_9167
    SET     7, E
    BIT     4, (IX+0)
    JR      NZ, LOC_91BB
    SET     1, E
    JR      LOC_91BB
LOC_9167:
    CP      2
    JR      NZ, LOC_91BB
    SET     5, E
    LD      A, (IY+2)
    AND     0FH
    CP      8
    JR      NC, LOC_9180
    BIT     0, (IX+0)
    JR      NZ, LOC_91BB
    SET     1, E
    JR      LOC_91BB
LOC_9180:
    BIT     1, (IX+0)
    JR      NZ, LOC_91BB
    SET     1, E
    JR      LOC_91BB
LOC_918A:
    CP      6
    JR      NZ, LOC_919A
    SET     7, E
    BIT     5, (IX+0)
    JR      NZ, LOC_91BB
    SET     1, E
    JR      LOC_91BB
LOC_919A:
    CP      0EH
    JR      NZ, LOC_91BB
    SET     5, E
    LD      A, (IY+2)
    AND     0FH
    CP      8
    JR      NC, LOC_91B3
    BIT     2, (IX+0)
    JR      NZ, LOC_91BB
    SET     1, E
    JR      LOC_91BB
LOC_91B3:
    BIT     3, (IX+0)
    JR      NZ, LOC_91BB
    SET     1, E
LOC_91BB:
    LD      A, (IY+2)
    AND     0FH
    BIT     0, (IY+0)
    JR      Z, LOC_91F9
    CP      2
    JR      NZ, LOC_91D6
    SET     6, E
    BIT     7, (IX+0)
    JR      NZ, LOC_922A
    SET     0, E
    JR      LOC_922A
LOC_91D6:
    CP      0AH
    JR      NZ, LOC_922A
    SET     4, E
    LD      A, (IY+1)
    AND     0FH
    CP      8
    JR      C, LOC_91EF
    BIT     2, (IX+0)
    JR      NZ, LOC_922A
    SET     0, E
    JR      LOC_922A
LOC_91EF:
    BIT     0, (IX+0)
    JR      NZ, LOC_922A
    SET     0, E
    JR      LOC_922A
LOC_91F9:
    CP      0EH
    JR      NZ, LOC_9209
    SET     6, E
    BIT     6, (IX+0)
    JR      NZ, LOC_922A
    SET     0, E
    JR      LOC_922A
LOC_9209:
    CP      6
    JR      NZ, LOC_922A
    SET     4, E
    LD      A, (IY+1)
    AND     0FH
    CP      8
    JR      C, LOC_9222
    BIT     3, (IX+0)
    JR      NZ, LOC_922A
    SET     0, E
    JR      LOC_922A
LOC_9222:
    BIT     1, (IX+0)
    JR      NZ, LOC_922A
    SET     0, E
LOC_922A:
    BIT     7, E
    JR      Z, LOC_92A3
    BIT     6, E
    JR      Z, LOC_92A3
    LD      A, E
    AND     3
    JP      NZ, LOC_92E8
    LD      B, (IY+1)
    LD      C, (IY+2)
    LD      A, B
    BIT     1, (IY+0)
    JR      Z, LOC_9275
    SUB     4
    LD      B, A
    LD      A, C
    BIT     0, (IY+0)
    JR      Z, LOC_9263
    SUB     4
    LD      C, A
    PUSH    DE
    CALL    SUB_AC3F
    POP     DE
    BIT     3, (IX+0)
    JP      NZ, LOC_92E8
    LD      E, 3
    JP      LOC_92E8
LOC_9263:
    ADD     A, 4
    LD      C, A
    PUSH    DE
    CALL    SUB_AC3F
    POP     DE
    BIT     2, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
    JR      LOC_92E8
LOC_9275:
    ADD     A, 4
    LD      B, A
    LD      A, C
    BIT     0, (IY+0)
    JR      Z, LOC_9291
    SUB     4
    LD      C, A
    PUSH    DE
    CALL    SUB_AC3F
    POP     DE
    BIT     1, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
    JR      LOC_92E8
LOC_9291:
    ADD     A, 4
    LD      C, A
    PUSH    DE
    CALL    SUB_AC3F
    POP     DE
    BIT     0, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
    JR      LOC_92E8
LOC_92A3:
    BIT     5, E
    JR      Z, LOC_92E8
    BIT     4, E
    JR      Z, LOC_92E8
    LD      A, E
    AND     3
    JR      NZ, LOC_92E8
    BIT     1, (IY+0)
    JR      Z, LOC_92D0
    BIT     0, (IY+0)
    JR      Z, LOC_92C6
    BIT     0, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
    JR      LOC_92E8
LOC_92C6:
    BIT     1, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
    JR      LOC_92E8
LOC_92D0:
    BIT     0, (IY+0)
    JR      Z, LOC_92E0
    BIT     2, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
    JR      LOC_92E8
LOC_92E0:
    BIT     3, (IX+0)
    JR      NZ, LOC_92E8
    LD      E, 3
LOC_92E8:
    LD      A, E
    AND     3
    XOR     (IY+0)
    LD      (IY+0), A
RET

SUB_92F2:
    LD      IX, $728E
    LD      C, 0
LOC_92F8:
    BIT     7, (IX+4)
    JR      Z, LOC_9316
    BIT     6, (IX+4)
    JR      NZ, LOC_9316
    PUSH    BC
    PUSH    IX
    LD      B, (IX+2)
    LD      C, (IX+1)
    CALL    SUB_B5DD
    POP     IX
    POP     BC
    AND     A
    JR      NZ, LOC_9324
LOC_9316:
    LD      DE, 6
    ADD     IX, DE
    INC     C
    LD      A, C
    CP      7
    JR      C, LOC_92F8
    XOR     A
    JR      LOCRET_9336
LOC_9324:
    CALL    SUB_B7C4
    PUSH    AF
    LD      DE, 32H
    CALL    SUB_B601
    POP     AF
    AND     A
    LD      A, 2
    JR      Z, LOCRET_9336
    LD      A, 1
LOCRET_9336:
RET

SUB_9337:
    LD      IX, $72C7
    LD      C, 0
LOC_933D:
    BIT     7, (IX+4)
    JR      Z, LOC_9355
    PUSH    BC
    PUSH    IX
    LD      B, (IX+2)
    LD      C, (IX+1)
    CALL    SUB_B5DD
    POP     IX
    POP     BC
    AND     A
    JR      NZ, LOC_9363
LOC_9355:
    LD      DE, 6
    ADD     IX, DE
    INC     C
    LD      A, C
    CP      3
    JR      C, LOC_933D
    XOR     A
    JR      LOCRET_936E
LOC_9363:
    CALL    SUB_B832
    LD      DE, 32H
    CALL    SUB_B601
    LD      A, 1
LOCRET_936E:
RET

SUB_936F:
    LD      A, ($72BD)
    BIT     6, A
    JR      Z, LOCRET_9398
    LD      A, ($72BF)
    LD      B, A
    LD      A, ($72BE)
    LD      C, A
    CALL    SUB_B5DD
    AND     A
    JR      Z, LOCRET_9398
    LD      BC, 808H
    LD      D, 0
    LD      A, 3
    CALL    SUB_B629
    LD      DE, 32H
    CALL    SUB_B601
    CALL    SUB_B76D
    INC     A
LOCRET_9398:
RET

SUB_9399:
    LD      A, ($7284)
    LD      B, A
    LD      A, ($7285)
    LD      C, A
    CALL    SUB_B5DD
    AND     A
    JR      Z, LOCRET_93B5
    LD      HL, $7281
    SET     6, (HL)
    PUSH    IY
    CALL    SUB_C98A
    POP     IY
    LD      A, 1
LOCRET_93B5:
RET

SUB_93B6:
    LD      B, (IY+1)
    LD      C, (IY+2)
    LD      D, 1
    LD      A, 4
    CALL    SUB_B629
    LD      HL, 1
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
RET

SUB_93CE:
    LD      A, (IY+5)
    ADD     A, 2
    LD      B, (IY+1)
    LD      C, (IY+2)
    BIT     3, (IY+0)
    JR      Z, LOC_93ED
    LD      C, A
    LD      A, 9
    SUB     C
    LD      IX, $7281
    LD      B, (IX+3)
    LD      C, (IX+4)
LOC_93ED:
    LD      D, A
    LD      A, 4
    CALL    SUB_B629
    INC     (IY+5)
    LD      A, (IY+5)
    CP      6
    JR      Z, LOC_9409
    LD      HL, 5
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
    JR      LOCRET_944D
LOC_9409:
    BIT     4, (IY+0)
    JR      Z, LOC_9444
    RES     4, (IY+0)
    SET     5, (IY+0)
    LD      A, (IY+4)
    DEC     A
    CP      4
    JR      C, LOC_9421
    LD      A, 4
LOC_9421:
    ADD     A, A
    LD      E, A
    LD      D, 0
    LD      IX, BYTE_944E
    ADD     IX, DE
    LD      L, (IX+0)
    LD      H, (IX+1)
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
    LD      BC, 808H
    LD      D, 0
    LD      A, 4
    CALL    SUB_B629
    JR      LOCRET_944D
LOC_9444:
    RES     3, (IY+0)
    LD      HL, $7281
    SET     6, (HL)
LOCRET_944D:
RET

BYTE_944E:
	DB 060,000,120,000,240,000,104,001,224,001,000

LEADS_TO_CHERRY_STUFF:
    LD      A, ($726E)
    BIT     6, A
    JR      Z, LOC_9463
    XOR     A
    JR      LOCRET_94A8
LOC_9463:
    LD      IY, $7281
    LD      A, (IY+2)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_949A
    CALL    SUB_94A9
    AND     A
    JR      NZ, LOC_947A
    LD      A, 1
    JR      LOC_9489
LOC_947A:
    CP      5
    JR      NZ, LOC_9483
    JP      LOC_D366
LOC_9481:
    JR      LOC_9491
LOC_9483:
    LD      (IY+1), A
    CALL    SUB_95A1
LOC_9489:
    PUSH    AF
    CALL    DEAL_WITH_CHERRIES
    CALL    SUB_96E4
    POP     AF
LOC_9491:
    CALL    SUB_9732
    CALL    SUB_9807
    AND     A
    JR      NZ, LOCRET_94A8
LOC_949A:
    LD      HL, $7245
    LD      B, 14H
    XOR     A
LOC_94A0:
    CP      (HL)
    JR      NZ, LOCRET_94A8
    INC     HL
    DJNZ    LOC_94A0
    LD      A, 2
LOCRET_94A8:
RET

SUB_94A9:
    LD      IX, $7088
    LD      A, ($726E)
    BIT     1, A
    JR      Z, LOC_94B8
    LD      IX, $708D
LOC_94B8:
    BIT     6, (IX+0)
    JR      NZ, LOC_94C4
    BIT     6, (IX+3)
    JR      Z, LOC_9538
LOC_94C4:
    LD      A, ($7281)
    BIT     6, A
    JR      Z, LOC_9538
    LD      B, (IY+3)
    LD      C, (IY+4)
    LD      A, (IY+1)
    CP      3
    JR      NC, LOC_94FD
    CP      1
    LD      A, C
    JR      NZ, LOC_94ED
    ADD     A, 6
    LD      ($72DB), A
    ADD     A, 3
    JR      C, LOC_9538
    LD      C, A
    LD      A, B
    LD      ($72DA), A
    JR      LOC_9524
LOC_94ED:
    SUB     6
    LD      ($72DB), A
    SUB     3
    JR      C, LOC_9538
    LD      C, A
    LD      A, B
    LD      ($72DA), A
    JR      LOC_9524
LOC_94FD:
    CP      3
    LD      A, B
    JR      NZ, LOC_9514
    SUB     6
    LD      ($72DA), A
    SUB     3
    CP      1CH
    JR      C, LOC_9538
    LD      B, A
    LD      A, C
    LD      ($72DB), A
    JR      LOC_9524
LOC_9514:
    ADD     A, 6
    LD      ($72DA), A
    ADD     A, 3
    CP      0B5H
    JR      NC, LOC_9538
    LD      B, A
    LD      A, C
    LD      ($72DB), A
LOC_9524:
    PUSH    IX
    CALL    SUB_AC3F
    LD      A, (IX+0)
    POP     IX
    AND     0FH
    CP      0FH
    JR      NZ, LOC_9538
    LD      A, 5
    JR      LOCRET_9576
LOC_9538:
    LD      A, 1
    BIT     1, (IX+1)
    JR      NZ, LOC_9558
    INC     A
    BIT     3, (IX+1)
    JR      NZ, LOC_9558
    INC     A
    BIT     0, (IX+1)
    JR      NZ, LOC_9558
    INC     A
    BIT     2, (IX+1)
    JR      NZ, LOC_9558
    XOR     A
    JR      LOCRET_9576
LOC_9558:
    PUSH    AF
    CP      3
    JR      NC, LOC_9566
    LD      A, (IY+3)
    AND     0FH
    JR      NZ, LOC_956F
    JR      LOC_9575
LOC_9566:
    LD      A, (IY+4)
    AND     0FH
    CP      8
    JR      Z, LOC_9575
LOC_956F:
    POP     AF
    LD      A, (IY+1)
    JR      LOCRET_9576
LOC_9575:
    POP     AF
LOCRET_9576:
RET

SUB_9577:
    LD      IX, $72D9
    LD      A, (IY+1)
    DEC     A
    LD      B, A
    CP      2
    JR      C, LOC_9593
    LD      B, 3
    CP      2
    JR      Z, LOC_958C
    LD      B, 1
LOC_958C:
    BIT     7, (IY+4)
    JR      Z, LOC_9593
    DEC     B
LOC_9593:
    SET     7, B
    LD      (IX+0), B
    SET     3, (IY+0)
    RES     6, (IY+0)
RET

SUB_95A1:
    CALL    SUB_961F
    AND     A
    JP      NZ, LOC_961C
    PUSH    BC
    RES     5, (IY+0)
    LD      B, (IY+3)
    LD      C, (IY+4)
    LD      A, (IY+1)
    CP      3
    JR      NC, LOC_95CE
    LD      D, A
    LD      A, 1
    CALL    SUB_AEE1
    BIT     0, A
    JR      Z, LOC_95C8
    SET     5, (IY+0)
LOC_95C8:
    CP      2
    JR      NC, LOC_9617
    JR      LOC_95D5
LOC_95CE:
    LD      D, A
    CALL    SUB_B12D
    AND     A
    JR      NZ, LOC_9617
LOC_95D5:
    POP     BC
    LD      (IY+3), B
    LD      (IY+4), C
    LD      A, (IY+1)
    LD      D, A
    CP      1
    JR      NZ, LOC_95E9
    CALL    SUB_B2FA
    JR      LOC_95FE
LOC_95E9:
    CP      2
    JR      NZ, LOC_95F2
    CALL    SUB_B39D
    JR      LOC_95FE
LOC_95F2:
    CP      3
    JR      NZ, LOC_95FB
    CALL    SUB_B43F
    JR      LOC_95FE
LOC_95FB:
    CALL    SUB_B4E9
LOC_95FE:
    BIT     0, E
    JR      Z, LOC_9606
    SET     4, (IY+0)
LOC_9606:
    LD      B, (IY+3)
    LD      C, (IY+4)
    PUSH    DE
    CALL    SUB_AC3F
    CALL    SUB_AEB7
    POP     DE
    XOR     A
    JR      LOCRET_961E
LOC_9617:
    SET     5, (IY+0)
    POP     BC
LOC_961C:
    LD      A, 1
LOCRET_961E:
RET

SUB_961F:
    LD      (IY+1), A
    LD      B, (IY+3)
    LD      C, (IY+4)
    CP      3
    JR      NC, LOC_964B
    LD      A, B
    AND     0FH
    JR      NZ, LOC_966D
    LD      A, C
    ADD     A, 4
    LD      C, A
    LD      A, (IY+1)
    CP      1
    JR      Z, LOC_9640
    LD      A, C
    SUB     8
    LD      C, A
LOC_9640:
    LD      A, C
    CP      18H
    JR      C, LOC_966D
    CP      0E9H
    JR      NC, LOC_966D
    JR      LOC_966A
LOC_964B:
    LD      A, C
    AND     0FH
    CP      8
    JR      NZ, LOC_966D
    LD      A, B
    ADD     A, 4
    LD      B, A
    LD      A, (IY+1)
    CP      4
    JR      Z, LOC_9661
    LD      A, B
    SUB     8
    LD      B, A
LOC_9661:
    LD      A, B
    CP      20H
    JR      C, LOC_966D
    CP      0B1H
    JR      NC, LOC_966D
LOC_966A:
    XOR     A
    JR      LOCRET_966F
LOC_966D:
    LD      A, 1
LOCRET_966F:
RET

DEAL_WITH_CHERRIES:
    CALL    SUB_B173
    JR      C, GRAB_SOME_CHERRIES
    BIT     1, (IY+0)
    JR      Z, LOCRET_96E3
    LD      A, (IY+8)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOCRET_96E3
    LD      (IY+7), 0
    RES     1, (IY+0)
    PUSH    IY
    CALL    SUB_C97F
    POP     IY
    JR      LOCRET_96E3
GRAB_SOME_CHERRIES:
    LD      DE, 5
    CALL    SUB_B601
    BIT     1, (IY+0)
    JR      Z, LOC_96CA
    LD      A, (IY+8)
    CALL    TEST_SIGNAL
    AND     A
    JR      NZ, LOC_96CA
    LD      A, (IY+8)
    CALL    FREE_SIGNAL
    INC     (IY+7)
    LD      A, (IY+7)
    CP      8
    JR      C, LOC_96D5
    LD      (IY+7), 0
    LD      DE, 32H
    CALL    SUB_B601
    RES     1, (IY+0)
    JR      LOCRET_96E3
LOC_96CA:
    LD      (IY+7), 1
    PUSH    IY
    CALL    PLAY_GRAB_CHERRIES_SOUND
    POP     IY
LOC_96D5:
    XOR     A
    LD      HL, 1EH
    CALL    REQUEST_SIGNAL
    LD      (IY+8), A
    SET     1, (IY+0)
LOCRET_96E3:
RET

SUB_96E4:
    LD      A, ($7272)
    BIT     7, A
    JR      Z, LOCRET_9731
    LD      A, (IY+3)
    CP      60H
    JR      NZ, LOCRET_9731
    LD      A, (IY+4)
    CP      78H
    JR      NZ, LOCRET_9731
    LD      HL, $7272
    RES     7, (HL)
    LD      A, (HL)
    OR      32H
    LD      (HL), A
    LD      A, 0AH
    LD      ($728C), A
    LD      HL, (SCORE_P1_RAM)
    LD      A, ($726E)
    LD      C, A
    LD      A, (CURRENT_LEVEL_RAM)
    BIT     1, C
    JR      Z, LOC_971B
    LD      HL, (SCORE_P2_RAM)
    LD      A, ($7275)
LOC_971B:
    LD      HL, 0
    LD      DE, 32H
LOC_9721:
    ADD     HL, DE
    DEC     A
    JP      P, LOC_9721
    EX      DE, HL
    CALL    SUB_B601
    PUSH    IY
    NOP
    NOP
    NOP
    POP     IY
LOCRET_9731:
RET

SUB_9732:
    AND     A
    JR      NZ, LOC_973D
    LD      A, (IY+6)
    INC     A
    CP      2
    JR      C, LOC_973E
LOC_973D:
    XOR     A
LOC_973E:
    LD      (IY+6), A
    LD      C, 1
    ADD     A, C
    BIT     5, (IY+0)
    JR      Z, LOC_974C
    ADD     A, 2
LOC_974C:
    LD      C, A
    LD      A, (IY+1)
    CP      2
    JR      NZ, LOC_975A
    LD      A, C
    ADD     A, 7
    LD      C, A
    JR      LOC_9786
LOC_975A:
    CP      3
    JR      NZ, LOC_9771
    LD      A, (IY+4)
    AND     A
    JP      P, LOC_976B
    LD      A, C
    ADD     A, 0EH
    LD      C, A
    JR      LOC_9786
LOC_976B:
    LD      A, C
    ADD     A, 1CH
    LD      C, A
    JR      LOC_9786
LOC_9771:
    CP      4
    JR      NZ, LOC_9786
    LD      A, (IY+4)
    AND     A
    JP      P, LOC_9782
    LD      A, C
    ADD     A, 15H
    LD      C, A
    JR      LOC_9786
LOC_9782:
    LD      A, C
    ADD     A, 23H
    LD      C, A
LOC_9786:
    LD      (IY+5), C
    BIT     6, (IY+0)
    JR      Z, LOC_97C8
    LD      A, (IY+1)
    CP      3
    JR      C, LOC_97A1
    LD      E, A
    LD      A, (IY+4)
    AND     A
    LD      A, E
    JP      M, LOC_97A1
    ADD     A, 2
LOC_97A1:
    BIT     5, (IY+0)
    JR      Z, LOC_97A9
    ADD     A, 6
LOC_97A9:
    DEC     A
    ADD     A, A
    LD      E, A
    LD      D, 0
    LD      HL, BYTE_97EF
    ADD     HL, DE
    LD      A, (IY+4)
    ADD     A, 8
    SUB     (HL)
    LD      C, A
    INC     HL
    LD      A, (IY+3)
    ADD     A, 8
    SUB     (HL)
    LD      B, A
    LD      D, 1
    LD      A, 4
    CALL    SUB_B629
LOC_97C8:
    LD      HL, 1EH
    BIT     3, (IY+0)
    JR      NZ, LOC_97DD
    LD      HL, 0FH
    BIT     5, (IY+0)
    JR      NZ, LOC_97DD
    LD      HL, 7
LOC_97DD:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+2), A
    LD      A, (IY+0)
    AND     0E7H
    OR      80H
    LD      (IY+0), A
RET

BYTE_97EF:
	DB 002,006,014,006,006,014,006,002,010,014,010,002,012,008,004,008,008,004,008,012,008,004,008,012

SUB_9807:
    LD      A, (DIAMOND_RAM)
    BIT     7, A
    JR      Z, LOC_983F
    LD      IX, 722CH
    LD      B, (IX+1)
    LD      C, (IX+2)
    LD      A, (IY+3)
    SUB     B
    JR      NC, LOC_9820
    CPL
    INC     A
LOC_9820:
    CP      6
    JR      NC, LOC_983F
    LD      A, (IY+4)
    SUB     C
    JR      NC, LOC_982C
    CPL
    INC     A
LOC_982C:
    CP      6
    JR      NC, LOC_983F
    LD      DE, 3E8H
    CALL    SUB_B601
    LD      HL, DIAMOND_RAM
    RES     7, (HL)
    LD      A, 2
    JR      LOCRET_9840
LOC_983F:
    XOR     A
LOCRET_9840:
RET

SUB_9842:
    LD      A, ($7272)
    BIT     4, A
    JR      Z, LOC_98A2
    LD      A, ($72C3)
    BIT     7, A
    JR      NZ, LOC_986C
    LD      A, ($728B)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_986C
    LD      HL, 1EH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      ($728B), A
    LD      A, ($728C)
    DEC     A
    LD      ($728C), A
    JR      Z, LOC_9892
LOC_986C:
    LD      IY, $728E
    LD      B, 7
LOC_9872:
    BIT     7, (IY+4)
    JR      Z, LOC_9887
    BIT     6, (IY+4)
    JR      NZ, LOC_9887
    PUSH    BC
    CALL    SUB_9FC8
    LD      L, 1
    POP     BC
    JR      NZ, LOC_98CB
LOC_9887:
    LD      DE, 6
    ADD     IY, DE
    DJNZ    LOC_9872
    LD      L, 0
    JR      LOC_98CB
LOC_9892:
    LD      A, ($7272)
    RES     4, A
    LD      ($7272), A
    LD      A, ($728A)
    SET     4, A
    LD      ($728A), A
LOC_98A2:
    JP      LOC_D40B
LOC_98A5:
    CALL    SUB_98CE
    CALL    SUB_9A12
    LD      L, 0
    LD      A, (IY+4)
    BIT     7, A
    JR      Z, LOC_98C2
    BIT     6, A
    JR      NZ, LOC_98C2
    BIT     7, (IY+0)
    JR      NZ, LOC_98C2
    CALL    SUB_9A2C
    LD      L, A
LOC_98C2:
    LD      A, ($728C)
    INC     A
    AND     7
    LD      ($728C), A
LOC_98CB:
    LD      A, L
    AND     A
RET

SUB_98CE:
    PUSH    IX
    LD      A, ($728A)
    BIT     3, A
    JR      NZ, LOC_9928
    LD      IX, $72B2
    LD      A, (IX+3)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_9928
    CALL    SUB_9980
    JR      Z, LOC_991E
    LD      BC, 6078H
    CALL    SUB_992B
    JR      Z, LOC_98F6
    LD      HL, 1
    JR      LOC_9915
LOC_98F6:
    CALL    SUB_9962
    LD      A, 5
    LD      (IY+5), A
    CALL    SUB_9980
    JR      Z, LOC_991E
    LD      HL, 0D2H
    LD      A, ($728A)
    BIT     2, A
    JR      NZ, LOC_9910
    LD      HL, 1EH
LOC_9910:
    XOR     4
    LD      ($728A), A
LOC_9915:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IX+3), A
    JR      LOC_9928
LOC_991E:
    LD      A, ($7272)
    SET     0, A
    SET     7, A
    LD      ($7272), A
LOC_9928:
    POP     IX
RET

SUB_992B:
    PUSH    IY
    LD      IY, $728E
    LD      BC, 700H
LOC_9934:
    LD      A, (IY+4)
    BIT     7, A
    JR      Z, LOC_994D
    BIT     6, A
    JR      NZ, LOC_994D
    LD      A, (IY+2)
    SUB     60H
    JR      NC, LOC_9948
    CPL
    INC     A
LOC_9948:
    CP      0DH
    JR      NC, LOC_994D
    INC     C
LOC_994D:
    LD      DE, 6
    ADD     IY, DE
    DJNZ    LOC_9934
    LD      A, C
    CP      2
    JR      NC, LOC_995C
    XOR     A
    JR      LOC_995E
LOC_995C:
    LD      A, 1
LOC_995E:
    POP     IY
    AND     A
RET

SUB_9962:
    LD      A, 28H
    LD      (IY+0), A
    LD      A, 81H
    LD      (IY+4), A
    XOR     A
    LD      HL, 6
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
    LD      BC, 6078H
    LD      (IY+2), B
    LD      (IY+1), C
RET

SUB_9980:
    LD      IY, $728E
    LD      L, 7
    LD      DE, 6
LOC_9989:
    BIT     7, (IY+4)
    JR      Z, LOC_999C
    ADD     IY, DE
    DEC     L
    JR      NZ, LOC_9989
    LD      A, ($728A)
    SET     3, A
    LD      ($728A), A
LOC_999C:
    LD      A, L
    AND     A
RET

SUB_999F:
    LD      A, ($728A)
    BIT     5, A
    JR      NZ, LOC_99BB
    SET     5, A
    LD      ($728A), A
    LD      HL, 3CH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      IX, $72B2
    LD      (IX+3), A
    JR      LOC_9A07
LOC_99BB:
    LD      A, ($728B)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOCRET_9A11
    LD      A, ($728D)
    LD      D, A
    LD      A, ($728A)
    SET     6, A
    BIT     7, A
    JR      Z, LOC_99E4
    RES     7, A
    LD      ($728A), A
    INC     D
    JR      NZ, LOC_99DB
    LD      D, 0FFH
LOC_99DB:
    LD      A, D
    LD      ($728D), A
    LD      A, ($728A)
    JR      LOC_99E9
LOC_99E4:
    SET     7, A
    LD      ($728A), A
LOC_99E9:
    LD      E, 7
    LD      BC, 6
    LD      IY, $728E
LOC_99F2:
    LD      H, (IY+4)
    SET     5, H
    SET     4, H
    BIT     7, A
    JR      Z, LOC_99FF
    RES     4, H
LOC_99FF:
    LD      (IY+4), H
    ADD     IY, BC
    DEC     E
    JR      NZ, LOC_99F2
LOC_9A07:
    LD      HL, 1EH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      ($728B), A
LOCRET_9A11:
RET

SUB_9A12:
    LD      A, ($728C)
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_9A24
    ADD     HL, BC
    LD      C, (HL)
    LD      IY, $728E
    ADD     IY, BC
RET

BYTE_9A24:
	DB 000,006,012,018,024,030,036,042

SUB_9A2C:
    PUSH    IX
    LD      A, (IY+3)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_9AB1
    LD      A, (IY+0)
    BIT     5, A
    JR      Z, LOC_9A50
    BIT     3, A
    JR      Z, LOC_9A49
    CALL    SUB_9B91
    JR      NZ, LOC_9A5E
    JR      LOC_9A75
LOC_9A49:
    CALL    SUB_9BBD
    JR      NZ, LOC_9A59
    JR      LOC_9A75
LOC_9A50:
    BIT     4, A
    JR      Z, LOC_9A5E
    CALL    SUB_9C76
    JR      NZ, LOC_9A75
LOC_9A59:
    CALL    SUB_A460
    JR      LOC_9AA0
LOC_9A5E:
    CALL    SUB_A1DF
    JR      NZ, LOC_9A75
    CALL    SUB_9CAB
    JR      NZ, LOC_9A6D
    CALL    SUB_9E7C
    JR      LOC_9A75
LOC_9A6D:
    CALL    SUB_9FF4
    JR      Z, LOC_9AA0
    CALL    SUB_9E3F
LOC_9A75:
    LD      A, (IY+4)
    AND     7
    CALL    SUB_9D2F
    JR      Z, LOC_9AA0
    LD      A, (IY+4)
    AND     7
    DEC     A
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_9AB5
    ADD     HL, BC
    LD      B, (HL)
    PUSH    BC
    CALL    SUB_9F29
    POP     BC
    AND     B
    JR      Z, LOC_9AA0
    CALL    SUB_9E7A
    LD      A, (IY+4)
    AND     7
    CALL    SUB_9D2F
LOC_9AA0:
    CALL    SUB_9AB9
    CALL    SUB_9AE2
    LD      A, (IY+4)
    AND     0C7H
    LD      (IY+4), A
    CALL    SUB_9FC8
LOC_9AB1:
    POP     IX
    AND     A
RET

BYTE_9AB5:
	DB 176,112,224,208

SUB_9AB9:
    PUSH    DE
    PUSH    HL
    LD      E, (IY+0)
    LD      HL, 6
    BIT     5, E
    JR      NZ, LOC_9AD8
    BIT     4, E
    JR      Z, LOC_9ACE
    CALL    SUB_9BE2
    JR      LOC_9AD8
LOC_9ACE:
    CALL    SUB_9BDA
    BIT     3, (IY+4)
    JR      Z, LOC_9AD8
    ADD     HL, HL
LOC_9AD8:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
    POP     HL
    POP     DE
RET

SUB_9AE2:
    PUSH    IX
    PUSH    IY
    LD      H, (IY+0)
    LD      D, 1
    BIT     6, H
    JR      NZ, LOC_9B07
    LD      D, 0DH
    BIT     5, H
    JR      NZ, LOC_9B07
    CALL    SUB_9B4F
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_AC3F
    LD      D, A
    CALL    SUB_B173
    LD      D, 19H
LOC_9B07:
    LD      A, (IY+4)
    AND     7
    LD      L, 0
    DEC     A
    JR      Z, LOC_9B28
    LD      L, 2
    DEC     A
    JR      Z, LOC_9B28
    LD      L, 4
    LD      B, A
    LD      A, (IY+1)
    CP      80H
    JR      NC, LOC_9B22
    LD      L, 8
LOC_9B22:
    LD      A, B
    DEC     A
    JR      Z, LOC_9B28
    INC     L
    INC     L
LOC_9B28:
    LD      C, (IY+5)
    BIT     7, C
    JR      Z, LOC_9B33
    RES     7, C
    JR      LOC_9B36
LOC_9B33:
    SET     7, C
    INC     L
LOC_9B36:
    LD      (IY+5), C
    LD      A, D
    ADD     A, L
    LD      D, A
    LD      A, ($728C)
    ADD     A, 5
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_B629
    POP     IY
    POP     IX
RET

SUB_9B4F:
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A, (IY+0)
    BIT     0, A
    JR      NZ, LOC_9B83
    BIT     5, A
    JR      NZ, LOC_9B83
    LD      A, (IY+4)
    AND     7
    DEC     A
    CP      4
    JR      NC, LOC_9B83
    LD      HL, OFF_9B89
    ADD     A, A
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    PUSH    DE
    POP     IX
    LD      B, (IY+2)
    LD      C, (IY+1)
    LD      DE, LOC_9B83
    PUSH    DE
    JP      (IX)
LOC_9B83:
    POP     IX
    POP     HL
    POP     DE
    POP     BC
RET

OFF_9B89:
	DW SUB_B2FA
    DW SUB_B39D
    DW SUB_B43F
    DW SUB_B4E9

SUB_9B91:
    CALL    SUB_9BA8
    LD      B, 0
    JR      NZ, LOC_9BA5
    LD      A, (IY+0)
    RES     5, A
    SET     6, A
    AND     0F8H
    LD      (IY+0), A
    INC     B
LOC_9BA5:
    LD      A, B
    AND     A
RET

SUB_9BA8:
    LD      A, (IY+5)
    DEC     A
    LD      (IY+5), A
    AND     3FH
RET

SUB_9BB2:
    LD      C, A
    LD      A, (IY+5)
    AND     0C0H
    OR      C
    LD      (IY+5), A
RET

SUB_9BBD:
    LD      B, 0
    CALL    SUB_9BA8
    JR      NZ, LOC_9BD7
    LD      A, (IY+0)
    AND     0F8H
    RES     5, A
    SET     4, A
    LD      (IY+0), A
    CALL    SUB_9BE2
    CALL    SUB_9BB2
    INC     B
LOC_9BD7:
    LD      A, B
    OR      A
RET

SUB_9BDA:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      D, 0
    JR      LOC_9BE8

SUB_9BE2:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      D, 1
LOC_9BE8:
    LD      A, ($7271)
    DEC     A
    LD      C, A
    LD      B, 0
    LD      IX, BYTE_9D1A
    ADD     IX, BC
    LD      C, (IX+0)
    LD      HL, CURRENT_LEVEL_RAM
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_9C05
    INC     HL
LOC_9C05:
    LD      A, (HL)
    DEC     A
    ADD     A, C
    LD      C, A
    LD      A, ($728A)
    BIT     4, A
    JR      Z, LOC_9C12
    INC     C
    INC     C
LOC_9C12:
    LD      A, C
    CP      0FH
    JR      C, LOC_9C19
    LD      A, 0FH
LOC_9C19:
    ADD     A, A
    LD      C, A
    LD      IX, BYTE_9C56
    LD      A, D
    AND     A
    JR      Z, LOC_9C27
    LD      IX, BYTE_9C36
LOC_9C27:
    ADD     IX, BC
    LD      L, (IX+0)
    LD      H, 0
    LD      A, (IX+1)
    POP     IX
    POP     DE
    POP     BC
RET

BYTE_9C36:
	DB 013,009,013,009,013,009,010,012,010,012,010,012,008,015,008,015,006,020,006,020,005,024,005,024,005,024,004,030,004,030,004,030
BYTE_9C56:
	DB 008,001,008,001,008,001,006,001,006,001,006,001,005,001,005,001,005,001,005,001,004,001,004,001,004,001,004,001,004,001,004,001

SUB_9C76:
    LD      B, 0
    LD      A, (IY+5)
    AND     3FH
    JR      Z, LOC_9C84
    CALL    SUB_9BA8
    JR      NZ, LOC_9CA8
LOC_9C84:
    LD      A, (IY+2)
    AND     0FH
    JR      NZ, LOC_9CA8
    LD      A, (IY+1)
    AND     0FH
    CP      8
    JR      NZ, LOC_9CA8
    LD      A, (IY+0)
    AND     0F8H
    RES     4, A
    SET     5, A
    SET     3, A
    LD      (IY+0), A
    LD      A, 0AH
    CALL    SUB_9BB2
    INC     B
LOC_9CA8:
    LD      A, B
    AND     A
RET

SUB_9CAB:
    LD      B, (IY+0)
    BIT     5, (IY+4)
    JR      NZ, LOC_9CBA
    BIT     2, B
    JR      NZ, LOC_9CD4
    JR      LOC_9CDA
LOC_9CBA:
    CALL    SUB_9CE0
    LD      E, A
    LD      A, ($728D)
    RRA
    RRA
    RRA
    RRA
    RRA
    AND     7
    ADD     A, E
    LD      E, A
    CALL    RAND_GEN
    AND     0FH
    RES     2, B
    CP      E
    JR      NC, LOC_9CDA
LOC_9CD4:
    SET     2, B
    RES     0, B
    RES     1, B
LOC_9CDA:
    LD      (IY+0), B
    BIT     2, B
RET

SUB_9CE0:
    PUSH    DE
    PUSH    HL
    LD      A, ($7271)
    DEC     A
    LD      E, A
    LD      D, 0
    LD      HL, BYTE_9D1A
    ADD     HL, DE
    LD      E, (HL)
    LD      HL, CURRENT_LEVEL_RAM
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_9CFB
    INC     HL
LOC_9CFB:
    LD      A, (HL)
    DEC     A
    ADD     A, E
    LD      E, A
    LD      A, ($728A)
    BIT     4, A
    JR      Z, LOC_9D08
    INC     E
    INC     E
LOC_9D08:
    LD      A, E
    CP      0FH
    JR      C, LOC_9D0F
    LD      A, 0FH
LOC_9D0F:
    LD      E, A
    LD      D, 0
    LD      HL, BYTE_9D1E
    ADD     HL, DE
    LD      A, (HL)
    POP     HL
    POP     DE
RET

BYTE_9D1A:
	DB 000,003,005,007
BYTE_9D1E:
	DB 008,008,009,009,010,010,011,011,012,012,013,013,014,014,014,014,014

SUB_9D2F:
    LD      C, A
    XOR     A
    LD      H, (IY+0)
    BIT     0, H
    JR      NZ, LOC_9D9D
    BIT     5, H
    JR      NZ, LOC_9D9D
    PUSH    BC
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_9E07
    POP     BC
    JR      NZ, LOC_9D9D
    DEC     C
    LD      A, C
    CP      4
    LD      A, 0
    JR      NC, LOC_9D9D
    LD      A, C
    RLCA
    LD      C, A
    LD      B, 0
    LD      HL, OFF_9D9F
    ADD     HL, BC
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    EX      DE, HL
    LD      B, (IY+2)
    LD      C, (IY+1)
    LD      E, 4
    JP      (HL)
LOC_9D67:
    LD      A, C
    ADD     A, E
    LD      C, A
    JR      LOC_9D79
LOC_9D6C:
    LD      A, C
    SUB     E
    LD      C, A
    JR      LOC_9D79
LOC_9D71:
    LD      A, B
    SUB     E
    LD      B, A
    JR      LOC_9D79
LOC_9D76:
    LD      A, B
    ADD     A, E
    LD      B, A
LOC_9D79:
    PUSH    HL
    PUSH    BC
    PUSH    IY
    POP     HL
    LD      BC, $72B8
    AND     A
    SBC     HL, BC
    POP     BC
    POP     HL
    JR      NC, LOC_9D92
    LD      A, (IY+4)
    AND     7
    CALL    SUB_9DA7
    JR      NZ, LOC_9D9D
LOC_9D92:
    CALL    SUB_9E07
    JR      NZ, LOC_9D9D
    LD      (IY+2), B
    LD      (IY+1), C
LOC_9D9D:
    AND     A
RET

OFF_9D9F:
	DW LOC_9D67
    DW LOC_9D6C
    DW LOC_9D71
    DW LOC_9D76

SUB_9DA7:
    PUSH    BC
    PUSH    IX
    CP      3
    JR      C, LOC_9E01
    LD      C, A
    LD      IX, $728E
    LD      HL, 7
LOC_9DB6:
    BIT     7, (IX+4)
    JR      Z, LOC_9DF0
    BIT     6, (IX+4)
    JR      NZ, LOC_9DF0
    LD      A, (IX+2)
    BIT     2, C
    JR      NZ, LOC_9DD5
    CP      B
    JR      Z, LOC_9DCE
    JR      NC, LOC_9DF0
LOC_9DCE:
    ADD     A, 0CH
    CP      B
    JR      C, LOC_9DF0
    JR      LOC_9DDD
LOC_9DD5:
    CP      B
    JR      C, LOC_9DF0
    SUB     0DH
    CP      B
    JR      NC, LOC_9DF0
LOC_9DDD:
    INC     H
    LD      A, H
    CP      1
    JR      NZ, LOC_9DF0
    PUSH    HL
    PUSH    IY
    POP     DE
    PUSH    IX
    POP     HL
    AND     A
    SBC     HL, DE
    POP     HL
    JR      NC, LOC_9E01
LOC_9DF0:
    LD      DE, 6
    ADD     IX, DE
    DEC     L
    JR      NZ, LOC_9DB6
    LD      A, H
    CP      2
    JR      C, LOC_9E01
    LD      A, 0FFH
    JR      LOC_9E02
LOC_9E01:
    XOR     A
LOC_9E02:
    POP     IX
    POP     BC
    AND     A
RET

SUB_9E07:
    PUSH    BC
    LD      A, (IY+4)
    AND     7
    LD      D, A
    LD      A, 3
    BIT     4, (IY+0)
    JR      Z, LOC_9E17
    DEC     A
LOC_9E17:
    LD      E, A
    LD      A, D
    CP      3
    LD      A, E
    JR      NC, LOC_9E31
    CALL    SUB_AEE1
    CP      2
    JR      NC, LOC_9E39
    LD      L, 0
    CP      1
    JR      NZ, LOC_9E3B
    SET     3, (IY+4)
    JR      LOC_9E3B
LOC_9E31:
    CALL    SUB_B12D
    LD      L, 0
    AND     A
    JR      Z, LOC_9E3B
LOC_9E39:
    LD      L, 1
LOC_9E3B:
    POP     BC
    LD      A, L
    AND     A
RET

SUB_9E3F:
    SET     0, (IY+0)
    BIT     4, (IY+4)
    JR      Z, LOC_9E75
    CALL    SUB_A527
    JR      Z, LOC_9E54
    BIT     3, (IY+4)
    JR      Z, LOC_9E75
LOC_9E54:
    CALL    SUB_9CE0
    AND     0FH
    LD      B, A
    CALL    RAND_GEN
    AND     0FH
    CP      B
    JR      NC, LOC_9E75
    LD      A, (IY+0)
    AND     0F8H
    RES     6, A
    SET     5, A
    RES     3, A
    LD      (IY+0), A
    LD      A, 0AH
    CALL    SUB_9BB2
LOC_9E75:
    RES     3, (IY+4)
RET

SUB_9E7A:
    JR      LOC_9EBD

SUB_9E7C:
    BIT     4, (IY+4)
    JR      NZ, LOC_9EAA
    BIT     0, (IY+0)
    JP      NZ, LOC_9F10
    LD      A, (IY+4)
    AND     7
    DEC     A
    CP      4
    JR      NC, LOC_9EAA
    LD      HL, BYTE_9F25
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      B, (HL)
    PUSH    BC
    CALL    SUB_9F29
    POP     BC
    AND     A
    JR      Z, LOC_9EAA
    LD      C, A
    AND     B
    JR      NZ, LOC_9F10
    LD      A, C
    JR      LOC_9EBD
LOC_9EAA:
    SET     0, (IY+0)
    CALL    RAND_GEN
    AND     0FH
    CP      8
    JR      C, LOC_9F10
    CALL    SUB_9F29
    AND     A
    JR      Z, LOC_9F10
LOC_9EBD:
    LD      IX, BYTE_9F15
    LD      C, 4
LOC_9EC3:
    LD      E, (IX+1)
    CP      (IX+0)
    JR      Z, LOC_9F03
    INC     IX
    INC     IX
    DEC     C
    JR      NZ, LOC_9EC3
    LD      B, A
LOC_9ED3:
    CALL    RAND_GEN
    AND     3
    RLCA
    LD      HL, OFF_9F1D
    LD      E, A
    LD      D, 0
    ADD     HL, DE
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    EX      DE, HL
    JP      (HL)
LOC_9EE5:
    LD      E, 3
    BIT     4, B
    JR      NZ, LOC_9F03
    JR      LOC_9ED3
LOC_9EED:
    LD      E, 4
    BIT     5, B
    JR      NZ, LOC_9F03
    JR      LOC_9ED3
LOC_9EF5:
    LD      E, 1
    BIT     6, B
    JR      NZ, LOC_9F03
    JR      LOC_9ED3
LOC_9EFD:
    LD      E, 2
    BIT     7, B
    JR      Z, LOC_9ED3
LOC_9F03:
    RES     0, (IY+0)
    LD      A, (IY+4)
    AND     0F8H
    OR      E
    LD      (IY+4), A
LOC_9F10:
    BIT     0, (IY+0)
RET

BYTE_9F15:
	DB 016,003,032,004,064,001,128,002

OFF_9F1D:
	DW LOC_9EE5
    DW LOC_9EED
    DW LOC_9EF5
    DW LOC_9EFD

BYTE_9F25:
	DB 064,128,016,032

SUB_9F29:
    PUSH    IX
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_AC3F
    LD      C, A
    LD      HL, UNK_9FB3
    LD      A, (IY+1)
    RLCA
    RLCA
    RLCA
    RLCA
    AND     0F0H
    LD      B, A
    LD      A, (IY+2)
    AND     0FH
    OR      B
    LD      E, 7
LOC_9F4A:
    CP      (HL)
    JR      Z, LOC_9F55
    INC     HL
    INC     HL
    INC     HL
    DEC     E
    JR      NZ, LOC_9F4A
    JR      LOC_9FA0
LOC_9F55:
    XOR     A
    INC     HL
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    PUSH    IX
    PUSH    DE
    POP     IX
    POP     HL
    JP      (IX)
LOC_9F62:
    BIT     1, (HL)
    JR      Z, LOC_9F6C
    BIT     3, (HL)
    JR      Z, LOC_9F6C
    SET     6, A
LOC_9F6C:
    DEC     HL
    BIT     0, (HL)
    JR      Z, LOC_9FAF
    BIT     2, (HL)
    JR      Z, LOC_9FAF
    SET     7, A
    JR      LOC_9FAF
LOC_9F79:
    LD      A, (HL)
    AND     0F0H
    JR      LOC_9FAF
LOC_9F7E:
    LD      A, 0C0H
    JR      LOC_9FAF
LOC_9F82:
    BIT     2, (HL)
    JR      Z, LOC_9F8C
    BIT     3, (HL)
    JR      Z, LOC_9F8C
    SET     5, A
LOC_9F8C:
    LD      BC, 0FFF0H
    ADD     HL, BC
    BIT     0, (HL)
    JR      Z, LOC_9FAF
    BIT     1, (HL)
    JR      Z, LOC_9FAF
    SET     4, A
    JR      LOC_9FAF
LOC_9F9C:
    LD      A, 30H
    JR      LOC_9FAF
LOC_9FA0:
    LD      A, (HL)
    AND     0F0H
    PUSH    AF
    LD      A, C
    CALL    SUB_ABB7
    LD      (IY+2), B
    LD      (IY+1), C
    POP     AF
LOC_9FAF:
    AND     A
    POP     IX
RET

UNK_9FB3:
	DB    0
    DW LOC_9F62
    DB  40H
    DW LOC_9F7E
    DB  80H
    DW LOC_9F79
    DB 0C0H
    DW LOC_9F7E
    DB  88H
    DW LOC_9F82
    DB  84H
    DW LOC_9F9C
    DB  8CH
    DW LOC_9F9C

SUB_9FC8:
    PUSH    IY
    LD      B, (IY+2)
    LD      A, ($7284)
    SUB     B
    JR      NC, LOC_9FD5
    CPL
    INC     A
LOC_9FD5:
    LD      L, 0
    CP      5
    JR      NC, LOC_9FEF
    LD      B, (IY+1)
    LD      A, ($7285)
    SUB     B
    JR      NC, LOC_9FE6
    CPL
    INC     A
LOC_9FE6:
    CP      5
    JR      NC, LOC_9FEF
    CALL    PLAY_LOSE_LIFE_SOUND
    LD      L, 1
LOC_9FEF:
    POP     IY
    LD      A, L
    AND     A
RET

SUB_9FF4:
    PUSH    IX
    CALL    SUB_9F29
    PUSH    AF
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_AC3F
    POP     BC
    CALL    SUB_A028
    JR      NZ, LOC_A00C
    CALL    SUB_A1AC
LOC_A00C:
    CP      2
    JR      Z, LOC_A01E
    LD      A, (IY+4)
    AND     7
    CALL    SUB_9D2F
    JR      Z, LOC_A024
    CP      0FFH
    JR      Z, LOC_A022
LOC_A01E:
    SET     3, (IY+4)
LOC_A022:
    LD      A, 1
LOC_A024:
    AND     A
    POP     IX
RET

SUB_A028:
    PUSH    BC
    PUSH    IX
    PUSH    AF
    LD      A, (IY+2)
    AND     0FH
    LD      C, A
    LD      A, (IY+1)
    RLCA
    RLCA
    RLCA
    RLCA
    AND     0F0H
    OR      C
    LD      C, 7
    LD      HL, UNK_A12A
LOC_A041:
    CP      (HL)
    JR      Z, LOC_A04D
    INC     HL
    INC     HL
    INC     HL
    DEC     C
    JR      NZ, LOC_A041
    DEC     HL
    DEC     HL
    DEC     HL
LOC_A04D:
    INC     HL
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    PUSH    DE
    POP     IX
    POP     HL
    LD      A, H
    LD      L, 0FFH
    CALL    SUB_A13F
    JR      Z, LOC_A05E
    LD      L, A
LOC_A05E:
    JP      (IX)

LOC_A060:
    LD      C, 41H
    LD      A, H
    DEC     A
    CALL    SUB_A13F
    JR      Z, LOC_A06F
    CP      L
    JR      NC, LOC_A06F
    LD      C, 82H
    LD      L, A
LOC_A06F:
    JP      LOC_A102
LOC_A072:
    LD      C, 82H
    LD      A, H
    INC     A
    CALL    SUB_A13F
    JR      Z, LOC_A081
    CP      L
    JR      NC, LOC_A081
    LD      L, A
    LD      C, 41H
LOC_A081:
    JP      LOC_A102
LOC_A084:
    LD      C, 13H
    LD      A, H
    ADD     A, 10H
    CALL    SUB_A13F
    JR      Z, LOC_A094
    CP      L
    JR      NC, LOC_A094
    LD      L, A
    LD      C, 24H
LOC_A094:
    JP      LOC_A102
LOC_A097:
    LD      C, 24H
    LD      A, H
    SUB     10H
    CALL    SUB_A13F
    JR      Z, LOC_A0A7
    CP      L
    JR      NC, LOC_A0A7
    LD      L, A
    LD      C, 13H
LOC_A0A7:
    JP      LOC_A102
LOC_A0AA:
    LD      L, 0FFH
    LD      A, H
    AND     0FH
    JR      Z, LOC_A0BF
    BIT     6, B
    JR      Z, LOC_A0BF
    LD      A, H
    INC     A
    CALL    SUB_A13F
    JR      Z, LOC_A0BF
    LD      L, A
    LD      C, 41H
LOC_A0BF:
    LD      A, H
    DEC     A
    AND     0FH
    JR      Z, LOC_A0D6
    BIT     7, B
    JR      Z, LOC_A0D6
    LD      A, H
    DEC     A
    CALL    SUB_A13F
    JR      Z, LOC_A0D6
    CP      L
    JR      NC, LOC_A0D6
    LD      L, A
    LD      C, 82H
LOC_A0D6:
    LD      A, H
    CP      11H
    JR      C, LOC_A0EC
    BIT     4, B
    JR      Z, LOC_A0EC
    SUB     10H
    CALL    SUB_A13F
    JR      Z, LOC_A0EC
    CP      L
    JR      NC, LOC_A0EC
    LD      L, A
    LD      C, 13H
LOC_A0EC:
    LD      A, H
    CP      91H
    JR      NC, LOC_A102
    BIT     5, B
    JR      Z, LOC_A102
    ADD     A, 10H
    CALL    SUB_A13F
    JR      Z, LOC_A102
    CP      L
    JR      NC, LOC_A102
    LD      L, A
    LD      C, 24H
LOC_A102:
    LD      D, 0
    LD      A, L
    CP      0FFH
    JR      Z, LOC_A124
    LD      A, C
    AND     7
    LD      L, A
    LD      A, (IY+4)
    AND     0F8H
    OR      L
    LD      (IY+4), A
    LD      D, 1
    LD      A, C
    AND     0F0H
    AND     B
    JR      NZ, LOC_A124
    SET     0, (IY+0)
    LD      D, 2
LOC_A124:
    POP     IX
    POP     BC
    LD      A, D
    AND     A
RET

UNK_A12A:
	DB    0
    DW LOC_A060
    DB  40H
    DW LOC_A060
    DB 0C0H
    DW LOC_A072
    DB  84H
    DW LOC_A084
    DB  88H
    DW LOC_A097
    DB  8CH
    DW LOC_A097
    DB  80H
    DW LOC_A0AA

SUB_A13F:
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      D, A
    LD      A, (BADGUY_BHVR_CNT_RAM)
    AND     A
    JR      Z, LOC_A159
    LD      C, A
    LD      B, 0
    DEC     BC
    LD      HL, BADGUY_BEHAVIOR_RAM
    ADD     HL, BC
    INC     BC
    LD      A, D
    CPDR
    JR      Z, LOC_A182
LOC_A159:
    LD      HL, BADGUY_BEHAVIOR_RAM
    LD      BC, 4FH
    ADD     HL, BC
    PUSH    HL
    POP     IX
    LD      HL, BADGUY_BEHAVIOR_RAM
    LD      A, (BADGUY_BHVR_CNT_RAM)
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      B, H
    LD      C, L
    PUSH    IX
    POP     HL
    XOR     A
    SBC     HL, BC
    JR      Z, LOC_A1A4
    INC     HL
    LD      B, H
    LD      C, L
    PUSH    IX
    POP     HL
    LD      A, D
    CPDR
    JR      NZ, LOC_A1A4
LOC_A182:
    INC     HL
    PUSH    HL
    LD      HL, BADGUY_BEHAVIOR_RAM
    LD      A, (BADGUY_BHVR_CNT_RAM)
    LD      C, A
    LD      B, 0
    AND     A
    JR      NZ, LOC_A193
    LD      BC, 50H
LOC_A193:
    DEC     BC
    ADD     HL, BC
    POP     BC
    XOR     A
    SBC     HL, BC
    JR      NC, LOC_A1A0
    LD      BC, 50H
    XOR     A
    ADD     HL, BC
LOC_A1A0:
    INC     L
    LD      A, L
    JR      LOC_A1A5
LOC_A1A4:
    XOR     A
LOC_A1A5:
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    AND     A
RET

SUB_A1AC:
    LD      L, 0
    LD      H, (IY+1)
    LD      A, ($7285)
    CP      H
    JR      Z, LOC_A1BF
    JR      C, LOC_A1BD
    SET     6, L
    JR      LOC_A1BF
LOC_A1BD:
    SET     7, L
LOC_A1BF:
    LD      H, (IY+2)
    LD      A, ($7284)
    CP      H
    JR      Z, LOC_A1D0
    JR      C, LOC_A1CE
    SET     5, L
    JR      LOC_A1D0
LOC_A1CE:
    SET     4, L
LOC_A1D0:
    LD      A, L
    AND     B
    JR      NZ, LOC_A1D8
    LD      A, 2
    JR      LOC_A1DD
LOC_A1D8:
    CALL    SUB_9E7A
    LD      A, 1
LOC_A1DD:
    AND     A
RET

SUB_A1DF:
    PUSH    IX
    LD      B, 0
    BIT     5, (IY+4)
    JR      NZ, LOC_A20E
    BIT     1, (IY+0)
    JR      Z, LOC_A254
    LD      A, (IY+4)
    AND     7
    DEC     A
    CP      4
    JR      NC, LOC_A254
    LD      HL, BYTE_9F25
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      C, (HL)
    PUSH    BC
    CALL    SUB_9F29
    POP     BC
    AND     A
    JR      Z, LOC_A254
    AND     C
    JR      NZ, LOC_A252
    JR      LOC_A21E
LOC_A20E:
    RES     1, (IY+0)
    CALL    SUB_9CE0
    LD      C, A
    CALL    RAND_GEN
    AND     0FH
    CP      C
    JR      NC, LOC_A254
LOC_A21E:
    LD      A, (IY+0)
    AND     0F8H
    LD      (IY+0), A
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_AC3F
    LD      E, A
    CALL    SUB_A259
    JR      NZ, LOC_A241
    CALL    SUB_A382
    JR      Z, LOC_A241
    CALL    SUB_A402
    LD      B, 0
    JR      NZ, LOC_A254
LOC_A241:
    PUSH    HL
    CALL    SUB_9F29
    POP     HL
    LD      B, 0
    AND     L
    JR      Z, LOC_A254
    CALL    SUB_9E7A
    SET     1, (IY+0)
LOC_A252:
    LD      B, 1
LOC_A254:
    LD      A, B
    POP     IX
    AND     A
RET

SUB_A259:
    PUSH    IX
    PUSH    DE
    PUSH    BC
    LD      A, ($72D9)
    LD      B, A
    XOR     A
    BIT     6, B
    JR      Z, LOC_A2B9
    PUSH    DE
    LD      A, E
    CALL    SUB_ABB7
    PUSH    BC
    LD      A, ($72DA)
    LD      B, A
    LD      A, ($72DB)
    LD      C, A
    CALL    SUB_AC3F
    PUSH    AF
    PUSH    IX
    CALL    SUB_ABB7
    POP     IX
    POP     AF
    POP     HL
    POP     DE
    LD      D, A
    SUB     E
    JR      Z, LOC_A2B9
    LD      A, ($72D9)
    AND     3
    JR      NZ, LOC_A297
    CALL    SUB_A2C0
    JR      NZ, LOC_A2B9
    CALL    SUB_A34C
    JR      LOC_A2B9
LOC_A297:
    DEC     A
    JR      NZ, LOC_A2A4
    CALL    SUB_A2E8
    JR      NZ, LOC_A2B9
    CALL    SUB_A34C
    JR      LOC_A2B9
LOC_A2A4:
    DEC     A
    JR      NZ, LOC_A2B1
    CALL    SUB_A2C0
    JR      NZ, LOC_A2B9
    CALL    SUB_A316
    JR      LOC_A2B9
LOC_A2B1:
    CALL    SUB_A2E8
    JR      NZ, LOC_A2B9
    CALL    SUB_A316
LOC_A2B9:
    LD      L, A
    POP     BC
    POP     DE
    POP     IX
    AND     A
RET

SUB_A2C0:
    PUSH    DE
    PUSH    HL
    LD      A, B
    CP      H
    JR      NZ, LOC_A2E3
    LD      A, L
    SUB     C
    JR      C, LOC_A2E3
    CP      21H
    JR      NC, LOC_A2E3
    INC     D
    BIT     6, (IX+0)
    JR      Z, LOC_A2E3
    LD      A, E
    CP      D
    JR      Z, LOC_A2DF
    BIT     6, (IX+1)
    JR      Z, LOC_A2E3
LOC_A2DF:
    LD      A, 70H
    JR      LOC_A2E4
LOC_A2E3:
    XOR     A
LOC_A2E4:
    POP     HL
    POP     DE
    AND     A
RET

SUB_A2E8:
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A, B
    CP      H
    JR      NZ, LOC_A30F
    LD      A, C
    SUB     L
    JR      C, LOC_A30F
    CP      21H
    JR      NC, LOC_A30F
    DEC     D
    BIT     7, (IX+0)
    JR      Z, LOC_A30F
    LD      A, E
    CP      D
    JR      Z, LOC_A30B
    DEC     IX
    BIT     7, (IX+0)
    JR      Z, LOC_A30F
LOC_A30B:
    LD      A, 0B0H
    JR      LOC_A310
LOC_A30F:
    XOR     A
LOC_A310:
    POP     IX
    POP     HL
    POP     DE
    AND     A
RET

SUB_A316:
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A, C
    CP      L
    JR      NZ, LOC_A345
    LD      A, B
    SUB     H
    JR      C, LOC_A345
    CP      21H
    JR      NC, LOC_A345
    LD      A, D
    SUB     10H
    LD      D, A
    BIT     4, (IX+0)
    JR      Z, LOC_A345
    LD      A, E
    CP      D
    JR      Z, LOC_A341
    PUSH    BC
    LD      BC, 0FFF0H
    ADD     IX, BC
    POP     BC
    BIT     4, (IX+0)
    JR      Z, LOC_A345
LOC_A341:
    LD      A, 0D0H
    JR      LOC_A346
LOC_A345:
    XOR     A
LOC_A346:
    POP     IX
    POP     HL
    POP     DE
    AND     A
RET

SUB_A34C:
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A, C
    CP      L
    JR      NZ, LOC_A37B
    LD      A, H
    SUB     B
    JR      C, LOC_A37B
    CP      21H
    JR      NC, LOC_A37B
    LD      A, D
    ADD     A, 10H
    LD      D, A
    BIT     5, (IX+0)
    JR      Z, LOC_A37B
    LD      A, E
    CP      D
    JR      Z, LOC_A377
    PUSH    BC
    LD      BC, 10H
    ADD     IX, BC
    POP     BC
    BIT     5, (IX+0)
    JR      Z, LOC_A37B
LOC_A377:
    LD      A, 0E0H
    JR      LOC_A37C
LOC_A37B:
    XOR     A
LOC_A37C:
    POP     IX
    POP     HL
    POP     DE
    AND     A
RET

SUB_A382:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    PUSH    IY
    LD      A, E
    PUSH    DE
    CALL    SUB_ABB7
    POP     DE
    LD      L, 5
    LD      IY, $722C
LOC_A394:
    BIT     7, (IY+0)
    JR      Z, LOC_A3EE
    BIT     5, (IY+0)
    JR      Z, LOC_A3EE
    LD      A, C
    CP      (IY+2)
    JR      NZ, LOC_A3EE
    LD      A, B
    CP      (IY+1)
    JR      C, LOC_A3EE
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      B, (IY+1)
    LD      C, (IY+2)
    CALL    SUB_AC3F
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    LD      H, A
    LD      D, E
LOC_A3C1:
    PUSH    BC
    LD      BC, 0FFF0H
    ADD     IX, BC
    POP     BC
    LD      A, D
    SUB     10H
    LD      D, A
    LD      A, (IX+0)
    AND     0FH
    CP      0FH
    JR      NZ, LOC_A3EE
    LD      A, H
    CP      D
    JR      C, LOC_A3C1
    LD      L, 0E0H
    POP     IY
    LD      A, (IY+1)
    CP      C
    JR      Z, LOC_A3EB
    RES     7, L
    JR      NC, LOC_A3EB
    SET     7, L
    RES     6, L
LOC_A3EB:
    XOR     A
    JR      LOC_A3FC
LOC_A3EE:
    PUSH    BC
    LD      BC, 5
    ADD     IY, BC
    POP     BC
    DEC     L
    JR      NZ, LOC_A394
    LD      A, 1
    POP     IY
LOC_A3FC:
    POP     IX
    POP     DE
    POP     BC
    AND     A
RET

SUB_A402:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      B, (IY+2)
    LD      C, (IY+1)
    LD      L, 5
    LD      IX, $722C
LOC_A412:
    BIT     7, (IX+0)
    JR      Z, LOC_A44D
    BIT     6, (IX+0)
    JR      Z, LOC_A44D
    LD      D, (IX+1)
    LD      E, (IX+2)
    LD      A, B
    CP      D
    JR      C, LOC_A44D
    SUB     D
    CP      21H
    JR      NC, LOC_A44D
    LD      A, C
    SUB     E
    JR      NC, LOC_A433
    CPL
    INC     A
LOC_A433:
    CP      11H
    JR      NC, LOC_A44D
    LD      H, 0
    LD      A, (IY+1)
    LD      L, 0E0H
    CP      (IX+2)
    JR      Z, LOC_A459
    RES     7, L
    JR      NC, LOC_A459
    SET     7, L
    RES     6, L
    JR      LOC_A459
LOC_A44D:
    PUSH    BC
    LD      BC, 5
    ADD     IX, BC
    POP     BC
    DEC     L
    JR      NZ, LOC_A412
    LD      H, 1
LOC_A459:
    POP     IX
    POP     DE
    POP     BC
    LD      A, H
    AND     A
RET

SUB_A460:
    CALL    SUB_A497
    JR      Z, LOCRET_A496
LOC_A465:
    LD      L, A
    PUSH    HL
    CALL    SUB_9E7A
    LD      A, (IY+4)
    AND     7
    CALL    SUB_9D2F
    POP     HL
    JR      Z, LOCRET_A496
    LD      A, (IY+4)
    AND     7
    LD      C, 0C0H
    CP      3
    JR      NC, LOC_A482
    LD      C, 30H
LOC_A482:
    LD      A, L
    AND     C
    JR      NZ, LOC_A465
    LD      A, (IY+4)
    BIT     0, A
    JR      Z, LOC_A490
    INC     A
    JR      LOC_A491
LOC_A490:
    DEC     A
LOC_A491:
    LD      (IY+4), A
    JR      LOCRET_A496
LOCRET_A496:
RET

SUB_A497:
    LD      A, (IY+2)
    LD      B, A
    AND     0FH
    JR      NZ, LOC_A512
    LD      A, (IY+1)
    LD      C, A
    AND     0FH
    CP      8
    JR      NZ, LOC_A512
    LD      H, 0
    LD      A, ($7284)
    CP      B
    JR      Z, LOC_A4B9
    JR      NC, LOC_A4B7
    SET     4, H
    JR      LOC_A4B9
LOC_A4B7:
    SET     5, H
LOC_A4B9:
    LD      A, ($7285)
    CP      C
    JR      Z, LOC_A520
    LD      A, C
    JR      C, LOC_A4C8
    SET     6, H
    ADD     A, 10H
    JR      LOC_A4CC
LOC_A4C8:
    SET     7, H
    SUB     10H
LOC_A4CC:
    LD      C, A
    LD      IX, $722C
    LD      L, 5
LOC_A4D3:
    BIT     7, (IX+0)
    JR      Z, LOC_A4F3
    LD      A, (IX+1)
    SUB     9
    CP      B
    JR      NC, LOC_A4F3
    ADD     A, 12H
    CP      B
    JR      C, LOC_A4F3
    LD      A, (IX+2)
    SUB     0FH
    CP      C
    JR      NC, LOC_A4F3
    ADD     A, 1FH
    CP      C
    JR      NC, LOC_A4FD
LOC_A4F3:
    LD      DE, 5
    ADD     IX, DE
    DEC     L
    JR      NZ, LOC_A4D3
    JR      LOC_A520
LOC_A4FD:
    LD      A, H
    AND     30H
    LD      H, A
    JR      NZ, LOC_A520
    SET     4, H
    LD      A, (IY+2)
    CP      30H
    JR      NC, LOC_A520
    RES     4, H
    SET     5, H
    JR      LOC_A520
LOC_A512:
    LD      A, (IY+4)
    AND     7
    DEC     A
    LD      E, A
    LD      D, 0
    LD      HL, BYTE_A523
    ADD     HL, DE
    LD      H, (HL)
LOC_A520:
    LD      A, H
    AND     A
RET

BYTE_A523:
	DB 064,128,016,032

SUB_A527:
    PUSH    BC
    LD      A, ($726E)
    LD      B, A
    LD      A, ($7278)
    BIT     0, B
    JR      Z, LOC_A53A
    BIT     1, B
    JR      Z, LOC_A53A
    LD      A, ($7279)
LOC_A53A:
    CP      1
    POP     BC
RET

SUB_A53E:
    LD      A, ($72BA)
    BIT     7, A
    JR      NZ, LOC_A551
    SET     7, A
    LD      ($72BA), A
    LD      A, 40H
    LD      ($72BD), A
    JR      LOC_A5A6
LOC_A551:
    LD      A, ($72BD)
    BIT     7, A
    LD      A, 0
    JR      NZ, LOC_A5BB
    LD      A, ($72C0)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_A5BB
    LD      A, ($72BA)
    BIT     6, A
    JR      Z, LOC_A56F
    CALL    SUB_A6BB
    JR      LOC_A5AA
LOC_A56F:
    LD      A, ($7272)
    BIT     5, A
    JR      NZ, LOC_A57B
    CALL    SUB_A61F
    JR      Z, LOC_A591
LOC_A57B:
    CALL    SUB_A5F9
    JR      NZ, LOC_A591
    CALL    SUB_A662
    LD      HL, $7272
    BIT     5, (HL)
    JR      Z, LOC_A5A9
    RES     5, (HL)
    CALL    SUB_B8A3
    JR      LOC_A5A9
LOC_A591:
    JP      LOC_D309


LOC_A596:
    LD      A, ($7272)
    BIT     4, A
    JR      NZ, LOC_A5A9
    LD      A, ($72C2)
    DEC     A
    LD      ($72C2), A
    JR      NZ, LOC_A5A9
LOC_A5A6:
    CALL    SUB_A5BD
LOC_A5A9:
    XOR     A
LOC_A5AA:
    PUSH    AF
    LD      HL, 0AH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      ($72C0), A
    POP     AF
    PUSH    AF
    CALL    SUB_A788
    POP     AF
LOC_A5BB:
    AND     A
RET

SUB_A5BD:
    LD      A, ($72BA)
    INC     A
    AND     0F7H
    LD      ($72BA), A
    LD      HL, BYTE_A5F1
    LD      A, ($72BA)
    AND     7
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      A, (HL)
    LD      ($72BE), A
    LD      A, 0CH
    LD      ($72BF), A
    LD      HL, BYTE_A616
    ADD     HL, BC
    LD      A, (HL)
    LD      ($72BC), A
    LD      HL, BYTE_A617
    ADD     HL, BC
    LD      A, (HL)
    LD      ($72BB), A
    LD      A, 18H
    LD      ($72C2), A
RET

BYTE_A5F1:
	DB 091,107,123,139,155,139,123,107

SUB_A5F9:
    LD      A, ($72BA)
    AND     7
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_A617
    ADD     HL, BC
    LD      B, (HL)
    LD      HL, $72B8
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_A613
    INC     HL
LOC_A613:
    LD      A, (HL)
    AND     B
RET

BYTE_A616:
	DB 002
BYTE_A617:
	DB 001,002,004,008,016,008,004,002

SUB_A61F:
    LD      HL, $727A
    LD      BC, (SCORE_P1_RAM)
    LD      HL, $727A
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_A637
    LD      BC, (SCORE_P2_RAM)
    INC     HL
LOC_A637:
    LD      D, (HL)
    LD      E, 0
LOC_A63A:
    LD      A, C
    SUB     0E8H
    LD      C, A
    LD      A, B
    SBC     A, 3
    LD      B, A
    JR      C, LOC_A647
    INC     E
    JR      LOC_A63A
LOC_A647:
    LD      A, E
    LD      E, 0
    CP      D
    JR      Z, LOC_A65F
    LD      (HL), A
    LD      A, ($72BA)
    LD      B, A
    BIT     6, A
    JR      NZ, LOC_A65F
    LD      A, ($72BA)
    SET     5, A
    LD      ($72BA), A
    INC     E
LOC_A65F:
    LD      A, E
    AND     A
RET

SUB_A662:
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_A66F
    LD      A, ($7275)
LOC_A66F:
    CP      0BH
    JR      C, LOC_A677
    SUB     0AH
    JR      LOC_A66F
LOC_A677:
    CP      4
    JR      NZ, LOC_A67F
    LD      A, 98H
    JR      LOC_A681
LOC_A67F:
    LD      A, 78H
LOC_A681:
    LD      ($72BE), A
    LD      A, 20H
    LD      ($72BF), A
    LD      A, 0CH
    LD      ($72C2), A
    LD      A, ($72BA)
    SET     6, A
    LD      ($72BA), A
    LD      A, ($7272)
    BIT     5, A
    JR      NZ, LOC_A6AB
    LD      HL, $72C4
    SET     0, (HL)
    LD      HL, 5A0H
    CALL    REQUEST_SIGNAL
    LD      ($726F), A
LOC_A6AB:
    LD      A, ($72BA)
    BIT     5, A
    JR      Z, LOCRET_A6BA
    RES     5, A
    LD      ($72BA), A
    JP      LOC_D31C
LOCRET_A6BA:
RET

SUB_A6BB:
    PUSH    IX
    PUSH    IY
    LD      A, ($72C4)
    BIT     0, A
    JR      Z, LOC_A6F2
    CALL    SUB_A61F
    LD      A, ($726F)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_A6F2
    LD      HL, $72C4
    RES     0, (HL)
    LD      A, 40H
    LD      ($72BD), A
    LD      A, 1
    LD      ($72C2), A
    LD      A, ($72BA)
    RES     6, A
    RES     5, A
    LD      ($72BA), A
    CALL    SUB_CA24
    XOR     A
    JP      LOC_A77E
LOC_A6F2:
    LD      IY, $72BD
    SET     4, (IY+0)
    CALL    SUB_9F29
    LD      D, A
    PUSH    DE
    LD      HL, $7272
    BIT     5, (HL)
    JR      Z, LOC_A70B
    RES     5, (HL)
    CALL    SUB_B8A3
LOC_A70B:
    CALL    SUB_A527
    POP     DE
    JR      Z, LOC_A74B
    LD      A, ($728A)
    BIT     4, A
    JR      NZ, LOC_A74B
LOC_A718:
    LD      A, ($72C2)
    DEC     A
    LD      ($72C2), A
    JR      NZ, LOC_A72F
    LD      A, 0CH
    LD      ($72C2), A
    CALL    RAND_GEN
    AND     0FH
    CP      7
    JR      NC, LOC_A76B
LOC_A72F:
    LD      A, ($72C1)
    AND     0FH
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_A783
    ADD     HL, BC
    LD      A, (HL)
    AND     D
    JR      Z, LOC_A76B
    LD      A, ($72C1)
    AND     0FH
    CALL    SUB_9D2F
    JR      Z, LOC_A77B
    JR      LOC_A76B
LOC_A74B:
    LD      A, ($72BF)
    LD      B, A
    LD      A, ($72BE)
    LD      C, A
    PUSH    DE
    CALL    SUB_AC3F
    POP     BC
    CALL    SUB_A028
    JR      Z, LOC_A718
    CP      2
    JR      Z, LOC_A76B
    LD      A, ($72C1)
    AND     7
    CALL    SUB_9D2F
    JR      Z, LOC_A77B
LOC_A76B:
    CALL    SUB_9F29
    JR      Z, LOC_A77B
    CALL    SUB_9E7A
    LD      A, ($72C1)
    AND     7
    CALL    SUB_9D2F
LOC_A77B:
    CALL    SUB_9FC8
LOC_A77E:
    POP     IY
    POP     IX
RET

BYTE_A783:
	DB 000,064,128,016,032

SUB_A788:
    LD      A, ($7272)
    BIT     4, A
    JR      Z, LOC_A796
    LD      A, ($72BA)
    BIT     6, A
    JR      Z, LOCRET_A7DB
LOC_A796:
    LD      A, ($726E)
    BIT     1, A
    LD      IX, $72B8
    JR      Z, LOC_A7A5
    LD      IX, $72B9
LOC_A7A5:
    LD      A, ($72BA)
    AND     7
    LD      HL, BYTE_A7DC
    LD      C, A
    ADD     A, A
    ADD     A, C
    LD      C, A
    LD      B, 0
    ADD     HL, BC
    LD      A, (HL)
    INC     HL
    AND     (IX+0)
    JR      Z, LOC_A7BC
    INC     HL
LOC_A7BC:
    LD      D, (HL)
    LD      A, ($72BA)
    BIT     5, A
    JR      Z, LOC_A7C8
    RES     5, A
    JR      LOC_A7CB
LOC_A7C8:
    SET     5, A
    INC     D
LOC_A7CB:
    LD      ($72BA), A
    LD      A, ($72BF)
    LD      B, A
    LD      A, ($72BE)
    LD      C, A
    LD      A, 3
    CALL    SUB_B629
LOCRET_A7DB:
RET

BYTE_A7DC:
	DB 001,001,012,002,003,014,004,005,016,008,007,018,016,009,020,008,007,018,004,005,016,002,003,014

SUB_A7F4:
    LD      A, ($72C5)
    AND     3
    LD      IY, $72C7
    LD      BC, 6
LOC_A800:
    DEC     A
    JP      M, LOC_A808
    ADD     IY, BC
    JR      LOC_A800
LOC_A808:
    BIT     7, (IY+4)
    JR      Z, LOC_A82B
    BIT     7, (IY+0)
    JR      NZ, LOC_A82B
    LD      A, (IY+3)
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_A82B
    CALL    SUB_A83E
    CALL    SUB_A8CB
    CALL    SUB_A921
    CALL    SUB_A92C
    JR      LOC_A82C
LOC_A82B:
    XOR     A
LOC_A82C:
    PUSH    AF
    LD      HL, $72C5
    INC     (HL)
    LD      A, (HL)
    AND     3
    CP      3
    JR      NZ, LOC_A83C
    LD      A, (HL)
    AND     0FCH
    LD      (HL), A
LOC_A83C:
    POP     AF
RET

SUB_A83E:
    JP      LOC_D383

LOC_A853:
    CALL    SUB_A460
    JR      LOCRET_A8C6
LOC_A858:
    LD      A, (IY+2)
    AND     0FH
    JR      NZ, LOC_A868
    LD      A, (IY+1)
    AND     0FH
    CP      8
    JR      Z, LOC_A878
LOC_A868:
    LD      A, (IY+4)
    AND     7
    DEC     A
    LD      E, A
    LD      D, 0
    LD      HL, BYTE_A8C7
    ADD     HL, DE
    LD      H, (HL)
    JR      LOC_A898
LOC_A878:
    LD      H, 0F0H
    LD      A, (IY+2)
    CP      28H
    JR      NC, LOC_A883
    RES     4, H
LOC_A883:
    CP      0A8H
    JR      C, LOC_A889
    RES     5, H
LOC_A889:
    LD      A, (IY+1)
    CP      20H
    JR      NC, LOC_A892
    RES     7, H
LOC_A892:
    CP      0E0H
    JR      C, LOC_A898
    RES     6, H
LOC_A898:
    LD      A, H
    PUSH    HL
    CALL    SUB_9E7A
    LD      A, (IY+4)
    AND     7
    CALL    SUB_9D2F
    POP     HL
    JR      Z, LOCRET_A8C6
    LD      A, (IY+4)
    JP      LOC_D3D5

LOC_A8AF:
    JR      NC, LOC_A8B3
    LD      C, 30H
LOC_A8B3:
    LD      A, H
    AND     C
    LD      H, A
    JR      NZ, LOC_A898
    LD      A, (IY+4)
    BIT     0, A
    JR      Z, LOC_A8C2
    INC     A
    JR      LOC_A8C3
LOC_A8C2:
    DEC     A
LOC_A8C3:
    LD      (IY+4), A
LOCRET_A8C6:
RET

BYTE_A8C7:
	DB 064,128,016,032

SUB_A8CB:
    CALL    SUB_9B4F
    LD      B, (IY+2)
    LD      C, (IY+1)
    CALL    SUB_AC3F
    LD      D, A
    CALL    SUB_B173
    LD      D, 1
    LD      A, (IY+4)
    AND     7
    CP      1
    JR      Z, LOC_A905
    CP      2
    JR      NZ, LOC_A8EE
    INC     D
    INC     D
    JR      LOC_A905
LOC_A8EE:
    LD      A, ($72C5)
    ADD     A, A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      HL, $712F
    ADD     HL, BC
    LD      A, (HL)
    CP      0E0H
    JR      Z, LOC_A905
    CP      0E4H
    JR      Z, LOC_A905
    INC     D
    INC     D
LOC_A905:
    LD      A, (IY+5)
    BIT     7, A
    JR      Z, LOC_A90D
    INC     D
LOC_A90D:
    XOR     80H
    LD      (IY+5), A
    LD      B, (IY+2)
    LD      C, (IY+1)
    LD      A, ($72C5)
    ADD     A, 11H
    CALL    SUB_B629
RET

SUB_A921:
    CALL    SUB_9BE2
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3), A
RET

SUB_A92C:
    CALL    SUB_9FC8
RET

GOT_DIAMOND:
    LD      HL, DIAMOND_RAM
    LD      (HL), 0
    CP      1
    JR      NZ, COMPLETED_LEVEL
    LD      HL, 78H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
NO_DIAMOND:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, NO_DIAMOND
    POP     AF
    JR      LOC_A973
COMPLETED_LEVEL:
    PUSH    AF
    LD      HL, 1EH
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_A956:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_A956
    POP     AF
    POP     AF
    CP      2
    JR      NZ, LOC_A969
    CALL    DEAL_WITH_END_OF_ROUND_TUNE
    JR      LOC_A96C
LOC_A969:
    CALL    SUB_A99C
LOC_A96C:
    CALL    SUB_AA25
    LD      A, 2
    JR      LOCRET_A987
LOC_A973:
    CALL    SUB_AA69
    CP      1
    JR      Z, LOCRET_A987
    AND     A
    JR      Z, LOC_A984
    CALL    SUB_AADC
    LD      A, 1
    JR      LOCRET_A987
LOC_A984:
    CALL    SUB_AB28
LOCRET_A987:
RET

DEAL_WITH_END_OF_ROUND_TUNE:
    CALL    PLAY_END_OF_ROUND_TUNE
    LD      HL, 103H
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_A992:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_A992
    POP     AF
RET

SUB_A99C:
    LD      HL, $726E
    SET     7, (HL)
LOC_A9A1:
    BIT     7, (HL)
    JR      NZ, LOC_A9A1
    LD      HL, 1000H
    LD      DE, 300H
    LD      A, 0
    CALL    FILL_VRAM
    LD      HL, 1900H
    LD      DE, 80H
    LD      A, 0
    CALL    FILL_VRAM
    LD      HL, SPRITE_NAME_TABLE
    LD      B, 50H
LOC_A9C0:
    LD      (HL), 0
    INC     HL
    DJNZ    LOC_A9C0
    LD      A, 6
    CALL    DEAL_WITH_PLAYFIELD
    LD      BC, 70CH
    CALL    WRITE_REGISTER
    XOR     A
    LD      ($72BC), A
    LD      ($72BB), A
    LD      HL, $726E
    BIT     1, (HL)
    JR      NZ, DEAL_WITH_EXTRA_MR_DO
    LD      ($72B8), A
    LD      HL, LIVES_LEFT_P1_RAM
    JR      LOC_A9EC
DEAL_WITH_EXTRA_MR_DO:
    LD      ($72B9), A
    LD      HL, LIVES_LEFT_P2_RAM
LOC_A9EC:
    LD      A, (HL)
    CP      6
    JR      NC, LOC_A9F2
    INC     (HL)
LOC_A9F2:
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    CALL    INITIALIZE_THE_SOUND
    CALL    PLAY_WIN_EXTRA_DO_TUNE
    LD      HL, 180H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AA06:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_AA06
    POP     AF
    LD      HL, $726E
    SET     7, (HL)
LOC_AA14:
    BIT     7, (HL)
    JR      NZ, LOC_AA14
    LD      BC, 700H
    CALL    WRITE_REGISTER
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
RET

SUB_AA25:
    LD      HL, $726E
    SET     7, (HL)
LOC_AA2A:
    BIT     7, (HL)
    JR      NZ, LOC_AA2A
    LD      HL, CURRENT_LEVEL_RAM
    LD      IX, $7278
    LD      A, ($726E)
    BIT     1, A
    JR      Z, LOC_AA43
    LD      HL, $7275
    LD      IX, $7279
LOC_AA43:
    LD      (IX+0), 7
    INC     (HL)
    LD      A, (HL)
    CALL    SUB_B286
    LD      HL, $718A
    LD      DE, 3400H
    LD      A, ($726E)
    BIT     1, A
    JR      Z, LOC_AA5C
    LD      DE, 3600H
LOC_AA5C:
    LD      BC, 0D4H
    CALL    WRITE_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
RET

SUB_AA69:
    LD      HL, $726E
    SET     7, (HL)
LOC_AA6E:
    BIT     7, (HL)
    JR      NZ, LOC_AA6E
    LD      DE, 3400H
    BIT     1, (HL)
    JR      Z, LOC_AA7C
    LD      DE, 3600H
LOC_AA7C:
    LD      HL, $718A
    LD      BC, 0D4H
    CALL    WRITE_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    LD      IX, LIVES_LEFT_P1_RAM
    LD      IY, LIVES_LEFT_P2_RAM
    LD      HL, $726E
    BIT     1, (HL)
    JR      NZ, LOC_AABD
    DEC     (IX+0)
    JR      Z, LOC_AAAD
    BIT     0, (HL)
    JR      Z, LOC_AACA
    LD      A, (IY+0)
    AND     A
    JR      Z, LOC_AACA
    SET     1, (HL)
    JR      LOC_AACA
LOC_AAAD:
    BIT     0, (HL)
    JR      Z, LOC_AADA
    LD      A, (IY+0)
    AND     A
    JR      Z, LOC_AADA
    SET     1, (HL)
    LD      A, 2
    JR      LOCRET_AADB
LOC_AABD:
    DEC     (IY+0)
    JR      Z, LOC_AACE
    LD      A, (IX+0)
    AND     A
    JR      Z, LOC_AACA
    RES     1, (HL)
LOC_AACA:
    LD      A, 1
    JR      LOCRET_AADB
LOC_AACE:
    LD      A, (IX+0)
    AND     A
    JR      Z, LOC_AADA
    RES     1, (HL)
    LD      A, 3
    JR      LOCRET_AADB
LOC_AADA:
    XOR     A
LOCRET_AADB:
RET

SUB_AADC:
    PUSH    AF
    LD      HL, $726E
    SET     7, (HL)
LOC_AAE2:
    BIT     7, (HL)
    JR      NZ, LOC_AAE2
    LD      HL, 1000H
    LD      DE, 300H
    XOR     A
    CALL    FILL_VRAM
    LD      HL, 1900H
    LD      DE, 80H
    XOR     A
    CALL    FILL_VRAM
    LD      HL, SPRITE_NAME_TABLE
    LD      B, 50H
LOC_AAFF:
    LD      (HL), 0
    INC     HL
    DJNZ    LOC_AAFF
    POP     AF
    CP      2
    LD      A, 7
    JR      Z, LOC_AB0D
    LD      A, 8
LOC_AB0D:
    CALL    DEAL_WITH_PLAYFIELD
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    XOR     A
    LD      HL, 0B4H
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AB1E:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_AB1E
    POP     AF
RET

SUB_AB28:
    LD      HL, $726E
    SET     7, (HL)
LOC_AB2D:
    BIT     7, (HL)
    JR      NZ, LOC_AB2D
    LD      HL, 1900H
    LD      DE, 80H
    XOR     A
    CALL    FILL_VRAM
    LD      HL, SPRITE_NAME_TABLE
    LD      B, 50H
LOC_AB40:
    LD      (HL), 0
    INC     HL
    DJNZ    LOC_AB40
    LD      A, 9
    CALL    DEAL_WITH_PLAYFIELD
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    CALL    PLAY_GAME_OVER_TUNE
    LD      HL, 168H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AB5B:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_AB5B
    POP     AF
    LD      HL, 4B0H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AB6C:
    LD      A, (KEYBOARD_P1)
    CP      0AH
    JR      Z, LOC_ABA5
    CP      0BH
    JR      Z, LOC_ABA9
    LD      A, (KEYBOARD_P2)
    CP      0AH
    JR      Z, LOC_ABA5
    CP      0BH
    JR      Z, LOC_ABA9
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_AB6C
    LD      HL, $726E
    SET     7, (HL)
LOC_AB8F:
    BIT     7, (HL)
    JR      NZ, LOC_AB8F
    LD      HL, 1000H
    LD      DE, 300H
    XOR     A
    CALL    FILL_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    JR      LOC_AB6C
LOC_ABA5:
    POP     AF
    XOR     A
    JR      LOCRET_ABB5
LOC_ABA9:
    LD      HL, $726E
    SET     7, (HL)
LOC_ABAE:
    BIT     7, (HL)
    JR      NZ, LOC_ABAE
    POP     AF
    LD      A, 3
LOCRET_ABB5:
RET

SUB_ABB7:
    LD      B, 20H
    LD      C, 8
    LD      D, 0
    DEC     A
LOC_ABBE:
    CP      10H
    JR      C, LOC_ABC7
    SUB     10H
    INC     D
    JR      LOC_ABBE
LOC_ABC7:
    LD      E, A
LOC_ABC8:
    LD      A, E
    CP      0
    JR      Z, LOC_ABD4
    LD      A, C
    ADD     A, 10H
    LD      C, A
    DEC     E
    JR      LOC_ABC8
LOC_ABD4:
    LD      A, D
    CP      0
    JR      Z, LOCRET_ABE0
    LD      A, B
    ADD     A, 10H
    LD      B, A
    DEC     D
    JR      LOC_ABC8
LOCRET_ABE0:
RET

SUB_ABE1:
    PUSH    IX
    CALL    SUB_AC1F
    LD      IX, BYTE_AC2F
    LD      E, A
    ADD     IX, DE
    LD      E, (IX+0)
    LD      A, (HL)
    OR      E
    LD      (HL), A
    POP     IX
RET

SUB_ABF6:
    PUSH    IX
    CALL    SUB_AC1F
    LD      IX, BYTE_AC37
    LD      E, A
    ADD     IX, DE
    LD      E, (IX+0)
    LD      A, (HL)
    AND     E
    LD      (HL), A
    POP     IX
RET

SUB_AC0B:
    PUSH    IX
    CALL    SUB_AC1F
    LD      IX, BYTE_AC2F
    LD      E, A
    ADD     IX, DE
    LD      E, (IX+0)
    LD      A, (HL)
    AND     E
    POP     IX
RET

SUB_AC1F:
    LD      E, 0
    DEC     A
LOC_AC22:
    CP      8
    JR      C, LOC_AC2B
    SUB     8
    INC     E
    JR      LOC_AC22
LOC_AC2B:
    LD      D, 0
    ADD     HL, DE
RET

BYTE_AC2F:
	DB 128,064,032,016,008,004,002,001
BYTE_AC37:
	DB 127,191,223,239,247,251,253,254

SUB_AC3F:
    PUSH    BC
    LD      D, 1
    LD      A, B
    SUB     18H
LOC_AC45:
    SUB     10H
    JR      C, LOC_AC51
    PUSH    AF
    LD      A, D
    ADD     A, 10H
    LD      D, A
    POP     AF
    JR      LOC_AC45
LOC_AC51:
    LD      A, C
LOC_AC52:
    SUB     10H
    JR      C, LOC_AC59
    INC     D
    JR      LOC_AC52
LOC_AC59:
    LD      A, D
    DEC     A
    LD      B, 0
    LD      C, A
    LD      IX, $718A
    ADD     IX, BC
    LD      A, D
    POP     BC
RET

DEAL_WITH_PLAYFIELD_MAP:
    DEC     A
    ADD     A, A
    LD      B, 0
    LD      C, A
    LD      IX, PLAYFIELD_MAP
    ADD     IX, BC
    LD      B, (IX+1)
    LD      C, (IX+0)
    PUSH    BC
    POP     IX
LOC_ACD5:
    LD      A, 2
    CP      (IX+0)
    JR      Z, LOCRET_ACFF
    LD      A, 1
    CP      (IX+0)
    JR      NZ, LOC_ACF6
    INC     IX
    LD      B, (IX+0)
    INC     IX
    LD      A, (IX+0)
LOC_ACED:
    LD      (HL), B
    INC     HL
    DEC     A
    JR      NZ, LOC_ACED
    INC     IX
    JR      LOC_ACD5
LOC_ACF6:
    LD      B, (IX+0)
    LD      (HL), B
    INC     HL
    INC     IX
    JR      LOC_ACD5
LOCRET_ACFF:
RET

DEAL_WITH_SPRITES:
    LD      B, 0
    LD      C, A
    LD      IX, SPRITE_GENERATOR
    ADD     IX, BC
    AND     A
	RL      C
	RL      B
	RL      C
	RL      B
    ADD     IX, BC
    LD      A, (IX+0)
    AND     A
    JR      NZ, LOC_AD32
    LD      E, (IX+1)
    LD      D, (IX+2)
    LD      L, (IX+3)
    LD      H, (IX+4)
    LD      IY, 4
    LD      A, 1
    CALL    PUT_VRAM
    JR      LOCRET_AD95
LOC_AD32:
    LD      L, (IX+3)
    LD      H, (IX+4)
    LD      E, (IX+1)
    LD      D, (IX+2)
    PUSH    DE
    POP     IX
    LD      B, 4
LOOP_AD43:
    PUSH    BC
    PUSH    AF
    PUSH    HL
    PUSH    IX
    LD      IY, $72E7
    CP      1
    JR      NZ, LOC_AD55
    CALL    SUB_AD96
    JR      LOC_AD73
LOC_AD55:
    CP      2
    JR      NZ, LOC_AD5E
    CALL    SUB_ADAB
    JR      LOC_AD73
LOC_AD5E:
    CP      3
    JR      NZ, LOC_AD67
    CALL    SUB_ADCA
    JR      LOC_AD73
LOC_AD67:
    CP      4
    JR      NZ, LOC_AD70
    CALL    SUB_ADE9
    JR      LOC_AD73
LOC_AD70:
    CALL    SUB_AE0C
LOC_AD73:
    POP     IX
    LD      E, (IX+0)
    LD      D, 0
    INC     IX
    PUSH    IX
    LD      HL, $72E7
    LD      IY, 1
    LD      A, 1
    CALL    PUT_VRAM
    POP     IX
    POP     HL
    LD      BC, 8
    ADD     HL, BC
    POP     AF
    POP     BC
    DJNZ    LOOP_AD43
LOCRET_AD95:
RET

SUB_AD96:
    LD      B, 8
LOC_AD98:
    LD      D, (HL)
    LD      C, 8
LOC_AD9B:
    SRL     D
	RL      E
    DEC     C
    JR      NZ, LOC_AD9B
    LD      (IY+0), E
    INC     HL
    INC     IY
    DJNZ    LOC_AD98
RET

SUB_ADAB:
    LD      C, 8
    PUSH    HL
    LD      D, 1
LOC_ADB0:
    POP     HL
    PUSH    HL
    LD      B, 8
LOC_ADB4:
    LD      A, (HL)
    AND     D
    JR      Z, LOC_ADB9
	SCF
LOC_ADB9:
	RL      E
    INC     HL
    DJNZ    LOC_ADB4
    LD      (IY+0), E
    INC     IY
    RLC     D
    DEC     C
    JR      NZ, LOC_ADB0
    POP     HL
RET

SUB_ADCA:
    LD      C, 8
    PUSH    HL
    LD      D, 80H
LOC_ADCF:
    POP     HL
    PUSH    HL
    LD      B, 8
LOC_ADD3:
    LD      A, (HL)
    AND     D
    JR      Z, LOC_ADD8
	SCF
LOC_ADD8:
	RL      E
    INC     HL
    DJNZ    LOC_ADD3
    LD      (IY+0), E
    INC     IY
	RRC     D
    DEC     C
    JR      NZ, LOC_ADCF
    POP     HL
RET

SUB_ADE9:
    LD      BC, 7
    ADD     HL, BC
    LD      C, 8
    LD      D, 1
    PUSH    HL
LOC_ADF2:
    POP     HL
    PUSH    HL
    LD      B, 8
LOC_ADF6:
    LD      A, (HL)
    AND     D
    JR      Z, LOC_ADFB
SCF
LOC_ADFB:
	RL      E
    DEC     HL
    DJNZ    LOC_ADF6
    LD      (IY+0), E
    INC     IY
    RLC     D
    DEC     C
    JR      NZ, LOC_ADF2
    POP     HL
RET

SUB_AE0C:
    LD      BC, 7
    ADD     HL, BC
    LD      D, 80H
    PUSH    HL
    LD      C, 8
LOC_AE15:
    POP     HL
    PUSH    HL
    LD      B, 8
LOC_AE19:
    LD      A, (HL)
    AND     D
    JR      Z, LOC_AE1E
	SCF
LOC_AE1E:
	RL      E
    DEC     HL
    DJNZ    LOC_AE19
    LD      (IY+0), E
    INC     IY
	RRC     D
    DEC     C
    JR      NZ, LOC_AE15
    POP     HL
RET

DEAL_WITH_PLAYFIELD:
    DEC     A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_BE21
    ADD     HL, BC
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    LD      IX, PLAYFIELD_TABLE
    ADD     IX, BC
    LD      L, (IX+0)
    LD      H, (IX+1)
LOC_AE47:
    LD      A, (HL)
    CP      0FFH
    JR      Z, LOCRET_AE87
    CP      0FEH
    JR      NZ, LOC_AE5A
    INC     HL
    LD      C, (HL)
    INC     HL
    LD      B, 0
    EX      DE, HL
    ADD     HL, BC
    EX      DE, HL
    JR      LOC_AE47
LOC_AE5A:
    CP      0FDH
    JR      NZ, LOC_AE76
    INC     HL
    LD      B, (HL)
    INC     HL
LOOP_AE61:
    PUSH    BC
    PUSH    HL
    PUSH    DE
    LD      A, 2
    LD      IY, 1
    CALL    PUT_VRAM
    POP     DE
    POP     HL
    POP     BC
    INC     DE
    DJNZ    LOOP_AE61
    INC     HL
    JR      LOC_AE47
LOC_AE76:
    PUSH    HL
    PUSH    DE
    LD      IY, 1
    LD      A, 2
    CALL    PUT_VRAM
    POP     DE
    POP     HL
    INC     DE
    INC     HL
    JR      LOC_AE47
LOCRET_AE87:
RET

LOC_AE88:
    LD      IX, BYTE_AEAD
    LD      B, 5
LOOP_AE8E:
    PUSH    BC
    XOR     A
    EX      DE, HL
    LD      C, (IX+0)
    LD      B, (IX+1)
LOC_AE97:
    AND     A
    SBC     HL, BC
    JR      C, LOC_AE9F
    INC     A
    JR      LOC_AE97
LOC_AE9F:
    ADD     HL, BC
    EX      DE, HL
    ADD     A, 0D8H
    LD      (HL), A
    INC     HL
    INC     IX
    INC     IX
    POP     BC
    DJNZ    LOOP_AE8E
RET

BYTE_AEAD:
	DB 016,039,232,003,100,000,010,000,001,000

SUB_AEB7:
    LD      B, A
    LD      A, (BADGUY_BHVR_CNT_RAM)
    DEC     A
    JP      P, LOC_AEC1
    LD      A, 4FH
LOC_AEC1:
    LD      E, A
    LD      D, 0
    LD      HL, BADGUY_BEHAVIOR_RAM
    ADD     HL, DE
    LD      A, (HL)
    CP      B
    JR      Z, LOCRET_AEE0
    LD      A, (BADGUY_BHVR_CNT_RAM)
    LD      D, 0
    LD      E, A
    LD      HL, BADGUY_BEHAVIOR_RAM
    ADD     HL, DE
    LD      (HL), B
    INC     A
    CP      50H
    JR      C, LOC_AEDD
    XOR     A
LOC_AEDD:
    LD      (BADGUY_BHVR_CNT_RAM), A
LOCRET_AEE0:
RET

SUB_AEE1:
    PUSH    AF
    LD      H, 0
LOC_AEE4:
    LD      A, D
    CP      1
    LD      A, C
    JR      NZ, LOC_AEF1
    ADD     A, 0CH
    JP      C, LOC_AFF5
    JR      LOC_AEF6
LOC_AEF1:
    SUB     0CH
    JP      C, LOC_AFF5
LOC_AEF6:
    LD      C, A
    LD      E, 5
    LD      IX, $722C
LOC_AEFD:
    BIT     7, (IX+0)
    JR      Z, LOC_AF1A
    LD      A, (IX+2)
    CP      C
    JR      NZ, LOC_AF1A
    LD      A, (IX+1)
    CP      B
    JR      Z, LOC_AF26
    SUB     10H
    CP      B
    JR      NC, LOC_AF1A
    ADD     A, 1FH
    CP      B
    JP      NC, LOC_B061
LOC_AF1A:
    PUSH    DE
    LD      DE, 5
    ADD     IX, DE
    POP     DE
    DEC     E
    JR      NZ, LOC_AEFD
    JR      LOC_AF76
LOC_AF26:
    LD      A, (IX+0)
    AND     78H
    JP      NZ, LOC_AFD2
    INC     H
    POP     AF
    PUSH    AF
    CP      2
    JP      Z, LOC_AEE4
    CP      3
    JR      NZ, LOC_AEE4
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A, C
    BIT     0, D
    JR      Z, LOC_AF48
    ADD     A, 6
    JR      LOC_AF4A
LOC_AF48:
    SUB     6
LOC_AF4A:
    LD      C, A
    CALL    SUB_AC3F
    LD      A, C
    AND     0FH
    CP      8
    LD      A, (IX+0)
    JR      NC, LOC_AF60
    AND     5
    CP      5
    JR      NZ, LOC_AF6E
    JR      LOC_AF66
LOC_AF60:
    AND     0AH
    CP      0AH
    JR      NZ, LOC_AF6E
LOC_AF66:
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    JP      LOC_AEE4
LOC_AF6E:
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    JP      LOC_B061
LOC_AF76:
    LD      E, 0
    LD      A, H
    AND     A
    JP      Z, LOC_B063
    POP     AF
    PUSH    AF
    CP      1
    JR      NZ, LOC_AFD7
    PUSH    DE
    PUSH    HL
    LD      IX, $728E
    LD      L, 7
LOC_AF8B:
    BIT     7, (IX+4)
    JR      Z, LOC_AFBF
    BIT     6, (IX+4)
    JR      NZ, LOC_AFBF
    LD      A, ($7272)
    BIT     4, A
    JR      NZ, LOC_AFA5
    LD      A, (IX+0)
    AND     30H
    JR      Z, LOC_AFBF
LOC_AFA5:
    LD      A, (IX+2)
    SUB     0CH
    CP      B
    JR      NC, LOC_AFBF
    ADD     A, 18H
    CP      B
    JR      C, LOC_AFBF
    LD      A, (IX+1)
    SUB     4
    CP      C
    JR      NC, LOC_AFBF
    ADD     A, 8
    CP      C
    JR      NC, LOC_AFD0
LOC_AFBF:
    LD      DE, 6
    ADD     IX, DE
    DEC     L
    JR      NZ, LOC_AF8B
    POP     HL
    POP     DE
    CALL    SUB_B066
    JR      NZ, LOC_AFD2
    JR      LOC_AFF6
LOC_AFD0:
    POP     HL
    POP     DE
LOC_AFD2:
    LD      E, 3
    JP      LOC_B063
LOC_AFD7:
    LD      A, ($7284)
    SUB     0CH
    CP      B
    JR      NC, LOC_AFF6
    ADD     A, 18H
    CP      B
    JR      C, LOC_AFF6
    LD      A, ($7285)
    SUB     4
    CP      C
    JR      NC, LOC_AFF6
    ADD     A, 8
    CP      C
    JR      C, LOC_AFF6
    LD      E, 3
    JR      LOC_B063
LOC_AFF5:
    LD      C, A
LOC_AFF6:
    LD      E, 0
    LD      A, H
    AND     A
    JR      Z, LOC_B063
LOC_AFFC:
    LD      A, D
    CP      1
    LD      A, C
    JR      NZ, LOC_B006
    SUB     0CH
    JR      LOC_B008
LOC_B006:
    ADD     A, 0CH
LOC_B008:
    LD      C, A
    LD      IX, $722C
    LD      E, 5
LOC_B00F:
    BIT     7, (IX+0)
    JR      Z, LOC_B050
    LD      A, (IX+1)
    CP      B
    JR      NZ, LOC_B050
    LD      A, (IX+2)
    CP      C
    JR      NZ, LOC_B050
    LD      A, D
    CP      1
    LD      A, C
    JR      NZ, LOC_B02F
    ADD     A, 4
    CP      0E9H
    JR      NC, LOC_B061
    JR      LOC_B035
LOC_B02F:
    SUB     4
    CP      18H
    JR      C, LOC_B061
LOC_B035:
    LD      (IX+2), A
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      C, A
    LD      B, (IX+1)
    LD      A, 11H
    SUB     E
    LD      D, 1
    CALL    SUB_B629
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    JR      LOC_B05A
LOC_B050:
    PUSH    DE
    LD      DE, 5
    ADD     IX, DE
    POP     DE
    DEC     E
    JR      NZ, LOC_B00F
LOC_B05A:
    DEC     H
    JR      NZ, LOC_AFFC
    LD      E, 1
    JR      LOC_B063
LOC_B061:
    LD      E, 2
LOC_B063:
    POP     AF
    LD      A, E
RET

SUB_B066:
    PUSH    IY
    PUSH    HL
    LD      IY, $728E
    LD      HL, 207H
LOC_B070:
    LD      A, (IY+4)
    BIT     7, A
    JP      Z, LOC_B105
    BIT     6, A
    JP      NZ, LOC_B105
    LD      A, (IY+0)
    AND     30H
    JP      NZ, LOC_B105
LOC_B085:
    LD      A, (IY+2)
    SUB     B
    JR      NC, LOC_B08D
    CPL
    INC     A
LOC_B08D:
    CP      10H
    JR      NC, LOC_B105
    LD      A, (IY+1)
    BIT     0, D
    JR      NZ, LOC_B0B7
    CP      C
    JR      C, LOC_B105
    SUB     9
    CP      C
    JR      NC, LOC_B105
    PUSH    BC
    PUSH    DE
    PUSH    HL
    CALL    SUB_9F29
    POP     HL
    POP     DE
    POP     BC
    BIT     7, A
    JR      Z, LOC_B0D8
    LD      A, (IY+1)
    SUB     4
    LD      (IY+1), A
    JR      LOC_B085
LOC_B0B7:
    CP      C
    JR      Z, LOC_B0BC
    JR      NC, LOC_B105
LOC_B0BC:
    ADD     A, 9
    CP      C
    JR      C, LOC_B105
    PUSH    BC
    PUSH    DE
    PUSH    HL
    CALL    SUB_9F29
    POP     HL
    POP     DE
    POP     BC
    BIT     6, A
    JR      Z, LOC_B0D8
    LD      A, (IY+1)
    ADD     A, 4
    LD      (IY+1), A
    JR      LOC_B085
LOC_B0D8:
    PUSH    AF
    LD      A, (IY+2)
    CP      B
    JR      C, LOC_B0F8
    POP     AF
    BIT     5, A
    JR      Z, LOC_B0EE
    LD      A, (IY+2)
    ADD     A, 4
    LD      (IY+2), A
    JR      LOC_B105
LOC_B0EE:
    PUSH    AF
    LD      A, (IY+2)
    CP      B
    JR      Z, LOC_B0F8
    POP     AF
    JR      LOC_B126
LOC_B0F8:
    POP     AF
    BIT     4, A
    JR      Z, LOC_B126
    LD      A, (IY+2)
    SUB     4
    LD      (IY+2), A
LOC_B105:
    PUSH    DE
    LD      DE, 6
    ADD     IY, DE
    POP     DE
    DEC     L
    JP      NZ, LOC_B070
    DEC     H
    JR      Z, LOC_B123
    LD      A, ($72BA)
    BIT     6, A
    JR      Z, LOC_B123
    LD      IY, $72BD
    LD      L, 1
    JP      LOC_B085
LOC_B123:
    XOR     A
    JR      LOC_B128
LOC_B126:
    LD      A, 1
LOC_B128:
    POP     HL
    POP     IY
    AND     A
RET

SUB_B12D:
    LD      IX, $722C
    LD      E, 5
LOC_B133:
    BIT     7, (IX+0)
    JR      Z, LOC_B163
    LD      A, B
    BIT     1, D
    JR      Z, LOC_B149
    SUB     (IX+1)
    JR      C, LOC_B163
    CP      0DH
    JR      NC, LOC_B163
    JR      LOC_B156
LOC_B149:
    SUB     (IX+1)
    JR      Z, LOC_B156
    JR      NC, LOC_B163
    CPL
    INC     A
    CP      0DH
    JR      NC, LOC_B163
LOC_B156:
    LD      A, (IX+2)
    ADD     A, 9
    CP      C
    JR      C, LOC_B163
    SUB     12H
    CP      C
    JR      C, LOC_B170
LOC_B163:
    EX      DE, HL
    LD      DE, 5
    ADD     IX, DE
    EX      DE, HL
    DEC     E
    JR      NZ, LOC_B133
    XOR     A
    JR      LOCRET_B172
LOC_B170:
    LD      A, 1
LOCRET_B172:
RET

SUB_B173:
    LD      A, D
    PUSH    AF
    LD      HL, $7245
    CALL    SUB_AC0B
    JR      Z, LOC_B198
    POP     AF
    PUSH    AF
    DEC     A
    LD      C, A
    LD      B, 0
    LD      HL, $718A
    ADD     HL, BC
    LD      A, (HL)
    AND     0FH
    CP      0FH
    JR      NZ, LOC_B198
    POP     AF
    LD      HL, $7245
    CALL    SUB_ABF6
	SCF
    JR      LOCRET_B19A
LOC_B198:
    POP     AF
    AND     A
LOCRET_B19A:
RET

DISPLAY_PLAY_FIELD_PARTS:
    PUSH    AF
    CP      48H
    JP      Z, LOC_B24E
    DEC     A
    LD      C, A
    LD      B, 0
    LD      IY, $718A
    ADD     IY, BC
    POP     AF
    PUSH    AF
    CALL    SUB_B591
    LD      IX, TUNNEL_WALL_PATTERNS
    LD      BC, 3
DISPLAY_CHERRIES:
    LD      A, (IX+0)
    AND     (IY+0)
    JR      NZ, DISPLAY_TUNNELS
    POP     AF
    PUSH    AF
    PUSH    DE
    PUSH    IX
    PUSH    BC
    LD      HL, $7245
    CALL    SUB_AC0B
    POP     BC
    POP     IX
    POP     DE
    JR      Z, DISPLAY_PLAYFIELD
    LD      HL, CHERRIES_TXT
    ADD     HL, BC
    JR      PLAYFIELD_TO_VRAM
DISPLAY_PLAYFIELD:
    PUSH    BC
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_B1E6
    LD      A, ($7275)
LOC_B1E6:
    CP      0BH
    JR      C, LOC_B1EE
    SUB     0AH
    JR      LOC_B1E6
LOC_B1EE:
    DEC     A
    LD      C, A
    LD      B, 0
    LD      HL, PLAYFIELD_PATTERNS
    ADD     HL, BC
    POP     BC
    JR      PLAYFIELD_TO_VRAM
DISPLAY_TUNNELS:
    LD      HL, TUNNEL_PATTERNS
    LD      A, (IY+0)
    AND     (IX+1)
    JR      Z, LOC_B20A
    PUSH    BC
    LD      BC, 8
    ADD     HL, BC
    POP     BC
LOC_B20A:
    LD      A, (IY+0)
    AND     (IX+2)
    JR      Z, LOC_B216
    INC     HL
    INC     HL
    INC     HL
    INC     HL
LOC_B216:
    LD      A, (IY+0)
    AND     (IX+3)
    JR      Z, LOC_B220
    INC     HL
    INC     HL
LOC_B220:
    LD      A, (IY+0)
    AND     (IX+4)
    JR      Z, PLAYFIELD_TO_VRAM
    INC     HL
PLAYFIELD_TO_VRAM:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    PUSH    IY
    LD      IY, 1
    LD      A, 2
    CALL    PUT_VRAM
    POP     IY
    POP     IX
    POP     DE
    LD      L, (IX+5)
    LD      H, 0
    ADD     HL, DE
    EX      DE, HL
    LD      BC, 6
    ADD     IX, BC
    POP     BC
    DEC     C
    JP      P, DISPLAY_CHERRIES
LOC_B24E:
    POP     AF
RET

TUNNEL_WALL_PATTERNS:
	DB 001,016,004,002,128,001,002,016,008,064,001,031,004,001,032,008,128,001,008,002,032,064,004,000
TUNNEL_PATTERNS:
	DB 000,000,000,000,000,093,092,090,000,095,094,091,000,089,088,000
CHERRIES_TXT:
	DB 017,016,009,008
PLAYFIELD_PATTERNS:
	DB 080,081,082,080,083,082,084,080,082,083

SUB_B286:
    CP      0BH
    JR      C, LOC_B28E
    SUB     0AH
    JR      SUB_B286
LOC_B28E:
    PUSH    AF
    LD      HL, $718A
    LD      (HL), 0
    LD      DE, $718B
    LD      BC, 9FH
    LDIR
    LD      HL, $718A
    CALL    DEAL_WITH_PLAYFIELD_MAP
    POP     AF
    DEC     A
    ADD     A, A
    LD      C, A
    LD      B, 0
    PUSH    BC
    LD      IX, CHERRY_PLACEMENT_TABLE
    ADD     IX, BC
    LD      L, (IX+0)
    LD      H, (IX+1)
    LD      DE, $7245
    LD      BC, 14H
    LDIR
    CALL    RAND_GEN
    LD      IX, EXTRA_BEHAVIOR
    BIT     0, A
    JR      Z, LOC_B2CC
    LD      IX, APPLE_PLACEMENT_TABLE
LOC_B2CC:
    POP     BC
    ADD     IX, BC
    LD      L, (IX+0)
    LD      H, (IX+1)
    LD      B, 5
    LD      IY, $722C
LOOP_B2DB:
    LD      A, (HL)
    PUSH    HL
    PUSH    BC
    CALL    SUB_ABB7
    LD      (IY+0), 80H
    LD      (IY+1), B
    LD      (IY+2), C
    LD      (IY+3), 0
    LD      DE, 5
    ADD     IY, DE
    POP     BC
    POP     HL
    INC     HL
    DJNZ    LOOP_B2DB
RET

SUB_B2FA:
    PUSH    IY
    PUSH    HL
    CALL    SUB_AC3F
    LD      D, A
    LD      E, 0
    LD      A, C
    AND     0FH
    CP      8
    JR      NZ, LOC_B32C
    LD      A, (IX+0)
    AND     0AH
    CP      0AH
    JR      Z, LOC_B31D
    LD      E, 1
    SET     1, (IX+0)
    SET     3, (IX+0)
LOC_B31D:
    PUSH    IX
    PUSH    DE
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B399
LOC_B32C:
    AND     A
    JR      NZ, LOC_B370
    LD      A, (IX+0)
    AND     85H
    CP      85H
    JR      Z, LOC_B342
    LD      E, 1
    LD      A, (IX+0)
    OR      85H
    LD      (IX+0), A
LOC_B342:
    PUSH    DE
    PUSH    IX
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    DEC     IX
    DEC     D
    BIT     6, (IX+0)
    JR      NZ, LOC_B360
    POP     DE
    LD      E, 1
    PUSH    DE
    DEC     D
LOC_B360:
    SET     6, (IX+0)
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B399
LOC_B370:
    POP     IY
    PUSH    IY
    CP      4
    JR      Z, LOC_B38B
    INC     IX
    LD      C, 80H
    LD      A, (IX+0)
    DEC     IX
    AND     5
    CP      5
    JR      Z, LOC_B399
    LD      B, D
    INC     B
    JR      LOC_B397
LOC_B38B:
    LD      C, 84H
    LD      A, (IX+0)
    AND     0AH
    CP      0AH
    JR      Z, LOC_B399
    LD      B, D
LOC_B397:
    LD      E, 1
LOC_B399:
    POP     HL
    POP     IY
RET

SUB_B39D:
    PUSH    IY
    PUSH    HL
    CALL    SUB_AC3F
    LD      D, A
    LD      E, 0
    LD      A, C
    AND     0FH
    JR      NZ, LOC_B3EC
    BIT     7, (IX+0)
    JR      NZ, LOC_B3B7
    LD      E, 1
    SET     7, (IX+0)
LOC_B3B7:
    PUSH    DE
    PUSH    IX
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    DEC     IX
    DEC     D
    LD      A, (IX+0)
    AND     4AH
    CP      4AH
    JR      Z, LOC_B3E0
    POP     DE
    LD      E, 1
    PUSH    DE
    DEC     D
    LD      A, (IX+0)
    OR      4AH
    LD      (IX+0), A
LOC_B3E0:
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B43B
LOC_B3EC:
    CP      8
    JR      NZ, LOC_B412
    LD      A, (IX+0)
    AND     5
    CP      5
    JR      Z, LOC_B403
    LD      E, 1
    SET     0, (IX+0)
    SET     2, (IX+0)
LOC_B403:
    LD      A, D
    LD      HL, $7259
    PUSH    IX
    PUSH    DE
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B43B
LOC_B412:
    POP     IY
    PUSH    IY
    CP      4
    JR      NZ, LOC_B428
    LD      C, 85H
    LD      A, (IX+0)
    AND     5
    CP      5
    JR      Z, LOC_B43B
    LD      B, D
    JR      LOC_B439
LOC_B428:
    LD      C, 81H
    DEC     IX
    LD      A, (IX+0)
    INC     IX
    AND     0AH
    CP      0AH
    JR      Z, LOC_B43B
    LD      B, D
    DEC     B
LOC_B439:
    LD      E, 1
LOC_B43B:
    POP     HL
    POP     IY
RET

SUB_B43F:
    PUSH    IY
    PUSH    HL
    CALL    SUB_AC3F
    LD      D, A
    LD      E, 0
    LD      A, B
    AND     0FH
    CP      8
    JR      NZ, LOC_B493
    BIT     4, (IX+0)
    JR      NZ, LOC_B45B
    LD      E, 1
    SET     4, (IX+0)
LOC_B45B:
    PUSH    DE
    PUSH    IX
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    LD      BC, 0FFF0H
    ADD     IX, BC
    LD      A, (IX+0)
    AND     2CH
    CP      2CH
    JR      Z, LOC_B485
    POP     DE
    LD      E, 1
    PUSH    DE
    LD      A, (IX+0)
    OR      2CH
    LD      (IX+0), A
LOC_B485:
    LD      A, D
    SUB     10H
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B4E5
LOC_B493:
    AND     A
    JR      NZ, LOC_B4B8
    LD      A, (IX+0)
    AND     3
    CP      3
    JR      Z, LOC_B4A9
    LD      E, 1
    SET     0, (IX+0)
    SET     1, (IX+0)
LOC_B4A9:
    PUSH    IX
    PUSH    DE
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B4E5
LOC_B4B8:
    CP      4
    JR      NZ, LOC_B4CA
    LD      A, (IX+0)
    AND     3
    CP      3
    JR      Z, LOC_B4E5
    LD      B, D
    LD      C, 82H
    JR      LOC_B4E3
LOC_B4CA:
    LD      BC, 0FFF0H
    ADD     IX, BC
    LD      A, (IX+0)
    LD      BC, 10H
    ADD     IX, BC
    AND     0CH
    CP      0CH
    JR      Z, LOC_B4E5
    LD      A, D
    SUB     10H
    LD      B, A
    LD      C, 86H
LOC_B4E3:
    LD      E, 1
LOC_B4E5:
    POP     HL
    POP     IY
RET

SUB_B4E9:
    PUSH    IY
    PUSH    HL
    CALL    SUB_AC3F
    LD      D, A
    LD      A, B
    AND     0FH
    CP      8
    JR      NZ, LOC_B53B
    LD      A, (IX+0)
    AND     13H
    CP      13H
    JR      Z, LOC_B50A
    LD      E, 1
    LD      A, (IX+0)
    OR      13H
    LD      (IX+0), A
LOC_B50A:
    PUSH    DE
    PUSH    IX
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    LD      BC, 0FFF0H
    ADD     IX, BC
    BIT     5, (IX+0)
    JR      NZ, LOC_B52D
    POP     DE
    LD      E, 1
    PUSH    DE
    SET     5, (IX+0)
LOC_B52D:
    LD      A, D
    SUB     10H
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B58D
LOC_B53B:
    AND     A
    JR      NZ, LOC_B560
    LD      A, (IX+0)
    AND     0CH
    CP      0CH
    JR      Z, LOC_B551
    LD      E, 1
    SET     2, (IX+0)
    SET     3, (IX+0)
LOC_B551:
    PUSH    IX
    PUSH    DE
    LD      A, D
    LD      HL, $7259
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B58D
LOC_B560:
    CP      4
    JR      NZ, LOC_B57F
    LD      BC, 10H
    ADD     IX, BC
    LD      A, (IX+0)
    LD      BC, 0FFF0H
    ADD     IX, BC
    AND     0CH
    CP      0CH
    JR      Z, LOC_B58D
    LD      A, D
    ADD     A, 10H
    LD      B, A
    LD      C, 87H
    JR      LOC_B58B
LOC_B57F:
    LD      A, (IX+0)
    AND     3
    CP      3
    JR      Z, LOC_B58D
    LD      B, D
    LD      C, 83H
LOC_B58B:
    LD      E, 1
LOC_B58D:
    POP     HL
    POP     IY
RET

SUB_B591:
    LD      HL, 60H
    LD      DE, 40H
    DEC     A
LOC_B598:
    CP      10H
    JR      C, LOC_B5A1
    ADD     HL, DE
    SUB     10H
    JR      LOC_B598
LOC_B5A1:
    ADD     A, A
    LD      E, A
    ADD     HL, DE
    EX      DE, HL
RET

PATTERNS_TO_VRAM:
    ADD     A, A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_B5D4
    ADD     HL, BC
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    INC     HL
    PUSH    HL
    EX      DE, HL
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    LD      HL, $72E7
    CALL    LOC_AE88
    LD      A, 0D8H
    LD      ($72EC), A
    LD      A, 2
    POP     HL
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    LD      HL, $72E7
    LD      IY, 6
    CALL    PUT_VRAM
RET

BYTE_B5D4:
	DB 125,114,036,000,127,114,068,000,000

SUB_B5DD:
    LD      A, B
    SUB     7
    CP      (IY+1)
    JR      NC, LOC_B5FF
    ADD     A, 0EH
    CP      (IY+1)
    JR      C, LOC_B5FF
    LD      A, C
    SUB     7
    CP      (IY+2)
    JR      NC, LOC_B5FF
    ADD     A, 0EH
    CP      (IY+2)
    JR      C, LOC_B5FF
    LD      A, 1
    JR      LOCRET_B600
LOC_B5FF:
    XOR     A
LOCRET_B600:
RET

SUB_B601:
    LD      IX, SCORE_P1_RAM
    LD      C, 80H
    LD      A, ($726E)
    BIT     1, A
    JR      Z, LOC_B614
    LD      IX, SCORE_P2_RAM
    LD      C, 40H
LOC_B614:
    LD      L, (IX+0)
    LD      H, (IX+1)
    ADD     HL, DE
    LD      (IX+0), L
    LD      (IX+1), H
    LD      A, ($727C)
    OR      C
    LD      ($727C), A

RET

SUB_B629:
    LD      IX, $72DF
    BIT     7, A
    JR      Z, LOC_B637
    LD      IX, $72E7
    AND     7FH
LOC_B637:
    PUSH    AF
    PUSH    DE
    ADD     A, A
    LD      E, A
    LD      D, 0
    LD      HL, OFF_B691
    ADD     HL, DE
    LD      E, (HL)
    INC     HL
    LD      D, (HL)
    EX      DE, HL
    POP     DE
    LD      A, D
    ADD     A, A
    LD      E, A
    LD      D, 0
    ADD     HL, DE
    LD      A, B
    SUB     8
    JR      NC, LOC_B655
    LD      E, 1
    ADD     A, 8
LOC_B655:
    LD      (IX+0), A
    LD      A, C
    SUB     8
    LD      (IX+1), A
    LD      A, (HL)
    LD      (IX+2), A
    INC     HL
    LD      A, (HL)
    BIT     0, E
    JR      Z, LOC_B66A
    SET     7, A
LOC_B66A:
    LD      (IX+3), A
    LD      A, ($726E)
    SET     3, A
    LD      ($726E), A
    POP     AF
    ADD     A, A
    ADD     A, A
    LD      E, A
    LD      D, 0
    LD      HL, SPRITE_NAME_TABLE
    ADD     HL, DE
    EX      DE, HL
    PUSH    IX
    POP     HL
    LD      BC, 4
    LDIR
    LD      A, ($726E)
    RES     3, A
    LD      ($726E), A
RET

OFF_B691:
	DW BYTE_B6C3
    DW BYTE_B6C7
    DW BYTE_B6CB
    DW BYTE_B6CF
    DW BYTE_B6FB
    DW BYTE_B70B
    DW BYTE_B70B
    DW BYTE_B70B
    DW BYTE_B70B
    DW BYTE_B70B
    DW BYTE_B70B
    DW BYTE_B70B
    DW BYTE_B757
    DW BYTE_B757
    DW BYTE_B757
    DW BYTE_B757
    DW BYTE_B757
    DW BYTE_B761
    DW BYTE_B761
    DW BYTE_B761
    DB 000,000,000,000,000,000,000,000,000,000
BYTE_B6C3:
	DB 000,000,184,010
BYTE_B6C7:
	DB 176,015,148,015
BYTE_B6CB:
	DB 180,003,160,003
BYTE_B6CF:
	DB 000,000,096,011,100,011,104,011,108,011,112,011,116,011,120,011,124,011,128,011,132,011
    DB 148,011,096,008,100,008,104,008,108,008,112,008,116,008,120,008,124,008,128,008,132,008
BYTE_B6FB:
	DB 000,000,156,010,192,010,196,010,200,010,204,010,208,010,212,010
BYTE_B70B:
	DB 000,000,000,013,004,013,008,013,012,013,016,013,020,013,024,013,028,013,032,013,036,013,040,013,044,013
    DB 000,007,004,007,008,007,012,007,016,007,020,007,024,007,028,007,032,007,036,007,040,007,044,007,048,015
    DB 052,015,056,015,060,015,064,015,068,015,072,015,076,015,080,015,084,015,088,015,092,015,148,013
BYTE_B757:
	DB 000,000,136,008,140,008,144,008,152,015
BYTE_B761:
	DB 000,000,224,005,228,005,232,005,236,005,148,005

SUB_B76D:
    LD      A, 40H
    LD      ($72BD), A
    LD      HL, $72C4
    BIT     0, (HL)
    JR      Z, LOC_B781
    RES     0, (HL)
    LD      A, (SCORE_P1_RAM)
    CALL    FREE_SIGNAL
LOC_B781:
    CALL    SUB_CA24
    LD      A, 1
    LD      ($72C2), A
    LD      A, ($72BA)
    RES     6, A
    RES     5, A
    LD      ($72BA), A
    AND     7
    LD      C, A
    LD      B, 0
    LD      HL, BYTE_B7BC
    ADD     HL, BC
    LD      B, (HL)
    LD      HL, $72B8
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_B7AA
    INC     HL
LOC_B7AA:
    LD      C, 0
    LD      A, (HL)
    OR      B
    LD      (HL), A
    CP      1FH
    JR      NZ, LOC_B7B4
    INC     C
LOC_B7B4:
    LD      A, C
    PUSH    AF
    CALL    SUB_B809
    POP     AF
    AND     A
RET

BYTE_B7BC:
	DB 001,002,004,008,016,008,004,002

SUB_B7C4:
    PUSH    HL
    PUSH    IX
    LD      A, 0C0H
    LD      (IX+4), A
    LD      A, 8
    LD      B, A
    LD      C, A
    CALL    SUB_B7EF
    ADD     A, 5
    LD      D, 0
    CALL    SUB_B629
    LD      HL, $7278
    LD      A, ($726E)
    AND     3
    CP      3
    JR      NZ, LOC_B7E7
    INC     HL
LOC_B7E7:
    LD      A, (HL)
    DEC     A
    LD      (HL), A
    POP     IX
    POP     HL
    AND     A
RET

SUB_B7EF:
    PUSH    DE
    PUSH    HL
    PUSH    IX
    POP     HL
    LD      DE, $728E
    AND     A
    SBC     HL, DE
    LD      A, L
    LD      H, 0
    AND     A
    JR      Z, LOC_B805
LOC_B800:
    INC     H
    SUB     6
    JR      NZ, LOC_B800
LOC_B805:
    LD      A, H
    POP     HL
    POP     DE
RET

SUB_B809:
    LD      IX, $72C7
    LD      B, 3
LOC_B80F:
    BIT     7, (IX+4)
    JR      Z, LOC_B82A
    BIT     7, (IX+0)
    JR      NZ, LOC_B82A
    PUSH    BC
    CALL    SUB_B832
    PUSH    IX
    LD      DE, 32H
    CALL    SUB_B601
    POP     IX
    POP     BC
LOC_B82A:
    LD      DE, 6
    ADD     IX, DE
    DJNZ    LOC_B80F
RET

SUB_B832:
    PUSH    IY
    PUSH    IX
    LD      (IX+4), 0
    LD      A, (IX+3)
    CALL    FREE_SIGNAL
    LD      BC, $72C7
    LD      D, 11H
    AND     A
    PUSH    IX
    POP     HL
    SBC     HL, BC
    JR      Z, LOC_B856
    LD      BC, 6
LOC_B850:
    INC     D
    AND     A
    SBC     HL, BC
    JR      NZ, LOC_B850
LOC_B856:
    LD      BC, 808H
    LD      A, D
    LD      D, 0
    CALL    SUB_B629
    LD      IX, $72C7
    LD      B, 3
LOC_B865:
    BIT     7, (IX+4)
    JR      NZ, LOC_B89E
    LD      DE, 6
    ADD     IX, DE
    DJNZ    LOC_B865
    JP      LOC_D345
LOC_B875:
    RES     4, (HL)
    LD      A, ($72C3)
    BIT     0, A
    JR      NZ, LOC_B884
    LD      A, ($72C6)
    CALL    FREE_SIGNAL
LOC_B884:
    XOR     A
    LD      ($72C3), A
    LD      A, ($72BA)
    BIT     6, A
    JR      Z, LOC_B89B
    LD      HL, $72C4
    JP      LOC_D300
LOC_B895:
    CALL    REQUEST_SIGNAL
    JP      LOC_D35D
LOC_B89B:
    NOP
    NOP
    NOP
LOC_B89E:
    POP     IX
    POP     IY
RET

SUB_B8A3:
    PUSH    IX
    PUSH    HL
    PUSH    DE
    PUSH    BC
    JP      LOC_D326

LOC_B8AB:
    LD      IX, $72C7
    LD      B, 3
LOC_B8B1:
    LD      (IX+0), 10H
    LD      A, ($72BF)
    LD      (IX+2), A
    LD      A, ($72BE)
    LD      (IX+1), A
    LD      A, ($72C1)
    AND     7
    OR      80H
    LD      (IX+4), A
    LD      (IX+5), 0
    PUSH    BC
    XOR     A
    LD      HL, 1
    CALL    REQUEST_SIGNAL
    LD      (IX+3), A
    POP     BC
    LD      DE, 6
    ADD     IX, DE
    DJNZ    LOC_B8B1
    XOR     A
    LD      HL, 78H
    CALL    REQUEST_SIGNAL
    JP      LOC_D36D
LOC_B8EC:
    LD      A, 80H
    LD      ($72C3), A
    POP     BC
    POP     DE
    POP     HL
    POP     IX
RET

SUB_B8F7:
    PUSH    IY
    LD      HL, $726E
    SET     7, (HL)
LOC_B8FE:
    BIT     7, (HL)
    JR      NZ, LOC_B8FE
    LD      HL, PLAYFIELD_COLOR_FLASH_EXTRA
    LD      DE, 0
    LD      IY, 0CH
    LD      A, 4
    CALL    PUT_VRAM
    LD      HL, 0
LOC_B914:
    DEC     HL
    LD      A, L
    OR      H
    JR      NZ, LOC_B914
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, LOC_B926
    LD      A, ($7275)
LOC_B926:
    CP      0BH
    JR      C, LOC_B92E
    SUB     0AH
    JR      LOC_B926
LOC_B92E:
    DEC     A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      IY, PLAYFIELD_COLORS
    ADD     IY, BC
    LD      L, (IY+0)
    LD      H, (IY+1)
    LD      DE, 0
    LD      IY, 0CH
    LD      A, 4
    CALL    PUT_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    POP     IY
RET
PLAYFIELD_COLOR_FLASH_EXTRA:
    DB 000,025,137,144,128,240,240,160,160,128,153,144,000

EXTRA_BEHAVIOR:
	DW PHASE_01_EX
    DW PHASE_02_EX
    DW PHASE_03_EX
    DW PHASE_04_EX
    DW PHASE_05_EX
    DW PHASE_06_EX
    DW PHASE_07_EX
    DW PHASE_08_EX
    DW PHASE_09_EX
    DW PHASE_10_EX
PHASE_01_EX:
    DB 004,023,052,061,075,106
PHASE_02_EX:
    DB 022,026,029,036,042,104
PHASE_03_EX:
    DB 021,025,035,070,105,108
PHASE_04_EX:
    DB 003,028,042,057,086,094
PHASE_05_EX:
    DB 019,026,028,040,086,091
PHASE_06_EX:
    DB 022,025,027,043,100,106
PHASE_07_EX:
    DB 020,022,023,026,091,102
PHASE_08_EX:
    DB 027,035,038,059,103,109
PHASE_09_EX:
    DB 020,023,028,039,058,103
PHASE_10_EX:
    DB 025,027,036,076,083,105

APPLE_PLACEMENT_TABLE:
	DW APPLES_PHASE_01
    DW APPLES_PHASE_02
    DW APPLES_PHASE_03
    DW APPLES_PHASE_04
    DW APPLES_PHASE_05
    DW APPLES_PHASE_06
    DW APPLES_PHASE_07
    DW APPLES_PHASE_08
    DW APPLES_PHASE_09
    DW APPLES_PHASE_10
APPLES_PHASE_01:
    DB 027,036,039,068,076,077
APPLES_PHASE_02:
    DB 023,025,026,035,108,109
APPLES_PHASE_03:
    DB 023,026,045,052,069,106
APPLES_PHASE_04:
    DB 004,014,027,037,058,074
APPLES_PHASE_05:
    DB 020,024,029,085,089,107
APPLES_PHASE_06:
    DB 023,026,035,044,102,109
APPLES_PHASE_07:
    DB 019,025,027,037,101,108
APPLES_PHASE_08:
    DB 022,024,043,054,102,107
APPLES_PHASE_09:
    DB 023,028,036,045,055,106
APPLES_PHASE_10:
    DB 024,026,035,045,071,092

CHERRY_PLACEMENT_TABLE:
	DW CHERRIES_PHASE_01
    DW CHERRIES_PHASE_02
    DW CHERRIES_PHASE_03
    DW CHERRIES_PHASE_04
    DW CHERRIES_PHASE_05
    DW CHERRIES_PHASE_06
    DW CHERRIES_PHASE_07
    DW CHERRIES_PHASE_08
    DW CHERRIES_PHASE_09
    DW CHERRIES_PHASE_10
CHERRIES_PHASE_01:
    DB 108,000,108,000,108,240,108,240,000,000,120,048,120,048,000,048,000,048,000,000
CHERRIES_PHASE_02:
    DB 000,000,000,048,015,048,111,048,096,048,096,006,096,006,007,134,007,134,000,000
CHERRIES_PHASE_03:
    DB 000,000,000,048,015,048,111,048,096,048,102,000,102,000,006,120,006,120,000,000
CHERRIES_PHASE_04:
    DB 015,000,111,006,096,054,096,054,096,054,000,048,000,000,000,000,030,000,030,000
CHERRIES_PHASE_05:
    DB 000,000,000,000,030,060,030,060,000,000,048,024,051,216,051,216,048,024,000,000
CHERRIES_PHASE_06:
    DB 000,000,024,012,027,204,027,204,024,012,000,000,000,000,030,120,030,120,000,000
CHERRIES_PHASE_07:
    DB 000,000,000,000,051,192,051,192,048,000,048,012,000,108,060,108,060,108,000,096
CHERRIES_PHASE_08:
    DB 000,000,024,216,024,216,024,216,024,216,000,000,000,000,030,120,030,120,000,000
CHERRIES_PHASE_09:
    DB 000,000,013,224,013,224,012,060,012,060,096,000,096,000,096,240,096,240,000,000
CHERRIES_PHASE_10:
    DB 000,000,000,000,000,240,060,240,060,012,030,012,030,012,003,204,003,192,000,000

PLAYFIELD_MAP:
	DW PHASE_01_MAP
    DW PHASE_02_MAP
    DW PHASE_03_MAP
    DW PHASE_04_MAP
    DW PHASE_05_MAP
    DW PHASE_06_MAP
    DW PHASE_07_MAP
    DW PHASE_08_MAP
    DW PHASE_09_MAP
    DW PHASE_10_MAP
PHASE_01_MAP:
    DB 001,000,006,079,239,001,207,004,175,001,000,010,063,001,000,004,095,175,001,000,009,063,001,000,005,095,175,001,000,008,063,001,000,006,063
    DB 001,000,008,063,001,000,006,063,001,000,008,063,001,000,006,063,001,000,008,063,001,000,006,063,000,000,111,207,175,001,000,003,063,001,000
    DB 005,111,159,000,000,063,000,063,001,000,003,063,001,000,004,111,159,001,000,003,095,207,223,001,207,003,223,001,207,004,159,001,000,003,002
PHASE_02_MAP:
    DB 000,000,111,001,207,010,175,001,000,003,111,159,001,000,010,095,175,000,000,031,001,000,012,063,001,000
    DB 014,111,159,001,000,008,047,001,000,004,111,159,001,000,006,111,207,207,223,001,207,004,159,001,000,006
    DB 111,159,001,000,012,111,207,159,001,000,013,063,001,000,015,095,001,207,012,143,000,002
PHASE_03_MAP:
    DB 000,000,111,001,207,010,175,001,000,003,111,159,001,000,010,095,175,000,000,031,001,000,012,063,001,000,015,063,001,000
    DB 008,047,001,000,006,063,001,000,008,095,001,207,006,191,001,000,015,063,000,000,047,001,000,012,063,000,000,095,175,001
    DB 000,010,111,159,001,000,003,095,001,207,010,159,000,000,002
PHASE_04_MAP:
    DB 001,000,009,111,207,207,175,001,000,011,111,159,000,000,063,001,000,008,111,207,207,159,001,000,003,063,001,000,008,063
    DB 001,000,006,063,001,000,006,111,207,223,207,143,001,000,004,063,001,000,004,111,207,159,001,000,008,063,001,000,004,063
    DB 001,000,010,063,001,000,004,095,001,207,010,255,207,143,001,000,013,063,001,000,010,079,001,207,004,159,001,000,003,002
PHASE_05_MAP:
    DB 000,111,001,207,012,143,000,000,063,001,000,015,063,001,000,015,063,001,000,015,095,001,207,011,175,001,000,015,095,175
    DB 001,000,015,063,001,000,015,063,000,000,047,001,000,011,111,159,000,000,095,001,207,011,159,000,000,002
PHASE_06_MAP:
    DB 000,000,111,001,207,011,143,000,000,111,159,001,000,014,063,001,000,015,063,001,000,015,063,001,000,005,047,001,000,009
    DB 127,001,207,005,223,001,207,006,175,000,000,063,001,000,012,063,000,000,063,001,000,012,063,000,000,095,175,001,000,010
    DB 111,159,001,000,003,095,001,207,010,159,000,000,002
PHASE_07_MAP:
    DB 000,111,001,207,012,175,000,000,031,001,000,012,063,001,000,014,111,159,001,000,012,111,207,159,001,000,009,047,000,111
    DB 207,159,001,000,011,127,207,159,001,000,013,063,001,000,015,063,001,000,015,063,001,000,015,031,001,000,008,002
PHASE_08_MAP:
    DB 000,000,111,001,207,010,175,001,000,003,111,159,001,000,010,095,175,000,000,063,001,000,012,063,000,000,063,001,000,012,063
    DB 000,000,095,175,001,000,004,047,001,000,005,111,159,001,000,003,127,001,207,004,223,001,207,005,191,001,000,003,111,159,001
    DB 000,010,095,175,000,000,063,001,000,012,063,000,000,095,175,001,000,010,111,159,001,000,003,095,001,207,010,159,000,000,002
PHASE_09_MAP:
    DB 000,000,111,001,207,010,175,001,000,003,111,159,001,000,010,095,175,000,000,063,001,000,012,063,000,000,063,001,000,012
    DB 063,000,000,095,207,175,001,000,003,047,001,000,006,063,001,000,004,095,001,207,003,223,001,207,006,191,001,000,015,063
    DB 001,000,015,063,001,000,014,111,159,000,000,079,001,207,011,159,000,000,002
PHASE_10_MAP:
    DB 000,000,111,001,207,010,175,001,000,003,111,223,207,175,001,000,008,095,175,000,000,063,000,000,095,207,175,001,000,007
    DB 063,000,000,063,001,000,004,095,175,001,000,006,063,000,000,063,001,000,005,095,175,001,000,005,063,000,000,063,001,000
    DB 006,095,175,001,000,004,063,000,000,063,001,000,007,095,175,001,000,003,063,000,000,063,001,000,008,095,175,000,000,063
    DB 000,000,095,175,001,000,008,095,207,239,159,001,000,003,095,001,207,010,159,000,000,002,000

BYTE_BE21:
	DB 033,000,010,000,110,001,136,001,136,001,072,001,102,001,102,001,106,001,110,001,110,001,110,001,110,001,110,001,065,000,000,000,000,000,000,000,000,000,000,000

PLAYFIELD_TABLE:
	DW P1ST_PHASE_LEVEL_GEN
    DW EXTRA_BORDER_GEN
    DW BADGUY_OUTLINE_GEN
    DW GET_READY_P1_GEN
    DW GET_READY_P2_GEN
    DW WIN_EXTRA_GEN
    DW GAME_OVER_P1_GEN
    DW GAME_OVER_P2_GEN
    DW GAME_OVER_GEN
    DW SUNDAE_GEN
    DW WHEAT_SQUARE_GEN
    DW GUMDROP_GEN
    DW PIE_SLICE_GEN
    DW BLANK_SPACE_GEN
    DW P2ND_GEN
;    DB 000,000,000,000,000,000,000,000,000,000

P1ST_PHASE_LEVEL_GEN:
	DB 066,067,068,254,023,241,233,255
EXTRA_BORDER_GEN:
	DB 058,253,009,061,063,254,021,059,254,009,064,254,021,060,253,009,062,065,255
BADGUY_OUTLINE_GEN:
	DB 112,114,254,030,113,115,255
GET_READY_P1_GEN:
	DB 232,230,245,000,243,230,226,229,250,000,241,237,226,250,230,243,000,217,255
GET_READY_P2_GEN:
	DB 232,230,245,000,243,230,226,229,250,000,241,237,226,250,230,243,000,218,255
WIN_EXTRA_GEN:
	DB 228,240,239,232,243,226,245,246,237,226,245,234,240,239,244,000,253,001,255,254,076,250,240,246,000,248
	DB 234,239,000,226,239,000,230,249,245,243,226,000,238,243,253,001,254,000,229,240,000,253,001,255,255
GAME_OVER_P1_GEN:
	DB 253,020,000,254,012,000,232,226,238,230,000,240,247,230,243,000,241,237,226,250,230,243,000,217,000,254,012,253,020,000,255
GAME_OVER_P2_GEN:
	DB 253,020,000,254,012,000,232,226,238,230,000,240,247,230,243,000,241,237,226,250,230,243,000,218,000,254,012,253,020,000,255
GAME_OVER_GEN:
	DB 253,011,000,254,021,000,232,226,238,230,000,240,247,230,243,000,254,021,253,011,000,255
SUNDAE_GEN:
	DB 042,043,254,030,056,057,255
WHEAT_SQUARE_GEN:
	DB 032,033,254,030,034,035,255
GUMDROP_GEN:
	DB 024,025,254,030,026,027,255
PIE_SLICE_GEN:
	DB 044,045,254,030,036,037,255
BLANK_SPACE_GEN:
	DB 000,000,254,030,000,000,255
P2ND_GEN:
	DB 069,070,071,255

PLAYFIELD_COLORS:
	DW PHASE_01_COLORS
    DW PHASE_02_COLORS
    DW PHASE_03_COLORS
    DW PHASE_04_COLORS
    DW PHASE_05_COLORS
    DW PHASE_06_COLORS
    DW PHASE_07_COLORS
    DW PHASE_08_COLORS
    DW PHASE_09_COLORS
    DW PHASE_10_COLORS
PHASE_01_COLORS:
	DB 000,028,140,144,128,240,240,160,160,128,202,192,192,192,128,224,000,000,000,000,000,000,000,000,000,000,000,240,240,240,240,240
PHASE_02_COLORS:
	DB 000,020,132,144,128,240,240,160,160,128,069,064
PHASE_03_COLORS:
	DB 000,026,138,144,128,240,240,160,160,128,202,160
PHASE_04_COLORS:
	DB 000,029,141,144,128,240,240,160,160,128,209,208
PHASE_05_COLORS:
	DB 000,021,133,144,128,240,240,160,160,128,165,080
PHASE_06_COLORS:
	DB 000,027,139,144,128,240,240,160,160,128,155,176
PHASE_07_COLORS:
	DB 000,028,140,144,128,240,240,160,160,128,060,192
PHASE_08_COLORS:
	DB 000,023,135,144,128,240,240,160,160,128,116,112
PHASE_09_COLORS:
	DB 000,020,132,144,128,240,240,160,160,128,180,064
PHASE_10_COLORS:
	DB 000,028,140,144,128,240,240,160,160,128,220,192

BADGUY_BEHAVIOR:
	DW PHASE_01_BGB
    DW PHASE_02_BGB
    DW PHASE_03_BGB
    DW PHASE_04_BGB
    DW PHASE_05_BGB
    DW PHASE_06_BGB
    DW PHASE_07_BGB
    DW PHASE_08_BGB
    DW PHASE_09_BGB
    DW PHASE_10_BGB
PHASE_01_BGB:
	DB 006,072,088,104,120,136,152
PHASE_02_BGB:
	DB 018,072,088,087,086,085,101,100,116,115,114,130,146,147,148,149,150,151,152
PHASE_03_BGB:
	DB 020,072,088,089,090,091,092,093,094,095,111,127,143,142,158,157,156,155,154,153,152
PHASE_04_BGB:
	DB 028,072,071,070,069,068,084,083,082,098,114,115,116,117,118,119,120,121,122,123,124,125,141,157,156,155,154,153,152
PHASE_05_BGB:
	DB 020,072,073,074,075,076,077,078,094,095,111,127,143,142,158,157,156,155,154,153,152
PHASE_06_BGB:
	DB 020,072,088,089,090,091,092,093,094,095,111,127,143,142,158,157,156,155,154,153,152
PHASE_07_BGB:
	DB 006,072,088,104,120,136,152
PHASE_08_BGB:
	DB 020,072,088,089,090,091,092,093,094,110,111,127,143,142,158,157,156,155,154,153,152
PHASE_09_BGB:
	DB 020,072,088,089,090,091,092,093,094,095,111,127,143,142,158,157,156,155,154,153,152
PHASE_10_BGB:
	DB 018,072,073,089,090,106,107,123,124,140,141,142,158,157,156,155,154,153,152,000



SPRITE_GENERATOR:
	DB 000,000,000
    DW BADGUY_RIGHT_WALK_01_PAT
    DB 000,004,000
    DW BADGUY_RIGHT_WALK_02_PAT
    DB 001
    DW BYTE_C234
    DW BADGUY_RIGHT_WALK_01_PAT
    DB 001
    DW BYTE_C238
    DW BADGUY_RIGHT_WALK_02_PAT
    DB 002
    DW BYTE_C23C
    DW BADGUY_RIGHT_WALK_01_PAT
    DB 002
    DW BYTE_C240
    DW BADGUY_RIGHT_WALK_02_PAT
    DB 003
    DW BYTE_C244
    DW BADGUY_RIGHT_WALK_01_PAT
    DB 003
    DW BYTE_C248
    DW BADGUY_RIGHT_WALK_02_PAT
    DB 004
    DW BYTE_C24C
    DW BADGUY_RIGHT_WALK_01_PAT
    DB 004
    DW BYTE_C250
    DW BADGUY_RIGHT_WALK_02_PAT
    DB 005
    DW BYTE_C254
    DW BADGUY_RIGHT_WALK_01_PAT
    DB 005
    DW BYTE_C258
    DW BADGUY_RIGHT_WALK_02_PAT
    DB 000,048,000
    DW DIGGER_RIGHT_01_PAT
    DB 000,052,000
    DW DIGGER_RIGHT_02_PAT
    DB 001
    DW BYTE_C25C
    DW DIGGER_RIGHT_01_PAT
    DB 001
    DW BYTE_C260
    DW DIGGER_RIGHT_02_PAT
    DB 002
    DW BYTE_C264
    DW DIGGER_RIGHT_01_PAT
    DB 002
    DW BYTE_C268
    DW DIGGER_RIGHT_02_PAT
    DB 003
    DW BYTE_C26C
    DW DIGGER_RIGHT_01_PAT
    DB 003
    DW BYTE_C270
    DW DIGGER_RIGHT_02_PAT
    DB 004
    DW BYTE_C274
    DW DIGGER_RIGHT_01_PAT
    DB 004
    DW BYTE_C278
    DW DIGGER_RIGHT_02_PAT
    DB 005
    DW BYTE_C27C
    DW DIGGER_RIGHT_01_PAT
    DB 005
    DW BYTE_C280
    DW DIGGER_RIGHT_02_PAT
    DB 000,224,000
    DW CHOMPER_RIGHT_CLOSED_PAT
    DB 000,228,000
    DW CHOMPER_RIGHT_OPEN_PAT
    DB 001
    DW BYTE_C298
    DW CHOMPER_RIGHT_CLOSED_PAT
    DB 001
    DW BYTE_C29C
    DW CHOMPER_RIGHT_OPEN_PAT
    DB 000,176,000
    DW MR_DO_WALK_RIGHT_01_PAT
    DB 000,176,000
    DW MR_DO_WALK_RIGHT_02_PAT
    DB 000,176,000
    DW MR_DO_PUSH_RIGHT_01_PAT
    DB 000,176,000
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 000,176,000
    DW MR_DO_UNUSED_PUSH_ANIM_02_PAT
    DB 000,176,000
    DW MR_DO_UNUSED_PUSH_ANIM_03_PAT
    DB 000,176,000
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_WALK_RIGHT_01_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_WALK_RIGHT_02_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_PUSH_RIGHT_01_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_UNUSED_PUSH_ANIM_02_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_UNUSED_PUSH_ANIM_03_PAT
    DB 001
    DW BYTE_C284
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_WALK_RIGHT_01_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_WALK_RIGHT_02_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_PUSH_RIGHT_01_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_UNUSED_PUSH_ANIM_02_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_UNUSED_PUSH_ANIM_03_PAT
    DB 002
    DW BYTE_C288
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_WALK_RIGHT_01_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_WALK_RIGHT_02_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_PUSH_RIGHT_01_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_UNUSED_PUSH_ANIM_02_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_UNUSED_PUSH_ANIM_03_PAT
    DB 003
    DW BYTE_C28C
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_WALK_RIGHT_01_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_WALK_RIGHT_02_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_PUSH_RIGHT_01_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_UNUSED_PUSH_ANIM_02_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_UNUSED_PUSH_ANIM_03_PAT
    DB 004
    DW BYTE_C290
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_WALK_RIGHT_01_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_WALK_RIGHT_02_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_PUSH_RIGHT_01_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_PUSH_RIGHT_02_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_UNUSED_PUSH_ANIM_02_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_UNUSED_PUSH_ANIM_03_PAT
    DB 005
    DW BYTE_C294
    DW MR_DO_PUSH_RIGHT_02_PAT

BYTE_C234:      DB 010,011,008,009
BYTE_C238:      DB 014,015,012,013
BYTE_C23C:      DB 017,019,016,018
BYTE_C240:      DB 021,023,020,022
BYTE_C244:      DB 024,026,025,027
BYTE_C248:      DB 028,030,029,031
BYTE_C24C:      DB 035,033,034,032
BYTE_C250:      DB 039,037,038,036
BYTE_C254:      DB 042,040,043,041
BYTE_C258:      DB 046,044,047,045
BYTE_C25C:      DB 058,059,056,057
BYTE_C260:      DB 062,063,060,061
BYTE_C264:      DB 065,067,064,066
BYTE_C268:      DB 069,071,068,070
BYTE_C26C:      DB 072,074,073,075
BYTE_C270:      DB 076,078,077,079
BYTE_C274:      DB 083,081,082,080
BYTE_C278:      DB 087,085,086,084
BYTE_C27C:      DB 090,088,091,089
BYTE_C280:      DB 094,092,095,093
BYTE_C284:      DB 178,179,176,177
BYTE_C288:      DB 177,179,176,178
BYTE_C28C:      DB 176,178,177,179
BYTE_C290:      DB 179,177,178,176
BYTE_C294:      DB 178,176,179,177
BYTE_C298:      DB 234,235,232,233
BYTE_C29C:      DB 238,239,236,237

MR_DO_WALK_RIGHT_01_PAT:
	DB 000,000,031,063,039,003,001,001
    DB 003,007,007,003,005,006,000,000
    DB 000,000,224,224,240,216,216,240
    DB 192,248,248,192,224,248,000,000
MR_DO_WALK_RIGHT_02_PAT:
	DB 000,000,007,031,063,035,001,001
    DB 031,007,003,063,063,032,000,000
    DB 000,000,224,224,240,216,216,240
    DB 192,252,252,224,240,124,000,000
MR_DO_PUSH_RIGHT_01_PAT:
	DB 000,000,031,063,039,003,001,001
    DB 003,007,007,003,005,006,000,000
    DB 000,000,224,224,240,216,216,240
    DB 196,252,252,192,224,248,000,000
MR_DO_PUSH_RIGHT_02_PAT:
	DB 000,000,007,031,063,035,001,001
	DB 001,003,003,063,063,032,000,000
	DB 000,000,224,224,240,216,216,240
	DB 196,252,252,192,240,124,000,000

MR_DO_UNUSED_PUSH_ANIM_01_PAT:
	DB 000,000,003,007,009,013,007,003
    DB 007,014,031,031,018,031,000,000
    DB 000,000,192,224,144,176,224,200
    DB 248,056,192,192,000,128,000,000
MR_DO_UNUSED_PUSH_ANIM_02_PAT:
	DB 000,000,003,007,009,013,007,003
    DB 003,006,015,015,015,001,000,000
    DB 000,000,192,224,144,176,224,200
    DB 248,056,192,192,000,192,000,000
MR_DO_UNUSED_PUSH_ANIM_03_PAT:
	DB 000,000,003,007,009,013,007,003
    DB 007,014,031,031,019,028,000,000
    DB 000,000,192,224,144,176,224,200
    DB 248,056,128,128,128,000,000,000

DIGGER_RIGHT_01_PAT:
	DB 000,000,007,015,019,007,031,047
    DB 014,031,063,031,025,044,000,000
    DB 000,000,192,224,056,056,120,224
    DB 252,124,196,192,192,240,000,000
DIGGER_RIGHT_02_PAT:
	DB 000,000,007,015,019,007,031,047
    DB 015,031,062,031,031,047,000,000
    DB 000,000,192,224,060,124,060,224
    DB 192,192,252,124,164,192,000,000
BADGUY_RIGHT_WALK_01_PAT:
	DB 000,000,031,063,063,063,063,063
    DB 007,014,063,031,012,012,000,000
    DB 000,000,192,192,056,120,056,224
    DB 248,252,096,224,192,240,000,000
BADGUY_RIGHT_WALK_02_PAT:
	DB 000,000,031,063,063,063,063,031
    DB 007,015,029,062,031,012,000,000
    DB 000,000,192,224,056,056,120,224
    DB 192,240,248,000,160,192,000,000
CHOMPER_RIGHT_CLOSED_PAT:
	DB 000,000,000,000,000,006,013,031
    DB 063,054,063,063,051,033,000,000
    DB 000,000,000,000,000,000,000,248
    DB 252,204,252,252,204,132,000,000
CHOMPER_RIGHT_OPEN_PAT:
	DB 000,000,006,013,029,063,060,048
    DB 048,049,063,063,054,034,000,000
    DB 000,000,000,000,248,252,204,000
    DB 000,152,252,252,108,068,000,000
EXTRA_SPRITE_PAT:
	DB 000,000,015,031,056,059,056,059
    DB 059,056,031,015,002,014,000,000
    DB 000,000,240,248,060,252,124,252
    DB 252,060,248,240,112,000,000,000
    DB 000,000,015,031,056,059,056,059
    DB 059,056,031,015,014,000,000,000
    DB 000,000,240,248,060,252,124,252
    DB 252,060,248,240,064,112,000,000
    DB 000,000,015,031,059,061,062,061
    DB 059,055,031,015,014,000,000,000
    DB 000,000,240,248,188,124,252,124
    DB 188,220,248,240,064,112,000,000
    DB 000,000,015,031,059,061,062,061
    DB 059,055,031,015,002,014,000,000
    DB 000,000,240,248,188,124,252,124
    DB 188,220,248,240,112,000,000,000
    DB 000,000,015,031,056,062,062,062
    DB 062,062,031,015,002,014,000,000
    DB 000,000,240,248,060,252,252,252
    DB 252,252,248,240,112,000,000,000
    DB 000,000,015,031,056,062,062,062
    DB 062,062,031,015,014,000,000,000
    DB 000,000,240,248,060,252,252,252
    DB 252,252,248,240,064,112,000,000
    DB 000,000,015,031,056,059,059,056
    DB 058,059,031,015,014,000,000,000
    DB 000,000,240,248,124,188,188,124
    DB 252,060,248,240,064,112,000,000
    DB 000,000,015,031,056,059,059,056
    DB 058,059,031,015,002,014,000,000
    DB 000,000,240,248,124,188,188,124
    DB 252,060,248,240,112,000,000,000
    DB 000,000,015,031,062,061,059,056
    DB 059,059,031,015,002,014,000,000
    DB 000,000,240,248,124,188,220,028
    DB 220,220,248,240,112,000,000,000
    DB 000,000,015,031,062,061,059,056
    DB 059,059,031,015,014,000,000,000
    DB 000,000,240,248,124,188,220,028
    DB 220,220,248,240,064,112,000,000
    DB 000,000,000,001,014,031,063,063
    DB 063,063,031,031,015,003,000,000
    DB 000,000,000,192,112,232,092,188
    DB 252,220,184,184,112,192,000,000
    DB 000,000,000,002,014,030,062,062
    DB 062,062,030,030,014,006,000,000
    DB 000,000,000,064,112,120,124,124
    DB 124,124,120,120,112,096,000,000
    DB 000,000,000,000,000,000,000,000
    DB 000,255,255,254,126,060,000,000
    DB 000,000,000,000,000,000,000,000
    DB 000,255,255,127,126,060,000,000
    DB 000,000,000,000,000,000,000,000
    DB 000,000,031,063,031,063,000,000
    DB 000,000,000,000,000,000,000,000
    DB 000,000,248,252,248,252,000,000
    DB 000,000,007,009,018,036,056,039
    DB 020,018,009,004,002,001,000,000
    DB 000,000,224,144,072,036,028,228
    DB 040,072,144,032,064,128,000,000
    DB 000,000,000,000,000,000,000,001
    DB 001,000,000,000,000,000,000,000
    DB 000,000,000,000,000,000,000,128
    DB 128,000,000,000,000,000,000,000
BALL_SPRITE_PAT:
	DB 000,000,000,000,000,000,001,002
    DB 001,000,000,000,000,000,000,000
    DB 000,000,000,000,000,000,000,128
    DB 000,000,000,000,000,000,000,000
    DB 000,000,000,000,000,001,002,004
    DB 002,001,000,000,000,000,000,000
    DB 000,000,000,000,000,000,128,064
    DB 128,000,000,000,000,000,000,000
    DB 000,000,000,000,001,004,000,008
    DB 000,004,001,000,000,000,000,000
    DB 000,000,000,000,000,064,000,032
    DB 000,064,000,000,000,000,000,000
    DB 000,000,000,001,008,000,000,016
    DB 000,000,128,001,000,000,000,000
    DB 000,000,000,000,032,000,000,016
    DB 000,000,032,000,000,000,000,000
    DB 000,000,001,016,000,000,000,032
    DB 000,000,000,016,001,000,000,000
    DB 000,000,000,016,000,000,000,008
    DB 000,000,000,016,000,000,000,000
    DB 000,001,032,000,000,000,000,064
    DB 000,000,000,000,032,000,001,000
    DB 000,000,008,000,000,000,000,000
    DB 000,000,000,000,008,000,000,000

VARIOUTS_PATTERNS:
	DB 001,000
    DW BLANK_LINE_PAT
    DB 002,008
    DW CHERRY_TOP_PAT
    DB 002,016
    DW CHERRY_BOTTOM_PAT
    DB 004,024
    DW GUMDROP_PAT
    DB 006,032
    DW WHEAT_SQUARE_PAT
    DB 015,040
    DW HUD_PATS_01
    DB 016,056
    DW HUD_PATS_02
    DB 005,072
    DW EXTRA_PATS
    DB 005,080
    DW PLAYFIELD_PATS
    DB 008,088
    DW HALLWAY_BORDER_PAT
    DB 004,112
    DW BADGUY_OUTLINE_PAT
    DB 002,120
    DW HUD_PATS_01
    DB 000
BLANK_LINE_PAT:
	DB 000,000,000,000,000,000,000,000
CHERRY_TOP_PAT:
	DB 000,000,000,000,000,000,001,002
    DB 000,000,000,048,072,136,008,008
CHERRY_BOTTOM_PAT:
	DB 004,014,027,029,031,014,000,000
    DB 016,056,108,116,124,056,000,000
GUMDROP_PAT:
	DB 000,000,001,003,007,014,028,029
    DB 000,000,128,192,224,240,248,248
    DB 057,059,031,015,003,000,000,000
    DB 252,252,248,240,192,000,000,000
WHEAT_SQUARE_PAT:
	DB 000,000,042,063,022,063,023,063
    DB 000,000,192,128,192,128,108,248
    DB 031,053,003,001,003,003,000,000
    DB 108,248,252,104,252,084,000,000
    DB 063,062,049,015,063,056,000,000
    DB 240,008,248,248,000,000,000,000
BADGUY_OUTLINE_PAT:
	DB 000,000,031,032,032,032,032,024
    DB 004,008,008,016,008,015,000,000
    DB 000,000,192,032,024,072,008,016
    DB 032,056,012,016,032,240,000,000
HUD_PATS_01:
    DB 000,000,056,120,124,118,086,092
    DB 024,056,124,124,040,062,000,000
    DB 000,000,000,000,001,003,013,030
    DB 000,000,000,000,128,192,176,120
    DB 000,000,000,003,007,015,031,063
    DB 000,000,000,192,248,248,248,232
    DB 000,000,007,009,018,036,056,039
    DB 000,000,224,144,072,036,028,228
    DB 020,018,009,004,002,001,000,000
    DB 040,072,144,032,064,128,000,000
    DB 254,254,192,248,248,192,254,254
    DB 130,198,108,056,056,108,198,130
    DB 252,252,048,048,048,048,048,048
    DB 248,252,198,198,254,240,200,204
    DB 120,124,204,252,254,198,198,198
HUD_PATS_02:
    DB 063,043,010,001,001,003,000,000
    DB 252,180,096,128,128,192,000,000
    DB 255,255,192,192,192,192,192,192
    DB 192,192,192,192,192,192,192,192
    DB 192,192,192,192,192,192,255,255
    DB 255,255,000,000,000,000,000,000
    DB 000,000,000,000,000,000,255,255
    DB 255,255,003,003,003,003,003,003
    DB 003,003,003,003,003,003,003,003
    DB 003,003,003,003,003,003,255,255
    DB 033,098,034,033,032,034,113,000
    DB 207,034,002,194,034,034,194,000
    DB 128,000,000,000,000,000,000,000
    DB 114,138,011,050,066,130,250,000
    DB 047,040,040,168,104,040,047,000
    DB 000,128,128,128,128,128,000,000
EXTRA_PATS:
	DB 254,254,192,248,248,192,254,254
    DB 130,198,108,056,056,108,198,130
    DB 252,252,048,048,048,048,048,048
    DB 248,252,198,198,254,240,200,204
    DB 120,124,204,252,254,198,198,198
PLAYFIELD_PATS:
	DB 030,030,255,255,225,225,255,255
    DB 241,227,199,143,031,062,124,248
    DB 129,066,036,024,024,036,066,129
    DB 051,102,204,136,204,102,051,017
    DB 195,102,060,000,195,102,060,000
HALLWAY_BORDER_PAT:
	DB 192,192,128,128,192,192,128,128
    DB 001,001,003,003,001,001,003,003
    DB 255,204,000,000,000,000,000,000
    DB 000,000,000,000,000,000,051,255
    DB 255,204,128,128,192,192,128,128
    DB 255,205,003,003,001,001,003,003
    DB 192,192,128,128,192,192,179,255
    DB 001,001,003,003,001,001,051,255
    DB 000

SUB_C952:
    CALL    PLAY_SONGS
    JP      SOUND_MAN

INITIALIZE_THE_SOUND:
    LD      HL, SOUND_TABLE
    LD      B, 9
    JP      SOUND_INIT

PLAY_OPENING_TUNE:
    LD      B, OPENING_TUNE_SND_0A
    CALL    PLAY_IT
    LD      B, OPENING_TUNE_SND_0B
    CALL    PLAY_IT
    LD      A, (SOUND_BANK_01_RAM)
    AND     0C0H
    OR      2
    LD      (SOUND_BANK_01_RAM), A
    LD      A, (SOUND_BANK_02_RAM)
    AND     0C0H
    OR      4
    LD      (SOUND_BANK_02_RAM), A
RET

SUB_C97F:
    LD      A, 0FFH
    LD      (SOUND_BANK_03_RAM), A
RET

PLAY_GRAB_CHERRIES_SOUND:
    LD      B, GRAB_CHERRIES_SND
    JP      PLAY_IT

SUB_C98A:
    LD      A, 0FFH
    LD      (SOUND_BANK_04_RAM), A
    LD      (SOUND_BANK_05_RAM), A
RET

PLAY_BOUNCING_BALL_SOUND:
    LD      B, BOUNCING_BALL_SND_0A
    CALL    PLAY_IT
    LD      A, (SOUND_BANK_05_RAM)
    CP      0FFH
    RET     NZ
    LD      B, BOUNCING_BALL_SND_0B
    JP      PLAY_IT

PLAY_BALL_STUCK_SOUND_01:
    LD      A, (SOUND_BANK_05_RAM)
    AND     3FH
    CP      7
    JR      NZ, PLAY_BALL_STUCK_SOUND_02
    LD      A, 0FFH
    LD      (SOUND_BANK_05_RAM), A
PLAY_BALL_STUCK_SOUND_02:
    LD      B, BALL_STUCK_SND
    JP      PLAY_IT

PLAY_BALL_RETURN_SOUND:
    LD      B, BALL_RETURN_SND
    JP      PLAY_IT

PLAY_APPLE_FALLING_SOUND:
    LD      B, APPLE_FALLING_SND
    JP      PLAY_IT

PLAY_APPLE_BREAKING_SOUND:
    LD      B, APPLE_BREAK_SND_0A
    CALL    PLAY_IT
    LD      A, (SOUND_BANK_05_RAM)
    AND     3FH
    CP      7
    RET     Z
    LD      B, APPLE_BREAK_SND_0B
    JP      PLAY_IT

PLAY_NO_EXTRA_NO_CHOMPERS:
    LD      B, NO_EXTRA_TUNE_0A
    CALL    PLAY_IT
    LD      B, NO_EXTRA_TUNE_0B
    CALL    PLAY_IT
    LD      B, NO_EXTRA_TUNE_0C
    JP      LOC_D3DE

PLAY_DIAMOND_SOUND:
    CALL    INITIALIZE_THE_SOUND
    LD      B, DIAMOND_SND
    JP      PLAY_IT

PLAY_EXTRA_WALKING_TUNE_NO_CHOMPERS:
    LD      B, EXTRA_WALKING_TUNE_0A
    CALL    PLAY_IT
    LD      B, EXTRA_WALKING_TUNE_0B
    JP      PLAY_IT

PLAY_GAME_OVER_TUNE:
    CALL    INITIALIZE_THE_SOUND
    LD      B, GAME_OVER_TUNE_0A
    CALL    PLAY_IT
    LD      B, GAME_OVER_TUNE_0B
    JP      PLAY_IT

PLAY_WIN_EXTRA_DO_TUNE:
    LD      B, WIN_EXTRA_DO_TUNE_0A
    CALL    PLAY_IT
    LD      B, WIN_EXTRA_DO_TUNE_0B
    JP      PLAY_IT

PLAY_END_OF_ROUND_TUNE:
    CALL    INITIALIZE_THE_SOUND
    LD      B, END_OF_ROUND_TUNE_0A
    CALL    PLAY_IT
    LD      B, END_OF_ROUND_TUNE_0B
    JP      PLAY_IT

PLAY_LOSE_LIFE_SOUND:
    CALL    INITIALIZE_THE_SOUND
    LD      B, LOSE_LIFE_TUNE_0A
    CALL    PLAY_IT
    LD      B, LOSE_LIFE_TUNE_0B
    JP      PLAY_IT

SUB_CA24:
    LD      A, 0FFH
    LD      (SOUND_BANK_07_RAM), A
    LD      (SOUND_BANK_08_RAM), A
RET

SUB_CA2D:
    LD      A, 0FFH
    LD      (SOUND_BANK_08_RAM), A
    LD      ($707B), A
RET

PLAY_BLUE_CHOMPERS_SOUND:
    LD      B, BLUE_CHOMPER_SND_0A
    CALL    PLAY_IT
    LD      B, BLUE_CHOMPER_SND_0B
    JP      LOC_D3EA

SOUND_TABLE:
    DW NEW_OPENING_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW NEW_BACKGROUND_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW NEW_OPENING_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW NEW_BACKGROUND_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW GRAB_CHERRIES_SOUND
    DW SOUND_BANK_03_RAM
    DW BOUNCING_BALL_SOUND_P1
    DW SOUND_BANK_04_RAM
    DW BOUNCING_BALL_SOUND_P2
    DW SOUND_BANK_05_RAM
    DW BALL_STUCK_SOUND
    DW SOUND_BANK_04_RAM
    DW BALL_RETURN_SOUND
    DW SOUND_BANK_04_RAM
    DW APPLE_FALLING_SOUND
    DW SOUND_BANK_06_RAM
    DW APPLE_BREAK_SOUND_P1
    DW SOUND_BANK_06_RAM
    DW APPLE_BREAK_SOUND_P2
    DW SOUND_BANK_05_RAM
    DW NO_EXTRA_TUNE_P1
    DW SOUND_BANK_09_RAM
    DW NO_EXTRA_TUNE_P2
    DW SOUND_BANK_07_RAM
    DW NO_EXTRA_TUNE_P3
    DW SOUND_BANK_08_RAM
    DW DIAMOND_SOUND
    DW SOUND_BANK_09_RAM
    DW EXTRA_WALKING_TUNE_P1
    DW SOUND_BANK_07_RAM
    DW EXTRA_WALKING_TUNE_P2
    DW SOUND_BANK_08_RAM
    DW GAME_OVER_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW GAME_OVER_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW WIN_EXTRA_DO_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW WIN_EXTRA_DO_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW END_OF_ROUND_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW END_OF_ROUND_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW LOSE_LIFE_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW LOSE_LIFE_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW BLUE_CHOMPER_SOUND_0A
    DW SOUND_BANK_08_RAM
    DW BLUE_CHOMPER_SOUND_0B
    DW SOUND_BANK_09_RAM

GRAB_CHERRIES_SOUND:
    DB 193,214,048,002,051,149,193,214,048,002,051,149,193,214,048,002,051,149,234,193,190,048
    DB 002,051,161,193,190,048,002,051,161,193,190,048,002,051,161,234,193,170,048,002,051,171
    DB 193,170,048,002,051,171,193,170,048,002,051,171,234,193,160,048,002,051,176,193,160,048
    DB 002,051,176,193,160,048,002,051,176,234,193,143,048,002,051,185,193,143,048,002,051,185
    DB 193,143,048,002,051,185,234,193,127,048,002,051,193,193,127,048,002,051,193,193,127,048
    DB 002,051,193,234,193,113,048,002,051,200,193,113,048,002,051,200,193,113,048,002,051,200
    DB 234,193,107,048,002,051,203,193,107,048,002,051,203,193,107,048,002,051,203,208
BOUNCING_BALL_SOUND_P1:
    DB 130,075,129,006,194,051,152
BOUNCING_BALL_SOUND_P2:
    DB 194,138,129,006,194,051,216
BALL_STUCK_SOUND:
    DB 192,064,001,003,193,127,016,002,051,127,193,107,016,002,051,107,193,080,032,002,051,080
    DB 193,064,032,002,051,064,193,053,048,002,051,053,193,040,064,002,051,040,193,032,080,002
    DB 051,032,193,024,096,002,051,024,193,020,112,002,051,020,193,016,128,002,051,016,208
BALL_RETURN_SOUND:
    DB 193,016,128,002,051,016,193,020,112,002,051,020,193,024,096,002,051,024,193,032,080,002
    DB 051,032,193,040,080,002,051,040,193,053,064,002,051,053,193,064,064,002,051,064,193,080
    DB 048,002,051,080,193,107,048,002,051,107,193,127,032,002,051,127,192,064,017,003,208
APPLE_FALLING_SOUND:
    DB 129,057,080,007,068,004,129,089,048,007,068,007,129,145,112,007,068,011,129,233,176,007,068,016,144
APPLE_BREAK_SOUND_P1:
    DB 128,172,017,008,167,129,107,048,002,071,250,144
APPLE_BREAK_SOUND_P2:
    DB 192,029,017,008,231,193,127,048,002,071,249,208
NO_EXTRA_TUNE_P1:
    DB 065,027,000,002,102,001,065,032,032,002,102,004,064,040,048,006,111,064,107,048,007
    DB 099,064,107,048,007,099,064,085,048,007,099,064,085,048,007,099,064,071,048,007,099
    DB 064,071,048,007,099,064,085,048,010,106,064,080,048,007,099,064,080,048,007,099,064
    DB 095,048,007,099,064,095,048,007,099,064,113,048,007,099,064,113,048,007,099,064,143
    DB 048,010,106,064,170,064,007,099,064,170,064,007,099,064,143,064,007,099,064,143,064
    DB 007,099,064,107,064,007,099,064,107,064,007,099,064,085,064,010,106,064,095,064,007
    DB 099,064,095,064,007,099,065,107,064,002,085,006,065,127,064,002,085,242,064,107,064
    DB 007,099,064,107,064,007,099,064,107,064,010,080
NO_EXTRA_TUNE_P2:
    DB 129,060,000,002,102,016,128,050,032,006,129,101,048,002,102,231,175,128,214,064,007
    DB 163,128,170,064,010,170,128,143,064,007,163,128,170,064,010,170,128,127,064,010,170
    DB 128,143,064,007,163,128,113,064,010,170,128,095,064,007,163,128,071,064,020,180,128
    DB 071,048,007,163,128,064,048,007,163,128,071,048,007,163,128,064,048,007,163,128,071
    DB 048,007,163,128,071,048,007,163,128,085,048,010,170,128,080,048,007,163,128,080,048
    DB 007,163,128,095,048,007,163,128,095,048,007,163,128,107,048,010,144
NO_EXTRA_TUNE_P3:
    DB 193,064,000,002,102,016,192,053,032,006,193,107,048,002,102,229,208
LOSE_LIFE_TUNE_P1:
    ; High B
    DB 064,056,096,007,099
    ; High C
    DB 064,053,096,007,107
    ; Sec F
    DB 064,160,096,004,099
    ; Sec G
    DB 064,142,096,007,107
    ; SEcond Highest G#
    DB 064,067,096,007,099
    ; B Flat (B5)
    DB 064,119,096,007,107
    ; D# (low)
    DB 064,206,098,007,099
    ; C (low)
    DB 064,086,099,007,080
LOSE_LIFE_TUNE_P2:
    DB 128,056,096,007,162
    DB 128,053,096,007,170
    ; Middle G#
    DB 128,134,096,004,162
    ; Middle B (B4)
    DB 192,142,096,007,235
    ; D# (D5)
    DB 192,089,096,007,227
    ; F# (middle)
    DB 192,119,096,007,235
    ; D# (low)
    DB 192,206,098,007,227
    ; C (low)
    DB 192,086,099,007,144
DIAMOND_SOUND:
    DB 130,023,080,008,027,017,152

EXTRA_WALKING_TUNE_P1:
	DB 064,107,048,007,099,064,143,048,007,099,064,143,048,007,099,064,143,048,007,099,064
    DB 107,048,007,099,064,143,048,007,099,064,143,048,007,099,064,143,048,007,099,064,127
    DB 048,007,099,064,160,048,007,099,064,160,048,007,099,064,160,048,007,099,064,127,048
    DB 007,099,064,160,048,007,099,064,160,048,007,099,064,160,048,007,099,064,143,048,007
    DB 099,064,113,048,007,099,064,113,048,007,099,064,113,048,007,099,064,143,048,007,099
    DB 064,113,048,007,099,064,113,048,007,099,064,113,048,007,099,064,113,048,007,099,064
    DB 095,048,007,099,064,113,048,007,099,064,095,048,007,099,064,095,048,007,099,064,107
    DB 048,007,099,064,107,048,010,088
EXTRA_WALKING_TUNE_P2:
    DB 128,143,080,005,129,107,128,003,085,228,128,170,080,005,129,107,128,003,085,228,128
    DB 143,080,005,129,107,128,003,085,228,128,085,080,005,129,107,128,003,085,228,128,095
    DB 080,005,129,095,128,003,085,226,128,127,080,005,129,095,128,003,085,226,128,080,080
    DB 005,129,095,128,003,085,226,128,107,080,005,129,095,128,003,085,226,128,113,080,005
    DB 129,113,128,003,085,214,128,071,080,005,129,113,128,003,085,214,128,127,080,005,129
    DB 113,128,003,085,214,128,080,080,005,129,113,128,003,085,214,128,085,080,005,129,113
    DB 128,003,085,214,128,095,080,005,129,113,128,003,085,214,128,107,080,005,129,071,128
    DB 003,085,071,128,214,080,010,152
GAME_OVER_TUNE_P1:
    DB 064,160,048,022,064,107,048,007,100,064,107,048,007,100,064,127,048,011,107,064,160
    DB 048,011,107,064,160,048,022,064,107,048,007,100,064,107,048,007,100,064,127,048,011
    DB 107,064,160,048,011,107,064,143,048,011,107,064,107,048,007,100,064,107,048,007,100
    DB 064,107,048,022,118,118,064,085,048,011,107,064,080,048,011,080
GAME_OVER_TUNE_P2:
    DB 182,182,128,064,081,022,128,214,080,007,164,128,214,080,007,164,128,254,080,011,171
    DB 128,064,081,011,171,128,064,081,022,128,214,080,007,164,128,214,080,007,164,128,240
    DB 096,011,171,128,254,096,011,171,128,029,097,011,171,128,087,099,007,164,128,087,099
    DB 007,164,128,087,099,022,128,214,112,011,107,128,064,113,011,144
WIN_EXTRA_DO_TUNE_P1:
    DB 065,170,048,002,170,020,065,214,048,002,170,232,066,170,048,010,052,021,065,190,048
    DB 002,245,024,066,254,048,010,052,021,065,202,048,002,170,024,065,254,048,002,170,228
    DB 066,202,048,010,052,021,065,226,048,002,245,028,065,214,048,002,170,012,065,240,048
    DB 002,165,242,065,254,048,002,165,031,066,202,048,010,052,021,065,214,048,002,165,244
    DB 065,226,048,002,165,028,066,190,048,010,052,021,065,254,048,002,165,228,065,254,048
    DB 002,165,048,066,125,049,020,052,021,066,190,048,020,052,021,080
WIN_EXTRA_DO_TUNE_P2:
    DB 130,172,049,020,052,021,130,029,049,020,052,021,130,172,049,020,052,021,129,252,049
    DB 002,170,228,130,197,049,020,052,021,130,046,049,020,052,021,130,197,049,020,052,021
    DB 129,046,049,002,170,018,130,083,049,020,052,021,130,197,049,020,052,021,130,252,049
    DB 020,052,021,130,148,049,020,052,021,130,125,049,020,052,021,130,252,049,020,052,021
    DB 129,125,049,002,170,127,130,125,049,020,052,021,144
END_OF_ROUND_TUNE_P1:
    DB 105,064,180,048,006,099,064,143,048,006,099,064,135,048,006,099,064,120,048,009,105
    DB 064,090,048,009,105,064,095,048,009,105,064,107,048,009,105,064,143,048,027,114,064
    DB 143,048,006,099,064,135,048,006,099,064,143,048,006,099,064,160,048,027,114,064,160
    DB 048,006,099,064,143,048,006,099,064,160,048,006,099,064,180,048,027,105,088
END_OF_ROUND_TUNE_P2:
    DB 128,202,082,006,163,128,029,065,006,163,128,029,081,006,163,128,029,097,006,163,128
    DB 250,066,006,163,128,029,065,006,163,128,029,081,006,163,128,029,097,006,163,128,087
    DB 051,006,163,128,029,065,006,163,128,029,081,006,163,128,029,097,006,163,128,191,051
    DB 006,163,128,029,065,006,163,128,029,081,006,163,128,029,097,006,163,128,202,082,006
    DB 163,128,029,065,006,163,128,029,081,006,163,128,029,097,006,163,128,224,081,006,163
    DB 128,013,065,006,163,128,013,081,006,163,128,013,097,006,163,128,250,066,006,163,128
    DB 013,065,006,163,128,013,081,006,163,128,013,097,006,163,128,202,082,006,163,128,191
    DB 035,006,163,128,087,051,006,163,128,250,066,006,163,152
BLUE_CHOMPER_SOUND_0A:
    DB 065,255,115,004,020,017,104,088
BLUE_CHOMPER_SOUND_0B:
    DB 002,018,004,020,017,002,080,012,083,019,024

LOC_D300:
    SET     0, (HL)
    LD      HL, 5A0H
    XOR     A
    JP      LOC_B895
LOC_D309:
    LD      HL, $7272
    BIT     5, (HL)
    JR      Z, LOC_D319
    RES     5, (HL)
    PUSH    IY
    CALL    PLAY_NO_EXTRA_NO_CHOMPERS
    POP     IY
LOC_D319:
    JP      LOC_A596
LOC_D31C:
    LD      A, ($7272)
    BIT     5, A
    RET     NZ
    CALL    PLAY_EXTRA_WALKING_TUNE_NO_CHOMPERS
RET
LOC_D326:
    CALL    SUB_B8F7
    PUSH    IY
    CALL    SUB_CA24
    LD      HL, $726E
    SET     7, (HL)
LOC_D333:
    BIT     7, (HL)
    JR      NZ, LOC_D333
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    CALL    PLAY_BLUE_CHOMPERS_SOUND
    POP     IY
    JP      LOC_B8AB
LOC_D345:
    CALL    SUB_CA2D
    LD      HL, $726E
    SET     7, (HL)
LOC_D34D:
    BIT     7, (HL)
    JR      NZ, LOC_D34D
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    LD      HL, $7272
    JP      LOC_B875
LOC_D35D:
    LD      ($726F), A
    CALL    PLAY_EXTRA_WALKING_TUNE_NO_CHOMPERS
    JP      LOC_B89B
LOC_D366:
    CALL    SUB_9577
    XOR     A
    JP      LOC_9481
LOC_D36D:
    LD      ($72C6), A
    LD      HL, $72C4
    BIT     0, (HL)
    JP      Z, LOC_B8EC
    RES     0, (HL)
    LD      A, ($726F)
    CALL    TEST_SIGNAL
    JP      LOC_B8EC
LOC_D383:
    LD      A, ($72C6)
    CALL    TEST_SIGNAL
    AND     A
    JP      Z, LOC_D3A6
    LD      A, ($72C3)
    XOR     1
    LD      ($72C3), A
    LD      HL, 78H
    BIT     0, A
    JR      Z, LOC_D39F
    LD      HL, 3CH
LOC_D39F:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      ($72C6), A
LOC_D3A6:
    LD      A, ($72C3)
    BIT     0, A
    JP      Z, LOC_A853
    JP      LOC_A858

LOC_D3D5:
    AND     7
    LD      C, 0C0H
    CP      3
    JP      LOC_A8AF
LOC_D3DE:
    CALL    PLAY_IT
    LD      A, 0FFH
    LD      (SOUND_BANK_01_RAM), A
    LD      (SOUND_BANK_02_RAM), A
RET
LOC_D3EA:
    CALL    PLAY_IT
    LD      A, 0FFH
    LD      (SOUND_BANK_01_RAM), A
    LD      (SOUND_BANK_02_RAM), A
    LD      (SOUND_BANK_07_RAM), A
RET

LOC_D3F9:
    LD      A, (SOUND_BANK_01_RAM)
    AND     0FH
    CP      2
    JR      Z, LOC_D405
    CALL    PLAY_OPENING_TUNE
LOC_D405:
    CALL    SUB_999F
    JP      LOC_98A5
LOC_D40B:
    LD      A, (DIAMOND_RAM)
    BIT     7, A
    JP      Z, LOC_D3F9
    LD      A, ($707B)
    AND     0FFH
    CP      0FFH
    JP      NZ, LOC_D405
    CALL    PLAY_DIAMOND_SOUND
    JP      LOC_D405

NEW_OPENING_TUNE_P1:
    DB 064,143,096,007,099,064,214,096,007,099,064,214,096,007,099,064,214,096,007,099,064,160
    DB 096,007,099,064,226,096,007,099,064,226,096,007,099,064,226,096,007,099,064,143,096,007
    DB 099,064,160,096,007,099,064,170,096,007,099,064,190,096,007,099,064,214,096,030,106
NEW_BACKGROUND_TUNE_P1:
    ; E2 33
    DB 064,169,128,030,106
    ; D4 10
    DB 064,190,128,007,099
    ; F4 10
    DB 064,160,128,007,099
    ; E4 10
    DB 064,169,128,007,099
    ; D4 10
    DB 064,190,128,007,099
    ; G4 20
    ; DB 064,142,128,010,106
    ; G4 20
    ; DB 064,142,128,010,106
    ; E4 (complements lower G) 10

    ; OVER LONG G
    ; E4 10
    DB 064,169,128,007,099
    ; C4 10
    DB 064,213,128,007,099
    ; OVER LONG G
    ; E4 10
    DB 064,169,128,007,099
    ; C4 10
    DB 064,213,128,007,099

    DB 064,169,128,007,099
    ; F4 (complements lower A) 10
    DB 064,160,128,007,099
    ; C4 (complements lower E) 10
    DB 064,213,128,007,099
    ; D4 (complements lower F) 10
    DB 064,190,128,007,099 
    ; B4 (over long D) 20
    ; DB 064,226,128,010,106
    ; B4 (over long D) 20
    ; DB 064,226,128,010,106

    ; OVER LONG D
    ; F4 10
    DB 064,160,128,007,099
    ; G4 10
    DB 064,142,128,007,099
    ; OVER LONG D
    ; F4 10
    DB 064,160,128,007,099
    ; G4 10
    DB 064,142,128,007,099

    ; D4 (short) 10
    DB 064,226,128,007,099
    ; D4 (complements lower F) 10
    DB 064,190,128,007,099
    ; C (complements lower E) 10
    DB 064,213,128,007,099
    ; D4 (complements lower D) 10
    DB 064,190,128,007,099
    ; C4 (complements lower C) 10
    DB 064,213,128,007,099
    ; E5 (complements lower C) 10
    DB 064,169,128,007,099
    ; G on the B 10
    DB 064,142,128,007,099
    ; F on the A 10
    DB 064,160,128,007,099
    ; E on the G 10
    DB 064,169,128,007,099
    ; D on the F 10
    DB 064,190,128,007,099
    ; C on the E 10
    DB 064,213,128,007,099
    ; B on the D 20
    DB 064,226,128,007,099,088
NEW_OPENING_TUNE_P2:
    DB 128,170,128,007,163,128,170,128,010,170,128,170,128,007,163,128,190,128,007,163,128
    DB 190,128,010,170,128,190,128,007,163,128,170,128,007,163,128,190,128,007,163,128,214
    DB 128,007,163,128,226,128,007,163,128,214,128,007,163,128,226,128,007,163,128,254,128
    DB 007,163,128,029,129,007,163
NEW_BACKGROUND_TUNE_P2:
    ; Note 1: C3
    DB 128,171,097,030,170
    ; Note 2: D3
    DB 128,062,097,007,163
    ; Note 3: F3
    DB 128,064,097,007,163
    ; Note 4: E3
    DB 128,083,097,007,163
    ; Note 5: D3
    DB 128,124,097,007,163
    ; Note 6: G3 (longer duration)
    DB 128,029,097,010,170
    ; Note 7: G3 (longer duration)
    DB 128,029,097,010,170
    ; Note 8: G3 
    DB 128,029,097,007,163
    ; Note 9: A4 
    DB 128,254,096,007,163
    ; Note 10: E3
    DB 128,083,097,007,163
    ; Note 11: F3
    DB 128,064,097,007,163

    ; Note 12: D3
    DB 128,124,097,010,170
    ; Note 13: D3
    DB 128,124,097,010,170

    ; Note 14: D3
    DB 128,124,097,007,163

    ; Note 15: F3
    DB 128,064,097,007,163
    ; Note 16: E3
    DB 128,083,097,007,163
    ; Note 17: D3
    DB 128,124,097,007,163
    ; Note 18: C3
    DB 128,171,097,007,163
    ; Note 19: C4
    DB 128,213,096,007,163
    ; Note 20: B4
    DB 128,226,096,007,163
    ; Note 21: A4
    DB 128,254,096,007,163
    ; Note 22: G3
    DB 128,029,097,007,163
    ; Note 23: F3
    DB 128,064,097,007,163
    ; Note 24: E3
    DB 128,083,097,007,163
    ; Note 25: D3
    DB 128,124,097,007,163,152