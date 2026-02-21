; tab=8

.debuginfo		on

.define	FILE		"FamilyBasicV3.nes"

	.include	"nes.inc"
	.include	"FDS/fds.inc"

_Reset	=		$80ba
pNmiTrampoline	= 	$ed


.segment "CHR"
	.incbin FILE, $10+$8000, $2000

; -------------------------------------------
.segment "PRG"
	.incbin		FILE, $10, $5000

; ------ FDS suport---------------------------
.segment "FDS_PATCH"
.include	"FDS/fdslib.s"

; ------ RAM Top $7fff -----------------------
.segment "PATCH_0"
	.byte	$7f

.segment "PATCH_1"
	.byte	$80
.segment "PATCH_2"
	.byte	$80

; ------ NS-HUBASIC Title  ------------------
.segment "PATCH_D1"
	.byte	<strNS_HUDSON
.segment "PATCH_D2"
	.byte	>strNS_HUDSON


; ------ BGPUT, BGGET address ------------------
.segment "BGGETPUT_PATCH0"
	.byte >bgGetRam
.segment "BGGETPUT_PATCH1"
	.byte <bgGetRam
.segment "BGGETPUT_PATCH2"
	.byte >bgGetRam
.segment "BGGETPUT_PATCH3"
	.byte >bgGetRam
.segment "BGGETPUT_PATCH4"
	.byte <bgGetRam


; ------ RESET ----------------------------------
.segment "RESET_PATCH"
	jsr	_ResetPatch

; ------ TOKEN tabble moved ---------------------
.segment "TOKEN_PATCH0"
	.byte	<tTokenTable	
.segment "TOKEN_PATCH1"
	.byte	>tTokenTable	
.segment "TOKEN_PATCH2"
	.byte	<tTokenTable	
.segment "TOKEN_PATCH3"
	.byte	>tTokenTable	

; ------ Funcsion table moved -------------------
.segment "FUNCADDR_PATCH4"
	.addr	tCommandAddr
.segment "FUNCADDR_PATCH5"
	.addr	tCommandAddr+1
.segment "FUNCADDR_PATCH6"
	.addr	tCommandAddr
.segment "FUNCADDR_PATCH7"
	.addr	tCommandAddr+1

;------ Interrupt vectors -------------------------
.segment "VECTORS_PATCH"
	.addr		pNmiTrampoline					; NMI #1
	.addr		pNmiTrampoline					; NMI #2
	.addr		bypass						; NMI #3, default
	.addr		_Reset						; Reset
	.addr		_Reset						; IRQ

