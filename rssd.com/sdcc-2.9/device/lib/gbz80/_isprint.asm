;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 2.9.0 #5416 (Apr  7 2010) (MINGW32)
; This file was generated Fri Jun 11 23:46:53 2010
;--------------------------------------------------------
	.module _isprint
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _isprint
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
;../_isprint.c:24: char isprint (unsigned char c) 
;	---------------------------------
; Function isprint
; ---------------------------------
_isprint:
	
;../_isprint.c:27: if ( c >= '\x20' && c <= '\x7e') 
	lda	hl,2(sp)
	ld	a,(hl)
	sub	a,#0x20
	jp	C,00102$
	ld	a,#0x7E
	sub	a,(hl)
	jp	C,00102$
;../_isprint.c:28: return 1;
	ld	e,#0x01
	jp	00104$
00102$:
;../_isprint.c:29: return 0;
	ld	e,#0x00
00104$:
	
ret
	.area _CODE
	.area _CABS
