; --------- Setup start --------- 

#include <stdio.s>

offset = 5

LDA #<ISR
STA $FFFE
LDA #>ISR
STA $FFFF
CLI

loop:
	wai
  JMP loop

; We use X to keep state; 0=null, 1=encrypt, 2=decrypt
LDX #$0 ; We initialize it to 0

ISR pha

; --------- Setup end --------- 

start:
	CPX #$0 									; If user has not yet decided if encrypt or decrypt; X = 0
	BEQ compare_and_set_flag
	CPX #$1									  ; If user has decided encrypt; X = 1
	BEQ encrypt
	CPX #$2 									; If user has decided decrypt; X = 2
	BEQ decrypt

compare_and_set_flag:
	LDX getc
	CPX #"e"							; User has decided encrypt
	BEQ set_encrypt_flag
	CPX #"d"							; User has decided decrypt
	BEQ set_decrypt_flag
	JMP error							; User did not pick "e" or "d". Displaying "ERROR"

set_encrypt_flag:
	LDX #$1						; Setting X to 1
	JMP done

set_decrypt_flag:
	LDX #$2						; Setting X to 2
	JMP done

encrypt:
	LDA getc					; Get typed char into A
	CLC								; Clear carry flag
	ADC #offset				; Add our offset to A
	STA putc					; Print char
	JMP done

decrypt:
	LDA getc					; Get typed char into A
	SBC #offset				; Subtract our offset from A
	STA putc					; Print char

done:								; This will loop back to start
	LDA getc
	pla
	rti

error:							; Print "ERROR"
		LDA #"E"
		STA putc
		LDA #"R"
		STA putc
		LDA #"R"
		STA putc
		LDA #"O"
		STA putc
		LDA #"R"
		STA putc
		pla
		rti
