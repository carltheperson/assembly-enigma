LDY #$0
r1_lookup:
	CLC
	INY
	TYA
	TAX
	LDA r1start, x
	CLC
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	TAX
	TYA
	; In A we have Y
	; In X we have letter for Y
	STA r1lookup, x ; Storing our index (1 to start then 2, 3, ...) in the place of our letter. 

	CPY #$1A
	BNE r1_lookup; If not 26 repeat

LDY #$0
r2_lookup:
	CLC
	INY
	TYA
	TAX
	LDA r2start, x
	CLC
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	TAX
	TYA
	; In A we have Y
	; In X we have letter for Y
	STA r2lookup, x ; Storing our index (1 to start then 2, 3, ...) in the place of our letter. 

	CPY #$1A
	BNE r2_lookup; If not 26 repeat

LDY #$0
r3_lookup:
	CLC
	INY
	TYA
	TAX
	LDA r3start, x
	CLC
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	TAX
	TYA
	; In A we have Y
	; In X we have letter for Y
	STA r3lookup, x ; Storing our index (1 to start then 2, 3, ...) in the place of our letter. 

	CPY #$1A
	BNE r3_lookup; If not 26 repeat