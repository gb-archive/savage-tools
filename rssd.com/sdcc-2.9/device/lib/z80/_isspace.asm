;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 2.9.0 #5416 (Apr  7 2010) (MINGW32)
; This file was generated Sun Apr 11 14:38:22 2010
;--------------------------------------------------------
	.module _isspace
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _isspace
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; overlayable items in  ram 
;--------------------------------------------------------
	.area _OVERLAY
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;../_isspace.c:24: char isspace (unsigned char c) 
;	---------------------------------
; Function isspace
; ---------------------------------
_isspace:
	push	ix
	ld	ix,#0
	add	ix,sp
;../_isspace.c:27: if ( c == ' '  ||
	ld	a,4 (ix)
	sub	a,#0x20
	jr	Z,00101$
;../_isspace.c:28: c == '\f' ||
	ld	a,4 (ix)
	sub	a,#0x0C
	jr	Z,00101$
;../_isspace.c:29: c == '\n' ||
	ld	a,4 (ix)
	sub	a,#0x0A
	jr	Z,00101$
;../_isspace.c:30: c == '\r' ||
	ld	a,4 (ix)
	sub	a,#0x0D
	jr	Z,00101$
;../_isspace.c:31: c == '\t' ||
	ld	a,4 (ix)
	sub	a,#0x09
	jr	Z,00101$
;../_isspace.c:32: c == '\v' ) 
	ld	a,4 (ix)
	sub	a,#0x0B
	jr	NZ,00102$
00101$:
;../_isspace.c:33: return 1;
	ld	l,#0x01
	jr	00108$
00102$:
;../_isspace.c:34: return 0;
	ld	l,#0x00
00108$:
	pop	ix
ret
	.area _CODE
	.area _CABS
