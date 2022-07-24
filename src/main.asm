#include <stdio.s>

; The starting memory addresses where rotor config is defined.
; See config_loading.asm
r1start = $AC00
r2start = $AC00 + 27
r3start = $AC00 + 54
refstart = $AC00 + 81

; The starting memory addresses where rotor backwards lookup is defined.
; see lookup.asm
r1lookup = $AA00
r2lookup = $AA00 + 27
r3lookup = $AA00 + 54

; Where the rotor offsets are stored in memory.
; An offset indicates how much a given rotor is rotated.
r1offset = $1F
r2offset = $1E
r3offset = $0D

r1rotor_notch = $3 ; This will decide when r2 will rotate
r2rotor_notch = $5 ; This will decide when r3 will rotate

#include <./../../src/config.asm>
#include <./../../src/config_loading.asm>
#include <./../../src/lookup.asm>

; IO stuff
LDA #<ISR
STA $FFFE
LDA #>ISR
STA $FFFF
CLI

set_initial_offsets:
	LDA #$0
	STA r1offset
	LDA #$1
	STA r2offset
	STA r3offset

; IO stuff
loop:
	wai
  JMP loop
ISR pha

; The below code will run on each character input

; Re-loop if character pressed is a space
LDA getc
CMP #" "
BNE possibly_rotate_r1
STA putc
JMP done

;  ------- Rotate rotors -------
; The logic does this for each rotor:
; 	Compare current offset to 26
; 		a. If 26; set offset to 0
; 		b. If not 26; increment offset
; Rotor 2 and 3 has extra logic for rotor notches.
; They only rotate if a notch hits them.

possibly_rotate_r1:
	CLC
	LDX r1offset
	CPX #$1A
	BNE rotate_r1
	LDX	#$0
rotate_r1:
	CLC
	INX
	STX r1offset
possibly_rotate_r2:
	; X holds r1 
	CPX #r1rotor_notch ; Does r1 hit the notch? Should r2 rotate?
	BNE start_indexing ; If not, stop rotations
	; Normal rotation logic
	LDX r2offset
	CPX #$1A 
	BNE rotate_r2
	LDX	#$0
rotate_r2:
	CLC
	INX
	STX r2offset
possibly_rotate_r3:
	; X holds r2
	CPX #r2rotor_notch ; Does r2 hit the notch? Should r3 rotate?
	BNE start_indexing ; If not, stop rotations
	; Normal rotaiton logic
	LDX r3offset
	CPX #$1A 
	BNE rotate_r3
	LDX	#$0
rotate_r3:
	CLC
	INX
	STX r3offset


; ------- Passing through the rotors the first time -------
; The goal here (for each rotor) is to take a letter and output which letter
; it is swapped to, while taking rotor offset into account.
; The logic is as follows:
; 	1. Convert the letter to a letter position
; 	2. Add offset to it. This results in a number between 2 and 52
;		3. If the number is greater than 25
;				a. Subtract 25


start_indexing:
	CLC
index1: ; --- Take typed char and get placement on rotor1 with offset.
	LDA getc
	SBC #$5F ; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
	ADC r1offset ; Adding offset. Now we have a number between 2 and 52
	TAX 
	ADC #$65 ; Done to potentially overflow. Will overflow if > 25
	BVC done1 ; If not overflovn
	TXA
	SBC #$19 ; If overflown (number > 25); Subtract 25 from original number
	CLC
	TAX
done1:
	CLC
	LDA r1start, x ; Extract position on rotor using now offset number
	SBC #$5F ; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
index2: ; --- Take the char from r1 and get placement on r2 with offset
	CLC
	ADC r2offset ; Adding offset. Now we have a number between 2 and 52
	TAX
	ADC #$65 ; Done to potentially overflow. Will overflow if > 25
	BVC done2 ; If not overflovn
	TXA
	SBC #$19 ; If overflown (number > 25); Subtract 25 from original number
	CLC
	TAX
done2:
	CLC
	LDA r2start, x ; Extract position on rotor using now offset number
	SBC #$5F ; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC
index3: ; --- Take the char from r2 and get placement on r3 with offset
	CLC	
	ADC r3offset ; Adding offset. Now we have a number between 2 and 52
	TAX
	ADC #$65 ; Done to potentially overflow. Will overflow if > 25
	BVC done3 ; If not overflovn
	TXA
	SBC #$19 ; If overflown (number > 25); Subtract 25 from original number
	CLC
	TAX
done3:
	CLC
	LDA r3start, x ; Extract position on rotor using now offset number
	SBC #$5F ; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC

; ------- Getting reflected back using the reflector -------

reflection:
	CLC
	TAX
	LDA refstart, x
	SBC #$5F ; Converting the letter to a number. e.g. a=1, b=2, z=26
	CLC


; ------- Passing through the rotors the second time (Back) -------
; Here we need to use the lookup table from lookup.asm
; Then offset backwards (by Subtracting the offset)
; The logic is this:
; 	1. Lookup the backwards position from lookup.asm
; 	2. Add 25 to it. We now a number between 2 and 52
; 	3. Subtract the offset from it
;		4. If the number is greater than 25
;				a. Subtract 25

start_indexing_b:
	CLC
index3_b: ; --- Take the char from r3 and get placement on r3 with offset (backwards)
	TAX
	LDA r3lookup, x ; Index letter backwards. See lookup.asm
	ADC #$1B ; Add 25
	CLC
	SBC r3offset ; Subtract offset
	CLC
	TAX
	ADC #$65 ; Done to potentially overflow. Will overflow if > 25
	BVC done3_b ; If not overflovn
	TXA
	SBC #$19 ; If overflown (number > 25); Subtract 25 from original number
	CLC
	TAX
done3_b:
	TXA
index2_b: ; --- Take the char from r3 (backwards) and get placement on r2 with offset (backwards)
	TAX
	LDA r2lookup, x ; Index letter backwards. See lookup.asm
	ADC #$1B ; Add 25
	CLC
	SBC r2offset ; Subtract offset
	CLC
	TAX
	ADC #$65 ; Done to potentially overflow. Will overflow if > 25
	BVC done2_b ; If not overflovn
	TXA
	SBC #$19 ; If overflown (number > 25); Subtract 25 from original number
	CLC
	TAX
done2_b:
	TXA
index1_b:  ; --- Take the char from r2 (backwards) and get placement on r1 with offset (backwards)
	TAX
	LDA r1lookup, x ; Index letter backwards. See lookup.asm
	ADC #$1B  ; Add 25
	CLC
	SBC r1offset ; Subtract offset
	CLC
	TAX
	ADC #$65 ; Done to potentially overflow. Will overflow if > 25
	BVC done1_b ; If not overflovn
	TXA
	SBC #$19  ; If overflown (number > 25); Subtract 25 from original number
	CLC
	TAX
done1_b: ; We're done!
	TXA
	ADC #$60 ; Add $60 to letter position to convert to ASCII letter
	STA putc ; Print

; This will loop back to start
done:
	pla
	rti
