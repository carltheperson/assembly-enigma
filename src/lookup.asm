; The purpose of this file is to create a sort of lookup table.
; It is indexed as such:
; [rotor lookup start addrress] + [letter position] = [letter position]
; This lookup table allows you to look up the opisite of config_loading.asm
; Where config_loading.asm maps a letter to what it swaps (e.g. A -> X)
; This creates a lookup table to index the other way around (e.g. X -> A)

LDX #$0
r1_lookup_creation:
	INX
	LDA r1start, x
	CLC
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	TAY
	TXA
	STA r1lookup, y 
	CPX #$1A
	BNE r1_lookup_creation

LDX #$0
r2_lookup_creation:
	INX
	LDA r2start, x
	CLC
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	TAY
	TXA
	STA r2lookup, y 
	CPX #$1A
	BNE r2_lookup_creation

LDY #$0
r3_lookup_creation:
	INX
	LDA r3start, x
	CLC
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	TAY
	TXA
	STA r3lookup, y 
	CPX #$1A
	BNE r3_lookup_creation