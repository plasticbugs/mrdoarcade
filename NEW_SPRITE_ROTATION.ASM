;
NEW_SPRITE_ROTATION:
	LD	A,SAT and 255		; Send LSB of address
	OUT	(CTRL_PORT),A
	
	LD	A, $40  + (SAT / 256)
	OUT	(CTRL_PORT),A		; Send MSB of address

	LD	IXL,20
	LD	DE,SPRITE_ORDER_TABLE	;   RAM sprite index table		
	LD	B,0
.2:		
	LD	HL,SPRITE_NAME_TABLE
	LD	A,(DE)				
	INC	DE
	ADD	A,A
	ADD	A,A
	LD	C,A
	ADD HL,BC
							; B = count for 4 bytes of data
	LD	BC,4*256+DATA_PORT	; C = output port
.1:	OUTI					; Output a byte of data
	JR	NZ,.1			; Loop until 4 bytes copied
	DEC	IXL
	JR	NZ,.2		; Loop until all sprites copied
	
	LD	A,208
	OUT (DATA_PORT),A

;SATFLIPPING:
;	LD	A,(SPRITEROTFLAG)
;	XOR	1
;	LD	(SPRITEROTFLAG),A
;	
;	JR	Z,.direct
;	
;.reverse:
;	LD	HL,REVERSE
;	LD	DE,SPRITE_ORDER_TABLE
;	LD	BC,20
;	LDIR
;	RET
;
;.direct:
;	LD	HL,DIRECT
;	LD	DE,SPRITE_ORDER_TABLE
;	LD	BC,20
;	LDIR
;	RET
;
;DIRECT:	
;	DB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
;REVERSE:
;	DB 19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0


SATROTATION:

	LD	A,(SPRITEROTFLAG)
	ADD	A,4
	CP	20
	JR	C,.nores
	XOR	A
.nores:	
	LD	(SPRITEROTFLAG),A
	LD	C,A
	LD	B,0
	LD	HL,SEQUENCE
	ADD	HL,BC
	LD	DE,SPRITE_ORDER_TABLE
	LD	BC,20
	LDIR
	RET

SEQUENCE:
	DB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
	DB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19