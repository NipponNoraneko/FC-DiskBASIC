; tab=8

zEditAddr	=	zpPokeAddr		; basic zp override
						; zpPokeAddrはPOKE以外で使われていない(多分)
STOP_KEY	=	$03
BS_KEY		=	$08
CR_KEY		=	$0d
LEFT_KEY	=	$1c
RIGHT_KEY	=	$1d
UP_KEY		=	$1e
DOWN_KEY	=	$1f

;------------------------------------------------------------------------------
;	HexCharCheck:	
;		IN:	A = Check code
;		OUT:	CY=ON	not Hex Char
;			  =OFF	Hex Char
;
HexCharCheck:
	cmp	#'0'
	bmi	HCCErr
	cmp	#'G'
	bpl	HCCErr

	cmp	#':'
	bmi	HCCEnd
	cmp	#'A'
	bmi	HCCErr
HCCEnd:
	clc
	rts
HCCErr:
	sec
	rts

;------------------------------------------------------------------------------
;	InputBytes:	アドレス入力
;
InputBytes:
	ldx	#$00
	stx	nibbleCnt
	stx	inputCharCnt
	dex
	stx	inputCharBuf
		
@RALoop:
	jsr	ReadChar
	jsr	HexCharCheck
	bcc	@RA15					; is hex char

	cmp	#BS_KEY					; Backspace
	bne	@RA13					; no
	lda	inputCharCnt
	beq	@RA13					; not yet entered
	jsr	Backspace
	dec	inputCharCnt
	jmp	@RALoop
@RA13:
	cmp	#CR_KEY					; CR
	bne	@RA14
	rts
@RA14:
	jsr	ShortBeep
	jmp	@RALoop
@RA15:
	pha
	jsr	PrintOneChar

	inc	nibbleCnt
	lda	#$02
	cmp	nibbleCnt
	bne	@RA20
	lda	#$00
	sta	nibbleCnt
@RA20:
	pla
	ldx	inputCharCnt
	sta	inputCharBuf,x
	inx

	lda	#$ff
	sta	inputCharBuf,x
	stx	inputCharCnt

	cpx	reqBytes
	bne	@RALoop

	rts

;--------------------------------------------------------
reqBytes:
	.res		1
inputCharCnt:
	.res		1
inputCharBuf:
	.res		4+1

;------------------------------------------------------------------------------
;
FromInput:
							;---" FROM:$"
	lda	#<sFrom
	sta	zpOutputStr
	lda	#>sFrom
	sta	zpOutputStr+1
	jsr	PrintString
							;--- アドレス入力
	lda	#4
	sta	reqBytes
	jsr	InputBytes

	lda	inputCharCnt
	bne	@FI10
							;--- 入力なし
	sec

	rts
@FI10:
	jsr	DoCRLF
	jsr	Asc2Bin					; アドレス変換

	clc
@FIEnd:
	rts

;------------------------------------------------------------------------------
;
KetaCheck:
	lda	inputCharCnt
	cmp	#$3
	bpl	@KC10
							;--  アドレス3桁未満
	lda	binA2B
	sta	monPtr+1
	lda	#$00
	sta	monPtr+2
	beq	@KCEnd
@KC10:							;--- 3桁以上
	lda	binA2B
	sta	monPtr+2
	lda	binA2B+1
	sta	monPtr+1
@KCEnd:
	rts

;------------------------------------------------------------------------------
;	DumpBody:	ダンプ本体
;
DumpBody:
	jsr	KetaCheck

	lda	#$00
	sta	zpCH
	sta	tmpBufPos
							;--- Header line
	ldy	#28
@DB10:	
	lda	#$ed					; ─
	cpy	#24
	bne	@DB15
	lda	#$EA					; ┬
@DB15:
	jsr	QueueCharForOutput
	dey
	bne	@DB10
	jsr	PrintOutBuf
							;--- ADDRESS
	lda	#$00
	tay
@DBLoop:
	pha
	lda	monPtr+2
	jsr	Bin2HexQ
	lda	monPtr+1
	jsr	Bin2HexQ
							;--- DATA
	ldy	#$00
	lda	#$ee					; │
	jmp	@DB60
@DBByteLoop:
	lda	#' '
@DB60:
	jsr	QueueCharForOutput
	jsr	GetMonByte
	jsr	Bin2HexQ
	iny
	cpy	#$08
	bne	@DBByteLoop
							;--- End 1 line
	jsr	QueueNullForOutput
	jsr	PrintOutBuf
							;--- update line addr
	lda	GetMonByte+1
	clc
	adc	#$08
	bcc	@DB20
	inc	GetMonByte+2
@DB20:
	sta	GetMonByte+1
							;--- end check (16line)
	pla
	clc
	adc	#1
	cmp	#16
	bne	@DBLoop					; not end

	rts

;------------------------------------------------------------------------------
;	Dump
;
Dump:
							;--- Put "DUMP"
	lda	#<sDump
	sta	zpOutputStr
	lda	#>sDump
	sta	zpOutputStr+1
	jsr	PrintString

	jsr	FromInput				;--- アドレス入力
	bcs	DumpErr					; 入力無し

	jsr	DumpBody				;

	lda	#0
	sta	dirty

	clc

	rts

DumpErr:
	lda	#$ff
	sta	dirty

	jsr	DoCRLF
	jsr	ShortBeep

	clc

	rts

;------------------------------------------------------------------------------
;
GetMonByte:
monPtr:	lda	GetMonByte,y

	rts

;------------------------------------------------------------------------------
;
ModByte:
	jsr	HexCharCheck
	bcs	@MBErr
@MB02:
	pha
							;--- edit addr
	lda	binA2B+1
	sta	zEditAddr
	lda	binA2B
	sta	zEditAddr+1

	ldx	nibbleCnt
	bne	@MB10					; lower nibble
							;----- upper nibble
	ldx	#$0f
	stx	nibbleMask

	pla
	asl	a
	asl	a
	bcc	@MB05
	clc
	adc	#$26
@MB05:
	asl	a
	asl	a
	and	#$f0
	jmp	@MB20
							;----- lower nibble
@MB10:
	dec	zpCH					; adjust H pos for HEX out

	ldx	#$f0
	stx	nibbleMask

	pla
	sec
	sbc	#'0'
	cmp	#$0a
	bmi	@MB20					; "0" ~ "9"

	and	#$0f
	clc
	adc	#$09					; "A" ~ 
@MB20:
	ldy	tmpBufPos
	tax
	lda	nibbleMask
	and	(zEditAddr),y
	sta	(zEditAddr),y
	txa
	ora	(zEditAddr),y
	sta	(zEditAddr),y

	jsr	Bin2HexQ
	jsr	PrintOutBuf

	jsr	MMRight

	lda	tmpCV
	sta	zpCV

	rts
@MBErr:
	jsr	ShortBeep

	rts

;--------------------------------------------------------
nibbleMask:
	.res		1

;------------------------------------------------------------------------------
;
ModifyMode:
	lda	dirty
	beq	@MM10
							;--- "MODIFY"
	lda	#<sModify
	sta	zpOutputStr
	lda	#>sModify
	sta	zpOutputStr+1
	jsr	PrintString

	jsr	FromInput
	bcs	@MMErr

	jsr	DumpBody				; dump出力

	lda	#0
	sta	dirty
@MM10:
	lda	zpCH
	sta	zpCHsav

	lda	zpCV
	tax
	dex
	stx	zpCVsav
	sec
	sbc	#16					; 16行上へ
	sta	zpCV
	sta	tmpCV
	sta	topCV

	lda	#$05
	sta	zpCH
	sta	tmpCH

	ldy	#$00
	sty	nibbleCnt
@MMCursor:						;----- 
	jsr	ReadChar

	cmp	#LEFT_KEY				; →
	beq	@JMMRight
	cmp	#'L'					; →
	beq	@JMMRight

	cmp	#RIGHT_KEY				; ←
	beq	@JMMLeft
	cmp	#'H'					; ←
	beq	@JMMLeft

	cmp	#UP_KEY					; ↑
	beq	@JMMUp
	cmp	#'K'					; ↑
	beq	@JMMUp

	cmp	#DOWN_KEY				; ↓
	beq	@JMMDown
	cmp	#'J'					; ↓
	beq	@JMMDown

	cmp	#'Q'
	beq	@MMEnd					; 終了
	cmp	#':'					; :
	beq	@MMEnd

	jsr	ModByte
	jmp	@MMCursor
@MMErr:
	jsr	DoCRLF
	jsr	ShortBeep
	clc
	rts
@MMEnd:
	lda	zpCVsav
	sta	zpCV
	lda	zpCHsav
	sta	zpCH

	clc

	rts

;--------------------------------------------------------
@JMMRight:
	jsr	MMRight
	jmp	@MMCursor
@JMMLeft:
	jsr	MMLeft
	jmp	@MMCursor
@JMMDown:
	jsr	MMDown
	jmp	@MMCursor
@JMMUp:
	jsr	MMUp
	jmp	@MMCursor

;------------------------------------------------------------------------------
;
MMLeft:
	ldx	tmpCH
	dex
	cpx	#$05
	bmi	@MML10

	stx	tmpCH
	stx	zpCH

	dec	nibbleCnt
	bmi	@MML05
		
	rts

@MML05:
	lda	#$02
	sta	nibbleCnt
	dec	tmpBufPos

	jsr	MMLeft

	rts

@MML10:
	lda	#01
	sta	nibbleCnt

	lda	#27
	sta	tmpCH
	sta	zpCH

	lda	tmpBufPos
	clc
	adc	#$08-1
	sta	tmpBufPos

	jsr	MMUp

	rts

;------------------------------------------------------------------------------
;
MMRight:
	ldx	tmpCH
	inx
	cpx	#28
	beq	MMRNextLine
	bpl	MMErr

	stx	zpCH
	stx	tmpCH

	inc	nibbleCnt
	ldx	#$02
	cpx	nibbleCnt
	beq	@MMR10

	rts
@MMR10:
	ldx	#$ff
	stx	nibbleCnt

	inc	tmpBufPos
		
	jsr	MMRight

	rts

MMRNextLine:
							;--- to next line head
	lda	#$00
	sta	nibbleCnt

	lda	#$05
	sta	tmpCH
	sta	zpCH

	jsr	MMDown

	lda	tmpBufPos
	sec
	sbc	#$07
	sta	tmpBufPos

	rts

;------------------------------------------------------------------------------
MMUp:
	ldx	tmpCV
	dex
	cpx	topCV
	bmi	MMErr
	stx	zpCV
	stx	tmpCV
		
	lda	tmpBufPos
	sec
	sbc	#$08
	sta	tmpBufPos

	rts
		
;------------------------------------------------------------------------------
MMDown:
	ldx	tmpCV
	cpx	zpCVsav
	beq	MMErr

	inx
	stx	zpCV
	stx	tmpCV
		
	lda	tmpBufPos
	clc
	adc	#$08
	sta	tmpBufPos

	rts

;--------------------------------------------------------
MMErr:
	jsr	ShortBeep				; short BEEP

	rts

;--------------------------------------------------------
tmpCV:	.res	1
tmpCH:	.res	1
topCV:	.res	1
topCH:	.res	1
nibbleCnt:
	.res	1
dirty:	.res	1



;------------------------------------------------------------------------------
;
Fill:
							;--- Put "FILL"
	lda	#<sFill
	sta	zpOutputStr
	lda	#>sFill
	sta	zpOutputStr+1
	jsr	PrintString

	jsr	FromInput
	jsr	DoCRLF
							;--- Put "TO:$"
	lda	#<sTo
	sta	zpOutputStr
	lda	#>sTo
	sta	zpOutputStr+1
	jsr	PrintString
	lda	#4
	sta	reqBytes
	jsr	InputBytes
	jsr	DoCRLF
							; 大小比較


							;--- Put "VAL:$"
	lda	#<sVal
	sta	zpOutputStr
	lda	#>sVal
	sta	zpOutputStr+1
	jsr	PrintString

	lda	#2
	sta	reqBytes
	jsr	InputBytes

	lda	#$ff
	sta	dirty

	clc

	rts

;--------------------------------------------------------
sDump:	.asciiz		"DUMP"
sModify:.asciiz		"MODIFY"
sFill:	.asciiz		"FILL"
sFrom:	.asciiz		" FROM:$"
sTo:	.asciiz		"        TO:$"
sVal:	.asciiz		"       VAL:$"

GetOneChar:
	jsr	ReadChar
	ldx	zpRkimMidMacro
	bne	GetOneChar

	sta	readChar

	rts

readChar:
	.res	1

;------------------------------------------------------------------------------
;	MonPrompt:
;
MonPrompt:
	clc
MPRET:
	bcs	MPExit
@MP01:
	jsr	DoCRLF
	lda	#$b3					; ']'
	jsr	PrintOneChar
@MPLoop:
	jsr	GetOneChar
	jsr	PrintOneChar				; key echo

	ldx	#0
@MP10:
	lda	monCmds,x
	cmp	readChar
	beq	@MP20
	cmp	#$ff
	beq	@MP01

	inx
	inx
	inx

	lda	#$ff
	sta	dirty
	bne	@MP10
@MP20:
	inx
	lda	monCmds,x
	sta	zEditAddr
	lda	monCmds+1,x
	sta	zEditAddr+1
	
	dec	zpCH

	lda	#>(MPRET-1)
	pha
	lda	#<(MPRET-1)
	pha

	clc
	jmp	(zEditAddr)
MPExit:
	sec

	rts
MPEnd:
	lda	readChar
	jsr	PrintOneChar				; key echo

	lda	#$ff
	sta	dirty

	clc

	rts


;--------------------------------------------------------
monCmds:
	.byte	STOP_KEY
	.addr	MPExit

	.byte	'Q'
	.addr	MPExit

	.byte	CR_KEY
	.addr	MPEnd

	.byte	' '
	.addr	MPEnd

	.byte	'D'
	.addr	Dump

	.byte	'M'
	.addr	ModifyMode

	.byte	'F'
	.addr	Fill

	.byte	$ff					; end

;------------------------------------------------------------------------------
;
CmdMON:
	lda	#$ff
	sta	dirty

	jsr	MonPrompt
	bcc	CmdMON

	jsr	TxtPtrIncr

	rts

;--------------------------------------------------------
tmpBufPos:
	.res	1
zpCHsav:
	.res	1
zpCVsav:
	.res	1
