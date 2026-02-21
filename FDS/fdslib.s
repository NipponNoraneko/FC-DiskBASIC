;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
.include	"basv3.inc"
.include	"fnc.inc"

;------------------------------------------------------------------------------
diskInfoStat:						; DiskInfoBlock読込み状態
	.byte	$00
fdsBuf:	.addr	diskBuf
loadFileType:
	.byte	$00
driveStat:						; ドライブ状態
	.byte	$00

strNS_HUDSON:
	.byte	"NS-HUBASIC V3.0D:"
.incbin	"datetime.s",0,10
	.byte	$00

;------------------------------------------------------------------------------
;
_ResetPatch:
	lda	#$10
	sta	PPU_CTRL
;	lda	#$0e
	lda	#$00
	sta	PPU_MASK
							;--- Wait V-SYNC 3Times
	ldy	#$03
@RP10:
	bit	PPU_STATUS
	bpl	@RP10
	dey
	bne	@RP10

	sty	diskInfoStat

	lda	#$27					; $27: |H-SCRL|READ|M-OFF|NO-RESET|
	sta	FDS_CTRL
	sta	FDS_CTRL_Mirror

	jsr	InitPpuApu

	lda	#>NMI
	sta	zpNmiTrampoline+2
	lda	#<NMI
	sta	zpNmiTrampoline+1

	rts

;------------------------------------------------------------------------------
NMI:
	pha
	lda	FDS_DRIVE_STATUS
	sta	driveStat
	pla

	jmp	NMI_DefaultHandler

;------------------------------------------------------------------------------
;	ShortBeep:
;
ShortBeep:
	lda	#$40
	jsr	KeyClick+2

	rts

;------------------------------------------------------------------------------
;	Wait
;
;		Ret:	Y = 0
WaitYff:
	lda	#$ff
@WaitJ10:
	clc
	adc	#$ff
	bne	@WaitJ10

	dey
	bne	WaitYff

	rts


;------------------------------------------------------------------------------
;	QueueStr:
;
;		IN		XY = strings address
;				 X: address Hi
;				 Y: address Low
;
strAddr	=	QS10+1
QueueStr:
	stx	strAddr+1
	sty	strAddr
	ldy	#$00
QS10:
	lda	QS10,y
	beq	@QSEnd

	jsr	QueueCharForOutput

	iny
	jmp	QS10
@QSEnd:
	rts


;------------------------------------------------------------------------------
;	QueueErrMsg:	
;
;		IN		A = error No.
;
QueueErrMsg:
	ora	#$00
	beq	@QEEnd

	pha
	ldx	#>sErr
	ldy	#<sErr
	jsr     QueueStr
	pla

	jsr	Bin2HexQ

@QEEnd:
	rts

sErr:	.byte	"! ERR.",0

;------------------------------------------------------------------------------
;	IncBCD:
;
IncBCD:
        clc
        adc     #1  
        tay
        and     #$0f
        cmp     #9  
        tya
        bcc     @IBEnd

        clc
        adc     #6  
@IBEnd:
        rts

;------------------------------------------------------------------------------
;	Add16:		tmpAccm = tmpAccm + tmpAccm+2
;
Add16:
	pha

	clc
	lda	tmpAccm
	adc	tmpAccm+2
	sta	tmpAccm
	bcc	@End

	lda	tmpAccm+1
	adc	tmpAccm+3
	sta	tmpAccm+1
@End:
	pla     

	rts  

;------------------------------------------------------------------------------
Dec16:
	lda	tmpAccm
	clc
	sbc	#0
	sta	tmpAccm
	lda	tmpAccm+1
	sbc	#0
	sta	tmpAccm+1

	rts
	
;------------------------------------------------------------------------------
;	Bin2Hex
;		IN		A = data
;
;		break:		A,X
Bin2HexQ:
	sec
Bin2Hex:
	pha
	php
	lsr		a
	lsr		a
	lsr		a
	lsr		a
	plp
	jsr		B2H10
	lda		hexDat
	sta		hexDat+1

	pla
	and		#$0f
B2H10:
	php
	tax
	lda		tBinHex,x
	sta		hexDat
	plp
	bcc		@B2HEnd

	jsr		QueueCharForOutput
@B2HEnd:
	rts

;------------------------------------------------------------------------------
;	NibbleChar
;
NibbleChar:
	pha
	lda		nibbleCnt
	beq		@NC10
	lsr		a
	lsr		a
	lsr		a
	lsr		a
@NC10:
	pla
	and		#$0f

	jmp		B2H10

	rts

hexDat:	.res	2
tBinHex:.byte	"0123456789ABCDEF"


;------------------------------------------------------------------------------
Asc2Bin:
	ldx	#$00
@A2BLoop:						;--- ASC to Nibble loop
	lda	inputCharBuf,x
	cmp	#$ff
	beq	@A2BEnd

	tay
	and	#$40
	beq	@A2B100
	tya
	clc
	adc	#$9
	jmp	@A2B200
@A2B100:
	tya
@A2B200:
	and	#$0f
	sta	tmpA2B,x
	inx
	cpx	inputCharCnt
	bne	@A2BLoop
							;--- Nibble to Bin
	lda	#$00
	tay
	tax
	lda	inputCharCnt
	lsr
	bcs	@A2B400					; inputCharCnt is odd
	tya
	tax
@A2B300:
	lda	tmpA2B,x
	asl
	asl
	asl
	asl
	inx
	ora	tmpA2B,x
	sta	binA2B,y
@A2B400:
	iny
	inx
	cpx	inputCharCnt
	bne	@A2B300
@A2BEnd:
	rts

binA2B:
tmpA2B:
	.res	4

; ----------------------------------
;	A = 0–99
;		結果:
;		A = packed BCD ($00–$99)
;		使用:
;		A, X
;		zp tmp (1 byte)
; ----------------------------------
tmp = $00

BIN2BCD:
	LDX #0 ; tens = 0

@div10:
	CMP	#10
	BCC	@done
	SEC
	SBC	#10
	INX
	JMP	@div10
@done:
	STA	tmp

	TXA
	ASL	A
	ASL	A
	ASL	A
	ASL	A

	ORA	tmp

	RTS

; From https://github.com/bbbradsmith/NES-ca65-example/tree/fds
;------------------------------------------------------------------------------
; this routine is entered by interrupting the last boot file load
; by forcing an NMI not expected by the BIOS, allowing the license
; screen to be skipped entirely.
;
; The last file writes $90 to $2000, enabling NMI during the file load.
; The "extra" file in the FILE_COUNT causes the disk to keep seeking
; past the last file, giving enough delay for an NMI to fire and interrupt
; the process.
bypass:
	lda	#0
	sta	$2000			; disable NMI 
					; replace NMI#3 "bypass"
	lda	#<pNmiTrampoline
	sta	$DFFA
	lda	#>pNmiTrampoline
	sta	$DFFB
					; tell the FDS reset routine that the BIOS initialized correctly
	lda	#$35
	sta	$0102
	lda	#$AC
	sta	$0103
					; reset the FDS to begin our program properly
	jmp	($FFFC)

;------------------------------------------------------------------------------

.include	"pcg.s"
.include	"mon.s"
.include	"token.s"

.include	"fds.s"

