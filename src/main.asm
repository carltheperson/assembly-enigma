#include <stdio.s>

r1start = $AC00
r2start = $AC00 + 27
r3start = $AC00 + 54
refstart = $AC00 + 81

r1lookup = $AA00
r2lookup = $AA00 + 27
r3lookup = $AA00 + 54

temp = $2F

r1offset = $1F
r2offset = $1E
r3offset = $0D

r1rotor_notch = $A ; J.  This will decide when r2 will rotate
r2rotor_notch = $A ; E. This will decide when r3 will rotate

#include <./../../src/config.asm>
#include <./../../src/config_loading.asm>
#include <./../../src/lookup.asm>

LDA #<ISR
STA $FFFE
LDA #>ISR
STA $FFFF
CLI

set_offsets:
	LDA #$0
	STA r1offset
	LDA #$1
	STA r2offset
	STA r3offset

loop:
	wai
  JMP loop

ISR pha


; Ignore space
LDA getc
CMP #" "
BNE possibly_rotate_r1
STA putc
JMP done

;  ----- Rotate rotors -----

possibly_rotate_r1:
	CLC								; Clear carry flag
	LDX r1offset
	CPX #$1A ; 25 dec
	BNE rotate_r1
	LDX	#$0
rotate_r1:
	CLC								; Clear carry flag
	INX
	STX r1offset
possibly_rotate_r2:
	; X holds r1 
	LDX r1offset
	CPX #r1rotor_notch ; Does r1 hit the notch? Should r2 rotate?
	BNE start_indexing 
	; We now want to rotate r2
	LDX r2offset
	CPX #$1A ; 26 dec
	BNE rotate_r2
	LDX	#$0
rotate_r2:
	CLC								; Clear carry flag
	INX
	STX r2offset
possibly_rotate_r3:
	; X holds r2
	CPX #r2rotor_notch ; Does r2 hit the notch? Should r3 rotate?
	BNE start_indexing 
	; We now want to rotate r3
	LDX r3offset
	CPX #$1A ; 26 dec
	BNE rotate_r3
	LDX	#$0
rotate_r3:
	CLC								; Clear carry flag
	INX
	STX r3offset


; ------ Passing through the rotors the first time -------

start_indexing:
	CLC
index1: ; --- Take typed char and get placement on rotor1 with offset.
	LDA getc
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC								; Clear carry flag
	ADC r1offset 			; Adding offset to it ; Now we have a number like (1 to 26) + (1 to 26) in A
	TAX 
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done1 ; If not overflovn
	TXA
	SBC #$19 ;  - 25
	CLC
	TAX
done1:
	CLC
	LDA r1start, X
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
index2: 	; --- Take the char r1 points to and get placement on rotor2 with offset.
	CLC								; Clear carry flag
	ADC r2offset 			; Adding offset to it ; Now we have a number like (1 to 26) + (1 to 26) in A
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done2 ; If not overflovn
	TXA
	SBC #$19 ;  - 25
	CLC
	TAX
done2:
	CLC
	LDA r2start, X
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
index3: 	; --- Take the char r2 points to and get placement on rotor3 with offset.
	CLC								; Clear carry flag
	ADC r3offset 			; Adding offset to it ; Now we have a number like (1 to 26) + (1 to 26) in A
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done3 ; If not overflovn
	TXA
	SBC #$19 ;  - 25
	CLC
	TAX
done3:
	CLC
	LDA r3start, X
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC

; ---------- Getting reflected back using the reflector --------

reflection:
	CLC
	TAX
	LDA refstart, X
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC


; ------ Passing through the rotors the second time (Back) -------

start_indexing_b:
	CLC
index3_b: 	; --- Take the char r2 points to and get placement on rotor3 with offset.
	TAX
	LDA r3lookup, x
	; We now have the letter looked up. Time to offset
	ADC #$1B 
	CLC
	SBC r3offset
	CLC
	; (26 + Ø) is in A
	; A is now 0 - 52
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done3_b ; If not overflovn
	TXA
	SBC #$19
	CLC
	TAX
done3_b:
	TXA
index2_b:
	TAX
	LDA r2lookup, x
	; We now have the letter looked up. Time to offset
	ADC #$1B 
	CLC
	SBC r2offset
	CLC
	; (26 + Ø) is in A
	; A is now 0 - 52
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done2_b ; If not overflovn
	TXA
	SBC #$19
	CLC
	TAX
done2_b:
	TXA
index1_b:
	TAX
	LDA r1lookup, x
	; We now have the letter looked up. Time to offset. Backwards
	ADC #$1B 
	CLC
	SBC r1offset
	CLC
	; (26 + Ø) is in A
	; A is now 0 - 52
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done1_b ; If not overflovn
	TXA
	SBC #$19
	CLC
	TAX
done1_b:
	TXA
	ADC #$60
	STA putc

done:								; This will loop back to start
	pla
	rti