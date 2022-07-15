#include <stdio.s>

r1start = $AA00
r2start = $AA00 + 26
r3start = $AA00 + 52

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
	LDA #$1
	STA r1offset
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
	CPX #$19 ; 25 dec
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
	CLC								; Clear carry flag
	LDA r1offset
	ADC #$40 ; to ascii letter
	STA putc					; Print char
	;
		; Print 2
	LDA r2offset
	ADC #$40 ; to ascii letter
	STA putc					; Print char

	LDA r3offset
	ADC #$40 ; to ascii letter
	; STA putc					; Print char
	;
		; Print -
	LDA #" "
	STA putc					; Print char
	;

done:								; This will loop back to start
	pla
	rti
