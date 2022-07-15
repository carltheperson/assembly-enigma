#include <stdio.s>

r1start = $AA00
r2start = $AA00 + 27
r3start = $AA00 + 54
refstart = $AA00 + 81

r1offset = $1F
r2offset = $1E
r3offset = $0D

r1rotor_notch = $A ; J.  This will decide when r2 will rotate
r2rotor_notch = $A ; E. This will decide when r3 will rotate

#include <./../../enigma_config.asm>
#include <./../../enigma_config_loading.asm>

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
	BNE done_rotations 
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
	BNE done_rotations 
	; We now want to rotate r3
	LDX r3offset
	CPX #$1A ; 26 dec
	BNE rotate_r3
	LDX	#$0
rotate_r3:
	CLC								; Clear carry flag
	INX
	STX r3offset


done_rotations:
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
	TAX
done1:
	LDA r1start, X
	STA putc					; Print char
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
index2: 	; --- Take the char r1 points to and get placement on rotor2 with offset.
	CLC								; Clear carry flag
	ADC r2offset 			; Adding offset to it ; Now we have a number like (1 to 26) + (1 to 26) in A
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done2 ; If not overflovn
	TXA
	SBC #$19 ;  - 25
	TAX
done2:
	LDA r2start, X
	STA putc					; Print char
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
index3: 	; --- Take the char r2 points to and get placement on rotor3 with offset.
	CLC								; Clear carry flag
	ADC r3offset 			; Adding offset to it ; Now we have a number like (1 to 26) + (1 to 26) in A
	TAX
	ADC #$65 ; Done to potentioally overflow. Will overflow if > 25
	BVC done3 ; If not overflovn
	TXA
	SBC #$19 ;  - 25
	TAX
done3:
	LDA r2start, X
	STA putc					; Print char
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26



	
		; Print -
	LDA #" "
	STA putc					; Print char
	;

done:								; This will loop back to start
	pla
	rti
