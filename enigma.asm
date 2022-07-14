#include <stdio.s>

LDA #<ISR
STA $FFFE
LDA #>ISR
STA $FFFF
CLI

r1start = $AA00
r2start = $AA00 + 26
r3start = $AA00 + 52

; ROTER 1
r1_a = "a"
r1_b = "b"
r1_c = "c"
r1_d = "d"
r1_e = "e"
r1_f = "f"
r1_g = "g"
r1_h = "h"
r1_i = "i"
r1_j = "j"
r1_k = "k"
r1_l = "l"
r1_m = "m"
r1_n = "n"
r1_o = "o"
r1_p = "p"
r1_q = "q"
r1_r = "r"
r1_s = "s"
r1_t = "t"
r1_u = "u"
r1_v = "v"
r1_w = "w"
r1_x = "x"
r1_y = "y"
r1_z = "z"

; ROTER 2
r2_a = "a"
r2_b = "b"
r2_c = "c"
r2_d = "d"
r2_e = "e"
r2_f = "f"
r2_g = "g"
r2_h = "h"
r2_i = "i"
r2_j = "j"
r2_k = "k"
r2_l = "l"
r2_m = "m"
r2_n = "n"
r2_o = "o"
r2_p = "p"
r2_q = "q"
r2_r = "r"
r2_s = "s"
r2_t = "t"
r2_u = "u"
r2_v = "v"
r2_w = "w"
r2_x = "x"
r2_y = "y"
r2_z = "z"

; ROTER 3
r3_a = "a"
r3_b = "b"
r3_c = "c"
r3_d = "d"
r3_e = "e"
r3_f = "f"
r3_g = "g"
r3_h = "h"
r3_i = "i"
r3_j = "j"
r3_k = "k"
r3_l = "l"
r3_m = "m"
r3_n = "n"
r3_o = "o"
r3_p = "p"
r3_q = "q"
r3_r = "r"
r3_s = "s"
r3_t = "t"
r3_u = "u"
r3_v = "v"
r3_w = "w"
r3_x = "x"
r3_y = "y"
r3_z = "z"

load_r1:
	LDA #r1_a
	STA r1start
	LDA #r1_b
	STA r1start + 1
	LDA #r1_c
	STA r1start + 2
	LDA #r1_d
	STA r1start + 3
	LDA #r1_e
	STA r1start + 4
	LDA #r1_f
	STA r1start + 5
	LDA #r1_g
	STA r1start + 6
	LDA #r1_h
	STA r1start + 7
	LDA #r1_i
	STA r1start + 8
	LDA #r1_j
	STA r1start + 9
	LDA #r1_k
	STA r1start + 10
	LDA #r1_l
	STA r1start + 11
	LDA #r1_m
	STA r1start + 12
	LDA #r1_n
	STA r1start + 13
	LDA #r1_o
	STA r1start + 14
	LDA #r1_p
	STA r1start + 15
	LDA #r1_q
	STA r1start + 16
	LDA #r1_r
	STA r1start + 17
	LDA #r1_s
	STA r1start + 18
	LDA #r1_t
	STA r1start + 19
	LDA #r1_u
	STA r1start + 20
	LDA #r1_v
	STA r1start + 21
	LDA #r1_w
	STA r1start + 22
	LDA #r1_x
	STA r1start + 23
	LDA #r1_y
	STA r1start + 24
	LDA #r1_z
	STA r1start + 25

load_r2:
	LDA #r2_a
	STA r2start
	LDA #r2_b
	STA r2start + 1
	LDA #r2_c
	STA r2start + 2
	LDA #r2_d
	STA r2start + 3
	LDA #r2_e
	STA r2start + 4
	LDA #r2_f
	STA r2start + 5
	LDA #r2_g
	STA r2start + 6
	LDA #r2_h
	STA r2start + 7
	LDA #r2_i
	STA r2start + 8
	LDA #r2_j
	STA r2start + 9
	LDA #r2_k
	STA r2start + 10
	LDA #r2_l
	STA r2start + 11
	LDA #r2_m
	STA r2start + 12
	LDA #r2_n
	STA r2start + 13
	LDA #r2_o
	STA r2start + 14
	LDA #r2_p
	STA r2start + 15
	LDA #r2_q
	STA r2start + 16
	LDA #r2_r
	STA r2start + 17
	LDA #r2_s
	STA r2start + 18
	LDA #r2_t
	STA r2start + 19
	LDA #r2_u
	STA r2start + 20
	LDA #r2_v
	STA r2start + 21
	LDA #r2_w
	STA r2start + 22
	LDA #r2_x
	STA r2start + 23
	LDA #r2_y
	STA r2start + 24
	LDA #r2_z
	STA r2start + 25

load_r3:
	LDA #r3_a
	STA r3start
	LDA #r3_b
	STA r3start + 1
	LDA #r3_c
	STA r3start + 2
	LDA #r3_d
	STA r3start + 3
	LDA #r3_e
	STA r3start + 4
	LDA #r3_f
	STA r3start + 5
	LDA #r3_g
	STA r3start + 6
	LDA #r3_h
	STA r3start + 7
	LDA #r3_i
	STA r3start + 8
	LDA #r3_j
	STA r3start + 9
	LDA #r3_k
	STA r3start + 10
	LDA #r3_l
	STA r3start + 11
	LDA #r3_m
	STA r3start + 12
	LDA #r3_n
	STA r3start + 13
	LDA #r3_o
	STA r3start + 14
	LDA #r3_p
	STA r3start + 15
	LDA #r3_q
	STA r3start + 16
	LDA #r3_r
	STA r3start + 17
	LDA #r3_s
	STA r3start + 18
	LDA #r3_t
	STA r3start + 19
	LDA #r3_u
	STA r3start + 20
	LDA #r3_v
	STA r3start + 21
	LDA #r3_w
	STA r3start + 22
	LDA #r3_x
	STA r3start + 23
	LDA #r3_y
	STA r3start + 24
	LDA #r3_z
	STA r3start + 25


loop:
	wai
  JMP loop

ISR pha

start:
	LDA r3start + 1
	STA putc					; Print char


done:								; This will loop back to start
	pla
	rti
