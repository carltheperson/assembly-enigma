#include <stdio.s>

r1start = $AA00
r2start = $AA00 + 27
r3start = $AA00 + 54

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

; Remember You can use subrutines. You just have to know where to return.
; Use X, Y, A for parameters and return.



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

; I need a function that takes.
; A letter + offset = new offset

done_rotations:
	CLC								; Clear carry flag
	; --- Take typed char and get placement on rotor1 with offset.
	LDA getc
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	ADC r1offset 			; Adding offset to it
	CMP #$1A ; >= 26 dec
	BNE continue1
	SBC #$1A ; -  26 dec
	; ----
continue1:
	TAX
	LDA r1start, X
	SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26


	

	; SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26
	; CLC								; Clear carry flag
	; LDA r1start, X
	; SBC #$5F					; Converting the letter to a number. e.g. a=1, b=2, z=26

	; TAX
	; LDA r2start, X
	; STA putc					; Print char
	

	; You now have a letter. 
	; This letter should be converted to a number.
	; Then you will know how to index the second rotor

	; LDX r2offset
	; CLC								; Clear carry flag
	; LDA r2start, X
	; STA putc					; Print char

	; LDA r1offset
	; ADC #$40 ; to ascii letter
	; STA putc					; Print char
	; ;
	; 	; Print 2
	; LDA r2offset
	; ADC #$40 ; to ascii letter
	; STA putc					; Print char

	; LDA r3offset
	; ADC #$40 ; to ascii letter
	; ; STA putc					; Print char
	; ;
		; Print -
	LDA #" "
	STA putc					; Print char
	;

done:								; This will loop back to start
	pla
	rti
