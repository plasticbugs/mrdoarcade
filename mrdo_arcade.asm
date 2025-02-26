; BASED ON THE  ASM CODE DISASSEMBLY OF MR. DO! BY CAPTAIN COSMOS (November 10,2023)
;
; https://archive.org/details/manualzilla-id-5667325/mode/1up?view=theater
; OS listing
;
; About moving the game to screen 2....
; The layout of the VRAM in the original game is:
;
; Pattern Table:    0000h-07FFh (256*8 bytes in screen 1)
; Name Table:       1000h-12FFh - 256*3 tiles
; Color Table:      1800h (32 bytes)
; SAT:              1900h
; SPT:              2000h (256*8 bytes)

; Original VRAM tables
; PT:       EQU $0000
; PNT:      EQU $1000
; CT:       EQU $1800
; SAT:      EQU $1900
; SPT:      EQU $2000
;
; VRAM areas used for data
; 3400H     212 bytes for saving P1 game data
; 3600H     212 bytes for saving P2 game data
; 3800h     768 bytes for alternative PNT during pause
; 3B00H     93 bytes for sound data

; Screen 2 layout
; Pattern Table:    0000h-17FFh (3*256*8 bytes in screen 2)
; Name Table:       1800h-1AFFh (3*256 tiles)
; SAT:              1B00h-1B7Fh (4*32 bytes)
; Color Table:      2000h-27FFh (256*8 bytes - screen 2 mirrored)
; SPT:              2800h-2FFFh (256*8 bytes)

PT:                     EQU $0000
PNT:                    EQU $1800
CT:                     EQU $2000
SAT:                    EQU $1B00
SPT:                    EQU $2800


; BIOS DEFINITIONS **************************
ASCII_TABLE:            EQU $006A
NUMBER_TABLE:           EQU $006C
PLAY_SONGS:             EQU $1F61

FILL_VRAM:              EQU $1F82
INIT_TABLE:             EQU $1FB8
PUT_VRAM:               EQU $1FBE
INIT_SPR_NM_TBL:        EQU $1FC1
WR_SPR_NM_TBL:          EQU $1FC4
INIT_TIMER:             EQU $1FC7
FREE_SIGNAL:            EQU $1FCA
REQUEST_SIGNAL:         EQU $1FCD
TEST_SIGNAL:            EQU $1FD0
TIME_MGR:               EQU $1FD3
TURN_OFF_SOUND:         EQU $1FD6
WRITE_REGISTER:         EQU $1FD9
READ_REGISTER:          EQU $1FDC
WRITE_VRAM:             EQU $1FDF
READ_VRAM:              EQU $1FE2
POLLER:                 EQU $1FEB
SOUND_INIT:             EQU $1FEE
PLAY_IT:                EQU $1FF1
SOUND_MAN:              EQU $1FF4
RAND_GEN:               EQU $1FFD

; VDP
DATA_PORT:              EQU $BE
CTRL_PORT:              EQU $BF


COLECO_TITLE_ON:        EQU $55AA
COLECO_TITLE_OFF:       EQU $AA55


; SOUND DEFINITIONS *************************
OPENING_TUNE_SND_0A:    EQU $01
BACKGROUND_TUNE_0A:     EQU $02
OPENING_TUNE_SND_0B:    EQU $03
BACKGROUND_TUNE_0B:     EQU $04
GRAB_CHERRIES_SND:      EQU $05
BOUNCING_BALL_SND_0A:   EQU $06
BOUNCING_BALL_SND_0B:   EQU $07
BALL_STUCK_SND:         EQU $08
BALL_RETURN_SND:        EQU $09
APPLE_FALLING_SND:      EQU $0A
APPLE_BREAK_SND_0A:     EQU $0B
APPLE_BREAK_SND_0B:     EQU $0C
NO_EXTRA_TUNE_0A:       EQU $0D
NO_EXTRA_TUNE_0B:       EQU $0E
NO_EXTRA_TUNE_0C:       EQU $0F
DIAMOND_SND:            EQU $10
EXTRA_WALKING_TUNE_0A:  EQU $11
EXTRA_WALKING_TUNE_0B:  EQU $12
GAME_OVER_TUNE_0A:      EQU $13
GAME_OVER_TUNE_0B:      EQU $14
WIN_EXTRA_DO_TUNE_0A:   EQU $15
WIN_EXTRA_DO_TUNE_0B:   EQU $16
END_OF_ROUND_TUNE_0A:   EQU $17
END_OF_ROUND_TUNE_0B:   EQU $18
LOSE_LIFE_TUNE_0A:      EQU $19
LOSE_LIFE_TUNE_0B:      EQU $1A
BLUE_CHOMPER_SND_0A:    EQU $1B
BLUE_CHOMPER_SND_0B:    EQU $1C
VERY_GOOD_TUNE_0A:      EQU $1D
VERY_GOOD_TUNE_0B:      EQU $1E
VERY_GOOD_TUNE_0C:      EQU $1F
SFX_COIN_INSERT_SND:    EQU $20
NO_EXTRA_TUNE_0D:       EQU $21
NO_EXTRA_TUNE_0E:       EQU $22
TWINKLE_TWINKLE_0A:     EQU $23
TWINKLE_TWINKLE_0B:     EQU $24
TWINKLE_TWINKLE_0C:     EQU $25

; RAM DEFINITIONS ***************************
    ORG $7000,$73FF

SAT_BUFFER:
WORKBUFFER:             RB  16  ;EQU $7000  ; work ram

                RB  4   ;EQU $7010  ; Free

                RB  12  ;EQU $7014      ; Free
STATESTART:             RB  11  ;EQU $7020  ; OS Sound Buffer Start
SOUND_BANK_01_RAM:      RB  10  ;EQU $702B
SOUND_BANK_02_RAM:      RB  10  ;EQU $7035
SOUND_BANK_03_RAM:      RB  10  ;EQU $703F
SOUND_BANK_04_RAM:      RB  10  ;EQU $7049
SOUND_BANK_05_RAM:      RB  10  ;EQU $7053
SOUND_BANK_06_RAM:      RB  10  ;EQU $705D
SOUND_BANK_07_RAM:      RB  10  ;EQU $7067
SOUND_BANK_08_RAM:      RB  10  ;EQU $7071
SOUND_BANK_09_RAM:      RB  11  ;EQU $707B

CONTROLLER_BUFFER:      RB   2  ;EQU $7086
                        RB   4  ;EQU $7088 ?? some kind of struct used in SUB_94A9 for Player1
KEYBOARD_P1:            RB   1  ;EQU $708C

                        RB   4  ;EQU $708D ?? some kind of struct used in SUB_94A9 for Player2
KEYBOARD_P2:            RB   1  ;EQU $7091

TIMER_TABLE:            RB  87  ;EQU $7092  ; total 29x3=87 bytes avoid overflow in the SAT

SPRITE_NAME_TABLE:      RB  80  ;EQU $70E9  ; SAT (4*20)

BADGUY_BHVR_CNT_RAM:    RB   1  ;EQU $7139 ; HOW MANY BYTES IN TABLE
BADGUY_BEHAVIOR_RAM:    RB  80  ;EQU $713A ; BEHAVIOR TABLE. UP TO 80 ELEMENTS

LEVELMAP:               RB 160  ;EQU $718A ; Level (16x10) and game state (52 bytes) total 212 byte saved in VRAM
CURRAPPL:               RB   1  ;EQU $722A
                        RB   1  ;EQU $722B ; free !
APPLEDATA:              RB  25  ;EQU $722C ; Apple sprite data 5x5 bytes
ENEMYINTERACT:          RB  20  ;EQU $7245 ; enemy interaction data
ENEMYINTERACT2:         RB  20  ;EQU $7259 ; enemy interaction data
SPRITEROTFLAG:          RB   1  ;EQU $726D
GAMECONTROL:            RB   1  ;EQU $726E ; GAME CONTROL BYTE (All bits have A meaning!) B0->1/2 Players B5-> Pause/Game
GAMETIMER:              RB   1  ;EQU $726F  ??
                        RB   1  ;EQU $7270  ??
SKILLLEVEL:             RB   1  ;EQU $7271 ; Skill Level 1-4
GAMEFLAGSBONUSITEM:     RB   1  ;EQU $7272 ; SOME GAME FLAG ?
DIAMOND_RAM:            RB   1  ;EQU $7273
CURRENT_LEVEL_P1:       RB   1  ;EQU $7274
CURRENT_LEVEL_P2:       RB   1  ;EQU $7275
LIVES_LEFT_P1_RAM:      RB   1  ;EQU $7276
LIVES_LEFT_P2_RAM:      RB   1  ;EQU $7277
ENEMY_NUM_P1:           RB   1  ;EQU $7278 Initialised at 7 by LOC_8573
ENEMY_NUM_P2:           RB   1  ;EQU $7279 Initialised at 7 by LOC_8573
LETTERMON_SPAWNP1:      RB   1  ;EQU $727A Counter used to spawn letter monster for P1
LETTERMON_SPAWNP2:      RB   1  ;EQU $727B Counter used to spawn letter monster for P2
SCOREFLAG:              RB   1  ;EQU $727C Tell which score to upate ($80 for P1, $40 for P2, 0 no update)

free:                   RB   4  ;EQU $727D

MRDO_DATA:              RB   1  ;EQU $7281 ;+0  ; Mr. Do's flags
MRDO_DATA.unkn:         RB   1  ;EQU $7282 ;+1  ; Mr. Do's ?
MRDO_DATA.Timer:        RB   1  ;EQU $7283 ;+2  ; Mr. Do's timer
MRDO_DATA.Y:            RB   1  ;EQU $7284 ;+3
MRDO_DATA.X:            RB   1  ;EQU $7285 ;+4
MRDO_DATA.Frame:        RB   1  ;EQU $7286 ;+5
                        RB   1  ;EQU $7287 ;+6
                        RB   1  ;EQU $7288 ;+7
                        RB   1  ;EQU $7289  ; ??
BADGUYFLAGS:            RB   1  ;EQU $728A  ; ??
BADGUYTIMER:            RB   1  ;EQU $728B  ;
CURRBADGUY:             RB   1  ;EQU $728C  ; Current bad guy 0-6
BADGUYCOUNTER:          RB   1  ;EQU $728D
ENEMY_DATA_ARRAY:       RB  42  ;EQU $728E  ; enemy data starts here = 7*6 bytes (7 enemies)
LETTERMON_DATA_P1:      RB   1  ;EQU $72B8
LETTERMON_DATA_P2:      RB   1  ;EQU $72B9
LETTERMON_COUNTER:      RB   1  ;EQU $72BA  ; Counter for the position in the scorebar (only 3 bits, UPPER BITS ARE FLAGS)
LETTERMON_EXTRAFLAGP1:  RB   1  ;EQU $72BB
LETTERMON_EXTRAFLAGP2:  RB   1  ;EQU $72BC
LETTERMON_FLAG:         RB   1  ;EQU $72BD  ; ram for letter monsters
LETTERMON_X:            RB   1  ;EQU $72BE
LETTERMON_Y:            RB   1  ;EQU $72BF
LETTERMON_TIMER:        RB   1  ;EQU $72C0
                        RB   1  ;EQU $72C1
                        RB   1  ;EQU $72C2
GAMEFLAGS:              RB   1  ;EQU $72C3  Game Flag B7 = chomper mode,B0 ???
                        RB   1  ;EQU $72C4  if set to 1 you need to free the timer for Letter Monsters
CHOMPNUMBER:            RB   1  ;EQU $72C5  store the current chomper 0-2
TIMERCHOMP1:            RB   1  ;EQU $72C6  Game timer chomper mode
CHOMPDATA:              RB  18  ;EQU $72C7  3x6 = 18 bytes (3 chompers)
BALLDATA:               RB   6  ;EQU $72D9

TEXT_BUFFER:            RB   8  ;EQU $72DF  ; 8 bytes - Text buffer for printing

SCRATCH:                        ;Scratch ram
SPTBUFF2:               RB   8  ;EQU $72E7  ; ?? SPT buffer

ADDCURRTIMER:           RB 2    ;EQU $072EF ; 2 bytes used to remove overhead in the NMI
FRAME_COUNT:            RB 1    ;EQU $072F1     Shared frame counter (0-59)


P1_LEVEL1_SEC:          RB 1    ; EQU 072F2h ; Player 1 level 1 seconds
P1_LEVEL1_MIN:          RB 1    ; EQU 072F3h ; Player 1 level 1 minutes
P1_LEVEL2_SEC:          RB 1    ; EQU 072F4h ; Player 1 level 2 seconds
P1_LEVEL2_MIN:          RB 1    ; EQU 072F5h ; Player 1 level 2 minutes
P1_LEVEL3_SEC:          RB 1    ; EQU 072F6h ; Player 1 level 3 seconds
P1_LEVEL3_MIN:          RB 1    ; EQU 072F7h ; Player 1 level 3 minutes

P1_PREV_SCORE:          RB 2    ; EQU 072F8h ; 2 bytes - Previous total score for P1
P1_LEVEL1_SCORE:        RB 2    ; EQU 072FAh ; 2 bytes - Level 1 score
P1_LEVEL2_SCORE:        RB 2    ; EQU 072FCh ; 2 bytes - Level 2 score
P1_LEVEL3_SCORE:        RB 2    ; EQU 072FEh ; 2 bytes - Level 3 score

P2_LEVEL1_SEC:          RB 1    ; EQU 07300h ; Player 1 level 1 seconds
P2_LEVEL1_MIN:          RB 1    ; EQU 07301h ; Player 1 level 1 minutes
P2_LEVEL2_SEC:          RB 1    ; EQU 07302h ; Player 1 level 2 seconds
P2_LEVEL2_MIN:          RB 1    ; EQU 07303h ; Player 1 level 2 minutes
P2_LEVEL3_SEC:          RB 1    ; EQU 07304h ; Player 1 level 3 seconds
P2_LEVEL3_MIN:          RB 1    ; EQU 07305h ; Player 1 level 3 minutes

P2_PREV_SCORE:          RB 2    ; EQU 07306h ; 2 bytes - Previous total score for P2
P2_LEVEL1_SCORE:        RB 2    ; EQU 07308h ; 2 bytes - Level 1 score
P2_LEVEL2_SCORE:        RB 2    ; EQU 0730Ah ; 2 bytes - Level 2 score
P2_LEVEL3_SCORE:        RB 2    ; EQU 0730Ch ; 2 bytes - Level 3 score

P1_LEVEL_FINISH_BASE:   RB 3    ; EQU 0730Eh ;
P2_LEVEL_FINISH_BASE:   RB 3    ; EQU 07311h ;

SIGNPOSITION:           RB 1    ; EQU 0x07314 ;offeset in the game map (16x10)
SIGNTIMER:              RB 1    ; EQU 0x07315 ;now we have free ram also at the end of the used area
                        
SCORE_P1:               RB  1
SCORE_P1_RAM:           RB  2  ;EQU 07316h ;  SCORING FOR PLAYER#1
SCORE_P2:               RB  1
SCORE_P2_RAM:           RB  2  ;EQU 07318h ;  SCORING FOR PLAYER#2

TIMER_DATA_BLOCK:       RB  21

ENDUSEDRAM:             RB 1

FRAMEPERSEC:            EQU $0069
DEFER_WRITES:           EQU $73C6       ; System flag
MUX_SPRITES:            EQU $73C7       ; System flag: enable sprite rotation ?
RAND_NUM:               EQU $73C8       ; Used by RAND_GEN,it has to be !=0

mode:                   EQU $73FD       ; Unused (?) used by OS
; B0==0 -> ISR Enabled,B0==1 -> ISR disabled
; B1==0 -> ISR served   B1==1 -> ISR pending
; B3-B6 spare
; B7==0 -> game mode,   B7==1 -> intermission mode


FNAME "mrdo_arcade.rom"
;   CPU Z80


    ORG $8000

    DW COLECO_TITLE_OFF        ; SET TO COLECO_TITLE_ON FOR TITLES,COLECO_TITLE_OFF TO TURN THEM OFF
    DW 0
    DW 0
    DW 0
    DW CONTROLLER_BUFFER
    DW START

    ; RST 08H vector
    ; RST 10H vector
    ; RST 20H vector
    ; RST 28H vector
    ; RST 30H vector
    ; RST 38H vector
    DS 20,0
    RET
;   JP      nmi_handler     ; nmi has to start here

;GAME_NAME:
;   DB "MR. DO!",1EH,1FH
;   DB "/PRESENTS UNIVERSAL'S/1983"

nmi_handler:                ; do not move from here (!!!)
    PUSH AF
    PUSH HL
    LD HL,mode
    BIT 0,(HL)              ; B0==0 -> ISR Enabled,B0==1 -> ISR disabled
    JR z,.1
                    ; here ISR is disabled

    SET 1,(HL)              ; ISR pending
                            ; B1==0 -> ISR served   B1==1 -> ISR pending
    POP HL
    POP AF
    retn

.0: RES 1,(HL)              ; ISR served
.1:                         ; ISR enabled
    BIT 7,(HL)
    JR z,.2                 ; B7==0 -> game Mode,   B7==1 -> intermission mode

                    ; Intermission Mode
    POP     HL
    IN      A,(CTRL_PORT)
    POP     AF

    PUSH    AF
    PUSH    BC
    PUSH    DE
    PUSH    HL
    EX      AF,AF'
    EXX
    PUSH    AF
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    PUSH    IY
    CALL    TIME_MGR        ; udate timers
    CALL    POLLER          ; update controllers
    CALL    SUB_C952        ; PLAY MUSIC
    POP     IY
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    POP     AF
    EXX
    EX      AF,AF'
    POP     HL
    POP     DE
    POP     BC
    POP     AF
    RETN

.2: POP HL                  ; Game Mode
    POP AF

    PUSH    AF
    PUSH    BC
    PUSH    DE
    PUSH    HL
    EX      AF,AF'
    EXX
    PUSH    AF
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    PUSH    IY
    LD      BC,1C2H
    CALL    WRITE_REGISTER          ; disable ISR generation

    IN      A,(CTRL_PORT)

    LD      A,(GAMECONTROL)
    BIT     3,A
    PUSH    AF
    CALL    Z,NEW_SPRITE_ROTATION       ; CALL only if sprites are not disabled
    POP     AF
    CALL    Z,DEAL_WITH_TIMER           ; level timers active only if not in pause mode

    CALL    SUB_80D1                    ; enemy interaction with the play field
    CALL    MRDO_SPT_UPDATE             ; UPDATE MR DO SPRITE
    CALL    SCORE_UPDATE                ; update play score
    CALL    DISPLAY_EXTRA_01            ; update Extra Letters
    CALL    SETBONUS                    ; Set bonus items and diamonds
    CALL    TIME_MGR
    CALL    POLLER
    CALL    SUB_C952            ; PLAY MUSIC

    LD      HL,GAMECONTROL
    BIT     7,(HL)
    JR      Z,LOC_80BB
    RES     7,(HL)
    JR      FINISH_NMI
LOC_80BB:
    LD      BC,1E2H
    CALL    WRITE_REGISTER          ; enable ISR generation
FINISH_NMI:
    POP     IY
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    POP     AF
    EXX
    EX      AF,AF'
    POP     HL
    POP     DE
    POP     BC
    POP     AF
    RETN


NEW_SPRITE_ROTATION:
    LD      A,SAT and 255       ; Send LSB of address
    OUT     (CTRL_PORT),A
    LD      A,$40  + (SAT / 256)
    OUT     (CTRL_PORT),A       ; Send MSB of address

    LD      DE,$1005            ; copy 20 sprites 4 at time (5*4=20 and 4*4=16)

    LD      A,(SPRITEROTFLAG)
    ADD     A,D
    CP      20*4
    JR      C,.nores
    XOR     A
.nores:
    LD      (SPRITEROTFLAG),A

    LD      C,A
    LD      B,0
    LD      HL,SPRITE_NAME_TABLE
    ADD     HL,BC

    LD      C,DATA_PORT         ; C = output port

.2: LD      B,D                 ; B = count for 4*4 bytes, i.E. 4 sprites
.1: OUTI                        ; Output A byte of data
    JP      NZ,.1               ; Loop until 4*4 bytes copied

    ADD     A,D
    CP      20*4                ; start from the top if reach the end of the table
    JR      C,.3

    LD      HL,SPRITE_NAME_TABLE
    XOR     A

.3: DEC     E
    JR      NZ,.2

    LD      A,208
    OUT     (DATA_PORT),A
RET



DEAL_WITH_TIMER:
    ; First increment shared frame counter
    LD      A,(FRAME_COUNT)
    INC     A
    LD      (FRAME_COUNT),A
    LD      HL,FRAMEPERSEC
    CP      (HL)
    RET      NZ

    ; We hit 60 frames,need to increment seconds
    XOR     A
    LD      (FRAME_COUNT),A
    LD      HL,(ADDCURRTIMER)

    ; Update seconds for current level
    LD      A,(HL)      ; Load current seconds
    INC     A
    LD      (HL),A     ; Store seconds
    CP      60
    RET      NZ

    ; Hit 60 seconds,increment minutes
    LD      (HL),0      ; Reset seconds
    INC     HL
    INC     (HL)            ; increment minutes
RET

SUB_80D1:
    LD      HL,ENEMYINTERACT2
    LD      BC,1401H            ; B = 20 sprites
LOC_80D7:
    LD      A,(HL)
    AND     A
    JR      Z,LOC_80FF
    LD      E,C
    PUSH    BC
LOC_80DD:
    PUSH    HL
    PUSH    DE
    LD      HL,ENEMYINTERACT2
    LD      A,E
    CALL    SUB_AC0B
    JR      Z,LOC_80F7
    POP     DE
    PUSH    DE
    LD      HL,ENEMYINTERACT2
    LD      A,E
    CALL    SUB_ABF6
    POP     DE
    PUSH    DE
    LD      A,E
    CALL    DISPLAY_PLAY_FIELD_PARTS
LOC_80F7:
    POP     DE
    INC     E
    POP     HL
    LD      A,(HL)
    AND     A
    JR      NZ,LOC_80DD
    POP     BC
LOC_80FF:
    LD      A,C
    ADD     A,8
    LD      C,A
    INC     HL
    DJNZ    LOC_80D7
RET

; in A the frame number in MRDOGENERATOR
SETMRDOFRAME:
    LD      E,A         ; A<51 as 51*5=255,we can use 8 bit math
    ADD     A,A
    ADD     A,A
    ADD     A,E
    LD      E,A
    LD      D,0
    LD      IY,8                ; number of 8x8 tiles to process (8 <=> 2 layers)
    LD      IX,MRDOGENERATOR
;   LD      A,(SNOWFLAG)
;   AND     A
;   JR      Z,.1
;   LD      IX,SNOWMANGENERATOR
;.1:
    ADD     IX,DE
    CALL    UPDATE_SPT  ; Rotate the current frame of the player
RET

MRDO_SPT_UPDATE:
    LD      HL,MRDO_DATA            ; Mr. Do's sprite data
    BIT     7,(HL)
    RET     Z
    RES     7,(HL)
    LD      D,1
    LD      A,(MRDO_DATA.Frame)         ; if >0 update the MrDo sprite (CURRENT FRAME ?)
    AND     A
    JR      Z,LOC_8241
    DEC     A
    CALL    SETMRDOFRAME

    LD      D,0
LOC_8241:
    LD      HL,(MRDO_DATA.Y)            ; L = MrDo's Y,H = MrDo's X
    DEC L
    LD      B,L                         ; B = Y-1
    LD      C,H                         ; C = X
    LD      A,1
    CALL    PUTSPRITE           ; put sprite A at B = Y-1,C=X with step D

                                ; HACK TO ADD A SECOND COLOR LAYER
    LD      A,(IX+2)
    CP      132                 ; smashed player HARDCODED (!! was 148)
    JP      NZ,.patch           ; patch only if the player is not smashed
    LD      (IX+4),$D1          ; hide the second layer if player is smashed
    RET
.patch:
    LD      A,(IX+0)
    LD      (IX+4),A
    LD      A,(IX+1)
    LD      (IX+5),A
    LD      (IX+6),45*4         ; hardcoded !!
    LD      (IX+7),15
RET

SCORE_UPDATE:                   ; update play score
    LD      HL,SCOREFLAG
    BIT     7,(HL)
    JR      Z,.p2
    RES     7,(HL)              ; print only once
    XOR     A                   ; print up (P1)
    JP      PRINT_SCORE
.p2:
    BIT     6,(HL)
    RET     Z
    RES     6,(HL)              ; print only once
    LD      A,1                 ; print down (P2)
    CALL    PRINT_SCORE
RET

DISPLAY_EXTRA_01:
    LD      A,(LETTERMON_EXTRAFLAGP2)
    AND     A
    JR      Z,LOC_82AA
    LD      HL,BYTE_82D3
    LD      DE,2BH
    LD      BC,EXTRA_01_TXT
LOC_8278:
    RRCA
    JR      C,LOC_8282
    INC     HL
    INC     HL
    INC     DE
    INC     DE
    INC     BC
    JR      LOC_8278
LOC_8282:
    LD      A,(LETTERMON_EXTRAFLAGP2)
    AND     (HL)
    LD      (LETTERMON_EXTRAFLAGP2),A
    INC     HL
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,(LETTERMON_DATA_P1)
    JR      Z,LOC_8297
    LD      A,(LETTERMON_DATA_P2)
LOC_8297:
    AND     (HL)
    LD      HL,0
    JR      Z,LOC_82A0
    LD      HL,5
LOC_82A0:
    ADD     HL,BC
    LD      A,2
    LD      IY,1
    CALL    PUT_VRAM
LOC_82AA:
    LD      A,(LETTERMON_EXTRAFLAGP1)
    AND     A
    RET     Z
    LD      HL,BYTE_82D3
    LD      DE,2BH
LOC_82B6:
    RRCA
    JR      C,LOC_82BF
    INC     HL
    INC     HL
    INC     DE
    INC     DE
    JR      LOC_82B6
LOC_82BF:
    LD      A,(LETTERMON_EXTRAFLAGP1)
    AND     (HL)
    LD      (LETTERMON_EXTRAFLAGP1),A
    LD      HL,BYTE_82DD
    LD      A,2
    LD      IY,1
    CALL    PUT_VRAM
RET

BYTE_82D3:
    DB 254,001,253,002,251,004,247,008,239,016      ; AND and OR MASKS
BYTE_82DD:
    DB 0

SETBONUS:
    LD      HL,GAMEFLAGSBONUSITEM
    BIT     0,(HL)
    JR      Z,LOC_8305
    RES     0,(HL)
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,(CURRENT_LEVEL_P1)
    JR      Z,LOC_82F4
    LD      A,(CURRENT_LEVEL_P2)
LOC_82F4:
    DEC     A
    CP      0AH
    JR      C,LOC_82FB
    LD      A,9
LOC_82FB:
    LD      HL,BONUS_OBJ_LIST
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      A,(HL)          ; choose bonus to set
    JR      LOC_830D
LOC_8305:
    BIT     1,(HL)
    JR      Z,LOC_8310
    RES     1,(HL)
    LD      A,0EH           ; remove bonus
LOC_830D:
    CALL    PRINT_MESSAGE
LOC_8310:
    LD      HL,DIAMOND_RAM
    BIT     7,(HL)
    RET     Z
    LD      IX,APPLEDATA
    LD      B,(IX+1)        ; B = Y-1,C=X
    LD      C,(IX+2)
    LD      D,0             ; D=0 removes the apple
    BIT     0,(HL)
    JR      NZ,LOC_8329
    LD      D,4                 ; Diamond
LOC_8329:
    LD      A,(HL)
    XOR     1
    LD      (HL),A
    LD      A,13                ;  Diamond! Use apple n. 13 (second out of 5)
    CALL    PUTSPRITE
RET

; BONUS ITEM LIST
BONUS_OBJ_LIST:
    db   6,10,11,12,13,16,17,18,19,20

START:
    LD      HL,$7000            ; clean user ram
    LD      DE,$7000+1
    LD      BC,$3FE-1           ; all zeros till to the end of the ram - needed as we skip the coleco screen
    LD      (HL),0
    LDIR
    LD      A,1             ; ???
    LD      (MUX_SPRITES),A
    LD      HL,$1f01
    LD      (RAND_NUM),HL       ; needed as we skip the coleco screen
    XOR     A                   ; ???
    LD      (DEFER_WRITES),A
    CALL    INITIALIZE_THE_SOUND
    LD      A,20                ; show only 20 sprites in total
    CALL    INIT_SPR_NM_TBL
    LD      HL,TIMER_TABLE
    LD      DE,TIMER_DATA_BLOCK
    CALL    INIT_TIMER
    LD      HL,CONTROLLER_BUFFER
    LD      A,9BH
    LD      (HL),A
    INC     HL
    LD      (HL),A

LOC_8372:

    ; Initialize the game

    CALL    cvb_ANIMATEDLOGO
    CALL    INIT_VRAM

        ; GAME START
    XOR     A
LOC_8375:
    PUSH    AF          ; Disables NMI,sets up the game
    CALL    WAIT_NMI
    POP     AF
    PUSH    AF
    CALL    Z,SUB_851C  ; if Z restart the game
    CALL    SUB_8585
    POP     AF
    CP      2
    CALL    NZ,CLEAR_SCREEN_AND_SPRITES_01
    CALL    BUILD_LEVEL
    CALL    SUB_Start_the_level

    CALL    CURRTIMERINIT       ; update pointer to timer
    CALL    FREESIGNTIMER       ; avoid lost timers (??)

    ; DEBUGGER! COMMENT
;   CALL    ExtraMrDo           ; TEST EXTRA MRDO SCREEN
;   CALL    WONDERFUL           ; TEST WONDERFUL SCREEN
;   CALL    INTERMISSION        ; TEST INTERMISSION SCREEN
;   CALL    CONGRATULATION      ; TEST CONGRATULATION SCREEN

        ; GAME MAIN LOOP
LOC_8378:
    CALL    CHECK_FOR_PAUSE
    CALL    DEAL_WITH_APPLE_FALLING
    CP      1
    JP      Z,LOC_83AB
    AND     A
    JR      Z,.continue1  ; If NZ,Last enemy killed by an apple (don't jump)

    LD    C,2     ; MONSTERS
    CALL    STORE_COMPLETION_TYPE
    JP      ADVANCE_TO_NEXT_LEVEL

.continue1:
    CALL    DEAL_WITH_BALL
    AND     A
    JR      Z,.continue2 ; If NZ,Last enemy killed by A ball (don't jump)

    ; Enemies killed by A ball,store the stat
    LD    C,2   ; MONSTERS
    CALL    STORE_COMPLETION_TYPE
    JP      ADVANCE_TO_NEXT_LEVEL

.continue2:
    CALL    LEADS_TO_CHERRY_STUFF
    AND     A
    JR      Z,.continue3 ; if NZ,all the cherries collected (or diamond collected)

    ; Either cherries or diamond collected,store the stats
    CP      $82
    JR      Z,.diamonds   ; C = 1 for cherries

    LD      C,1
    CALL    STORE_COMPLETION_TYPE
    JP      ADVANCE_TO_NEXT_LEVEL

.diamonds:

    LD      C,3     ; Diamond completion type
    CALL    STORE_COMPLETION_TYPE
    JP      ADVANCE_TO_NEXT_LEVEL

.continue3:
    CALL    SUB_A7F4
    AND     A
    JR      NZ,LOC_83AB
    CALL    SUB_9842
    CP      1
    JR      Z,LOC_83AB      ; if Z MrDo collided an enemy
    AND     A
    JP      NZ,ADVANCE_TO_NEXT_LEVEL ; ??
    CALL    SUB_A53E
    AND     A
    JP      Z,LOC_8378
    CP      1
    JR      NZ,ADVANCE_TO_NEXT_LEVEL ; ??
LOC_83AB:

    ; animate here the MrDo death
    CALL    MrDoDeathSequence

LOC_83ABX:
    LD      IX,APPLEDATA        ; apple data array
    LD      B,5                 ; apple number
LOOP_83B1:                      ; MrDo is dead,let apples fall if any
    BIT     3,(IX+0)
    JR      NZ,LOC_83C0         ; if this apple is falling make it fall
    LD      DE,5
    ADD     IX,DE
    DJNZ    LOOP_83B1           ; ?? probably only one apple falling at time...

LOC_83C5: ; Mr. Do finished the round
    AND A                       ; if Z you have an extra MrDo ?
    JR      NZ,ADVANCE_TO_NEXT_LEVEL
    LD      A,1
ADVANCE_TO_NEXT_LEVEL:

    CALL    GOT_DIAMOND         ; this is dealing with more than Diamonds
    CP      3
    JP      Z,LOC_8372
    JP      LOC_8375
LOC_83C0:
    CALL    DEAL_WITH_APPLE_FALLING
    JR      LOC_83ABX

MrDoDeathSequence:
    PUSH    AF
    LD      bc,4*256+48         ; C is the pointer to the current frame: Death starts from 48
.nextframe:
    PUSH    bc
    LD      HL,20               ; 20 x 4 = 80 /60 = 1.33 sec
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
.wait:

    LD      IX,APPLEDATA        ; apple data array
    LD      B,5                 ; apple number
.NextApple:                     ; MrDo is dead,let apples fall if any
    BIT     3,(IX+0)
    PUSH        IX
    PUSH        BC
    CALL        NZ,DEAL_WITH_APPLE_FALLING      ; if this apple is falling make it fall
    POP         BC
    POP         IX
    LD      DE,5
    ADD     IX,DE
    DJNZ    .NextApple

    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.wait
    POP     AF
    POP     BC
    LD      A,C
    INC     C
    PUSH    BC
    CALL    SETMRDOFRAME    ; Update the current frame of the player
    POP     BC
    djnz  .nextframe
    POP     AF
RET

REMOVESPRITES:
    LD      HL,SPRITE_NAME_TABLE
    LD      B,50H
.1:
    LD      (HL),$D1
    INC     HL
    DJNZ    .1
RET

INIT_VRAM:
    LD      BC,0
    CALL    WRITE_REGISTER
    LD      BC,182H     ; Disable video, disable NMI
    CALL    WRITE_REGISTER
    LD      BC,700H
    CALL    WRITE_REGISTER

    LD      HL,CT       ; avoid glitches during screen transition
    LD      DE,256*8
    XOR     A           ; CLEAR CT
    CALL    FILL_VRAM

    XOR     A           ; SAT
    LD      HL,SAT
    CALL    INIT_TABLE
    LD      A,1     ; SPT
    LD      HL,SPT
    CALL    INIT_TABLE
    LD      A,2     ; PNT
    LD      HL,PNT
    CALL    INIT_TABLE
    LD      A,3     ; PT
    LD      HL,PT
    CALL    INIT_TABLE
    LD      A,4     ; CT
    LD      HL,CT
    CALL    INIT_TABLE

;   LD      HL,EXTRA_SPRITE_PAT ; EXTRA+Apples+Diamond+Balls
;   LD      DE,60H
;   LD      IY,80+6*4               ; OS7 BUG should have been 72+6*4
;   LD      A,1
;   CALL    PUT_VRAM

    LD      DE,SPT+24*32
    LD      HL,EXTRA_SPRITE_COMP
    CALL    unpack


    LD      IX,ENEMY_GENERATOR      ; Load chompers and bad guys pushing in the SPT
    LD      B,24+12+4               ; 24 frames for badguys/diggers + 12  for chompers + 4 bad guys pushing
.1: PUSH    BC
    PUSH    IX
    LD      IY,4
    CALL    UPDATE_SPT
    POP     IX
    LD      DE,5
    ADD     IX,DE
    POP     BC
    DJNZ    .1

; screen 2 hack
    CALL MYMODE1                    ; switch to intermission  mode (Disable video, enable NMI)

; load tile graphics

    LD      DE,PT
    LD      HL,tileset_bitmap
    CALL    unpack
    LD      DE,PT+256*8
    LD      HL,tileset_bitmap
    CALL    unpack
    LD      DE,PT+256*8*2
    LD      HL,tileset_bitmap
    CALL    unpack

    LD      DE,CT
    LD      HL,tileset_color
    CALL    unpack

    CALL    LOADFONTS

    LD HL,mode
    RES 7,(HL)          ; game mode

    LD      BC,1E2H             ; Original game state register: Enable video and NMI
    CALL    WRITE_REGISTER
RET

LOADFONTS:      ; LOAD  ARCADE FONTS
    LD      DE,PT + 8*0d7h                  ; start fonts here
    LD      HL,ARCADEFONTS
    CALL    unpack
    LD      DE,PT + 256*8 + 8*0d7h          ; start fonts here
    LD      HL,ARCADEFONTS
    CALL    unpack
    LD      DE,PT + 256*8*2 + 8*0d7h        ; start fonts here
    LD      HL,ARCADEFONTS
    CALL    unpack

    LD      HL,CT+0d7h*8
    LD      BC,41*8
    LD      A,$F1
    CALL    cvb_MYCLS.0
RET





SUB_851C:                   ; If we're here,the game just started
    XOR     A
    LD      HL,0
    LD      (SCORE_P1),A
    LD      (SCORE_P1_RAM),HL
    LD      (SCORE_P2),A
    LD      (SCORE_P2_RAM),HL
    LD      (P1_PREV_SCORE),HL
    LD      (P2_PREV_SCORE),HL
    CALL    Reset_p1        ; reset min and sec for the two players
    CALL    Reset_p2

    LD      A,1         ; Set the starting level to 1
    LD      (CURRENT_LEVEL_P1),A
    LD      (CURRENT_LEVEL_P2),A
    XOR     A
    LD      (LETTERMON_SPAWNP1),A
    LD      (LETTERMON_SPAWNP2),A
    LD      A,(SKILLLEVEL)
    CP      2
    LD      A,3     ; Set the number of lives to 3 for skill 1 and 2
    JR      NC,LOC_853F
    LD      A,5     ; Set the number of lives to 5 for skill 3 and 4
LOC_853F:
    LD      (LIVES_LEFT_P1_RAM),A
    LD      (LIVES_LEFT_P2_RAM),A

    LD      A,(GAMECONTROL)
    AND     1                   ; save B0 == number of players
    LD      (GAMECONTROL),A     ; reset B1 == current player

    LD      A,1
    CALL    SUB_B286        ; build level 1

    LD      HL,LEVELMAP
    LD      DE,3400H        ; VRAM area for P1 data
    LD      BC,0D4H     ; save in VRAM 212 bytes of game state for P1
    CALL    WRITE_VRAM

    LD      HL,LEVELMAP
    LD      DE,3600H        ; VRAM area for P2 data
    LD      BC,0D4H     ; save in VRAM 212 bytes of game state for P2
    CALL    WRITE_VRAM

    CALL    SUB_866B
    LD      HL,LETTERMON_DATA_P1
    LD      B,0BH
    XOR     A
LOC_8573:
    LD      (HL),A
    INC     HL
    DJNZ    LOC_8573
    LD      A,8
    LD      (LETTERMON_COUNTER),A
    LD      A,7             ; Enemy Number
    LD      (ENEMY_NUM_P1),A
    LD      (ENEMY_NUM_P2),A
RET

SUB_8585:
    XOR     A
    LD      (BALLDATA),A
    LD      ($72DD),A
    LD      (GAMEFLAGSBONUSITEM),A
    LD      (DIAMOND_RAM),A
    LD      HL,GAMECONTROL
    RES     6,(HL)
    LD      DE,3400H
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,LOC_85A4
    LD      DE,3600H
LOC_85A4:
    LD      HL,LEVELMAP
    LD      BC,0D4H
    CALL    READ_VRAM
    XOR     A
    LD      (BADGUY_BHVR_CNT_RAM),A
    LD      HL,BADGUY_BEHAVIOR_RAM
    LD      B,80
LOC_85B6:
    LD      (HL),A
    INC     HL
    DJNZ    LOC_85B6

    CALL    GET_LEVEL
    DEC     A
    ADD     A,A
    LD      E,A
    LD      D,0
    LD      IX,BADGUY_BEHAVIOR
    ADD     IX,DE
    LD      L,(IX+0)
    LD      H,(IX+1)
    LD      A,(HL)
    LD      (BADGUY_BHVR_CNT_RAM),A
    LD      C,(HL)
    LD      B,0
    INC     HL
    LD      DE,BADGUY_BEHAVIOR_RAM
    LDIR
    LD      HL,TIMER_TABLE
    LD      DE,TIMER_DATA_BLOCK
    CALL    INIT_TIMER

    CALL    SET_LEVEL_COLORS

    LD      HL,GAMEFLAGS
    LD      B,16H               ; 22 bytes of GAMEFLAGS ?
    XOR     A
LOC_862E:
    LD      (HL),A              ; Reset GAMEFLAGS ??
    INC     HL
    DJNZ    LOC_862E
    CALL    SUB_866B
    LD      A,($72C1)
    AND     7
    LD      ($72C1),A
    LD      A,(LETTERMON_COUNTER)
    AND     3FH
    LD      (LETTERMON_COUNTER),A
    LD      HL,ENEMY_NUM_P1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_8652
    INC     HL      ; point to ENEMY_NUM_P2
LOC_8652:
    LD      A,(HL)
    CP      7
    RET     NC
    LD      IY,ENEMY_DATA_ARRAY+6*6 ; last enemy
LOC_865C:
    LD      (IY+4),0C0H
    LD      DE,-6
    ADD     IY,DE
    INC     A
    CP      7
    JR      NZ,LOC_865C
RET

SUB_866B:
    LD      HL,BADGUYFLAGS
    LD      B,2EH
    XOR     A
LOOP_8671:
    LD      (HL),A
    INC     HL
    DJNZ    LOOP_8671
RET

CLEAR_SCREEN_AND_SPRITES_01:
    LD      HL,PNT
    LD      DE,300H
    XOR     A
    CALL    FILL_VRAM
    LD      HL,SAT
    LD      DE,80H
    XOR     A
    CALL    FILL_VRAM
    CALL    REMOVESPRITES
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,4             ; get ready player 1
    JR      Z,LOC_86A1
    LD      A,5             ; get ready player 2
LOC_86A1:
    CALL    PRINT_MESSAGE
    LD      BC,1E2H
    CALL    WRITE_REGISTER

    LD      HL,0B4H         ; short pause
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_86B2:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,LOC_86B2
    POP     AF
    CALL    WAIT_NMI
RET

BUILD_LEVEL:
    LD      BC,1C2H         ; disable interrupt NMI
    CALL    WRITE_REGISTER

    LD      HL,PNT          ; vram PATTERN_NAME_TABLE
    LD      DE,300H
    XOR     A
    CALL    FILL_VRAM
    LD      HL,SAT              ; vram SPRITE_ATTRIBUTE_TABLE
    LD      DE,80H
    XOR     A
    CALL    FILL_VRAM
    CALL    REMOVESPRITES

    LD      A,0A0H                      ; plot level line by line from the bottom (10 blocks 2 lines each)
NEXTLINE:
    PUSH    AF
    CALL    DISPLAY_PLAY_FIELD_PARTS    ; plot A line of blocks
    POP     AF
    DEC     A
    JR      NZ,NEXTLINE

    LD      A,1
    CALL    PRINT_MESSAGE
    XOR     A
    CALL    PRINT_SCORE
    LD      A,(GAMECONTROL)
    BIT     0,A
    JR      Z,LOC_8709          ; B0 == one player
    LD      A,0FH
    CALL    PRINT_MESSAGE
    LD      A,1
    CALL    PRINT_SCORE
LOC_8709:
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,(CURRENT_LEVEL_P1)
    JR      Z,LOC_8716
    LD      A,(CURRENT_LEVEL_P2)
LOC_8716:
    LD      HL,SCRATCH
    LD      D,0D8H
    LD      IY,1
    CP      0AH
    JR      NC,LOC_8728
    ADD     A,0D8H
    LD      (HL),A
    JR      LOC_8739
LOC_8728:
    CP      0AH
    JR      C,LOC_8731
    SUB     0AH
    INC     D
    JR      LOC_8728
LOC_8731:
    INC     IY
    LD      (HL),D
    INC     HL
    ADD     A,0D8H
    LD      (HL),A
    DEC     HL
LOC_8739:
    LD      DE,3DH
    LD      A,2
    CALL    PUT_VRAM
    LD      A,2
    CALL    PRINT_MESSAGE
    LD      HL,LETTERMON_DATA_P1
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,LOC_8753
    LD      HL,LETTERMON_DATA_P2
LOC_8753:
    LD      DE,12BH
    LD      BC,0
LOC_8759:
    LD      A,(HL)
    PUSH    HL
    LD      HL,EXTRA_01_TXT
    AND     D
    JR      Z,SEND_EXTRA_TO_VRAM
    LD      HL,EXTRA_02_TXT
SEND_EXTRA_TO_VRAM:
    ADD     HL,BC
    PUSH    BC
    PUSH    DE
    LD      D,0
    LD      IY,1
    LD      A,2
    CALL    PUT_VRAM
    POP     DE
    POP     BC
    POP     HL
    INC     E
    INC     E
    RLC     D
    INC     C
    LD      A,C
    CP      5
    JR      NZ,LOC_8759
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      HL,LIVES_LEFT_P1_RAM
    JR      Z,LOC_878C
    LD      HL,LIVES_LEFT_P2_RAM
LOC_878C:
    LD      B,(HL)
    LD      DE,35H
SEND_LIVES_TO_VRAM:
    DEC     B
    JR      Z,LOC_87B9
    PUSH    BC
    PUSH    DE
    LD      HL,MR_DO_ICON
    LD      IY,1
    LD      A,2
    CALL    PUT_VRAM
    POP     HL
    PUSH    HL
    LD      DE,20H
    ADD     HL,DE
    EX      DE,HL
    LD      HL,MR_DO_ICON+1
    LD      IY,1
    LD      A,2
    CALL    PUT_VRAM
    POP     DE
    POP     BC
    INC     DE
    JR      SEND_LIVES_TO_VRAM
LOC_87B9:
    LD      A,3
    CALL    PRINT_MESSAGE
    LD      B,5
    LD      IY,APPLEDATA
    LD      A,12
LOOP_87C6:
    BIT     7,(IY+0)
    JR      Z,LOC_87DF
    PUSH    BC
    PUSH    IX
    PUSH    AF
    LD      B,(IY+1)
    LD      C,(IY+2)
    LD      D,1         ; set integer apple
    CALL    PUTSPRITE
    POP     AF
    POP     IX
    POP     BC
LOC_87DF:
    LD      DE,5
    ADD     IY,DE
    INC     A
    DJNZ    LOOP_87C6
RET

EXTRA_01_TXT:
    DB  53,54,55,56,57      ; EXTRA yellow
EXTRA_02_TXT:
    DB  48,49,50,51,52      ; EXTRA red
MR_DO_ICON:
    DB  75,107

SUB_Start_the_level:   ; SUB_87F4
    LD      IY,MRDO_DATA
    XOR     A
    LD      (IY+6),A        ; $7287 = ??
    LD      (IY+7),A        ; $7288 = ??
    LD      A,1
    LD      (IY+1),A        ; $7282 = Set Mr. Do's starting direction 1=Right,2=Left,3=Up,4=Down
    LD      (IY+5),A        ; $7286 = ?? CURRENT MRDO FRAME !!!
    LD      (IY+3),0B0H     ; $7284 = Set Mr. Do's starting Y coordinate
    LD      (IY+4),078H     ; $7285 = Set Mr. Do's starting X coordinate
    LD      (IY+0),0C0H     ; $7281 = flag
    LD      BC,1E2H
    CALL    WRITE_REGISTER

    CALL    PLAY_OPENING_TUNE
    LD      HL,1
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (MRDO_DATA.Timer),A     ; $7283 = Mr Do's Timer ?
RET

CHECK_FOR_PAUSE:            ; CHECK_FOR_PAUSE
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,(KEYBOARD_P1)
    JR      Z,.ply1
    LD      A,(KEYBOARD_P2)
.ply1:
    CP      0AH
    RET     NZ

    CALL    WAIT_NMI

    SET     3,(HL)                  ; stop sprite update

    XOR     A
    LD      HL,SAT                  ; remove sprites
    LD      DE,80H
    CALL    FILL_VRAM

    LD      A,2
    LD      HL,3800H
    CALL    INIT_TABLE              ; enable alternative PNT at 3800H

    LD      HL,STATESTART           ; save to VRAM the sound state
    LD      DE,3B00H
    LD      BC,5DH                  ; 93 bytes of sound state saved at 3B00h in VRAM
    CALL    WRITE_VRAM

    LD      BC,1E2H
    CALL    WRITE_REGISTER

    CALL    PLAY_END_OF_ROUND_TUNE

    CALL    DELAY

.wait_star:
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,(KEYBOARD_P1)
    JR      Z,.plr1
    LD      A,(KEYBOARD_P2)
.plr1:
    CP      0AH
    JR      NZ,.wait_star

    CALL    INITIALIZE_THE_SOUND

    CALL    WAIT_NMI

    ; SET       4,(HL)

    LD      A,2
    LD      HL,PNT
    CALL    INIT_TABLE          ; enable PNT

    LD      BC,1E2H
    CALL    WRITE_REGISTER

    LD      HL,GAMECONTROL
    RES     3,(HL)              ; enable sprites

    CALL    DELAY

    CALL    WAIT_NMI

    ; RES       4,(HL)

    LD      HL,STATESTART       ; restore from VRAM the sound state
    LD      DE,3B00H
    LD      BC,5DH
    CALL    READ_VRAM

    LD      BC,1E2H
    CALL    WRITE_REGISTER
RET

DELAY:
    LD      B,2
.wait_ext:
    LD      HL,0
.wait:
    DEC     HL
    LD      A,L
    OR      H
    JR      NZ,.wait
    DJNZ    .wait_ext
RET

WAIT_NMI:
    LD      HL,GAMECONTROL
    SET     7,(HL)
.1:
    BIT     7,(HL)
    JR      NZ,.1
RET

DEAL_WITH_APPLE_FALLING:
    LD      IY,APPLEDATA
    LD      HL,BYTE_896C
    LD      A,(CURRAPPL)
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      C,(HL)
    ADD     IY,BC

    XOR     A
    BIT     7,(IY+0)
    JP      Z,LEADS_TO_FALLING_APPLE_04
    LD      A,(IY+0)
    BIT     3,A
    JR      NZ,LEADS_TO_FALLING_APPLE_01
    XOR     A
    CALL    SUB_8E10
    JR      Z,LEADS_TO_FALLING_APPLE_04
    JR      LOC_8941
LEADS_TO_FALLING_APPLE_01:
    LD      A,(IY+3)
    CALL    TEST_SIGNAL
    JR      Z,LEADS_TO_FALLING_APPLE_04
    LD      A,(IY+0)
    BIT     6,A
    JR      Z,LEADS_TO_FALLING_APPLE_02
    CALL    SUB_8FB0
    JR      NZ,LOC_8941
LEADS_TO_FALLING_APPLE_02:
    LD      A,(IY+0)
    BIT     4,A
    JR      Z,LEADS_TO_FALLING_APPLE_05
    PUSH    IY
    CALL    PLAY_APPLE_BREAKING_SOUND
    POP     IY
    JR      LEADS_TO_FALLING_APPLE_07
LEADS_TO_FALLING_APPLE_05:
    BIT     5,A
    JR      NZ,LEADS_TO_FALLING_APPLE_06
LEADS_TO_FALLING_APPLE_07:
    LD      A,(IY+4)
    LD      B,A
    AND     0CFH
    LD      C,A
    LD      A,B
    ADD     A,10H
    AND     30H
    OR      C
    LD      (IY+4),A
    AND     30H
    JR      Z,LOC_892A
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
    JR      Z,LOC_8945
LOC_8941:

;   CALL    SUB_8972
;SUB_8972:
    LD      HL,0FH
    LD      A,(IY+0)
    BIT     6,A
    JR      NZ,LOC_8992
    LD      HL,4
    BIT     5,A
    JR      NZ,LOC_8992
    LD      HL,19H
LOC_8992:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A
;RET

    XOR     A
LOC_8945:
    PUSH    AF
    CALL    SUB_899A
    POP     AF
LEADS_TO_FALLING_APPLE_04:
    PUSH    AF
    LD      A,(CURRAPPL)
    INC     A
    CP      5
    JR      C,LOC_8954
    XOR     A
LOC_8954:
    LD      (CURRAPPL),A
    POP     AF
    AND     A
RET


BYTE_896C:
    DB 000,005,010,015,020,025

;SUB_8972:
;   LD      HL,0FH
;   LD      A,(IY+0)
;   BIT     6,A
;   JR      NZ,LOC_8992
;   LD      HL,4
;   BIT     5,A
;   JR      NZ,LOC_8992
;   LD      HL,19H
;
;LOC_8992:
;   XOR     A
;   CALL    REQUEST_SIGNAL
;   LD      (IY+3),A
;RET

SUB_899A:
    LD      A,(IY+4)
    RRCA
    RRCA
    RRCA
    RRCA
    AND     3
    LD      D,A
    LD      B,(IY+1)
    LD      C,(IY+2)
    LD      A,(IY+0)
    BIT     6,A
    JR      Z,LOC_89C1
    AND     7
    CP      2
    JR      Z,LOC_89C1
    CP      1
    JR      NZ,LOC_89BF
    DEC     C
    DEC     C
    JR      LOC_89C1
LOC_89BF:
    INC     C
    INC     C
LOC_89C1:
    LD      A,D
    AND     A
    JR      NZ,LOC_89C8
    LD      BC,$D908
LOC_89C8:
    LD      A,(CURRAPPL)            ; which apple to show
    ADD     A,12
    CALL    PUTSPRITE
RET

SUB_89D1:
    PUSH    IY
    LD      A,(IY+4)
    AND     0FH
    JR      Z,LOC_89E9
    DEC     A
    ADD     A,A
    LD      C,A
    LD      B,0
    LD      HL,BYTE_89EC
    ADD     HL,BC
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    CALL    SUB_B601        ; score for apples smashed (enemy smashed?)
LOC_89E9:
    POP     IY
RET

BYTE_89EC:
    DW 100,200,600,800,1000,1200,1400,1600,1800,2000,2200

DEAL_WITH_RANDOM_DIAMOND:
    PUSH    IY
    CALL    SUB_8A31
    CP      1
    JR      NZ,LOC_8A2E
    CALL    RAND_GEN
    AND     0FH
    CP      2
    JR      NC,LOC_8A2E
    LD      B,(IY+1)
    LD      C,(IY+2)
    LD      IX,APPLEDATA
    LD      (IX+1),B
    LD      (IX+2),C
    LD      A,80H
    LD      (DIAMOND_RAM),A
    CALL    PLAY_DIAMOND_SOUND
LOC_8A2E:
    POP     IY
RET

SUB_8A31:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      IX,APPLEDATA
    LD      B,5
    LD      C,0
    LD      DE,5
LOOP_8A40:
    BIT     7,(IX+0)
    JR      Z,LOC_8A47
    INC     C
LOC_8A47:
    ADD     IX,DE
    DJNZ    LOOP_8A40
    LD      A,C
    POP     IX
    POP     DE
    POP     BC
;   AND     A   ; unused
RET

DEAL_WITH_APPLE_HITTING_SOMETHING:
    LD      B,(IY+1)
    LD      C,(IY+2)
    LD      A,C
    AND     0FH
    JR      Z,LOC_8A67
    CP      8
    JR      Z,LOC_8A67
    LD      A,C
    ADD     A,8
    AND     0F0H
    LD      C,A
LOC_8A67:
    CALL    SUB_8AD9
    LD      A,(IY+1)        ; PUSH apple ?
    ADD     A,4
    LD      (IY+1),A
    LD      A,(IY+0)
    INC     A
    LD      B,A
    AND     7
    CP      6
    JR      NC,LOC_8A80
    LD      (IY+0),B
LOC_8A80:
    CALL    SUB_8BF6    ; letter interaction
    CALL    SUB_8C3A    ; bad guy interaction
    CALL    SUB_8C96    ; chomper interaction
    CALL    SUB_8BC0    ; MrDo interaction
    LD      A,(IY+1)
    AND     7
    JR      NZ,LOC_8AD7
    CALL    SUB_8D25
    JR      NZ,APPLE_FELL_ON_SOMETHING
    LD      A,1
    CALL    SUB_8E48
    JR      NZ,LOC_8AD7
    LD      A,(IY+4)
    BIT     7,A
    JR      NZ,APPLE_FELL_ON_SOMETHING
    BIT     6,A
    JR      NZ,APPLE_FELL_ON_SOMETHING
    AND     0FH
    JR      NZ,APPLE_FELL_ON_SOMETHING
    LD      A,(IY+0)
    AND     7
    CP      5
    JR      NC,APPLE_FELL_ON_SOMETHING
    LD      (IY+0),80H
    LD      (IY+4),10H
    XOR     A
    JR      LOC_8AD7
APPLE_FELL_ON_SOMETHING:
    RES     5,(IY+0)
    PUSH    IY
    CALL    PLAY_APPLE_BREAKING_SOUND
    POP     IY
    LD      A,(IY+4)
    ADD     A,10H
    LD      (IY+4),A
LOC_8AD7:
    AND     A
RET

SUB_8AD9:
    LD      A,B
    AND     0FH
    RET     NZ
    CALL    PEEKMAP
    DEC     IX
    DEC     D       ;***
    LD      A,(IX+11H)
    AND     3
    CP      3
    RET     NZ
    BIT     3,C
    JR      NZ,LOC_8AF7
    LD      A,(IX+10H)
    AND     3
    CP      3
    RET     NZ
LOC_8AF7:
    LD      A,(IX+1)
    AND     0CH
    CP      0CH
    JR      NZ,LOC_8B09
    LD      A,B
    CP      0E8H
    JR      NC,LOC_8B09
    SET     5,(IX+1)
LOC_8B09:
    BIT     0,(IX+1)
    JR      Z,LOC_8B1D
    BIT     1,(IX+0)
    JR      Z,LOC_8B1D
    BIT     3,C
    JR      NZ,LOC_8B1D
    SET     7,(IX+1)
LOC_8B1D:
    LD      A,D
    INC     A
    CALL    SUB_8BB1
    LD      A,B
    CP      0B8H
    JR      NC,LOC_8B54
    LD      A,(IX+1)
    AND     0CH
    CP      0CH
    JR      NZ,LOC_8B34
    SET     4,(IX+11H)
LOC_8B34:
    LD      A,(IX+11H)
    AND     5
    CP      5
    JR      NZ,LOC_8B4E
    LD      A,(IX+10H)
    AND     0AH
    CP      0AH
    JR      NZ,LOC_8B4E
    BIT     3,C
    JR      NZ,LOC_8B4E
    SET     7,(IX+11H)
LOC_8B4E:
    LD      A,D
    ADD     A,11H
    CALL    SUB_8BB1
LOC_8B54:
    BIT     3,C
    RET     NZ
    LD      A,(IX+0)
    AND     0CH
    CP      0CH
    JR      NZ,LOC_8B69
    LD      A,B
    CP      0B8H
    JR      NC,LOC_8B69
    SET     5,(IX+0)
LOC_8B69:
    LD      A,(IX+0)
    AND     0AH
    CP      0AH
    JR      NZ,LOC_8B7F
    LD      A,(IX+1)
    AND     5
    CP      5
    JR      NZ,LOC_8B7F
    SET     6,(IX+0)
LOC_8B7F:
    LD      A,D
    CALL    SUB_8BB1
    LD      A,B
    CP      0B8H
    RET     NC
    LD      A,(IX+0)
    AND     0CH
    CP      0CH
    JR      NZ,LOC_8B94
    SET     4,(IX+10H)
LOC_8B94:
    LD      A,(IX+10H)
    AND     0AH
    CP      0AH
    JR      NZ,LOC_8BAA
    LD      A,(IX+11H)
    AND     5
    CP      5
    JR      NZ,LOC_8BAA
    SET     6,(IX+10H)
LOC_8BAA:
    LD      A,D
    ADD     A,10H
    CALL    SUB_8BB1
RET

SUB_8BB1:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    POP     BC
RET

SUB_8BC0:   ; Mr. Do interesecting with A falling apple
    LD      A,(MRDO_DATA.Y)         ; A = MrDo's Y
    LD      D,A
    BIT     7,(IY+4)
    JR      Z,LOC_8BCE
    ADD     A,4
    JR      LOC_8BE4
LOC_8BCE:
    LD      A,(MRDO_DATA.X)         ; A = MrDo's X
    LD      E,A
    CALL    SUB_8CFE
    RET     NZ          ;   JR      NZ,LOC_8BF4
    SET     7,(IY+4)
    LD      A,(GAMECONTROL)
    SET     6,A
    LD      (GAMECONTROL),A
    LD      A,D
LOC_8BE4:
    LD      (MRDO_DATA.Y),A
    XOR     A
    LD      (MRDO_DATA.Frame),A         ; Mr Do current frame 0 == death
    LD      A,(MRDO_DATA)
    SET     7,A
    LD      (MRDO_DATA),A
    XOR     A
;LOC_8BF4:
;   AND     A
RET

SUB_8BF6:   ; Falling apple
    LD      A,(LETTERMON_COUNTER)
    LD      B,A
    LD      A,1
    BIT     7,B
    JR      Z,LOC_8C38
    LD      A,(LETTERMON_Y)
    LD      D,A
    BIT     6,(IY+4)
    JR      Z,LOC_8C0F
    ADD     A,4
    LD      D,A
    JR      LOC_8C28
LOC_8C0F:
    LD      A,(LETTERMON_X)
    LD      E,A
    CALL    SUB_8CFE
    JR      NZ,LOC_8C38
    LD      A,(LETTERMON_FLAG)
    SET     7,A
    LD      (LETTERMON_FLAG),A
    SET     6,(IY+4)
    INC     (IY+4)
    LD      A,D
LOC_8C28:
    LD      (LETTERMON_Y),A
    LD      B,D
    LD      A,(LETTERMON_X)
    LD      C,A
    LD      D,0BH
    LD      A,3         ; smashed letter
    CALL    PUTSPRITE
    XOR     A
LOC_8C38:
    AND     A
RET

SUB_8C3A:   ; Falling apple
    LD      B,7
    LD      IX,ENEMY_DATA_ARRAY
LOC_8C40:
    PUSH    BC
    BIT     7,(IX+4)
    JR      Z,LOC_8C8D
    BIT     6,(IX+4)
    JR      NZ,LOC_8C8D
    LD      D,(IX+2)
    LD      E,(IX+1)
    BIT     7,(IX+0)
    JR      Z,LOC_8C68
    LD      A,(CURRAPPL)
    CP      (IX+5)
    JR      NZ,LOC_8C8D
    LD      A,D
    ADD     A,4
    LD      D,A
    JR      LOC_8C7A
LOC_8C68:
    CALL    SUB_8CFE
    JR      NZ,LOC_8C8D
    SET     7,(IX+0)
    LD      A,(CURRAPPL)
    LD      (IX+5),A
    INC     (IY+4)          ;  apple counter
LOC_8C7A:
    LD      (IX+2),D
    LD      B,D
    LD      C,E
    CALL    SUB_B7EF
    ADD     A,5
    LD      D,37        ; digger
    PUSH    IX
    CALL    PUTSPRITE
    POP     IX
LOC_8C8D:
    LD      DE,6
    ADD     IX,DE
    POP     BC
    DJNZ    LOC_8C40
RET

SUB_8C96:   ; Falling apple ?
    LD      B,3         ; chomper number
    LD      IX,CHOMPDATA        ; chomper data
LOC_8C9C:
    PUSH    BC
    BIT     7,(IX+4)
    JR      Z,LOC_8CF5
    LD      D,(IX+2)
    LD      E,(IX+1)
    BIT     7,(IX+0)
    JR      Z,LOC_8CBE
    LD      A,(CURRAPPL)
    CP      (IX+5)
    JR      NZ,LOC_8CF5
    LD      A,D
    ADD     A,4
    LD      D,A
    JR      LOC_8CD0
LOC_8CBE:
    CALL    SUB_8CFE
    JR      NZ,LOC_8CF5
    SET     7,(IX+0)
    LD      A,(CURRAPPL)
    LD      (IX+5),A
    INC     (IY+4)          ; apple timer
LOC_8CD0:
    LD      (IX+2),D
    LD      B,D
    LD      C,E
    PUSH    IX
    POP     HL
    XOR     A
    LD      DE,CHOMPDATA
                    ;   AND     A       ; CF==0  already
    SBC     HL,DE
    JR      Z,LOC_8CEA
    LD      DE,6
LOC_8CE4:
    INC     A
    AND     A
    SBC     HL,DE
    JR      NZ,LOC_8CE4
LOC_8CEA:
    ADD     A,17            ; chomper
    LD      D,5         ; smashed
    PUSH    IX
    CALL    PUTSPRITE
    POP     IX
LOC_8CF5:
    LD      DE,6
    ADD     IX,DE
    POP     BC
    DJNZ    LOC_8C9C
RET

SUB_8CFE:   ; Check if Mr. Do is intersecting with A falling apple
    PUSH    BC
    LD      C,1
    LD      A,(IY+1)
    SUB     D
    JR      NC,LOC_8D09
    NEG
LOC_8D09:
    CP      8
    JR      NC,LOC_8D21
    LD      A,(IY+2)
    SUB     E
    JR      NC,LOC_8D15
    NEG
LOC_8D15:
    CP      9
    JR      NC,LOC_8D21
    LD      A,(IY+1)
    ADD     A,4
    LD      D,A
    LD      C,0
LOC_8D21:
    LD      A,C
    POP     BC
    OR      A
RET

SUB_8D25:
    LD      IX,APPLEDATA
    LD      BC,0
LOC_8D2C:
    LD      A,(CURRAPPL)
    CP      C
    JR      Z,LOC_8D80
    LD      A,(IX+0)
    BIT     7,A
    JR      Z,LOC_8D80
    BIT     6,A
    JR      NZ,LOC_8D80
    LD      A,(IY+2)
    SUB     (IX+2)
    JR      NC,LOC_8D47
    NEG
LOC_8D47:
    CP      10H
    JR      NC,LOC_8D80
    LD      A,(IX+1)
    SUB     (IY+1)
    JR      C,LOC_8D80
    CP      9
    JR      NC,LOC_8D80
    RES     6,(IX+0)
    RES     5,(IX+0)
    LD      A,(IY+4)
    AND     0CFH
    OR      20H
    LD      (IX+4),A
    BIT     3,(IX+0)
    JR      NZ,LOC_8D7F
    SET     3,(IX+0)
    LD      HL,0FH
    XOR     A
    PUSH    BC
    CALL    REQUEST_SIGNAL
    POP     BC
    LD      (IX+3),A
LOC_8D7F:
    INC     B
LOC_8D80:
    LD      DE,5
    ADD     IX,DE
    INC     C
    LD      A,C
    CP      5
    JR      C,LOC_8D2C
    LD      A,B
    AND     A
RET

DEAL_WITH_LOOSING_LIFE:
    BIT     6,(IY+4)
    JR      Z,LOC_8D9B
    CALL    SUB_B76D
    LD      L,3
    JR      NZ,LOC_8E05
LOC_8D9B:
    LD      IX,ENEMY_DATA_ARRAY     ; enemy data starts here = 6*7 bytes
    LD      B,7         ; test each enemy
LOC_8DA1:
    PUSH    BC
    LD      A,(IX+4)
    BIT     7,A
    JR      Z,LOC_8DC5
    BIT     6,A
    JR      NZ,LOC_8DC5
    BIT     7,(IX+0)
    JR      Z,LOC_8DC5
    LD      A,(CURRAPPL)
    CP      (IX+5)
    JR      NZ,LOC_8DC5
    CALL    SUB_B7C4        ; outupt = ZF
    POP     BC
    LD      L,2
    JR      Z,LOC_8E05
    PUSH    BC
LOC_8DC5:
    LD      DE,6
    ADD     IX,DE       ; next enemy
    POP     BC
    DJNZ    LOC_8DA1

    LD      IX,CHOMPDATA    ; chompers start here ?
    LD      B,3     ; test each chompers
LOOP_8DD3:
    PUSH    BC
    BIT     7,(IX+4)
    JR      Z,LOST_A_LIFE
    BIT     7,(IX+0)
    JR      Z,LOST_A_LIFE
    LD      A,(CURRAPPL)
    CP      (IX+5)
    JR      NZ,LOST_A_LIFE
    CALL    SUB_B832
LOST_A_LIFE:
    POP     BC
    LD      DE,6
    ADD     IX,DE
    DJNZ    LOOP_8DD3
    LD      L,0
    BIT     7,(IY+4)
    JR      Z,LOC_8E05
    PUSH    IY
    CALL    PLAY_LOSE_LIFE_SOUND        ; smashed: no DEATH SEQUENCE HERE
    POP     IY
    LD      L,1
LOC_8E05:
    RES     7,(IY+0)
    RES     3,(IY+0)
    LD      A,L
    AND     A
RET

SUB_8E10:   ; Falling apple logic
    CALL    SUB_8E48
    JR      Z,LOC_8E46
    LD      E,A
    LD      A,(MRDO_DATA.Y)
    SUB     (IY+1)
    JR      C,LOC_8E32
    CP      11H
    JR      NC,LOC_8E32
    LD      A,(MRDO_DATA.X)
    SUB     (IY+2)
    JR      NC,LOC_8E2C
    NEG
LOC_8E2C:
    LD      D,0
    CP      8
    JR      C,LOC_8E45
LOC_8E32:
    LD      B,0C8H
    DEC     E
    JR      Z,LOC_8E3B
    RES     6,B
    SET     5,B
LOC_8E3B:
    LD      (IY+0),B

    LD      (IY+4),$10
    LD      D,1
LOC_8E45:
    LD      A,D
LOC_8E46:
    AND     A
RET

SUB_8E48:
    LD      D,A
    LD      B,(IY+1)
    LD      C,(IY+2)
    PUSH    DE
    CALL    PEEKMAP
    POP     DE
    LD      A,B
    CP      0B0H
    JR      NC,LOC_8E76
    LD      A,(IY+2)
    RLCA
    RLCA
    RLCA
    RLCA
    AND     0F0H
    LD      C,A
    LD      A,(IY+1)
    AND     0FH
    OR      C
    LD      B,8
    LD      HL,UNK_8F98
LOOP_8E6E:
    CP      (HL)
    JR      Z,LOC_8E7A
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
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    PUSH    IX
    PUSH    DE
    POP     IX
    POP     HL
    POP     DE
    JP      (IX)
LOC_8E88:
    LD      BC,10H
    ADD     HL,BC
    XOR     A
    BIT     0,(HL)
    JR      Z,LOC_8E97
    DEC     HL
    BIT     1,(HL)
    JR      Z,LOC_8E97
    INC     A
LOC_8E97:
    JP      LOC_8F96
LOC_8E9A:
    LD      BC,10H
    ADD     HL,BC
    XOR     A
    BIT     0,(HL)
    JR      Z,LOC_8ECC
    LD      A,D
    AND     A
    JR      NZ,LOC_8EB4
    BIT     1,(HL)
    JR      Z,LOC_8ECC
    DEC     HL
    BIT     1,(HL)
    JR      Z,LOC_8ECC
    LD      A,1
    JR      LOC_8ECC
LOC_8EB4:
    LD      B,0FCH
    BIT     1,(HL)
    JR      Z,LOC_8EC3
    LD      B,4
    DEC     HL
    BIT     1,(HL)
    JR      Z,LOC_8EC3
    LD      B,0
LOC_8EC3:
    LD      A,(IY+2)
    ADD     A,B
    LD      (IY+2),A
    LD      A,2
LOC_8ECC:
    JP      LOC_8F96
LOC_8ECF:
    LD      A,2
    BIT     5,(HL)
    JR      NZ,LOC_8EE3
    LD      BC,10H
    ADD     HL,BC
    XOR     A
    BIT     0,(HL)
    JR      Z,LOC_8EE3
    BIT     1,(HL)
    JR      Z,LOC_8EE3
    INC     A
LOC_8EE3:
    JP      LOC_8F96
LOC_8EE6:
    LD      BC,10H
    ADD     HL,BC
    XOR     A
    BIT     1,(HL)
    JR      Z,LOC_8F18
    LD      A,D
    AND     A
    JR      NZ,LOC_8F00
    BIT     0,(HL)
    JR      Z,LOC_8F18
    INC     HL
    BIT     0,(HL)
    JR      Z,LOC_8F18
    LD      A,1
    JR      LOC_8F18
LOC_8F00:
    LD      B,4
    BIT     0,(HL)
    JR      Z,LOC_8F0F
    LD      B,0FCH
    INC     HL
    BIT     0,(HL)
    JR      Z,LOC_8F0F
    LD      B,0
LOC_8F0F:
    LD      A,(IY+2)
    ADD     A,B
    LD      (IY+2),A
    LD      A,2
LOC_8F18:
    JP      LOC_8F96
LOC_8F1B:
    XOR     A
    BIT     2,(HL)
    JR      Z,LOC_8F27
    DEC     HL
    BIT     3,(HL)
    JR      Z,LOC_8F27
    LD      A,2
LOC_8F27:
    JP      LOC_8F96
LOC_8F2A:
    XOR     A
    BIT     2,(HL)
    JR      Z,LOC_8F57
    LD      A,D
    AND     A
    JR      NZ,LOC_8F40
    BIT     3,(HL)
    JR      Z,LOC_8F57
    DEC     HL
    BIT     3,(HL)
    JR      Z,LOC_8F57
    LD      A,2
    JR      LOC_8F57
LOC_8F40:
    LD      B,0FCH
    BIT     3,(HL)
    JR      Z,LOC_8F4E
    LD      B,4
    BIT     3,(HL)
    JR      Z,LOC_8F4E
    LD      B,0
LOC_8F4E:
    LD      A,(IY+2)
    ADD     A,B
    LD      (IY+2),A
    LD      A,2
LOC_8F57:
    JP      LOC_8F96
LOC_8F5A:
    XOR     A
    BIT     2,(HL)
    JR      Z,LOC_8F65
    BIT     3,(HL)
    JR      Z,LOC_8F65
    LD      A,2
LOC_8F65:
    JP      LOC_8F96
LOC_8F68:
    XOR     A
    BIT     3,(HL)
    JR      Z,LOC_8F96
    LD      A,D
    AND     A
    JR      NZ,LOC_8F7E
    BIT     2,(HL)
    JR      Z,LOC_8F96
    INC     HL
    BIT     2,(HL)
    JR      Z,LOC_8F96
    LD      A,2
    JR      LOC_8F96
LOC_8F7E:
    LD      B,4
    BIT     2,(HL)
    JR      Z,LOC_8F8D
    LD      B,0FCH
    INC     HL
    BIT     2,(HL)
    JR      Z,LOC_8F8D
    LD      B,0
LOC_8F8D:
    LD      A,(IY+2)
    ADD     A,B
    LD      (IY+2),A
    LD      A,2
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
    LD      A,(IY+0)
    INC     A
    LD      (IY+0),A
    AND     3
    CP      3
    JR      NZ,LOC_8FC2
    LD      A,(IY+0)
    AND     0F8H
    RES     6,A
    SET     5,A
    LD      (IY+0),A
    XOR     A
LOC_8FC2:
    AND     A
RET


DEAL_WITH_BALL:
    LD      IY,BALLDATA
    LD      A,(IY+0)
    BIT     7,(IY+0)
    JR      Z,LOC_8FF1
    AND     7FH
    OR      40H
    LD      (IY+0),A

    LD      A,(GAMEFLAGS)
    AND     $80
    JR      Z,.normal_mode

    LD (IY+4),0     ; Fast cooldown in chomper mode

.normal_mode:
    INC     (IY+4)      ; In chomper mode SET to 1 the ball cooldown counter
    PUSH    IY
    CALL    PLAY_BOUNCING_BALL_SOUND
    POP     IY
    JR      LOC_9005
LOC_8FF1:
    AND     78H
    JR      Z,LOC_9071
    LD      A,(IY+3)
    CALL    TEST_SIGNAL
    RET     Z
    LD      A,(IY+0)
    BIT     6,A
    JR      Z,BALL_RETURNS_TO_DO
LOC_9005:
    CALL    SUB_9074
    CALL    SUB_9099
    BIT     2,E
    JR      NZ,BALL_GETS_STUCK
    CALL    SUB_912D
    CALL    SUB_92F2
    CP      2
    RET     Z
    CP      1
    JR      Z,BALL_GETS_STUCK
    CALL    SUB_936F
    CP      2
    JR      NZ,LOC_9028
    LD      A,3
    RET
LOC_9028:
    CP      1
    JR      Z,BALL_GETS_STUCK
    CALL    SUB_9337
    AND     A
    JR      NZ,BALL_GETS_STUCK
    CALL    SUB_9399
    AND     A
    JR      Z,LOC_903E
    RES     6,(IY+0)
    JR      LOC_9071
LOC_903E:
    CALL    SUB_93B6
    JR      LOC_9071
BALL_GETS_STUCK:
    RES     6,(IY+0)
    SET     4,(IY+0)
    LD      (IY+5),0
    PUSH    IY
    CALL    PLAY_BALL_STUCK_SOUND_01
    POP     IY
    JR      LOC_906E
BALL_RETURNS_TO_DO:
    BIT     5,A
    JR      Z,LOC_906E
    RES     5,A
    SET     3,A
    LD      (IY+0),A
    LD      (IY+5),0
    PUSH    IY
    CALL    PLAY_BALL_RETURN_SOUND
    POP     IY
LOC_906E:
    CALL    SUB_93CE
LOC_9071:
    XOR     A
RET

SUB_9074:
    LD      B,(IY+1)
    LD      C,(IY+2)
    BIT     1,(IY+0)
    JR      NZ,LOC_9084
    INC     B
    INC     B
    JR      LOC_9086
LOC_9084:
    DEC     B
    DEC     B
LOC_9086:
    BIT     0,(IY+0)
    JR      NZ,LOC_9090
    INC     C
    INC     C
    JR      LOC_9092
LOC_9090:
    DEC     C
    DEC     C
LOC_9092:
    LD      (IY+1),B
    LD      (IY+2),C
RET

SUB_9099:
    LD      DE,0
    LD      IX,APPLEDATA
    LD      B,5
LOC_90A2:
    BIT     7,(IX+0)
    JR      Z,LOC_911E
    LD      A,(IX+1)
    SUB     9
    CP      (IY+1)
    JR      NC,LOC_911E
    ADD     A,11H
    CP      (IY+1)
    JR      C,LOC_911E
    LD      A,(IX+2)
    SUB     8
    CP      (IY+2)
    JR      Z,LOC_90C5
    JR      NC,LOC_911E
LOC_90C5:
    ADD     A,10H
    JR      C,LOC_90CE
    CP      (IY+2)
    JR      C,LOC_911E
LOC_90CE:
    BIT     5,(IX+0)
    JR      Z,LOC_90DC
    SET     4,(IX+0)
    LD      E,4
    RET
LOC_90DC:
    LD      A,(IY+1)
    CP      (IX+1)
    JR      C,LOC_90F0
    BIT     1,(IY+0)
    JR      Z,LOC_90FC
    RES     1,(IY+0)
    JR      LOC_90FA
LOC_90F0:
    BIT     1,(IY+0)
    JR      NZ,LOC_90FC
    SET     1,(IY+0)
LOC_90FA:
    SET     1,D
LOC_90FC:
    LD      A,(IY+2)
    CP      (IX+2)
    JR      C,LOC_9110
    BIT     0,(IY+0)
    RET     Z
    RES     0,(IY+0)
    JR      LOC_911A
LOC_9110:
    BIT     0,(IY+0)
    JR      NZ,LOC_911E
    SET     0,(IY+0)
LOC_911A:
    SET     0,D
    RET
LOC_911E:
    INC     IX
    INC     IX
    INC     IX
    INC     IX
    INC     IX
    DEC     B
    JP      NZ,LOC_90A2
RET

SUB_912D:
    LD      B,(IY+1)
    LD      C,(IY+2)
    DEC     B
    DEC     C
    BIT     1,(IY+0)
    JR      NZ,LOC_913D
    INC     B
    INC     B
LOC_913D:
    BIT     0,(IY+0)
    JR      NZ,LOC_9145
    INC     C
    INC     C
LOC_9145:
    LD      E,0
    PUSH    DE
    CALL    PEEKMAP
    POP     DE
    LD      A,(IY+1)
    AND     0FH
    BIT     1,(IY+0)
    JR      Z,LOC_918A
    CP      0AH
    JR      NZ,LOC_9167
    SET     7,E
    BIT     4,(IX+0)
    JR      NZ,LOC_91BB
    SET     1,E
    JR      LOC_91BB
LOC_9167:
    CP      2
    JR      NZ,LOC_91BB
    SET     5,E
    LD      A,(IY+2)
    AND     0FH
    CP      8
    JR      NC,LOC_9180
    BIT     0,(IX+0)
    JR      NZ,LOC_91BB
    SET     1,E
    JR      LOC_91BB
LOC_9180:
    BIT     1,(IX+0)
    JR      NZ,LOC_91BB
    SET     1,E
    JR      LOC_91BB
LOC_918A:
    CP      6
    JR      NZ,LOC_919A
    SET     7,E
    BIT     5,(IX+0)
    JR      NZ,LOC_91BB
    SET     1,E
    JR      LOC_91BB
LOC_919A:
    CP      0EH
    JR      NZ,LOC_91BB
    SET     5,E
    LD      A,(IY+2)
    AND     0FH
    CP      8
    JR      NC,LOC_91B3
    BIT     2,(IX+0)
    JR      NZ,LOC_91BB
    SET     1,E
    JR      LOC_91BB
LOC_91B3:
    BIT     3,(IX+0)
    JR      NZ,LOC_91BB
    SET     1,E
LOC_91BB:
    LD      A,(IY+2)
    AND     0FH
    BIT     0,(IY+0)
    JR      Z,LOC_91F9
    CP      2
    JR      NZ,LOC_91D6
    SET     6,E
    BIT     7,(IX+0)
    JR      NZ,LOC_922A
    SET     0,E
    JR      LOC_922A
LOC_91D6:
    CP      0AH
    JR      NZ,LOC_922A
    SET     4,E
    LD      A,(IY+1)
    AND     0FH
    CP      8
    JR      C,LOC_91EF
    BIT     2,(IX+0)
    JR      NZ,LOC_922A
    SET     0,E
    JR      LOC_922A
LOC_91EF:
    BIT     0,(IX+0)
    JR      NZ,LOC_922A
    SET     0,E
    JR      LOC_922A
LOC_91F9:
    CP      0EH
    JR      NZ,LOC_9209
    SET     6,E
    BIT     6,(IX+0)
    JR      NZ,LOC_922A
    SET     0,E
    JR      LOC_922A
LOC_9209:
    CP      6
    JR      NZ,LOC_922A
    SET     4,E
    LD      A,(IY+1)
    AND     0FH
    CP      8
    JR      C,LOC_9222
    BIT     3,(IX+0)
    JR      NZ,LOC_922A
    SET     0,E
    JR      LOC_922A
LOC_9222:
    BIT     1,(IX+0)
    JR      NZ,LOC_922A
    SET     0,E
LOC_922A:
    BIT     7,E
    JR      Z,LOC_92A3
    BIT     6,E
    JR      Z,LOC_92A3
    LD      A,E
    AND     3
    JP      NZ,LOC_92E8
    LD      B,(IY+1)
    LD      C,(IY+2)
    LD      A,B
    BIT     1,(IY+0)
    JR      Z,LOC_9275
    SUB     4
    LD      B,A
    LD      A,C
    BIT     0,(IY+0)
    JR      Z,LOC_9263
    SUB     4
    LD      C,A
    PUSH    DE
    CALL    PEEKMAP
    POP     DE
    BIT     3,(IX+0)
    JP      NZ,LOC_92E8
    LD      E,3
    JP      LOC_92E8
LOC_9263:
    ADD     A,4
    LD      C,A
    PUSH    DE
    CALL    PEEKMAP
    POP     DE
    BIT     2,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
    JR      LOC_92E8
LOC_9275:
    ADD     A,4
    LD      B,A
    LD      A,C
    BIT     0,(IY+0)
    JR      Z,LOC_9291
    SUB     4
    LD      C,A
    PUSH    DE
    CALL    PEEKMAP
    POP     DE
    BIT     1,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
    JR      LOC_92E8
LOC_9291:
    ADD     A,4
    LD      C,A
    PUSH    DE
    CALL    PEEKMAP
    POP     DE
    BIT     0,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
    JR      LOC_92E8
LOC_92A3:
    BIT     5,E
    JR      Z,LOC_92E8
    BIT     4,E
    JR      Z,LOC_92E8
    LD      A,E
    AND     3
    JR      NZ,LOC_92E8
    BIT     1,(IY+0)
    JR      Z,LOC_92D0
    BIT     0,(IY+0)
    JR      Z,LOC_92C6
    BIT     0,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
    JR      LOC_92E8
LOC_92C6:
    BIT     1,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
    JR      LOC_92E8
LOC_92D0:
    BIT     0,(IY+0)
    JR      Z,LOC_92E0
    BIT     2,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
    JR      LOC_92E8
LOC_92E0:
    BIT     3,(IX+0)
    JR      NZ,LOC_92E8
    LD      E,3
LOC_92E8:
    LD      A,E
    AND     3
    XOR     (IY+0)
    LD      (IY+0),A
RET

SUB_92F2:
    LD      IX,ENEMY_DATA_ARRAY
    LD      C,0
LOC_92F8:
    BIT     7,(IX+4)
    JR      Z,LOC_9316
    BIT     6,(IX+4)
    JR      NZ,LOC_9316
    PUSH    BC
    PUSH    IX
    LD      B,(IX+2)
    LD      C,(IX+1)
    CALL    SUB_B5DD            ; Ball collision detection
    POP     IX
    POP     BC
    AND     A
    JR      NZ,LOC_9324
LOC_9316:
    LD      DE,6
    ADD     IX,DE
    INC     C
    LD      A,C
    CP      7
    JR      C,LOC_92F8
    XOR     A
    RET
LOC_9324:
    CALL    SUB_B7C4            ; outupt = ZF
    PUSH    AF
    LD      DE,32H              ; 500 points if bad guy is hit by A ball
    CALL    SUB_B601
    POP     AF
                        ;   AND A           ; already in AF
    LD      A,2
    RET     Z
    LD      A,1
RET

SUB_9337:
    LD      IX,CHOMPDATA
    LD      C,0
LOC_933D:
    BIT     7,(IX+4)
    JR      Z,LOC_9355
    PUSH    BC
    PUSH    IX
    LD      B,(IX+2)
    LD      C,(IX+1)
    CALL    SUB_B5DD            ; Ball collision detection
    POP     IX
    POP     BC
    AND     A
    JR      NZ,LOC_9363
LOC_9355:
    LD      DE,6
    ADD     IX,DE
    INC     C
    LD      A,C
    CP      3
    JR      C,LOC_933D
    XOR     A
    RET
LOC_9363:
    CALL    SUB_B832
    LD      DE,32H              ; 500 points if chomper is hit by A ball
    CALL    SUB_B601
    LD      A,1
RET

SUB_936F:
    LD      A,(LETTERMON_FLAG)
    BIT     6,A
    RET     Z
    LD      A,(LETTERMON_Y)
    LD      B,A
    LD      A,(LETTERMON_X)
    LD      C,A
    CALL    SUB_B5DD            ; Ball collision detection
    AND     A
    RET     Z
    LD      BC,$D908
    LD      D,0
    LD      A,3                 ; remove extra letter
    CALL    PUTSPRITE
    LD      DE,32H              ; 500 points if Letter is hit by A ball
    CALL    SUB_B601
    CALL    SUB_B76D
    INC     A
RET

SUB_9399:
    LD      A,(MRDO_DATA.Y)
    LD      B,A
    LD      A,(MRDO_DATA.X)
    LD      C,A
    CALL    SUB_B5DD
    AND     A
    RET     Z
    LD      HL,MRDO_DATA
    SET     6,(HL)
    PUSH    IY
    CALL    SUB_C98A
    POP     IY
    LD      A,1
RET

SUB_93B6:
    LD      B,(IY+1)
    LD      C,(IY+2)
    LD      D,1
    LD      A,4         ; start ball explosion
    CALL    PUTSPRITE
    LD      HL,1
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A
RET

SUB_93CE:  ; Ball intersecting with sprite
    LD      A,(IY+5)
    ADD     A,2
    LD      B,(IY+1)
    LD      C,(IY+2)
    BIT     3,(IY+0)
    JR      Z,LOC_93ED
    LD      C,A
    LD      A,9
    SUB     C
    LD      IX,MRDO_DATA
    LD      B,(IX+3)
    LD      C,(IX+4)
LOC_93ED:
    LD      D,A
    LD      A,4         ; continue ball explosion
    CALL    PUTSPRITE   ; possible cause of the sprite glitch ???
    INC     (IY+5)
    LD      A,(IY+5)
    CP      6
    JR      Z,LOC_9409
    LD      HL,5
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A
    RET
LOC_9409:
    BIT     4,(IY+0)
    JR      Z,LOC_9444
    RES     4,(IY+0)
    SET     5,(IY+0)
    LD      A,(IY+4)
    DEC     A
    CP      4
    JR      C,LOC_9421
    LD      A,4
LOC_9421:  ; Ball intersects with sprite
    ADD     A,A
    LD      E,A
    LD      D,0
    LD      IX,BYTE_944E
    ADD     IX,DE
    LD      L,(IX+0)
    LD      H,(IX+1)
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A
    LD      BC,$D908
    LD      D,0
    LD      A,4         ; remove ball explosion
    CALL    PUTSPRITE
    RET
LOC_9444:
    RES     3,(IY+0)
    LD      HL,MRDO_DATA
    SET     6,(HL)
RET

; timer for ball

BYTE_944E:
    DW 60,120,240,360,480
    db 0


FREESIGNTIMER:
    LD      A,(SIGNPOSITION)
    AND     A
    RET     Z
    LD      A,(SIGNTIMER)
    CALL    FREE_SIGNAL
    XOR     A           ; any value>0 will tell to the MrDo code to test the SIGN timers
    LD      (SIGNPOSITION),A
    RET

LEADS_TO_CHERRY_STUFF:
    LD      A,(GAMECONTROL)
    BIT     6,A
    JR      Z,LOC_9463
    XOR     A
    RET
LOC_9463:

; test is the 500 sign is on the screen

    LD      A,(SIGNPOSITION)
    AND     A
    JR      Z,no_sign_on_the_screen         ; skip if no sign is on the screen

TEST2:

; test the 500 sign timer

    LD      A,(SIGNTIMER)
    CALL    TEST_SIGNAL     ; A = 1 if timer expired, else 0, Z-flag = set according to A
    JR      Z,timer_still_running

TEST3:

; timer is expired, free it
    LD      A,(SIGNTIMER)
    CALL    FREE_SIGNAL

; plot A block of 2x2 leftover patterns
    LD       A, (SIGNPOSITION)
    CALL    PLOTLEFTOVERS
    LD       A, (SIGNPOSITION)
    LD      BC,SAT_BUFFER
    CALL    PRINT_2X2_PATTERN

    XOR     A
    LD      (SIGNPOSITION),A    ; no sign on the screen
    JR    no_sign_on_the_screen

timer_still_running:

    LD      A, (SIGNPOSITION)
    LD      BC,TestSign
    CALL    PRINT_2X2_PATTERN


no_sign_on_the_screen:

    LD      IY,MRDO_DATA  ; IY points to Mr. Do's data
    LD      A,(IY+2)
    CALL    TEST_SIGNAL
    JR      Z,LOC_949A
    CALL    SUB_94A9
    AND     A
    JR      NZ,LOC_947A
    LD      A,1
    JR      LOC_9489
LOC_947A:
    CP      5
    JR      NZ,LOC_9483
    CALL    SUB_9577
    XOR     A
    JR      LOC_9491
LOC_9483:
    LD      (IY+1),A
    CALL    SUB_95A1     ; Mr. Do sprite intersection logic
LOC_9489:
    PUSH    AF
    CALL    DEAL_WITH_CHERRIES
    CALL    SUB_96E4
    POP     AF
LOC_9491:
    CALL    SUB_9732    ; MrDo movements
    CALL    CHECK_DIAMOND_COLLECTION        ; Diamond collection check A=0 if no diamond,A=$82 if diamond
    AND     A
    RET     NZ
LOC_949A:
    LD      HL,ENEMYINTERACT
    LD      B,20
    XOR     A
LOC_94A0:
    CP      (HL)
    RET     NZ
    INC     HL
    DJNZ    LOC_94A0
    LD      A,2
RET

SUB_94A9:
    LD      IX,$7088
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,LOC_94B8
    LD      IX,$708D
LOC_94B8:
    BIT     6,(IX+0)
    JR      NZ,LOC_94C4
    BIT     6,(IX+3)
    JR      Z,LOC_9538
LOC_94C4:
    LD      A,(MRDO_DATA)
    BIT     6,A
    JR      Z,LOC_9538
    LD      B,(IY+3)
    LD      C,(IY+4)
    LD      A,(IY+1)
    CP      3
    JR      NC,LOC_94FD
    CP      1
    LD      A,C
    JR      NZ,LOC_94ED
    ADD     A,6
    LD      (BALLDATA+2),A
    ADD     A,3
    JR      C,LOC_9538
    LD      C,A
    LD      A,B
    LD      (BALLDATA+1),A
    JR      LOC_9524
LOC_94ED:
    SUB     6
    LD      (BALLDATA+2),A
    SUB     3
    JR      C,LOC_9538
    LD      C,A
    LD      A,B
    LD      (BALLDATA+1),A
    JR      LOC_9524
LOC_94FD:
;   CP      3       ; redundant
    LD      A,B
    JR      NZ,LOC_9514
    SUB     6
    LD      (BALLDATA+1),A
    SUB     3
    CP      1CH
    JR      C,LOC_9538
    LD      B,A
    LD      A,C
    LD      (BALLDATA+2),A
    JR      LOC_9524
LOC_9514:
    ADD     A,6
    LD      (BALLDATA+1),A
    ADD     A,3
    CP      0B5H
    JR      NC,LOC_9538
    LD      B,A
    LD      A,C
    LD      (BALLDATA+2),A
LOC_9524:
    PUSH    IX
    CALL    PEEKMAP
    LD      A,(IX+0)
    POP     IX
    AND     0FH
    CP      0FH
    JR      NZ,LOC_9538
    LD      A,5
    RET
LOC_9538:
    LD      A,1
    BIT     1,(IX+1)
    JR      NZ,LOC_9558
    INC     A
    BIT     3,(IX+1)
    JR      NZ,LOC_9558
    INC     A
    BIT     0,(IX+1)
    JR      NZ,LOC_9558
    INC     A
    BIT     2,(IX+1)
    JR      NZ,LOC_9558
    XOR     A
    RET
LOC_9566:
    LD      A,(IY+4)
    AND     0FH
    CP      8
    JR      Z,LOC_9575
LOC_956F:
    POP     AF
    LD      A,(IY+1)
    RET
LOC_9558:
    PUSH    AF
    CP      3
    JR      NC,LOC_9566
    LD      A,(IY+3)
    AND     0FH
    JR      NZ,LOC_956F
LOC_9575:
    POP     AF
RET

SUB_9577:
    LD      IX,BALLDATA
    LD      A,(IY+1)
    DEC     A
    LD      B,A
    CP      2
    JR      C,LOC_9593
    LD      B,3
    CP      2
    JR      Z,LOC_958C
    LD      B,1
LOC_958C:
    BIT     7,(IY+4)
    JR      Z,LOC_9593
    DEC     B
LOC_9593:
    SET     7,B
    LD      (IX+0),B
    SET     3,(IY+0)
    RES     6,(IY+0)
RET

SUB_95A1:  ; Mr. Do Sprite intersection logic
    CALL    SUB_961F  ; Mr. Do's sprite collision logic with the screen bounds
    AND     A
    JP      NZ,LOC_961C
    PUSH    BC
    RES     5,(IY+0)
    LD      B,(IY+3)
    LD      C,(IY+4)
    LD      A,(IY+1)
    CP      3
    JP      NC,LOC_95CE
    LD      D,A
    LD      A,1
    CALL    SUB_AEE1 ; Mr do is pushing an apple
    BIT     0,A
    JR      Z,LOC_95C8
    SET     5,(IY+0)
LOC_95C8:
    CP      2
    JR      NC,LOC_9617
LOC_95D5:
    POP     BC
    LD      (IY+3),B
    LD      (IY+4),C
    LD      A,(IY+1)
    LD      D,A
    CP      1
    JR      NZ,LOC_95E9
    CALL    SUB_B2FA
    JR      LOC_95FE
LOC_95E9:
    CP      2
    JR      NZ,LOC_95F2
    CALL    SUB_B39D
    JR      LOC_95FE
LOC_95F2:
    CP      3
    JR      NZ,LOC_95FB
    CALL    SUB_B43F
    JR      LOC_95FE
LOC_95FB:
    CALL    SUB_B4E9
LOC_95FE:
    BIT     0,E
    JR      Z,LOC_9606
    SET     4,(IY+0)
LOC_9606:
    LD      B,(IY+3)
    LD      C,(IY+4)
    PUSH    DE
    CALL    PEEKMAP

    LD      B,A     ;***
    LD      A,(BADGUY_BHVR_CNT_RAM)
    DEC     A
    JP      P,LOC_AEC1
    LD      A,4FH
LOC_AEC1:
    LD      L,A
    LD      H,0
    LD      DE,BADGUY_BEHAVIOR_RAM
    ADD     HL,DE
    LD      A,(HL)
    CP      B
    JR      Z,SKIP
    LD      A,(BADGUY_BHVR_CNT_RAM)
    LD      L,A
    LD      H,0
;   LD      DE,BADGUY_BEHAVIOR_RAM      ; already in DE
    ADD     HL,DE
    LD      (HL),B
    INC     A
    CP      50H
    JR      C,LOC_AEDD
    XOR     A
LOC_AEDD:
    LD      (BADGUY_BHVR_CNT_RAM),A
SKIP:

    POP     DE
    XOR     A
    RET

LOC_9617:
    SET     5,(IY+0)
    POP     BC
LOC_961C:
    LD      A,1
    RET
LOC_95CE: ; Mr. Do intersects with an apple while facing up or down
    LD      D,A
    SCF                 ; CF==1 Mr. Do collision offset to fix stuck in apple bug
    CALL    SUB_B12D    ; Returns A=0 if no collision,A=1 if collision
    AND     A
    JR      Z,LOC_95D5
    POP     BC          ; here A==1
RET                 ; Treat as A "wall" collision

SUB_961F:  ; Mr. Do's sprite collision logic with the screen bounds
    LD      (IY+1),A
    LD      B,(IY+3)
    LD      C,(IY+4)
    CP      3       ; Check if Mr. Do is facing up or down
    JR      NC,LOC_964B  ; If facing up or down,jump to LOC_964B
    LD      A,B
    AND     0FH
    JR      NZ,LOC_966D
    LD      A,C
    ADD     A,4
    LD      C,A
    LD      A,(IY+1)
    CP      1
    JR      Z,LOC_9640
    LD      A,C
    SUB     8
    LD      C,A
LOC_9640:
    LD      A,C
    CP      18H
    JR      C,LOC_966D
    CP      0E9H
    JR      NC,LOC_966D
    JR      LOC_966A
LOC_964B:
    LD      A,C
    AND     0FH
    CP      8
    JR      NZ,LOC_966D
    LD      A,B
    ADD     A,4
    LD      B,A
    LD      A,(IY+1)
    CP      4
    JR      Z,LOC_9661
    LD      A,B
    SUB     8
    LD      B,A
LOC_9661:
    LD      A,B
    CP      20H
    JR      C,LOC_966D
    CP      0B1H
    JR      NC,LOC_966D
LOC_966A:
    XOR     A
    RET
LOC_966D: ; Mr. Do has collided with the bounds of the screen
    LD      A,1
RET

DEAL_WITH_CHERRIES:
    CALL    SUB_B173
    JR      C,GRAB_SOME_CHERRIES
    BIT     1,(IY+0)
    RET     Z
    LD      A,(IY+8)
    CALL    TEST_SIGNAL
    RET     Z
    LD      (IY+7),0
    RES     1,(IY+0)
    PUSH    IY
    CALL    SUB_C97F
    POP     IY
    RET
GRAB_SOME_CHERRIES:
    LD      DE,5
    CALL    SUB_B601
    BIT     1,(IY+0)
    JP      Z,LOC_96CA
    LD      A,(IY+8)
    CALL    TEST_SIGNAL
    JP      NZ,LOC_96CA
    LD      A,(IY+8)
    CALL    FREE_SIGNAL
    INC     (IY+7)
    LD      A,(IY+7)
    CP      8
    JP      C,LOC_96D5
    LD      (IY+7),0
    LD      DE,2DH          ; final cherry scores 500 not 550
    CALL    SUB_B601        ; activate here the 500 sign (**), IY aims to MRDO_DATA (IY+3)=Y, (IY+4)=X
    RES     1,(IY+0)

; NB: this safety test avoids signs not being removed  when A second one is placed
    LD      A,(SIGNPOSITION)
    AND     A
    RET     NZ          ; don't allocate A 500 sign if another 500 sign is already on the screen

    PUSH    IY

; allocate  500 sign timer  here
    XOR     A           ; A = 0 if one-shot, else free-running
    LD      HL,2*60     ; time length   (2 secs)
    CALL    REQUEST_SIGNAL
    LD      (SIGNTIMER),A   ; ID of the allocated timer in the current

  ; Get map position for cleanup tracking
    LD      A,(MRDO_DATA.Y)
    LD      B,A
    LD      A,(MRDO_DATA.X)
    LD      C,A
    CALL    PEEKMAP

  ; Store position for cleanup (A-1 as noted in comments)

    DEC     A
    LD      (SIGNPOSITION),A
    LD      BC,TestSign
    CALL    PRINT_2X2_PATTERN
    POP  IY
    RET


; Input:
;   A = Position value (X in lower nibble, Y in upper nibble)
;   BC = Pattern source address (SAT_BUFFER/TestSign etc.)
PRINT_2X2_PATTERN:
    PUSH    AF
    AND     $F0
    LD      L,A
    LD      H,0
    ADD     HL,HL       ; y * 2 * 16
    ADD     HL,HL       ; y * 2 * 32
    LD      DE,3*32
    ADD     HL,DE       ; count the scorebar
    POP     AF
    AND     $0F
    ADD     A,A         ; x * 2
    ADD     A,L         ; carry not possible here
    LD      L,A         ; HL = x*2 + y*2 *32 + 3*32

    EX      DE,HL       ; VRAM position in DE

    LD  L,C             ; ROM position in HL
    LD  H,B
    LD      IY,2
    LD      A,2
    PUSH    HL
    PUSH    DE
    CALL    MyNMI_off         ; Disable VDP ISR
    CALL    PUT_VRAM
    CALL    MyNMI_on
    POP     DE
    LD      HL,32
    ADD     HL,DE
    EX      DE,HL
    POP     HL
    INC     HL
    INC     HL
    LD      A,2
    LD      IY,2
    CALL    MyNMI_off         ; Disable VDP ISR
    CALL    PUT_VRAM
    CALL    MyNMI_on
    RET




LOC_96CA:
    LD      (IY+7),1
    PUSH    IY
    CALL    PLAY_GRAB_CHERRIES_SOUND
    POP     IY
LOC_96D5:
    XOR     A
    LD      HL,1EH
    CALL    REQUEST_SIGNAL
    LD      (IY+8),A
    SET     1,(IY+0)
RET



TestSign:   DB 120,121,122,123


PLOTLEFTOVERS:
    LD      B,0
    LD      C,A
    LD      HL,LEVELMAP
    ADD     HL,BC

; we read the  leftover pattern in LEVELMAP

    LD      A,(HL)
    RRCA
    RRCA
    RRCA
    RRCA
    AND     15      ; divide by 16
                    ; range 1-14
    ADD     A,A     ; x2 to accedd the table
    LD      E,A
    LD      D,0
    LD      HL,LfovrConf-2
    ADD     HL,DE
    LD      DE,SAT_BUFFER+2
    CALL    EXPAND
    INC     HL
    LD      DE,SAT_BUFFER+0
;   CALL    EXPAND
;   RET
EXPAND:
    XOR     A
    RLD             ; upper nibble
    CALL    .0
    INC     DE
    XOR     A
    RRD             ; lower nibble
;   CALL    .0
;   RET
.0: CP      $F
    JR      Z,.1
    ADD     A,88
.1: LD      (DE),A
    RET


LfovrConf:
    DW  $0167   ;1F
    DW  $4501   ;2F
    DW  $0101   ;3F
    DW  $4263   ;4F
    DW  $0F63   ;5F
    DW  $420F   ;6F
    DW  $0F0F   ;7F
    DW  $F1F1   ;8F
    DW  $F137   ;9F
    DW  $25F1   ;AF
    DW  $F1F1   ;BF
    DW  $2233   ;CF
    DW  $FF33   ;DF
    DW  $22FF   ;EF


SUB_96E4:
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     7,A
    RET     Z
    LD      A,(IY+3)
    CP      60H
    RET     NZ
    LD      A,(IY+4)
    CP      78H
    RET     NZ
    LD      HL,GAMEFLAGSBONUSITEM
    RES     7,(HL)
    LD      A,(HL)
    OR      32H
    LD      (HL),A
    LD      A,0AH
    LD      (CURRBADGUY),A

    LD      A,(GAMECONTROL)
    LD      C,A
    LD      A,(CURRENT_LEVEL_P1)
    BIT     1,C
    JR      Z,LOC_971B
    LD      A,(CURRENT_LEVEL_P2)
LOC_971B:
    LD      HL,0
    LD      DE,32H              ; score for bonus item! ADD 500 points per each level
LOC_9721:
    ADD     HL,DE
    DEC     A
    JP      P,LOC_9721
    EX      DE,HL
    CALL    SUB_B601
RET

SUB_9732:
    AND     A                   ; if MrDo is halted reset animation
    JR      NZ,LOC_973D
    LD      A,(IY+6)
    INC     A
    CP      4                   ; Number of steps in the animation
    JR      C,LOC_973E
LOC_973D:
    XOR     A
LOC_973E:
    LD      (IY+6),A
    LD      C,1
    ADD     A,C
    BIT     5,(IY+0)
    JR      Z,LOC_974C
    ADD     A,4             ; PUSH/WALK offset <-> ADD 4 if PUSHING
LOC_974C:
    LD      C,A
    LD      A,(IY+1)            ; MrDo Direction
    CP      2
    JR      NZ,LOC_975A
    LD      A,C
    ADD     A,8             ; walk left offset
    LD      C,A
    JR      LOC_9786
LOC_975A:
    CP      3
    JR      NZ,LOC_9771
    LD      A,(IY+4)
    AND     A
    JP      P,LOC_976B
    LD      A,C
    ADD     A,16    ;0EH        ; walk up offset
    LD      C,A
    JR      LOC_9786
LOC_976B:
    LD      A,C
    ADD     A,32    ;1CH        ; walk up-mirror offset
    LD      C,A
    JR      LOC_9786
LOC_9771:
    CP      4
    JR      NZ,LOC_9786
    LD      A,(IY+4)
    AND     A
    JP      P,LOC_9782
    LD      A,C
    ADD     A,24    ;15H        ; walk down offset
    LD      C,A
    JR      LOC_9786
LOC_9782:
    LD      A,C
    ADD     A,40 ;23H           ; walk down-mirror offset
    LD      C,A
LOC_9786:
    LD      (IY+5),C            ;  MrDO STEPS
    BIT     6,(IY+0)
    JR      Z,LOC_97C8
    LD      A,(IY+1)
    CP      3
    JR      C,LOC_97A1
    LD      E,A
    LD      A,(IY+4)
    AND     A
    LD      A,E
    JP      M,LOC_97A1
    ADD     A,2
LOC_97A1:
    BIT     5,(IY+0)
    JR      Z,LOC_97A9
    ADD     A,6
LOC_97A9:
    DEC     A
    ADD     A,A
    LD      E,A
    LD      D,0
    LD      HL,BYTE_97EF
    ADD     HL,DE
    LD      A,(IY+4)
    ADD     A,8
    SUB     (HL)
    LD      C,A
    INC     HL
    LD      A,(IY+3)
    ADD     A,8
    SUB     (HL)
    LD      B,A
    LD      D,1
    LD      A,4     ; ball explosion
    CALL    PUTSPRITE
LOC_97C8:
    LD      HL,1EH
    BIT     3,(IY+0)
    JR      NZ,LOC_97DD
    LD      HL,0FH
    BIT     5,(IY+0)
    JR      NZ,LOC_97DD
    LD      HL,7
LOC_97DD:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+2),A
    LD      A,(IY+0)
    AND     0E7H
    OR      80H
    LD      (IY+0),A
RET

BYTE_97EF:
    DB 002,006,014,006,006,014,006,002,010,014,010,002,012,008,004,008,008,004,008,012,008,004,008,012

CHECK_DIAMOND_COLLECTION: ; Check if Mr. Do has collected A diamond
    LD      A,(DIAMOND_RAM)  ; Load diamond status
    BIT     7,A              ; Check if bit 7 is set (diamond active?)
    JR      Z,LOC_983F       ; If not set,return 0 (no diamond)

    ; Check X distance between Mr. Do and diamond
    LD      IX,APPLEDATA     ; Diamond position stored in apple data

    LD      A,(IY+3)         ; Get Mr. Do's X position
    SUB     (IX+1)             ; Calculate DX by diamond X
    JR      NC,LOC_9820      ; If positive,skip next line
    NEG                      ; If negative,make positive by two's complement
LOC_9820:
    CP      6                 ; Is X distance >= 6?
    JR      NC,LOC_983F      ; If yes,too far,return 0

    ; Check Y distance between Mr. Do and diamond
    LD      A,(IY+4)         ; Get Mr. Do's Y position
    SUB     (IX+2)           ; Calculate DY distance by diamon Y
    JR      NC,LOC_982C      ; If positive,skip next line
    NEG                      ; If negative,make positive by two's complement
LOC_982C:
    CP      6                 ; Is Y distance >= 6?
    JR      NC,LOC_983F      ; If yes,too far,return 0

    ; Diamond collected! Award points
    LD      DE,320H          ; Load 800 (320 hex) for 8,000 points (previously was 10,000)
    CALL    SUB_B601          ; ADD points to score
    LD      HL,DIAMOND_RAM
    RES     7,(HL)           ; Clear bit 7 (deactivate diamond)
    LD      A,$82              ; Return $82 (diamond collected)
    RET
LOC_983F:                     ; No diamond collection
    XOR     A                 ; Return 0
RET

SUB_9842:                       ; TEST MRDO COLLISION AGAINST ENEMIES
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     4,A
    JR      Z,LOC_98A2
    LD      A,(GAMEFLAGS)
    BIT     7,A             ; test chomper mode
    JR      NZ,LOC_986C
    LD      A,(BADGUYTIMER)
    CALL    TEST_SIGNAL
    JR      Z,LOC_986C
    LD      HL,1EH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (BADGUYTIMER),A
    LD      A,(CURRBADGUY)
    DEC     A
    LD      (CURRBADGUY),A
    JR      Z,LOC_9892
LOC_986C:
    LD      IY,ENEMY_DATA_ARRAY
    LD      B,7
LOC_9872:
    BIT     7,(IY+4)
    JR      Z,LOC_9887
    BIT     6,(IY+4)
    JR      NZ,LOC_9887
    PUSH    BC
    CALL    SUB_9FC8
    LD      L,1
    POP     BC
    JR      NZ,LOC_98CB
LOC_9887:
    LD      DE,6
    ADD     IY,DE
    DJNZ    LOC_9872
    LD      L,0
    JR      LOC_98CB
LOC_9892:
    LD      A,(GAMEFLAGSBONUSITEM)
    RES     4,A
    LD      (GAMEFLAGSBONUSITEM),A
    LD      A,(BADGUYFLAGS)
    SET     4,A
    LD      (BADGUYFLAGS),A
LOC_98A2:

    LD      A,(DIAMOND_RAM)
    BIT     7,A
    JP      Z,LOC_D3F9
    LD      A,(SOUND_BANK_09_RAM)
;   AND     0FFH
    CP      0FFH
    JP      NZ,LOC_D405
    CALL    PLAY_DIAMOND_SOUND

    CALL    SUB_999F

LOC_98A5:
    CALL    SUB_98CE
    LD      A,(CURRBADGUY)
    LD      C,A
    LD      B,0
    LD      HL,BYTE_9A24
    ADD     HL,BC
    LD      C,(HL)
    LD      IY,ENEMY_DATA_ARRAY
    ADD     IY,BC
    LD      L,0
    LD      A,(IY+4)
    BIT     7,A
    JR      Z,LOC_98C2
    BIT     6,A
    JR      NZ,LOC_98C2
    BIT     7,(IY+0)
    JR      NZ,LOC_98C2
    CALL    SUB_9A2C
    LD      L,A
LOC_98C2:
    LD      A,(CURRBADGUY)
    INC     A
    AND     7
    LD      (CURRBADGUY),A
LOC_98CB:
    LD      A,L
    AND     A               ; return L=A=1 if collison
RET


LOC_D3F9:
    LD      A,(SOUND_BANK_01_RAM)
    AND     0FH
    CP      2
    JR      Z,LOC_D405
    CALL    RESTORE_PLAYFIELD_COLORS
    CALL    PLAY_BACKGROUND_TUNE
LOC_D405:
    CALL    SUB_999F
    JP      LOC_98A5

BYTE_9A24:
    DB 000,006,012,018,024,030,036,042

SUB_98CE:
    PUSH    IX
    LD      A,(BADGUYFLAGS)
    BIT     3,A
    JR      NZ,LOC_9928
    LD      IX,ENEMY_DATA_ARRAY+6*6 ; last enemy
    LD      A,(IX+3)
    CALL    TEST_SIGNAL
    JR      Z,LOC_9928
    CALL    SUB_9980
    JR      Z,LOC_991E
;   LD      BC,6078H    ; unused
    CALL    SUB_992B
    JR      Z,LOC_98F6
    LD      HL,1
    JR      LOC_9915
LOC_98F6:
    LD      (IY+0),28H
    LD      (IY+4),81H
    XOR     A
    LD      HL,6
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A
    LD      BC,6078H
    LD      (IY+2),B
    LD      (IY+1),C
    LD      (IY+5),5
    CALL    SUB_9980
    JR      Z,LOC_991E
    LD      HL,0D2H
    LD      A,(BADGUYFLAGS)
    BIT     2,A
    JR      NZ,LOC_9910
    LD      HL,1EH
LOC_9910:
    XOR     4
    LD      (BADGUYFLAGS),A
LOC_9915:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IX+3),A
    JR      LOC_9928
LOC_991E:
    LD      A,(GAMEFLAGSBONUSITEM)
    SET     0,A
    SET     7,A
    LD      (GAMEFLAGSBONUSITEM),A
LOC_9928:
    POP     IX
RET

SUB_992B:
    PUSH    IY
    LD      IY,ENEMY_DATA_ARRAY     ; enemy data starts here = 6*7 bytes
    LD      BC,700H     ; B = enemy number
LOC_9934:
    LD      A,(IY+4)
    BIT     7,A
    JR      Z,LOC_994D
    BIT     6,A
    JR      NZ,LOC_994D
    LD      A,(IY+2)
    SUB     60H
    JR      NC,LOC_9948
    NEG
LOC_9948:
    CP      0DH
    JR      NC,LOC_994D
    INC     C
LOC_994D:
    LD      DE,6
    ADD     IY,DE           ; next enemy
    DJNZ    LOC_9934
    LD      A,C
    CP      2
    JR      NC,LOC_995C
    XOR     A
    JR      LOC_995E
LOC_995C:
    LD      A,1
LOC_995E:
    POP     IY
    AND     A
RET

SUB_9980:
    LD      IY,ENEMY_DATA_ARRAY
    LD      L,7
    LD      DE,6
LOC_9989:
    BIT     7,(IY+4)
    JR      Z,LOC_999C
    ADD     IY,DE
    DEC     L
    JR      NZ,LOC_9989
    LD      A,(BADGUYFLAGS)
    SET     3,A
    LD      (BADGUYFLAGS),A
LOC_999C:
    LD      A,L
    AND     A
RET

SUB_999F:
    LD      A,(BADGUYFLAGS)
    BIT     5,A
    JR      NZ,LOC_99BB
    SET     5,A
    LD      (BADGUYFLAGS),A
    LD      HL,3CH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      IX,ENEMY_DATA_ARRAY+6*6 ; last enemy
    LD      (IX+3),A
    JR      LOC_9A07
LOC_99BB:
    LD      A,(BADGUYTIMER)
    CALL    TEST_SIGNAL
    RET     Z
    LD      A,(BADGUYCOUNTER)
    LD      D,A
    LD      A,(BADGUYFLAGS)
    SET     6,A
    BIT     7,A
    JR      Z,LOC_99E4
    RES     7,A
    LD      (BADGUYFLAGS),A
    INC     D
    JR      NZ,LOC_99DB
    LD      D,0FFH
LOC_99DB:
    LD      A,D
    LD      (BADGUYCOUNTER),A
    LD      A,(BADGUYFLAGS)
    JR      LOC_99E9
LOC_99E4:
    SET     7,A
    LD      (BADGUYFLAGS),A
LOC_99E9:
    LD      E,7
    LD      BC,6
    LD      IY,ENEMY_DATA_ARRAY
LOC_99F2:
    LD      H,(IY+4)
    SET     5,H
    SET     4,H
    BIT     7,A
    JR      Z,LOC_99FF
    RES     4,H
LOC_99FF:
    LD      (IY+4),H
    ADD     IY,BC
    DEC     E
    JR      NZ,LOC_99F2
LOC_9A07:
    LD      HL,1EH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (BADGUYTIMER),A
RET


SUB_9A2C:                   ; Bad guy logic
    LD      A,(IY+3)
    CALL    TEST_SIGNAL     ; IX unchanged
    RET     Z
    PUSH    IX
    LD      A,(IY+0)
    BIT     5,A
    JR      Z,LOC_9A50      ; B5==0,Digger
    BIT     3,A
    JR      Z,LOC_9A49
    CALL    SUB_9B91        ; IX unchanged
    JR      NZ,LOC_9A5E
    JR      LOC_9A75
LOC_9A49:
    CALL    SUB_9BBD        ; IX unchanged
    JR      NZ,LOC_9A59
    JR      LOC_9A75
LOC_9A50:
    BIT     4,A
    JR      Z,LOC_9A5E
    CALL    SUB_9C76        ; IX unchanged
    JR      NZ,LOC_9A75
LOC_9A59:
    CALL    SUB_A460        ; digger interact with apples, IX changes
    JR      LOC_9AA0
LOC_9A5E:
    CALL    SUB_A1DF
    JR      NZ,LOC_9A75
    CALL    SUB_9CAB
    JR      NZ,LOC_9A6D
    CALL    SUB_9E7C
    JR      LOC_9A75
LOC_9A6D:
    CALL    SUB_9FF4
    JR      Z,LOC_9AA0
    CALL    SUB_9E3F
LOC_9A75:
    LD      A,(IY+4)
    AND     7
    CALL    SUB_9D2F
    JR      Z,LOC_9AA0
    LD      A,(IY+4)
    AND     7
    DEC     A
    LD      C,A
    LD      B,0
    LD      HL,BYTE_9AB5
    ADD     HL,BC
    LD      B,(HL)
    PUSH    BC
    CALL    SUB_9F29
    POP     BC
    AND     B
    JR      Z,LOC_9AA0
    CALL    SUB_9E7A
    LD      A,(IY+4)
    AND     7
    CALL    SUB_9D2F
LOC_9AA0:
    CALL    SUB_9AB9
    CALL    SUB_9AE2        ; plot bad guy/transformer/digger
    LD      A,(IY+4)
    AND     0C7H
    LD      (IY+4),A
    CALL    SUB_9FC8
    POP     IX
    AND     A
RET


BYTE_9AB5:
    DB 176,112,224,208

SUB_9AB9:
    PUSH    DE
    PUSH    HL
    LD      E,(IY+0)
    LD      HL,6
    BIT     5,E
    JR      NZ,LOC_9AD8
    BIT     4,E
    JR      Z,LOC_9ACE
    CALL    SUB_9BE2
    JR      LOC_9AD8
LOC_9ACE:
    CALL    SUB_9BDA
    BIT     3,(IY+4)
    JR      Z,LOC_9AD8
    ADD     HL,HL
LOC_9AD8:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A
    POP     HL
    POP     DE
RET


SUB_9AE2:
    PUSH    IX
    PUSH    IY

    BIT     6,(IY+0)        ; B6==0,Transform
    JR      NZ,.LOC_BADGUY      ; Manage Bad guy

    LD      D,13            ; Bad guys Transforming (right)
    BIT     5,(IY+0)
    JR      NZ,.WALK
                            ; B5==0,Digger
    CALL    SUB_9B4F
    LD      B,(IY+2)
    LD      C,(IY+1)
    CALL    PEEKMAP
;   LD      D,A         ; done by PEEKMAP
    CALL    SUB_B173

    LD      D,25            ; Digger (right)
.WALK:
    LD      A,(IY+4)        ; direction
    AND     7
    DEC     A               ; 1 == rigth    D+=0
    JR      Z,.BADGUYANIM
    INC     D
    INC     D
    DEC     A               ; 2 == left     D+=2
    JR      Z,.BADGUYANIM

    INC     D               ; 3/4 = down/up      FootLeft
    INC     D
    BIT     7,(IY+1)        ; test if x<128
    JR      NZ,.FootRight
    INC     D
    INC     D
    INC     D
    INC     D
.FootRight:
    DEC     A
    JR      Z,.BADGUYANIM       ; 3 == down     L=4 or 8

    INC     D                   ; 4 == up       L=6 or 10
    INC     D

.BADGUYANIM:
    LD      A,(IY+5)
    XOR     $80
    JR      Z,.odd
    INC     D
.odd:
    LD      (IY+5),A

    LD      A,(CURRBADGUY)
    ADD     A,5
    LD      B,(IY+2)        ; B=Y, C=X, A=Object, D=Frame
    LD      C,(IY+1)
    CALL    PUTSPRITE       ; show bad guy
    POP     IY
    POP     IX
RET

.LOC_BADGUY:
    CALL    PUSHTEST
    JP      Z,.BADGUYANIM       ; pushing
    LD      D,1             ; normal walk
    JP      .WALK       ; walking

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; test if the current bad guy pointed by IY is next to an active apple
; return Z is pushing NZ is waking and in D the animation frame

PUSHTEST:
    LD      IX,APPLEDATA
    LD      B,5
.loop:
    BIT     7,(IX+0)
    JR      Z,.next
    LD      A,(IX+1)        ;Y apple
    CP      (IY+2)      ;Y bad buy
    JR      NZ,.next        ;on the same line
.sameline:
    LD      A,(IX+2)        ;X apple
    SUB     (IY+1)      ;X bad guy (WTF !! THEY ARE INVERTED!!!)
    JR      NC,.pos
    NEG
.pos:
    CP      17
    JP      NC,.next
    LD      A,(IY+4)        ; direction
    AND     7
    LD      D,38            ; pushing apple 38 39 right, A==1
    DEC     A
    RET     Z
    LD      D,40
    DEC     A               ; pushing apple 40 41 left, A==2
    RET                     ; Z if A==2, NZ otherwise
.next:
    LD      DE,5
    ADD     IX,DE
    DJNZ    .loop
    OR      E               ; NZ
RET


SUB_9B4F:
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A,(IY+0)
    BIT     0,A
    JR      NZ,LOC_9B83
    BIT     5,A             ; digger
    JR      NZ,LOC_9B83
    LD      A,(IY+4)        ; direction
    AND     7
    DEC     A               ; 0 - 3 valid directions
    CP      4
    JR      NC,LOC_9B83     ; skip if invalid direction
    LD      HL,OFF_9B89
    ADD     A,A
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    PUSH    DE
    POP     IX
    LD      B,(IY+2)
    LD      C,(IY+1)
    LD      DE,LOC_9B83
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
    LD      B,0
    JR      NZ,LOC_9BA5
    LD      A,(IY+0)
    RES     5,A
    SET     6,A
    AND     0F8H
    LD      (IY+0),A
    INC     B
LOC_9BA5:
    LD      A,B
    AND     A
RET

SUB_9BA8:
    LD      A,(IY+5)
    DEC     A
    LD      (IY+5),A
    AND     3FH
RET

SUB_9BB2:
    LD      C,A
    LD      A,(IY+5)
    AND     0C0H
    OR      C
    LD      (IY+5),A
RET

SUB_9BBD:
    LD      B,0
    CALL    SUB_9BA8
    JR      NZ,LOC_9BD7
    LD      A,(IY+0)
    AND     0F8H
    RES     5,A
    SET     4,A
    LD      (IY+0),A
    CALL    SUB_9BE2
    CALL    SUB_9BB2
    INC     B
LOC_9BD7:
    LD      A,B
    OR      A
RET

SUB_9BDA:
    XOR     A
    JR      LOC_9BE8

SUB_9BE2:               ; ENTRY POINT FOR CHOMPERS
    LD  A,1

LOC_9BE8:   
    PUSH    BC
    PUSH    DE

    LD      D,A

    LD      A,(SKILLLEVEL)
    DEC     A
    LD      C,A
    LD      B,0
    LD      HL,BYTE_9D1A
    ADD     HL,BC
    LD      C,(HL)
    LD      HL,CURRENT_LEVEL_P1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_9C05
    INC     HL
LOC_9C05:
    LD      A,(HL)
    DEC     A
    ADD     A,C
    LD      C,A
    LD      A,(BADGUYFLAGS)
    BIT     4,A
    JR      Z,LOC_9C12
    INC     C
    INC     C
LOC_9C12:
    LD      A,C
    CP      0FH
    JR      C,LOC_9C19
    LD      A,0FH
LOC_9C19:
    ADD     A,A
    LD      C,A
    DEC     D
    LD      HL,BYTE_9C56
    JR      NZ,LOC_9C27
    LD      HL,BYTE_9C36
LOC_9C27:
    ADD     HL,BC

    LD      E,(HL)
    INC     HL
    LD      A,(HL)
    LD      H,0
    LD      L,E

    POP     DE
    POP     BC
RET

BYTE_9C36:
    DB 013,009,013,009,013,009,010,012,010,012,010,012,008,015,008,015,006,020,006,020,005,024,005,024,005,024,004,030,004,030,004,030
BYTE_9C56:
    DB 008,001,008,001,008,001,006,001,006,001,006,001,005,001,005,001,005,001,005,001,004,001,004,001,004,001,004,001,004,001,004,001

SUB_9C76:
    LD      B,0
    LD      A,(IY+5)
    AND     3FH
    JR      Z,LOC_9C84
    CALL    SUB_9BA8
    JR      NZ,LOC_9CA8
LOC_9C84:
    LD      A,(IY+2)
    AND     0FH
    JR      NZ,LOC_9CA8
    LD      A,(IY+1)
    AND     0FH
    CP      8
    JR      NZ,LOC_9CA8
    LD      A,(IY+0)
    AND     0F8H
    RES     4,A
    SET     5,A
    SET     3,A
    LD      (IY+0),A
    LD      A,0AH
    CALL    SUB_9BB2
    INC     B
LOC_9CA8:
    LD      A,B
    AND     A
RET

SUB_9CAB:
    LD      B,(IY+0)
    BIT     5,(IY+4)
    JR      NZ,LOC_9CBA
    BIT     2,B
    JR      NZ,LOC_9CD4
    JR      LOC_9CDA
LOC_9CBA:
    CALL    SUB_9CE0
    LD      E,A
    LD      A,(BADGUYCOUNTER)
    RRA
    RRA
    RRA
    RRA
    RRA
    AND     7
    ADD     A,E
    LD      E,A
    CALL    RAND_GEN
    AND     0FH
    RES     2,B
    CP      E
    JR      NC,LOC_9CDA
LOC_9CD4:
    SET     2,B
    RES     0,B
    RES     1,B
LOC_9CDA:
    LD      (IY+0),B
    BIT     2,B
RET

SUB_9CE0:
    PUSH    DE
    PUSH    HL
    LD      A,(SKILLLEVEL)
    DEC     A
    LD      E,A
    LD      D,0
    LD      HL,BYTE_9D1A
    ADD     HL,DE
    LD      E,(HL)
    LD      HL,CURRENT_LEVEL_P1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_9CFB
    INC     HL
LOC_9CFB:
    LD      A,(HL)
    DEC     A
    ADD     A,E
    LD      E,A
    LD      A,(BADGUYFLAGS)
    BIT     4,A
    JR      Z,LOC_9D08
    INC     E
    INC     E
LOC_9D08:
    LD      A,E
    CP      0FH
    JR      C,LOC_9D0F
    LD      A,0FH
LOC_9D0F:
    LD      E,A
    LD      D,0
    LD      HL,BYTE_9D1E
    ADD     HL,DE
    LD      A,(HL)
    POP     HL
    POP     DE
RET

BYTE_9D1A:
    DB 000,003,005,007
BYTE_9D1E:
    DB 008,008,009,009,010,010,011,011,012,012,013,013,014,014,014,014,014

SUB_9D2F:
    LD      C,A
    XOR     A
    LD      H,(IY+0)
    BIT     0,H
    RET     NZ
    BIT     5,H
    RET     NZ
    PUSH    BC
    LD      B,(IY+2)
    LD      C,(IY+1)
    CALL    SUB_9E07
    POP     BC
    RET     NZ
    DEC     C
    LD      A,C
    CP      4
    LD      A,0
    RET     NC
    LD      A,C
    RLCA
    LD      C,A
    LD      B,0
    LD      HL,OFF_9D9F
    ADD     HL,BC
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    EX      DE,HL
    LD      B,(IY+2)
    LD      C,(IY+1)
    LD      E,4
    JP      (HL)
LOC_9D67:
    LD      A,C
    ADD     A,E
    LD      C,A
    JR      LOC_9D79
LOC_9D6C:
    LD      A,C
    SUB     E
    LD      C,A
    JR      LOC_9D79
LOC_9D71:
    LD      A,B
    SUB     E
    LD      B,A
    JR      LOC_9D79
LOC_9D76:
    LD      A,B
    ADD     A,E
    LD      B,A
LOC_9D79:
    PUSH    HL
    PUSH    BC
    PUSH    IY
    POP     HL
    LD      BC,LETTERMON_DATA_P1
    AND     A
    SBC     HL,BC
    POP     BC
    POP     HL
    JR      NC,LOC_9D92
    LD      A,(IY+4)
    AND     7
    CALL    SUB_9DA7
    RET     NZ
LOC_9D92:
    CALL    SUB_9E07
    RET     NZ
    LD      (IY+2),B
    LD      (IY+1),C
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
    JR      C,LOC_9E01
    LD      C,A
    LD      IX,ENEMY_DATA_ARRAY
    LD      HL,7
LOC_9DB6:
    BIT     7,(IX+4)
    JR      Z,LOC_9DF0
    BIT     6,(IX+4)
    JR      NZ,LOC_9DF0
    LD      A,(IX+2)
    BIT     2,C
    JR      NZ,LOC_9DD5
    CP      B
    JR      Z,LOC_9DCE
    JR      NC,LOC_9DF0
LOC_9DCE:
    ADD     A,0CH
    CP      B
    JR      C,LOC_9DF0
    JR      LOC_9DDD
LOC_9DD5:
    CP      B
    JR      C,LOC_9DF0
    SUB     0DH
    CP      B
    JR      NC,LOC_9DF0
LOC_9DDD:
    INC     H
    LD      A,H
    CP      1
    JR      NZ,LOC_9DF0
    PUSH    HL
    PUSH    IY
    POP     DE
    PUSH    IX
    POP     HL
    AND     A
    SBC     HL,DE
    POP     HL
    JR      NC,LOC_9E01
LOC_9DF0:
    LD      DE,6
    ADD     IX,DE
    DEC     L
    JR      NZ,LOC_9DB6
    LD      A,H
    CP      2
    JR      C,LOC_9E01
    LD      A,0FFH
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
    LD      A,(IY+4)
    AND     7
    LD      D,A
    LD      A,3
    BIT     4,(IY+0)
    JR      Z,LOC_9E17
    DEC     A
LOC_9E17:
    LD      E,A
    LD      A,D
    CP      3
    LD      A,E
    JR      NC,LOC_9E31
    CALL    SUB_AEE1
    CP      2
    JR      NC,LOC_9E39
    LD      L,0
    CP      1
    JR      NZ,LOC_9E3B
    SET     3,(IY+4)
    JR      LOC_9E3B
LOC_9E31:
    AND     A           ; CF==0 Monster collision offset
    CALL    SUB_B12D    ; Returns A=1 if vertical apple collision
    LD      L,0
    AND     A
    JR      Z,LOC_9E3B
LOC_9E39:
    LD      L,1
LOC_9E3B:
    POP     BC
    LD      A,L
    AND     A
RET

SUB_9E3F:
    SET     0,(IY+0)
    BIT     4,(IY+4)
    JR      Z,LOC_9E75
    CALL    SUB_A527
    JR      Z,LOC_9E54
    BIT     3,(IY+4)
    JR      Z,LOC_9E75
LOC_9E54:
    CALL    SUB_9CE0
    AND     0FH
    LD      B,A
    CALL    RAND_GEN
    AND     0FH
    CP      B
    JR      NC,LOC_9E75
    LD      A,(IY+0)
    AND     0F8H
    RES     6,A
    SET     5,A
    RES     3,A
    LD      (IY+0),A
    LD      A,0AH
    CALL    SUB_9BB2
LOC_9E75:
    RES     3,(IY+4)
RET


SUB_9E7C:
    BIT     4,(IY+4)
    JR      NZ,LOC_9EAA
    BIT     0,(IY+0)
    JP      NZ,LOC_9F10
    LD      A,(IY+4)
    AND     7
    DEC     A
    CP      4
    JR      NC,LOC_9EAA
    LD      HL,BYTE_9F25
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      B,(HL)
    PUSH    BC
    CALL    SUB_9F29
    POP     BC
    AND     A
    JR      Z,LOC_9EAA
    LD      C,A
    AND     B
    JR      NZ,LOC_9F10
    LD      A,C
    JR      LOC_9EBD
LOC_9EAA:
    SET     0,(IY+0)
    CALL    RAND_GEN
    AND     0FH
    CP      8
    JR      C,LOC_9F10
    CALL    SUB_9F29
    AND     A
    JR      Z,LOC_9F10

SUB_9E7A:
LOC_9EBD:
    LD      IX,BYTE_9F15
    LD      C,4
LOC_9EC3:
    LD      E,(IX+1)
    CP      (IX+0)
    JR      Z,LOC_9F03
    INC     IX
    INC     IX
    DEC     C
    JR      NZ,LOC_9EC3
    LD      B,A
LOC_9ED3:
    CALL    RAND_GEN
    AND     3
    RLCA
    LD      HL,OFF_9F1D
    LD      E,A
    LD      D,0
    ADD     HL,DE
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    EX      DE,HL
    JP      (HL)
LOC_9EE5:
    LD      E,3
    BIT     4,B
    JR      NZ,LOC_9F03
    JR      LOC_9ED3
LOC_9EED:
    LD      E,4
    BIT     5,B
    JR      NZ,LOC_9F03
    JR      LOC_9ED3
LOC_9EF5:
    LD      E,1
    BIT     6,B
    JR      NZ,LOC_9F03
    JR      LOC_9ED3
LOC_9EFD:
    LD      E,2
    BIT     7,B
    JR      Z,LOC_9ED3
LOC_9F03:
    RES     0,(IY+0)
    LD      A,(IY+4)
    AND     0F8H
    OR      E
    LD      (IY+4),A
LOC_9F10:
    BIT     0,(IY+0)
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
    LD      B,(IY+2)
    LD      C,(IY+1)
    CALL    PEEKMAP
    LD      C,A         ;***
    LD      HL,UNK_9FB3
    LD      A,(IY+1)
    RLCA
    RLCA
    RLCA
    RLCA
    AND     0F0H
    LD      B,A
    LD      A,(IY+2)
    AND     0FH
    OR      B
    LD      E,7
LOC_9F4A:
    CP      (HL)
    JR      Z,LOC_9F55
    INC     HL
    INC     HL
    INC     HL
    DEC     E
    JR      NZ,LOC_9F4A
    JR      LOC_9FA0
LOC_9F55:
    XOR     A
    INC     HL
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    PUSH    IX
    PUSH    DE
    POP     IX
    POP     HL
    JP      (IX)
    
LOC_9F62:
    BIT     1,(HL)
    JR      Z,LOC_9F6C
    BIT     3,(HL)
    JR      Z,LOC_9F6C
    SET     6,A
LOC_9F6C:
    DEC     HL
    BIT     0,(HL)
    JR      Z,LOC_9FAF
    BIT     2,(HL)
    JR      Z,LOC_9FAF
    SET     7,A
    JR      LOC_9FAF
    
LOC_9F79:
    LD      A,(HL)
    AND     0F0H
    JR      LOC_9FAF
    
LOC_9F7E:
    LD      A,0C0H
    JR      LOC_9FAF
    
LOC_9F82:
    BIT     2,(HL)
    JR      Z,LOC_9F8C
    BIT     3,(HL)
    JR      Z,LOC_9F8C
    SET     5,A
LOC_9F8C:
    LD      BC,-16
    ADD     HL,BC
    BIT     0,(HL)
    JR      Z,LOC_9FAF
    BIT     1,(HL)
    JR      Z,LOC_9FAF
    SET     4,A
    JR      LOC_9FAF
    
LOC_9F9C:
    LD      A,30H
    JR      LOC_9FAF
LOC_9FA0:
    LD      A,(HL)
    AND     0F0H
    PUSH    AF
    LD      A,C
    CALL    SUB_ABB7
    LD      (IY+2),B
    LD      (IY+1),C
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

SUB_9FC8:                           ; Test collision MrDo vs Enemy in IY
  ; INVINCIBILITY HACK FOR DEBUG (PRESERVE)
    ; XOR       A    ; (Uncomment for invincibility)
    ; RET        ; (Uncomment for invincibility)
    LD      A,(MRDO_DATA.Y)
    SUB     (IY+2)
    JR      NC,.ypos
    NEG
.ypos:
    LD      L,0
    CP      5
    JR      NC,LOC_9FEF
    LD      A,(MRDO_DATA.X)
    SUB     (IY+1)
    JR      NC,.xpos
    NEG
.xpos:
    CP      5
    JR      NC,LOC_9FEF
    PUSH    IY
    CALL    PLAY_LOSE_LIFE_SOUND        ; XXX DEATH SEQUENCE HERE
    POP     IY
    LD      L,1
LOC_9FEF:
    LD      A,L
    AND     A
RET

SUB_9FF4:
    PUSH    IX
    CALL    SUB_9F29
    PUSH    AF
    LD      B,(IY+2)
    LD      C,(IY+1)
    CALL    PEEKMAP
    POP     BC
    CALL    SUB_A028
    JR      NZ,LOC_A00C
    CALL    SUB_A1AC
LOC_A00C:
    CP      2
    JR      Z,LOC_A01E
    LD      A,(IY+4)
    AND     7
    CALL    SUB_9D2F
    JR      Z,LOC_A024
    CP      0FFH
    JR      Z,LOC_A022
LOC_A01E:
    SET     3,(IY+4)
LOC_A022:
    LD      A,1
LOC_A024:
    AND     A
    POP     IX
RET

SUB_A028:
    PUSH    BC
    PUSH    IX
    PUSH    AF
    LD      A,(IY+2)
    AND     0FH
    LD      C,A
    LD      A,(IY+1)
    RLCA
    RLCA
    RLCA
    RLCA
    AND     0F0H
    OR      C
    LD      C,7
    LD      HL,UNK_A12A
LOC_A041:
    CP      (HL)
    JR      Z,LOC_A04D
    INC     HL
    INC     HL
    INC     HL
    DEC     C
    JR      NZ,LOC_A041
    DEC     HL
    DEC     HL
    DEC     HL
LOC_A04D:
    INC     HL
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    PUSH    DE
    POP     IX
    POP     HL
    LD      A,H
    LD      L,0FFH
    CALL    SUB_A13F
    JR      Z,LOC_A05E
    LD      L,A
LOC_A05E:
    JP      (IX)

LOC_A060:
    LD      C,41H
    LD      A,H
    DEC     A
    CALL    SUB_A13F
    JR      Z,LOC_A06F
    CP      L
    JR      NC,LOC_A06F
    LD      C,82H
    LD      L,A
LOC_A06F:
    JP      LOC_A102
LOC_A072:
    LD      C,82H
    LD      A,H
    INC     A
    CALL    SUB_A13F
    JR      Z,LOC_A081
    CP      L
    JR      NC,LOC_A081
    LD      L,A
    LD      C,41H
LOC_A081:
    JP      LOC_A102
LOC_A084:
    LD      C,13H
    LD      A,H
    ADD     A,10H
    CALL    SUB_A13F
    JR      Z,LOC_A094
    CP      L
    JR      NC,LOC_A094
    LD      L,A
    LD      C,24H
LOC_A094:
    JP      LOC_A102
LOC_A097:
    LD      C,24H
    LD      A,H
    SUB     10H
    CALL    SUB_A13F
    JR      Z,LOC_A0A7
    CP      L
    JR      NC,LOC_A0A7
    LD      L,A
    LD      C,13H
LOC_A0A7:
    JP      LOC_A102
LOC_A0AA:
    LD      L,0FFH
    LD      A,H
    AND     0FH
    JR      Z,LOC_A0BF
    BIT     6,B
    JR      Z,LOC_A0BF
    LD      A,H
    INC     A
    CALL    SUB_A13F
    JR      Z,LOC_A0BF
    LD      L,A
    LD      C,41H
LOC_A0BF:
    LD      A,H
    DEC     A
    AND     0FH
    JR      Z,LOC_A0D6
    BIT     7,B
    JR      Z,LOC_A0D6
    LD      A,H
    DEC     A
    CALL    SUB_A13F
    JR      Z,LOC_A0D6
    CP      L
    JR      NC,LOC_A0D6
    LD      L,A
    LD      C,82H
LOC_A0D6:
    LD      A,H
    CP      11H
    JR      C,LOC_A0EC
    BIT     4,B
    JR      Z,LOC_A0EC
    SUB     10H
    CALL    SUB_A13F
    JR      Z,LOC_A0EC
    CP      L
    JR      NC,LOC_A0EC
    LD      L,A
    LD      C,13H
LOC_A0EC:
    LD      A,H
    CP      91H
    JR      NC,LOC_A102
    BIT     5,B
    JR      Z,LOC_A102
    ADD     A,10H
    CALL    SUB_A13F
    JR      Z,LOC_A102
    CP      L
    JR      NC,LOC_A102
    LD      L,A
    LD      C,24H
LOC_A102:
    LD      D,0
    LD      A,L
    CP      0FFH
    JR      Z,LOC_A124
    LD      A,C
    AND     7
    LD      L,A
    LD      A,(IY+4)
    AND     0F8H
    OR      L
    LD      (IY+4),A
    LD      D,1
    LD      A,C
    AND     0F0H
    AND     B
    JR      NZ,LOC_A124
    SET     0,(IY+0)
    LD      D,2
LOC_A124:
    POP     IX
    POP     BC
    LD      A,D
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
    LD      D,A
    LD      A,(BADGUY_BHVR_CNT_RAM)
    AND     A
    JR      Z,LOC_A159
    LD      C,A
    LD      B,0
    DEC     BC
    LD      HL,BADGUY_BEHAVIOR_RAM
    ADD     HL,BC
    INC     BC
    LD      A,D
    CPDR
    JR      Z,LOC_A182
LOC_A159:
    LD      HL,BADGUY_BEHAVIOR_RAM
    LD      BC,4FH
    ADD     HL,BC
    PUSH    HL
    POP     IX
    LD      HL,BADGUY_BEHAVIOR_RAM
    LD      A,(BADGUY_BHVR_CNT_RAM)
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      B,H
    LD      C,L
    PUSH    IX
    POP     HL
    XOR     A
    SBC     HL,BC
    JR      Z,LOC_A1A4
    INC     HL
    LD      B,H
    LD      C,L
    PUSH    IX
    POP     HL
    LD      A,D
    CPDR
    JR      NZ,LOC_A1A4
LOC_A182:
    INC     HL
    PUSH    HL
    LD      HL,BADGUY_BEHAVIOR_RAM
    LD      A,(BADGUY_BHVR_CNT_RAM)
    LD      C,A
    LD      B,0
    AND     A
    JR      NZ,LOC_A193
    LD      BC,50H
LOC_A193:
    DEC     BC
    ADD     HL,BC
    POP     BC
    XOR     A
    SBC     HL,BC
    JR      NC,LOC_A1A0
    LD      BC,50H
    ADD     HL,BC
LOC_A1A0:
    INC     L
    LD      A,L
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
    LD      L,0
    LD      H,(IY+1)
    LD      A,(MRDO_DATA.X)
    CP      H
    JR      Z,LOC_A1BF
    JR      C,LOC_A1BD
    SET     6,L
    JR      LOC_A1BF
LOC_A1BD:
    SET     7,L
LOC_A1BF:
    LD      H,(IY+2)
    LD      A,(MRDO_DATA.Y)
    CP      H
    JR      Z,LOC_A1D0
    JR      C,LOC_A1CE
    SET     5,L
    JR      LOC_A1D0
LOC_A1CE:
    SET     4,L
LOC_A1D0:
    LD      A,L
    AND     B
    JR      NZ,LOC_A1D8
    LD      A,2
    AND             A
    RET     ;JR     LOC_A1DD
LOC_A1D8:
    CALL    SUB_9E7A
    LD      A,1
;LOC_A1DD:
;   AND     A   ; unused
RET

SUB_A1DF:
    PUSH    IX
    LD      B,0
    BIT     5,(IY+4)
    JR      NZ,LOC_A20E
    BIT     1,(IY+0)
    JR      Z,LOC_A254
    LD      A,(IY+4)
    AND     7
    DEC     A
    CP      4
    JR      NC,LOC_A254
    LD      HL,BYTE_9F25
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      C,(HL)
    PUSH    BC
    CALL    SUB_9F29
    POP     BC
    AND     A
    JR      Z,LOC_A254
    AND     C
    JR      NZ,LOC_A252
    JR      LOC_A21E
LOC_A20E:
    RES     1,(IY+0)
    CALL    SUB_9CE0
    LD      C,A
    CALL    RAND_GEN
    AND     0FH
    CP      C
    JR      NC,LOC_A254
LOC_A21E:
    LD      A,(IY+0)
    AND     0F8H
    LD      (IY+0),A
    LD      B,(IY+2)
    LD      C,(IY+1)
    CALL    PEEKMAP
    LD      E,A
    CALL    SUB_A259
    JR      NZ,LOC_A241
    CALL    SUB_A382
    JR      Z,LOC_A241
    CALL    SUB_A402
    LD      B,0
    JR      NZ,LOC_A254
LOC_A241:
    PUSH    HL
    CALL    SUB_9F29
    POP     HL
    LD      B,0
    AND     L
    JR      Z,LOC_A254
    CALL    SUB_9E7A
    SET     1,(IY+0)
LOC_A252:
    LD      B,1
LOC_A254:
    LD      A,B
    POP     IX
    AND     A
RET

SUB_A259:
    PUSH    IX
    PUSH    DE
    PUSH    BC
    LD      A,(BALLDATA)
    LD      B,A
    XOR     A
    BIT     6,B
    JR      Z,LOC_A2B9
    PUSH    DE
    LD      A,E
    CALL    SUB_ABB7
    PUSH    BC
    LD      A,(BALLDATA+1)
    LD      B,A
    LD      A,(BALLDATA+2)
    LD      C,A
    CALL    PEEKMAP
    PUSH    AF
    PUSH    IX
    CALL    SUB_ABB7
    POP     IX
    POP     AF
    POP     HL
    POP     DE
    LD      D,A
    SUB     E
    JR      Z,LOC_A2B9
    LD      A,(BALLDATA)
    AND     3
    JR      NZ,LOC_A297
    CALL    SUB_A2C0
    JR      NZ,LOC_A2B9
    CALL    SUB_A34C
    JR      LOC_A2B9
LOC_A297:
    DEC     A
    JR      NZ,LOC_A2A4
    CALL    SUB_A2E8
    JR      NZ,LOC_A2B9
    CALL    SUB_A34C
    JR      LOC_A2B9
LOC_A2A4:
    DEC     A
    JR      NZ,LOC_A2B1
    CALL    SUB_A2C0
    JR      NZ,LOC_A2B9
    CALL    SUB_A316
    JR      LOC_A2B9
LOC_A2B1:
    CALL    SUB_A2E8
    JR      NZ,LOC_A2B9
    CALL    SUB_A316
LOC_A2B9:
    LD      L,A
    POP     BC
    POP     DE
    POP     IX
    AND     A
RET

SUB_A2C0:
    PUSH    DE
    PUSH    HL
    LD      A,B
    CP      H
    JR      NZ,LOC_A2E3
    LD      A,L
    SUB     C
    JR      C,LOC_A2E3
    CP      21H
    JR      NC,LOC_A2E3
    INC     D
    BIT     6,(IX+0)
    JR      Z,LOC_A2E3
    LD      A,E
    CP      D
    JR      Z,LOC_A2DF
    BIT     6,(IX+1)
    JR      Z,LOC_A2E3
LOC_A2DF:
    LD      A,70H
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
    LD      A,B
    CP      H
    JR      NZ,LOC_A30F
    LD      A,C
    SUB     L
    JR      C,LOC_A30F
    CP      21H
    JR      NC,LOC_A30F
    DEC     D
    BIT     7,(IX+0)
    JR      Z,LOC_A30F
    LD      A,E
    CP      D
    JR      Z,LOC_A30B
    DEC     IX
    BIT     7,(IX+0)
    JR      Z,LOC_A30F
LOC_A30B:
    LD      A,0B0H
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
    LD      A,C
    CP      L
    JR      NZ,LOC_A345
    LD      A,B
    SUB     H
    JR      C,LOC_A345
    CP      21H
    JR      NC,LOC_A345
    LD      A,D
    SUB     10H
    LD      D,A
    BIT     4,(IX+0)
    JR      Z,LOC_A345
    LD      A,E
    CP      D
    JR      Z,LOC_A341
    PUSH    BC
    LD      BC,-16
    ADD     IX,BC
    POP     BC
    BIT     4,(IX+0)
    JR      Z,LOC_A345
LOC_A341:
    LD      A,0D0H
    JR      LOC_A346
LOC_A345:
    XOR     A
LOC_A346:
    POP     IX
    POP     HL
    POP     DE
;   AND     A       ; unused
RET

SUB_A34C:
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A,C
    CP      L
    JR      NZ,LOC_A37B
    LD      A,H
    SUB     B
    JR      C,LOC_A37B
    CP      21H
    JR      NC,LOC_A37B
    LD      A,D
    ADD     A,10H
    LD      D,A
    BIT     5,(IX+0)
    JR      Z,LOC_A37B
    LD      A,E
    CP      D
    JR      Z,LOC_A377
    PUSH    BC
    LD      BC,10H
    ADD     IX,BC
    POP     BC
    BIT     5,(IX+0)
    JR      Z,LOC_A37B
LOC_A377:
    LD      A,0E0H
    JR      LOC_A37C
LOC_A37B:
    XOR     A
LOC_A37C:
    POP     IX
    POP     HL
    POP     DE
;   AND     A   ; unused
RET

SUB_A382:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    PUSH    IY
    LD      A,E
    PUSH    DE
    CALL    SUB_ABB7
    POP     DE
    LD      L,5
    LD      IY,APPLEDATA
LOC_A394:
    BIT     7,(IY+0)
    JR      Z,LOC_A3EE
    BIT     5,(IY+0)
    JR      Z,LOC_A3EE
    LD      A,C
    CP      (IY+2)
    JR      NZ,LOC_A3EE
    LD      A,B
    CP      (IY+1)
    JR      C,LOC_A3EE
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      B,(IY+1)
    LD      C,(IY+2)
    CALL    PEEKMAP
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    LD      H,A
    LD      D,E
LOC_A3C1:
    PUSH    BC
    LD      BC,-16
    ADD     IX,BC
    POP     BC
    LD      A,D
    SUB     10H
    LD      D,A
    LD      A,(IX+0)
    AND     0FH
    CP      0FH
    JR      NZ,LOC_A3EE
    LD      A,H
    CP      D
    JR      C,LOC_A3C1
    LD      L,0E0H
    POP     IY
    LD      A,(IY+1)
    CP      C
    JR      Z,LOC_A3EB
    RES     7,L
    JR      NC,LOC_A3EB
    SET     7,L
    RES     6,L
LOC_A3EB:
    XOR     A
    JR      LOC_A3FC
LOC_A3EE:
    PUSH    BC
    LD      BC,5
    ADD     IY,BC
    POP     BC
    DEC     L
    JR      NZ,LOC_A394
    LD      A,1
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
    LD      B,(IY+2)
    LD      C,(IY+1)
    LD      L,5
    LD      IX,APPLEDATA
LOC_A412:
    BIT     7,(IX+0)
    JR      Z,LOC_A44D
    BIT     6,(IX+0)
    JR      Z,LOC_A44D
    LD      D,(IX+1)
    LD      E,(IX+2)
    LD      A,B
    CP      D
    JR      C,LOC_A44D
    SUB     D
    CP      21H
    JR      NC,LOC_A44D
    LD      A,C
    SUB     E
    JR      NC,LOC_A433
    NEG
LOC_A433:
    CP      11H
    JR      NC,LOC_A44D
    LD      A,(IY+1)
    LD      HL,00E0H
    CP      (IX+2)
    JR      Z,LOC_A459
    RES     7,L
    JR      NC,LOC_A459
    SET     7,L
    RES     6,L
    JR      LOC_A459
LOC_A44D:
    PUSH    BC
    LD      BC,5
    ADD     IX,BC
    POP     BC
    DEC     L
    JR      NZ,LOC_A412
    LD      H,1
LOC_A459:
    POP     IX
    POP     DE
    POP     BC
    LD      A,H
    AND     A
RET

SUB_A460:
    CALL    SUB_A497
    RET     Z
LOC_A465:
    LD      L,A
    PUSH    HL
    CALL    SUB_9E7A
    LD      A,(IY+4)
    AND     7
    CALL    SUB_9D2F
    POP     HL
    RET     Z
    LD      A,(IY+4)
    AND     7
    LD      C,0C0H
    CP      3
    JR      NC,LOC_A482
    LD      C,30H
LOC_A482:
    LD      A,L
    AND     C
    JR      NZ,LOC_A465
    LD      A,(IY+4)
    BIT     0,A
    JR      Z,LOC_A490
    INC     A
    JR      LOC_A491
LOC_A490:
    DEC     A
LOC_A491:
    LD      (IY+4),A
RET

SUB_A497:
    LD      A,(IY+2)
    LD      B,A
    AND     0FH
    JR      NZ,LOC_A512
    LD      A,(IY+1)
    LD      C,A
    AND     0FH
    CP      8
    JR      NZ,LOC_A512
    LD      H,0
    LD      A,(MRDO_DATA.Y)
    CP      B
    JR      Z,LOC_A4B9
    JR      NC,LOC_A4B7
    SET     4,H
    JR      LOC_A4B9
LOC_A4B7:
    SET     5,H
LOC_A4B9:
    LD      A,(MRDO_DATA.X)
    CP      C
    JR      Z,LOC_A520
    LD      A,C
    JR      C,LOC_A4C8
    SET     6,H
    ADD     A,10H
    JR      LOC_A4CC
LOC_A4C8:
    SET     7,H
    SUB     10H
LOC_A4CC:
    LD      C,A
    LD      IX,APPLEDATA
    LD      L,5
LOC_A4D3:
    BIT     7,(IX+0)
    JR      Z,LOC_A4F3
    LD      A,(IX+1)
    SUB     9
    CP      B
    JR      NC,LOC_A4F3
    ADD     A,12H
    CP      B
    JR      C,LOC_A4F3
    LD      A,(IX+2)
    SUB     0FH
    CP      C
    JR      NC,LOC_A4F3
    ADD     A,1FH
    CP      C
    JR      NC,LOC_A4FD
LOC_A4F3:
    LD      DE,5
    ADD     IX,DE
    DEC     L
    JR      NZ,LOC_A4D3
    JR      LOC_A520
LOC_A4FD:
    LD      A,H
    AND     30H
    LD      H,A
    JR      NZ,LOC_A520
    SET     4,H
    LD      A,(IY+2)
    CP      30H
    JR      NC,LOC_A520
    RES     4,H
    SET     5,H
    JR      LOC_A520
LOC_A512:
    LD      A,(IY+4)
    AND     7
    DEC     A
    LD      E,A
    LD      D,0
    LD      HL,BYTE_A523
    ADD     HL,DE
    LD      H,(HL)
LOC_A520:
    LD      A,H
    AND     A
RET

BYTE_A523:
    DB 064,128,016,032

SUB_A527:
    PUSH    BC
    LD      A,(GAMECONTROL)
    LD      B,A
    LD      A,(ENEMY_NUM_P1)
    BIT     0,B
    JR      Z,LOC_A53A
    BIT     1,B
    JR      Z,LOC_A53A
    LD      A,(ENEMY_NUM_P2)
LOC_A53A:
    CP      1
    POP     BC
RET

SUB_A53E:
    LD      A,(LETTERMON_COUNTER)
    BIT     7,A
    JR      NZ,LOC_A551
    SET     7,A
    LD      (LETTERMON_COUNTER),A
    LD      A,40H
    LD      (LETTERMON_FLAG),A
    JR      LOC_A5A6
LOC_A551:
    LD      A,(LETTERMON_FLAG)
    BIT     7,A
    LD      A,0
    JR      NZ,LOC_A5BB
    LD      A,($72C0)
    CALL    TEST_SIGNAL
    JR      Z,LOC_A5BB
    LD      A,(LETTERMON_COUNTER)
    BIT     6,A
    JR      Z,LOC_A56F
    CALL    SUB_A6BB
    JR      LOC_A5AA
LOC_A56F:
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     5,A
    JR      NZ,LOC_A57B
    CALL    SUB_A61F
    JR      Z,LOC_A591
LOC_A57B:
    CALL    SUB_A5F9
    JR      NZ,LOC_A591
    CALL    SUB_A662
    LD      HL,GAMEFLAGSBONUSITEM
    BIT     5,(HL)
    JR      Z,LOC_A5A9
    RES     5,(HL)
    CALL    SUB_B8A3
    JR      LOC_A5A9
LOC_A591:
;   JP      LOC_D309
;LOC_D309:
    LD      HL,GAMEFLAGSBONUSITEM
    BIT     5,(HL)
    JR      Z,LOC_D319
    RES     5,(HL)
    PUSH    IY
    CALL    PLAY_NO_EXTRA_NO_CHOMPERS
    POP     IY
LOC_D319:
;   JP      LOC_A596
;LOC_A596:
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     4,A
    JR      NZ,LOC_A5A9
    LD      A,($72C2)
    DEC     A
    LD      ($72C2),A
    JR      NZ,LOC_A5A9
LOC_A5A6:
    CALL    SUB_A5BD
LOC_A5A9:
    XOR     A
LOC_A5AA:
    PUSH    AF
    LD      HL,0AH
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (LETTERMON_TIMER),A
    POP     AF
    PUSH    AF
    CALL    SUB_A788
    POP     AF
LOC_A5BB:
    AND     A
RET

SUB_A5BD:
    LD      A,(LETTERMON_COUNTER)
    INC     A
    AND     0F7H
    LD      (LETTERMON_COUNTER),A
    LD      HL,BYTE_A5F1
;   LD      A,(LETTERMON_COUNTER)   ; already in A
    AND     7
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      A,(HL)
    LD      (LETTERMON_X),A
    LD      A,0CH
    LD      (LETTERMON_Y),A
    LD      HL,BYTE_A616
    ADD     HL,BC
    LD      A,(HL)
    LD      (LETTERMON_EXTRAFLAGP2),A
    LD      HL,BYTE_A616+1
    ADD     HL,BC
    LD      A,(HL)
    LD      (LETTERMON_EXTRAFLAGP1),A
    LD      A,18H
    LD      ($72C2),A
RET

; X Coords for Letter Monster in the scorebar
BYTE_A5F1:
    DB 091,107,123,139,155,139,123,107

SUB_A5F9:
    LD      A,(LETTERMON_COUNTER)
    AND     7
    LD      C,A
    LD      B,0
    LD      HL,BYTE_A616+1
    ADD     HL,BC
    LD      B,(HL)
    LD      HL,LETTERMON_DATA_P1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_A613
    INC     HL
LOC_A613:
    LD      A,(HL)
    AND     B
RET

BYTE_A616:
    DB 002,001,002,004,008,016,008,004,002

SUB_A61F:
    LD      BC,(SCORE_P1_RAM)
    LD      HL,LETTERMON_SPAWNP1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_A637
    LD      BC,(SCORE_P2_RAM)
    LD      HL,LETTERMON_SPAWNP2
LOC_A637:
    LD      D,(HL)
    LD      E,0
LOC_A63A:
    LD      A,C                     ; spawn letter monser each 10.000 points
    SUB     0F4H
    LD      C,A
    LD      A,B
    SBC     A,1
    LD      B,A
    JR      C,LOC_A647
    INC     E
    JR      LOC_A63A
LOC_A647:
    LD      A,E
    LD      E,0
    CP      D
    JR      Z,LOC_A65F
    LD      (HL),A
    LD      A,(LETTERMON_COUNTER)
    LD      B,A
    BIT     6,A
    JR      NZ,LOC_A65F
    LD      A,(LETTERMON_COUNTER)
    SET     5,A
    LD      (LETTERMON_COUNTER),A
    INC     E
LOC_A65F:
    LD      A,E
    AND     A
RET

SUB_A662:
    CALL    GET_LEVEL

    CP      4
    JR      NZ,LOC_A67F
    LD      A,98H
    JR      LOC_A681
LOC_A67F:
    LD      A,78H
LOC_A681:
    LD      (LETTERMON_X),A
    LD      A,20H
    LD      (LETTERMON_Y),A
    LD      A,0CH
    LD      ($72C2),A
    LD      A,(LETTERMON_COUNTER)
    SET     6,A
    LD      (LETTERMON_COUNTER),A
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     5,A
    JR      NZ,LOC_A6AB
    LD      HL,$72C4
    SET     0,(HL)
    LD      HL,5A0H
    CALL    REQUEST_SIGNAL
    LD      (GAMETIMER),A
LOC_A6AB:
    LD      A,(LETTERMON_COUNTER)
    BIT     5,A
    RET     Z
    RES     5,A
    LD      (LETTERMON_COUNTER),A
;   JP      LOC_D31C
;RET
;LOC_D31C:
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     5,A
    RET     NZ
    CALL    PLAY_EXTRA_WALKING_TUNE_NO_CHOMPERS
RET

SUB_A6BB:
    PUSH    IX
    PUSH    IY
    LD      A,($72C4)
    BIT     0,A
    JR      Z,LOC_A6F2
    CALL    SUB_A61F
    LD      A,(GAMETIMER)
    CALL    TEST_SIGNAL
    JR      Z,LOC_A6F2
    LD      HL,$72C4
    RES     0,(HL)
    LD      A,40H
    LD      (LETTERMON_FLAG),A
    LD      A,1
    LD      ($72C2),A
    LD      A,(LETTERMON_COUNTER)
    RES     6,A
    RES     5,A
    LD      (LETTERMON_COUNTER),A
    CALL    SUB_CA24
    XOR     A
    JP      LOC_A77E
LOC_A6F2:
    LD      IY,LETTERMON_FLAG
    SET     4,(IY+0)
    CALL    SUB_9F29
    LD      D,A
    PUSH    DE
    LD      HL,GAMEFLAGSBONUSITEM
    BIT     5,(HL)
    JR      Z,LOC_A70B
    RES     5,(HL)
    CALL    SUB_B8A3
LOC_A70B:
    CALL    SUB_A527
    POP     DE
    JR      Z,LOC_A74B
    LD      A,(BADGUYFLAGS)
    BIT     4,A
    JR      NZ,LOC_A74B
LOC_A718:
    LD      A,($72C2)
    DEC     A
    LD      ($72C2),A
    JR      NZ,LOC_A72F
    LD      A,0CH
    LD      ($72C2),A
    CALL    RAND_GEN
    AND     0FH
    CP      7
    JR      NC,LOC_A76B
LOC_A72F:
    LD      A,($72C1)
    AND     0FH
    LD      C,A
    LD      B,0
    LD      HL,BYTE_A783
    ADD     HL,BC
    LD      A,(HL)
    AND     D
    JR      Z,LOC_A76B
    LD      A,($72C1)
    AND     0FH
    CALL    SUB_9D2F
    JR      Z,LOC_A77B
    JR      LOC_A76B
LOC_A74B:
    LD      A,(LETTERMON_Y)
    LD      B,A
    LD      A,(LETTERMON_X)
    LD      C,A
    PUSH    DE
    CALL    PEEKMAP
    POP     BC
    CALL    SUB_A028
    JR      Z,LOC_A718
    CP      2
    JR      Z,LOC_A76B
    LD      A,($72C1)
    AND     7
    CALL    SUB_9D2F
    JR      Z,LOC_A77B
LOC_A76B:
    CALL    SUB_9F29
    JR      Z,LOC_A77B
    CALL    SUB_9E7A
    LD      A,($72C1)
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
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     4,A
    JR      Z,LOC_A796
    LD      A,(LETTERMON_COUNTER)
    BIT     6,A
    RET     Z
LOC_A796:
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      IX,LETTERMON_DATA_P1
    JR      Z,LOC_A7A5
    LD      IX,LETTERMON_DATA_P2
LOC_A7A5:
    LD      A,(LETTERMON_COUNTER)
    AND     7
    LD      HL,BYTE_A7DC
    LD      C,A
    ADD     A,A
    ADD     A,C
    LD      C,A
    LD      B,0
    ADD     HL,BC
    LD      A,(HL)
    INC     HL
    AND     (IX+0)
    JR      Z,LOC_A7BC
    INC     HL
LOC_A7BC:
    LD      D,(HL)
    LD      A,(LETTERMON_COUNTER)
    BIT     5,A
    JR      Z,LOC_A7C8
    RES     5,A
    JR      LOC_A7CB
LOC_A7C8:
    SET     5,A
    INC     D
LOC_A7CB:
    LD      (LETTERMON_COUNTER),A
    LD      A,(LETTERMON_Y)
    LD      B,A
    LD      A,(LETTERMON_X)
    LD      C,A
    LD      A,3         ; extra letter
    CALL    PUTSPRITE
RET

BYTE_A7DC:
    DB 001,001,012,002,003,014,004,005,016,008,007,018,016,009,020,008,007,018,004,005,016,002,003,014

SUB_A7F4:
    LD      A,(CHOMPNUMBER)
    AND     3
    LD      C,A
    ADD     A,A     ;*2
    ADD     A,C     ;*3
    ADD     A,A     ;*6
    LD      IY,CHOMPDATA
    LD      C,A
    LD      B,0
    ADD     IY,BC                   ; IY = CHOMPDATA + 6*CHOMPNUMBER

    BIT     7,(IY+4)
    JR      Z,LOC_A82B
    BIT     7,(IY+0)
    JR      NZ,LOC_A82B
    LD      A,(IY+3)
    CALL    TEST_SIGNAL
    JR      Z,LOC_A82B
    CALL    MOVECHOMPER_SUB_A83E    ; MOVE CHOMPER
    CALL    AMIMATECHOMPER_SUB_A83E ; PLOT CHOMPER

    CALL    SUB_9BE2                ; MANAGE MOVEMENT DELAY ACCORDING TO SKILL LEVEL AND PHASE
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A

    CALL    SUB_9FC8                ; Test Collision with MrDo
    JR      LOC_A82C
LOC_A82B:
    XOR     A
LOC_A82C:
    PUSH    AF
    LD      HL,CHOMPNUMBER
    INC     (HL)
    LD      A,(HL)
    CP      3
    JR      C,LOC_A83C
    LD      (HL),0
LOC_A83C:
    POP     AF
RET

;SUB_A7F4:
;   LD      A,(CHOMPNUMBER)
;   AND     3
;   LD      IY,CHOMPDATA
;   LD      BC,6
;LOC_A800:
;   DEC     A
;   JP      M,LOC_A808
;   ADD     IY,BC
;   JR      LOC_A800
;LOC_A808:
;   BIT     7,(IY+4)
;   JR      Z,LOC_A82B
;   BIT     7,(IY+0)
;   JR      NZ,LOC_A82B
;   LD      A,(IY+3)
;   CALL    TEST_SIGNAL
;   JR      Z,LOC_A82B
;   CALL    MOVECHOMPER_SUB_A83E    ; MOVE CHOMPER
;   CALL    AMIMATECHOMPER_SUB_A83E ; PLOT CHOMPER
;   CALL    SUB_A921
;   CALL    SUB_9FC8                ; Test Collisionwith MrDo
;   JR      LOC_A82C
;LOC_A82B:
;   XOR     A
;LOC_A82C:
;   PUSH    AF
;   LD      HL,CHOMPNUMBER
;   INC     (HL)
;   LD      A,(HL)
;   AND     3
;   CP      3
;   JR      NZ,LOC_A83C
;   LD      A,(HL)
;   AND     0FCH
;   LD      (HL),A
;LOC_A83C:
;   POP     AF
;RET

MOVECHOMPER_SUB_A83E:                       ; MOVE CHOMPER
    LD      A,(TIMERCHOMP1)
    CALL    TEST_SIGNAL
    JP      Z,LOC_D3A6
    LD      A,(GAMEFLAGS)
    XOR     1                   ; b0 in GAMEFLAGS ??
    LD      (GAMEFLAGS),A
    LD      HL,78H
    BIT     0,A
    JR      Z,LOC_D39F
    LD      HL,3CH
LOC_D39F:
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (TIMERCHOMP1),A
LOC_D3A6:
    LD      A,(GAMEFLAGS)
    BIT     0,A             ; b0 in GAMEFLAGS ??
    JR      NZ,LOC_A858
;   JP      Z,LOC_A853
;   JP      LOC_A858
;LOC_A853:
    CALL    SUB_A460
    RET
LOC_A858:
    LD      A,(IY+2)
    AND     0FH
    JR      NZ,LOC_A868
    LD      A,(IY+1)
    AND     0FH
    CP      8
    JR      Z,LOC_A878
LOC_A868:
    LD      A,(IY+4)
    AND     7
    DEC     A
    LD      E,A
    LD      D,0
    LD      HL,BYTE_A8C7
    ADD     HL,DE
    LD      H,(HL)
    JR      LOC_A898
LOC_A878:
    LD      H,0F0H
    LD      A,(IY+2)
    CP      28H
    JR      NC,LOC_A883
    RES     4,H
LOC_A883:
    CP      0A8H
    JR      C,LOC_A889
    RES     5,H
LOC_A889:
    LD      A,(IY+1)
    CP      20H
    JR      NC,LOC_A892
    RES     7,H
LOC_A892:
    CP      0E0H
    JR      C,LOC_A898
    RES     6,H
LOC_A898:
    LD      A,H
    PUSH    HL
    CALL    SUB_9E7A
    LD      A,(IY+4)
    AND     7
    CALL    SUB_9D2F
    POP     HL
    RET     Z
    LD      A,(IY+4)
;   JP      LOC_D3D5
;LOC_D3D5:
    AND     7
    LD      C,0C0H
    CP      3
;   JP      LOC_A8AF
;LOC_A8AF:
    JR      NC,LOC_A8B3
    LD      C,30H
LOC_A8B3:
    LD      A,H
    AND     C
    LD      H,A
    JR      NZ,LOC_A898
    LD      A,(IY+4)
    BIT     0,A
    JR      Z,LOC_A8C2
    INC     A
    JR      LOC_A8C3
LOC_A8C2:
    DEC     A
LOC_A8C3:
    LD      (IY+4),A
RET

BYTE_A8C7:
    DB 064,128,016,032

AMIMATECHOMPER_SUB_A83E:
    CALL    SUB_9B4F            ; comment here to make chopers not dig (but they will pass everywhere)
    LD      B,(IY+2)
    LD      C,(IY+1)
    CALL    PEEKMAP
;   LD      D,A     ; already A==D in PEEKMAP
    CALL    SUB_B173

    LD      A,(IY+4)
    AND     7
    CP      1                               ; 1 = right
    JR      Z,CHMPRIGHT
    CP      2                               ; 2 = left
    JR      Z,CHMPLEFT
    CP      3                               ; 3 = up
    JR      Z,CHMPUP
    CP      4                               ; 4 = down
    JR      Z,CHMPDOWN

    LD      BC,$D908
    LD      A,(CHOMPNUMBER)
    ADD     A,17            ; remove chomper
    CALL    PUTSPRITE
    RET                     ; REMOVE THIS SPRITE IN CASE OF ANY OTHER VALUE (?!?)
CHMPLEFT:
    LD      D,3
    JR      LOC_A905
CHMPDOWN:
    LD      D,8             ; left side
    BIT     7,(IY+1)        ; test if X<128
    JR      NZ,LOC_A905
    LD      D,12            ; right side
    JR      LOC_A905
CHMPUP:
    LD      D,6             ; left side
    BIT     7,(IY+1)        ; test if X<128
    JR      NZ,LOC_A905
    LD      D,10            ; right side
    JR      LOC_A905
CHMPRIGHT:
    LD      D,1
LOC_A905:
    LD      A,(IY+5)
    XOR     $80
    JR      Z,.odd
    INC     D
.odd:
    LD      (IY+5),A
    LD      B,(IY+2)
    LD      C,(IY+1)
    LD      A,(CHOMPNUMBER)
    ADD     A,17            ; animate chomper
    CALL    PUTSPRITE
RET

;SUB_A921:
;   CALL    SUB_9BE2
;   XOR     A
;   CALL    REQUEST_SIGNAL
;   LD      (IY+3),A
;RET


GOT_DIAMOND:
    LD      HL,DIAMOND_RAM
    LD      (HL),0
    CP      1
    JR      NZ,.COMPLETED_LEVEL
    LD      HL,78H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
.wait:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.wait
    POP     AF
    JR      LOC_A973
.COMPLETED_LEVEL:
    PUSH    AF
    LD      HL,1EH
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
.wait2:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.wait2
    POP     AF
    POP     AF
    CP      $82                 ; I chose this value so I know A diamond was collected
    JR      Z,DIAMOND_COLLECTED
    CP      2                   ; extra MrDo
    JR      NZ,LOC_A969
    CALL    PLAY_END_OF_ROUND_TUNE
    LD      HL,103H
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_A992:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,LOC_A992
    POP     AF
    JR      LOC_A96C
LOC_A969:
    CALL  INITIALIZE_THE_SOUND
    LD    C,4
    CALL    STORE_COMPLETION_TYPE

    CALL    ExtraMrDo
    JR      LOC_A96C
DIAMOND_COLLECTED:
    CALL    CONGRATULATION
    LD      A,2
LOC_A96C:
    CALL    GO_NEXT_LEVEL
    LD      A,2
    RET
LOC_A973:
    CALL    SUB_AA69
    CP      1
    RET     Z
    AND     A
    JR      Z,LOC_A984
    PUSH    AF
    CALL    WAIT_NMI
    LD      HL,PNT
    LD      DE,300H
    XOR     A
    CALL    FILL_VRAM
    LD      HL,SAT
    LD      DE,80H
    XOR     A
    CALL    FILL_VRAM
    CALL    REMOVESPRITES
    POP     AF
    CP      2
    LD      A,7
    JR      Z,LOC_AB0D
    LD      A,8
LOC_AB0D:
    CALL    PRINT_MESSAGE
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    XOR     A
    LD      HL,0B4H
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AB1E:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,LOC_AB1E
    POP     AF
    LD      A,1
    RET
LOC_A984:
    CALL    SUB_AB28
RET

; Input: C = completion type (1 for cherries,2 for monsters,3 diamond,4 for Extra MrDo)
; Uses: GAMECONTROL to determine active player
;       CURRENT_LEVEL_P1/P2 to get current level
; Output: Stores completion type to correct player's slot
; Preserves: BC,AF
STORE_COMPLETION_TYPE:
    PUSH    AF
    ; Get current level based on active player
    LD      A,(GAMECONTROL)
    BIT     1,A           ; Test if Player 2 is active

    LD      A,(CURRENT_LEVEL_P1)            ; Player 1
    LD      HL,P1_LEVEL_FINISH_BASE
    JR      Z,.p1
    LD      A,(CURRENT_LEVEL_P2)            ; Player 2
    LD      HL,P2_LEVEL_FINISH_BASE
.p1:
    CALL    GET_SLOT_OFFSET     ; Get offset in A and DE
    SRL     E                   ; Divide offset by 2

    ADD     HL,DE           ; ADD offset to base
    LD      (HL),C          ; Store completion type in correct slot
    POP     AF
    RET

ExtraMrDo:  ; CONGRATULATIONS! YOU WIN AN EXTRA MR. DO! TEXT and MUSIC
    CALL    WAIT_NMI

    XOR     A
    LD      (LETTERMON_EXTRAFLAGP2),A
    LD      (LETTERMON_EXTRAFLAGP1),A
    LD      HL,GAMECONTROL
    BIT     1,(HL)
    JR      NZ,.p2
    LD      (LETTERMON_DATA_P1),A
    LD      HL,LIVES_LEFT_P1_RAM
    JR      LOC_A9EC
.p2:
    LD      (LETTERMON_DATA_P2),A
    LD      HL,LIVES_LEFT_P2_RAM

LOC_A9EC:
    LD      A,(HL)
    CP      6               ; max number of lives
    JR      NC,LOC_A9F2
    INC     (HL)
LOC_A9F2:
    LD      BC,1E2H
    CALL    WRITE_REGISTER

    ; %%%%%%%%%%%%%%%%%%%%%%%%%%
    ; show the extra screen
    LD  HL,mode
    SET 7,(HL)                      ; switch to intermission  mode

    CALL    cvb_EXTRASCREEN
    CALL    INITIALIZE_THE_SOUND
    CALL    PLAY_WIN_EXTRA_DO_TUNE

    LD      HL,280H             ; music duration
    XOR     A
    CALL    REQUEST_SIGNAL

    PUSH    AF                      ; wait for music to finish
.1:
    CALL    cvb_EXTRASCREEN_FRM1    ; animate the FLAG
    CALL    WAIT8
    CALL    cvb_EXTRASCREEN_FRM2
    CALL    WAIT8
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.1
    POP     AF

    CALL    REMOVESPRITES
    CALL    MYDISSCR

    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL cvb_MYCLS

    LD  HL,mode
    RES 7,(HL)                      ; switch to game mode
    CALL    INIT_VRAM
    CALL    RESTORE_PLAYFIELD_COLORS

    CALL    WAIT_NMI

    LD      BC,1E2H      ; Original game state register: Enable video and NMI
    CALL    WRITE_REGISTER
RET

WAIT8:
    LD  B,8
.1: HALT
    DJNZ .1
RET


GO_NEXT_LEVEL: ; Level complete,load next level
    CALL    WAIT_NMI

; CALCULATE_LEVEL_SCORE

    ; Check which player
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,.calc_p1_score

.calc_p2_score:
    LD      HL,(SCORE_P2_RAM)       ; Get current total score
    LD      DE,(P2_PREV_SCORE)      ; Get previous total score
    LD      IY,P2_LEVEL1_SCORE      ; Base address for P2 scores ($74DE)
    LD      A,(CURRENT_LEVEL_P2)    ; Get P2's level
    JR      .calc_difference

.calc_p1_score:
    LD      HL,(SCORE_P1_RAM)       ; Get current total score
    LD      DE,(P1_PREV_SCORE)      ; Get previous total score
    LD      IY,P1_LEVEL1_SCORE      ; Base address for P1 scores
    LD      A,(CURRENT_LEVEL_P1)    ; Get P1's level

.calc_difference:
    ; First check if it's level 10 or multiple of 10

    LD      B,10
    CALL    MOD_B                   ; Check if multiple of 10
    AND     A                       ; Check if remainder is 0
    JR      Z,.use_first_slot       ; If multiple of 10,use first slot

    ; For all other levels,calculate based on remainder after division by 10

    DEC     A                       ; Convert to completed level
    LD      B,3
    CALL    MOD_B                   ; Get mod 3 (0,1,2)
    ADD     A,A                     ; Multiply by 2 for bytes offset

    ; ADD offset to IY
    LD      B,0
    LD      C,A
    ADD     IY,BC                   ; IY now points to correct score slot

.use_first_slot:
                                    ; Calculate HL (current) - DE (previous) = level score
    OR      A                       ; Clear carry
    SBC     HL,DE                   ; HL now contains level score

    ; Store level score
    LD      (IY+0),L      ; Store low byte
    LD      (IY+1),H      ; Store high byte


    ; Update previous score for next level
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,.update_p1_prev

.update_p2_prev:
    LD      HL,(SCORE_P2_RAM)
    LD      (P2_PREV_SCORE),HL
    JR      .done

.update_p1_prev:
    LD      HL,(SCORE_P1_RAM)
    LD      (P1_PREV_SCORE),HL

.done:

    LD      HL,CURRENT_LEVEL_P1 ; Player 1
    LD      IX,ENEMY_NUM_P1
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,.PLAYERONE
    INC      HL         ; $7275 ; Player 2 data
    INC      IX         ; $7279 ; Player 2 data
.PLAYERONE:

    ; Current level (either p1 or p2) is loaded into HL
    LD      A,(HL)     ; Load level number
    LD      B,10
    CALL MOD_B  ; Get modulo B

    ; test if we completed level 10xN
    ; if A==0 then go to WONDERFUL SCREEN

    JR NZ,.TEST_INTERMISSION
    PUSH    IX              ; Save Player data pointer
    PUSH    HL              ; Save Level Pointer
    CALL    WONDERFUL
    POP     HL
    POP     IX
    JR .CONTINUE_NEXT_LEVEL

.TEST_INTERMISSION:
    ; here A is in 0-9
    LD      B,3
    CALL MOD_B  ; Get modulo B

    ; now A contains just 0,1,2
    ; if A==0 the level Number is multiple of 3

    PUSH    IX              ; Save Player data pointer
    PUSH    HL              ; Save Level Pointer
    CALL    Z,INTERMISSION
    POP     HL
    POP     IX

.CONTINUE_NEXT_LEVEL:

    LD      (IX+0),7
    INC     (HL)            ; Increment the level number
    LD      A,(HL)
    CALL    SUB_B286        ; buld level in A

    CALL    CURRTIMERINIT   ;   update pointer to timer

    LD      HL,LEVELMAP
    LD      DE,3400H        ; VRAM address to store P1 data
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,LOC_AA5C
    LD      DE,3600H        ; VRAM address to store P2 data
LOC_AA5C:
    LD      BC,0D4H
    CALL    WRITE_VRAM      ; save game data in VRAM
    LD      BC,1E2H
    CALL    WRITE_REGISTER
RET

GET_LEVEL:
    LD      A,(GAMECONTROL)
    BIT     1,A
    LD      A,(CURRENT_LEVEL_P1)
    JR      Z,.MOD
    LD      A,(CURRENT_LEVEL_P2)
.MOD:
    CP      0BH
    RET     C
    SUB     0AH
    JR      .MOD

; Get A modulo B
MOD_B:
    SUB     A,B         ; Subtract B
    JR      NC,MOD_B    ; If result >= 0,continue
    ADD     A,B     ; ADD back B to get remainder in 0-(B-1)
RET

; Divide HL by 10
; Quotient in C,reminder in HL
DIV_HLby10:
    ; Get tens and ones only
    LD DE,10

; Divide HL by DE
; Quotient in C,reminder in HL

DIV_HLbyDE:
    LD  C,0                   ; Counter for tens
.1: or A                       ; Clear carry
    SBC HL,DE
    JR C,.2
    INC C
    JR .1
.2: ADD HL,DE                 ; Restore remainder in HL
RET


; Multiply DE by A (24 bit output)
;  A:HL is product, BC=0,DE preserved
;343cc~423cc, avg= 383cc
;size: 14 bytes
DE_Times_A:
    LD bc,0800h
    LD h,C
    LD l,C
times_loop:
    ADD HL,HL
    rla
    JP nc,$+4
    ADD HL,DE
    ADC A,C
    djnz times_loop
RET

   ;Inputs:
   ;     DEHL is A 32 bit value where DE is the upper 16 bits
   ;     C is the value to divide DEHL by
   ;Outputs:
   ;    A is the remainder
   ;    DEHL is the result of the division
   ;
DEHL_Div_C:
   xor  A
   LD   B, 32
_loop:
   ADD  HL, HL
   rl   E
   rl   D
   rla
   JR   C, $+5
   CP   C
   JR   C, $+4

   sub  C
   INC  l

   djnz _loop

RET


SUB_AA69:
    CALL    WAIT_NMI
    LD      DE,3400H
    BIT     1,(HL)
    JR      Z,LOC_AA7C
    LD      DE,3600H
LOC_AA7C:
    LD      HL,LEVELMAP
    LD      BC,0D4H
    CALL    WRITE_VRAM
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    LD      IX,LIVES_LEFT_P1_RAM
    LD      IY,LIVES_LEFT_P2_RAM
    LD      HL,GAMECONTROL
    BIT     1,(HL)
    JR      NZ,LOC_AABD
    DEC     (IX+0)
    JR      Z,LOC_AAAD
    BIT     0,(HL)
    JR      Z,LOC_AACA
    LD      A,(IY+0)
    AND     A
    JR      Z,LOC_AACA
    SET     1,(HL)
    JR      LOC_AACA
LOC_AAAD:
    BIT     0,(HL)
    JR      Z,LOC_AADA
    LD      A,(IY+0)
    AND     A
    JR      Z,LOC_AADA
    SET     1,(HL)
    LD      A,2
    RET
LOC_AABD:
    DEC     (IY+0)
    JR      Z,LOC_AACE
    LD      A,(IX+0)
    AND     A
    JR      Z,LOC_AACA
    RES     1,(HL)
LOC_AACA:
    LD      A,1
    RET
LOC_AACE:
    LD      A,(IX+0)
    AND     A
    JR      Z,LOC_AADA
    RES     1,(HL)
    LD      A,3
    RET
LOC_AADA:
    XOR     A
RET


SUB_AB28:
    CALL    WAIT_NMI
    LD      HL,SAT
    LD      DE,80H
    XOR     A
    CALL    FILL_VRAM
    CALL    REMOVESPRITES
    LD      A,9
    CALL    PRINT_MESSAGE               ; game over text
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    CALL    PLAY_GAME_OVER_TUNE
    LD      HL,168H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AB5B:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,LOC_AB5B
    POP     AF
    LD      HL,4B0H
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
LOC_AB6C:
    LD      A,(KEYBOARD_P1)
    CP      0AH
    JR      Z,LOC_ABA5
    CP      0BH
    JR      Z,LOC_ABA9
    LD      A,(KEYBOARD_P2)
    CP      0AH
    JR      Z,LOC_ABA5
    CP      0BH
    JR      Z,LOC_ABA9
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,LOC_AB6C
    CALL    WAIT_NMI
    LD      HL,PNT
    LD      DE,300H
    XOR     A
    CALL    FILL_VRAM
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    JR      LOC_AB6C
LOC_ABA5:
    POP     AF
    XOR     A
    RET
LOC_ABA9:
    CALL    WAIT_NMI
    POP     AF
    LD      A,3
RET

SUB_ABB7:
    LD      B,20H
    LD      C,8
    LD      D,0
    DEC     A
LOC_ABBE:
    CP      10H
    JR      C,LOC_ABC7
    SUB     10H
    INC     D
    JR      LOC_ABBE
LOC_ABC7:
    LD      E,A
LOC_ABC8:
    LD      A,E
    AND     A       ;   CP      0
    JR      Z,LOC_ABD4
    LD      A,C
    ADD     A,10H
    LD      C,A
    DEC     E
    JR      LOC_ABC8
LOC_ABD4:
    LD      A,D
    AND     A       ;   CP      0
    RET     Z
    LD      A,B
    ADD     A,10H
    LD      B,A
    DEC     D
    JR      LOC_ABC8
RET

SUB_ABE1:
    PUSH    IX
    CALL    SUB_AC1F
    LD      IX,BYTE_AC2F
    LD      E,A
    ADD     IX,DE
    LD      E,(IX+0)
    LD      A,(HL)
    OR      E
    LD      (HL),A
    POP     IX
RET

SUB_ABF6:
    PUSH    IX
    CALL    SUB_AC1F
    LD      IX,BYTE_AC37
    LD      E,A
    ADD     IX,DE
    LD      E,(IX+0)
    LD      A,(HL)
    AND     E
    LD      (HL),A
    POP     IX
RET

SUB_AC0B:
    PUSH    IX
    CALL    SUB_AC1F
    LD      IX,BYTE_AC2F
    LD      E,A
    ADD     IX,DE
    LD      E,(IX+0)
    LD      A,(HL)
    AND     E
    POP     IX
RET

SUB_AC1F:
    LD      E,0
    DEC     A
LOC_AC22:
    CP      8
    JR      C,LOC_AC2B
    SUB     8
    INC     E
    JR      LOC_AC22
LOC_AC2B:
    LD      D,0
    ADD     HL,DE
RET

BYTE_AC2F:
    DB 128,064,032,016,008,004,002,001
BYTE_AC37:
    DB 127,191,223,239,247,251,253,254


PEEKMAP:
                        ; input B = Y,C = X, output IX -> byte in game map, D offset in game map + 1
    LD      A,B
    SUB     A,24        ; remove 3 lines of the upper scorebar
    AND     $F0         ; same as Y/16 * 16
    LD      D,A

    LD      A,C
    RRCA
    RRCA
    RRCA
    RRCA
    AND     $0F         ; same as X/16

    ADD     A,D

    PUSH    BC
    LD      B,0
    LD      C,A
    LD      IX,LEVELMAP
    ADD     IX,BC
    POP     BC

    INC     A               ; odd (?) offeset fixed elsewhere in the code   ;***
    LD      D,A
                            ; IX  = LEVELMAP + ((Y-24)/16)*16+X/16
                            ; A = D = ((Y-24)/16)*16+X/16 + 1
RET

INIT_PLAYFIELD_MAP:
    DEC     A
    ADD     A,A
    LD      B,0
    LD      C,A
    LD      IX,PLAYFIELD_MAP
    ADD     IX,BC
    LD      B,(IX+1)
    LD      C,(IX+0)
    PUSH    BC
    POP     IX
LOC_ACD5:
    LD      A,2
    CP      (IX+0)
    RET     Z                   ; 2 == END of data
    LD      A,1
    CP      (IX+0)
    JR      NZ,LOC_ACF6
    INC     IX                  ; 1 == Encode A RUN of tiles
    LD      B,(IX+0)
    INC     IX
    LD      A,(IX+0)
LOC_ACED:
    LD      (HL),B
    INC     HL
    DEC     A
    JR      NZ,LOC_ACED
    INC     IX
    JR      LOC_ACD5
LOC_ACF6:
    LD      B,(IX+0)            ; single tiles
    LD      (HL),B
    INC     HL
    INC     IX
    JR      LOC_ACD5
;RET

; in IY the number of 8x8 tiles to process
; in IX the entry in the sprite generator list

UPDATE_SPT:

    LD      A,(IX+0)            ; flag
    LD      E,(IX+1)            ; Position in the SPT in VRAM
    LD      D,(IX+2)
    LD      L,(IX+3)            ; pointer to sprite pattern
    LD      H,(IX+4)
    AND     A
    JP      NZ,.ROTATION
.NOROTATION:
    LD      A,1             ; write the SPT
    CALL    PUT_VRAM            ; IY = #of chars,DE = SPT pos,HL = ROM addr
    RET
.ROTATION:

    PUSH DE
    exx
    POP DE                      ; save DE pointer to SPT positions
    exx
    LD      B,IYL

    DEC     A                   ; 1 mirror frame left
    JP      Z,MIRRORLEFT
    DEC     A                   ; 2 rotate face up
    JP      Z,ROTATE_UP
    DEC     A                   ; 3 rotate face down
    JP      Z,ROTATE_DWN
    DEC     A                   ; 4 rotate face UP-mirror
    JP      Z,ROTATE_UPMIRROR
                                ; 5 rotate face DOWN-mirror
ROTATE_DWNMIRROR:
.nextpattern:
    PUSH    BC
    PUSH    HL
    LD      IY,SPTBUFF2
    CALL    SUB_AE0C            ; rotate face DOWN-mirror
    exx
    LD      A,(DE)
    INC     DE
    exx
    LD      E,A
    LD      D,0
    LD      HL,SPTBUFF2
    LD      IY,1
    LD      A,1
    CALL    PUT_VRAM
    POP     HL
    LD      BC,8
    ADD     HL,BC
    POP     BC
    DJNZ    .nextpattern
RET

MIRRORLEFT:
.nextpattern:
    PUSH    BC
    PUSH    HL
    LD      IY,SPTBUFF2
    CALL    SUB_AD96            ; mirror frame left
    exx
    LD      A,(DE)
    INC     DE
    exx
    LD      E,A
    LD      D,0
    LD      HL,SPTBUFF2
    LD      IY,1
    LD      A,1
    CALL    PUT_VRAM
    POP     HL
    LD      BC,8
    ADD     HL,BC
    POP     BC
    DJNZ    .nextpattern
RET

ROTATE_UP:
.nextpattern:
    PUSH    BC
    PUSH    HL
    LD      IY,SPTBUFF2
    CALL    SUB_ADAB            ; rotate face down
    exx
    LD      A,(DE)
    INC     DE
    exx
    LD      E,A
    LD      D,0
    LD      HL,SPTBUFF2
    LD      IY,1
    LD      A,1
    CALL    PUT_VRAM
    POP     HL
    LD      BC,8
    ADD     HL,BC
    POP     BC
    DJNZ    .nextpattern
RET

ROTATE_DWN:
.nextpattern:
    PUSH    BC
    PUSH    HL
    LD      IY,SPTBUFF2
    CALL    SUB_ADCA            ; rotate face down
    exx
    LD      A,(DE)
    INC     DE
    exx
    LD      E,A
    LD      D,0
    LD      HL,SPTBUFF2
    LD      IY,1
    LD      A,1
    CALL    PUT_VRAM
    POP     HL
    LD      BC,8
    ADD     HL,BC
    POP     BC
    DJNZ    .nextpattern
RET

ROTATE_UPMIRROR:
.nextpattern:
    PUSH    BC
    PUSH    HL
    LD      IY,SPTBUFF2
    CALL    SUB_ADE9            ; rotate face up-mirror
    exx
    LD      A,(DE)
    INC     DE
    exx
    LD      E,A
    LD      D,0
    LD      HL,SPTBUFF2
    LD      IY,1
    LD      A,1
    CALL    PUT_VRAM
    POP     HL
    LD      BC,8
    ADD     HL,BC
    POP     BC
    DJNZ    .nextpattern
RET


SUB_AD96:                   ; mirror frame left
    LD      B,8
LOC_AD98:
    LD      D,(HL)
    LD      C,8
LOC_AD9B:
    SRL     D
    RL      E
    DEC     C
    JR      NZ,LOC_AD9B
    LD      (IY+0),E
    INC     HL
    INC     IY
    DJNZ    LOC_AD98
RET

SUB_ADAB:                   ; rotate face down
    LD      C,8
    PUSH    HL
    LD      D,1
LOC_ADB0:
    POP     HL
    PUSH    HL
    CALL    SUBMIRDWN
    RLC     D
    DEC     C
    JR      NZ,LOC_ADB0
    POP     HL
RET

SUB_ADCA:                       ; rotate face up
    LD      C,8
    PUSH    HL
    LD      D,80H
LOC_ADCF:
    POP     HL
    PUSH    HL
    CALL    SUBMIRDWN
    RRC     D
    DEC     C
    JR      NZ,LOC_ADCF
    POP     HL
RET

SUB_ADE9:                       ; rotate face up-mirror
    LD      BC,7
    ADD     HL,BC
    LD      C,8
    LD      D,1
    PUSH    HL
LOC_ADF2:
    POP     HL
    PUSH    HL
    CALL    SUBMIRDUP
    RLC     D
    DEC     C
    JR      NZ,LOC_ADF2
    POP     HL
RET

SUB_AE0C:                           ; rotate face DOWN-mirror
    LD      BC,7
    ADD     HL,BC
    LD      D,80H
    PUSH    HL
    LD      C,8
LOC_AE15:
    POP     HL
    PUSH    HL
    CALL    SUBMIRDUP
    RRC     D
    DEC     C
    JR      NZ,LOC_AE15
    POP     HL
RET


SUBMIRDWN:
    LD      B,8
.loop:
    LD      A,(HL)
    AND     D
    JR      Z,.zero
    SCF
.zero:
    RL      E
    INC     HL
    DJNZ    .loop
    LD      (IY+0),E
    INC     IY
RET


SUBMIRDUP:
    LD      B,8
.loop:
    LD      A,(HL)
    AND     D
    JR      Z,.zero
    SCF
.zero:
    RL      E
    DEC     HL
    DJNZ    .loop
    LD      (IY+0),E
    INC     IY
RET

PRINT_MESSAGE:          ; Print strings to the playfield
    DEC     A
    ADD     A,A
    LD      C,A
    LD      B,0
    LD      HL,OBJ_POSITION_LIST
    ADD     HL,BC
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    LD      IX,OBJ_DESCRIPTION_LIST
    ADD     IX,BC
    LD      L,(IX+0)
    LD      H,(IX+1)
LOC_AE47:
    LD      A,(HL)
    CP      0FFH        ; END OF THE STRING
    RET     Z
    CP      0FEH        ; next value is an offset, ADD it to the VRAM address
    JR      NZ,LOC_AE5A
    INC     HL
    LD      C,(HL)
    INC     HL
    LD      B,0
    EX      DE,HL
    ADD     HL,BC
    EX      DE,HL
    JR      LOC_AE47
LOC_AE5A:
    CP      0FDH        ; next value is A counter, repeat n times
    JR      NZ,LOC_AE76
    INC     HL
    LD      B,(HL)
    INC     HL
LOOP_AE61:
    PUSH    BC
    PUSH    HL
    PUSH    DE
    LD      A,2
    LD      IY,1
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
    LD      A,2
    LD      IY,1
    CALL    PUT_VRAM
    POP     DE
    POP     HL
    INC     DE
    INC     HL
    JR      LOC_AE47
;RET

;LOC_AE88:
;   LD      IX,BYTE_AEAD
;   LD      B,5
;LOOP_AE8E:
;   PUSH    BC
;   XOR     A
;   EX      DE,HL
;   LD      C,(IX+0)
;   LD      B,(IX+1)
;LOC_AE97:
;   AND     A
;   SBC     HL,BC
;   JR      C,LOC_AE9F
;   INC     A
;   JR      LOC_AE97
;LOC_AE9F:
;   ADD     HL,BC
;   EX      DE,HL
;   ADD     A,0D8H
;   LD      (HL),A
;   INC     HL
;   INC     IX
;   INC     IX
;   POP     BC
;   DJNZ    LOOP_AE8E
;RET

;BYTE_AEAD:
;   DB 016,039,232,003,100,000,010,000,001,000

;SUB_AEB7:
;   LD      B,A     ;***
;   LD      A,(BADGUY_BHVR_CNT_RAM)
;   DEC     A
;   JP      P,LOC_AEC1
;   LD      A,4FH
;LOC_AEC1:
;   LD      E,A
;   LD      D,0
;   LD      HL,BADGUY_BEHAVIOR_RAM
;   ADD     HL,DE
;   LD      A,(HL)
;   CP      B
;   RET     Z
;   LD      A,(BADGUY_BHVR_CNT_RAM)
;   LD      D,0
;   LD      E,A
;   LD      HL,BADGUY_BEHAVIOR_RAM
;   ADD     HL,DE
;   LD      (HL),B
;   INC     A
;   CP      50H
;   JR      C,LOC_AEDD
;   XOR     A
;LOC_AEDD:
;   LD      (BADGUY_BHVR_CNT_RAM),A
;RET

SUB_AEE1:   ; Apple Pushing/Intersection logic
    PUSH    AF
    LD      H,0
LOC_AEE4:
    LD      A,D
    CP      1
    LD      A,C
    JR      NZ,LOC_AEF1
    ADD     A,0CH
    JP      C,LOC_AFF5
    JR      LOC_AEF6
LOC_AEF1:
    SUB     0CH
    JP      C,LOC_AFF5
LOC_AEF6:
    LD      C,A
    LD      E,5
    LD      IX,APPLEDATA
LOC_AEFD:
    BIT     7,(IX+0)
    JR      Z,LOC_AF1A
    LD      A,(IX+2)
    CP      C
    JR      NZ,LOC_AF1A
    LD      A,(IX+1)
    CP      B
    JR      Z,LOC_AF26
    SUB     10H
    CP      B
    JR      NC,LOC_AF1A
    ADD     A,1FH
    CP      B
    JP      NC,LOC_B061
LOC_AF1A:
    PUSH    DE
    LD      DE,5
    ADD     IX,DE
    POP     DE
    DEC     E
    JR      NZ,LOC_AEFD
    JR      LOC_AF76
LOC_AF26:
    LD      A,(IX+0)
    AND     78H
    JP      NZ,LOC_AFD2
    INC     H
    POP     AF
    PUSH    AF
    CP      2
    JP      Z,LOC_AEE4
    CP      3
    JR      NZ,LOC_AEE4
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      A,C
    BIT     0,D
    JR      Z,LOC_AF48
    ADD     A,6
    JR      LOC_AF4A
LOC_AF48:
    SUB     6
LOC_AF4A:
    LD      C,A
    CALL    PEEKMAP
    LD      A,C
    AND     0FH
    CP      8
    LD      A,(IX+0)
    JR      NC,LOC_AF60
    AND     5
    CP      5
    JR      NZ,LOC_AF6E
    JR      LOC_AF66
LOC_AF60:
    AND     0AH
    CP      0AH
    JR      NZ,LOC_AF6E
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
    LD      E,0
    LD      A,H
    AND     A
    JP      Z,LOC_B063
    POP     AF
    PUSH    AF
    CP      1
    JR      NZ,LOC_AFD7
    PUSH    DE
    PUSH    HL
    LD      IX,ENEMY_DATA_ARRAY
    LD      L,7
LOC_AF8B:
    BIT     7,(IX+4)
    JR      Z,LOC_AFBF
    BIT     6,(IX+4)
    JR      NZ,LOC_AFBF
    LD      A,(GAMEFLAGSBONUSITEM)
    BIT     4,A
    JR      NZ,LOC_AFA5
    LD      A,(IX+0)
    AND     30H
    JR      Z,LOC_AFBF
LOC_AFA5:
    LD      A,(IX+2)
    SUB     0CH
    CP      B
    JR      NC,LOC_AFBF
    ADD     A,18H
    CP      B
    JR      C,LOC_AFBF
    LD      A,(IX+1)
    SUB     4
    CP      C
    JR      NC,LOC_AFBF
    ADD     A,8
    CP      C
    JR      NC,LOC_AFD0
LOC_AFBF:
    LD      DE,6
    ADD     IX,DE
    DEC     L
    JR      NZ,LOC_AF8B
    POP     HL
    POP     DE
    CALL    SUB_B066
    JR      NZ,LOC_AFD2
    JR      LOC_AFF6
LOC_AFD0:
    POP     HL
    POP     DE
LOC_AFD2:
    LD      E,3
    JP      LOC_B063
LOC_AFD7:                       ; BADGUY Pushes APPLE (?)
    LD      A,(MRDO_DATA.Y)
    SUB     0CH
    CP      B
    JR      NC,LOC_AFF6
    ADD     A,18H
    CP      B
    JR      C,LOC_AFF6
    LD      A,(MRDO_DATA.X)
    SUB     4
    CP      C
    JR      NC,LOC_AFF6
    ADD     A,8
    CP      C
    JR      C,LOC_AFF6
    LD      E,3
    JR      LOC_B063
LOC_AFF5:
    LD      C,A
LOC_AFF6:
    LD      E,0
    LD      A,H
    AND     A
    JR      Z,LOC_B063
LOC_AFFC:
    LD      A,D
    CP      1
    LD      A,C
    JR      NZ,LOC_B006
    SUB     0CH
    JR      LOC_B008
LOC_B006:
    ADD     A,0CH
LOC_B008:
    LD      C,A
    LD      IX,APPLEDATA
    LD      E,5
LOC_B00F:
    BIT     7,(IX+0)
    JR      Z,LOC_B050
    LD      A,(IX+1)
    CP      B
    JR      NZ,LOC_B050
    LD      A,(IX+2)
    CP      C
    JR      NZ,LOC_B050
    LD      A,D
    CP      1
    LD      A,C
    JR      NZ,LOC_B02F
    ADD     A,4
    CP      0E9H
    JR      NC,LOC_B061
    JR      LOC_B035
LOC_B02F:
    SUB     4
    CP      18H
    JR      C,LOC_B061
LOC_B035:
    LD      (IX+2),A
    PUSH    BC
    PUSH    DE
    PUSH    HL
    PUSH    IX
    LD      C,A
    LD      B,(IX+1)
    LD      A,17
    SUB     E
    LD      D,1         ; animate chomper
    CALL    PUTSPRITE
    POP     IX
    POP     HL
    POP     DE
    POP     BC
    JR      LOC_B05A
LOC_B050:
    PUSH    DE
    LD      DE,5
    ADD     IX,DE
    POP     DE
    DEC     E
    JR      NZ,LOC_B00F
LOC_B05A:   ; Mr. Do pushing an apple from the bottom
    DEC     H
    JR      NZ,LOC_AFFC
    LD      E,1
    JR      LOC_B063
LOC_B061:
    LD      E,2
LOC_B063:
    POP     AF
    LD      A,E
RET

SUB_B066:
    PUSH    IY
    PUSH    HL
    LD      IY,ENEMY_DATA_ARRAY
    LD      HL,207H
LOC_B070:
    LD      A,(IY+4)
    BIT     7,A
    JP      Z,LOC_B105
    BIT     6,A
    JP      NZ,LOC_B105
    LD      A,(IY+0)
    AND     30H
    JP      NZ,LOC_B105
LOC_B085:
    LD      A,(IY+2)
    SUB     B
    JR      NC,LOC_B08D
    NEG
LOC_B08D:
    CP      10H
    JR      NC,LOC_B105
    LD      A,(IY+1)
    BIT     0,D
    JR      NZ,LOC_B0B7
    CP      C
    JR      C,LOC_B105
    SUB     9
    CP      C
    JR      NC,LOC_B105
    PUSH    BC
    PUSH    DE
    PUSH    HL
    CALL    SUB_9F29
    POP     HL
    POP     DE
    POP     BC
    BIT     7,A
    JR      Z,LOC_B0D8
    LD      A,(IY+1)
    SUB     4
    LD      (IY+1),A
    JR      LOC_B085
LOC_B0B7:
    CP      C
    JR      Z,LOC_B0BC
    JR      NC,LOC_B105
LOC_B0BC:
    ADD     A,9
    CP      C
    JR      C,LOC_B105
    PUSH    BC
    PUSH    DE
    PUSH    HL
    CALL    SUB_9F29
    POP     HL
    POP     DE
    POP     BC
    BIT     6,A
    JR      Z,LOC_B0D8
    LD      A,(IY+1)
    ADD     A,4
    LD      (IY+1),A
    JR      LOC_B085
LOC_B0D8:
    PUSH    AF
    LD      A,(IY+2)
    CP      B
    JR      C,LOC_B0F8
    POP     AF
    BIT     5,A
    JR      Z,LOC_B0EE
    LD      A,(IY+2)
    ADD     A,4
    LD      (IY+2),A
    JR      LOC_B105

LOC_B0F8:
    POP     AF
    BIT     4,A
    JR      Z,LOC_B126
    LD      A,(IY+2)
    SUB     4
    LD      (IY+2),A
LOC_B105:
    PUSH    DE
    LD      DE,6
    ADD     IY,DE
    POP     DE
    DEC     L
    JP      NZ,LOC_B070
    DEC     H
    JR      Z,LOC_B123
    LD      A,(LETTERMON_COUNTER)
    BIT     6,A
    JR      Z,LOC_B123
    LD      IY,LETTERMON_FLAG
    LD      L,1
    JP      LOC_B085
LOC_B123:
    XOR     A
    JR      LOC_B128
LOC_B0EE:
    PUSH    AF
    LD      A,(IY+2)
    CP      B
    JR      Z,LOC_B0F8
    POP     AF
LOC_B126:
    LD      A,1
LOC_B128:
    POP     HL
    POP     IY
    AND     A
RET

SUB_B12D: ; Mr. Do sprite intersection with apples from above and below
    LD      IX,APPLEDATA    ; IX points to the first apple's sprite data
    LD      E,5     ; Number of apples to check
    ; Modified to offset the value used to detect A vertical collision
    ; with an apple so that Mr. Do doesn't get stuck in the apple from
    ; above or below.

    JR      NC,LOC_B133 ; CF==0 -> monsters,CF==1 ->MrDo

    LD      A,(IY+3)        ; Get Y position of Mr. Do
    BIT     1,D         ; Check if moving down
    JR      Z,CHECK_UP
    SUB     4               ; Moving down,so sub 4 from Y position
    JR      START_CHECK
CHECK_UP:
    ADD     A,4         ; Moving up,so ADD 4 to Y position
START_CHECK:
    LD      B,A         ; Store the new Y position in B for checks

LOC_B133:
    BIT     7,(IX+0)        ; Check if the apple is active
    JR      Z,LOC_B163
    LD      A,B
    BIT     1,D
    JR      Z,LOC_B149
    SUB     (IX+1)
    JR      C,LOC_B163
    CP      0DH
    JR      NC,LOC_B163
    JR      LOC_B156
LOC_B149:
    SUB     (IX+1)
    JR      Z,LOC_B156
    JR      NC,LOC_B163
    NEG
    CP      0DH
    JR      NC,LOC_B163
LOC_B156:
    LD      A,(IX+2)
    ADD     A,9
    CP      C
    JR      C,LOC_B163
    SUB     12H
    CP      C
    JR      C,LOC_B170
LOC_B163:
    EX      DE,HL
    LD      DE,5
    ADD     IX,DE
    EX      DE,HL
    DEC     E
    JR      NZ,LOC_B133
    XOR     A
    RET
LOC_B170:
    LD      A,1
RET

SUB_B173:
    LD      A,D         ;***
    PUSH    AF
    LD      HL,ENEMYINTERACT
    CALL    SUB_AC0B
    JR      Z,LOC_B198
    POP     AF
    PUSH    AF
    DEC     A
    LD      C,A
    LD      B,0
    LD      HL,LEVELMAP
    ADD     HL,BC
    LD      A,(HL)
    AND     0FH
    CP      0FH
    JR      NZ,LOC_B198
    POP     AF
    LD      HL,ENEMYINTERACT
    CALL    SUB_ABF6
    SCF
    RET
LOC_B198:
    POP     AF
    AND     A
RET

DISPLAY_PLAY_FIELD_PARTS:
    PUSH    AF
    CP      48H
    JP      Z,LOC_B24E
    DEC     A
    LD      C,A
    LD      B,0
    LD      IY,LEVELMAP
    ADD     IY,BC
    POP     AF
    PUSH    AF

;   CALL    SUB_B591
;SUB_B591:
    LD      HL,60H
    LD      DE,40H
    DEC     A
LOC_B598:
    CP      10H
    JR      C,LOC_B5A1
    ADD     HL,DE
    SUB     10H
    JR      LOC_B598
LOC_B5A1:
    ADD     A,A
    LD      E,A
    ADD     HL,DE
    EX      DE,HL
;RET (was subroutine)

    LD      IX,TUNNEL_WALL_PATTERNS
    LD      BC,3
DISPLAY_CHERRIES:
    LD      A,(IX+0)
    AND     (IY+0)
    JR      NZ,DISPLAY_TUNNELS
    POP     AF
    PUSH    AF
    PUSH    DE
    PUSH    IX
    PUSH    BC
    LD      HL,ENEMYINTERACT
    CALL    SUB_AC0B
    POP     BC
    POP     IX
    POP     DE
    JR      Z,DISPLAY_PLAYFIELD
    LD      HL,CHERRIES_TXT
    ADD     HL,BC
    JR      PLAYFIELD_TO_VRAM
DISPLAY_PLAYFIELD:
    PUSH    BC
    CALL    GET_LEVEL
    DEC     A
    LD      C,A
    LD      B,0
    LD      HL,PLAYFIELD_PATTERNS
    ADD     HL,BC
    POP     BC
    JR      PLAYFIELD_TO_VRAM
DISPLAY_TUNNELS:
    LD      HL,TUNNEL_PATTERNS
    LD      A,(IY+0)
    AND     (IX+1)
    JR      Z,LOC_B20A
    PUSH    BC
    LD      BC,8
    ADD     HL,BC
    POP     BC
LOC_B20A:
    LD      A,(IY+0)
    AND     (IX+2)
    JR      Z,LOC_B216
    INC     HL
    INC     HL
    INC     HL
    INC     HL
LOC_B216:
    LD      A,(IY+0)
    AND     (IX+3)
    JR      Z,LOC_B220
    INC     HL
    INC     HL
LOC_B220:
    LD      A,(IY+0)
    AND     (IX+4)
    JR      Z,PLAYFIELD_TO_VRAM
    INC     HL
PLAYFIELD_TO_VRAM:
    PUSH    BC
    PUSH    DE
    PUSH    IX
    PUSH    IY
    LD      IY,1
    LD      A,2
    CALL    PUT_VRAM
    POP     IY
    POP     IX
    POP     DE
    LD      L,(IX+5)
    LD      H,0
    ADD     HL,DE
    EX      DE,HL
    LD      BC,6
    ADD     IX,BC
    POP     BC
    DEC     C
    JP      P,DISPLAY_CHERRIES
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
    DB 10,10,10,10,10,10,10,10,10,10

SUB_B286:                   ; build level in A
    CALL    GET_LEVEL.MOD

    PUSH    AF
    LD      HL,LEVELMAP
    LD      (HL),0
    LD      DE,$718B
    LD      BC,9FH
    LDIR
    LD      HL,LEVELMAP
    CALL    INIT_PLAYFIELD_MAP
    POP     AF
    DEC     A
    ADD     A,A
    LD      C,A
    LD      B,0
    PUSH    BC
    LD      IX,CHERRY_PLACEMENT_TABLE
    ADD     IX,BC
    LD      L,(IX+0)
    LD      H,(IX+1)
    LD      DE,ENEMYINTERACT
    LD      BC,20
    LDIR
    CALL    RAND_GEN
    LD      IX,EXTRA_BEHAVIOR
    BIT     0,A
    JR      Z,LOC_B2CC
    LD      IX,APPLE_PLACEMENT_TABLE
LOC_B2CC:
    POP     BC
    ADD     IX,BC
    LD      L,(IX+0)
    LD      H,(IX+1)
    LD      B,5
    LD      IY,APPLEDATA
LOOP_B2DB:
    LD      A,(HL)
    PUSH    HL
    PUSH    BC
    CALL    SUB_ABB7
    LD      (IY+0),80H
    LD      (IY+1),B
    LD      (IY+2),C
    LD      (IY+3),0
    LD      DE,5
    ADD     IY,DE
    POP     BC
    POP     HL
    INC     HL
    DJNZ    LOOP_B2DB
RET

SUB_B2FA:
    PUSH    IY
    PUSH    HL
    CALL    PEEKMAP
    LD      D,A
    LD      E,0
    LD      A,C
    AND     0FH
    CP      8
    JR      NZ,LOC_B32C
    LD      A,(IX+0)
    AND     0AH
    CP      0AH
    JR      Z,LOC_B31D
    LD      E,1
    SET     1,(IX+0)
    SET     3,(IX+0)
LOC_B31D:
    PUSH    IX
    PUSH    DE
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B399
LOC_B32C:
    AND     A
    JR      NZ,LOC_B370
    LD      A,(IX+0)
    AND     85H
    CP      85H
    JR      Z,LOC_B342
    LD      E,1
    LD      A,(IX+0)
    OR      85H
    LD      (IX+0),A
LOC_B342:
    PUSH    DE
    PUSH    IX
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    DEC     IX
    DEC     D
    BIT     6,(IX+0)
    JR      NZ,LOC_B360
    POP     DE
    LD      E,1
    PUSH    DE
    DEC     D
LOC_B360:
    SET     6,(IX+0)
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B399
LOC_B370:
    POP     IY
    PUSH    IY
    CP      4
    JR      Z,LOC_B38B
    INC     IX
    LD      C,80H
    LD      A,(IX+0)
    DEC     IX
    AND     5
    CP      5
    JR      Z,LOC_B399
    LD      B,D
    INC     B
    JR      LOC_B397
LOC_B38B:
    LD      C,84H
    LD      A,(IX+0)
    AND     0AH
    CP      0AH
    JR      Z,LOC_B399
    LD      B,D
LOC_B397:
    LD      E,1
LOC_B399:
    POP     HL
    POP     IY
RET

SUB_B39D:
    PUSH    IY
    PUSH    HL
    CALL    PEEKMAP
    LD      D,A
    LD      E,0
    LD      A,C
    AND     0FH
    JR      NZ,LOC_B3EC
    BIT     7,(IX+0)
    JR      NZ,LOC_B3B7
    LD      E,1
    SET     7,(IX+0)
LOC_B3B7:
    PUSH    DE
    PUSH    IX
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    DEC     IX
    DEC     D
    LD      A,(IX+0)
    AND     4AH
    CP      4AH
    JR      Z,LOC_B3E0
    POP     DE
    LD      E,1
    PUSH    DE
    DEC     D
    LD      A,(IX+0)
    OR      4AH
    LD      (IX+0),A
LOC_B3E0:
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B43B
LOC_B3EC:
    CP      8
    JR      NZ,LOC_B412
    LD      A,(IX+0)
    AND     5
    CP      5
    JR      Z,LOC_B403
    LD      E,1
    SET     0,(IX+0)
    SET     2,(IX+0)
LOC_B403:
    LD      A,D
    LD      HL,ENEMYINTERACT2
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
    JR      NZ,LOC_B428
    LD      C,85H
    LD      A,(IX+0)
    AND     5
    CP      5
    JR      Z,LOC_B43B
    LD      B,D
    JR      LOC_B439
LOC_B428:
    LD      C,81H
    DEC     IX
    LD      A,(IX+0)
    INC     IX
    AND     0AH
    CP      0AH
    JR      Z,LOC_B43B
    LD      B,D
    DEC     B
LOC_B439:
    LD      E,1
LOC_B43B:
    POP     HL
    POP     IY
RET

SUB_B43F:
    PUSH    IY
    PUSH    HL
    CALL    PEEKMAP
    LD      D,A
    LD      E,0
    LD      A,B
    AND     0FH
    CP      8
    JR      NZ,LOC_B493
    BIT     4,(IX+0)
    JR      NZ,LOC_B45B
    LD      E,1
    SET     4,(IX+0)
LOC_B45B:
    PUSH    DE
    PUSH    IX
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    LD      BC,-16
    ADD     IX,BC
    LD      A,(IX+0)
    AND     2CH
    CP      2CH
    JR      Z,LOC_B485
    POP     DE
    LD      E,1
    PUSH    DE
    LD      A,(IX+0)
    OR      2CH
    LD      (IX+0),A
LOC_B485:
    LD      A,D
    SUB     10H
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B4E5
LOC_B493:
    AND     A
    JR      NZ,LOC_B4B8
    LD      A,(IX+0)
    AND     3
    CP      3
    JR      Z,LOC_B4A9
    LD      E,1
    SET     0,(IX+0)
    SET     1,(IX+0)
LOC_B4A9:
    PUSH    IX
    PUSH    DE
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B4E5
LOC_B4B8:
    CP      4
    JR      NZ,LOC_B4CA
    LD      A,(IX+0)
    AND     3
    CP      3
    JR      Z,LOC_B4E5
    LD      B,D
    LD      C,82H
    JR      LOC_B4E3
LOC_B4CA:
    LD      BC,-16
    ADD     IX,BC
    LD      A,(IX+0)
    LD      BC,10H
    ADD     IX,BC
    AND     0CH
    CP      0CH
    JR      Z,LOC_B4E5
    LD      A,D
    SUB     10H
    LD      B,A
    LD      C,86H
LOC_B4E3:
    LD      E,1
LOC_B4E5:
    POP     HL
    POP     IY
RET

SUB_B4E9:
    PUSH    IY
    PUSH    HL
    CALL    PEEKMAP
    LD      D,A
    LD      A,B
    AND     0FH
    CP      8
    JR      NZ,LOC_B53B
    LD      A,(IX+0)
    AND     13H
    CP      13H
    JR      Z,LOC_B50A
    LD      E,1
    LD      A,(IX+0)
    OR      13H
    LD      (IX+0),A
LOC_B50A:
    PUSH    DE
    PUSH    IX
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     IX
    POP     DE
    PUSH    IX
    PUSH    DE
    LD      BC,-16
    ADD     IX,BC
    BIT     5,(IX+0)
    JR      NZ,LOC_B52D
    POP     DE
    LD      E,1
    PUSH    DE
    SET     5,(IX+0)
LOC_B52D:
    LD      A,D
    SUB     10H
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B58D
LOC_B53B:
    AND     A
    JR      NZ,LOC_B560
    LD      A,(IX+0)
    AND     0CH
    CP      0CH
    JR      Z,LOC_B551
    LD      E,1
    SET     2,(IX+0)
    SET     3,(IX+0)
LOC_B551:
    PUSH    IX
    PUSH    DE
    LD      A,D
    LD      HL,ENEMYINTERACT2
    CALL    SUB_ABE1
    POP     DE
    POP     IX
    JR      LOC_B58D
LOC_B560:
    CP      4
    JR      NZ,LOC_B57F
    LD      BC,10H
    ADD     IX,BC
    LD      A,(IX+0)
    LD      BC,-16
    ADD     IX,BC
    AND     0CH
    CP      0CH
    JR      Z,LOC_B58D
    LD      A,D
    ADD     A,10H
    LD      B,A
    LD      C,87H
    JR      LOC_B58B
LOC_B57F:
    LD      A,(IX+0)
    AND     3
    CP      3
    JR      Z,LOC_B58D
    LD      B,D
    LD      C,83H
LOC_B58B:
    LD      E,1
LOC_B58D:
    POP     HL
    POP     IY
RET

;SUB_B591:
;   LD      HL,60H
;   LD      DE,40H
;   DEC     A
;LOC_B598:
;   CP      10H
;   JR      C,LOC_B5A1
;   ADD     HL,DE
;   SUB     10H
;   JR      LOC_B598
;LOC_B5A1:
;   ADD     A,A
;   LD      E,A
;   ADD     HL,DE
;   EX      DE,HL
;RET

; convert binary score in decimal and print it

PRINT_SCORE:            ; A=0 for P1, A=1 for P2
    ADD     A,A
    ADD     A,A
    LD      C,A
    LD      B,0
    LD      HL,BYTE_B5D4
    ADD     HL,BC
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    INC     HL
    PUSH    HL
    EX      DE,HL
    LD      E,(HL)
    INC     HL
    LD      D,(HL)      ; DE = score of p1 or p2
    LD      HL,SCRATCH
;   CALL    LOC_AE88
;LOC_AE88:
    LD      IX,BYTE_AEAD
    LD      B,5
LOOP_AE8E:
    PUSH    BC
    XOR     A
    EX      DE,HL
    LD      C,(IX+0)
    LD      B,(IX+1)    ; compare with current power of 10
LOC_AE97:
    AND     A
    SBC     HL,BC
    JR      C,LOC_AE9F
    INC     A           ; decimal digit
    JR      LOC_AE97
LOC_AE9F:
    ADD     HL,BC
    EX      DE,HL
    ADD     A,0D8H      ; offset for "0"
    LD      (HL),A
    INC     HL
    INC     IX
    INC     IX
    POP     BC
    DJNZ    LOOP_AE8E
; RET   (was A subroutine)
    LD      A,0D8H
    LD      (SCRATCH+5),A   ; last fake "0"
    LD      A,2
    POP     HL
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    LD      HL,SCRATCH
    LD      IY,6            ; print 6 digits
    CALL    PUT_VRAM
RET

BYTE_B5D4:
    DW SCORE_P1_RAM
    DW          36  ; SCREEN POSITION SCORE P1
    DW SCORE_P2_RAM
    DW          68  ; SCREEN POSITION SCORE P2
;   DB          0   ; ?? unused?

BYTE_AEAD:
    DW 10000
    DW  1000
    DW   100
    DW    10
    DW     1

SUB_B5DD:   ; Ball collision detection
    LD      A,B
    SUB     7
    CP      (IY+1)
    JR      NC,LOC_B5FF
    ADD     A,0EH
    CP      (IY+1)
    JR      C,LOC_B5FF
    LD      A,C
    SUB     7
    CP      (IY+2)
    JR      NC,LOC_B5FF
    ADD     A,0EH
    CP      (IY+2)
    JR      C,LOC_B5FF
    LD      A,1
    RET
LOC_B5FF:
    XOR     A
RET

SUB_B601:                           ; ADD DE to the SCORE of the active player
    LD      IX,SCORE_P1_RAM
    LD      C,80H
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,LOC_B614
    LD      IX,SCORE_P2_RAM
    LD      C,40H
LOC_B614:
    LD      L,(IX+0)                ; change here to pass to 24 bits
    LD      H,(IX+1)
    ADD     HL,DE
    LD      (IX+0),L
    LD      (IX+1),H
    LD      A,(SCOREFLAG)       ; tell where to print the score
    OR      C               ; $80 for P1, $40 for P2
    LD      (SCOREFLAG),A
RET


PUTSPRITE:      ; B=Y, C=X, A = OBJECT/SAT Position, D=Frame
    PUSH    DE          ; Save FRAME NUMBER in D

    AND     7FH         ; SAT position
    ADD     A,A

    LD      E,A
    LD      D,0
    LD      HL,SPR_OBJ_ATTRB            ; frame and color table (pointer)
    ADD     HL,DE

    ADD     A,A
    LD      E,A
;       LD      D,0             ; already 0
    LD      IX,SPRITE_NAME_TABLE
    ADD     IX,DE

    LD      A,(HL)
    INC     HL
    LD      H,(HL)
    LD      L,A             ; HL -> frame list

    POP     AF              ; restore frame number in A
    ADD     A,A
    LD      E,A
    LD      D,0
    ADD     HL,DE               ; HL -> current frame

    LD      A,(GAMECONTROL)     ; stop sprite update
    SET     3,A
    LD      (GAMECONTROL),A

    LD      A,B
    CP      4*8-1                   ; if it is plotted in the scorebar test what FRAME is it
    CALL    C,.MYCRAPPYPATCH
    LD      A,B
    SUB     8
    LD      (IX+0),A                ; Y
    LD      A,C
    SUB     8
    LD      (IX+1),A                ; X
    LD      A,(HL)
    LD      (IX+2),A                ; FRAME
    INC     HL
    LD      A,(HL)
    AND     A
    JR      NZ,.2
    LD      (IX+0),$D1              ; remove if transparent (part of the crappy patch)
.2:     
    LD      (IX+3),A                ; COLOR

    LD      A,(GAMECONTROL)     ; enable sprite update
    RES     3,A
    LD      (GAMECONTROL),A
RET

.MYCRAPPYPATCH:
    LD      A,(HL)
    CP      140                 ; the BALL can be with Y<24 (i.E.32)
    RET     Z
    
    SUB     96                  ; if FRAME<MONSTER LETTER E, remove it
    CP      117-96              ; if FRAME>MONSTER LETTER EMPTY, remove it
    RET     C
    
.REMOVE:                ; set breackpoint at PUTSPRITE.REMOVE and trace back in the debugger
    LD      B,$D1               ; remove this crap
    RET


SPR_OBJ_ATTRB:          ; Sprite frame and color data
    DW BYTE_B6C3    ; 0 ball
    DW BYTE_B6C7    ; 1 mr do
    DW 0    ; free
    DW BYTE_B6CF    ; 3 Extra letter
    DW BYTE_B6FB    ; 4 ball explosion
    DW BYTE_B70B    ; 5 bad guy/digger
    DW BYTE_B70B    ; 6 bad guy/digger
    DW BYTE_B70B    ; 7 bad guy/digger
    DW BYTE_B70B    ; 8 bad guy/digger
    DW BYTE_B70B    ; 9 bad guy/digger
    DW BYTE_B70B    ;10 bad guy/digger
    DW BYTE_B70B    ;11 bad guy/digger
    DW BYTE_B757    ;12 apple
    DW BYTE_B757    ;13 apple
    DW BYTE_B757    ;14 apple
    DW BYTE_B757    ;15 apple
    DW BYTE_B757    ;16 apple
    DW BYTE_B761    ;17 chomper
    DW BYTE_B761    ;18 chomper
    DW BYTE_B761    ;19 chomper

BYTE_B6C3:
    DB 000,000,184,015    ; Ball Sprite pattern 184 uses White

BYTE_B6C7:                ; MrDo
    DB  176,6,132,015     ; Patterns 176,132 use White

BYTE_B6CF:          ; EXTRA SPRITES!!
    DB   0,0
    DB 096,011,116,011,116,011,100,011,104,011,116,011,116,011,108,011,112,011,116,011  ; Series using Light Yellow
    DB 132,011
    DB 096,008,116,008,116,008,100,008,104,008,116,008,116,008,108,008,112,008,116,008  ; Series using Medium Red

BYTE_B6FB:
    DB 000,000,140,015,144,015,148,015,152,015,156,015,160,015,164,015    ; Ball sprite using White

BYTE_B70B:
    ; 0 null
    DB   0,0
    ; 1 - 12 Bad guys red
    DB   0, 8, 4, 8, 8, 8,12, 8,16, 8,20, 8,24, 8,28, 8,32, 8,36, 8,40, 8,44, 8 ; Badguy sprites and colors (Red)
    ; 13 - 24 Bad guys Transforming
    DB   0, 7, 4, 7, 8, 7,12, 7,16, 7,20, 7,24, 7,28, 7,32, 7,36, 7,40, 7,44, 7 ; Badguy Transforming sprites and colors (cyan)
    ; 25 - 36 light blue digger
    DB  48, 5,52, 5,56, 5,60, 5,64, 5,68, 5,72, 5,76, 5,80, 5,84, 5,88, 5,92, 5 ; Digger sprites and colors (Light Blue)
    ; 37 enemy smashed (purple)
    DB 132,13
    ; 38 - 39 Bad guy pushing right
    DB 240, 8,244, 8
    ; 40 - 41 Bad guy pushing left
    DB 248, 8,252, 8

BYTE_B757:
    DB 000,000,120,008,124,008,128,008,136,015    ; Apple sprite colors (Medium Red),ending with White diamond

BYTE_B761:      ; Chomper animation
    DB   0,0    ; null
    DB 192, 5,196, 5,200, 5,204, 5,132, 5    ; Series using Light Blue
    DB 208, 5,212, 5        ;  6,7 upA
    DB 216, 5,220, 5        ;  8,9 dwnA
    DB 224, 5,228, 5        ; 10,11 upB
    DB 232, 5,236, 5        ; 12,13 dwnB

SUB_B76D:
    LD      A,40H
    LD      (LETTERMON_FLAG),A
    LD      HL,$72C4
    BIT     0,(HL)
    JR      Z,LOC_B781
    RES     0,(HL)
    LD      A,(SCORE_P1_RAM)        ; THIS SEEMS A BUG (!?) WHY USE THE SCORE AS TIMER ID ?
;   LD      A,(LETTERMON_TIMER)     ; doesn't solve....
    CALL    FREE_SIGNAL
LOC_B781:
    CALL    SUB_CA24
    LD      A,1
    LD      ($72C2),A
    LD      A,(LETTERMON_COUNTER)
    RES     6,A
    RES     5,A
    LD      (LETTERMON_COUNTER),A
    AND     7
    LD      C,A
    LD      B,0
    LD      HL,BYTE_B7BC
    ADD     HL,BC
    LD      B,(HL)
    LD      HL,LETTERMON_DATA_P1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_B7AA
    INC     HL
LOC_B7AA:
    LD      C,0
    LD      A,(HL)
    OR      B
    LD      (HL),A
    CP      1FH
    JR      NZ,LOC_B7B4
    INC     C
LOC_B7B4:
    LD      A,C
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

    LD      (IX+4),$0C0

    CALL    SUB_B7EF
    ADD     A,5
    LD      D,0             ; remove bad guy
    LD      BC,$D908
    CALL    PUTSPRITE
    LD      HL,ENEMY_NUM_P1
    LD      A,(GAMECONTROL)
    AND     3
    CP      3
    JR      NZ,LOC_B7E7
    INC     HL              ; point to ENEMY_NUM_P2
LOC_B7E7:
    DEC     (HL)            ; one enemy killed
    POP     IX
    POP     HL
                            ; ZF is tested from the caller
RET

SUB_B7EF:
    PUSH    DE
    PUSH    HL
    PUSH    IX
    POP     HL
    LD      DE,-ENEMY_DATA_ARRAY
    ADD     HL,DE
    LD      A,L
    LD      H,0
    AND     A
    JR      Z,LOC_B805
LOC_B800:
    INC     H
    SUB     6
    JR      NZ,LOC_B800
LOC_B805:
    LD      A,H
    POP     HL
    POP     DE
RET

SUB_B809:
    LD      IX,CHOMPDATA
    LD      B,3
LOC_B80F:
    BIT     7,(IX+4)
    JR      Z,LOC_B82A
    BIT     7,(IX+0)
    JR      NZ,LOC_B82A
    PUSH    BC
    CALL    SUB_B832
    PUSH    IX
    LD      DE,32H              ; killed chomper ??
    CALL    SUB_B601
    POP     IX
    POP     BC
LOC_B82A:
    LD      DE,6
    ADD     IX,DE
    DJNZ    LOC_B80F
RET

SUB_B832:
    PUSH    IY
    PUSH    IX
    LD      (IX+4),0
    LD      A,(IX+3)
    CALL    FREE_SIGNAL
    LD      BC,CHOMPDATA
    LD      D,11H
    AND     A
    PUSH    IX
    POP     HL
    SBC     HL,BC
    JR      Z,LOC_B856
    LD      BC,6
LOC_B850:
    INC     D
    AND     A
    SBC     HL,BC
    JR      NZ,LOC_B850
LOC_B856:
    LD      BC,$D908
    LD      A,D         ; remove chomper
    LD      D,0
    CALL    PUTSPRITE
    LD      IX,CHOMPDATA
    LD      B,3
LOC_B865:
    BIT     7,(IX+4)
    JR      NZ,LOC_B89E
    LD      DE,6
    ADD     IX,DE
    DJNZ    LOC_B865
    CALL    SUB_CA2D
    CALL    WAIT_NMI
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    LD      HL,GAMEFLAGSBONUSITEM
    RES     4,(HL)
    LD      A,(GAMEFLAGS)
    BIT     0,A                 ; b0 in GAMEFLAGS ??
    JR      NZ,LOC_B884
    LD      A,(TIMERCHOMP1)
    CALL    FREE_SIGNAL
LOC_B884:
    XOR     A
    LD      (GAMEFLAGS),A
    LD      A,(LETTERMON_COUNTER)
    BIT     6,A
    JR      Z,LOC_B89E
    LD      HL,$72C4
    ; JP        LOC_D300
; LOC_D300:
    SET     0,(HL)
    LD      HL,5A0H
    XOR     A
    ; JP        LOC_B895
; LOC_B895:
    CALL    REQUEST_SIGNAL
    LD      (GAMETIMER),A
    CALL    PLAY_EXTRA_WALKING_TUNE_NO_CHOMPERS

LOC_B89E:
    POP     IX
    POP     IY
RET

SUB_B8A3:
    PUSH    IX
    PUSH    HL
    PUSH    DE
    PUSH    BC
    CALL    SUB_B8F7
    PUSH    IY
    CALL    SUB_CA24
    CALL    WAIT_NMI
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    CALL  PLAY_DESSERT_COLLECT_SOUND

    ; Wait for dessert collect sound to finish
    LD      HL,1EH          ; Same duration as in COMPLETED_LEVEL
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF
.wait:
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.wait
    POP     AF

    CALL    PLAY_BLUE_CHOMPERS_SOUND
    POP     IY
    LD      IX,CHOMPDATA    ; chomper data
    LD      B,3     ; chomper number
LOC_B8B1:
    LD      (IX+0),10H
    LD      A,(LETTERMON_Y)
    LD      (IX+2),A
    LD      A,(LETTERMON_X)
    LD      (IX+1),A
    LD      A,($72C1)
    AND     7
    OR      80H
    LD      (IX+4),A
    LD      (IX+5),0
    PUSH    BC
    XOR     A
    LD      HL,1
    CALL    REQUEST_SIGNAL
    LD      (IX+3),A
    POP     BC
    LD      DE,6
    ADD     IX,DE
    DJNZ    LOC_B8B1            ; init the 3 chompers

    XOR     A
    LD      HL,78H
    CALL    REQUEST_SIGNAL

    LD      (TIMERCHOMP1),A         ; save signal timer for chomper mode
    LD      HL,$72C4
    BIT     0,(HL)
    JP      Z,LOC_B8EC
    RES     0,(HL)
;   LD      A,(GAMETIMER)           ; ?? what is it for ??
;   CALL    TEST_SIGNAL             ; apparently unused

LOC_B8EC:
    LD      A,80H
    LD      (GAMEFLAGS),A       ; b7 in GAMEFLAGS -> chomper mode

; immediately return the ball when in chomper mode
; only if Mr. Do is in cool down mode (Bit 6 is SET)
    LD      IY,BALLDATA             ; Load ball state pointer
    BIT   5,(IY+0)              ; Check if BIT 5 is SET
    JR    Z,.skip_ball_return   ; Skip ball return if not in cooldown phase

    LD      (IY+0),$20          ; Set BIT 5,reset direction flags
    LD      (IY+1),0            ; reset ball's X
    LD      (IY+2),0            ; reset ball's Y

    LD      HL,1
    XOR     A
    CALL    REQUEST_SIGNAL
    LD      (IY+3),A         ; Store signal result
    RES     5,(IY+0)
    SET     3,(IY+0)
    LD      (IY+5),0
    CALL    PLAY_BALL_RETURN_SOUND
.skip_ball_return:
    ; Ensure balls in flight are returned immediately after they strike an enemy
    LD      (IY+4),1  ; Set cooldown to 1
    POP     BC
    POP     DE
    POP     HL
    POP     IX
RET


SUB_B8F7:
    PUSH    IY
    CALL    WAIT_NMI

    LD  A,11
    CALL SET_LEVEL_COLORS.RESTORE_COLORS

    LD      BC,1E2H
    CALL    WRITE_REGISTER

    POP     IY
RET


RESTORE_PLAYFIELD_COLORS:
    PUSH    IY                  ; Calculate correct level colors using original logic
    CALL    SET_LEVEL_COLORS
    LD      BC,1E2H
    CALL    WRITE_REGISTER
    POP     IY
RET

SET_LEVEL_COLORS:
    CALL    GET_LEVEL
.RESTORE_COLORS:
    DEC     A
    PUSH    AF

    ADD     A,A
    ADD     A,A
    ADD     A,A         ;x8
    LD      L,A
    LD      H,0

    CALL MyNMI_off

    PUSH    HL

    LD      DE,PT+32*3*8        ; copy background
    ADD     HL,DE
    EX      DE,HL
    LD      HL,WORKBUFFER
    LD      BC,8
    CALL    MYINIRVM

    LD      DE,PT+(10)*8
    CALL    REP8                ; plot playfield pattern
    LD      DE,PT+(10)*8 + 256*8
    CALL    REP8                ; plot playfield pattern
    LD      DE,PT+(10)*8 + 256*2*8
    CALL    REP8                ; plot playfield pattern

    POP     HL
    PUSH    HL

    LD      DE,CT+32*3*8        ; copy background
    ADD     HL,DE
    EX      DE,HL
    LD      HL,WORKBUFFER
    LD      BC,8
    CALL    MYINIRVM

    LD      DE,CT+(10)*8
    CALL    REP8                ; plot playfield color

    POP     HL
    ADD     HL,HL               ; A*16
    PUSH    HL

    LD      DE,PT+32*4*8        ; cherry top  tiles
    ADD     HL,DE
    EX      DE,HL
    LD      HL,WORKBUFFER
    LD      BC,16               ; using WORKBUFFER
    CALL    MYINIRVM

    LD      DE,PT+(8)*8
    CALL    REP16               ; using WORKBUFFER
    LD      DE,PT+(8)*8 + 256*8
    CALL    REP16               ; using WORKBUFFER
    LD      DE,PT+(8)*8 + 256*2*8
    CALL    REP16               ; using WORKBUFFER

    POP     HL
    PUSH    HL

    LD      DE,CT+32*4*8
    ADD     HL,DE
    EX      DE,HL
    LD      HL,WORKBUFFER
    LD      BC,16               ; using WORKBUFFER
    CALL    MYINIRVM

    LD      DE,CT+(8)*8
    CALL    REP16               ; using WORKBUFFER

    POP     HL
    PUSH    HL

    LD      DE,PT+32*5*8
    ADD     HL,DE
    EX      DE,HL
    LD      HL,WORKBUFFER
    LD      BC,16               ; using WORKBUFFER
    CALL    MYINIRVM

    LD      DE,PT+(16)*8
    CALL    REP16               ; using WORKBUFFER
    LD      DE,PT+(16)*8 + 256*8
    CALL    REP16               ; using WORKBUFFER
    LD      DE,PT+(16)*8 + 256*2*8
    CALL    REP16               ; using WORKBUFFER

    POP     HL

    LD      DE,CT+32*5*8
    ADD     HL,DE
    EX      DE,HL
    LD      HL,WORKBUFFER
    LD      BC,16               ; using WORKBUFFER
    CALL    MYINIRVM

    LD      DE,CT+(16)*8
    CALL    REP16               ; using WORKBUFFER

    POP     AF                  ; level number
    LD      E,A
    LD      D,0
    LD      HL,staticcolors
    ADD     HL,DE
    LD      A,(HL)
    LD      DE,8*8
    LD      HL,CT+(2*32+24)*8
    CALL    FILL_VRAM

    CALL    MyNMI_on
RET

staticcolors:               ; leftovers
    DB $C1,$51,$31,$A1,$31
    DB $51,$31,$51,$C1,$51,$91

REP8:
    LD      BC,8
    JR      REP16.1
REP16:
    LD      BC,16
.1: LD      HL,WORKBUFFER
    CALL    MYLDIRVM
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

OBJ_POSITION_LIST:
    DW $0020,$000A,$016E,$0188,$0188,$016E,$0166,$0166,$016A,$016E,$016E,$016E,$016E,$016E,$0040,$016E,$016E,$016E,$016E,$016E

OBJ_DESCRIPTION_LIST:
    DW P1ST_PHASE_LEVEL_GEN             ; 1
    DW EXTRA_BORDER_GEN                 ; 2
    DW BADGUY_OUTLINE_GEN               ; 3
    DW GET_READY_P1_GEN                 ; 4
    DW GET_READY_P2_GEN                 ; 5

    DW PIE_SLICE_GEN                    ; 6 (was WIN EXTRA MrDo)

    DW GAME_OVER_P1_GEN                 ; 7
    DW GAME_OVER_P2_GEN                 ; 8
    DW GAME_OVER_GEN                    ; 9

    DW WHEAT_SQUARE_GEN                 ;10
    DW GUMDROP_GEN                      ;11
    DW SUNDAE_GEN                       ;12
    DW BURGER                           ;13

    DW BLANK_SPACE_GEN                  ;14
    DW P2ND_GEN                         ;15

    DW SANDWICH                         ;16
    DW MILK                             ;17
    DW EGGS                             ;18
    DW BAGEL                            ;19
    DW DRINK                            ;20


P1ST_PHASE_LEVEL_GEN:
;   DB 066,067,068,254,023,241,233,255
    DB 124,125,216,216,0FEH, 23, 73, 74,0FFH            ;1st, two fake 0s and PH
EXTRA_BORDER_GEN:
    DB 058,0FDH,009,061,063,0FEH,021,059,0FEH,009,064,0FEH,021,060,0FDH,009,062,065,0FFH
GET_READY_P1_GEN:
    DB 232,230,245,000,243,230,226,229,250,000,241,237,226,250,230,243,000,217,0FFH
GET_READY_P2_GEN:
    DB 232,230,245,000,243,230,226,229,250,000,241,237,226,250,230,243,000,218,0FFH

GAME_OVER_P1_GEN:
    DB 0FDH,020,000,0FEH,012,000,232,226,238,230,000,240,247,230,243,000,241,237,226,250,230,243,000,217,000,0FEH,012,0FDH,020,000,0FFH
GAME_OVER_P2_GEN:
    DB 0FDH,020,000,0FEH,012,000,232,226,238,230,000,240,247,230,243,000,241,237,226,250,230,243,000,218,000,0FEH,012,0FDH,020,000,0FFH
GAME_OVER_GEN:
    DB 0FDH,011,000,0FEH,021,000,232,226,238,230,000,240,247,230,243,000,0FEH,021,0FDH,011,000,0FFH

P2ND_GEN:
    DB 126,127,216,216,0FFH             ;2nd and two fake 0s

BLANK_SPACE_GEN:    DB   0, 0,0FEH,030,  0,  0,0FFH
BADGUY_OUTLINE_GEN: DB  76,77,0FEH,030,108,109,0FFH

PIE_SLICE_GEN:      DB  78,79,0FEH,030,110,111,0FFH
WHEAT_SQUARE_GEN:   DB  80,81,0FEH,030,112,113,0FFH
GUMDROP_GEN:        DB  82,83,0FEH,030,114,115,0FFH
SUNDAE_GEN:         DB  84,85,0FEH,030,116,117,0FFH
BURGER:             DB  86,87,0FEH,030,118,119,0FFH

SANDWICH:           DB 150,151,0FEH,030,182,183,0FFH
MILK:               DB 152,153,0FEH,030,184,185,0FFH
EGGS:               DB 154,155,0FEH,030,186,187,0FFH
BAGEL:              DB 156,157,0FEH,030,188,189,0FFH
DRINK:              DB 158,159,0FEH,030,190,191,0FFH


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




; MrDo 4 frames                     ;
MRDOGENERATOR:
    DB 0                            ; 0 right   0   ; MrDo sprites start from here
    DW 44*4,MR_DO_WALK_RIGHT_00_PAT
    DB 0                            ; 1
    DW 44*4,MR_DO_WALK_RIGHT_01_PAT
    DB 0                            ; 2
    DW 44*4,MR_DO_WALK_RIGHT_02_PAT
    DB 0                            ; 3
    DW 44*4,MR_DO_WALK_RIGHT_01_PAT

    DB 0                            ; 0 right 4
    DW 44*4,MR_DO_PUSH_RIGHT_00_PAT
    DB 0                            ; 1     5
    DW 44*4,MR_DO_PUSH_RIGHT_01_PAT
    DB 0                            ; 2     6
    DW 44*4,MR_DO_PUSH_RIGHT_02_PAT
    DB 0                            ; 3     7
    DW 44*4,MR_DO_PUSH_RIGHT_01_PAT

    DB 1                            ; 0 left 8
    DW BYTE_C284,MR_DO_WALK_RIGHT_00_PAT
    DB 1                            ; 1
    DW BYTE_C284,MR_DO_WALK_RIGHT_01_PAT
    DB 1                            ; 2
    DW BYTE_C284,MR_DO_WALK_RIGHT_02_PAT
    DB 1                            ; 3
    DW BYTE_C284,MR_DO_WALK_RIGHT_01_PAT

    DB 1                            ; 0 left 12
    DW BYTE_C284,MR_DO_PUSH_RIGHT_00_PAT
    DB 1                            ; 1     13
    DW BYTE_C284,MR_DO_PUSH_RIGHT_01_PAT
    DB 1                            ; 2     14
    DW BYTE_C284,MR_DO_PUSH_RIGHT_02_PAT
    DB 1                            ; 3     15
    DW BYTE_C284,MR_DO_PUSH_RIGHT_01_PAT

    DB 2                            ; 0 up  16
    DW BYTE_C288,MR_DO_WALK_RIGHT_00_PAT
    DB 2                            ; 1
    DW BYTE_C288,MR_DO_WALK_RIGHT_01_PAT
    DB 2                            ; 2
    DW BYTE_C288,MR_DO_WALK_RIGHT_02_PAT
    DB 2                            ; 3
    DW BYTE_C288,MR_DO_WALK_RIGHT_01_PAT

    DB 2                            ; 0 up 20
    DW BYTE_C288,MR_DO_PUSH_RIGHT_00_PAT
    DB 2                            ; 1
    DW BYTE_C288,MR_DO_PUSH_RIGHT_01_PAT
    DB 2                            ; 2
    DW BYTE_C288,MR_DO_PUSH_RIGHT_02_PAT
    DB 2                            ; 3
    DW BYTE_C288,MR_DO_PUSH_RIGHT_01_PAT

    DB 3                            ; 0 down    24
    DW BYTE_C28C,MR_DO_WALK_RIGHT_00_PAT
    DB 3                            ; 1
    DW BYTE_C28C,MR_DO_WALK_RIGHT_01_PAT
    DB 3                            ; 2
    DW BYTE_C28C,MR_DO_WALK_RIGHT_02_PAT
    DB 3                            ; 3
    DW BYTE_C28C,MR_DO_WALK_RIGHT_01_PAT

    DB 3                            ; 0 down 28
    DW BYTE_C28C,MR_DO_PUSH_RIGHT_00_PAT
    DB 3                            ; 1
    DW BYTE_C28C,MR_DO_PUSH_RIGHT_01_PAT
    DB 3                            ; 2
    DW BYTE_C28C,MR_DO_PUSH_RIGHT_02_PAT
    DB 3                            ; 3
    DW BYTE_C28C,MR_DO_PUSH_RIGHT_01_PAT

    DB 4                            ; 0 up-mirror 32
    DW BYTE_C290,MR_DO_WALK_RIGHT_00_PAT
    DB 4                            ; 1
    DW BYTE_C290,MR_DO_WALK_RIGHT_01_PAT
    DB 4                            ; 2
    DW BYTE_C290,MR_DO_WALK_RIGHT_02_PAT
    DB 4                            ; 3
    DW BYTE_C290,MR_DO_WALK_RIGHT_01_PAT

    DB 4                            ; 0 up-mirror 36
    DW BYTE_C290,MR_DO_PUSH_RIGHT_00_PAT
    DB 4                            ; 1
    DW BYTE_C290,MR_DO_PUSH_RIGHT_01_PAT
    DB 4                            ; 2
    DW BYTE_C290,MR_DO_PUSH_RIGHT_02_PAT
    DB 4                            ; 3
    DW BYTE_C290,MR_DO_PUSH_RIGHT_01_PAT

    DB 5                            ; 0 down-mirror 40
    DW BYTE_C294,MR_DO_WALK_RIGHT_00_PAT
    DB 5                            ; 1
    DW BYTE_C294,MR_DO_WALK_RIGHT_01_PAT
    DB 5                            ; 2
    DW BYTE_C294,MR_DO_WALK_RIGHT_02_PAT
    DB 5                            ; 3
    DW BYTE_C294,MR_DO_WALK_RIGHT_01_PAT

    DB 5                            ; 0 down-mirror 44
    DW BYTE_C294,MR_DO_PUSH_RIGHT_00_PAT
    DB 5                            ; 1
    DW BYTE_C294,MR_DO_PUSH_RIGHT_01_PAT
    DB 5                            ; 2
    DW BYTE_C294,MR_DO_PUSH_RIGHT_02_PAT
    DB 5                            ; 3
    DW BYTE_C294,MR_DO_PUSH_RIGHT_01_PAT

    DB 0                            ; 0 Death 48
    DW 44*4,MR_DO_DEATH_F0
    DB 0                            ; 1
    DW 44*4,MR_DO_DEATH_F1
    DB 0                            ; 2
    DW 44*4,MR_DO_DEATH_F2
    DB 0                            ; 3
    DW 44*4,MR_DO_DEATH_F3


BYTE_C284:      DB 178,179,176,177,45*4+2,45*4+3,45*4+0,45*4+1
BYTE_C288:      DB 177,179,176,178,45*4+1,45*4+3,45*4+0,45*4+2
BYTE_C28C:      DB 176,178,177,179,45*4+0,45*4+2,45*4+1,45*4+3
BYTE_C290:      DB 179,177,178,176,45*4+3,45*4+1,45*4+2,45*4+0
BYTE_C294:      DB 178,176,179,177,45*4+2,45*4+0,45*4+3,45*4+1


MR_DO_WALK_RIGHT_00_PAT:
 DB $00,$03,$05,$0f,$1d,$36,$00,$00,$2c,$3b,$07,$1d,$17,$01,$00,$00,$00,$c0,$a0,$e0,$00,$00,$00,$00,$40,$e0,$d8,$78,$c0,$60,$c0,$00,$00,$00,$02,$00,$02,$08,$41,$00,$51,$44,$00,$62,$68,$40,$40,$00,$00,$00,$40,$00,$e0,$b0,$b0,$e0,$80,$00,$24,$84,$00,$80,$3c,$00
MR_DO_WALK_RIGHT_01_PAT:
 DB $00,$07,$0b,$1f,$35,$0e,$00,$00,$00,$03,$0f,$1d,$1f,$09,$03,$00,$00,$c0,$60,$e0,$00,$00,$00,$00,$40,$e0,$b8,$e8,$60,$c0,$80,$00,$00,$00,$04,$40,$0a,$00,$01,$00,$01,$04,$00,$02,$00,$06,$00,$00,$00,$00,$80,$00,$e0,$b0,$b0,$e0,$80,$00,$44,$14,$80,$00,$78,$00
MR_DO_WALK_RIGHT_02_PAT:
 DB $00,$03,$0d,$3f,$15,$0e,$00,$00,$06,$0f,$2e,$3b,$07,$07,$00,$00,$00,$c0,$60,$e0,$00,$00,$00,$00,$78,$e8,$a0,$f0,$40,$00,$00,$00,$00,$00,$42,$00,$0a,$00,$01,$00,$01,$00,$51,$44,$00,$00,$07,$00,$00,$00,$80,$00,$e0,$b0,$b0,$e0,$84,$14,$40,$00,$bc,$00,$c0,$00

MR_DO_PUSH_RIGHT_00_PAT:
 DB $00,$01,$02,$07,$0e,$1b,$00,$00,$00,$03,$05,$1f,$16,$01,$00,$00,$00,$e0,$d0,$f0,$80,$00,$00,$00,$20,$f0,$ec,$bc,$c0,$e0,$c0,$00,$00,$00,$01,$00,$01,$04,$20,$00,$00,$00,$02,$60,$69,$40,$40,$00,$00,$00,$20,$00,$70,$58,$d8,$70,$c0,$01,$13,$43,$00,$00,$3c,$00
MR_DO_PUSH_RIGHT_01_PAT:
 DB $00,$01,$02,$07,$0d,$03,$00,$00,$07,$0f,$0a,$0f,$05,$03,$00,$00,$00,$f0,$d8,$f8,$40,$80,$00,$00,$00,$e0,$fc,$bc,$c0,$80,$00,$00,$00,$00,$01,$10,$02,$00,$00,$00,$00,$00,$05,$00,$02,$00,$03,$00,$00,$00,$20,$00,$b8,$2c,$6c,$38,$60,$01,$03,$43,$00,$00,$e0,$00
MR_DO_PUSH_RIGHT_02_PAT:
 DB $00,$07,$03,$01,$01,$00,$00,$00,$01,$02,$07,$0d,$17,$3c,$00,$00,$00,$e0,$58,$fc,$a0,$c0,$00,$00,$80,$f0,$fc,$5c,$e0,$c0,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$01,$00,$02,$08,$00,$3e,$00,$00,$00,$a0,$00,$5c,$16,$36,$1c,$30,$01,$03,$a3,$00,$3c,$00,$00

MR_DO_DEATH_F0:
 DB $00,$38,$68,$f8,$58,$e0,$8a,$1f,$1a,$07,$0a,$1f,$1a,$04,$00,$00,$00,$00,$00,$00,$00,$00,$06,$fe,$a8,$f0,$b0,$e8,$78,$28,$30,$00,$00,$00,$10,$01,$a3,$01,$04,$a0,$21,$00,$05,$00,$04,$78,$00,$00,$00,$f0,$f0,$f8,$6c,$68,$f1,$01,$50,$00,$40,$10,$00,$10,$0f,$00
MR_DO_DEATH_F1:
 DB $00,$00,$03,$0d,$3f,$7a,$6f,$34,$08,$08,$18,$2c,$38,$00,$00,$00,$00,$00,$60,$b0,$f8,$a8,$fc,$0c,$06,$06,$04,$00,$00,$e0,$40,$00,$00,$00,$00,$02,$00,$85,$90,$81,$81,$83,$06,$12,$01,$30,$01,$00,$00,$00,$00,$40,$00,$50,$00,$e0,$e0,$f0,$da,$d2,$e2,$02,$80,$00
MR_DO_DEATH_F2:
 DB $00,$00,$06,$05,$07,$0a,$0f,$0d,$0f,$08,$00,$00,$50,$78,$00,$00,$00,$00,$00,$1c,$34,$dc,$f8,$50,$f0,$10,$00,$00,$0e,$1a,$00,$00,$00,$0f,$38,$02,$00,$05,$00,$02,$00,$03,$03,$07,$ad,$85,$03,$00,$00,$00,$06,$03,$0b,$21,$01,$a1,$00,$c0,$c0,$e0,$b1,$a5,$c0,$00
MR_DO_DEATH_F3:
 DB $00,$00,$00,$00,$00,$00,$06,$0a,$5f,$78,$00,$00,$50,$78,$00,$00,$00,$00,$00,$00,$00,$00,$60,$b0,$f6,$1c,$00,$00,$0e,$1a,$00,$00,$00,$03,$04,$03,$00,$00,$80,$85,$a0,$83,$03,$07,$ad,$85,$03,$00,$00,$c0,$20,$c0,$00,$00,$01,$41,$09,$c1,$c0,$e0,$b1,$a5,$c0,$00

; bad guy
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

; digger
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


ENEMY_GENERATOR:
    DB 000                          ;0
    DW 0,BADGUY_RIGHT_WALK_01_PAT
    DB 000                          ;1
    DW 4,BADGUY_RIGHT_WALK_02_PAT
    DB 001                          ;2
    DW BYTE_C234,BADGUY_RIGHT_WALK_01_PAT
    DB 001                          ;3
    DW BYTE_C238,BADGUY_RIGHT_WALK_02_PAT
    DB 002                          ;4
    DW BYTE_C23C,BADGUY_RIGHT_WALK_01_PAT
    DB 002                          ;5
    DW BYTE_C240,BADGUY_RIGHT_WALK_02_PAT
    DB 003                          ;6
    DW BYTE_C244,BADGUY_RIGHT_WALK_01_PAT
    DB 003                          ;7
    DW BYTE_C248,BADGUY_RIGHT_WALK_02_PAT
    DB 004                          ;8
    DW BYTE_C24C,BADGUY_RIGHT_WALK_01_PAT
    DB 004                          ;9
    DW BYTE_C250,BADGUY_RIGHT_WALK_02_PAT
    DB 005                          ;10
    DW BYTE_C254,BADGUY_RIGHT_WALK_01_PAT
    DB 005                          ;11
    DW BYTE_C258,BADGUY_RIGHT_WALK_02_PAT
    DB 000                          ;12
    DW 48,DIGGER_RIGHT_01_PAT
    DB 000                          ;13
    DW 52,DIGGER_RIGHT_02_PAT
    DB 001                          ;14
    DW BYTE_C25C,DIGGER_RIGHT_01_PAT
    DB 001                          ;15
    DW BYTE_C260,DIGGER_RIGHT_02_PAT
    DB 002                          ;16
    DW BYTE_C264,DIGGER_RIGHT_01_PAT
    DB 002                          ;17
    DW BYTE_C268,DIGGER_RIGHT_02_PAT
    DB 003                          ;18
    DW BYTE_C26C,DIGGER_RIGHT_01_PAT
    DB 003                          ;19
    DW BYTE_C270,DIGGER_RIGHT_02_PAT
    DB 004                          ;20
    DW BYTE_C274,DIGGER_RIGHT_01_PAT
    DB 004                          ;21
    DW BYTE_C278,DIGGER_RIGHT_02_PAT
    DB 005                          ;22
    DW BYTE_C27C,DIGGER_RIGHT_01_PAT
    DB 005                          ;23
    DW BYTE_C280,DIGGER_RIGHT_02_PAT

CHOMPER_GEN:
    DB 000
    DW 192,CHOMPER_RIGHT_CLOSED_PAT
    DB 000
    DW 196,CHOMPER_RIGHT_OPEN_PAT
    DB 001
    DW CHMPL0,CHOMPER_RIGHT_CLOSED_PAT
    DB 001
    DW CHMPL1,CHOMPER_RIGHT_OPEN_PAT

    DB 002
    DW CHMPU0A,CHOMPER_RIGHT_CLOSED_PAT
    DB 002
    DW CHMPU1A,CHOMPER_RIGHT_OPEN_PAT
    DB 003
    DW CHMPD0A,CHOMPER_RIGHT_CLOSED_PAT
    DB 003
    DW CHMPD1A,CHOMPER_RIGHT_OPEN_PAT

    DB 004
    DW CHMPU0B,CHOMPER_RIGHT_CLOSED_PAT
    DB 004
    DW CHMPU1B,CHOMPER_RIGHT_OPEN_PAT
    DB 005
    DW CHMPD0B,CHOMPER_RIGHT_CLOSED_PAT
    DB 005
    DW CHMPD1B,CHOMPER_RIGHT_OPEN_PAT

BADGUYPUSH_GEN:
    DB 000
    DW 240,BadGuyPushRight_01
    DB 000
    DW 244,BadGuyPushRight_02
    DB 001
    DW BadGuyPushL0,BadGuyPushRight_01
    DB 001
    DW BadGuyPushL1,BadGuyPushRight_02


CHMPL0:     DB 192+10,192+11,192+08,192+09
CHMPL1:     DB 192+14,192+15,192+12,192+13
CHMPU0A:    DB 192+17,192+19,192+16,192+18
CHMPU1A:    DB 192+21,192+23,192+20,192+22
CHMPD0A:    DB 192+24,192+26,192+25,192+27
CHMPD1A:    DB 192+28,192+30,192+29,192+31
CHMPU0B:    DB 192+35,192+33,192+34,192+32
CHMPU1B:    DB 192+39,192+37,192+38,192+36
CHMPD0B:    DB 192+42,192+40,192+43,192+41
CHMPD1B:    DB 192+46,192+44,192+47,192+45


BadGuyPushL0:   DB 250,251,248,249
BadGuyPushL1:   DB 254,255,252,253

BadGuyPushRight_01:
    db $1f,$3f,$3e,$3e,$3f,$1f,$07,$7c
    db $3b,$3b,$1c,$3e,$00,$00,$00,$00
    db $f0,$38,$dc,$9c,$1c,$fc,$f9,$03
    db $ff,$fe,$00,$e0,$40,$f8,$00,$00
BadGuyPushRight_02:
    db $03,$0f,$0f,$1f,$1f,$0f,$07,$1e
    db $3d,$3d,$7e,$10,$10,$3e,$00,$00
    db $f8,$8c,$4c,$6c,$9c,$fc,$f9,$01
    db $ff,$fe,$00,$f8,$00,$00,$00,$00

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
   DB 000,014,031,025,014,017,063,056
   DB 053,056,063,059,017,000,000,000
   DB 000,056,124,100,184,192,252,000
   DB 084,000,252,220,136,000,000,000
CHOMPER_RIGHT_OPEN_PAT:
   DB 014,025,025,014,017,063,056,053
   DB 048,048,050,056,063,036,000,000
   DB 056,100,100,184,192,252,000,084
   DB 000,000,168,000,252,036,000,000


    ; Total sprites: 18
EXTRA_SPRITE_COMP:
    db $00,$1e,$39,$39,$60,$47,$44,$80
    db $01,$44,$27,$30,$0f,$06,$3c,$00
    db $00,$00,$78,$9c,$9c,$06,$f2,$02
    db $00,$c2,$02,$02,$f4,$0c,$f0,$7e
    db $00,$b8,$00,$1f,$46,$43,$0d,$40
    db $41,$43,$26,$60,$1f,$32,$62,$c2
    db $82,$35,$62,$34,$8c,$1f,$47,$40
    db $00,$6e,$20,$31,$3f,$82,$00,$84
    db $b9,$1f,$4d,$5d,$02,$24,$60,$1f
    db $e2,$32,$32,$e2,$35,$42,$74,$a5
    db $1f,$5c,$46,$20,$b8,$1f,$c2,$06
    db $62,$32,$12,$f2,$14,$d8,$1f,$20
    db $20,$70,$40,$00,$60,$30,$1f,$d2
    db $0f,$20,$38,$04,$02,$00,$06,$0c
    db $28,$f8,$60,$2f,$00,$01,$01,$1c
    db $0d,$1e,$3f,$00,$1f,$58,$0f,$40
    db $0f,$80,$00,$00,$70,$c8,$e4,$f4
    db $f4,$fc,$fc,$07,$f8,$f0,$f0,$60
    db $00,$80,$20,$3c,$3c,$3e,$3f,$3e
    db $1d,$1e,$0f,$07,$0f,$00,$20,$38
    db $64,$f2,$fa,$7a,$3e,$7e,$0d,$7c
    db $38,$30,$00,$80,$00,$32,$54,$f4
    db $f8,$fc,$7c,$1e,$7c,$3e,$0f,$00
    db $0f,$08,$0e,$1d,$1d,$3b,$3e,$3e
    db $1b,$7c,$78,$00,$81,$00,$30,$7e
    db $33,$7c,$bc,$0f,$0c,$1c,$7e,$cc
    db $3e,$07,$0e,$00,$15,$3b,$4c,$37
    db $1f,$0b,$05,$02,$6c,$01,$17,$e0
    db $00,$50,$b8,$64,$d8,$f0,$a0,$40
    db $80,$dc,$2b,$0d,$01,$03,$03,$01
    db $e1,$3b,$80,$c0,$c0,$bd,$1e,$3d
    db $1f,$02,$3b,$1e,$a4,$da,$1e,$f3
    db $f6,$3f,$f6,$5d,$46,$04,$b1,$00
    db $04,$e0,$20,$40,$00,$20,$b5,$03
    db $93,$1e,$08,$03,$10,$3e,$d4,$20
    db $ba,$1c,$0f,$05,$f9,$1e,$10,$b5
    db $12,$13,$e7,$20,$3c,$0f,$08,$07
    db $c6,$1e,$20,$dd,$51,$24,$78,$0c
    db $1a,$00,$bc,$71,$09,$ff,$ff,$ff
    db $ff,$c0

;EXTRA_SPRITE_PAT:
;   DB 030,057,057,096,071,068,071,068 ; E Left foot down
;   DB 068,039,048,015,006,060,000,000
;   DB 120,156,156,006,242,002,194,002
;   DB 002,244,012,240,126,000,000,000
;   DB 030,057,057,096,070,067,064,065 ; X Left foot down
;   DB 067,038,048,015,006,060,000,000
;   DB 120,156,156,006,050,098,194,130
;   DB 098,052,012,240,126,000,000,000
;   DB 030,057,057,096,071,064,064,064 ; T Left foot down
;   DB 064,032,048,015,006,060,000,000
;   DB 120,156,156,006,242,130,130,130
;   DB 130,132,012,240,126,000,000,000
;   DB 030,057,057,096,071,068,068,071 ; R Left foot down
;   DB 068,036,048,015,006,060,000,000
;   DB 120,156,156,006,226,050,050,226
;   DB 066,116,012,240,126,000,000,000
;   DB 030,057,057,096,065,067,070,068 ; A Left foot down
;   DB 071,036,048,015,006,060,000,000
;   DB 120,156,156,006,194,098,050,018
;   DB 242,020,012,240,126,000,000,000
;   DB 000,030,057,032,064,064,064,064 ; Right foot down
;   DB 064,096,048,031,126,000,000,000
;   DB 000,120,156,004,002,002,002,002
;   DB 002,006,012,248,096,060,000,000
;   DB 000,001,001,013,030,063,063,063 ; Apple
;   DB 063,063,031,015,015,006,000,000
;   DB 000,128,000,112,200,228,244,244
;   DB 252,252,248,240,240,096,000,000
;   DB 000,000,001,001,013,030,060,060 ; Half Split apple
;   DB 062,063,062,030,015,007,000,000
;   DB 000,000,128,000,056,100,242,250
;   DB 122,062,126,124,056,048,000,000
;   DB 000,000,000,000,000,050,084,244 ; Fully split apple
;   DB 248,252,124,124,062,015,000,000
;   DB 000,000,000,000,000,008,014,029
;   DB 029,059,062,062,124,120,000,000
;   DB 000,000,000,000,000,000,000,000 ; Squished character from apple
;   DB 000,000,048,126,051,124,000,000
;   DB 000,000,000,000,000,000,000,000
;   DB 000,000,012,126,204,062,000,000
;   DB 000,000,014,021,059,076,055,031 ; Diamond
;   DB 011,005,002,001,000,000,000,000
;   DB 000,000,224,080,184,100,216,240
;   DB 160,064,128,000,000,000,000,000
;   DB 000,000,000,000,000,000,001,003 ; Mr Do Ball
;   DB 003,001,000,000,000,000,000,000
;   DB 000,000,000,000,000,000,128,192
;   DB 192,128,000,000,000,000,000,000
;
;BALL_EXPLOSION_PAT:        ; Ball Explosion
;   db $00,$00,$00,$00,$00,$00,$01,$02,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$04,$02,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$40,$80,$00,$00,$00,$00,$00,$00,$00
;   db $00,$00,$00,$00,$01,$04,$00,$08,$00,$04,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$20,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$08,$00,$00,$10,$00,$00,$08,$01,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$10,$00,$00,$20,$00,$00,$00,$00,$00
;   db $00,$00,$01,$10,$00,$00,$00,$20,$00,$00,$00,$10,$01,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$08,$00,$00,$00,$10,$00,$00,$00,$00,$00,$01,$20,$00,$00,$00,$00,$40,$00,$00,$00,$00,$20,$00,$01,$00,$00,$00,$08,$00,$00,$00,$00,$04,$00,$00,$00,$00,$08,$00,$00,$00

;%%%%%%%%%%%%%%%%%%%%%%%%
; Multicolor Compressed Tileset

include "tilesetscr2.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%
; sound
SUB_C952:
    CALL    PLAY_SONGS
    JP      SOUND_MAN

INITIALIZE_THE_SOUND:
    LD      HL,SOUND_TABLE
    LD      B,9
    JP      SOUND_INIT

PLAY_OPENING_TUNE:
    LD      B,OPENING_TUNE_SND_0A     ; Play first part of opening tune
    CALL    PLAY_IT
    LD      B,OPENING_TUNE_SND_0B     ; Play second part of opening tune
    CALL    PLAY_IT
    LD      A,(SOUND_BANK_01_RAM)
    AND     0C0H
    OR      2
    LD      (SOUND_BANK_01_RAM),A
    LD      A,(SOUND_BANK_02_RAM)
    AND     0C0H
    OR      4
    LD      (SOUND_BANK_02_RAM),A
    RET
PLAY_BACKGROUND_TUNE:
    LD      B,BACKGROUND_TUNE_0A ; Play first part of background tune
    CALL    PLAY_IT
    LD      B,BACKGROUND_TUNE_0B ; Play second part of background tune
    CALL    PLAY_IT
    RET

SUB_C97F:
    LD      A,0FFH
    LD      (SOUND_BANK_03_RAM),A
RET

PLAY_GRAB_CHERRIES_SOUND:
    LD      B,GRAB_CHERRIES_SND
    JP      PLAY_IT

SUB_C98A:
    LD      A,0FFH
    LD      (SOUND_BANK_04_RAM),A
    LD      (SOUND_BANK_05_RAM),A
RET

PLAY_BOUNCING_BALL_SOUND:
    LD      B,BOUNCING_BALL_SND_0A
    CALL    PLAY_IT
    LD      A,(SOUND_BANK_05_RAM)
    CP      0FFH
    RET     NZ
    LD      B,BOUNCING_BALL_SND_0B
    JP      PLAY_IT

PLAY_BALL_STUCK_SOUND_01:
    LD      A,(SOUND_BANK_05_RAM)
    AND     3FH
    CP      7
    JR      NZ,PLAY_BALL_STUCK_SOUND_02
    LD      A,0FFH
    LD      (SOUND_BANK_05_RAM),A
PLAY_BALL_STUCK_SOUND_02:
    LD      B,BALL_STUCK_SND
    JP      PLAY_IT

PLAY_BALL_RETURN_SOUND:
    LD      B,BALL_RETURN_SND
    JP      PLAY_IT

PLAY_APPLE_FALLING_SOUND:
    LD      B,APPLE_FALLING_SND
    JP      PLAY_IT

PLAY_APPLE_BREAKING_SOUND:
    LD      B,APPLE_BREAK_SND_0A
    CALL    PLAY_IT
    LD      A,(SOUND_BANK_05_RAM)
    AND     3FH
    CP      7
    RET     Z
    LD      B,APPLE_BREAK_SND_0B
    JP      PLAY_IT

PLAY_NO_EXTRA_NO_CHOMPERS:
    LD      B,NO_EXTRA_TUNE_0A
    CALL    PLAY_IT
    LD      B,NO_EXTRA_TUNE_0B
    CALL    PLAY_IT
    LD      B,NO_EXTRA_TUNE_0C
;   JP      LOC_D3DE
; LOC_D3DE:
    CALL    PLAY_IT
    LD      A,0FFH
    LD      (SOUND_BANK_01_RAM),A
    LD      (SOUND_BANK_02_RAM),A
RET

PLAY_DESSERT_COLLECT_SOUND:
    LD    B,NO_EXTRA_TUNE_0C
    CALL    PLAY_IT
    LD    B,NO_EXTRA_TUNE_0D
    CALL    PLAY_IT
    LD    B,NO_EXTRA_TUNE_0E
    JP    PLAY_IT

PLAY_DIAMOND_SOUND:
    CALL    INITIALIZE_THE_SOUND
    LD      B,DIAMOND_SND
    JP      PLAY_IT

PLAY_EXTRA_WALKING_TUNE_NO_CHOMPERS:
    LD      B,EXTRA_WALKING_TUNE_0A
    CALL    PLAY_IT
    LD      B,EXTRA_WALKING_TUNE_0B
    JP      PLAY_IT

PLAY_GAME_OVER_TUNE:
    CALL    INITIALIZE_THE_SOUND
    LD      B,GAME_OVER_TUNE_0A
    CALL    PLAY_IT
    LD      B,GAME_OVER_TUNE_0B
    JP      PLAY_IT

PLAY_WIN_EXTRA_DO_TUNE:
    LD      B,WIN_EXTRA_DO_TUNE_0A
    CALL    PLAY_IT
    LD      B,WIN_EXTRA_DO_TUNE_0B
    JP      PLAY_IT

PLAY_VERY_GOOD_TUNE:
    LD      B,VERY_GOOD_TUNE_0A
    CALL    PLAY_IT
    LD      B,VERY_GOOD_TUNE_0B
    CALL    PLAY_IT
    LD    B,VERY_GOOD_TUNE_0C
    JP    PLAY_IT

PLAY_TWINKLE_TWINKLE_TUNE:
  LD    B,TWINKLE_TWINKLE_0A
  CALL  PLAY_IT
  LD    B,TWINKLE_TWINKLE_0B
  CALL  PLAY_IT
  LD    B,TWINKLE_TWINKLE_0C
  JP    PLAY_IT
PLAY_COIN_INSERT_SFX:
  LD    B,SFX_COIN_INSERT_SND
  JP    PLAY_IT

PLAY_END_OF_ROUND_TUNE:
    CALL    INITIALIZE_THE_SOUND
    LD      B,END_OF_ROUND_TUNE_0A
    CALL    PLAY_IT
    LD      B,END_OF_ROUND_TUNE_0B
    JP      PLAY_IT

PLAY_LOSE_LIFE_SOUND:
    CALL    INITIALIZE_THE_SOUND
    LD      B,LOSE_LIFE_TUNE_0A
    CALL    PLAY_IT
    LD      B,LOSE_LIFE_TUNE_0B
    JP      PLAY_IT

SUB_CA24:
    LD      A,0FFH
    LD      (SOUND_BANK_07_RAM),A
    LD      (SOUND_BANK_08_RAM),A
RET

SUB_CA2D:
    LD      A,0FFH
    LD      (SOUND_BANK_08_RAM),A
    LD      (SOUND_BANK_09_RAM),A
RET

PLAY_BLUE_CHOMPERS_SOUND:
    LD      B,BLUE_CHOMPER_SND_0A
    CALL    PLAY_IT
    LD      B,BLUE_CHOMPER_SND_0B
;   JP      LOC_D3EA
; LOC_D3EA:
    CALL    PLAY_IT
    LD      A,0FFH
    LD      (SOUND_BANK_01_RAM),A
    LD      (SOUND_BANK_02_RAM),A
    LD      (SOUND_BANK_07_RAM),A
RET


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
    DW VERY_GOOD_TUNE_P1
    DW SOUND_BANK_01_RAM
    DW VERY_GOOD_TUNE_P2
    DW SOUND_BANK_02_RAM
    DW VERY_GOOD_TUNE_P3
    DW SOUND_BANK_03_RAM
    DW SFX_COIN_INSERT
    DW SOUND_BANK_01_RAM
    DW NO_EXTRA_TUNE_P4
    DW SOUND_BANK_07_RAM
    DW NO_EXTRA_TUNE_P5
    DW SOUND_BANK_06_RAM
    DW TWINKLE_TWINKLE_P1
    DW SOUND_BANK_03_RAM
    DW TWINKLE_TWINKLE_P2
    DW SOUND_BANK_04_RAM
    DW TWINKLE_TWINKLE_P3
    DW SOUND_BANK_05_RAM

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
NO_EXTRA_TUNE_P4:
    DB 065,027,000,002,102,001,065,032,032,002,102,004,064,040,048,006,080
NO_EXTRA_TUNE_P5:
    DB 129,060,000,002,102,016,128,050,032,006,129,101,048,002,102,231,144

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
    DB 064,107,048,022,118,118,064,213,048,011,107,064,160,048,011,080
; GAME_OVER_TUNE_P1:
;   DB 064,$50,096,010,106 ; F
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


GAME_OVER_TUNE_P2:
    DB 182,182,128,064,081,022,128,214,080,007,164,128,214,080,007,164,128,254,080,011,171
    DB 128,064,081,011,171,128,064,081,022,128,214,080,007,164,128,214,080,007,164,128,240
    DB 096,011,171,128,254,096,011,171,128,029,097,011,171,128,087,099,007,164,128,087,099
    DB 007,164,128,087,099,022,128,086,115,011,107,128,128,114,011,144
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

TWINKLE_TWINKLE_P1:
  DB 064,$47,048,013,097
  DB 064,$47,048,013,097

  DB 064,$50,048,013,097
  DB 064,$50,048,013,097

  DB 064,$54,048,013,097
  DB 064,$54,048,013,097

  DB 064,$5F,048,026,098

  DB 064,$47,048,013,097
  DB 064,$47,048,013,097

  DB 064,$50,048,013,097
  DB 064,$50,048,013,097

  DB 064,$54,048,013,097
  DB 064,$54,048,013,097

  DB 064,$5F,048,026,098

  DB 064,$D5,048,013,097
  DB 064,$D5,048,013,097

  DB 064,$8E,048,013,097
  DB 064,$8E,048,013,097

  DB 064,$7F,048,013,097
  DB 064,$7F,048,013,097

  DB 064,$8E,048,026,098

  DB 064,$A0,048,013,097
  DB 064,$A0,048,013,097

  DB 064,$A9,048,013,097
  DB 064,$A9,048,013,097

  DB 064,$BE,048,013,097
  DB 064,$BE,048,013,097

  DB 064,$D5,048,013,097
  DB 064,$D5,048,013,080

TWINKLE_TWINKLE_P2:
  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$28,064,006,161
  DB 128,$2F,064,006,161

  DB 128,$28,064,006,161
  DB 128,$2F,064,006,161

  DB 128,$2A,064,006,161
  DB 128,$28,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$2F,064,006,161
  DB 128,$2A,064,006,161
  DB 128,$2F,064,013,161


  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$28,064,006,161
  DB 128,$2F,064,006,161

  DB 128,$28,064,006,161
  DB 128,$2F,064,006,161

  DB 128,$2A,064,006,161
  DB 128,$28,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$2F,064,006,161
  DB 128,$2A,064,006,161
  DB 128,$2F,064,013,161

  DB 128,$35,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$35,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

  ; A
  DB 128,$19,064,006,161
  ;   B
  DB 128,$16,064,006,161
  ;  C
  DB 128,$14,064,006,161
  ; A
  DB 128,$19,064,006,161

  DB 128,$23,064,006,161
  DB 128,$2A,064,006,161

 ; C
  DB 128,$35,064,013,161
  ; FG
  DB 128,$28,064,006,161
  DB 128,$23,064,006,161
  ; A
  DB 128,$19,064,006,161
  ; FE
  DB 128,$28,064,006,161
  DB 128,$2A,064,006,161
  ; FG
  DB 128,$28,064,006,161
  DB 128,$23,064,006,161

  ; ECE
  DB 128,$2A,064,006,161
  DB 128,$35,064,006,161
  DB 128,$2A,064,006,161
; FDC
  DB 128,$28,064,006,161
  DB 128,$2F,064,006,161
  DB 128,$35,064,006,161

  DB 128,$28,064,006,161
  DB 128,$35,064,006,144

TWINKLE_TWINKLE_P3:
  ; C
  DB 192,$35,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; E
  DB 192,$2A,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; B
  DB 192,$38,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; D
  DB 192,$2F,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; C
  DB 192,$35,048,006,225

  ; G
  DB 192,$23,048,006,225
  ; E
  DB 192,$2A,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; B
  DB 192,$38,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; D
  DB 192,$2F,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; C
  DB 192,$35,048,006,225

  ; G
  DB 192,$23,048,006,225
  ; E
  DB 192,$2A,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; B
  DB 192,$38,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; D
  DB 192,$2F,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; C
  DB 192,$35,048,006,225

  ; G
  DB 192,$23,048,006,225
  ; E
  DB 192,$2A,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; B
  DB 192,$38,048,006,225
  ; G
  DB 192,$23,048,006,225
  ; D
  DB 192,$2F,048,006,225
  ; G
  DB 192,$23,048,006,225

;*****=
  ; C
  DB 192,$AB,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; E
  DB 192,$53,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; C
  DB 192,$AB,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; E
  DB 192,$53,049,006,225
  ; G
  DB 192,$1D,049,006,225

  ; A
  DB 192,$FE,048,006,225
  ; F#
  DB 192,$2E,049,006,225
  ; A
  DB 192,$FE,048,006,225

  ; C
  DB 192,$AB,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; E
  DB 192,$53,049,006,225
  ; G
  DB 192,$1D,049,006,225

  ; B
  DB 192,$C4,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; D
  DB 192,$7C,049,006,225
  ; G
  DB 192,$1D,049,006,225

  ; C
  DB 192,$AB,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; E
  DB 192,$53,049,006,225
  ; G
  DB 192,$1D,049,006,225

  ; B
  DB 192,$C4,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; F
  DB 192,$40,049,006,225
  ; G
  DB 192,$1D,049,006,225

 ; E
  DB 192,$53,049,006,225
  ; G
  DB 192,$1D,049,006,225
  ; C
  DB 192,$AB,049,013,208



NEW_OPENING_TUNE_P1:
    DB 064,143,096,007,099,064,214,096,007,099,064,214,096,007,099,064,214,096,007,099,064,160
    DB 096,007,099,064,226,096,007,099,064,226,096,007,099,064,226,096,007,099,064,143,096,007
    DB 099,064,160,096,007,099,064,170,096,007,099,064,190,096,007,099,064,214,096,030,106
NEW_BACKGROUND_TUNE_P1:
    ; OVER LONG D
    ; F4 10
    DB 128,160,128,007,163
    ; G4 10
    DB 128,142,128,007,163
    ; OVER LONG D
    ; F4 10
    DB 128,160,128,007,163
    ; G4 10
    DB 128,142,128,007,163

    ; D4 (short) 10
    DB 128,160,128,007,163
    ; D4 (complements lower F) 10
    DB 128,190,128,007,163
    ; C (complements lower E) 10
    DB 128,142,128,007,163
    ; D4 (complements lower D) 10
    DB 128,160,128,007,163
    ; C4 (complements lower C) 10
    DB 128,168,160,007,163
    ; E5 (complements lower C) 10
    DB 128,071,128,007,163
    ; G on the B 10
    DB 128,190,128,007,163
    ; F on the A 10
    DB 128,160,128,007,163
    ; E on the G 10
    DB 128,169,128,007,163
    ; D on the F 10
    DB 128,190,128,007,163
    ; C on the E 10
    DB 128,213,128,007,163
    ; B on the D 20
    DB 128,160,128,007,163

        ; E2 33
    ; DB 128,169,128,030,106
    ; E4 10
    DB 128,169,128,010,170
    ; E4 10
    DB 128,169,128,007,163
    ; G4 16
    DB 128,142,128,007,163

    ; D4 10
    DB 128,160,128,007,163
    ; F4 10
    DB 128,190,128,007,163
    ; E4 10
    DB 128,142,128,007,163
    ; D4 10
    DB 128,160,128,007,163
    ; G4 20
    ; DB 128,142,128,010,106
    ; G4 20
    ; DB 128,142,128,010,106
    ; E4 (complements lower G) 10

    ; OVER LONG G
    ; E4 10
    DB 128,169,128,007,163
    ; C4 10
    DB 128,213,128,007,163
    ; OVER LONG G
    ; E4 10
    DB 128,169,128,007,163
    ; C4 10
    DB 128,213,128,007,163

    DB 128,169,128,007,163
    ; F4 (complements lower A) 10
    DB 128,160,128,007,163
    ; C4 (complements lower E) 10
    DB 128,213,128,007,163
    ; D4 (complements lower F) 10
    DB 128,190,128,007,163,152
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
    DB 064,124,097,010,106
    ; Note 13: D3
    DB 064,124,097,010,106

    ; Note 14: D3
    DB 064,124,097,007,099

    ; Note 15: F3
    DB 064,064,097,007,099
    ; Note 16: E3
    DB 064,083,097,007,099
    ; Note 17: D3
    DB 064,124,097,007,099
    ; Note 18: C3
    DB 064,171,097,007,099
    ; Note 19: C4
    DB 064,213,096,007,099
    ; Note 20: B4
    DB 064,226,096,007,099
    ; Note 21: A4
    DB 064,254,096,007,099
    ; Note 22: G3
    DB 064,029,097,007,099
    ; Note 23: F3
    DB 064,064,097,007,099
    ; Note 24: E3
    DB 064,083,097,007,099
    ; Note 25: D3
    DB 064,124,097,007,099
        ; Note 1: C3
    DB 064,171,097,030,106
    ; Note 2: D3
    DB 064,062,097,007,099
    ; Note 3: F3
    DB 064,064,097,007,099
    ; Note 4: E3
    DB 064,083,097,007,099
    ; Note 5: D3
    DB 064,124,097,007,099
    ; Note 6: G3 (longer duration)
    DB 064,029,097,010,106
    ; Note 7: G3 (longer duration)
    DB 064,029,097,010,106
    ; Note 8: G3
    DB 064,029,097,007,099
    ; Note 9: A4
    DB 064,254,096,007,099
    ; Note 10: E3
    DB 064,083,097,007,099
    ; Note 11: F3
    DB 064,064,097,007,099,088

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
    ; Long E x2
    DB 064,169,096,010,106 ;20
    DB 064,169,096,010,106 ;20
    ; Short E
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

    ;long A
    DB 064,127,096,010,106 ;20
    ;long A
    DB 064,127,096,010,106 ;20
    ;short A
    DB 064,127,096,007,099 ;10
    ;--------------------------------
    ;long B
    DB 064,113,096,010,106 ;20

    ;short C
    DB 064,106,096,007,099 ;10

    ; very long E
    DB 064,084,096,030,106 ;30 + 10 pad
    ;++++++++++++++++++++++++++++++++

    ; BEGIN 3 (at end of long E)

    DB 116 ; 20 pad

    ; short f (plays over the C pad)
    DB 064,80,096,007,099 ;10

    ; short E
    DB 064,084,096,007,099 ;10

    ; long D
    DB 064,095,096,020,106 ;30

    ; short A (over end of long f)
    DB 064,127,080,010,106 ;20

    ; E over 20 pad after long f
    DB 064,084,096,007,099 ;10
    ; D over 20 pad after long f
    DB 064,095,096,007,099 ;10

    ; (((((((())))))))

    ; long C
    DB 064,106,096,020,106 ;30

    ; short g
    DB 064,142,064,010,106 ;20

    ; short f#
    DB 064,151,096,007,099 ;10

    ; short g
    DB 064,142,096,007,099 ;10

    ; long A
    DB 064,127,096,010,106 ;20

    ;********************************
    ; long A
    DB 064,127,096,010,106 ;20
    ; short B
    DB 064,113,096,007,099 ;10
    ; long A
    DB 064,127,096,010,106 ;20


    ; short g
    DB 064,142,096,007,099 ;10

    ; very long C
    DB 064,106,096,030,116 ;50
    ; short C
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

    ; A (over second half of first long A)
    DB 128,254,112,007,163 ;10
    ; Short f (first half of second long A)
    DB 128,064,113,007,163 ;10
    ; A (over second half of second long A)
    DB 128,254,112,007,173 ;20
    ;--------------------------------

    ; short A - long pause
    DB 128,254,112,007,173 ;20

    ; short A - short pause
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


    ; short C (over short E)
    DB 128,106,112,007,163 ;10


    ; very long f (over D and A)
    DB 128,064,113,050,180 ;50 + 20 pad


    ; (((((((())))))))

    ; very long E
    DB 128,083,113,050,190 ;50 + 30 pad

    ; very short A
    DB 128,254,112,007,163 ;10

    ;********************************

    ; short f#
    DB 128,046,113,007,163 ;10
    ; very short A
    DB 128,254,112,007,163 ;10
    ; very short E
    DB 128,083,113,007,163 ;10

    ; short g
    DB 128,029,113,007,163 ;10
    ; short f
    DB 128,064,113,007,163 ;10


    ; complementary G
    DB 128,029,113,010,190 ;40

    ; short C
    DB 128,171,113,010,170 ;20
    ; short C
    DB 128,171,113,010,144 ;10

VERY_GOOD_TUNE_P1:
  ; F Sharp
    DB 064,$4B,064,005,098 ;7
    ; G
    DB 064,$47,064,005,098 ;7
    ; E
    DB 064,$54,064,011,099 ;14
    ; E
    DB 064,$54,064,011,099 ;14
    ; E
    DB 064,$54,064,011,099 ;14

    ; F Sharp
    DB 064,$4B,064,005,098 ;7
    ; G
    DB 064,$47,064,005,098 ;7
    ; E
    DB 064,$54,064,011,099 ;14
    ; E
    DB 064,$54,064,011,099 ;14
;--------------------------------

    ; Highest E
    DB 064,$2A,064,011,099 ;14
    ; D
    DB 064,$2F,064,005,098 ;7
    ; C
    DB 064,$35,064,005,098 ;7
    ; B
    DB 064,$38,064,005,098 ;7
    ; A
    DB 064,$3F,064,005,098 ;7

    ; G
    DB 064,$47,064,011,099 ;14
    ; F
    DB 064,$50,064,011,099 ;14
    ; E
    DB 064,$54,064,011,099 ;14
    ; Short F
    DB 064,$50,064,011,099 ;14
    ; G
    DB 064,$47,064,025,099 ;28

;--------------------------------
  ; F Sharp
    DB 064,$4B,064,005,098 ;7
    ; G
    DB 064,$47,064,005,098 ;7
    ; E
    DB 064,$54,064,011,099 ;14
    ; E
    DB 064,$54,064,011,099 ;14
    ; E
    DB 064,$54,064,011,099 ;14

    ; F Sharp
    DB 064,$4B,064,005,098 ;7
    ; G
    DB 064,$47,064,005,098 ;7
    ; E
    DB 064,$54,064,011,099 ;14
    ; E
    DB 064,$54,064,011,098 ;14


    ; Highest E
    DB 064,$2A,064,011,099 ;14
    ; D
    DB 064,$2F,064,005,098 ;7
    ; C
    DB 064,$35,064,005,098 ;7
    ; B
    DB 064,$38,064,005,098 ;7
    ; A
    DB 064,$3F,064,005,098 ;7

    ; G
    DB 064,$47,064,011,099 ;14

    ; B
    DB 064,$38,064,011,099 ; 14
    ; C
    DB 064,$35,064,011,099 ; 14
        ; Highest E
    DB 064,$2A,064,011,099 ;14
        ; C
    DB 064,$35,064,014,080 ; 14

;32
VERY_GOOD_TUNE_P2:
    ; F#
  DB 128,046,081,005,162 ;7
    ; G
    DB 128,029,081,005,162 ;7
    ; E
    DB 128,083,081,011,163 ;14
    ; Low E
    DB 128,166,082,011,163 ;14
    ; C
    DB 128,171,081,011,163 ;14

    ; F#
  DB 128,046,081,005,162 ;7
    ; G
    DB 128,029,081,005,162 ;7
    ; E
    DB 128,083,081,011,163 ;14
    ; Low E
    DB 128,166,082,011,163 ;14

;--------------------------------

    ; C
    DB 128,171,081,011,163 ;14
    ; B
    DB 128,196,081,005,162 ;7
    ; A
    DB 128,252,081,005,162 ;7
    ; G
    DB 128,058,082,005,162 ;7
    ; F
    DB 128,128,082,005,162 ;7
    ; E
    DB 128,166,082,011,163 ;14
    ; D
    DB 128,249,082,011,163 ;14
    ; Short E
    DB 128,166,082,011,163 ;14
    ; Short D
    DB 128,249,082,011,163 ;14
    ; Short E
    DB 128,166,082,011,163 ;14
    ; Short E
    DB 128,166,082,011,163 ;14
;--------------------------------
        ; F#
  DB 128,046,065,005,162 ;7
    ; G
    DB 128,029,065,005,162 ;7
    ; E
    DB 128,083,065,011,163 ;14
    ; Low E
    DB 128,166,066,011,163 ;14
    ; C
    DB 128,171,065,011,163 ;14

    ; F#
  DB 128,046,065,005,162 ;7
    ; G
    DB 128,029,065,005,162 ;7
    ; E
    DB 128,083,065,011,163 ;14
    ; Low E
    DB 128,166,066,011,163 ;14

    ; C
    DB 128,171,065,011,163 ;14
    ; B
    DB 128,196,065,005,162 ;7
    ; A
    DB 128,252,065,005,162 ;7
    ; G
    DB 128,058,066,005,162 ;7
    ; F
    DB 128,128,066,005,162 ;7
    ; E
    DB 128,166,066,011,163 ;14
    ; D
    DB 128,249,066,011,163 ;14
    ; Short E
    DB 128,166,066,011,163 ;14
    ; Short E
    DB 128,166,066,011,163 ;14
    ; E
    DB 128,166,066,014,144 ;14

VERY_GOOD_TUNE_P3:
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14

    ; G
    DB 192,058,146,011,227 ; 14
    ; F
    DB 192,128,146,011,227 ; 14

    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14

    ; G
    DB 192,058,146,011,227 ; 14
    ; F
    DB 192,128,146,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,011,227 ; 14
    DB 192,086,147,014,208 ; 14

SFX_COIN_INSERT:
; AY volume to SN volume: SN_vol = 0xF - AY_vol
; AY period to SN period: SN_period = AY_period / 2 (integer division)
; Pos 000: AY period 0x05F(95) → SN period 95/2=47=0x2F

; Pos 000: SN=0x2F → doubled=0x5E
  DB 0x40,0x5E,0xA0,1

; 001: 0x32→0x64
  DB 0x40,0x64,0x90,2

; 002: 0x23→0x46
  DB 0x40,0x46,0x80,1

; 003: 0x25→0x4A
  DB 0x40,0x4A,0x70,2

; 004: 0x25→0x4A
  DB 0x40,0x4A,0x60,1

; 005: 0x20→0x40
  DB 0x40,0x40,0x60,2

; 006: 0x20→0x40
  DB 0x40,0x40,0x60,1

; 007: 0x23→0x46
  DB 0x40,0x46,0x60,2

; 008: 0x25→0x4A
  DB 0x40,0x4A,0x60,1

; 009: 0x1B→0x36
  DB 0x40,0x36,0x60,2

; 00A: 0x1E→0x3C
  DB 0x40,0x3C,0x60,1

; 00B: 0x1E→0x3C
  DB 0x40,0x3C,0x60,2

; 00C: 0x19→0x32
  DB 0x40,0x32,0x60,1

; 00D: 0x19→0x32
  DB 0x40,0x32,0x70,2

; 00E: 0x1B→0x36
  DB 0x40,0x36,0x80,1

; 00F: 0x1F→0x3E
  DB 0x40,0x3E,0x90,2

; 010: 0x14→0x28
  DB 064,040,0xA0,01
  DB 064,040,0xB0,01
  DB 064,040,0xC0,01

  DB 0x50



; select 1/2 players
ShowPlyrNum:
    CALL MyNMI_off
    LD DE,$1800+11+32*15
    LD HL,Plyr1Slct
    CALL MYPRINT
    LD DE,$1800+11+32*17
    LD HL,Plyr2Slct
    CALL MYPRINT
    JP MyNMI_on

; Proper text

Plyr1Slct:  db "1.PLAYE","R" or 128
Plyr2Slct:  db "2.PLAYER","s" or 128

; select skill 1-4
ShowSkill:
    CALL MyNMI_off
    LD DE,$1800+11+32*13
    LD HL,Skill1
    CALL MYPRINT
    LD DE,$1800+11+32*15
    LD HL,Skill2
    CALL MYPRINT
    LD DE,$1800+11+32*17
    LD HL,Skill3
    CALL MYPRINT
    LD DE,$1800+11+32*19
    LD HL,Skill4
    CALL MYPRINT
    JP MyNMI_on

Skill1:     db "1.EAS","Y" or 128
Skill2:     db "2.ADVANCE","D" or 128
Skill3:     db "3.ARCADE"," " or 128    ; " " needed to remove the S from "PLAYERS"
Skill4:     db "4.PR","O" or 128

; Select  Number of Players and Skill

GET_GAME_OPTIONS:
    CALL    ShowPlyrNum         ; Show 1 or 2 Players
.PlyrNumWait:
    LD      A,(KEYBOARD_P1)
    DEC     A                   ; 0-1   valid range
    CP      2
    JR      C,.SetPlyrNum
    LD      A,(KEYBOARD_P2)
    DEC     A
    CP      2
    JR      NC,.PlyrNumWait
.SetPlyrNum:
    PUSH AF
    CALL PLAY_COIN_INSERT_SFX
    POP  AF
    LD      HL,GAMECONTROL
    RES     0,(HL)
    DEC     A                   ; If A==1 -> SET 2 players
    JR      NZ,.OnePlyr
    SET     0,(HL)
.OnePlyr:

.WaitKeyRelease:
    LD      A,(KEYBOARD_P1)
    CP      15
    JR      NZ,.WaitKeyRelease
    LD      A,(KEYBOARD_P2)
    CP      15
    JR      NZ,.WaitKeyRelease

    CALL    ShowSkill           ; Show Select skill 1-4
.SkillWait:
    LD      A,(KEYBOARD_P1)
    DEC     A                   ; 0-3 valid range
    CP      4
    JR      C,.SetSkill
    LD      A,(KEYBOARD_P2)
    DEC     A
    CP      4
    JR      NC,.SkillWait
.SetSkill:
    PUSH AF
    CALL PLAY_COIN_INSERT_SFX
    POP  AF
    INC     A                   ; The game is expecting 1-4
    LD      (SKILLLEVEL),A
    RET

StrINSERTCOIN:  db "INSERT COIN"," " or 128

cvb_ANIMATEDLOGO:
    CALL MYMODE2                    ; switch to intermission  mode (Disable video, Enable NMI)
    CALL cvb_MYCLS

    LD DE,$0000
    LD HL,cvb_TILESET
    CALL unpack
    LD DE,$1800
    LD HL,cvb_PNT
    CALL unpack

    CALL LOADFONTS              ; LOAD ARCADE FONTS (none cares if it loads lower banks too)

    LD DE,$2000
    LD HL,colorframes_plt
    CALL unpack

    LD  A,$80
    CALL NEWNXTFRM

    CALL MyNMI_off
    LD  HL,StrINSERTCOIN
    LD  DE,$1800+23*32
    CALL MYPRINT
    LD HL,$1B00         ; needed (some times) to remove all sprites
    LD  A,208           ; for hacked Colecovision Bios
    CALL MYWRTVRM
    CALL MyNMI_on

    CALL MYENASCR
    ;
    CALL GET_GAME_OPTIONS
    ;

    LD  A,$80
    CALL ONECYCLE       ; cycle 6 color frames in vram

    LD  B,10
.3: PUSH BC
    LD  A,$86
    CALL ONECYCLE       ; cycle 6 color frames in vram
    POP BC
    DJNZ .3

    CALL    MYDISSCR
    CALL cvb_MYCLS

    LD      HL,CT       ; avoid glitches during screen transition
    LD      DE,256*8
    XOR     A           ; CLEAR CT
    CALL    FILL_VRAM


    LD  HL,SAT              ; remove sprites in the new position of the SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL MyNMI_on

    LD  HL,mode
    RES 7,(HL)                      ; switch to game mode

    RET

ONECYCLE:
    LD   B,6
.1: CALL NEWNXTFRM
    INC A
    DJNZ .1
    RET

NEWNXTFRM:
    PUSH BC
    PUSH AF
    HALT
    HALT
    HALT
    HALT
    LD  B,A
    LD  C,3
    CALL MyNMI_off
    CALL MYWRTVDP
    CALL MyNMI_on
    POP AF
    POP BC
    RET

    ; 12 frames of color tables compressed (64 bytes each)
colorframes_plt:
    db $3b,$0b,$23,$00,$0a,$00,$08,$0b
    db $e4,$00,$bb,$02,$f1,$d7,$ed,$00
    db $58,$3f,$cb,$cb,$fd,$6a,$3f,$3b
    db $03,$3d,$4b,$4b,$f3,$3f,$48,$3b
    db $03,$7b,$7b,$f7,$cd,$3f,$20,$3b
    db $81,$3b,$3b,$f7,$cd,$3f,$20,$3b
    db $81,$6b,$6b,$f7,$cd,$3f,$20,$3b
    db $81,$ab,$ab,$5e,$bb,$48,$bd,$3f
    db $a4,$3b,$81,$63,$ff,$7a,$48,$f6
    db $3f,$91,$3b,$81,$8d,$ff,$48,$eb
    db $da,$3f,$46,$3b,$81,$37,$ff,$48
    db $AF,$76,$3f,$3b,$cd,$ff,$48,$fe
    db $cd,$ff,$48,$ba,$9f,$3f,$ff,$ff
    db $ff,$f8

    ; MAKE SURE TO BE IN INTERMISSION MODE BEFORE CALLING

cvb_EXTRASCREEN:
    CALL MYMODE1                    ; switch to intermission  mode (Disable video, enable NMI)
    CALL cvb_MYCLS

    LD DE,$2000                     ; Mirror mode for colors
    LD HL,cvb_IMAGE_COLOR
    CALL unpack

    LD DE,$0000                     ; Normal mode for patterns
    LD HL,cvb_IMAGE_CHAR
    CALL unpack
    LD DE,$0800
    LD HL,cvb_IMAGE_CHAR
    CALL unpack
    LD DE,$1000
    LD HL,cvb_IMAGE_CHAR
    CALL unpack

    LD DE,$2800
    LD HL,cvb_IMAGE_SPRITES
    CALL unpack                     ; 22 sprites

;   LD      A,1                     ; black tile
;   CALL    cvb_MYCLS.2
;
;   LD HL,cvb_IMAGE_PATTERN
;   LD DE,$1800+5
;   LD BC,24*256+22
;   CALL CPYBLK_MxN

    LD DE,$1800
    LD HL,cvb_IMAGE_PATTERN_plt
    CALL unpack

    LD BC,128
    LD DE,$1B00
    LD HL,cvb_SPRITE_OVERLAY
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on
    JP MYENASCR

cvb_EXTRASCREEN_FRM1:
    LD HL,cvb_IMAGE_PATTERN_FR1
    LD DE,$1800 + 13 + 17*32
    LD BC,5*256+4
    CALL CPYBLK_MxN
    CALL MyNMI_off
    LD A,2+17*8
    LD HL,$1b00     ; SET in place sprite 0
    CALL MYWRTVRM
    JP MyNMI_on


cvb_EXTRASCREEN_FRM2:
    LD HL,cvb_IMAGE_PATTERN_FR2
    LD DE,$1800 + 13 + 17*32
    LD BC,5*256+4
    CALL CPYBLK_MxN
    CALL MyNMI_off
    LD A,$D1
    LD HL,$1b00     ; remove sprite 0
    CALL MYWRTVRM
    JP MyNMI_on

WONDERFULTXT0:  DC "                "
WONDERFULTXT1:  DC "   WONDERFUL !! "
TOTAL_TEXT:     DC "TOTAL "
AVERAGE_TEXT:   DC "AVERAGE "


    ;% place here the other intermission each 10xN levels
WONDERFUL:
    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ; Show the intermission screen
    ;
    LD      BC,1A2H     ; Disable video, enable NMI
    CALL    WRITE_REGISTER

    CALL MYMODE1                    ; switch to intermission  mode (Disable video, enable NMI)

    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM

    CALL cvb_MYCLS

    LD DE,$0000
    LD HL,intermission_char
    CALL unpack
    LD DE,$0800
    LD HL,intermission_char
    CALL unpack
    LD DE,$1000
    LD HL,intermission_char
    CALL unpack

    LD DE,$2000
    LD HL,intermission_color
    CALL unpack

    LD DE,$2800
    LD HL,intermission_sprites
    CALL unpack

    ; Fill bottom half with brick pattern
    LD      HL,$1800 + 32*10 ; Start halfway down screen
    LD      BC,32*14         ; Fill lower 14 rows
    LD      A,105            ; brick pattern for level 10,20,30 etc
    CALL    cvb_MYCLS.0

    CALL    PRINT_WONDERFUL_STATS

    ; ADD terminator in slot 1
    LD      HL,SAT+4
    LD      A,208
    CALL    MyNMI_off
    CALL    MYWRTVRM
    CALL    MyNMI_on

    CALL    MYENASCR

    CALL    INITIALIZE_THE_SOUND
    CALL    PLAY_VERY_GOOD_TUNE

    LD      HL,200H             ; music duration
    XOR     A
    CALL    REQUEST_SIGNAL
    PUSH    AF                      ; wait for music to finish
.1: POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.1
    POP     AF

    CALL    RESET_LEVEL_TIMERS

    CALL    REMOVESPRITES
    CALL    MYDISSCR

    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL cvb_MYCLS

    LD  HL,mode
    RES 7,(HL)                      ; switch to game mode
    CALL    INIT_VRAM
    CALL    RESTORE_PLAYFIELD_COLORS

    CALL    WAIT_NMI

    LD      BC,1C2H             ; Original game state register (Enable video, No NMI)
    CALL    WRITE_REGISTER
RET

PRINT_WONDERFUL_STATS:
    ; Check which player is active
    LD A,(GAMECONTROL)
    bit 1,A
    JR nz,.use_p2

    ; Player 1 is active
    LD A,(CURRENT_LEVEL_P1)
    LD bc,(SCORE_P1_RAM)      ; Use BC instead of HL for initial load
    JR .continue
.use_p2:
    LD A,(CURRENT_LEVEL_P2)
    LD bc,(SCORE_P2_RAM)
.continue:
    ; Save score and level
    PUSH bc                     ; Save score

    ; Print and calculate scores for only the current level
    LD DE,$1800 + 6 + 32*2
    PUSH AF                     ; Save current level and Player (ZF==0 for P1,ZF==1 for P2)
    CALL PRINT_SINGLE_SCORE
    POP AF                      ; Get current level number
    PUSH AF                     ; Save current level number again
    CALL PRINT_SINGLE_TIME
    POP AF
    PUSH AF
    CALL PRINT_ICON

    POP  HL                 ; get level back
    EX (SP),HL              ; Get in HL original score and save level on the satck

;   POP AF                ; get level back
;   POP HL                ; Get in HL original score
;   PUSH AF                 ; save level
    PUSH HL                ; save score

    ; Convert score for display (needs HL)
    CALL CONVERT_TO_DECIMAL

    ; Print total score
    LD DE,$1800 + 6 + 32*4
    LD HL,TOTAL_TEXT
    CALL MYPRINT
    LD DE,$1800 + 16 + 32*4
    LD HL,TEXT_BUFFER
    CALL MYPRINT

    ; Print "AVERAGE" text
    LD DE,$1800 + 6 + 32*6
    LD HL,AVERAGE_TEXT
    CALL MYPRINT

    POP DE   ; get score back
    LD A, 10
    CALL DE_Times_A
    LD D, 0
    LD E, A
    POP AF   ; get level back
    LD C, A
    CALL DEHL_Div_C

    ; DEHL is the result of the division
    ; we can ignore the remainder and the 0s in DE
    ; NB: game scoring makes it impossible to get above 32k average
    ; HL is passed to CONVERT_TO_DECIMAL
    CALL CONVERT_TO_DECIMAL

    ; ADD terminator bit to the ones digit
    LD A,(TEXT_BUFFER+4)     ; Get the ones digit
    or $80                   ; Set the high bit (ADD terminator)
    LD (TEXT_BUFFER+4),A     ; Put it back
 ;   xor A                    ; A = 0
 ;   LD (TEXT_BUFFER+4+1),A   ; Clear zero

 ; Print average score
    LD DE,$1800 + 17 + 32*6
    LD HL,TEXT_BUFFER
    CALL MYPRINT

    ; Print WONDERFUL text
    LD DE,PNT + 8 + 32*(16)
    LD HL,WONDERFULTXT0
    CALL MYPRINT
    LD DE,PNT + 8 + 32*(17)
    LD HL,WONDERFULTXT1
    CALL MYPRINT
    LD DE,PNT + 8 + 32*(18)
    LD HL,WONDERFULTXT0
    CALL MYPRINT
RET

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RESET_LEVEL_TIMERS:
    ; Check which player's timers to reset
    LD      A,(GAMECONTROL)
    BIT     1,A               ; Test if Player 2 is active
    JR      NZ,Reset_p2

Reset_p1:
    LD      HL,P1_LEVEL1_SEC
    JR      Reset_p2.0
Reset_p2:
    LD      HL,P2_LEVEL1_SEC
.0:
    XOR     A                  ; A = 0
    LD      B,6              ; 6 bytes to clear (3 levels * 2 bytes each)
.1:
    LD      (HL),A           ; Clear byte
    INC     HL                ; Move to next byte
    DJNZ    .1
RET

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CURRTIMERINIT:
    ; set the pointer to the current timer

    ; Check which player is active
    LD      A,(GAMECONTROL)
    BIT     1,A
    JR      Z,.setup_p1_timer

.setup_p2_timer:
    LD      A,(CURRENT_LEVEL_P2)
    LD      HL,P2_LEVEL1_SEC
    JR      .check_level_type

.setup_p1_timer:
    LD      A,(CURRENT_LEVEL_P1)
    LD      HL,P1_LEVEL1_SEC

.check_level_type:

    CALL GET_SLOT_OFFSET
    ADD     HL,DE

    LD (ADDCURRTIMER),HL
RET

INTERMISSION:
    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ; Show the intermission screen
    ;
    LD      BC,1A2H     ; Disable video, enable NMI
    CALL    WRITE_REGISTER

    CALL MYMODE1                    ; switch to intermission  mode (Disable video, enable NMI)

    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL cvb_MYCLS

    CALL    cvb_INTERMISSION
    CALL    INITIALIZE_THE_SOUND
    CALL    PLAY_VERY_GOOD_TUNE

    LD      HL,200H             ; music duration
    XOR     A
    CALL    REQUEST_SIGNAL

    PUSH    AF                      ; wait for music to finish
.1:
    CALL    cvb_INTERMISSION_FRM1   ; animate the monsters
    CALL    WAIT8
    CALL    cvb_INTERMISSION_FRM2
    CALL    WAIT8
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.1
    POP     AF

    CALL    RESET_LEVEL_TIMERS

    CALL    REMOVESPRITES
    CALL    MYDISSCR

    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL cvb_MYCLS

    LD      HL,mode
    RES     7,(HL)                      ; switch to game mode
    CALL    INIT_VRAM
    CALL    RESTORE_PLAYFIELD_COLORS

    CALL    WAIT_NMI

    LD      BC,1C2H             ; restore original game state register (No NMI)
    CALL    WRITE_REGISTER
RET


cvb_INTERMISSION:

    CALL    LOADFONTS

    LD DE,$0000
    LD HL,intermission_char
    CALL unpack
    LD DE,$0800
    LD HL,intermission_char
    CALL unpack
    LD DE,$1000
    LD HL,intermission_char
    CALL unpack

    LD DE,$2000
    LD HL,intermission_color
    CALL unpack

    LD DE,$2800
    LD HL,intermission_sprites
    CALL unpack

    ; Print Very Good + Level stats
    CALL PRINT_LEVEL_STATS

    ; ADD terminator in slot 13
    LD HL,SAT+13*4           ; Slot 13 (icons are in slots 10-12)
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL MyNMI_on

    CALL MYENASCR

RET

;----------------------------------------------------------------------
; PRINT_LEVEL_STATS: Shows scores for current and previous two levels
;----------------------------------------------------------------------
PRINT_LEVEL_STATS:
    ; Print "VERY GOOD !!"
    LD DE,$1800 + 12 + 32*12
    LD HL,VERYGOOD
    CALL MYPRINT

    ; Check which player is active
    LD A,(GAMECONTROL)
    bit 1,A                   ; Test if Player 2 is active
    JR nz,.use_p2

    ; Player 1 is active
    LD A,(CURRENT_LEVEL_P1)
    JR .cont
.use_p2:
    LD A,(CURRENT_LEVEL_P2)
.cont:
    ; A now contains the correct current level

    ; Print and calculate scores for all three levels
    ; First level (Current - 2)
    LD DE,$1800 + 3 + 32*2      ; First line position
    SUB 2                       ; Get first level number
    PUSH AF                     ; Save current level and Player (ZF==0 for P1,ZF==1 for P2)
    CALL PRINT_SINGLE_SCORE
    POP AF
    PUSH AF
    CALL PRINT_SINGLE_TIME
    POP AF
    PUSH AF
    CALL PRINT_ICON
    POP AF

    ; Second level (Current - 1)
    LD DE,$1800 + 3 + 32*5   ; Next line down
    INC A
    PUSH AF
    CALL PRINT_SINGLE_SCORE
    POP AF
    PUSH AF
    CALL PRINT_SINGLE_TIME
    POP AF                     ; Get current level
    PUSH AF
    CALL PRINT_ICON
    POP AF

    ; Third level (Current)
    LD DE,$1800 + 3 + 32*8   ; Next line down
    INC A
    PUSH AF
    CALL PRINT_SINGLE_SCORE
    POP AF
    PUSH AF
    CALL PRINT_SINGLE_TIME
    POP AF
    CALL PRINT_ICON
RET

;----------------------------------------------------------------------
; GET_SLOT_OFFSET: Calculates the correct slot offset for level data
; Input: A = level number
; Output: A = offset (0,2,or 4),DE = offset as 16-bit value
; Preserves: BC,HL
;----------------------------------------------------------------------
GET_SLOT_OFFSET:
    PUSH    bc                  ; Save BC

    ; First check if it's exactly level 10,20,30,etc
    LD      B,10
    CALL    MOD_B               ; A = level % 10
    or      A                   ; Check if remainder is 0
    JR nz,.normalize

    ; It's level 10/20/30
    xor     A                   ; Use first slot
    LD      E,A
    LD      D,A
    POP     bc
    RET

.normalize:
    ; Now A is 1-9,do MOD_3
    dec     A                   ; Convert to 0-8
    LD      B,3
    CALL    MOD_B               ; Get mod 3 (0,1,2)
    ADD     A,A                 ; Multiply by 2 for offset
    LD      E,A
    LD      D,0
    POP     bc
RET

;----------------------------------------------------------------------
; PRINT_ICON: Prints completion icon for the level
; Input: A = level number,DE = screen position
; Uses: GAMECONTROL to determine active player
;
;----------------------------------------------------------------------
PRINT_ICON:
    LD      C, A        ; Save level in C

    LD      HL,-32+5            ; Move one line up and 5 spaces to right
    ADD     HL,DE
    PUSH    HL                  ; Save screen position

    CALL    GET_SLOT_OFFSET
    SRL     E                   ; Divide offset by 2 for single-byte slots,D==0 here

    ; Get completion type for this level
    LD      A,(GAMECONTROL)
    BIT     1,A               ; Test if Player 2 is active
    LD      HL,P1_LEVEL_FINISH_BASE
    JR      Z,.p1
    LD      HL,P2_LEVEL_FINISH_BASE
.p1:

    ADD     HL,DE              ; Point to completion type byte

    ; Load completion type and select correct icon
    LD      A,(HL)             ; Get icon type (1-4)
    LD      B, A                ; Save icon type in B
    DEC     A                   ; Convert 1-4 to 0-3
    ADD     A,A                ; Multiply by 2 for table lookup
    LD      HL,ICON_TABLE
    LD      E,A             ; D==0 here
    ADD     HL,DE
    LD      A,(HL)             ; Get low byte of icon address
    INC     HL
    LD      H,(HL)             ; Get high byte of icon address
    LD      L,A                ; HL now points to correct icon

    PUSH    HL                ; Save icon address [STACK: icon_addr, level, screen_pos]

    ; Check completion type for sprite
    DEC     B                ;  cherry  B==1
    JR      NZ, .try_monster

    LD      HL, CHERRY_Y_POS
    LD      B,80
    CALL    PRINT_ICON_SPRITE
    JR      .finish_sprite

.try_monster:
    DEC     B                 ; monster  B==2
    JR      NZ, .print_blank

    LD      HL, MONSTER_Y_POS
    LD      B,84
    CALL    PRINT_ICON_SPRITE
    JR      .finish_sprite

    ; any other icon
.print_blank:
    CALL    PRINT_BLANK_SPRITE

.finish_sprite:
    POP     HL                  ; Restore icon address [STACK: level, screen_pos]
    POP     DE                  ; Restore screen position

    ; Copy the icon to screen
    LD      BC,3*256+2         ; B = 3 (height),C = 2 (width)
    CALL    CPYBLK_MxN

RET

; Table of icon addresses
ICON_TABLE:
    DW CHERRY_ICON              ; Type 1
    DW MONSTER_ICON             ; Type 2
    DW DIAMOND_ICON             ; Type 3
    DW EXTRA_ICON               ; Type 4


;----------------------------------------------------------------------
; PRINT_BLANK_SPRITE: Prints blank sprite for given level
; Input: C = level number (1-3)
;----------------------------------------------------------------------
PRINT_BLANK_SPRITE:

    LD    A, $D1              ; put sprite offscreen
    LD    (SAT_BUFFER), A     ; Y position

    ; Calculate SAT position (level 1 = 40, level 2 = 44, level 3 = 48)

    LD    A, C
    CALL  GET_SLOT_OFFSET

    JP    PRINT_ICON_SPRITE.CpySAT


;----------------------------------------------------------------------
; PRINT_CHERRY_SPRITE: Prints cherry sprite for given level
; Input: C = level number (>=1), HL = Y TABLE, B = Sprite pattern
;----------------------------------------------------------------------
PRINT_ICON_SPRITE:
    LD      A, C                ; Get level number
    CALL    GET_SLOT_OFFSET     ; bc and HL preserved
    PUSH    AF                  ; save 2*slot number
    SRL A                       ; A is now 0, 1 or 2

    LD      E, A
;   LD      D, 0                ; D is 0 from get_slot_offset
    ADD     HL, DE
    LD      A, (HL)             ; Set up sprite in buffer
    LD      (SAT_BUFFER), A     ; Y position

    ; Check if level is A multiple of 10 (if yes, print sprite using wonderful positioning)
    PUSH    BC
    LD      A,C
    LD      B,10
    CALL    MOD_B               ; ZF Set by MOD_B, check if remainder is 0
    POP     BC
    JR      Z, .WONDERFUL       ; If multiple of 10, use wonderful positioning

    LD      A, 200              ; X position (always 200)
    LD      (SAT_BUFFER+1), A

    ; Calculate SAT position (level 1 = 40, level 2 = 44, level 3 = 48)

    POP   AF            ; Get 2*slot number back

.CpySAT:
    ADD   A, A          ; Multiply by 4
    LD    H, 0          ; Copy to SAT
    LD    L, A
    LD    DE, $1B00 + 4*10
    ADD   HL, DE        ; HL = $1B00 + offset
    EX    DE, HL        ; Put result in DE
    JR  .PRINT

.WONDERFUL:
    POP     AF                  ; clear the stack
    LD      A, 224              ; X position (always 224 for "WONDERFUL")
    LD      (SAT_BUFFER+1), A
    LD      DE, $1B00

.PRINT:
    LD      A, B                ; Cherry pattern = 80, Monster Pattern = 84
    LD      (SAT_BUFFER+2), A
    LD      A, 1                ; Color
    LD      (SAT_BUFFER+3), A
    LD    HL, SAT_BUFFER
    LD    BC, 4
    CALL  MyNMI_off
    CALL  MYLDIRVM
    CALL  MyNMI_on
RET


; Y position tables
CHERRY_Y_POS:
    DB 5, 29, 53           ; Y positions for levels 1-3
MONSTER_Y_POS:
    DB 4, 28, 52           ; Y positions for levels 1-3

;----------------------------------------------------------------------
; PRINT_SINGLE_TIME: Prints one level's completion time
; Input: A = level number,DE = screen position
;----------------------------------------------------------------------
PRINT_SINGLE_TIME:
    PUSH DE                  ; Save screen position
    PUSH AF                  ; Save level number

    ; Check which player is active
    LD A,(GAMECONTROL)
    bit 1,A                   ; Test if Player 2 is active
    LD HL,P1_LEVEL1_SEC         ; Default to Player 1 base
    JR z,.got_base              ; ZF==0 for P1,ZF==1 for P2
    LD HL,P2_LEVEL1_SEC         ; Otherwise use Player 2 base
.got_base:

    ; Calculate which level's time to show
    POP AF                      ; Get level number back
    CALL    GET_SLOT_OFFSET     ; Get the correct offset
    ADD HL,DE                   ; HL now points to seconds
    PUSH HL

    ; Get minutes first (it's the next byte)
    INC HL                      ; Point to minutes
    LD A,(HL)                   ; Get minutes
    ADD A,"0"                   ; Convert to ASCII
    LD (TEXT_BUFFER),A          ; Store single minute digit
    LD A,"'"                    ; ADD space
    LD (TEXT_BUFFER+1),A

    ; Now get seconds
    POP HL                      ; Restore pointer to seconds
    LD l,(HL)                   ; Get seconds
    LD h,0                      ; Put seconds in HL

    ; Convert seconds to decimal
    CALL DIV_HLby10

    ; Store seconds (always show both digits)
    LD A,C
    ADD A,"0"                   ; Convert tens to ASCII
    LD (TEXT_BUFFER+2),A
    LD A,l
    ADD A,"0" + $80            ; Convert ones to ASCII and ADD terminator
    LD (TEXT_BUFFER+3),A
     ; Print time value
    POP HL                    ; Restore screen position in HL
    LD DE,7                  ; Move 7 positions right
    ADD HL,DE
    EX DE,HL
    LD HL,TEXT_BUFFER
    CALL MYPRINT
RET

;----------------------------------------------------------------------
; PRINT_SINGLE_SCORE: Prints one level's score
; Input: A = level number,DE = screen position
;----------------------------------------------------------------------
PRINT_SINGLE_SCORE:
    PUSH AF                     ; Save level number

    ; Print "SCENE "
    PUSH DE                     ; Save screen position
    LD HL,SCENE_TEXT
    CALL MYPRINT
    POP DE                      ; Restore screen position

    ; Print level number
    POP AF                      ; Restore level number
    PUSH AF                     ; Save it again

    ; Convert level to decimal
    LD h,0                    ; Clear H
    LD l,A                    ; Put level in L (now HL = level)
    PUSH DE                    ; Save screen position

    ; Get tens and ones only
    CALL DIV_HLby10

    ; Store tens digit
    LD A,C
    or A                       ; Test if zero
    JR z,.skip_tens             ; If zero,skip tens

    ADD A,"0"                   ; Convert to ASCII
    LD (TEXT_BUFFER),A
    LD A,l                      ; Store ones digit
    ADD A,"0" + $80         ; ADD terminator
    LD (TEXT_BUFFER+1),A

    JR .print_level

.skip_tens:

    LD A,l                      ; Just store ones for single digit
    ADD A,"0" + $80
    LD (TEXT_BUFFER),A

.print_level:
    POP HL                      ; Restore VRAM Address
    ; Print level number
    PUSH  HL                    ; screen position in HL
    LD DE,6                     ; Move 6 positions right
    ADD HL,DE
    EX DE,HL                    ; Put back in DE
    LD HL,TEXT_BUFFER
    CALL MYPRINT
    POP DE                      ; Restore screen position

    ; Calculate which score to show based on level
    POP AF                      ; Restore level number
    PUSH DE                     ; Save screen position

    PUSH    AF
    ; Check which player is active
    LD A,(GAMECONTROL)
    bit 1,A                     ; Test if Player 2 is active
    LD HL,P1_LEVEL1_SCORE       ; Default to Player 1 base
    JR z,.got_base              ; ZF==0 for P1,ZF==1 for P2
    LD HL,P2_LEVEL1_SCORE       ; Otherwise use Player 2 base
.got_base:

    ; Calculate score address
    POP     AF                  ; Get level number back
    CALL    GET_SLOT_OFFSET     ; Get the correct offset
    ADD HL,DE                   ; HL now points to correct score

    ; Load score
    LD E,(HL)
    INC HL
    LD D,(HL)
    EX DE,HL                  ; HL now contains score value

    ; Convert to decimal digits
    CALL CONVERT_TO_DECIMAL

    ; Print score
    POP HL                      ; Restore screen position in HL
    LD DE,10                    ; Move 10 positions right
    ADD HL,DE
    EX DE,HL                    ; Put  in DE
    LD HL,TEXT_BUFFER
    CALL MYPRINT
RET

;----------------------------------------------------------------------
; CONVERT_TO_DECIMAL: Converts HL to decimal ASCII in TEXT_BUFFER
;----------------------------------------------------------------------
CONVERT_TO_DECIMAL:
    XOR A
    LD IX,TEXT_BUFFER   ;where we will store the result
    JP num2str16
    
;    ; First get ten thousands
;    LD DE,10000
;    CALL    DIV_HLbyDE
;
;    ; Store ten thousands digit
;    LD A,C
;    or A                       ; Test if zero
;    JR nz,.not_zero1         ; If not zero,show digit
;    LD A," "                 ; If zero,show space
;    JR .store1
;.not_zero1:
;    ADD A,"0"                ; Convert to ASCII
;.store1:
;    LD (TEXT_BUFFER),A
;
;    ; Now get thousands
;
;    LD DE,1000
;    CALL    DIV_HLbyDE
;
;    ; Store thousands digit
;    LD A,(TEXT_BUFFER)       ; Check if we had ten thousands
;    CP " "                    ; Was it A space?
;    LD A,C                   ; digit value
;    JR nz,.not_zero2         ; If we had ten thousands,always show this digit
;    or A                      ; Test if zero
;    JR nz,.not_zero2         ; If not zero,show digit
;    LD A," "                 ; If zero,show space
;    JR .store2
;.not_zero2:
;    ADD A,"0"               ; Convert to ASCII
;.store2:
;    LD (TEXT_BUFFER+1),A
;
;    ; Now get hundreds
;    LD DE,100
;    CALL    DIV_HLbyDE
;
;    ; Store hundreds digit
;    LD A,(TEXT_BUFFER+1)       ; Check if we had thousands
;    CP " "                      ; Was it A space?
;    LD A,C                      ; digit value
;    JR nz,.not_zero3            ; If we had thousands,always show this digit
;    or A                        ; Test if zero
;    JR nz,.not_zero3            ; If not zero,show digit
;    LD A," "                    ; If zero,show space
;    JR .store3
;.not_zero3:
;    ADD A,"0"               ; Convert to ASCII
;.store3:
;    LD (TEXT_BUFFER+2),A
;
;    ; Now get tens
;    LD DE,10
;    CALL    DIV_HLbyDE
;
;    ; Store tens digit
;    LD A,(TEXT_BUFFER+2)        ; Check if we had hundreds
;    CP " "                      ; Was it A space?
;    LD A,C                      ; Restore digit value
;    JR nz,.not_zero4            ; If we had hundreds,always show this digit
;    or A                        ; Test if zero
;    JR nz,.not_zero4            ; If not zero,show digit
;    LD A," "                    ; If zero,show space
;    JR .store4
;.not_zero4:
;    ADD A,"0"               ; Convert to ASCII
;.store4:
;    LD (TEXT_BUFFER+3),A
;
;    ; Ones are what's left in HL (always show)
;    LD A,l
;    ADD A,"0"
;    LD (TEXT_BUFFER+4),A
;
;    ; ADD literal "0" with terminator
;    LD A,"0" + $80
;    LD (TEXT_BUFFER+5),A
;
;RET


;#######################
;#NUM2STR
;# Convert number in AHL to A string
;# input: ahl = number to display,  IX == address of A RAM buffer for the output string
;# output: converted string without heading zeros, terminated by "0" at the address is passed in IX
;#######################
num2str24:
    PUSH IX
;-10,000,000 == $FF676980
    LD C,$67
    LD DE,$6980
    CALL b2d         ;count how many 10,000,000s there are
;-1,000,000  == $FF0BDC0
    LD C,$F0
    LD DE,$BDC0
    CALL b2d
;-100,000    == $FFFE7960
    LD C,$FE
    LD DE,$7960
    CALL b2d
    JR num2str16.1

num2str16:
    PUSH IX
.1:
;-10,000     == $FFFFD8F0
    LD C,$FF
    LD DE,-10000
    CALL b2d
;-1,000      == $FFFFFC18
    LD DE,-1000
    CALL b2d
;-100        == $FFFFFF9C
    LD DE,-100
    CALL b2d
;-10         == $FFFFFFF6
    LD E,-10
    CALL b2d
;-1          == $FFFFFFFF
    LD E,-1
    CALL b2d

    LD (IX+0),"0"+$80           ;put A fake "0" with string terminator
    
    ; remove heading zeros  
                                ;where the string is stored
    POP HL 
.0: 
    LD A,(HL)
    CP '0'                      ;if it's A 0, replace it by ' '
    RET nz
    LD (HL),' '
    INC HL
    JR .0                       ;repeat until we find A non-zero number

;#######################
;#B2D
;# Convert the units of A 24-bit binary
;#   number in AHL into decimal
;# input: ahl = number to display
;#        cde = negative value of units to check (if you
;#            want to check 10s, cde should equal -10)
;#        IX  = string pointer to store the unit
;#######################
b2d:
    LD B,-1         ;if there is no carry the first run through, # = 0
.0:
    INC B      ;each iteration increase accumulator by 1
    ADD HL,DE
    ADC A,C
    JR C,.0
    SBC HL,DE      ;225 - 100 = 125 - 100 = 25 - 100 = -75. This adds 100 again so we can check the next digits.
    SBC A,C
    EX AF,AF'
    LD  A,"0"
    ADD  A,B
    LD (IX),A
    EX AF,AF'
    INC IX
    RET

;----------------------------------------------------------------------
; Data
;----------------------------------------------------------------------
VERYGOOD:    DC "VERY GOOD !!"          ; using DC the last character has bit 7 set
SCENE_TEXT:  DC "SCENE "


cvb_INTERMISSION_FRM1:
    LD BC,4*10
    LD DE,$1B00
    LD HL,cvb_SP1
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on

    LD BC,5*256+14
    LD DE,$1800+10+17*32
    LD HL,cvb_FR1
    CALL CPYBLK_MxN
    RET

cvb_INTERMISSION_FRM2:
    LD BC,4*10
    LD DE,$1B00
    LD HL,cvb_SP2
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on

;   LD BC,5*256+14
    LD BC,2*256+14
    LD DE,$1800+10+17*32+3*32
    LD HL,cvb_FR2
    CALL CPYBLK_MxN
    RET

EXTRA_ICON:
    DB $3c,$3d     ; Top row of extra icon
    DB $3f,$40     ; Middle row of extra icon
    DB $43,$44     ; Bottom row of extra icon

CHERRY_ICON:
    DB $00,$3e     ; Top row of cherry icon
    DB $41,$42     ; Middle row of cherry icon
    DB $45,$46     ; Bottom row of cherry icon

MONSTER_ICON:
    DB $49,$4a     ; Top row of monster icon
    DB $4d,$4e     ; Middle row of monster icon
    DB $50,$51     ; Bottom row of monster icon

DIAMOND_ICON:
    DB $47,$48     ; Top row of diamond icon
    DB $4b,$4c     ; Middle row of diamond icon
    DB $4f,$00     ; Bottom row of diamond icon


    ; Start tile = 0. Total_tiles = 82
intermission_char:
    DB $3f,$00,$03,$00,$03,$30,$78,$78
    DB $30,$00,$07,$ff,$06,$66,$60,$7f
    DB $06,$00,$ef,$00,$c0,$c0,$c2,$18
    DB $ff,$ff,$68,$1f,$1b,$80,$3c,$c0
    DB $80,$24,$00,$f9,$ef,$06,$0f,$f9
    DB $f9,$03,$e0,$04,$f0,$7f,$f8,$f0
    DB $e0,$00,$a0,$20,$80,$20,$04,$70
    DB $30,$18,$38,$70,$38,$1d,$07,$0f
    DB $1f,$74,$3f,$41,$00,$19,$00,$04
    DB $0e,$3c,$60,$bf,$3f,$7f,$98,$70
    DB $26,$3d,$e0,$f8,$fc,$71,$fc,$1f
    DB $01,$03,$04,$21,$03,$f7,$cf,$1f
    DB $17,$7f,$1c,$ff,$fc,$ff,$00,$3e
    DB $62,$f0,$5b,$e0,$4d,$00,$f0,$f8
    DB $0c,$0e,$0f,$0f,$07,$03,$82,$23
    DB $f8,$78,$38,$9f,$7a,$08,$7f,$07
    DB $7f,$c0,$26,$0c,$20,$00,$71,$21
    DB $30,$e0,$e3,$c3,$02,$c6,$3b,$f7
    DB $10,$33,$8d,$00,$03,$ff,$80,$00
    DB $c7,$03,$03,$01,$01,$ff,$9c,$02
    DB $fe,$3f,$60,$03,$ff,$e0,$1f,$c1
    DB $83,$02,$0a,$1d,$f1,$01,$00,$2a
    DB $58,$f9,$50,$54,$ff,$01,$7e,$ff
    DB $cf,$cf,$78,$7c,$7c,$4b,$7c,$00
    DB $f8,$16,$88,$9d,$00,$40,$e0,$04
    DB $40,$0c,$0c,$ff,$c0,$00,$70,$11
    DB $1c,$fc,$60,$26,$60,$cf,$5a,$29
    DB $74,$16,$b4,$60,$3c,$1e,$1f,$5e
    DB $64,$ef,$47,$ae,$64,$51,$28,$80
    DB $12,$80,$fe,$fe,$40,$e1,$55,$b0
    DB $5d,$41,$f9,$ff,$21,$3c,$7c,$56
    DB $87,$cf,$1c,$d0,$2c,$b1,$81,$10
    DB $e0,$c0,$f0,$dd,$fe,$a9,$27,$6e
    DB $be,$05,$08,$3e,$1f,$07,$01,$45
    DB $63,$16,$00,$e0,$44,$b3,$f0,$fc
    DB $08,$1f,$f3,$f1,$07,$a9,$81,$09
    DB $cf,$c7,$c7,$c3,$40,$81,$64,$be
    DB $bc,$18,$10,$89,$5f,$fe,$be,$ba
    DB $78,$21,$55,$b8,$56,$7f,$38,$7c
    DB $4a,$fe,$1c,$0f,$0a,$66,$a8,$6c
    DB $51,$00,$fd,$fc,$19,$6c,$60,$60
    DB $17,$81,$b6,$7f,$e0,$8f,$ee,$DE
    DB $7f,$0c,$c6,$1e,$72,$91,$76,$f6
    DB $74,$7f,$78,$26,$fb,$18,$18,$b2
    DB $47,$ff,$18,$94,$bb,$1f,$82,$40
    DB $86,$02,$fc,$8c,$ce,$24,$13,$0e
    DB $1e,$39,$39,$60,$07,$0f,$78,$9c
    DB $9c,$06,$20,$ed,$10,$46,$43,$40
    DB $00,$41,$43,$26,$30,$0f,$32,$62
    DB $c2,$07,$82,$62,$34,$0c,$f0,$10
    DB $6a,$0e,$02,$38,$28,$48,$88,$12
    DB $10,$38,$08,$b4,$06,$6c,$3c,$28
    DB $7e,$f1,$30,$0e,$e3,$07,$38,$cf
    DB $07,$c6,$16,$e0,$c6,$06,$1f,$30
    DB $c0,$07,$f0,$1f,$15,$3b,$4c,$00
    DB $37,$1e,$0b,$05,$02,$50,$b8,$64
    DB $02,$d8,$f0,$a0,$40,$80,$e1,$00
    DB $06,$30,$08,$1d,$3f,$7e,$24,$87
    DB $0f,$20,$b9,$5e,$6c,$1e,$38,$3f
    DB $3e,$36,$40,$f8,$07,$ff,$ff,$ff
    DB $ff,$c0

intermission_color:
    DB $3f,$f1,$03,$00,$81,$c8,$c8,$c1
    DB $c1,$96,$07,$f8,$00,$55,$03,$07
    DB $00,$07,$6c,$14,$1b,$81,$78,$c1
    DB $25,$fc,$b8,$1c,$28,$fc,$fc,$b6
    DB $2c,$00,$6d,$81,$1f,$f3,$06,$81
    DB $61,$06,$b8,$f8,$21,$2b,$00,$82
    DB $00,$07,$cf,$16,$a7,$1f,$48,$c8
    DB $7c,$00,$3d,$fc,$be,$14,$09,$78
    DB $fc,$60,$fc,$aa,$02,$00,$25,$60
    DB $ce,$09,$8a,$3c,$9d,$3e,$00,$7d
    DB $f8,$07,$d9,$00,$05,$f3,$08,$81
    DB $33,$54,$16,$2e,$35,$39,$00,$eb
    DB $4b,$46,$eb,$68,$00,$e7,$3f,$fc
    DB $99,$37,$19,$a6,$5a,$7b,$4f,$6c
    DB $60,$00,$82,$eb,$56,$28,$6e,$67
    DB $10,$ce,$48,$bd,$2e,$51,$53,$AF
    DB $5f,$67,$3e,$00,$98,$78,$d3,$ad
    DB $0c,$00,$1d,$b8,$1e,$97,$58,$c9
    DB $07,$84,$c6,$8a,$09,$c7,$8c,$4f
    DB $09,$19,$06,$21,$25,$a7,$17,$6c
    DB $55,$f7,$6c,$80,$e7,$46,$da,$52
    DB $86,$97,$5f,$5b,$17,$1e,$bf,$7d
    DB $00,$1f,$b1,$dd,$b6,$27,$98,$0f
    DB $86,$7f,$33,$47,$a1,$00,$7b,$07
    DB $0f,$00,$21,$a1,$ce,$00,$13,$34
    DB $81,$f9,$94,$34,$07,$fb,$29,$e7
    DB $30,$61,$e7,$07,$e3,$00,$71,$c6
    DB $07,$f8,$a2,$07,$b1,$01,$94,$3c
    DB $71,$03,$02,$71,$AF,$06,$03,$1f
    DB $ce,$9d,$cf,$63,$df,$f3,$07,$ff
    DB $ff,$ff,$ff

intermission_sprites:
    DB $26,$c8,$86,$00,$b0,$00,$f8,$f0
    DB $f0,$e0,$06,$c0,$e0,$e0,$f0,$80
    DB $0b,$f8,$00,$1c,$0c,$04,$06,$38
    DB $70,$78,$11,$07,$0c,$00,$1c,$38
    DB $30,$38,$bd,$fd,$01,$72,$d9,$28
    DB $80,$a1,$26,$80,$80,$6f,$07,$03
    DB $00,$72,$ff,$f0,$30,$06,$59,$0e
    DB $3e,$1f,$02,$02,$01,$5c,$0c,$2c
    DB $2b,$f0,$8f,$58,$c0,$00,$c0,$00
    DB $10,$00,$60,$00,$7c,$be,$0c,$7c
    DB $f8,$08,$e0,$00,$2b,$98,$08,$66
    DB $1a,$f2,$2c,$3d,$f5,$9c,$00,$80
    DB $03,$77,$8d,$ab,$d0,$1c,$78,$f8
    DB $c1,$04,$3c,$7c,$fc,$ec,$15,$01
    DB $7b,$02,$71,$0f,$ff,$ee,$0f,$00
    DB $83,$00,$c3,$ed,$12,$55,$66,$bf
    DB $c2,$07,$0c,$00,$17,$34,$b0,$03
    DB $77,$0f,$f2,$2d,$7b,$29,$00,$13
    DB $3b,$da,$5a,$8c,$0b,$8c,$42,$ce
    DB $03,$76,$DE,$7b,$ff,$2e,$bf,$c0
    DB $73,$55,$40,$00,$05,$56,$e8,$18
    DB $1f,$b7,$0f,$d1,$bf,$f7,$3e,$7c
    DB $f6,$bf,$9d,$f1,$e3,$85,$1a,$00
    DB $e1,$c1,$0f,$07,$03,$c3,$c3,$1f
    DB $ab,$ff,$ff,$ff,$f8


cvb_SP1:
    DB 64+41+32,80,0,1
    DB 64+41+32,97,4,15
    DB 64+46+32,92,8,8
    DB 64+48+32,160,12,1
    DB 64+57+32,88,16,8
    DB 64+42+32,88,20,12
    DB 64+62+32,95,24,15
    DB 64+56+32,161,28,8
    DB 64+58+32,112,32,1
    DB 64+60+32,80,36,1

cvb_FR1:
    DB $01,$02,$03,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    DB $05,$06,$07,$08,$09,$0a,$0b,$0c,$00,$00,$0d,$0e,$0f,$10
    DB $11,$12,$13,$14,$15,$16,$17,$18,$00,$00,$19,$1a,$1b,$1c

    DB $1d,$1e,$1f,$20,$21,$22,$23,$24,$00,$00,$25,$26,$27,$28
    DB $29,$2a,$2b,$00,$2c,$2d,$2e,$2f,$00,$00,$30,$31,$32,$33

cvb_SP2:
    DB 105+32,80,40,1
    DB 105+32,97,44,15
    DB 110+32,92,48,8
    DB 112+32,160,52,1
    DB 121+32,85,56,8
    DB 119+32,81,60,12
    DB 126+32,95,64,15
    DB 124+32,166,68,12
    DB 122+32,112,72,1
    DB 122+32,176,76,8


;cvb_FR2:
;   DB $01,$02,$03,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;   DB $05,$06,$07,$08,$09,$0a,$0b,$0c,$00,$00,$0d,$0e,$0f,$10
;   DB $11,$12,$13,$14,$15,$16,$17,$18,$00,$00,$19,$1a,$1b,$1c
cvb_FR2:
    DB $34,$1e,$1f,$20,$21,$22,$23,$24,$00,$00,$35,$26,$36,$37
    DB $38,$2a,$2b,$00,$2c,$2d,$2e,$2f,$00,$00,$39,$3a,$3b,$00


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CONGRATULATION:
    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ; Show the congratulation screen
    ;
    LD      BC,1A2H     ; Disable video, enable NMI
    CALL    WRITE_REGISTER

    CALL MYMODE1                    ; switch to intermission  mode (Disable video, enable NMI)
    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM

    CALL cvb_MYCLS

    CALL    cvb_CONGRATULATION      ; switch to intermission  mode
    CALL    INITIALIZE_THE_SOUND
    CALL    PLAY_TWINKLE_TWINKLE_TUNE

    LD      HL,200H             ; music duration
    XOR     A
    CALL    REQUEST_SIGNAL

    PUSH    AF                      ; wait for music to finish
.1:
    CALL    cvb_CONGRATULATION_FRM0 ; animate the diamond
    CALL    WAIT8
    CALL    cvb_CONGRATULATION_FRM1
    CALL    WAIT8
    CALL    cvb_CONGRATULATION_FRM2
    CALL    WAIT8
    POP     AF
    PUSH    AF
    CALL    TEST_SIGNAL
    JR      Z,.1
    POP     AF

    CALL    REMOVESPRITES
    CALL    MYDISSCR

    LD HL,SAT
    LD  A,208
    CALL MyNMI_off
    CALL MYWRTVRM
    CALL cvb_MYCLS

    LD  HL,mode
    RES 7,(HL)                      ; switch to game mode

    CALL    INIT_VRAM
    CALL    RESTORE_PLAYFIELD_COLORS

    CALL    WAIT_NMI

    LD      BC,1E2H      ; Original game state register
    CALL    WRITE_REGISTER
RET

cvb_CONGRATULATION:

    CALL    LOADFONTS

    LD DE,$0000
    LD HL,congratulation_char
    CALL unpack
    LD DE,$0800
    LD HL,congratulation_char
    CALL unpack
    LD DE,$1000
    LD HL,congratulation_char
    CALL unpack

    LD DE,$2000
    LD HL,congratulation_color
    CALL unpack

    LD DE,$2800
    LD HL,congratulation_sprites
    CALL unpack

    LD BC,4*256+21
    LD DE,$1800+17*32+7
    LD HL,cvb_universal
    CALL CPYBLK_MxN

    LD BC,10*256+7
    LD DE,$1800+1
    LD HL,cvb_congratulation_pattern
    CALL CPYBLK_MxN

    LD BC,4*10+1
    LD DE,$1B00
    LD HL,cvb_FSB
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on


    LD DE,$1800+10+32*10
    LD HL,CONGRATULATIONS
    CALL MYPRINT

    CALL MYENASCR

    RET

CONGRATULATIONS:    db "CONGRATULATIONS !","!" or 128

cvb_CONGRATULATION_FRM0:
    LD BC,4*5+1
    LD DE,$1B00+10*4
    LD HL,cvb_FS0
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on

    LD BC,3*256+4
    LD DE,$1800+10*32
    LD HL,cvb_FRC0
    JP CPYBLK_MxN

cvb_CONGRATULATION_FRM1:
    LD BC,4*5+1
    LD DE,$1B00+10*4
    LD HL,cvb_FS1
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on

    LD BC,3*256+4
    LD DE,$1800+10*32
    LD HL,cvb_FRC1
    JP CPYBLK_MxN

cvb_CONGRATULATION_FRM2:
    LD BC,4*5+1
    LD DE,$1B00+10*4
    LD HL,cvb_FS2
    CALL MyNMI_off
    CALL MYLDIRVM
    CALL MyNMI_on

    LD BC,3*256+4
    LD DE,$1800+10*32
    LD HL,cvb_FRC2
    JP CPYBLK_MxN

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cvb_FS0:
    DB 79,9,40,2
    DB 81,1,44,3
    DB 83,18,48,3
    DB 86,8,52,1
    DB 85,8,56,2
    DB 208
cvb_FS1:
    DB 119-40,9,60,3
    DB 121-40,1,64,4
    DB 123-40,11,68,3
    DB 126-40,12,72,2
    DB 125-40,8,76,1
    DB 208
cvb_FS2:
    DB 159-80,7,80,3
    DB 161-80,21,84,4
    DB 163-80,5,88,3
    DB 166-80,8,92,1
    DB 165-80,8,96,2
    DB 208

cvb_FRC0:
    DB $33,$34,$35,$36
    DB $37,$38,$39,$3a
    DB $00,$3b,$3c,$00
cvb_FRC1:
    DB $3d,$3e,$3f,$40
    DB $41,$42,$43,$3a
    DB $00,$44,$45,$00
cvb_FRC2:
    DB $6d,$6e,$3e,$6f
    DB $37,$42,$43,$75
    DB $00,$76,$77,$00


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cvb_universal:
    DB $46,$47,$48,$49,$4a,$46,$47,$48,$4b,$4c,$46,$47,$4d,$4e,$4f,$50,$51,$46,$51,$4a,$00
    DB $52,$53,$51,$54,$55,$52,$56,$57,$00,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$00,$55,$00
    DB $52,$53,$51,$61,$55,$52,$62,$63,$00,$64,$65,$53,$66,$67,$68,$69,$6a,$6b,$00,$55,$6c
    DB $70,$71,$48,$72,$4a,$46,$51,$46,$51,$4c,$46,$47,$73,$4b,$74,$71,$47,$48,$4b,$4c,$46

cvb_FSB:
    DB 255,16,0,1
    DB 15,8,4,1
    DB 19,44,8,8
    DB 23,22,12,8
    DB 32,16,16,1
    DB 35,36,20,2
    DB 41,29,24,1
    DB 47,18,28,15
    DB 42,48,32,2
    DB 56,16,36,8
    DB 208

    ; Width = 7,height = 10
cvb_congratulation_pattern:
    DB $00,$01,$02,$00,$00,$00,$00
    DB $03,$04,$05,$00,$00,$00,$00
    DB $06,$07,$08,$00,$09,$0a,$00
    DB $0b,$0c,$0d,$0e,$0f,$10,$11
    DB $00,$12,$13,$14,$15,$16,$17
    DB $18,$19,$1a,$1b,$00,$1c,$1d
    DB $1e,$1f,$20,$21,$22,$23,$24
    DB $25,$26,$27,$28,$29,$2a,$2b
    DB $2c,$2d,$2e,$2f,$00,$00,$00
    DB $30,$31,$32,$00,$00,$00,$00

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ; Start tile = 0. Total_tiles = 120
congratulation_char:
    DB $3b,$00,$c3,$00,$01,$03,$07,$45
    DB $07,$fc,$00,$a0,$07,$03,$0f,$1f
    DB $00,$0c,$18,$19,$c1,$ff,$ff,$fe
    DB $fc,$00,$f8,$f8,$f0,$e0,$f8,$7f
    DB $7f,$3f,$08,$e3,$c1,$3f,$7f,$00
    DB $81,$c3,$a2,$0f,$00,$fc,$fe,$19
    DB $21,$c0,$e0,$00,$c0,$c0,$80,$e1
    DB $40,$07,$1f,$b1,$07,$20,$70,$41
    DB $24,$2b,$1e,$0e,$06,$02,$0c,$39
    DB $87,$03,$01,$00,$2c,$1f,$7f,$2b
    DB $47,$04,$f8,$00,$c1,$f7,$fc,$37
    DB $1f,$14,$07,$7f,$03,$00,$6d,$0f
    DB $02,$ff,$7c,$7e,$80,$c0,$e1,$18
    DB $c3,$37,$3c,$7c,$04,$00,$78,$03
    DB $04,$38,$1c,$4e,$0c,$04,$f0,$56
    DB $59,$c0,$5d,$3c,$a5,$38,$47,$88
    DB $36,$c0,$25,$0f,$07,$01,$07,$f8
    DB $04,$06,$06,$03,$f0,$31,$7e,$78
    DB $00,$f0,$f1,$b8,$a0,$4d,$1f,$77
    DB $77,$58,$e0,$18,$95,$71,$b1,$66
    DB $0d,$43,$6c,$3f,$21,$f0,$9a,$0c
    DB $40,$16,$d2,$3f,$0c,$02,$02,$00
    DB $27,$05,$ae,$13,$00,$c3,$02,$fb
    DB $fb,$71,$20,$08,$19,$8c,$73,$80
    DB $00,$00,$51,$7f,$bf,$70,$78,$7c
    DB $7f,$c0,$81,$48,$f7,$f3,$e3,$c3
    DB $03,$96,$39,$69,$69,$02,$61,$80
    DB $33,$30,$10,$e0,$0f,$0f,$80,$da
    DB $3f,$71,$df,$70,$30,$df,$ff,$d7
    DB $c6,$31,$70,$db,$37,$02,$fa,$87
    DB $cf,$e7,$24,$53,$06,$07,$3e,$70
    DB $4b,$0f,$0c,$30,$70,$84,$a0,$31
    DB $f1,$c7,$83,$32,$83,$c7,$43,$9a
    DB $23,$2e,$00,$80,$71,$f3,$a6,$00
    DB $47,$c0,$01,$87,$fd,$fc,$dc,$98
    DB $96,$11,$1d,$d1,$16,$c0,$2c,$33
    DB $07,$0c,$84,$68,$4c,$95,$c2,$73
    DB $1f,$1f,$07,$80,$0e,$60,$70,$40
    DB $40,$60,$1f,$aa,$8b,$0e,$8b,$6e
    DB $58,$c3,$22,$9d,$15,$64,$0f,$00
    DB $1f,$e1,$08,$e3,$1f,$1e,$3c,$90
    DB $9c,$ba,$26,$80,$a9,$08,$04,$02
    DB $01,$a0,$35,$00,$9f,$bf,$7f,$80
    DB $f1,$4f,$f8,$b5,$47,$2b,$f7,$57
    DB $0d,$4f,$38,$3c,$1e,$f2,$4f,$00
    DB $64,$3c,$17,$47,$03,$84,$47,$06
    DB $0c,$08,$47,$40,$3c,$80,$fc,$00
    DB $78,$3f,$00,$0f,$f3,$00,$46,$9e
    DB $df,$0f,$c3,$f0,$1e,$00,$c3,$3c
    DB $00,$ff,$00,$e7,$e7,$a2,$00,$d8
    DB $25,$e7,$17,$fe,$86,$17,$3c,$3c
    DB $cf,$4f,$03,$1e,$00,$30,$3c,$00
    DB $0c,$00,$e1,$a5,$70,$07,$a1,$38
    DB $c0,$9a,$00,$0f,$14,$0e,$0e,$07
    DB $26,$8e,$0e,$d5,$15,$47,$14,$d5
    DB $e3,$00,$b6,$35,$1a,$90,$5a,$21
    DB $17,$09,$84,$c1,$d1,$ee,$cd,$e3
    DB $8b,$ff,$3f,$6f,$9d,$f5,$99,$fe
    DB $f5,$b6,$21,$ef,$03,$9c,$0c,$18
    DB $1c,$ae,$55,$34,$36,$a4,$17,$1b
    DB $0e,$44,$9c,$ab,$17,$1b,$41,$6e
    DB $61,$27,$aa,$15,$14,$05,$f4,$e9
    DB $43,$b0,$da,$bc,$b3,$2b,$67,$30
    DB $2d,$a5,$8c,$5c,$fc,$7c,$18,$d0
    DB $94,$d0,$83,$3b,$fe,$fe,$4b,$ab
    DB $25,$16,$00,$e8,$cf,$7e,$7e,$8d
    DB $0b,$18,$18,$45,$f7,$e0,$b3,$c5
    DB $3b,$fa,$34,$85,$70,$ab,$34,$c1
    DB $6f,$ae,$11,$00,$b9,$f6,$a5,$46
    DB $cf,$c7,$1f,$4d,$d3,$80,$e9,$d7
    DB $c0,$b5,$d7,$ff,$ff,$ff,$ff,$80

congratulation_color:
    DB $3e,$f1,$f2,$00,$81,$00,$c4,$05
    DB $f8,$05,$82,$74,$82,$0f,$09,$f2
    DB $4c,$f2,$09,$21,$00,$79,$82,$00
    DB $74,$19,$0d,$00,$81,$f9,$30,$21
    DB $b6,$07,$66,$11,$00,$df,$21,$6c
    DB $29,$11,$f1,$f3,$3c,$cc,$42,$3f
    DB $db,$24,$ef,$72,$35,$31,$3b,$61
    DB $0b,$eb,$71,$1a,$97,$1f,$f2,$63
    DB $f7,$00,$d6,$54,$20,$a7,$6b,$76
    DB $11,$0d,$ad,$29,$d5,$00,$42,$46
    DB $71,$00,$08,$f8,$f8,$f5,$77,$32
    DB $5e,$12,$00,$3b,$7f,$81,$1a,$b7
    DB $00,$1f,$8a,$8b,$eb,$14,$a6,$57
    DB $95,$1b,$ce,$1f,$45,$db,$3f,$4c
    DB $06,$12,$d5,$b9,$6f,$c6,$cb,$5a
    DB $2b,$34,$37,$52,$cf,$0f,$f8,$00
    DB $31,$31,$73,$41,$00,$43,$d8,$00
    DB $32,$32,$ac,$17,$00,$52,$1b,$32
    DB $43,$41,$5d,$00,$11,$00,$7d,$19
    DB $07,$f1,$17,$42,$42,$a2,$2f,$21
    DB $07,$ea,$09,$07,$11,$e2,$bc,$0e
    DB $f6,$00,$d4,$2e,$bb,$08,$58,$52
    DB $4f,$19,$d4,$07,$ba,$39,$1c,$38
    DB $6c,$41,$07,$a1,$ff,$c3,$00,$f1
    DB $a1,$77,$e9,$00,$b3,$d7,$6d,$76
    DB $1d,$DE,$37,$05,$fb,$4b,$7b,$15
    DB $6b,$a5,$55,$be,$79,$25,$f3,$f7
    DB $6c,$32,$f7,$cf,$d9,$8d,$0f,$42
    DB $7e,$dd,$3e,$9f,$be,$cf,$ad,$01
    DB $bf,$07,$ff,$ff,$ff,$f0


congratulation_sprites:
    DB $3a,$00,$c7,$00,$c0,$00,$f0,$00
    DB $07,$0f,$1f,$68,$e0,$15,$80,$70
    DB $80,$05,$e0,$f0,$f8,$7f,$fc,$41
    DB $23,$00,$0c,$f8,$78,$08,$aa,$3a
    DB $14,$08,$00,$06,$37,$60,$40,$94
    DB $5d,$c0,$00,$05,$30,$7a,$3d,$39
    DB $28,$80,$5c,$80,$f1,$0d,$54,$24
    DB $fd,$5f,$e3,$25,$40,$1c,$3a,$e0
    DB $57,$0f,$f4,$17,$12,$f0,$ff,$01
    DB $04,$01,$00,$ee,$0b,$05,$92,$28
    DB $60,$25,$e0,$00,$e5,$0f,$10,$00
    DB $18,$03,$20,$94,$09,$38,$01,$38
    DB $30,$20,$30,$38,$3a,$00,$5a,$7b
    DB $00,$c7,$3b,$2e,$02,$b4,$4a,$e9
    DB $57,$3d,$63,$f7,$79,$88,$94,$31
    DB $39,$78,$31,$00,$c6,$07,$3e,$fc
    DB $1f,$fc,$1a,$fc,$78,$78,$c0,$55
    DB $0f,$0f,$02,$02,$07,$4f,$07,$05
    DB $01,$80,$3d,$c0,$0c,$1c,$38,$78
    DB $f0,$8b,$08,$0e,$06,$18,$5c,$d7
    DB $0d,$78,$38,$0e,$06,$03,$03,$1d
    DB $e1,$82,$c0,$34,$e3,$68,$94,$ee
    DB $8b,$83,$c0,$d9,$ff,$14,$39,$33
    DB $37,$9e,$3f,$DE,$21,$0f,$c3,$e3
    DB $f1,$f9,$c7,$33,$80,$b0,$9f,$f0
    DB $7c,$70,$9f,$73,$b5,$1e,$05,$3c
    DB $38,$11,$9f,$75,$3c,$1c,$ce,$c3
    DB $a9,$73,$bc,$0d,$01,$13,$e1,$61
    DB $61,$3f,$03,$0d,$AF,$88,$cb,$ae
    DB $b7,$5f,$39,$87,$6a,$18,$3f,$00
    DB $00,$48,$00,$c0,$f6,$0f,$04,$8f
    DB $9f,$40,$40,$e0,$d6,$36,$f0,$85
    DB $e8,$05,$84,$03,$3f,$3f,$1e,$1e
    DB $0c,$0c,$51,$cf,$54,$0e,$c4,$53
    DB $1c,$c5,$71,$07,$0a,$87,$0f,$60
    DB $c0,$cf,$d8,$d7,$78,$3f,$7b,$d8
    DB $65,$e6,$07,$03,$89,$fa,$03,$bd
    DB $87,$86,$86,$d6,$bf,$5a,$00,$a3
    DB $bf,$6a,$00,$cf,$bf,$ff,$ff,$ff
    DB $fe


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MyNMI_off:
    PUSH HL
    LD HL,mode
    SET 0,(HL)
    POP HL
    RET

MyNMI_on:
    PUSH AF
    PUSH HL
    LD HL,mode
    RES 0,(HL)
    nop
    BIT 1,(HL)
    JP nz,nmi_handler.0
    POP HL
    POP AF
    RET


cvb_MYCLS:
    XOR     A
.2: LD      BC,$0300
    LD      HL,$1800
.0: CALL    MyNMI_off
    PUSH    AF
    LD      A,L
    OUT     (CTRL_PORT),A
    LD      A,H
    OR      $40
    OUT     (CTRL_PORT),A
    POP     AF
    DEC     BC      ; T-states (normal / M1)
.1: OUT     (DATA_PORT),A   ; 11 12
    DEC     BC      ;  6  7
    BIT     7,B     ;  8 10
    JP Z,.1     ; 10 11

    JP MyNMI_on


    ;   HL->ROM
    ;   DE->VRAM
    ;   B -> Y size
    ;   C -> X size


CPYBLK_MxN:
    LD  A,C
.0:                     ;   CALL CPYBLK_MxN.0 with A = source width <> origin width
    CALL MyNMI_off
.1: PUSH bc
    PUSH AF
    PUSH HL
    PUSH DE
    LD  B,0
    CALL MYLDIRVM
    POP HL
    LD bc,32
    ADD HL,bc
    EX DE,HL
    POP HL
    POP AF
    LD  C,A
    ADD HL,bc
    POP bc
    djnz .1
    JP MyNMI_on

; BIOS HELPER CODE
MYWRTVDP:           ; write value B in the VDP register C
    LD A,B
    out (CTRL_PORT),A
    LD A,C
    or $80
    out (CTRL_PORT),A
    RET

MYMODE1:                ; screen 2 with mirror mode for patterns
    LD HL,mode
    SET 7,(HL)          ; intermission mode
    LD bc,$0200
    LD DE,$9F03 ; $2000 for color table - Mirror Mode,$0000 for bitmaps  - Normal mode
    JP vdp_chg_mode

MYMODE2:                ; screen 1 no mirroring
    LD HL,mode
    SET 7,(HL)          ; intermission mode
    LD bc,$0000
    LD DE,$8000 ; $2000 for color table,$0000 for bitmaps.

vdp_chg_mode:
    CALL MyNMI_off
    CALL MYWRTVDP
    LD bc,$a201
    CALL MYWRTVDP
    LD bc,$0602 ; $1800 for pattern table.
    CALL MYWRTVDP
    LD B,D
    LD C,$03    ; for color table.
    CALL MYWRTVDP
    LD B,E
    LD C,$04    ; for bitmap table.
    CALL MYWRTVDP
    LD bc,$3605 ; $1b00 for sprite attribute table.
    CALL MYWRTVDP
    LD bc,$0506 ; $2800 for sprites patterns.
    CALL MYWRTVDP
    LD bc,$0107
    CALL MYWRTVDP
    JP MyNMI_on

MYDISSCR:
    CALL MyNMI_off
    LD A,$a2
    out (CTRL_PORT),A
    LD A,$81
    out (CTRL_PORT),A
    JP MyNMI_on

MYENASCR:
    CALL MyNMI_off
    LD A,$e2
    out (CTRL_PORT),A
    LD A,$81
    out (CTRL_PORT),A
    JP MyNMI_on

MYPRINT:
    LD A,E
    out (CTRL_PORT),A
    LD A,D
    or $40
    out (CTRL_PORT),A

.1: LD A,(HL)
    and $7F
    sub "0"
    CP  "9"-"0"+1
    JR nc,.2    ; not in range 0-9
    ADD A,216   ; position of "0" in the tileset
    JR .99
.2: ADD A,"0"-"A"
    CP "Z"-"A"+1
    JR nc,.3    ; not in range A-Z
    ADD A,226   ; position of "A" in the tileset
    JR .99
.3: ADD A,"A"
    CP " "
    JR nz,.4
    LD A,215    ; position of " " in the tileset
    JR .99
.4: CP "!"
    JR nz,.5
    LD A,255    ; position of "!" in the tileset
    JR .99
.5: CP "."
    JR nz,.6
    LD A,254    ; position of "." in the tileset
    JR .99
.6: CP "-"
    JR nz,.7
    LD A,253    ; position of "-" in the tileset
    JR .99
.7: CP "'"
    JR nz,.8
    LD A,252    ; position of "'" in the tileset
    JR .99
.8: LD A,215    ; any other tile is mapped by " "
.99:
    out (DATA_PORT),A
    BIT 7,(HL)
    RET nz
    INC HL
    JR .1


MYINIRVM:               ; read from DE (VRAM) to HL (RAM) BC bytes
    LD A,E
    out (CTRL_PORT),A
    LD A,D
    out (CTRL_PORT),A
    dec bc
    LD A,B
    LD B,C
    INC A
    INC B
    LD C,DATA_PORT
.1:
    ini
    JP nz,.1
    dec A
    JR nz,.1
    RET

MYLDIRVM:
    LD A,E
    out (CTRL_PORT),A
    LD A,D
    or $40
    out (CTRL_PORT),A
    dec bc
    LD A,B
    LD B,C
    INC A
    INC B
    LD C,DATA_PORT
.1:
    outi
    JP nz,.1
    dec A
    JR nz,.1
    RET

MYRDVRM:
    LD A,l
    out (CTRL_PORT),A
    LD A,h
    and $3f
    out (CTRL_PORT),A
    LD A,(IX)           ; 21 cycles of delay
    NOP                 ;  5 cycles of delay
    in A,(DATA_PORT)    ; 12 cycles of delay
    RET

MYWRTVRM:
    PUSH AF
    LD A,l
    out (CTRL_PORT),A
    LD A,h
    or $40
    out (CTRL_PORT),A
    POP AF
    out (DATA_PORT),A
    RET


        ;
        ; Pletter-0.5c decompressor (XL2S Entertainment & Team Bomba)
        ;
unpack:
; Initialization
    LD A,(HL)
    INC HL
    exx
    LD DE,0
    ADD A,A
    INC A
    rl E
    ADD A,A
    rl E
    ADD A,A
    rl E
    rl E
    LD HL,.modes
    ADD HL,DE
    LD C,(HL)
    INC HL
    LD B,(HL)
    PUSH bc
    POP IX
    LD E,1
    exx
    LD iy,.loop

; Main depack loop
.literal:
    EX AF,AF'
    CALL MyNMI_off
    LD A,(HL)
    EX DE,HL
    CALL MYWRTVRM
    EX DE,HL
    INC HL
    INC DE
    CALL MyNMI_on
    EX AF,AF'
.loop:   ADD A,A
    CALL z,.getbit
    JR nc,.literal

; Compressed data
    exx
    LD h,D
    LD l,E
.getlen: ADD A,A
    CALL z,.getbitexx
    JR nc,.lenok
.lus:    ADD A,A
    CALL z,.getbitexx
    ADC HL,HL
    RET C
    ADD A,A
    CALL z,.getbitexx
    JR nc,.lenok
    ADD A,A
    CALL z,.getbitexx
    ADC HL,HL
    RET C
    ADD A,A
    CALL z,.getbitexx
    JR C,.lus
.lenok:  INC HL
    exx
    LD C,(HL)
    INC HL
    LD B,0
    BIT 7,C
    JR z,.offsok
    JP (IX)

.mode6:  ADD A,A
    CALL z,.getbit
    rl B
.mode5:  ADD A,A
    CALL z,.getbit
    rl B
.mode4:  ADD A,A
    CALL z,.getbit
    rl B
.mode3:  ADD A,A
    CALL z,.getbit
    rl B
.mode2:  ADD A,A
    CALL z,.getbit
    rl B
    ADD A,A
    CALL z,.getbit
    JR nc,.offsok
    or A
    INC B
    RES 7,C
.offsok: INC bc
    PUSH HL
    exx
    PUSH HL
    exx
    LD l,E
    LD h,D
    SBC HL,bc
    POP bc
    EX AF,AF'
.loop2:
    CALL MyNMI_off
    CALL MYRDVRM              ; unpack
    EX DE,HL
    CALL MYWRTVRM
    EX DE,HL        ; 4
    CALL MyNMI_on
    INC HL          ; 6
    INC DE          ; 6
    dec bc          ; 6
    LD A,B          ; 4
    or C            ; 4
    JR nz,.loop2     ; 10
    EX AF,AF'
    POP HL
    JP (iy)

.getbit: LD A,(HL)
    INC HL
    rla
    RET

.getbitexx:
    exx
    LD A,(HL)
    INC HL
    exx
    rla
    RET

.modes:
    dw      .offsok
    dw      .mode2
    dw      .mode3
    dw      .mode4
    dw      .mode5
    dw      .mode6

    ;   EXTRA MrDo Intermission Screen - Compressed data
    ;
    ;   ' Start tile = 0. Total_tiles = 204
    ; image_char:
cvb_IMAGE_CHAR:
    DB $3e,$ff,$3c,$00,$00,$00,$f8,$0f
    DB $0f,$1f,$0b,$3f,$3f,$1f,$07,$04
    DB $63,$0d,$03,$1f,$a8,$04,$0f,$0e
    DB $3f,$c3,$18,$0f,$c0,$80,$00,$ff
    DB $61,$7e,$06,$c0,$7e,$01,$15,$7c
    DB $c6,$82,$82,$c6,$7c,$01,$07,$c2
    DB $e2,$b2,$9a,$8e,$86,$c3,$0f,$80
    DB $8e,$c2,$00,$17,$fc,$86,$86,$fc
    DB $88,$8e,$88,$07,$38,$6c,$20,$fe
    DB $82,$8e,$07,$fe,$10,$00,$ad,$07
    DB $2d,$9c,$2f,$80,$00,$fe,$ce,$1f
    DB $16,$71,$38,$37,$70,$1c,$97,$17
    DB $68,$b7,$00,$73,$6a,$00,$01,$8f
    DB $00,$03,$03,$16,$15,$f8,$4e,$30
    DB $00,$f0,$1a,$7d,$39,$08,$93,$c7
    DB $ef,$ef,$07,$83,$39,$4a,$7d,$0a
    DB $83,$0f,$05,$f8,$07,$6d,$45,$2c
    DB $11,$bb,$07,$1c,$90,$00,$c7,$07
    DB $3d,$1d,$4d,$1a,$65,$71,$79,$8f
    DB $56,$41,$1e,$07,$7e,$05,$07,$07
    DB $ff,$c0,$f8,$01,$e0,$0c,$e0,$f8
    DB $e0,$fb,$0a,$00,$e4,$bf,$83,$bf
    DB $bf,$80,$68,$9c,$88,$c1,$e3,$e7
    DB $c9,$60,$9c,$8f,$f7,$e0,$00,$ff
    DB $81,$80,$bc,$00,$80,$81,$bb,$b8
    DB $ff,$e3,$c1,$88,$00,$9c,$be,$80
    DB $be,$ff,$63,$77,$7f,$08,$5d,$49
    DB $41,$41,$57,$40,$40,$16,$5e,$73
    DB $40,$00,$c1,$3e,$60,$60,$43,$41
    DB $c8,$00,$43,$67,$3c,$26,$40,$63
    DB $07,$63,$3e,$07,$0f,$0f,$16,$0e
    DB $0c,$08,$17,$c4,$ce,$00,$fe,$fc
    DB $ef,$75,$0f,$e2,$1e,$89,$e7,$09
    DB $3c,$0c,$07,$3b,$ad,$18,$a3,$8e
    DB $b1,$34,$0f,$80,$e6,$0e,$46,$1c
    DB $b4,$0c,$9a,$a6,$0c,$46,$7f,$49
    DB $bf,$9f,$c7,$17,$02,$07,$81,$d1
    DB $f0,$03,$00,$78,$fb,$fb,$f3,$e7
    DB $ef,$c0,$c0,$03,$e0,$60,$70,$70
    DB $38,$b8,$00,$14,$1c,$3e,$bf,$3f
    DB $7f,$f8,$00,$f0,$e0,$08,$08,$0f
    DB $9f,$cf,$6e,$04,$4e,$DE,$9e,$be
    DB $3e,$a6,$00,$df,$cf,$c7,$e7,$e7
    DB $f3,$fd,$24,$71,$07,$2f,$3f,$1d
    DB $7f,$02,$ff,$f0,$f8,$fc,$fc,$f8
    DB $04,$d8,$a6,$1a,$30,$78,$7c,$4d
    DB $07,$12,$e0,$be,$76,$AF,$ed,$73
    DB $8e,$06,$08,$18,$a9,$a8,$6b,$3b
    DB $cf,$df,$64,$9f,$5d,$00,$b8,$0b
    DB $bc,$9d,$dd,$df,$00,$50,$b8,$63
    DB $ef,$d3,$1a,$8d,$09,$4e,$07,$03
    DB $01,$ce,$a6,$93,$79,$17,$82,$11
    DB $5d,$0f,$35,$46,$d5,$1f,$80,$77
    DB $76,$72,$d2,$8f,$fe,$55,$b4,$1c
    DB $0b,$79,$f0,$16,$3c,$79,$c1,$07
    DB $da,$28,$ac,$23,$4d,$c0,$fc,$6f
    DB $1b,$a0,$09,$89,$7f,$0f,$e0,$06
    DB $83,$f1,$f9,$fd,$08,$3c,$1c,$1e
    DB $1e,$e5,$fb,$d3,$60,$c1,$90,$0c
    DB $75,$1c,$83,$7a,$72,$03,$c0,$ff
    DB $f9,$f0,$b9,$6d,$73,$3f,$38,$bb
    DB $45,$38,$01,$18,$90,$d0,$d0,$21
    DB $92,$d0,$08,$0b,$f0,$c0,$07,$24
    DB $c1,$80,$d3,$fd,$fb,$9d,$b0,$00
    DB $79,$1f,$0f,$99,$00,$07,$72,$c7
    DB $36,$fe,$03,$5a,$50,$76,$96,$ac
    DB $d4,$e7,$cd,$ef,$58,$d3,$c0,$f6
    DB $2a,$84,$b7,$4f,$22,$01,$62,$e2
    DB $e2,$f2,$f2,$f0,$7c,$40,$fd,$81
    DB $c1,$c4,$c7,$0f,$e3,$9e,$27,$64
    DB $92,$6a,$29,$39,$00,$ab,$5e,$03
    DB $2d,$cc,$4f,$1f,$0c,$c0,$c1,$f1
    DB $81,$fc,$a7,$72,$90,$80,$bb,$40
    DB $88,$9e,$58,$0f,$72,$68,$2b,$e3
    DB $c6,$12,$ff,$0e,$1c,$ca,$d1,$7c
    DB $b0,$cf,$AF,$9c,$a1,$a0,$78,$fb
    DB $4d,$dd,$fd,$02,$1c,$0e,$06,$f1
    DB $f0,$e4,$78,$00,$c7,$b0,$74,$f0
    DB $00,$d2,$11,$50,$78,$c0,$34,$00
    DB $74,$5e,$53,$3f,$00,$74,$1f,$e7
    DB $92,$8d,$ab,$95,$d9,$81,$59,$e0
    DB $71,$9f,$f1,$f3,$0b,$f3,$e3,$e3
    DB $c3,$00,$34,$1b,$00,$2f,$11,$05
    DB $ce,$34,$36,$e0,$08,$18,$19,$8a
    DB $08,$30,$60,$40,$c0,$c7,$30,$e3
    DB $e7,$81,$15,$07,$e3,$e0,$5a,$94
    DB $60,$4e,$0c,$7f,$3f,$f9,$51,$06
    DB $a1,$00,$0e,$0c,$7d,$DE,$00,$18
    DB $3f,$f8,$78,$00,$38,$18,$3c,$3c
    DB $74,$00,$70,$5d,$30,$00,$fc,$f7
    DB $00,$d7,$2f,$a4,$11,$90,$50,$7f
    DB $18,$61,$b4,$30,$78,$79,$33,$0c
    DB $9d,$8f,$f4,$48,$f0,$70,$ab,$43
    DB $e7,$00,$e3,$c1,$c1,$1d,$d9,$34
    DB $00,$ef,$6c,$0e,$04,$c8,$c9,$f9
    DB $40,$00,$60,$38,$bf,$ff,$df,$cf
    DB $cf,$03,$27,$0f,$7f,$1f,$8f,$7c
    DB $73,$4d,$60,$15,$f0,$18,$18,$62
    DB $00,$37,$8c,$71,$75,$00,$e7,$db
    DB $00,$5a,$b0,$20,$e5,$03,$ef,$8f
    DB $c7,$c3,$09,$e1,$c1,$7f,$1e,$55
    DB $7f,$18,$66,$3f,$e0,$cd,$16,$1c
    DB $08,$9c,$9f,$4b,$9f,$16,$70,$67
    DB $97,$92,$e0,$7c,$f5,$ca,$56,$15
    DB $87,$f0,$64,$60,$e4,$83,$c8,$07
    DB $d0,$eb,$be,$65,$ae,$e3,$4d,$04
    DB $58,$78,$1d,$e7,$3c,$84,$b3,$02
    DB $3e,$0c,$04,$fc,$7d,$9d,$2d,$c0
    DB $20,$67,$2b,$68,$1f,$23,$70,$f8
    DB $78,$b0,$f6,$2b,$c6,$40,$70,$ca
    DB $44,$e3,$c8,$00,$c7,$33,$e0,$f0
    DB $0b,$a9,$36,$04,$f8,$3a,$63,$01
    DB $3a,$ac,$6c,$59,$b8,$b8,$f5,$8b
    DB $c8,$35,$1d,$5f,$01,$22,$60,$c3
    DB $3c,$60,$f8,$ec,$c4,$48,$13,$d3
    DB $70,$78,$30,$64,$ff,$d8,$c0,$d8
    DB $48,$e0,$f8,$4b,$e0,$44,$f9,$5c
    DB $02,$26,$81,$81,$83,$c7,$19,$8d
    DB $92,$1c,$f7,$ad,$81,$3c,$7e,$7e
    DB $3c,$18,$8b,$06,$3c,$05,$be,$f7
    DB $71,$b4,$34,$fc,$51,$1c,$f1,$55
    DB $72,$13,$08,$d7,$4e,$02,$01,$96
    DB $09,$40,$e0,$37,$d8,$c5,$bb,$12
    DB $07,$77,$ef,$e7,$1f,$0f,$c5,$b6
    DB $48,$DE,$88,$c7,$d4,$dd,$b3,$72
    DB $7c,$48,$d1,$81,$fe,$7e,$3e,$1c
    DB $fc,$04,$57,$a6,$31,$5c,$a6,$61
    DB $d0,$ba,$7d,$26,$9c,$b4,$c0,$3e
    DB $98,$f6,$97,$11,$f8,$ef,$37,$ac
    DB $73,$79,$67,$17,$32,$30,$e0,$00
    DB $35,$ff,$ff,$ff,$ff,$c0
    ;
    ; image_color:
cvb_IMAGE_COLOR:
    DB $5e,$31,$3c,$00,$f1,$00,$78,$51
    DB $00,$b3,$f3,$00,$63,$1d,$83,$83
    DB $40,$04,$f8,$f8,$f1,$b3,$0c,$b8
    DB $b8,$83,$f3,$00,$34,$51,$b5,$00
    DB $6b,$51,$fd,$07,$7b,$61,$66,$00
    DB $6a,$83,$81,$bb,$73,$0b,$cf,$15
    DB $27,$0f,$17,$51,$bb,$3f,$00,$a5
    DB $b6,$07,$dd,$17,$00,$77,$6b,$0a
    DB $76,$74,$0a,$ea,$79,$50,$00,$f7
    DB $08,$b7,$15,$7b,$17,$3c,$00,$f3
    DB $00,$f8,$ef,$47,$d6,$63,$ef,$7c
    DB $11,$8f,$b7,$85,$f7,$07,$f2,$8a
    DB $f1,$6e,$c5,$e3,$07,$c1,$c6,$0e
    DB $c5,$d7,$0d,$00,$b0,$95,$3e,$85
    DB $85,$07,$4d,$c5,$00,$c1,$ee,$00
    DB $2d,$fb,$07,$f3,$17,$97,$2f,$81
    DB $31,$7d,$00,$07,$e7,$47,$7a,$07
    DB $4f,$00,$AF,$f8,$85,$d9,$03,$69
    DB $DE,$6c,$b3,$00,$ca,$3c,$00,$07
    DB $13,$a1,$ca,$81,$00,$c8,$b1,$00
    DB $07,$a8,$8f,$00,$a1,$1d,$07,$a8
    DB $7b,$dd,$00,$55,$df,$4e,$d7,$52
    DB $79,$b7,$07,$7d,$27,$07,$db,$09
    DB $83,$fd,$70,$f5,$9f,$a1,$a1,$77
    DB $10,$05,$0e,$88,$56,$fe,$9c,$0f
    DB $ca,$21,$07,$9d,$e7,$0f,$68,$0b
    DB $95,$33,$05,$85,$a0,$46,$c3,$a7
    DB $41,$a9,$36,$21,$c8,$bf,$19,$08
    DB $5c,$36,$03,$24,$a1,$ef,$04,$3e
    DB $00,$3f,$d8,$5d,$fc,$f1,$d6,$07
    DB $f0,$84,$f8,$21,$a8,$fa,$00,$55
    DB $f3,$04,$b8,$61,$9c,$fd,$00,$b5
    DB $39,$16,$d7,$12,$2f,$77,$64,$13
    DB $1a,$63,$a8,$ca,$dd,$00,$5c,$53
    DB $00,$bf,$99,$03,$f8,$3f,$a6,$04
    DB $e3,$07,$fc,$cf,$00,$be,$2f,$3b
    DB $da,$55,$07,$ee,$79,$08,$d6,$71
    DB $ef,$00,$17,$0b,$c8,$45,$da,$0f
    DB $db,$6f,$9e,$7c,$0e,$e7,$5f,$da
    DB $d7,$3d,$81,$bc,$00,$83,$1f,$c3
    DB $87,$DE,$00,$da,$6f,$f7,$95,$71
    DB $2b,$57,$03,$ae,$cd,$00,$0c,$91
    DB $11,$c3,$6d,$c3,$25,$7d,$1f,$07
    DB $b5,$55,$b1,$74,$6e,$d8,$82,$b1
    DB $f1,$06,$f1,$b7,$0f,$d5,$7d,$ed
    DB $cc,$24,$41,$b7,$e9,$f5,$3f,$fc
    DB $a8,$00,$04,$c3,$31,$8d,$8f,$5b
    DB $d9,$00,$64,$d6,$29,$69,$96,$2d
    DB $00,$99,$7d,$8f,$ba,$54,$59,$3a
    DB $fb,$fb,$4c,$05,$9e,$00,$b8,$65
    DB $00,$22,$04,$9b,$14,$7a,$c7,$07
    DB $4f,$f6,$00,$9a,$3b,$f3,$3c,$43
    DB $83,$e8,$ff,$63,$e4,$b3,$b1,$6b
    DB $00,$4b,$ed,$00,$bb,$0e,$53,$c1
    DB $c7,$da,$0a,$77,$04,$5f,$e6,$56
    DB $9b,$53,$0f,$f1,$b3,$66,$00,$3e
    DB $58,$b7,$fb,$5e,$53,$0f,$3e,$5c
    DB $f1,$c8,$3d,$56,$bd,$58,$fd,$54
    DB $7c,$21,$13,$f3,$db,$05,$4e,$57
    DB $b2,$1d,$4b,$36,$5c,$f1,$00,$62
    DB $fb,$ef,$e7,$56,$f1,$70,$4f,$b8
    DB $db,$35,$4c,$7c,$c5,$37,$04,$05
    DB $0d,$c3,$f3,$c1,$c3,$05,$cf,$0e
    DB $c3,$31,$07,$00,$b3,$e7,$00,$83
    DB $ff,$e7,$0e,$31,$9f,$13,$df,$17
    DB $ff,$ff,$ff,$f8

    ; Width = 22,height = 24
    ; image_pattern:
cvb_IMAGE_PATTERN_FR1:
    DB $00,$00,$00,$00
    DB $00,$00,$00,$03
    DB $00,$04,$05,$06
    DB $00,$12,$13,$14
    DB $15,$16,$17,$00
cvb_IMAGE_PATTERN_FR2:
    DB $00,$21,$22,$23
    DB $2f,$13,$30,$31
    DB $32,$33,$34,$35
    DB $00,$00,$00,$00
    DB $00,$00,$00,$00

;cvb_IMAGE_PATTERN:
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
;   DB $02,$02,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$0c,$0d,$10,$08,$09,$11,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
;   DB $02,$02,$18,$19,$1a,$02,$1b,$1c,$1d,$02,$02,$1e,$02,$02,$1f,$02,$20,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$24,$25,$26,$27,$28,$02,$29,$2a,$2b,$2c,$2d,$2e,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$36,$37,$02,$38,$39,$3a,$3b,$3c,$02,$02
;   DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$02
;   DB $02,$02,$46,$47,$48,$02,$02,$02,$49,$02,$02,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54
;   DB $55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$61,$4d,$4d,$62,$63,$64,$65,$66,$67,$68
;   DB $4d,$4d,$4d,$4d,$4d,$4d,$69,$6a,$6b,$6b,$6c,$4d,$4d,$4d,$6d,$6e,$6f,$70,$71,$72,$73,$74
;   DB $4d,$4d,$4d,$4d,$4d,$4d,$75,$76,$77,$78,$79,$4d,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83
;   DB $4d,$4d,$84,$85,$86,$4d,$4d,$87,$88,$89,$4d,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91,$92,$93,$4d
;   DB $94,$94,$95,$96,$97,$94,$94,$98,$94,$99,$94,$9a,$9b,$9c,$9d,$9e,$9f,$94,$a0,$a1,$94,$94
;   DB $00,$a2,$a3,$a4,$a5,$00,$00,$00,$00,$00,$00,$00,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$00,$00,$00
;   DB $00,$00,$ad,$ae,$AF,$b0,$00,$00,$00,$00,$00,$03,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$00,$00,$00
;   DB $00,$00,$b8,$b9,$ba,$bb,$00,$00,$00,$00,$00,$35,$bc,$bd,$be,$bf,$c0,$c1,$c2,$00,$00,$00
;   DB $00,$00,$c3,$c4,$c5,$c6,$00,$00,$00,$00,$00,$00,$00,$c7,$c8,$c9,$ca,$cb,$00,$00,$00,$00
;   DB $00,$cc,$cd,$ce,$cf,$00,$00,$00,$00,$00,$00,$00,$d0,$d1,$d2,$d3,$d4,$d5,$00,$00,$00,$00
;   DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;   DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

    ; TMSColor 2.4 Sep/25/2024
    ; Command: ..\..\tmscolor -D -z ExtraPNT.BIN ExtraPNT_plt.asm
    ; Created: Wed Jan 22 13:56:36 2025

cvb_IMAGE_PATTERN_plt:
    db $1c,$01,$00,$02,$dd,$34,$00,$1a
    db $d7,$c0,$1f,$07,$08,$09,$0a,$04
    db $0b,$0c,$0d,$0e,$0f,$03,$10,$9e
    db $0a,$11,$a8,$3f,$18,$02,$19,$1a
    db $02,$1b,$1c,$1d,$08,$43,$1e,$02
    db $1f,$02,$20,$5e,$3f,$00,$24,$25
    db $26,$27,$28,$02,$29,$2a,$0f,$2b
    db $2c,$2d,$2e,$fb,$5f,$7d,$c0,$1f
    db $36,$37,$02,$38,$0d,$39,$3a,$3b
    db $3c,$f8,$1f,$3d,$3e,$01,$3f,$40
    db $41,$42,$43,$44,$45,$e8,$1f,$46
    db $31,$47,$48,$1b,$49,$00,$02,$4a
    db $4b,$4c,$4d,$4e,$4f,$50,$0d,$51
    db $52,$53,$54,$60,$1f,$55,$56,$57
    db $58,$00,$59,$5a,$5b,$5c,$5d,$5e
    db $5f,$60,$00,$61,$4d,$4d,$62,$63
    db $64,$65,$66,$35,$67,$68,$ae,$1f
    db $12,$00,$06,$69,$6a,$6b,$6b,$6c
    db $00,$07,$6d,$6e,$6f,$70,$71,$72
    db $73,$7f,$74,$00,$1f,$75,$76,$77
    db $78,$79,$4d,$7a,$00,$7b,$7c,$7d
    db $7e,$7f,$80,$81,$82,$6f,$83,$08
    db $1f,$84,$85,$86,$04,$87,$88,$00
    db $89,$4d,$8a,$8b,$8c,$8d,$8e,$8f
    db $06,$90,$91,$92,$93,$4d,$b0,$1f
    db $94,$94,$95,$20,$96,$97,$04,$98
    db $94,$99,$94,$00,$9a,$9b,$9c,$9d
    db $9e,$9f,$94,$a0,$5a,$a1,$0e,$c0
    db $1f,$00,$a2,$a3,$a4,$a5,$6c,$00
    db $00,$a6,$03,$a7,$a8,$a9,$aa,$ab
    db $ac,$37,$09,$01,$1f,$00,$ad,$ae
    db $AF,$b0,$a0,$1e,$03,$b1,$b2,$07
    db $b3,$b4,$b5,$b6,$b7,$e0,$1f,$b8
    db $b9,$ba,$68,$bb,$1f,$35,$01,$bc
    db $bd,$be,$bf,$c0,$c1,$c2,$f8,$1f
    db $c3,$1e,$c4,$c5,$c6,$01,$60,$c7
    db $c8,$c9,$ca,$cb,$00,$ec,$1f,$cc
    db $1e,$cd,$ce,$cf,$01,$1e,$d0,$d1
    db $d2,$d3,$d4,$d5,$f9,$1f,$ba,$6b
    db $00,$a7,$1f,$ff,$ff,$ff,$fe

    ; image_sprites:
cvb_IMAGE_SPRITES:
    DB $3e,$00,$83,$00,$c0,$0c,$00,$f0
    DB $00,$03,$0e,$c1,$04,$60,$c0,$e0
    DB $6c,$00,$0f,$80,$04,$c0,$00,$10
    DB $10,$18,$00,$1c,$11,$1c,$1e,$0e
    DB $00,$0f,$0f,$f1,$27,$e0,$60,$06
    DB $00,$3c,$38,$30,$20,$f1,$3b,$58
    DB $08,$ec,$4b,$e0,$0f,$c0,$c0,$80
    DB $00,$d9,$00,$8c,$ea,$05,$19,$40
    DB $78,$fc,$fe,$7d,$ef,$2d,$3f,$f0
    DB $5f,$4f,$1f,$ed,$27,$f9,$15,$c0
    DB $fc,$0b,$20,$0d,$30,$38,$3c,$3e
    DB $91,$00,$3c,$cf,$1a,$d0,$a9,$41
    DB $c0,$00,$93,$38,$3e,$78,$70,$dd
    DB $1e,$19,$ce,$1a,$9a,$f3,$1b,$03
    DB $1c,$00,$01,$76,$e0,$c3,$79,$01
    DB $03,$89,$12,$0f,$07,$dc,$d0,$1b
    DB $0e,$c7,$00,$83,$06,$0c,$0c,$1c
    DB $9e,$c0,$17,$9c,$0b,$67,$ba,$eb
    DB $c9,$78,$01,$57,$f8,$c3,$07,$19
    DB $31,$31,$d0,$9f,$7a,$80,$cf,$a6
    DB $e8,$ff,$b5,$80,$52,$9f,$d5,$b3
    DB $58,$99,$7d,$c0,$a1,$68,$05,$06
    DB $71,$04,$98,$b0,$00,$18,$3c,$18
    DB $c2,$16,$64,$00,$c9,$35,$d2,$7f
    DB $00,$bd,$4c,$e4,$1d,$c0,$1d,$fa
    DB $fe,$13,$ff,$ff,$ff,$ff,$c0

    ;
    ; sprite_overlay:
cvb_SPRITE_OVERLAY:
;   DB 2+17*8,24+13*8,0,3
    DB 208,24+13*8,0,3      ; hide (!)
    DB 74,165,4,12
    DB 70,149,8,5
    DB 70,136,12,5
    DB 70,176,16,1
    DB 90,95,20,8
    DB 106,136,24,12
    DB 100,192,28,10
    DB 114,158,32,8
    DB 101,112,36,8
    DB 115,136,40,8
    DB 119,156,44,15
    DB 126,61,48,15
    DB 130,56,52,8
    DB 132,71,56,3
    DB 124,136,60,3
    DB 132,184,64,11
    DB 133,160,68,11
    DB 152,59,72,15
    DB 154,74,76,15
    DB 149,144,80,3
    DB 157,56,84,12
    DB 208

    ;   ANIMATED LOGO - Compressed data
    ;
    ; TILESET:
cvb_TILESET:
    DB $5a,$00,$1a,$00,$01,$03,$23,$00
    DB $07,$00,$0e,$00,$63,$00,$0f,$07
    DB $8c,$00,$03,$01,$1b,$43,$01,$17
    DB $0f,$1f,$1f,$39,$10,$22,$3f,$95
    DB $08,$05,$13,$60,$12,$13,$3f,$7f
    DB $7f,$d8,$2d,$80,$c0,$d2,$2b,$06
    DB $68,$f0,$0e,$ff,$b4,$00,$55,$da
    DB $07,$3f,$d8,$07,$03,$0f,$d8,$07
    DB $04,$0e,$ca,$07,$5c,$41,$78,$3f
    DB $27,$80,$d2,$07,$52,$73,$9f,$07
    DB $03,$ac,$16,$00,$5b,$33,$ff,$3f
    DB $73,$98,$1e,$f0,$0f,$20,$1c,$78
    DB $fe,$ff,$00,$18,$6c,$fc,$07,$ff
    DB $18,$7f,$3f,$3f,$94,$1c,$0f,$09
    DB $60,$c0,$24,$e0,$e0,$c0,$80,$f1
    DB $7a,$ff,$f4,$07,$3e,$02,$6d,$00
    DB $2a,$77,$29,$07,$69,$20,$3b,$f1
    DB $07,$07,$01,$b2,$07,$1f,$08,$d1
    DB $07,$81,$7c,$17,$5c,$ff,$f2,$08
    DB $d2,$03,$c0,$e0,$f8,$16,$08,$c0
    DB $5e,$85,$00,$f8,$f0,$68,$dd,$0a
    DB $1c,$6d,$72,$07,$cf,$39,$c0,$0c
    DB $00,$ff,$fe,$21,$ca,$22,$05,$00
    DB $a8,$07,$08,$02,$f0,$f8,$f0,$b1
    DB $49,$00,$fc,$12,$ff,$03,$20,$fe
    DB $fc,$fc,$f8,$f8,$6b,$10,$0a,$e7
    DB $1a,$00,$be,$11,$00,$09,$01,$00
    DB $79,$7f,$16,$88,$31,$3c,$00,$7b
    DB $00,$e6,$0b,$18,$00,$00,$dd,$fd
    DB $3d,$3c,$1f,$0e,$06,$07,$06,$c6
    DB $e6,$e6,$0f,$31,$0f,$bd,$00,$60
    DB $88,$00,$f7,$00,$f0,$3d,$1d,$3d
    DB $fd,$dd,$13,$10,$c5,$9f,$9e,$86
    DB $c6,$83,$21,$c3,$e1,$f9,$79,$10
    DB $4a,$43,$89,$19,$9f,$9f,$1f,$00
    DB $5d,$23,$00,$2b,$c8,$33,$81,$00
    DB $c3,$8c,$c4,$00,$DE,$00,$cc,$2e
    DB $ed,$c0,$04,$0b,$21,$ce,$ce,$34
    DB $e3,$e3,$e9,$84,$00,$ec,$ec,$09
    DB $c7,$30,$c7,$e1,$00,$f3,$f3,$2b
    DB $e1,$ed,$13,$00,$8b,$3b,$ed,$ed
    DB $0e,$98,$13,$f0,$0b,$e0,$cd,$00
    DB $f8,$bf,$00,$c1,$be,$a2,$ae,$a2
    DB $be,$c1,$81,$76,$c1,$9c,$9e,$c0
    DB $fc,$a5,$07,$01,$74,$02,$07,$0d
    DB $9f,$c2,$DE,$f7,$63,$e7,$41,$e3
    DB $f4,$9f,$27,$08,$06,$43,$bb,$0c
    DB $10,$e9,$cb,$ce,$d9,$07,$f8,$d9
    DB $f3,$c6,$a4,$9b,$8d,$a2,$f3,$78
    DB $12,$78,$30,$00,$ba,$e5,$d1,$78
    DB $00,$1b,$fe,$f9,$32,$3f,$e3,$00
    DB $7f,$66,$d7,$00,$db,$0d,$97,$97
    DB $2a,$c2,$00,$07,$72,$f0,$c6,$dc
    DB $57,$cf,$54,$1f,$c7,$79,$29,$4e
    DB $87,$65,$fd,$fd,$6b,$79,$f2,$d7
    DB $c3,$f3,$e5,$fc,$eb,$fe,$d2,$00
    DB $AF,$3e,$04,$04,$1d,$6e,$7c,$41
    DB $00,$99,$7e,$DE,$05,$71,$00,$1d
    DB $20,$60,$0c,$99,$9f,$16,$73,$59
    DB $93,$da,$c8,$ab,$20,$20,$e1,$8f
    DB $b7,$1f,$3a,$db,$83,$1a,$c0,$00
    DB $ac,$87,$03,$18,$3c,$3e,$7e,$66
    DB $4f,$80,$4f,$ab,$85,$df,$3c,$93
    DB $c7,$29,$b0,$f1,$f1,$d2,$cd,$08
    DB $7b,$f0,$76,$00,$22,$95,$08,$7b
    DB $7c,$6a,$00,$07,$ee,$fb,$5b,$04
    DB $10,$fd,$d7,$08,$07,$1f,$03,$1c
    DB $3e,$71,$7f,$cb,$9d,$04,$8f,$f4
    DB $b6,$a8,$55,$00,$0c,$b1,$e7,$c1
    DB $8e,$a5,$f9,$f0,$56,$df,$e0,$e0
    DB $00,$e1,$e3,$e7,$e7,$35,$ef,$ef
    DB $3a,$7c,$d9,$bd,$00,$fc,$00,$bb
    DB $75,$91,$f9,$00,$87,$bf,$6e,$b5
    DB $1f,$07,$03,$c3,$c1,$c1,$80,$34
    DB $1f,$7f,$0f,$9c,$d4,$b9,$b8,$c1
    DB $30,$60,$11,$03,$1f,$ec,$13,$08
    DB $e4,$f8,$83,$da,$45,$f5,$0a,$0f
    DB $00,$f6,$73,$c6,$77,$3e,$17,$3d
    DB $89,$7e,$7f,$ff,$ff,$ff,$ff,$c0


;cvb_COLORSET0:
;cvb_COLORSET1: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$bb,$0b,$0b
;cvb_COLORSET2: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$cb,$cb,$bb,$0b,$0b
;cvb_COLORSET3: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$0b,$0b,$0b,$cb,$cb,$0b,$0b,$4b,$4b,$bb,$0b,$0b
;cvb_COLORSET4: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$cb,$0b,$0b,$4b,$4b,$0b,$0b,$7b,$7b,$bb,$0b,$0b
;cvb_COLORSET5: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$4b,$0b,$0b,$7b,$7b,$cb,$cb,$3b,$3b,$bb,$0b,$0b
;cvb_COLORSET6: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$7b,$cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b,$bb,$0b,$0b
;cvb_COLORSET7: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$3b,$4b,$4b,$6b,$6b,$7b,$7b,$ab,$ab,$bb,$cb,$cb
;cvb_COLORSET8: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$6b,$7b,$7b,$ab,$ab,$3b,$3b,$cb,$cb,$bb,$4b,$4b
;cvb_COLORSET9: DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$ab,$3b,$3b,$cb,$cb,$6b,$6b,$4b,$4b,$bb,$7b,$7b
;cvb_COLORSET10:    DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$cb,$6b,$6b,$4b,$4b,$ab,$ab,$7b,$7b,$bb,$3b,$3b
;cvb_COLORSET11:    DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$4b,$ab,$ab,$7b,$7b,$cb,$cb,$3b,$3b,$bb,$6b,$6b
;cvb_COLORSET12:    DB $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$08,$7b,$cb,$cb,$3b,$3b,$4b,$4b,$6b,$6b,$bb,$ab,$ab


cvb_PNT:
    DB $1e,$30,$bb,$00,$00,$27,$1b,$1d
    DB $1c,$28,$28,$2d,$47,$1e,$00,$1f
    DB $23,$0d,$0f,$2f,$21,$22,$e0,$1e
    DB $2e,$b2,$64,$80,$00,$02,$73,$90
    DB $AF,$66,$82,$5b,$78,$70,$06,$10
    DB $26,$91,$05,$DE,$1f,$00,$2b,$b1
    DB $6a,$89,$5e,$75,$92,$ab,$00,$68
    DB $87,$5c,$7c,$93,$18,$1a,$20,$0d
    DB $30,$70,$99,$01,$e0,$1f,$25,$ad
    DB $62,$84,$00,$5d,$74,$00,$08,$61
    DB $85,$a0,$7a,$00,$97,$ae,$65,$81
    DB $17,$71,$95,$07,$DE,$1f,$00,$24
    DB $0c,$10,$0e,$0a,$0a,$09,$19,$c0
    DB $1f,$76,$98,$a8,$67,$0d,$88,$03
    DB $72,$04,$70,$a4,$2a,$b0,$00,$63
    DB $86,$5a,$7c,$96,$a9,$60,$8a,$1a
    DB $58,$77,$13,$e0,$1f,$29,$ac,$6b
    DB $00,$8b,$5f,$7b,$94,$aa,$69,$83
    DB $59,$35,$79,$0f,$c5,$1f,$2c,$62
    DB $00,$00,$0d,$15,$14,$0b,$12,$16
    DB $11,$6f,$30,$ee,$c0,$00,$3d,$47
    DB $39,$45,$3e,$06,$3b,$3c,$38,$49
    DB $4a,$ec,$1f,$44,$00,$48,$3a,$4b
    DB $4c,$3f,$40,$41,$46,$00,$43,$42
    DB $30,$50,$54,$51,$52,$53,$ff,$ff
    DB $ff,$ff,$c0



ARCADEFONTS:
    db $1f,$00,$01,$00,$7c,$c6,$82,$82
    db $c6,$7c,$09,$07,$10,$30,$10,$00
    db $38,$c1,$0f,$06,$7c,$c0,$fe,$07
    db $07,$fe,$06,$3c,$06,$01,$17,$1c
    db $34,$64,$c4,$fe,$04,$0d,$07,$fc
    db $80,$fc,$23,$0f,$1c,$fc,$86,$a0
    db $07,$1f,$0c,$18,$30,$60,$eb,$2f
    db $01,$a2,$17,$05,$c2,$7e,$39,$88
    db $07,$38,$6c,$50,$fe,$82,$aa,$2f
    db $25,$01,$02,$80,$07,$7e,$c0,$80
    db $80,$c0,$7e,$eb,$0f,$67,$84,$0f
    db $fe,$80,$f8,$10,$fe,$f1,$07,$80
    db $c5,$37,$80,$8e,$39,$55,$07,$1d
    db $35,$00,$8d,$3f,$10,$96,$87,$02
    db $00,$80,$97,$86,$8c,$98,$b0,$ec
    db $59,$c6,$07,$2c,$a4,$37,$14,$ee
    db $30,$ba,$92,$27,$c2,$e2,$0d,$b2
    db $9a,$8e,$86,$6e,$bf,$6d,$d8,$4f
    db $82,$9a,$36,$cc,$76,$0f,$38,$88
    db $8e,$0f,$70,$1c,$d1,$AF,$10,$dd
    db $00,$67,$b6,$2f,$0e,$05,$44,$6c
    db $38,$07,$08,$92,$ba,$ee,$44,$07
    db $c6,$6c,$ae,$ce,$ba,$5f,$b9,$15
    db $27,$fe,$d8,$DE,$6f,$30,$0d,$30
    db $10,$20,$00,$AF,$00,$0d,$18,$00
    db $60,$f7,$18,$65,$18,$25,$01,$ff
    db $ff,$ff,$ff,$80



;; Snowman 4 frames
;SNOWMANGENERATOR:
;   DB 0                            ; 0 right   0   ; MrDo sprites start from here
;   DW 44*4,SNOWMAN_WALK_RIGHT_00_PAT
;   DB 0                            ; 1
;   DW 44*4,SNOWMAN_WALK_RIGHT_01_PAT
;   DB 0                            ; 2
;   DW 44*4,SNOWMAN_WALK_RIGHT_02_PAT
;   DB 0                            ; 3
;   DW 44*4,SNOWMAN_WALK_RIGHT_01_PAT
;
;   DB 0                            ; 0 right 4
;   DW 44*4,SNOWMAN_PUSH_RIGHT_00_PAT
;   DB 0                            ; 1     5
;   DW 44*4,SNOWMAN_PUSH_RIGHT_01_PAT
;   DB 0                            ; 2     6
;   DW 44*4,SNOWMAN_PUSH_RIGHT_02_PAT
;   DB 0                            ; 3     7
;   DW 44*4,SNOWMAN_PUSH_RIGHT_01_PAT
;
;   DB 1                            ; 0 left 8
;   DW BYTE_C284,SNOWMAN_WALK_RIGHT_00_PAT
;   DB 1                            ; 1
;   DW BYTE_C284,SNOWMAN_WALK_RIGHT_01_PAT
;   DB 1                            ; 2
;   DW BYTE_C284,SNOWMAN_WALK_RIGHT_02_PAT
;   DB 1                            ; 3
;   DW BYTE_C284,SNOWMAN_WALK_RIGHT_01_PAT
;
;   DB 1                            ; 0 left 12
;   DW BYTE_C284,SNOWMAN_PUSH_RIGHT_00_PAT
;   DB 1                            ; 1     13
;   DW BYTE_C284,SNOWMAN_PUSH_RIGHT_01_PAT
;   DB 1                            ; 2     14
;   DW BYTE_C284,SNOWMAN_PUSH_RIGHT_02_PAT
;   DB 1                            ; 3     15
;   DW BYTE_C284,SNOWMAN_PUSH_RIGHT_01_PAT
;
;   DB 2                            ; 0 up  16
;   DW BYTE_C288,SNOWMAN_WALK_RIGHT_00_PAT
;   DB 2                            ; 1
;   DW BYTE_C288,SNOWMAN_WALK_RIGHT_01_PAT
;   DB 2                            ; 2
;   DW BYTE_C288,SNOWMAN_WALK_RIGHT_02_PAT
;   DB 2                            ; 3
;   DW BYTE_C288,SNOWMAN_WALK_RIGHT_01_PAT
;
;   DB 2                            ; 0 up 20
;   DW BYTE_C288,SNOWMAN_PUSH_RIGHT_00_PAT
;   DB 2                            ; 1
;   DW BYTE_C288,SNOWMAN_PUSH_RIGHT_01_PAT
;   DB 2                            ; 2
;   DW BYTE_C288,SNOWMAN_PUSH_RIGHT_02_PAT
;   DB 2                            ; 3
;   DW BYTE_C288,SNOWMAN_PUSH_RIGHT_01_PAT
;
;   DB 3                            ; 0 down    24
;   DW BYTE_C28C,SNOWMAN_WALK_RIGHT_00_PAT
;   DB 3                            ; 1
;   DW BYTE_C28C,SNOWMAN_WALK_RIGHT_01_PAT
;   DB 3                            ; 2
;   DW BYTE_C28C,SNOWMAN_WALK_RIGHT_02_PAT
;   DB 3                            ; 3
;   DW BYTE_C28C,SNOWMAN_WALK_RIGHT_01_PAT
;
;   DB 3                            ; 0 down 28
;   DW BYTE_C28C,SNOWMAN_PUSH_RIGHT_00_PAT
;   DB 3                            ; 1
;   DW BYTE_C28C,SNOWMAN_PUSH_RIGHT_01_PAT
;   DB 3                            ; 2
;   DW BYTE_C28C,SNOWMAN_PUSH_RIGHT_02_PAT
;   DB 3                            ; 3
;   DW BYTE_C28C,SNOWMAN_PUSH_RIGHT_01_PAT
;
;   DB 4                            ; 0 up-mirror 32
;   DW BYTE_C290,SNOWMAN_WALK_RIGHT_00_PAT
;   DB 4                            ; 1
;   DW BYTE_C290,SNOWMAN_WALK_RIGHT_01_PAT
;   DB 4                            ; 2
;   DW BYTE_C290,SNOWMAN_WALK_RIGHT_02_PAT
;   DB 4                            ; 3
;   DW BYTE_C290,SNOWMAN_WALK_RIGHT_01_PAT
;
;   DB 4                            ; 0 up-mirror 36
;   DW BYTE_C290,SNOWMAN_PUSH_RIGHT_00_PAT
;   DB 4                            ; 1
;   DW BYTE_C290,SNOWMAN_PUSH_RIGHT_01_PAT
;   DB 4                            ; 2
;   DW BYTE_C290,SNOWMAN_PUSH_RIGHT_02_PAT
;   DB 4                            ; 3
;   DW BYTE_C290,SNOWMAN_PUSH_RIGHT_01_PAT
;
;   DB 5                            ; 0 down-mirror 40
;   DW BYTE_C294,SNOWMAN_WALK_RIGHT_00_PAT
;   DB 5                            ; 1
;   DW BYTE_C294,SNOWMAN_WALK_RIGHT_01_PAT
;   DB 5                            ; 2
;   DW BYTE_C294,SNOWMAN_WALK_RIGHT_02_PAT
;   DB 5                            ; 3
;   DW BYTE_C294,SNOWMAN_WALK_RIGHT_01_PAT
;
;   DB 5                            ; 0 down-mirror 44
;   DW BYTE_C294,SNOWMAN_PUSH_RIGHT_00_PAT
;   DB 5                            ; 1
;   DW BYTE_C294,SNOWMAN_PUSH_RIGHT_01_PAT
;   DB 5                            ; 2
;   DW BYTE_C294,SNOWMAN_PUSH_RIGHT_02_PAT
;   DB 5                            ; 3
;   DW BYTE_C294,SNOWMAN_PUSH_RIGHT_01_PAT
;
;   DB 0                            ; 0 Death 48
;   DW 44*4,SNOWMAN_DEATH_F0
;   DB 0                            ; 1
;   DW 44*4,SNOWMAN_DEATH_F1
;   DB 0                            ; 2
;   DW 44*4,SNOWMAN_DEATH_F2
;   DB 0                            ; 3
;   DW 44*4,SNOWMAN_DEATH_F3
;
;SNOWMAN_WALK_RIGHT_00_PAT: DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$03,$01,$20,$00,$1e,$00,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$e0,$c0,$00,$00,$c0,$f0,$00,$00,$0f,$1f,$3e,$3e,$3b,$3c,$1f,$0e,$1c,$1e,$1f,$1f,$01,$00,$00,$00,$80,$c0,$a0,$a0,$00,$60,$c0,$80,$00,$00,$c0,$c0,$00,$00
;SNOWMAN_WALK_RIGHT_01_PAT: DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$06,$06,$06,$04,$03,$03,$00,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$00,$00,$00,$00,$c0,$00,$00,$0f,$1f,$3f,$3f,$3e,$3b,$1c,$0b,$19,$19,$19,$1b,$0c,$00,$00,$00,$80,$c0,$e0,$e0,$a0,$00,$40,$80,$c0,$c0,$c0,$c0,$80,$00
;SNOWMAN_WALK_RIGHT_02_PAT: DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$1e,$3c,$00,$00,$19,$1e,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$00,$20,$00,$00,$e0,$00,$00,$00,$0f,$1f,$3e,$3e,$3b,$3c,$1f,$0b,$01,$03,$1f,$1f,$04,$00,$00,$00,$80,$c0,$a0,$a0,$00,$60,$c0,$80,$c0,$c0,$c0,$c0,$00,$00
;
;SNOWMAN_PUSH_RIGHT_00_PAT: DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1e,$00,$00,$00,$00,$00,$00,$00,$00,$78,$00,$01,$3f,$7f,$00,$00,$c0,$f0,$00,$00,$07,$8f,$1f,$1e,$1f,$1d,$0e,$07,$0f,$1f,$1f,$1f,$01,$00,$00,$00,$c0,$e4,$f0,$02,$50,$80,$20,$c0,$c0,$80,$c0,$c0,$00,$00
;SNOWMAN_PUSH_RIGHT_01_PAT: DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$00,$00,$00,$00,$00,$00,$00,$78,$00,$01,$3f,$7f,$00,$00,$00,$c0,$00,$00,$07,$0f,$1f,$1f,$1f,$1d,$0e,$07,$0f,$1f,$1f,$1f,$0c,$00,$00,$00,$c0,$e0,$f0,$50,$50,$80,$20,$c0,$c0,$80,$c0,$c0,$80,$00
;SNOWMAN_PUSH_RIGHT_02_PAT: DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$1e,$00,$00,$00,$00,$00,$00,$00,$00,$3c,$01,$3f,$7f,$00,$00,$e0,$00,$00,$00,$23,$07,$0f,$0f,$0f,$0f,$07,$0c,$0f,$1f,$1f,$1f,$04,$00,$00,$00,$e4,$f1,$f8,$20,$88,$a8,$c0,$20,$c0,$80,$c0,$c0,$00,$00
;
;SNOWMAN_DEATH_F0:          DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$22,$66,$c6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1f,$1f,$19,$0e,$03,$19,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$f8,$f8,$98,$70,$c0,$98,$38
;SNOWMAN_DEATH_F1:          DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$22,$66,$c6,$00,$00,$00,$00,$00,$0f,$1f,$3f,$3f,$3f,$3f,$39,$1e,$03,$19,$1c,$00,$00,$00,$00,$00,$f0,$f8,$fc,$fc,$fc,$fc,$9c,$78,$c0,$98,$38
;SNOWMAN_DEATH_F2:          DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$22,$66,$c6,$07,$1f,$3f,$7f,$ff,$ff,$ff,$ff,$ff,$7f,$3d,$1a,$0f,$03,$19,$1c,$e0,$f8,$fc,$fe,$ff,$ff,$ff,$ff,$ff,$fe,$bc,$58,$f0,$c0,$98,$38
;SNOWMAN_DEATH_F3:          DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$44,$66,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$22,$66,$c6,$08,$4c,$70,$24,$86,$c0,$24,$0e,$05,$0d,$0c,$07,$02,$03,$19,$1c,$10,$32,$0e,$24,$61,$03,$24,$70,$a0,$b0,$30,$e0,$40,$c0,$98,$38
;
;