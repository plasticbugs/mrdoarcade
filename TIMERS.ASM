

	
; allocate timer
	XOR		A			; A = 0 if one-shot, else free-running
	LD		HL,180		; time lenght	
	CALL	REQUEST_SIGNAL
	LD		(IY+8),A	; ID of the allocated timer

; test timer	
	LD		A,(IY+8)
	CALL	TEST_SIGNAL		; A = 1 if timer expired, else 0, Z-flag = set according to A
	JR		NZ,Still_Running

; timer is expired, free it
	LD		A,(IY+8)
	CALL	FREE_SIGNAL
