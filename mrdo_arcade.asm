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
VRAM_PATTERN:       EQU $0000
VRAM_NAME:          EQU $1800
VRAM_COLOR:         EQU $2000

; VDP
DATA_PORT: EQU 0BEh ; MSX 098h
CTRL_PORT: EQU 0BFh ; MSX 099h


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
	ORG $7000,$73FF
SPRITE_ORDER_TABLE:		RB	20	;EQU $7000
TIMER_DATA_BLOCK:  		RB	23	;EQU $7014

SOUND_BANK_01_RAM:  	RB 	10	;EQU $702B
SOUND_BANK_02_RAM:  	RB 	10	;EQU $7035
SOUND_BANK_03_RAM:  	RB 	10	;EQU $703F
SOUND_BANK_04_RAM:  	RB 	10	;EQU $7049
SOUND_BANK_05_RAM:  	RB 	10	;EQU $7053
SOUND_BANK_06_RAM:  	RB 	10	;EQU $705D
SOUND_BANK_07_RAM:  	RB 	10	;EQU $7067
SOUND_BANK_08_RAM:  	RB 	10	;EQU $7071
SOUND_BANK_09_RAM:  	RB 	10	;EQU $707B
						RB 	 1	; ??
					 
CONTROLLER_BUFFER:  	RB 	 6	;EQU $7086
KEYBOARD_P1:        	RB 	 1	;EQU $708C
						RB 	 4	;EQU $708D ?? some kind of struct used in SUB_94A9
KEYBOARD_P2:        	RB 	 1	;EQU $7091
						RB 	12	;EQU $7092 ??
TIMER_TABLE:        	RB 	75	;EQU $709E
SPRITE_NAME_TABLE:  	RB 	80	;EQU $70E9	; SAT

BADGUY_BHVR_CNT_RAM:	RB   1	;EQU $7139 ; HOW MANY BYTES IN TABLE
BADGUY_BEHAVIOR_RAM:	RB  28	;EQU $713A ; BEHAVIOR TABLE. UP TO 28 ELEMENTS
						RB 285	; ?? 
								;EQU $726E ; NMI-ISR CONTROL BYTE (!!)
DIAMOND_RAM:        	RB   1	;EQU $7273
CURRENT_LEVEL_RAM:  	RB   2	;EQU $7274
LIVES_LEFT_P1_RAM:  	RB   1	;EQU $7276
LIVES_LEFT_P2_RAM:  	RB   1	;EQU $7277
						RB   5	;EQU $7278 ?? Initialised at 7 by LOC_8573
						
SCORE_P1_RAM:       	RB   2	;EQU $727D ;  $727D/7E  2 BYTES SCORING FOR PLAYER#1. THE LAST DIGIT IS A RED HERRING. I.E. 150 LOOKS LIKE 1500.  SCORE WRAPS AROUND AFTER $FFFF (65535)
SCORE_P2_RAM:       	RB   2	;EQU $727F ;  $727F/80  2 BYTES SCORING FOR PLAYER#2
						RB 110	; ??
WORK_BUFFER:         	RB 215	;EQU $72EF
DEFER_WRITES:        	RB 	 2	;EQU $73C6
						RB 	 8	; ??
STORED_COLOR_POINTER: 	RB 	 2	;EQU $73D0    ; 2 bytes for storing the pointer
STORED_COLOR_DATA:    	RB 	 12	;EQU $73D2    ; 12 bytes for actual color data

mode:				 EQU $73FF	; maybe used by OS ??



FNAME "mrdo_arcade.rom"
;	CPU Z80


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
;    JP      NMI
    JP      nmi_handler

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
    CALL    SUB_C952		; PLAY MUSIC
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
	ld 		hl,mode
	LD      (HL), 0	

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

SUB_83D4: ; Initialize the game
    CALL    GET_GAME_OPTIONS
	call 	cvb_ANIMATEDLOGO
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

SUB_84F8:    ; Disables NMI, sets up the game
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

SUB_851C:   ; If we're here, the game just started
    LD      HL, 0
    LD      (SCORE_P1_RAM), HL
    LD      (SCORE_P2_RAM), HL
    LD      A, 1    ; Set the starting level to 1
    LD      (CURRENT_LEVEL_RAM), A
    LD      ($7275), A
    XOR     A
    LD      ($727A), A
    LD      ($727B), A
    LD      A, ($7271)
    CP      2
    LD      A, 3        ; Set the number of lives to 3
    JR      NC, LOC_853F
    LD      A, 5        ; Set the number of lives to 5
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

SUB_87F4:   ; Start the level
    LD      IY, $7281
    XOR     A
    LD      (IY+6), A
    LD      (IY+7), A
    LD      A, 1
    LD      (IY+1), A       ; Set Mr. Do's starting direction
    LD      (IY+5), A
    LD      (IY+3), 0B0H    ; Set Mr. Do's starting Y coordinate
    LD      (IY+4), 78H     ; Set Mr. Do's starting X coordinate
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

SUB_8BC0:   ; Mr. Do interesecting with a falling apple
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

SUB_8BF6:   ; Falling apple
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

SUB_8C3A:   ; Falling apple
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

SUB_8C96:   ; Falling apple
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

SUB_8CFE:   ; Check if Mr. Do is intersecting with a falling apple
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

SUB_8E10:   ; Falling apple logic
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

SUB_93CE:  ; Ball intersecting with sprite
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
LOC_9421:  ; Ball intersects with sprite
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
    LD      IY, $7281  ; IY points to Mr. Do's sprite data
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
    CALL    SUB_95A1     ; Mr. Do sprite intersection logic
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

SUB_95A1:  ; Mr. Do Sprite intersection logic
    CALL    SUB_961F  ; Mr. Do's sprite collision logic with the screen bounds
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
    CALL    SUB_AEE1 ; Mr do is pushing an apple
    BIT     0, A
    JR      Z, LOC_95C8
    SET     5, (IY+0)
LOC_95C8:
    CP      2
    JR      NC, LOC_9617
    JR      LOC_95D5
LOC_95CE: ; Mr. Do intersects with an apple while facing up or down
    LD      D, A
    CALL    SUB_B12D ; Returns A=0 if no collision, A=1 if collision
    AND     A
    JR      Z, LOC_95D5

    POP     BC
    JP      LOC_961C ; Treat as a "wall" collision
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

SUB_961F:  ; Mr. Do's sprite collision logic with the screen bounds
    LD      (IY+1), A
    LD      B, (IY+3)
    LD      C, (IY+4)
    CP      3       ; Check if Mr. Do is facing up or down
    JR      NC, LOC_964B  ; If facing up or down, jump to LOC_964B
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
LOC_966D: ; Mr. Do has collided with the bounds of the screen
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
    LD      DE, 2DH ; final cherry scores 500 not 550
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
    CALL    SUB_B12D    ; Returns A=1 if vertical apple collision
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
    SUB     0F4H
    LD      C, A
    LD      A, B
    SBC     A, 1
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

SUB_A99C: ; CONGRATULATIONS! YOU WIN AN EXTRA MR. DO! TEXT and MUSIC
    LD      HL, $726E
    SET     7, (HL)
LOC_A9A1:
    BIT     7, (HL)
    JR      NZ, LOC_A9A1

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

	; %%%%%%%%%%%%%%%%%%%%%%%%%%
	; show the extra screen
	LD	HL,mode
	SET	7,(hl)						; switch to intermission  mode
	
    CALL    cvb_EXTRASCREEN

    LD      HL, 280H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AA06:							; wait for music 
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    AND     A
    JR      Z, LOC_AA06
    POP     AF

    LD      HL, 1900H 			; remove all sprites 
    LD      DE, 80H 			; 128 characters
    XOR 	A 					; fill with 0s
    CALL    FILL_VRAM
    LD      HL, SPRITE_NAME_TABLE
    LD      B, 50H				; remove 20 sprites
LOC_A9C0:
    LD      (HL), 0
    INC     HL
    DJNZ    LOC_A9C0

	LD	HL,mode
	RES	7,(hl)						; switch to game mode
	
    CALL    INIT_VRAM
    LD      HL, $726E
    SET     7, (HL)
LOC_AA14:
    BIT     7, (HL)
    JR      NZ, LOC_AA14

    ; Original code's final register writes
    LD      BC, 700H         ; R7: Border/background color
    CALL    WRITE_REGISTER
    LD      BC, 1E2H         ; Original game state register
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

SUB_AEE1:   ; Apple Pushing/Intersection logic
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
LOC_AFD7:   ; BADGUY PUshes APPLE
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
LOC_B05A:   ; Mr. Do pushing an apple from the bottom
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

SUB_B12D: ; Mr. Do sprite intersection with apples from above and below
    LD      IX, $722C   ; IX points to the first apple's sprite data
    LD      E, 5        ; Number of apples to check
    ; Modified to offset the value used to detect a vertical collision
    ; with an apple so that Mr. Do doesn't get stuck in the apple from
    ; above or below.
    LD      A, (IY+3)   ; Get Y position of Mr. Do
    BIT     1, D         ; Check if moving down
    JR      Z, CHECK_UP
    SUB     4          ; Moving down, so sub 4 from Y position
    JR      START_CHECK
CHECK_UP:
    ADD     A, 4           ; Moving up, so add 4 to Y position
START_CHECK:
    LD      B, A    ; Store the new Y position in B for checks
LOC_B133:
    BIT     7, (IX+0)   ; Check if the apple is active
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

SUB_B5DD:   ; Ball collision detection
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

OFF_B691: ; Sprite color data
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
    DB 000,000,184,010    ; Pattern 184 uses Dark Yellow (Yellow)

BYTE_B6C7:
    DB 176,015,148,015    ; Patterns 176,148 use White

BYTE_B6CB:
    DB 180,003,160,003    ; Patterns 180,160 use Light Green

BYTE_B6CF:
    DB 000,000,096,011,100,011,104,011,108,011,112,011,116,011,120,011,124,011,128,011,132,011  ; Series using Light Yellow
    DB 148,011,096,008,100,008,104,008,108,008,112,008,116,008,120,008,124,008,128,008,132,008  ; Series using Medium Red

BYTE_B6FB:
    DB 000,000,156,010,192,010,196,010,200,010,204,010,208,010,212,010    ; Series using Dark Yellow

BYTE_B70B:
    DB 000,000,000,008,004,008,008,008,012,008,016,008,020,008,024,008,028,008,032,008,036,008,040,008,044,008    ; Badguy sprite color (Red)
    DB 000,007,004,007,008,007,012,007,016,007,020,007,024,007,028,007,032,007,036,007,040,007,044,007,048,015    ; Series using Cyan, ending in White
    DB 052,005,056,005,060,005,064,005,068,005,072,005,076,005,080,005,084,005,088,005,092,005,148,013    ; Digger sprite color (Light Blue), last one defines enemy splat color

BYTE_B757:
    DB 000,000,136,008,140,008,144,008,152,015    ; Apple Sprite colors (Medium Red), ending in White

BYTE_B761:
    DB 000,000,224,005,228,005,232,005,236,005,148,005    ; Series using Light Blue

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
    
    ; Set red flash colors (original code)
    LD      HL, PLAYFIELD_COLOR_FLASH_EXTRA
    LD      DE, 0
    LD      IY, 0CH
    LD      A, 4
    CALL    PUT_VRAM
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    
    ; Store current level's color pointer
    LD      A, (CURRENT_LEVEL_RAM)
    DEC     A           ; Adjust for 0-based index
    ADD     A, A        ; Multiply by 2 for word-sized entries
    LD      HL, PLAYFIELD_COLORS
    LD      B, 0
    LD      C, A
    ADD     HL, BC     ; HL now points to the correct pointer
    LD      (STORED_COLOR_POINTER), HL
    
    POP     IY
    RET
PLAYFIELD_COLOR_FLASH_EXTRA:
    DB 000,025,137,144,128,240,240,160,160,128,153,144,000
RESTORE_PLAYFIELD_COLORS:
    PUSH    IY
    
    ; Calculate correct level colors using original logic
    LD      A, ($726E)
    BIT     1, A
    LD      A, (CURRENT_LEVEL_RAM)
    JR      Z, USE_CURRENT_LEVEL
    LD      A, ($7275)
USE_CURRENT_LEVEL:
    CP      0BH
    JR      C, CONTINUE_RESTORE
    SUB     0AH
    JR      USE_CURRENT_LEVEL
CONTINUE_RESTORE:
    DEC     A
    ADD     A, A
    LD      C, A
    LD      B, 0
    LD      IY, PLAYFIELD_COLORS
    ADD     IY, BC
    LD      L, (IY+0)
    LD      H, (IY+1)
    
    ; Restore the colors
    LD      DE, 0
    LD      IY, 0CH
    LD      A, 4
    CALL    PUT_VRAM
    
    LD      BC, 1E2H
    CALL    WRITE_REGISTER
    
    POP     IY
    RET

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
WIN_EXTRA_GEN: ; CONGRATULATIONS! YOU WIN AN EXTRA MR. DO! TEXT
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
    DB 000, 176, 000
    DW FIVE_HUNDRED_SCORE_PAT

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
   DB 000,007,013,095,058,014,005,006
   DB 001,002,007,013,015,005,003,000
   DB 000,192,096,000,224,176,176,224
   DB 128,064,176,248,088,128,224,000
MR_DO_WALK_RIGHT_02_PAT:
   DB 000,003,006,011,030,054,077,006
   DB 025,126,103,011,062,025,012,000
   DB 000,192,224,000,224,176,176,224
   DB 128,064,176,248,216,224,120,000
MR_DO_PUSH_RIGHT_01_PAT:
   DB 000,015,026,190,117,029,011,005
   DB 027,060,047,059,031,010,015,000
   DB 000,128,192,000,192,096,096,192
   DB 000,136,248,248,000,000,128,000
MR_DO_PUSH_RIGHT_02_PAT:
   DB 000,007,013,022,061,109,155,013
   DB 003,012,031,251,223,130,129,000
   DB 000,128,192,000,192,096,096,192
   DB 000,196,252,124,128,192,184,000

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

FIVE_HUNDRED_SCORE_PAT:
   DB 000,000,000,000,000,113,066,114
   DB 010,074,049,000,000,000,000,000
   DB 000,000,000,000,000,140,082,082
   DB 082,082,140,000,000,000,000,000
DIGGER_RIGHT_01_PAT:
   DB 007,029,054,124,212,063,045,120
   DB 215,055,120,222,033,126,000,000
   DB 224,016,104,072,008,248,176,000
   DB 252,254,006,066,240,000,000,000
DIGGER_RIGHT_02_PAT:
    DB 007,029,054,124,212,062,045,123
    DB 215,058,127,211,124,001,000,000
    DB 224,016,104,000,120,252,196,160
    DB 096,224,192,000,128,240,000,000
BADGUY_RIGHT_WALK_01_PAT:
   DB 000,000,031,063,062,062,063,031
   DB 006,029,063,125,016,062,000,000
   DB 000,000,240,056,220,156,028,248
   DB 032,252,254,128,064,248,000,000
BADGUY_RIGHT_WALK_02_PAT:
   DB 000,031,063,062,062,063,030,005
   DB 061,029,026,006,012,008,000,000
   DB 000,240,056,220,156,000,252,254
   DB 128,100,108,248,016,016,000,000
CHOMPER_RIGHT_CLOSED_PAT:
   DB 000,000,014,031,025,014,017,063
   DB 056,053,056,063,059,017,000,000
   DB 000,000,056,124,100,184,192,252
   DB 000,084,000,252,220,136,000,000
CHOMPER_RIGHT_OPEN_PAT:
   DB 014,025,025,014,017,063,056,053
   DB 048,048,050,056,063,036,000,000
   DB 056,100,100,184,192,252,000,084
   DB 000,000,168,000,252,036,000,000
EXTRA_SPRITE_PAT:
   DB 030,057,057,096,071,068,071,068 ; E Left foot down
   DB 068,039,048,015,006,060,000,000
   DB 120,156,156,006,242,002,194,002
   DB 002,244,012,240,126,000,000,000
   DB 000,030,057,032,064,064,064,064 ; Right foot down
   DB 064,096,048,031,126,000,000,000
   DB 000,120,156,004,002,002,002,002
   DB 002,006,012,248,096,060,000,000
   DB 000,030,057,032,064,064,064,064 ; Right foot down
   DB 064,096,048,031,126,000,000,000
   DB 000,120,156,004,002,002,002,002
   DB 002,006,012,248,096,060,000,000
   DB 030,057,057,096,070,067,064,065 ; X Left foot down
   DB 067,038,048,015,006,060,000,000
   DB 120,156,156,006,050,098,194,130
   DB 098,052,012,240,126,000,000,000
   DB 030,057,057,096,071,064,064,064 ; T Left foot down
   DB 064,032,048,015,006,060,000,000
   DB 120,156,156,006,242,130,130,130
   DB 130,132,012,240,126,000,000,000
   DB 000,030,057,032,064,064,064,064 ; Right foot down
   DB 064,096,048,031,126,000,000,000
   DB 000,120,156,004,002,002,002,002
   DB 002,006,012,248,096,060,000,000
   DB 000,030,057,032,064,064,064,064 ; Right foot down
   DB 064,096,048,031,126,000,000,000
   DB 000,120,156,004,002,002,002,002
   DB 002,006,012,248,096,060,000,000
   DB 030,057,057,096,071,068,068,071 ; R Left foot down
   DB 068,036,048,015,006,060,000,000
   DB 120,156,156,006,226,050,050,226
   DB 066,116,012,240,126,000,000,000
   DB 030,057,057,096,065,067,070,068 ; A Left foot down
   DB 071,036,048,015,006,060,000,000
   DB 120,156,156,006,194,098,050,018
   DB 242,020,012,240,126,000,000,000
   DB 000,030,057,032,064,064,064,064 ; Right foot down
   DB 064,096,048,031,126,000,000,000
   DB 000,120,156,004,002,002,002,002
   DB 002,006,012,248,096,060,000,000
   DB 000,001,001,013,030,063,063,063 ; Apple
   DB 063,063,031,015,015,006,000,000
   DB 000,128,000,112,200,228,244,244
   DB 252,252,248,240,240,096,000,000
   DB 000,000,001,001,013,030,060,060 ; Half Split apple
   DB 062,063,062,030,015,007,000,000
   DB 000,000,128,000,056,100,242,250
   DB 122,062,126,124,056,048,000,000
   DB 000,000,000,000,000,050,084,244 ; Fully split apple
   DB 248,252,124,124,062,015,000,000
   DB 000,000,000,000,000,008,014,029
   DB 029,059,062,062,124,120,000,000
    DB 000,000,000,000,000,000,000,000 ; Squished character from apple
    DB 000,000,031,063,031,063,000,000
    DB 000,000,000,000,000,000,000,000
    DB 000,000,248,252,248,252,000,000
    DB 000,000,007,009,018,036,056,039 ; Diamond
    DB 020,018,009,004,002,001,000,000
    DB 000,000,224,144,072,036,028,228
    DB 040,072,144,032,064,128,000,000
    DB 000,000,000,000,000,000,000,001 ; Mr Do Ball
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
   DB 000,000,000,000,000,000,000,001
   DB 000,000,000,016,040,072,136,016
CHERRY_BOTTOM_PAT:
   DB 014,029,031,031,014,000,000,000
   DB 056,116,124,124,056,000,000,000
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
   DB 000,000,000,031,048,033,034,034
   DB 049,016,016,048,096,063,062,000
   DB 000,000,000,240,024,140,068,068
   DB 140,024,016,016,048,224,248,000
HUD_PATS_01:
   DB 000,056,092,240,172,234,218,172 ; Mr. Do extra life sprite
   DB 024,036,122,110,056,028,000,000
    DB 000,000,000,000,001,003,013,030 ; Ice Cream dessert unaligned
    DB 000,000,000,000,128,192,176,120
    DB 000,000,000,003,007,015,031,063
    DB 000,000,000,192,248,248,248,232
    DB 000,000,007,009,018,036,056,039 ; Diamond pieces not lined up
    DB 000,000,224,144,072,036,028,228
    DB 020,018,009,004,002,001,000,000
    DB 040,072,144,032,064,128,000,000
    DB 000,254,128,248,128,128,254,000 ; E
    DB 000,198,108,024,048,108,198,000 ; XTRA
    DB 000,254,016,016,016,016,016,000
    DB 000,252,134,134,252,136,142,000
    DB 000,056,108,198,130,254,130,000
HUD_PATS_02:
    DB 063,043,010,001,001,003,000,000 ; Bottom of Ice Cream, Extra border
    DB 252,180,096,128,128,192,000,000
    DB 255,255,192,192,192,192,192,192
    DB 192,192,192,192,192,192,192,192
    DB 192,192,192,192,192,192,255,255 ; Extra Border Box
    DB 255,255,000,000,000,000,000,000
    DB 000,000,000,000,000,000,255,255
    DB 255,255,003,003,003,003,003,003
    DB 003,003,003,003,003,003,003,003 ; Border box, 1ST Text
    DB 003,003,003,003,003,003,255,255
    DB 033,098,034,033,032,034,113,000
    DB 207,034,002,194,034,034,194,000
    DB 128,000,000,000,000,000,000,000 ; 2ND Text
    DB 114,138,011,050,066,130,250,000
    DB 047,040,040,168,104,040,047,000
    DB 000,128,128,128,128,128,000,000
EXTRA_PATS:
    DB 000,254,128,248,128,128,254,000 ; EXTRA TEXT HUD (RED)
    DB 000,198,108,024,048,108,198,000
    DB 000,254,016,016,016,016,016,000
    DB 000,252,134,134,252,136,142,000
    DB 000,056,108,198,130,254,130,000
PLAYFIELD_PATS:
	DB 030,030,255,255,225,225,255,255 ; Brick pattern
    DB 241,227,199,143,031,062,124,248 ; Diagonal Stripes
    DB 129,066,036,024,024,036,066,129 ; cross hatch
    DB 051,102,204,136,204,102,051,017 ; wavy up/down/vertical
    DB 195,102,060,000,195,102,060,000 ; wavy horizontal
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
    LD      B, OPENING_TUNE_SND_0A    ; Play first part of opening tune
    CALL    PLAY_IT
    LD      B, OPENING_TUNE_SND_0B    ; Play second part of opening tune
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
PLAY_BACKGROUND_TUNE:
    LD      B, BACKGROUND_TUNE_0A ; Play first part of background tune
    CALL    PLAY_IT
    LD      B, BACKGROUND_TUNE_0B ; Play second part of background tune
    CALL    PLAY_IT
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
    LD      (SOUND_BANK_09_RAM), A
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
    DW NEW_WIN_EXTRA_DO_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW NEW_WIN_EXTRA_DO_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW END_OF_ROUND_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW END_OF_ROUND_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW LOSE_LIFE_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW LOSE_LIFE_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW NEW_BLUE_CHOMPER_SOUND_0A
    DW SOUND_BANK_08_RAM
    DW NEW_BLUE_CHOMPER_SOUND_0B
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
    DB 064,056,080,007,099
    ; High C
    DB 064,053,090,007,107
    ; Sec F
    DB 064,160,080,004,099
    ; Sec G
    DB 064,142,080,007,107
    ; SEcond Highest G#
    DB 064,067,080,007,099
    ; B Flat (B5)
    DB 064,119,080,007,107
    ; D# (low)
    DB 064,206,082,007,099
    ; C (low)
    DB 064,086,083,007,080
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
    ; LOW NOTES
    DB 128,106,129,007,163
    DB 128,080,129,007,163
    DB 128,063,129,007,163
    DB 128,053,129,010,170
    DB 128,063,129,007,163
    DB 128,053,129,030,163,144

END_OF_ROUND_TUNE_P2:
    ; HIGH NOTES
    ; C4 Middle
    DB 192,213,064,007,227 ;+3
    ; F4 
    DB 192,160,064,007,227 ;+3
    ; A4
    DB 192,127,064,007,227 ;+3
    ; C5
    DB 192,106,064,010,234 ;+10
    ; A4
    DB 192,127,064,007,227 ;+3
    ; C5
    DB 192,106,064,030,227,080 ;+3

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
    CALL    RESTORE_PLAYFIELD_COLORS
    CALL    PLAY_BACKGROUND_TUNE
LOC_D405:
    CALL    SUB_999F
    JP      LOC_98A5
LOC_D40B:
    LD      A, (DIAMOND_RAM)
    BIT     7, A
    JP      Z, LOC_D3F9
    LD      A, (SOUND_BANK_09_RAM)
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
    DB 064,160,128,007,099
    ; D4 (complements lower F) 10
    DB 064,190,128,007,099
    ; C (complements lower E) 10
    DB 064,142,128,007,099
    ; D4 (complements lower D) 10
    DB 064,160,128,007,099
    ; C4 (complements lower C) 10
    DB 064,168,160,007,099
    ; E5 (complements lower C) 10
    DB 064,071,128,007,099
    ; G on the B 10
    DB 064,190,128,007,099
    ; F on the A 10
    DB 064,160,128,007,099
    ; E on the G 10
    DB 064,169,128,007,099
    ; D on the F 10
    DB 064,190,128,007,099
    ; C on the E 10
    DB 064,213,128,007,099
    ; B on the D 20
    DB 064,160,128,007,099

        ; E2 33
    ; DB 064,169,128,030,106
    ; E4 10
    DB 064,169,128,010,106
    ; E4 10
    DB 064,169,128,007,099
    ; G4 16
    DB 064,142,128,007,099

    ; D4 10
    DB 064,160,128,007,099
    ; F4 10
    DB 064,190,128,007,099
    ; E4 10
    DB 064,142,128,007,099
    ; D4 10
    DB 064,160,128,007,099
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
    DB 064,190,128,007,099,088
    ; B4 (over long D) 20
    ; DB 064,226,128,010,106
    ; B4 (over long D) 20
    ; DB 064,226,128,010,106
NEW_OPENING_TUNE_P2:
    DB 128,170,128,007,163,128,170,128,010,170,128,170,128,007,163,128,190,128,007,163,128
    DB 190,128,010,170,128,190,128,007,163,128,170,128,007,163,128,190,128,007,163,128,214
    DB 128,007,163,128,226,128,007,163,128,214,128,007,163,128,226,128,007,163,128,254,128
    DB 007,163,128,029,129,007,163
NEW_BACKGROUND_TUNE_P2:
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
    DB 128,124,097,007,163
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
    DB 128,064,097,007,163,152

NEW_BLUE_CHOMPER_SOUND_0A:
    ; F3
    DB 064,064,097,007,099
    ; D3
    DB 064,124,097,007,099
    ; B flat 10 (below C4)
    DB 064,238,096,007,099
    ; B flat 10 (below C4)
    DB 064,238,096,007,099
    ; G3
    DB 064,029,097,007,099
    ; B flat 10 (below C4)
    DB 064,238,096,007,099
    ; B flat 10 (below C4)
    DB 064,238,096,007,099
    ; G3
    DB 064,029,097,007,099,088
NEW_BLUE_CHOMPER_SOUND_0B:
    ; D3 20
    DB 128,124,129,010,170
    ; B flat 10
    DB 128,223,129,007,163
    ; D3 10
    DB 128,124,129,007,163
    ; E flat 10
    DB 128,103,129,007,163
    ; B flat 10
    DB 128,223,129,007,163
    ; E flat 10
    DB 128,103,129,007,163,152


NEW_WIN_EXTRA_DO_TUNE_P1:
    ; Long e x2
    DB 064,169,096,010,106 ;20
    DB 064,169,096,010,106 ;20
    ; Short e
    DB 064,169,096,007,099 ;10
    ; Long f
    DB 064,160,096,010,106 ;20
    ; Short f#
    DB 064,151,096,007,099 ;10
    ; Very long g
    DB 064,142,096,030,116 ;50

    ; BEGIN 2

    ; very short gf#g
    DB 064,142,096,007,099 ;10
    DB 064,151,096,007,099 ;10
    DB 064,142,096,007,099 ;10

    ;long a
    DB 064,127,096,010,106 ;20
    ;long a
    DB 064,127,096,010,106 ;20
    ;short a
    DB 064,127,096,007,099 ;10
    ;--------------------------------
    ;long b
    DB 064,113,096,010,106 ;20

    ;short c
    DB 064,106,096,007,099 ;10

    ;very long e
    DB 064,084,096,030,106 ;30 + 10 pad
    ;++++++++++++++++++++++++++++++++

    ; BEGIN 3 (at end of long e)

    DB 116 ; 20 pad






    ; short f (plays over the c pad)
    DB 064,80,096,007,099 ;10 

    ; short e
    DB 064,084,096,007,099 ;10
  



    ; long D
    DB 064,095,096,020,106 ;30

    
    ; short a (over end of long f)
    DB 064,127,080,010,106 ;20

    ; e over 20 pad after long f
    DB 064,084,096,007,099 ;10
    ; d over 20 pad after long f
    DB 064,095,096,007,099 ;10

    ; (((((((())))))))

    ; long c
    DB 064,106,096,020,106 ;30

    ; short g
    DB 064,142,064,010,106 ;20

    ; short f#
    DB 064,151,096,007,099 ;10
    
    ; short g
    DB 064,142,096,007,099 ;10

    ; long a
    DB 064,127,096,010,106 ;20

    ;********************************
    ; long a
    DB 064,127,096,010,106 ;20
    ; short b
    DB 064,113,096,007,099 ;10
    ; long a
    DB 064,127,096,010,106 ;20


    ; short g
    DB 064,142,096,007,099 ;10

    ; very long c
    DB 064,106,096,030,116 ;50
    ; short c
    DB 064,106,096,010,080 ;10

NEW_WIN_EXTRA_DO_TUNE_P2:
    ; C
    DB 128,171,113,007,163 ;10
    ; G
    DB 128,029,113,007,163 ;10
    ; E
    DB 128,083,113,007,163 ;10
    ; G
    DB 128,029,113,007,163 ;10

    ; C
    DB 128,171,113,007,163 ;10
    ; G
    DB 128,029,113,007,163 ;10
    ; E
    DB 128,083,113,007,163 ;10
    ; G
    DB 128,029,113,007,163 ;10

    ; C
    DB 128,171,113,007,163 ;10
    ; G
    DB 128,029,113,007,163 ;10
    ; E
    DB 128,083,113,007,163 ;10
    ; G
    DB 128,029,113,007,163 ;10

    ; C
    DB 128,171,113,007,163 ;10

    ; BEGIN 2
    ; G
    DB 128,029,113,007,163 ;10
    ; E
    DB 128,083,113,007,163 ;10
    ; G
    DB 128,029,113,007,173 ;20

    ; A (over second half of first long a)
    DB 128,254,112,007,163 ;10
    ; Short f (first half of second long a)
    DB 128,064,113,007,163 ;10
    ; A (over second half of second long a)
    DB 128,254,112,007,173 ;20
    ;--------------------------------

    ; short a - long pause
    DB 128,254,112,007,173 ;20

    ; short a - short pause
    DB 128,254,112,007,163 ;10

    ; C
    DB 128,171,113,010,170 ;20

    ; C (up an octave)
    DB 128,106,112,010,170 ;20
 
    ;++++++++++++++++++++++++++++++++



    ; BEGIN 3 (at end of C)

    ; over first half of 20 pad
    ; E
    DB 128,083,113,007,163 ;10

    ; over second half of 20 pad
    ; C
    DB 128,106,112,007,173 ;20


    ; short c (over short e)
    DB 128,106,112,007,163 ;10




    ; very long f (over d and a)
    DB 128,064,113,050,180 ;50 + 20 pad


    ; (((((((())))))))

    ; very long e
    DB 128,083,113,050,190 ;50 + 30 pad

    ; very short a
    DB 128,254,112,007,163 ;10

    ;********************************

    ; short f#
    DB 128,046,113,007,163 ;10
    ; very short a
    DB 128,254,112,007,163 ;10
    ; very short e
    DB 128,083,113,007,163 ;10

    ; short g
    DB 128,029,113,007,163 ;10
    ; short f
    DB 128,064,113,007,163 ;10


    ; complementary G
    DB 128,029,113,010,190 ;40

    ; short c
    DB 128,171,113,010,170 ;20
    ; short c
    DB 128,171,113,010,144 ;10



nmi_handler:
	push af
	push hl
	ld hl,mode
	bit 0,(hl)			; 0 -> ISR Enabled, 1 -> ISR disabled
	jr z,.1
	set 1,(hl)			; ISR not executed
	pop hl
	pop af
	retn

.0:	res 1,(hl)

.1:	
	bit 7,(hl)
	jr z,.2				; 0 -> Game Mode, 1 -> intermission mode

	pop hl
	in a,(CTRL_PORT)
	pop af
	call FakeNmi
	retn
	

.2:	
	pop hl				; Game Mode
	pop af
	jp NMI


FakeNmi:				; Intermission Mode
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
    CALL    TIME_MGR	
    CALL    POLLER	
    CALL    SUB_C952
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
	RET



cvb_ANIMATEDLOGO:
	LD	HL,mode
	SET	7,(hl)							; switch to intermission  mode

	CALL MYMODE2
	CALL MYDISSCR
	CALL cvb_MYCLS
	LD DE,$0000
	LD HL,cvb_TILESET
	CALL unpack		
	LD DE,$1800
	LD HL,cvb_PNT
	CALL unpack		
	LD HL,cvb_COLORSET1
	CALL CLRFRM

	ld a,208
	ld hl,$1b00		; remove all sprites (may be $1900 ??)
	call MYWRTVRM
	
	CALL MYENASCR
	; 
	CALL cvb_MYPAUSE
	; 	
	LD HL,cvb_COLORSET1
	CALL CLRFRM
	LD HL,cvb_COLORSET2
	CALL CLRFRM
	LD HL,cvb_COLORSET3
	CALL CLRFRM
	LD HL,cvb_COLORSET4
	CALL CLRFRM
	LD HL,cvb_COLORSET5
	CALL CLRFRM
	LD HL,cvb_COLORSET6
	CALL CLRFRM
	; 
	; 	FOR T=0 TO 10
	LD	B,10
.MyNext:
	PUSH BC
	
	LD HL,cvb_COLORSET7
	CALL CLRFRM
	LD HL,cvb_COLORSET8
	CALL CLRFRM
	LD HL,cvb_COLORSET9
	CALL CLRFRM	
	LD HL,cvb_COLORSET10
	CALL CLRFRM
	LD HL,cvb_COLORSET11
	CALL CLRFRM
	LD HL,cvb_COLORSET12
	CALL CLRFRM
	
	; 	NEXT
	POP BC
	DJNZ .MyNext

	LD	HL,mode
	RES	7,(hl)						; switch to game mode

	RET

CLRFRM:
	HALT
	HALT
	HALT
	HALT
	LD BC,18
	LD DE,$2000
	CALL MyNMI_off
	CALL MYLDIRVM
	JP MyNMI_on

cvb_MYPAUSE:
	; 	FOR T=0 TO 120:WAIT: NEXT
	LD B,120
cv3:
	HALT
	djnz cv3
	RET

	; MAKE SURE TO BE IN INTERMISSION MODE BEFORE CALLING
	
cvb_EXTRASCREEN:
	CALL MYMODE1
	CALL MYDISSCR
	CALL cvb_MYCLS

;	LD	HL,0
;	PUSH HL
;	LD A,204
;	LD HL,cvb_IMAGE_CHAR
;	CALL define_char_unpack				; 	DEFINE CHAR PLETTER 0,204,image_char
;
;	LD	HL,0
;	PUSH HL
;	LD A,204
;	LD HL,cvb_IMAGE_COLOR
;	CALL define_color_unpack			; 	DEFINE COLOR PLETTER 0,204,image_color

	LD DE,$0000
	LD HL,cvb_IMAGE_CHAR
	CALL unpack			

	LD DE,$2000
	LD HL,cvb_IMAGE_COLOR
	CALL unpack			

	LD DE,$3800
	LD HL,cvb_IMAGE_SPRITES
	CALL unpack							; 	DEFINE SPRITE PLETTER 0,24,image_sprites

	LD HL,cvb_IMAGE_PATTERN
	LD DE,$1805
	CALL CPYBLK22x24

	LD BC,128
	LD DE,$1B00
	LD HL,cvb_SPRITE_OVERLAY
	CALL MyNMI_off	
	CALL MYLDIRVM
	CALL MyNMI_on
	
	CALL MYENASCR
	
	RET


MyNMI_off:
	push hl
	ld hl,mode
	set 0,(hl)
	pop hl
	ret

MyNMI_on:
	push af
	push hl
	ld hl,mode
	res 0,(hl)
	nop
	bit 1,(hl)
	jp nz,nmi_handler.0
	pop hl
	pop af
	ret
	
cvb_MYCLS:
	ld hl,$1800
	ld bc,$0300
	xor a
	CALL MyNMI_off
	push af
    LD A,L
    OUT (CTRL_PORT),A
    LD A,H
    AND 3Fh
    OR 40h
    OUT (CTRL_PORT),A
	pop af
	dec bc		; T-states (normal / M1)
.1:	out (DATA_PORT),a	; 11 12
	dec bc		;  6  7
	bit 7,b		;  8 10
	jp z,.1		; 10 11

	jp MyNMI_on


	;	HL->ROM
	;	DE->VRAM

CPYBLK22x24:
	CALL MyNMI_off
	ld b,24
.1:	push bc

	push hl
	push de
	ld bc,22
	CALL MYLDIRVM
	pop de
	pop hl
	ld bc,22
	add hl,bc

	ex de,hl
	ld bc,32
	add hl,bc
	ex de,hl

	pop bc
	djnz .1
	jp MyNMI_on	

; BIOS HELPER CODE
MYWRTVDP:
	ld a,b
	out (CTRL_PORT),a
	ld a,c
	or $80
	out (CTRL_PORT),a
	ret
	
MYMODE1:
	ld hl,mode
	res 3,(hl)
	ld bc,$0200
;	ld de,$ff03	; $2000 for color table, $0000 for bitmaps.
	ld de,$9F00	; $2000 for color table, $0000 for bitmaps.
	jp vdp_chg_mode

MYMODE2:
	ld hl,mode
	set 3,(hl)
	ld bc,$0000
	ld de,$8000	; $2000 for color table, $0000 for bitmaps.

vdp_chg_mode:
	call MyNMI_off
	call MYWRTVDP
	ld bc,$a201
	call MYWRTVDP
	ld bc,$0602	; $1800 for pattern table.
	call MYWRTVDP
	ld b,d
	ld c,$03	; for color table.
	call MYWRTVDP
	ld b,e
	ld c,$04	; for bitmap table.
	call MYWRTVDP
	ld bc,$3605	; $1b00 for sprite attribute table.
	call MYWRTVDP
	ld bc,$0706	; $3800 for sprites bitmaps.
	call MYWRTVDP
	ld bc,$0107
	jp MYWRTVDP

MYDISSCR:
	CALL MyNMI_off
	ld a,$a2
	out (CTRL_PORT),a
	ld a,$81
	out (CTRL_PORT),a
	jp MyNMI_on

MYENASCR:
	CALL MyNMI_off
	ld a,$e2
	out (CTRL_PORT),a
	ld a,$81
	out (CTRL_PORT),a
	jp MyNMI_on

MYLDIRVM:
	ld a,e
	out (CTRL_PORT),a
	ld a,d
	or $40
	out (CTRL_PORT),a
	dec bc
	inc c
	ld a,b
	ld b,c
	inc a
	ld c,DATA_PORT
.1:
	outi
	jp nz,.1
	dec a
	jp nz,.1
	ret
	
MYRDVRM:
	push af
	ld a,l
	out (CTRL_PORT),a
	ld a,h
	and $3f
	out (CTRL_PORT),a
	pop af
	ex (sp),hl
	ex (sp),hl
	in a,(DATA_PORT)
	ret
	
MYWRTVRM:
	push af
	ld a,l
	out (CTRL_PORT),a
	ld a,h
	or $40
	out (CTRL_PORT),a
	pop af
	out (DATA_PORT),a
	ret


;define_char_unpack:
;	ex de,hl
;	pop af
;	pop hl
;	push af
;	add hl,hl	; x2
;	add hl,hl	; x4
;	add hl,hl	; x8
;	ex de,hl
;	ld a,(mode)
;	and 8
;	jp z,unpack3
;	jp unpack
;
;define_color_unpack:
;	ex de,hl
;	pop af
;	pop hl
;	push af
;	add hl,hl	; x2
;	add hl,hl	; x4
;	add hl,hl	; x8
;	ex de,hl
;	set 5,d
;unpack3:
;	CALL .1
;	CALL .1
;.1:
;	push de
;	push hl
;	CALL unpack
;	pop hl
;	pop de
;	ld a,d
;	add a,8	
;	ld d,a
;	ret

        ;
        ; Pletter-0.5c decompressor (XL2S Entertainment & Team Bomba)
        ;
unpack:
; Initialization
	ld a,(hl)
	inc hl
	exx
	ld de,0
	add a,a
	inc a
	rl e
	add a,a
	rl e
	add a,a
	rl e
	rl e
	ld hl,.modes
	add hl,de
	ld c,(hl)
	inc hl
	ld b,(hl)
	push bc
	pop ix
	ld e,1
	exx
	ld iy,.loop

; Main depack loop
.literal:
	ex af,af'
	CALL MyNMI_off
	ld a,(hl)
	ex de,hl
	CALL MYWRTVRM
	ex de,hl
	inc hl
	inc de
	CALL MyNMI_on
	ex af,af'
.loop:   add a,a
	CALL z,.getbit
	jr nc,.literal

; Compressed data
	exx
	ld h,d
	ld l,e
.getlen: add a,a
	CALL z,.getbitexx
	jr nc,.lenok
.lus:    add a,a
	CALL z,.getbitexx
	adc hl,hl
	ret c   
	add a,a
	CALL z,.getbitexx
	jr nc,.lenok
	add a,a
	CALL z,.getbitexx
	adc hl,hl
	ret c  
	add a,a
	CALL z,.getbitexx
	jr c,.lus
.lenok:  inc hl
	exx
	ld c,(hl)
	inc hl
	ld b,0
	bit 7,c
	jr z,.offsok
	jp (ix)

.mode6:  add a,a
	CALL z,.getbit
	rl b
.mode5:  add a,a
	CALL z,.getbit
	rl b
.mode4:  add a,a
	CALL z,.getbit
	rl b
.mode3:  add a,a
	CALL z,.getbit
	rl b
.mode2:  add a,a
	CALL z,.getbit
	rl b
	add a,a
	CALL z,.getbit
	jr nc,.offsok
	or a
	inc b
	res 7,c
.offsok: inc bc
	push hl
	exx
	push hl
	exx
	ld l,e
	ld h,d
	sbc hl,bc
	pop bc
	ex af,af'
.loop2: 
	CALL MyNMI_off
	CALL MYRDVRM              ; unpack
	ex de,hl
	CALL MYWRTVRM
	ex de,hl        ; 4
	CALL MyNMI_on
	inc hl          ; 6
	inc de          ; 6
	dec bc          ; 6
	ld a,b          ; 4
	or c            ; 4
	jr nz,.loop2     ; 10
	ex af,af'
	pop hl
	jp (iy)

.getbit: ld a,(hl)
	inc hl
	rla
	ret

.getbitexx:
	exx
	ld a,(hl)
    inc hl
	exx
	rla
	ret

.modes:
	dw      .offsok
	dw      .mode2
	dw      .mode3
	dw      .mode4
	dw      .mode5
	dw      .mode6


	; 	
	; 	' Start tile = 0. Total_tiles = 204
	; image_char:
cvb_IMAGE_CHAR:
	; 	DATA BYTE $3e,$00,$3e,$00,$ff,$00,$02,$7e
	DB $3e,$00,$3e,$00,$ff,$00,$02,$7e
	; 	DATA BYTE $c0,$80,$80,$c0,$7e,$07,$02,$7c
	DB $c0,$80,$80,$c0,$7e,$07,$02,$7c
	; 	DATA BYTE $c6,$82,$82,$c6,$7c,$07,$03,$c2
	DB $c6,$82,$82,$c6,$7c,$07,$03,$c2
	; 	DATA BYTE $e2,$b2,$9a,$8e,$86,$86,$0f,$80
	DB $e2,$b2,$9a,$8e,$86,$86,$0f,$80
	; 	DATA BYTE $8e,$c2,$01,$17,$fc,$86,$86,$fc
	DB $8e,$c2,$01,$17,$fc,$86,$86,$fc
	; 	DATA BYTE $88,$8e,$11,$07,$38,$6c,$20,$fe
	DB $88,$8e,$11,$07,$38,$6c,$20,$fe
	; 	DATA BYTE $82,$1d,$07,$fe,$10,$00,$5b,$07
	DB $82,$1d,$07,$fe,$10,$00,$5b,$07
	; 	DATA BYTE $2d,$39,$2f,$80,$00,$fe,$9c,$1f
	DB $2d,$39,$2f,$80,$00,$fe,$9c,$1f
	; 	DATA BYTE $16,$38,$e3,$37,$70,$1c,$00,$17
	DB $16,$38,$e3,$37,$70,$1c,$00,$17
	; 	DATA BYTE $7d,$39,$93,$c7,$ef,$ef,$84,$0e
	DB $7d,$39,$93,$c7,$ef,$ef,$84,$0e
	; 	DATA BYTE $83,$39,$7d,$0a,$83,$af,$07,$05
	DB $83,$39,$7d,$0a,$83,$af,$07,$05
	; 	DATA BYTE $82,$07,$6d,$45,$11,$bb,$07,$c9
	DB $82,$07,$6d,$45,$11,$bb,$07,$c9
	; 	DATA BYTE $1c,$00,$c7,$01,$07,$3d,$1d,$4d
	DB $1c,$00,$c7,$01,$07,$3d,$1d,$4d
	; 	DATA BYTE $65,$71,$79,$a8,$8d,$3e,$41,$95
	DB $65,$71,$79,$a8,$8d,$3e,$41,$95
	; 	DATA BYTE $3c,$07,$40,$07,$5b,$bf,$83,$bf
	DB $3c,$07,$40,$07,$5b,$bf,$83,$bf
	; 	DATA BYTE $bf,$80,$00,$ff,$9c,$88,$c1,$e3
	DB $bf,$80,$00,$ff,$9c,$88,$c1,$e3
	; 	DATA BYTE $e7,$c9,$9c,$c7,$6e,$f7,$00,$00
	DB $e7,$c9,$9c,$c7,$6e,$f7,$00,$00
	; 	DATA BYTE $ff,$81,$80,$bc,$80,$81,$bb,$00
	DB $ff,$81,$80,$bc,$80,$81,$bb,$00
	; 	DATA BYTE $b8,$ff,$e3,$c1,$88,$9c,$be,$80
	DB $b8,$ff,$e3,$c1,$88,$9c,$be,$80
	; 	DATA BYTE $00,$be,$ff,$63,$77,$7f,$5d,$49
	DB $00,$be,$ff,$63,$77,$7f,$5d,$49
	; 	DATA BYTE $41,$40,$41,$3f,$40,$40,$5e,$73
	DB $41,$40,$41,$3f,$40,$40,$5e,$73
	; 	DATA BYTE $40,$b6,$00,$3e,$0e,$60,$60,$43
	DB $40,$b6,$00,$3e,$0e,$60,$60,$43
	; 	DATA BYTE $41,$00,$42,$43,$4f,$3c,$26,$63
	DB $41,$00,$42,$43,$4f,$3c,$26,$63
	; 	DATA BYTE $07,$00,$63,$3e,$07,$0f,$0f,$0e
	DB $07,$00,$63,$3e,$07,$0f,$0f,$0e
	; 	DATA BYTE $0c,$08,$bc,$17,$5f,$69,$01,$05
	DB $0c,$08,$bc,$17,$5f,$69,$01,$05
	; 	DATA BYTE $3c,$13,$80,$0e,$46,$03,$03,$f8
	DB $3c,$13,$80,$0e,$46,$03,$03,$f8
	; 	DATA BYTE $e0,$30,$62,$a6,$0c,$7f,$3f,$1b
	DB $e0,$30,$62,$a6,$0c,$7f,$3f,$1b
	; 	DATA BYTE $3f,$bf,$9f,$1b,$17,$02,$07,$08
	DB $3f,$bf,$9f,$1b,$17,$02,$07,$08
	; 	DATA BYTE $07,$e0,$f0,$03,$40,$fb,$fb,$00
	DB $07,$e0,$f0,$03,$40,$fb,$fb,$00
	; 	DATA BYTE $f3,$e7,$ef,$c0,$c0,$e0,$60,$70
	DB $f3,$e7,$ef,$c0,$c0,$e0,$60,$70
	; 	DATA BYTE $18,$70,$38,$b8,$14,$1c,$00,$3e
	DB $18,$70,$38,$b8,$14,$1c,$00,$3e
	; 	DATA BYTE $bf,$3f,$7f,$f8,$f0,$e0,$08,$00
	DB $bf,$3f,$7f,$f8,$f0,$e0,$08,$00
	; 	DATA BYTE $08,$0f,$9f,$cf,$6e,$4e,$de,$9e
	DB $08,$0f,$9f,$cf,$6e,$4e,$de,$9e
	; 	DATA BYTE $20,$be,$3e,$6e,$df,$cf,$c7,$e7
	DB $20,$be,$3e,$6e,$df,$cf,$c7,$e7
	; 	DATA BYTE $04,$e7,$f3,$fd,$71,$07,$2f,$3f
	DB $04,$e7,$f3,$fd,$71,$07,$2f,$3f
	; 	DATA BYTE $80,$1d,$7f,$ff,$f0,$f8,$fc,$fc
	DB $80,$1d,$7f,$ff,$f0,$f8,$fc,$fc
	; 	DATA BYTE $4d,$f8,$04,$fe,$06,$46,$30,$78
	DB $4d,$f8,$04,$fe,$06,$46,$30,$78
	; 	DATA BYTE $7c,$93,$07,$12,$e0,$6f,$76,$ab
	DB $7c,$93,$07,$12,$e0,$6f,$76,$ab
	; 	DATA BYTE $8f,$73,$63,$06,$08,$18,$23,$14
	DB $8f,$73,$63,$06,$08,$18,$23,$14
	; 	DATA BYTE $8c,$06,$3b,$cf,$df,$9f,$40,$5d
	DB $8c,$06,$3b,$cf,$df,$9f,$40,$5d
	; 	DATA BYTE $00,$b8,$bc,$9d,$dd,$df,$b5,$00
	DB $00,$b8,$bc,$9d,$dd,$df,$b5,$00
	; 	DATA BYTE $1c,$a8,$da,$51,$c0,$8d,$a0,$4e
	DB $1c,$a8,$da,$51,$c0,$8d,$a0,$4e
	; 	DATA BYTE $07,$03,$01,$99,$96,$c3,$61,$79
	DB $07,$03,$01,$99,$96,$c3,$61,$79
	; 	DATA BYTE $82,$75,$11,$0f,$35,$dd,$46,$1f
	DB $82,$75,$11,$0f,$35,$dd,$46,$1f
	; 	DATA BYTE $17,$cb,$76,$78,$72,$bd,$55,$7e
	DB $17,$cb,$76,$78,$72,$bd,$55,$7e
	; 	DATA BYTE $55,$1c,$a3,$0b,$f0,$c9,$16,$79
	DB $55,$1c,$a3,$0b,$f0,$c9,$16,$79
	; 	DATA BYTE $c1,$e6,$07,$d1,$28,$ac,$1b,$4d
	DB $c1,$e6,$07,$d1,$28,$ac,$1b,$4d
	; 	DATA BYTE $c0,$fc,$7d,$1b,$09,$07,$89,$7f
	DB $c0,$fc,$7d,$1b,$09,$07,$89,$7f
	; 	DATA BYTE $0f,$00,$06,$83,$f1,$f9,$fd,$3c
	DB $0f,$00,$06,$83,$f1,$f9,$fd,$3c
	; 	DATA BYTE $1c,$1e,$46,$1e,$e5,$d4,$1f,$8b
	DB $1c,$1e,$46,$1e,$e5,$d4,$1f,$8b
	; 	DATA BYTE $c1,$c0,$90,$f3,$e3,$57,$81,$20
	DB $c1,$c0,$90,$f3,$e3,$57,$81,$20
	; 	DATA BYTE $21,$b0,$c0,$ff,$3b,$f9,$f0,$6d
	DB $21,$b0,$c0,$ff,$3b,$f9,$f0,$6d
	; 	DATA BYTE $93,$73,$3f,$bb,$80,$45,$38,$18
	DB $93,$73,$3f,$bb,$80,$45,$38,$18
	; 	DATA BYTE $90,$d0,$d0,$10,$21,$92,$d0,$0b
	DB $90,$d0,$d0,$10,$21,$92,$d0,$0b
	; 	DATA BYTE $f0,$c0,$07,$9c,$24,$c1,$f0,$be
	DB $f0,$c0,$07,$9c,$24,$c1,$f0,$be
	; 	DATA BYTE $f8,$98,$16,$c0,$00,$13,$79,$1f
	DB $f8,$98,$16,$c0,$00,$13,$79,$1f
	; 	DATA BYTE $0f,$00,$07,$38,$72,$36,$fe,$03
	DB $0f,$00,$07,$38,$72,$36,$fe,$03
	; 	DATA BYTE $e2,$c3,$76,$7d,$03,$22,$93,$62
	DB $e2,$c3,$76,$7d,$03,$22,$93,$62
	; 	DATA BYTE $8f,$3e,$90,$4f,$87,$1f,$1d,$15
	DB $8f,$3e,$90,$4f,$87,$1f,$1d,$15
	; 	DATA BYTE $fc,$2a,$a1,$b7,$00,$4f,$22,$62
	DB $fc,$2a,$a1,$b7,$00,$4f,$22,$62
	; 	DATA BYTE $e2,$e2,$f2,$f2,$f0,$00,$7c,$1f
	DB $e2,$e2,$f2,$f2,$f0,$00,$7c,$1f
	; 	DATA BYTE $07,$81,$c1,$c4,$c7,$0f,$e3,$9e
	DB $07,$81,$c1,$c4,$c7,$0f,$e3,$9e
	; 	DATA BYTE $27,$64,$92,$cf,$c8,$2a,$00,$5e
	DB $27,$64,$92,$cf,$c8,$2a,$00,$5e
	; 	DATA BYTE $03,$2d,$f3,$4f,$03,$1f,$c0,$c1
	DB $03,$2d,$f3,$4f,$03,$1f,$c0,$c1
	; 	DATA BYTE $f1,$81,$29,$fc,$72,$90,$e0,$bb
	DB $f1,$81,$29,$fc,$72,$90,$e0,$bb
	; 	DATA BYTE $40,$16,$88,$9e,$0f,$72,$38,$68
	DB $40,$16,$88,$9e,$0f,$72,$38,$68
	; 	DATA BYTE $2b,$c6,$c4,$ff,$0e,$1c,$11,$07
	DB $2b,$c6,$c4,$ff,$0e,$1c,$11,$07
	; 	DATA BYTE $1f,$7c,$b0,$cf,$af,$9c,$a1,$a0
	DB $1f,$7c,$b0,$cf,$af,$9c,$a1,$a0
	; 	DATA BYTE $78,$fb,$4d,$dd,$fd,$02,$1c,$0e
	DB $78,$fb,$4d,$dd,$fd,$02,$1c,$0e
	; 	DATA BYTE $06,$f1,$f0,$e4,$78,$00,$c7,$b0
	DB $06,$f1,$f0,$e4,$78,$00,$c7,$b0
	; 	DATA BYTE $74,$f0,$00,$d2,$11,$50,$78,$c0
	DB $74,$f0,$00,$d2,$11,$50,$78,$c0
	; 	DATA BYTE $34,$00,$74,$5e,$53,$3f,$00,$74
	DB $34,$00,$74,$5e,$53,$3f,$00,$74
	; 	DATA BYTE $1f,$e7,$92,$8d,$ab,$95,$d9,$81
	DB $1f,$e7,$92,$8d,$ab,$95,$d9,$81
	; 	DATA BYTE $59,$e0,$71,$9f,$f1,$f3,$92,$bf
	DB $59,$e0,$71,$9f,$f1,$f3,$92,$bf
	; 	DATA BYTE $e3,$c3,$00,$cd,$1b,$0b,$00,$11
	DB $e3,$c3,$00,$cd,$1b,$0b,$00,$11
	; 	DATA BYTE $05,$ce,$cd,$36,$02,$e0,$18,$19
	DB $05,$ce,$cd,$36,$02,$e0,$18,$19
	; 	DATA BYTE $8a,$02,$30,$60,$40,$c0,$c7,$0c
	DB $8a,$02,$30,$60,$40,$c0,$c7,$0c
	; 	DATA BYTE $e3,$e7,$81,$05,$07,$e3,$e0,$5a
	DB $e3,$e7,$81,$05,$07,$e3,$e0,$5a
	; 	DATA BYTE $58,$94,$4e,$0c,$3e,$7f,$3f,$51
	DB $58,$94,$4e,$0c,$3e,$7f,$3f,$51
	; 	DATA BYTE $68,$06,$00,$0e,$5f,$0c,$de,$46
	DB $68,$06,$00,$0e,$5f,$0c,$de,$46
	; 	DATA BYTE $00,$3f,$f8,$78,$06,$00,$38,$3c
	DB $00,$3f,$f8,$78,$06,$00,$38,$3c
	; 	DATA BYTE $3c,$74,$17,$00,$70,$30,$00,$7d
	DB $3c,$74,$17,$00,$70,$30,$00,$7d
	; 	DATA BYTE $fc,$00,$f5,$2f,$a4,$c4,$90,$50
	DB $fc,$00,$f5,$2f,$a4,$c4,$90,$50
	; 	DATA BYTE $7f,$58,$18,$b4,$30,$78,$79,$43
	DB $7f,$58,$18,$b4,$30,$78,$79,$43
	; 	DATA BYTE $33,$9d,$8f,$12,$f4,$f0,$70,$ab
	DB $33,$9d,$8f,$12,$f4,$f0,$70,$ab
	; 	DATA BYTE $10,$e7,$00,$e3,$c1,$c1,$c7,$d9
	DB $10,$e7,$00,$e3,$c1,$c1,$c7,$d9
	; 	DATA BYTE $4d,$00,$1b,$ef,$0e,$32,$04,$c9
	DB $4d,$00,$1b,$ef,$0e,$32,$04,$c9
	; 	DATA BYTE $00,$f9,$40,$60,$38,$bf,$ff,$df
	DB $00,$f9,$40,$60,$38,$bf,$ff,$df
	; 	DATA BYTE $cf,$09,$cf,$03,$0f,$7f,$1f,$8f
	DB $cf,$09,$cf,$03,$0f,$7f,$1f,$8f
	; 	DATA BYTE $df,$73,$05,$4d,$60,$f0,$18,$18
	DB $df,$73,$05,$4d,$60,$f0,$18,$18
	; 	DATA BYTE $62,$4d,$00,$8c,$71,$dd,$00,$e7
	DB $62,$4d,$00,$8c,$71,$dd,$00,$e7
	; 	DATA BYTE $77,$00,$db,$1f,$5a,$b8,$20,$ed
	DB $77,$00,$db,$1f,$5a,$b8,$20,$ed
	; 	DATA BYTE $03,$ef,$8f,$c7,$c3,$09,$e1,$c1
	DB $03,$ef,$8f,$c7,$c3,$09,$e1,$c1
	; 	DATA BYTE $7f,$1e,$5d,$7f,$18,$6e,$3f,$e0
	DB $7f,$1e,$5d,$7f,$18,$6e,$3f,$e0
	; 	DATA BYTE $d5,$16,$1c,$08,$a4,$18,$66,$10
	DB $d5,$16,$1c,$08,$a4,$18,$66,$10
	; 	DATA BYTE $6e,$63,$41,$af,$1e,$12,$f0,$fc
	DB $6e,$63,$41,$af,$1e,$12,$f0,$fc
	; 	DATA BYTE $51,$9d,$0b,$9f,$9f,$1a,$2e,$70
	DB $51,$9d,$0b,$9f,$9f,$1a,$2e,$70
	; 	DATA BYTE $1f,$39,$b2,$c1,$74,$1f,$76,$f0
	DB $1f,$39,$b2,$c1,$74,$1f,$76,$f0
	; 	DATA BYTE $a6,$21,$22,$60,$6c,$84,$83,$07
	DB $a6,$21,$22,$60,$6c,$84,$83,$07
	; 	DATA BYTE $8e,$f0,$de,$b6,$ce,$54,$e3,$04
	DB $8e,$f0,$de,$b6,$ce,$54,$e3,$04
	; 	DATA BYTE $78,$78,$d2,$87,$d3,$a4,$c0,$d3
	DB $78,$78,$d2,$87,$d3,$a4,$c0,$d3
	; 	DATA BYTE $3e,$0c,$22,$04,$fc,$9d,$2d,$75
	DB $3e,$0c,$22,$04,$fc,$9d,$2d,$75
	; 	DATA BYTE $c0,$20,$2b,$b4,$b5,$38,$3e,$70
	DB $c0,$20,$2b,$b4,$b5,$38,$3e,$70
	; 	DATA BYTE $f8,$94,$1b,$3f,$8f,$93,$24,$fa
	DB $f8,$94,$1b,$3f,$8f,$93,$24,$fa
	; 	DATA BYTE $f7,$3f,$86,$54,$fa,$9b,$fd,$f0
	DB $f7,$3f,$86,$54,$fa,$9b,$fd,$f0
	; 	DATA BYTE $e2,$1f,$c6,$60,$8f,$a8,$2f,$64
	DB $e2,$1f,$c6,$60,$8f,$a8,$2f,$64
	; 	DATA BYTE $a3,$24,$00,$87,$e0,$f0,$ce,$0b
	DB $a3,$24,$00,$87,$e0,$f0,$ce,$0b
	; 	DATA BYTE $56,$a8,$04,$b8,$63,$01,$e9,$5a
	DB $56,$a8,$04,$b8,$63,$01,$e9,$5a
	; 	DATA BYTE $ec,$b2,$79,$f8,$6c,$1f,$c6,$31
	DB $ec,$b2,$79,$f8,$6c,$1f,$c6,$31
	; 	DATA BYTE $7f,$7f,$01,$c0,$22,$81,$c1,$3c
	DB $7f,$7f,$01,$c0,$22,$81,$c1,$3c
	; 	DATA BYTE $60,$f8,$14,$ec,$c4,$13,$93,$70
	DB $60,$f8,$14,$ec,$c4,$13,$93,$70
	; 	DATA BYTE $13,$78,$30,$ff,$1f,$3f,$cf,$b8
	DB $13,$78,$30,$ff,$1f,$3f,$cf,$b8
	; 	DATA BYTE $24,$a4,$7c,$a3,$ce,$07,$1d,$96
	DB $24,$a4,$7c,$a3,$ce,$07,$1d,$96
	; 	DATA BYTE $79,$3f,$c0,$b0,$60,$e0,$f8,$e0
	DB $79,$3f,$c0,$b0,$60,$e0,$f8,$e0
	; 	DATA BYTE $96,$5c,$f9,$74,$05,$3e,$81,$81
	DB $96,$5c,$f9,$74,$05,$3e,$81,$81
	; 	DATA BYTE $83,$c7,$31,$1a,$ca,$59,$cf,$85
	DB $83,$c7,$31,$1a,$ca,$59,$cf,$85
	; 	DATA BYTE $85,$3c,$7e,$7e,$3c,$31,$59,$06
	DB $85,$3c,$7e,$7e,$3c,$31,$59,$06
	; 	DATA BYTE $00,$37,$71,$25,$89,$69,$34,$d4
	DB $00,$37,$71,$25,$89,$69,$34,$d4
	; 	DATA BYTE $31,$1c,$c1,$54,$60,$13,$08,$bc
	DB $31,$1c,$c1,$54,$60,$13,$08,$bc
	; 	DATA BYTE $4e,$02,$01,$ae,$09,$40,$e0,$37
	DB $4e,$02,$01,$ae,$09,$40,$e0,$37
	; 	DATA BYTE $d8,$c6,$f3,$03,$12,$1f,$ef,$e7
	DB $d8,$c6,$f3,$03,$12,$1f,$ef,$e7
	; 	DATA BYTE $e1,$0f,$e2,$ce,$48,$e3,$e5,$67
	DB $e1,$0f,$e2,$ce,$48,$e3,$e5,$67
	; 	DATA BYTE $8c,$c0,$f4,$fc,$f8,$5f,$60,$48
	DB $8c,$c0,$f4,$fc,$f8,$5f,$60,$48
	; 	DATA BYTE $40,$a1,$fe,$7e,$3e,$1c,$fc,$31
	DB $40,$a1,$fe,$7e,$3e,$1c,$fc,$31
	; 	DATA BYTE $04,$ff,$84,$eb,$fe,$9b,$61,$d0
	DB $04,$ff,$84,$eb,$fe,$9b,$61,$d0
	; 	DATA BYTE $58,$8c,$93,$f1,$d8,$f7,$f0,$b0
	DB $58,$8c,$93,$f1,$d8,$f7,$f0,$b0
	; 	DATA BYTE $97,$f8,$99,$87,$e4,$bb,$73,$67
	DB $97,$f8,$99,$87,$e4,$bb,$73,$67
	; 	DATA BYTE $c9,$17,$30,$e0,$97,$00,$35,$ff
	DB $c9,$17,$30,$e0,$97,$00,$35,$ff
	; 	DATA BYTE $ff,$ff,$fe
	DB $ff,$ff,$fe
	; 
	; image_color:
cvb_IMAGE_COLOR:
	; 	DATA BYTE $3e,$f1,$3e,$00,$51,$00,$69,$b5
	DB $3e,$f1,$3e,$00,$51,$00,$69,$b5
	; 	DATA BYTE $00,$ba,$b7,$07,$bb,$3f,$00,$a5
	DB $00,$ba,$b7,$07,$bb,$3f,$00,$a5
	; 	DATA BYTE $b7,$07,$53,$38,$cf,$00,$bd,$08
	DB $b7,$07,$53,$38,$cf,$00,$bd,$08
	; 	DATA BYTE $bb,$15,$17,$db,$00,$c7,$36,$c5
	DB $bb,$15,$17,$db,$00,$c7,$36,$c5
	; 	DATA BYTE $8f,$07,$c1,$1b,$0e,$c5,$5e,$0d
	DB $8f,$07,$c1,$1b,$0e,$c5,$5e,$0d
	; 	DATA BYTE $00,$c7,$5d,$85,$85,$c9,$07,$c5
	DB $00,$c7,$5d,$85,$85,$c9,$07,$c5
	; 	DATA BYTE $00,$c1,$bd,$00,$df,$2d,$7e,$07
	DB $00,$c1,$bd,$00,$df,$2d,$7e,$07
	; 	DATA BYTE $72,$17,$2f,$81,$31,$ef,$00,$bc
	DB $72,$17,$2f,$81,$31,$ef,$00,$bc
	; 	DATA BYTE $07,$47,$ef,$07,$4a,$00,$8f,$fe
	DB $07,$47,$ef,$07,$4a,$00,$8f,$fe
	; 	DATA BYTE $cd,$2c,$03,$69,$ef,$6c,$59,$00
	DB $cd,$2c,$03,$69,$ef,$6c,$59,$00
	; 	DATA BYTE $ca,$9e,$00,$09,$07,$a1,$ca,$81
	DB $ca,$9e,$00,$09,$07,$a1,$ca,$81
	; 	DATA BYTE $00,$c8,$d8,$00,$07,$a8,$c7,$00
	DB $00,$c8,$d8,$00,$07,$a8,$c7,$00
	; 	DATA BYTE $a1,$8e,$07,$a8,$7b,$ee,$00,$55
	DB $a1,$8e,$07,$a8,$7b,$ee,$00,$55
	; 	DATA BYTE $ef,$4e,$eb,$52,$79,$db,$07,$be
	DB $ef,$4e,$eb,$52,$79,$db,$07,$be
	; 	DATA BYTE $27,$07,$ed,$09,$c3,$fd,$71,$bd
	DB $27,$07,$ed,$09,$c3,$fd,$71,$bd
	; 	DATA BYTE $3e,$a1,$a1,$10,$ae,$05,$7e,$00
	DB $3e,$a1,$a1,$10,$ae,$05,$7e,$00
	; 	DATA BYTE $fe,$a8,$34,$14,$f2,$07,$9d,$3c
	DB $fe,$a8,$34,$14,$f2,$07,$9d,$3c
	; 	DATA BYTE $0f,$ed,$0b,$0c,$95,$05,$e2,$a0
	DB $0f,$ed,$0b,$0c,$95,$05,$e2,$a0
	; 	DATA BYTE $46,$e3,$a7,$42,$a9,$21,$6c,$c8
	DB $46,$e3,$a7,$42,$a9,$21,$6c,$c8
	; 	DATA BYTE $bf,$65,$08,$36,$73,$03,$24,$a1
	DB $bf,$65,$08,$36,$73,$03,$24,$a1
	; 	DATA BYTE $bc,$04,$00,$fb,$3f,$63,$5d,$fc
	DB $bc,$04,$00,$fb,$3f,$63,$5d,$fc
	; 	DATA BYTE $f1,$5b,$07,$c7,$84,$c7,$21,$a8
	DB $f1,$5b,$07,$c7,$84,$c7,$21,$a8
	; 	DATA BYTE $d7,$00,$55,$9d,$04,$61,$cf,$9c
	DB $d7,$00,$55,$9d,$04,$61,$cf,$9c
	; 	DATA BYTE $db,$00,$5d,$39,$16,$12,$77,$2f
	DB $db,$00,$5d,$39,$16,$12,$77,$2f
	; 	DATA BYTE $64,$71,$13,$63,$a8,$ca,$ad,$00
	DB $64,$71,$13,$63,$a8,$ca,$ad,$00
	; 	DATA BYTE $d1,$5c,$00,$f8,$f8,$cc,$03,$f8
	DB $d1,$5c,$00,$f8,$f8,$cc,$03,$f8
	; 	DATA BYTE $3f,$d3,$04,$71,$07,$fc,$e7,$00
	DB $3f,$d3,$04,$71,$07,$fc,$e7,$00
	; 	DATA BYTE $df,$2f,$6d,$3b,$55,$77,$07,$79
	DB $df,$2f,$6d,$3b,$55,$77,$07,$79
	; 	DATA BYTE $6b,$08,$77,$71,$00,$8b,$0b,$c8
	DB $6b,$08,$77,$71,$00,$8b,$0b,$c8
	; 	DATA BYTE $45,$ed,$0f,$6e,$6f,$7c,$f4,$7f
	DB $45,$ed,$0f,$6e,$6f,$7c,$f4,$7f
	; 	DATA BYTE $e2,$80,$7d,$73,$f1,$00,$81,$db
	DB $e2,$80,$7d,$73,$f1,$00,$81,$db
	; 	DATA BYTE $00,$c3,$83,$f8,$87,$f7,$b6,$00
	DB $00,$c3,$83,$f8,$87,$f7,$b6,$00
	; 	DATA BYTE $6f,$2a,$31,$31,$71,$2b,$03,$3c
	DB $6f,$2a,$31,$31,$71,$2b,$03,$3c
	; 	DATA BYTE $f3,$f8,$00,$d1,$91,$8d,$11,$c3
	DB $f3,$f8,$00,$d1,$91,$8d,$11,$c3
	; 	DATA BYTE $c3,$af,$25,$1f,$b6,$07,$55,$34
	DB $c3,$af,$25,$1f,$b6,$07,$55,$34
	; 	DATA BYTE $f3,$f3,$6e,$d9,$82,$63,$f1,$06
	DB $f3,$f3,$6e,$d9,$82,$63,$f1,$06
	; 	DATA BYTE $f1,$6f,$0f,$8c,$7d,$b8,$b8,$24
	DB $f1,$6f,$0f,$8c,$7d,$b8,$b8,$24
	; 	DATA BYTE $c3,$41,$83,$83,$fb,$3f,$51,$00
	DB $c3,$41,$83,$83,$fb,$3f,$51,$00
	; 	DATA BYTE $83,$44,$00,$04,$c3,$31,$97,$dd
	DB $83,$44,$00,$04,$c3,$31,$97,$dd
	; 	DATA BYTE $63,$00,$9d,$6c,$31,$77,$71,$35
	DB $63,$00,$9d,$6c,$31,$77,$71,$35
	; 	DATA BYTE $36,$00,$f3,$00,$ea,$28,$05,$59
	DB $36,$00,$f3,$00,$ea,$28,$05,$59
	; 	DATA BYTE $fb,$34,$43,$9d,$3a,$15,$74,$79
	DB $fb,$34,$43,$9d,$3a,$15,$74,$79
	; 	DATA BYTE $3a,$fb,$fb,$6c,$05,$9e,$00,$b8
	DB $3a,$fb,$fb,$6c,$05,$9e,$00,$b8
	; 	DATA BYTE $65,$00,$39,$04,$9b,$14,$57,$2d
	DB $65,$00,$39,$04,$9b,$14,$57,$2d
	; 	DATA BYTE $07,$67,$b2,$00,$f8,$4c,$d1,$43
	DB $07,$67,$b2,$00,$f8,$4c,$d1,$43
	; 	DATA BYTE $83,$e6,$4e,$9d,$56,$67,$f6,$08
	DB $83,$e6,$4e,$9d,$56,$67,$f6,$08
	; 	DATA BYTE $3e,$00,$f1,$00,$c3,$0b,$b8,$b3
	DB $3e,$00,$f1,$00,$c3,$0b,$b8,$b3
	; 	DATA BYTE $c6,$00,$b1,$d7,$00,$6b,$db,$00
	DB $c6,$00,$b1,$d7,$00,$6b,$db,$00
	; 	DATA BYTE $77,$0e,$73,$8f,$87,$69,$0a,$04
	DB $77,$0e,$73,$8f,$87,$69,$0a,$04
	; 	DATA BYTE $df,$7f,$9a,$76,$6c,$73,$b1,$ed
	DB $df,$7f,$9a,$76,$6c,$73,$b1,$ed
	; 	DATA BYTE $0e,$a6,$68,$db,$6f,$96,$79,$07
	DB $0e,$a6,$68,$db,$6f,$96,$79,$07
	; 	DATA BYTE $69,$69,$0f,$f6,$07,$d7,$6b,$19
	DB $69,$69,$0f,$f6,$07,$d7,$6b,$19
	; 	DATA BYTE $8f,$74,$f1,$ae,$a0,$6e,$de,$70
	DB $8f,$74,$f1,$ae,$a0,$6e,$de,$70
	; 	DATA BYTE $fe,$6c,$be,$21,$13,$6b,$f3,$3e
	DB $fe,$6c,$be,$21,$13,$6b,$f3,$3e
	; 	DATA BYTE $ce,$63,$67,$47,$b3,$c1,$e1,$fb
	DB $ce,$63,$67,$47,$b3,$c1,$e1,$fb
	; 	DATA BYTE $9f,$c7,$3b,$56,$f1,$4f,$8d,$d0
	DB $9f,$c7,$3b,$56,$f1,$4f,$8d,$d0
	; 	DATA BYTE $b4,$35,$7c,$ca,$95,$04,$e0,$0d
	DB $b4,$35,$7c,$ca,$95,$04,$e0,$0d
	; 	DATA BYTE $c3,$f3,$c1,$c3,$b9,$05,$0e,$c3
	DB $c3,$f3,$c1,$c3,$b9,$05,$0e,$c3
	; 	DATA BYTE $e6,$07,$7e,$00,$3f,$97,$3c,$0e
	DB $e6,$07,$7e,$00,$3f,$97,$3c,$0e
	; 	DATA BYTE $31,$13,$fe,$17,$ff,$ff,$ff,$ff
	DB $31,$13,$fe,$17,$ff,$ff,$ff,$ff
	; 	DATA BYTE $c0
	DB $c0
	; 
	; 	' Width = 22, height = 24
	; image_pattern:
cvb_IMAGE_PATTERN:
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$07,$08,$0b,$03,$04,$0c,$01,$01,$01,$01,$01
	DB $01,$01,$02,$03,$04,$05,$06,$07
	DB $08,$09,$0a,$07,$08,$0b,$03,$04
	DB $0c,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$0d,$0e,$0f,$01,$10,$11,$12,$01,$01,$13,$01,$01,$14,$01,$15,$01,$01,$01,$01,$01
	DB $01,$01,$0d,$0e,$0f,$01,$10,$11
	DB $12,$01,$01,$13,$01,$01,$14,$01
	DB $15,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$16,$17,$18,$19,$1a,$01,$1b,$1c,$1d,$1e,$1f,$20,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$16,$17,$18
	DB $19,$1a,$01,$1b,$1c,$1d,$1e,$1f
	DB $20,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$22,$01,$23,$24,$25,$26,$27,$01,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$21,$22,$01,$23
	DB $24,$25,$26,$27,$01,$01
	; 	DATA BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$01
	DB $01,$01,$01,$01,$01,$01,$01,$01
	DB $01,$01,$01,$01,$28,$29,$2a,$2b
	DB $2c,$2d,$2e,$2f,$30,$01
	; 	DATA BYTE $01,$01,$31,$32,$33,$01,$01,$01,$34,$01,$01,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
	DB $01,$01,$31,$32,$33,$01,$01,$01
	DB $34,$01,$01,$35,$36,$37,$38,$39
	DB $3a,$3b,$3c,$3d,$3e,$3f
	; 	DATA BYTE $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$38,$38,$4d,$4e,$4f,$50,$51,$52,$53
	DB $40,$41,$42,$43,$44,$45,$46,$47
	DB $48,$49,$4a,$4b,$4c,$38,$38,$4d
	DB $4e,$4f,$50,$51,$52,$53
	; 	DATA BYTE $38,$38,$38,$38,$38,$38,$54,$55,$56,$56,$57,$38,$38,$38,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
	DB $38,$38,$38,$38,$38,$38,$54,$55
	DB $56,$56,$57,$38,$38,$38,$58,$59
	DB $5a,$5b,$5c,$5d,$5e,$5f
	; 	DATA BYTE $38,$38,$38,$38,$38,$38,$60,$61,$62,$63,$64,$38,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e
	DB $38,$38,$38,$38,$38,$38,$60,$61
	DB $62,$63,$64,$38,$65,$66,$67,$68
	DB $69,$6a,$6b,$6c,$6d,$6e
	; 	DATA BYTE $38,$38,$6f,$70,$71,$38,$38,$72,$73,$74,$38,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$38
	DB $38,$38,$6f,$70,$71,$38,$38,$72
	DB $73,$74,$38,$75,$76,$77,$78,$79
	DB $7a,$7b,$7c,$7d,$7e,$38
	; 	DATA BYTE $7f,$7f,$80,$81,$82,$7f,$7f,$83,$7f,$84,$7f,$85,$86,$87,$88,$89,$8a,$7f,$8b,$8c,$7f,$7f
	DB $7f,$7f,$80,$81,$82,$7f,$7f,$83
	DB $7f,$84,$7f,$85,$86,$87,$88,$89
	DB $8a,$7f,$8b,$8c,$7f,$7f
	; 	DATA BYTE $8d,$8e,$8f,$90,$91,$8d,$8d,$8d,$8d,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$8d,$8d,$8d
	DB $8d,$8e,$8f,$90,$91,$8d,$8d,$8d
	DB $8d,$92,$93,$94,$95,$96,$97,$98
	DB $99,$9a,$9b,$8d,$8d,$8d
	; 	DATA BYTE $8d,$8d,$9c,$9d,$9e,$9f,$8d,$8d,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$8d,$8d,$8d
	DB $8d,$8d,$9c,$9d,$9e,$9f,$8d,$8d
	DB $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
	DB $a8,$a9,$aa,$8d,$8d,$8d
	; 	DATA BYTE $8d,$8d,$ab,$ac,$ad,$ae,$8d,$8d,$8d,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$8d,$8d,$8d
	DB $8d,$8d,$ab,$ac,$ad,$ae,$8d,$8d
	DB $8d,$af,$b0,$b1,$b2,$b3,$b4,$b5
	DB $b6,$b7,$b8,$8d,$8d,$8d
	; 	DATA BYTE $8d,$8d,$b9,$ba,$bb,$bc,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$bd,$be,$bf,$c0,$c1,$8d,$8d,$8d,$8d
	DB $8d,$8d,$b9,$ba,$bb,$bc,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$bd,$be,$bf
	DB $c0,$c1,$8d,$8d,$8d,$8d
	; 	DATA BYTE $8d,$c2,$c3,$c4,$c5,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$c6,$c7,$c8,$c9,$ca,$cb,$8d,$8d,$8d,$8d
	DB $8d,$c2,$c3,$c4,$c5,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$c6,$c7,$c8,$c9
	DB $ca,$cb,$8d,$8d,$8d,$8d
	; 	DATA BYTE $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$8d
	; 	DATA BYTE $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$8d,$8d,$8d
	DB $8d,$8d,$8d,$8d,$8d,$8d
	; image_sprites:
cvb_IMAGE_SPRITES:
	; 	DATA BYTE $24,$03,$0e,$00,$00,$60,$2b,$c0
	DB $24,$03,$0e,$00,$00,$60,$2b,$c0
	; 	DATA BYTE $e0,$00,$07,$80,$00,$80,$c0,$00
	DB $e0,$00,$07,$80,$00,$80,$c0,$00
	; 	DATA BYTE $10,$10,$18,$82,$00,$1c,$1c,$1e
	DB $10,$10,$18,$82,$00,$1c,$1c,$1e
	; 	DATA BYTE $0e,$00,$1e,$0f,$0f,$00,$10,$00
	DB $0e,$00,$1e,$0f,$0f,$00,$10,$00
	; 	DATA BYTE $e0,$60,$00,$3c,$38,$30,$37,$20
	DB $e0,$60,$00,$3c,$38,$30,$37,$20
	; 	DATA BYTE $00,$07,$00,$58,$08,$00,$f0,$00
	DB $00,$07,$00,$58,$08,$00,$f0,$00
	; 	DATA BYTE $90,$07,$06,$1e,$06,$04,$00,$b3
	DB $90,$07,$06,$1e,$06,$04,$00,$b3
	; 	DATA BYTE $00,$8c,$dc,$1b,$c3,$64,$e2,$80
	DB $00,$8c,$dc,$1b,$c3,$64,$e2,$80
	; 	DATA BYTE $d4,$1b,$08,$40,$78,$fc,$fe,$9d
	DB $d4,$1b,$08,$40,$78,$fc,$fe,$9d
	; 	DATA BYTE $7b,$80,$83,$3d,$f0,$e0,$c0,$53
	DB $7b,$80,$83,$3d,$f0,$e0,$c0,$53
	; 	DATA BYTE $1f,$fb,$27,$7e,$15,$7f,$c0,$03
	DB $1f,$fb,$27,$7e,$15,$7f,$c0,$03
	; 	DATA BYTE $0b,$20,$30,$38,$3c,$3e,$64,$00
	DB $0b,$20,$30,$38,$3c,$3e,$64,$00
	; 	DATA BYTE $3c,$ef,$46,$f0,$aa,$70,$41,$00
	DB $3c,$ef,$46,$f0,$aa,$70,$41,$00
	; 	DATA BYTE $93,$38,$3e,$37,$78,$70,$47,$19
	DB $93,$38,$3e,$37,$78,$70,$47,$19
	; 	DATA BYTE $ce,$86,$9a,$bc,$1b,$03,$c7,$00
	DB $ce,$86,$9a,$bc,$1b,$03,$c7,$00
	; 	DATA BYTE $01,$30,$76,$e0,$79,$01,$03,$e2
	DB $01,$30,$76,$e0,$79,$01,$03,$e2
	; 	DATA BYTE $12,$0f,$07,$fc,$74,$1b,$00,$0e
	DB $12,$0f,$07,$fc,$74,$1b,$00,$0e
	; 	DATA BYTE $c7,$83,$06,$0c,$0c,$1c,$9e,$27
	DB $c7,$83,$06,$0c,$0c,$1c,$9e,$27
	; 	DATA BYTE $c0,$17,$0b,$67,$3a,$99,$f2,$78
	DB $c0,$17,$0b,$67,$3a,$99,$f2,$78
	; 	DATA BYTE $01,$57,$70,$f8,$07,$19,$31,$31
	DB $01,$57,$70,$f8,$07,$19,$31,$31
	; 	DATA BYTE $f4,$9f,$1a,$80,$b2,$a6,$e0,$5f
	DB $f4,$9f,$1a,$80,$b2,$a6,$e0,$5f
	; 	DATA BYTE $30,$6e,$c6,$ca,$4d,$f1,$07,$53
	DB $30,$6e,$c6,$ca,$4d,$f1,$07,$53
	; 	DATA BYTE $14,$de,$eb,$2e,$9b,$e0,$7f,$4b
	DB $14,$de,$eb,$2e,$9b,$e0,$7f,$4b
	; 	DATA BYTE $bf,$5c,$9f,$b3,$d9,$7d,$c0,$c1
	DB $bf,$5c,$9f,$b3,$d9,$7d,$c0,$c1
	; 	DATA BYTE $69,$05,$db,$9e,$01,$c1,$11,$18
	DB $69,$05,$db,$9e,$01,$c1,$11,$18
	; 	DATA BYTE $3c,$18,$84,$16,$64,$00,$e9,$7a
	DB $3c,$18,$84,$16,$64,$00,$e9,$7a
	; 	DATA BYTE $9e,$73,$c5,$c5,$00,$fb,$7e,$7f
	DB $9e,$73,$c5,$c5,$00,$fb,$7e,$7f
	; 	DATA BYTE $c9,$3f,$c0,$3d,$fa,$fd,$13,$ff
	DB $c9,$3f,$c0,$3d,$fa,$fd,$13,$ff
	; 	DATA BYTE $ff,$ff,$ff,$80
	DB $ff,$ff,$ff,$80
	; 
	; 
	; 
	; sprite_overlay:
cvb_SPRITE_OVERLAY:
	DB $4a,$a5,$00,$0c
	DB $46,$95,$04,$05
	DB $52,$7b,$08,$05
	DB $46,$b0,$0c,$01
	DB $54,$78,$10,$05
	DB $5a,$5f,$14,$08
	DB $6a,$88,$18,$0c
	DB $64,$c0,$1c,$0a
	DB $72,$9e,$20,$08
	DB $65,$70,$24,$08
	DB $73,$88,$28,$08
	DB $77,$9c,$2c,$0f
	DB $7e,$3d,$30,$0f
	DB $82,$38,$34,$08
	DB $84,$47,$38,$03
	DB $81,$74,$3c,$08
	DB $80,$80,$40,$03
	DB $84,$b8,$44,$0b
	DB $85,$a0,$48,$0b
	DB $98,$3b,$4c,$0f
	DB $9a,$4a,$50,$0f
	DB $96,$90,$54,$03
	DB $95,$b0,$58,$0b
	DB $9d,$38,$5c,$0c
	DB 208

	; 
	; TILESET:
cvb_TILESET:
	; 	DATA BYTE $3e,$00,$86,$00,$01,$03,$89,$00
	DB $3e,$00,$86,$00,$01,$03,$89,$00
	; 	DATA BYTE $07,$00,$0e,$e1,$11,$0f,$07,$c6
	DB $07,$00,$0e,$e1,$11,$0f,$07,$c6
	; 	DATA BYTE $00,$03,$01,$21,$1b,$01,$17,$0f
	DB $00,$03,$01,$21,$1b,$01,$17,$0f
	; 	DATA BYTE $1f,$1f,$9c,$10,$22,$3f,$ca,$08
	DB $1f,$1f,$9c,$10,$22,$3f,$ca,$08
	; 	DATA BYTE $05,$13,$b0,$12,$13,$3f,$7f,$6c
	DB $05,$13,$b0,$12,$13,$3f,$7f,$6c
	; 	DATA BYTE $7f,$2d,$80,$69,$c0,$2b,$34,$06
	DB $7f,$2d,$80,$69,$c0,$2b,$34,$06
	; 	DATA BYTE $f0,$0e,$5a,$ff,$00,$6d,$55,$07
	DB $f0,$0e,$5a,$ff,$00,$6d,$55,$07
	; 	DATA BYTE $6c,$3f,$07,$03,$6c,$0f,$07,$04
	DB $6c,$3f,$07,$03,$6c,$0f,$07,$04
	; 	DATA BYTE $65,$0e,$07,$5c,$3c,$41,$3f,$27
	DB $65,$0e,$07,$5c,$3c,$41,$3f,$27
	; 	DATA BYTE $69,$80,$07,$39,$52,$9f,$07,$03
	DB $69,$80,$07,$39,$52,$9f,$07,$03
	; 	DATA BYTE $d6,$16,$00,$19,$5b,$ff,$3f,$73
	DB $d6,$16,$00,$19,$5b,$ff,$3f,$73
	; 	DATA BYTE $cc,$1e,$f0,$0f,$0e,$20,$78,$fe
	DB $cc,$1e,$f0,$0f,$0e,$20,$78,$fe
	; 	DATA BYTE $ff,$00,$36,$18,$fc,$07,$0c,$ff
	DB $ff,$00,$36,$18,$fc,$07,$0c,$ff
	; 	DATA BYTE $7f,$3f,$3f,$94,$1c,$0f,$09,$60
	DB $7f,$3f,$3f,$94,$1c,$0f,$09,$60
	; 	DATA BYTE $c0,$24,$e0,$e0,$c0,$80,$f1,$7a
	DB $c0,$24,$e0,$e0,$c0,$80,$f1,$7a
	; 	DATA BYTE $ff,$f4,$07,$3e,$02,$6d,$00,$2a
	DB $ff,$f4,$07,$3e,$02,$6d,$00,$2a
	; 	DATA BYTE $77,$29,$07,$69,$20,$3b,$f1,$07
	DB $77,$29,$07,$69,$20,$3b,$f1,$07
	; 	DATA BYTE $07,$01,$b2,$07,$1f,$08,$d1,$07
	DB $07,$01,$b2,$07,$1f,$08,$d1,$07
	; 	DATA BYTE $81,$7c,$17,$5c,$ff,$f2,$08,$d2
	DB $81,$7c,$17,$5c,$ff,$f2,$08,$d2
	; 	DATA BYTE $06,$c0,$e0,$f8,$2d,$08,$c0,$5e
	DB $06,$c0,$e0,$f8,$2d,$08,$c0,$5e
	; 	DATA BYTE $0b,$00,$f8,$f0,$68,$ba,$0a,$1c
	DB $0b,$00,$f8,$f0,$68,$ba,$0a,$1c
	; 	DATA BYTE $72,$db,$07,$9e,$39,$c0,$19,$00
	DB $72,$db,$07,$9e,$39,$c0,$19,$00
	; 	DATA BYTE $ff,$fe,$21,$95,$22,$05,$00,$51
	DB $ff,$fe,$21,$95,$22,$05,$00,$51
	; 	DATA BYTE $07,$08,$02,$f0,$f8,$e1,$b1,$24
	DB $07,$08,$02,$f0,$f8,$e1,$b1,$24
	; 	DATA BYTE $00,$fc,$12,$ff,$20,$fe,$0d,$fc
	DB $00,$fc,$12,$ff,$20,$fe,$0d,$fc
	; 	DATA BYTE $fc,$f8,$f8,$af,$10,$0a,$9e,$1a
	DB $fc,$f8,$f8,$af,$10,$0a,$9e,$1a
	; 	DATA BYTE $00,$b8,$00,$08,$74,$06,$b3,$0c
	DB $00,$b8,$00,$08,$74,$06,$b3,$0c
	; 	DATA BYTE $7d,$10,$c3,$73,$d1,$7d,$07,$51
	DB $7d,$10,$c3,$73,$d1,$7d,$07,$51
	; 	DATA BYTE $cd,$be,$93,$44,$85,$6b,$78,$11
	DB $cd,$be,$93,$44,$85,$6b,$78,$11
	; 	DATA BYTE $78,$30,$00,$b2,$c2,$c9,$e0,$7f
	DB $78,$30,$00,$b2,$c2,$c9,$e0,$7f
	; 	DATA BYTE $f3,$78,$e7,$32,$3f,$8d,$00,$7f
	DB $f3,$78,$e7,$32,$3f,$8d,$00,$7f
	; 	DATA BYTE $96,$cf,$00,$dc,$0d,$8f,$71,$ba
	DB $96,$cf,$00,$dc,$0d,$8f,$71,$ba
	; 	DATA BYTE $4e,$00,$07,$f0,$be,$37,$33,$57
	DB $4e,$00,$07,$f0,$be,$37,$33,$57
	; 	DATA BYTE $54,$c7,$bf,$bc,$29,$4e,$c3,$65
	DB $54,$c7,$bf,$bc,$29,$4e,$c3,$65
	; 	DATA BYTE $fd,$fd,$b5,$79,$f8,$cf,$65,$01
	DB $fd,$fd,$b5,$79,$f8,$cf,$65,$01
	; 	DATA BYTE $00,$f4,$fd,$f6,$f0,$00,$06,$06
	DB $00,$f4,$fd,$f6,$f0,$00,$06,$06
	; 	DATA BYTE $04,$7c,$04,$1d,$7c,$dc,$00,$87
	DB $04,$7c,$04,$1d,$7c,$dc,$00,$87
	; 	DATA BYTE $99,$7e,$79,$05,$00,$c4,$1d,$20
	DB $99,$7e,$79,$05,$00,$c4,$1d,$20
	; 	DATA BYTE $60,$99,$61,$9f,$67,$73,$8b,$21
	DB $60,$99,$61,$9f,$67,$73,$8b,$21
	; 	DATA BYTE $d2,$60,$60,$20,$20,$c6,$8f,$dc
	DB $d2,$60,$60,$20,$20,$c6,$8f,$dc
	; 	DATA BYTE $1f,$d3,$c9,$fb,$c0,$00,$aa,$c0
	DB $1f,$d3,$c9,$fb,$c0,$00,$aa,$c0
	; 	DATA BYTE $87,$18,$3c,$3e,$6c,$7e,$4f,$80
	DB $87,$18,$3c,$3e,$6c,$7e,$4f,$80
	; 	DATA BYTE $cb,$a3,$e2,$df,$3c,$cb,$bf,$33
	DB $cb,$a3,$e2,$df,$3c,$cb,$bf,$33
	; 	DATA BYTE $a8,$f1,$f1,$a9,$c5,$08,$f0,$ed
	DB $a8,$f1,$f1,$a9,$c5,$08,$f0,$ed
	; 	DATA BYTE $00,$da,$22,$55,$08,$7b,$7c,$00
	DB $00,$da,$22,$55,$08,$7b,$7c,$00
	; 	DATA BYTE $a8,$ee,$3a,$fb,$04,$10,$df,$e8
	DB $a8,$ee,$3a,$fb,$04,$10,$df,$e8
	; 	DATA BYTE $cf,$07,$1f,$87,$03,$1c,$3e,$7f
	DB $cf,$07,$1f,$87,$03,$1c,$3e,$7f
	; 	DATA BYTE $31,$cb,$04,$8f,$07,$da,$12,$55
	DB $31,$cb,$04,$8f,$07,$da,$12,$55
	; 	DATA BYTE $a8,$00,$0c,$b3,$e7,$86,$8e,$9f
	DB $a8,$00,$0c,$b3,$e7,$86,$8e,$9f
	; 	DATA BYTE $f1,$87,$56,$df,$e0,$01,$00,$e1
	DB $f1,$87,$56,$df,$e0,$01,$00,$e1
	; 	DATA BYTE $e3,$e7,$e7,$ef,$ef,$a9,$7c,$de
	DB $e3,$e7,$e7,$ef,$ef,$a9,$7c,$de
	; 	DATA BYTE $d1,$ff,$75,$bb,$35,$58,$79,$57
	DB $d1,$ff,$75,$bb,$35,$58,$79,$57
	; 	DATA BYTE $00,$86,$ff,$80,$48,$7f,$1f,$03
	DB $00,$86,$ff,$80,$48,$7f,$1f,$03
	; 	DATA BYTE $c3,$c1,$39,$c1,$80,$1f,$7f,$a5
	DB $c3,$c1,$39,$c1,$80,$1f,$7f,$a5
	; 	DATA BYTE $0f,$94,$cf,$f9,$0c,$81,$60,$11
	DB $0f,$94,$cf,$f9,$0c,$81,$60,$11
	; 	DATA BYTE $3b,$03,$1f,$13,$3a,$08,$b8,$6d
	DB $3b,$03,$1f,$13,$3a,$08,$b8,$6d
	; 	DATA BYTE $83,$45,$0a,$b5,$0f,$00,$b6,$ed
	DB $83,$45,$0a,$b5,$0f,$00,$b6,$ed
	; 	DATA BYTE $86,$3e,$dd,$17,$c9,$6b,$f7,$7f
	DB $86,$3e,$dd,$17,$c9,$6b,$f7,$7f
	; 	DATA BYTE $ff,$ff,$ff,$fe
	DB $ff,$ff,$ff,$fe

	; COLORSET1:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b
cvb_COLORSET1:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
	DB $0b,$0b
	; COLORSET2:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$cb,$cb,$b,$b
cvb_COLORSET2:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
	DB $0b,$0b,$0b,$0b,$0b,$0b,$cb,$cb
	DB $0b,$0b
	; COLORSET3:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$b,$b,$b,$cb,$cb,$b,$b,$4b,$4b,$b,$b
cvb_COLORSET3:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
	DB $0b,$0b,$cb,$cb,$0b,$0b,$4b,$4b
	DB $0b,$0b
	; COLORSET4:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$cb,$b,$b,$4b,$4b,$b,$b,$7b,$7b,$b,$b
cvb_COLORSET4:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$cb
	DB $0b,$0b,$4b,$4b,$0b,$0b,$7b,$7b
	DB $0b,$0b
	; COLORSET5:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$4b,$b,$b,$7b,$7b,$cb,$cb,$3b,$3b,$b,$b
cvb_COLORSET5:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$4b
	DB $0b,$0b,$7b,$7b,$cb,$cb,$3b,$3b
	DB $0b,$0b
	; COLORSET6:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$7b,$cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b,$b,$b
cvb_COLORSET6:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$7b
	DB $cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b
	DB $0b,$0b
	; COLORSET7:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$3b,$4b,$4b,$6b,$6b,$7b,$7b,$ab,$ab,$cb,$cb
cvb_COLORSET7:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$3b
	DB $4b,$4b,$6b,$6b,$7b,$7b,$ab,$ab
	DB $cb,$cb
	; COLORSET8:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$6b,$7b,$7b,$ab,$ab,$3b,$3b,$cb,$cb,$4b,$4b
cvb_COLORSET8:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$6b
	DB $7b,$7b,$ab,$ab,$3b,$3b,$cb,$cb
	DB $4b,$4b
	; COLORSET9:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$ab,$3b,$3b,$cb,$cb,$6b,$6b,$4b,$4b,$7b,$7b
cvb_COLORSET9:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$ab
	DB $3b,$3b,$cb,$cb,$6b,$6b,$4b,$4b
	DB $7b,$7b
	; COLORSET10:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$cb,$6b,$6b,$4b,$4b,$ab,$ab,$7b,$7b,$3b,$3b
cvb_COLORSET10:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$cb
	DB $6b,$6b,$4b,$4b,$ab,$ab,$7b,$7b
	DB $3b,$3b
	; COLORSET11:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$4b,$ab,$ab,$7b,$7b,$cb,$cb,$3b,$3b,$6b,$6b
cvb_COLORSET11:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$4b
	DB $ab,$ab,$7b,$7b,$cb,$cb,$3b,$3b
	DB $6b,$6b
	; COLORSET12:	DATA BYTE $b,$b,$b,$b,$b,$b,$b,$7b,$cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b,$ab,$ab
cvb_COLORSET12:
	DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$7b
	DB $cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b
	DB $ab,$ab


cvb_PNT:
	; 	DATA BYTE $1b,$31,$ae,$c0,$00,$28,$1c,$1e
	DB $1b,$31,$ae,$c0,$00,$28,$1c,$1e
	; 	DATA BYTE $1d,$29,$11,$29,$2e,$1f,$00,$20
	DB $1d,$29,$11,$29,$2e,$1f,$00,$20
	; 	DATA BYTE $24,$c3,$0f,$30,$22,$23,$78,$1e
	DB $24,$c3,$0f,$30,$22,$23,$78,$1e
	; 	DATA BYTE $2f,$8a,$00,$44,$60,$03,$53,$70
	DB $2f,$8a,$00,$44,$60,$03,$53,$70
	; 	DATA BYTE $87,$46,$62,$1c,$3b,$58,$07,$10
	DB $87,$46,$62,$1c,$3b,$58,$07,$10
	; 	DATA BYTE $27,$37,$71,$06,$80,$1f,$2c,$89
	DB $27,$37,$71,$06,$80,$1f,$2c,$89
	; 	DATA BYTE $4a,$69,$3e,$55,$00,$72,$83,$48
	DB $4a,$69,$3e,$55,$00,$72,$83,$48
	; 	DATA BYTE $67,$3c,$5c,$73,$19,$03,$1b,$21
	DB $67,$3c,$5c,$73,$19,$03,$1b,$21
	; 	DATA BYTE $31,$50,$79,$02,$78,$1f,$26,$85
	DB $31,$50,$79,$02,$78,$1f,$26,$85
	; 	DATA BYTE $00,$42,$64,$3d,$54,$01,$09,$41
	DB $00,$42,$64,$3d,$54,$01,$09,$41
	; 	DATA BYTE $65,$00,$00,$5a,$77,$86,$45,$61
	DB $65,$00,$00,$5a,$77,$86,$45,$61
	; 	DATA BYTE $18,$51,$37,$75,$08,$80,$1f,$25
	DB $18,$51,$37,$75,$08,$80,$1f,$25
	; 	DATA BYTE $0d,$11,$0f,$0b,$0b,$30,$0a,$1a
	DB $0d,$11,$0f,$0b,$0b,$30,$0a,$1a
	; 	DATA BYTE $1f,$56,$78,$03,$80,$47,$68,$04
	DB $1f,$56,$78,$03,$80,$47,$68,$04
	; 	DATA BYTE $52,$05,$5c,$a4,$00,$2b,$88,$43
	DB $52,$05,$5c,$a4,$00,$2b,$88,$43
	; 	DATA BYTE $66,$3a,$5c,$76,$81,$06,$40,$6a
	DB $66,$3a,$5c,$76,$81,$06,$40,$6a
	; 	DATA BYTE $38,$57,$14,$b8,$1f,$2a,$00,$84
	DB $38,$57,$14,$b8,$1f,$2a,$00,$84
	; 	DATA BYTE $4b,$6b,$3f,$5b,$74,$82,$49,$0d
	DB $4b,$6b,$3f,$5b,$74,$82,$49,$0d
	; 	DATA BYTE $63,$39,$59,$10,$71,$1f,$2d,$40
	DB $63,$39,$59,$10,$71,$1f,$2d,$40
	; 	DATA BYTE $62,$00,$0e,$16,$15,$0c,$13,$1b
	DB $62,$00,$0e,$16,$15,$0c,$13,$1b
	; 	DATA BYTE $17,$12,$31,$eb,$e7,$00,$ff,$ff
	DB $17,$12,$31,$eb,$e7,$00,$ff,$ff
	; 	DATA BYTE $ff,$fe
	DB $ff,$fe
	; 
	; 	
	; 