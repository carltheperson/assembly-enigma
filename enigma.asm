#include <stdio.s>

r1start = $AA00
r2start = $AA00 + 26
r3start = $AA00 + 52

r1offset = $A0FD
r2offset = $A0FE
r3offset = $A0FF

#include <./../../enigma_config.asm>
#include <./../../enigma_config_loading.asm>

LDA #<ISR
STA $FFFE
LDA #>ISR
STA $FFFF
CLI

loop:
	wai
  JMP loop

ISR pha

start:
	LDA r1start + 1
	STA putc					; Print char


done:								; This will loop back to start
	pla
	rti
