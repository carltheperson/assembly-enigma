; --------- Setup start --------- 

#include <stdio.s>

  LDA #<ISR
  STA $FFFE
  LDA #>ISR
  STA $FFFF
  CLI

loop:
	wai
  JMP loop

LDX #$0 ; We use X to keep state; 0=null, 1=encrypt, 2=decrypt

; Start ISR
ISR pha

; --------- Setup end --------- 

start:
	CPX #$0 ; If we have not decided if encrypt or decrypt
	BEQ compare_and_set_flag
	CPX #$1 ; If we have decided encrypt
	BEQ encrypt
	CPX #$2 ; If we have decided decrypt
	BEQ decrypt

compare_and_set_flag:
	LDX getc
	CPX #"e"
	BEQ set_encrypt_flag
	CPX #"d"
	BEQ set_decrypt_flag
	JMP error

set_encrypt_flag:
	LDX #$1
	LDA #"5"
	STA putc
	JMP done

set_decrypt_flag:
	LDX #$2
	LDA #"4"
	STA putc
	JMP done

encrypt:
	LDA #"E"
	STA putc
	JMP done

decrypt:
	LDA #"D"
	STA putc

done:
	LDA getc
	pla
	rti

error:
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