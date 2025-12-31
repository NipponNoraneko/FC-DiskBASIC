    .org    $d000

	.include	"fnc.inc"
	.include	"token.asm"

;----- BASIC zeroPage
zpPpuCtrlVal	=	$32   
zpPpuMaskVal	=	$33
zpCH			=	$48				; Current cursor column number
zpCV			=	$49				; Current cursor row number 

zpOutputStr     =	$52				; Pointer to null-term'd string to be queued for output

;----- BASIC routine
PrintString		=	$893c
PrintOutBuf		=	$895d
InitPpuApu		=	$b3ab
DoCRLF			=	$b56f
WaitForVBlank	=	$b42b

TxtPtrGetCharAndIncr=	$9088
TxtPtrIncrAndGetChar=	$9098
TxtPtrIncr		=	$908c
IsEndOfCmd		=	$849c


;------------------------------------------------------------------------------
_ResetPatch:
        lda     #$27
        sta     $4025

        jsr     InitPpuApu

        rts

;------------------------------------------------------------------------------
;	Wait
;
;		Ret:	Y = 0
WaitYff:
		lda		#$ff
@WaitJ10:
		clc
		adc		#$ff
		bne		@WaitJ10

		dey
		bne		WaitYff

		rts

;------------------------------------------------------------------------------
ResetFDS:
		jsr		EndFDS				; Reset

;----- BIOS Reset condition
		lda		#$c0
		sta		NMI_FLAG
		lda		#$80
		sta		IRQ_FLAG
		lda		#$53
		sta		RESET_TYPE

		rts

;------------------------------------------------------------------------------
EndFDS:
		lda		#$26
		sta		FDS_CTRL

		ldy		#$05
		jsr		Delayms

		lda		#$27
		sta		FDS_CTRL
		sta		FDS_CTRL_Mirror

		rts

;------------------------------------------------------------------------------
SenceBattly:
		lda		#$80
		sta		FDS_EXT
		lda		FDS_BATTERY_EXT

		asl		a

		rts

;------------------------------------------------------------------------------
ReadByte:
		lda		#$25						; |V-SCRLL|READ|NO_RESET|
		sta		FDS_CTRL
		ldy		#$05
		jsr		Delayms
		lda		#$65						; |CRC_CLR|V-SCRLL|READ|NO_RESET|
		sta		FDS_CTRL
@RB10:
		bit		FDS_STATUS
		bpl		@RB10

		lda		FDS_READ_DATA

		rts

;------------------------------------------------------------------------------
FDSStart:
		lda		#$00
		sta		readCnt
		sta		readCnt+1
		sta		fileCnt+1

		jsr		WaitForReady
		ldy		#$c5
		jsr		Delayms
		ldy		#$46
		jsr		Delayms

		rts

;------------------------------------------------------------------------------
ReadBlockNN:
		sty		readBufPtr+1
		stx		readBufPtr+2
		jsr		CheckBlockType

		ldy		#$00
RBlk10:
		jsr		XferByte
readBufPtr:
		sta		readBufPtr,y
		iny
		cpy		readCnt
		bne		RBlk10

		jsr		EndOfBlockRead

		rts

;------------------------------------------------------------------------------
SkipBlock04:
		lda		#$04
		jsr		CheckBlockType
@SkpBlk10:
		lda		readCnt
		bne		@SkpBlk20
		lda		readCnt+1
		beq		@SkpBlkEnd
		dec		readCnt+1
@SkpBlk20:
		dec		readCnt
		jsr		XferByte
		jmp		@SkpBlk10		

@SkpBlkEnd:
		jsr		EndOfBlockRead

		rts

tArg:
		.byte	$86,<FileList,>FileList			; LIST
		.byte	$ff

NoOpe:	rts
;------------------------------------------------------------------------------
ExprCheck:
		ldx		#$00
@EC02:
		cmp		tArg,x
		bne		@EC05
		jsr		TxtPtrIncrAndGetChar
		lda		tArg+1,x
		sta		JmpPtr
		lda		tArg+2,x
		sta		JmpPtr+1
		clc
		jmp		@ECEnd
@EC05:
		inx
		inx
		inx
		lda		tArg,x
		cmp		#$ff
		beq		@EC10
		jmp		@EC02
@EC10:
		sec
@ECEnd:
		rts

;------------------------------------------------------------------------------
CmdFDS:
		beq		@FDSEnd
		jsr		ExprCheck
		bcs		@FDSEnd

		ldx		#$00
@FDS10:
		lda		tempzp,x
		sta		tempzpSav,x
		lda		$90,x
		sta		joypadSav,x
		inx
		cpx		#$10
		bne		@FDS10

		lda		#$0e

		lda		zpPpuMaskVal
		sta		PPU_MASK

		lda		zpPpuCtrlVal
		and		#$77
		sta		PPU_CTRL_Mirror
		sta		PPU_CTRL


		lda		#>(@FDSRet-1)
		pha
		lda		#<(@FDSRet-1)
		pha
		jmp		(JmpPtr)
@FDSRet:
		ldx		#$00
@FDS20:
		lda		tempzpSav,x
		sta		tempzp,x
		lda		joypadSav,x
		sta		$90,x
		inx
		cpx		#$10
		bne		@FDS20

		lda		zpPpuMaskVal
		sta		PPU_MASK
		lda		zpPpuCtrlVal
		ora		#$80
		sta		PPU_CTRL

@FDSEnd:
		sei

		rts

JmpPtr:	.res	2

;------------------------------------------------------------------------------
FileList:
		lda		#$00
		sta		fileCnt
;----- Block 01
		jsr		FDSStart

		ldx		#>diskHeader
		ldy		#<diskHeader
		lda		#$37
		sta		readCnt

		lda		#$01
		jsr		ReadBlockNN

;----- Block 02 (file amount)
		lda		#$02
		jsr		GetNumFiles
		ldx		tempzp+6
		stx		fileAmount
@FDS05:
		txa
		pha
;----- Block 03
		lda		fileCnt
		bne		@FDS07
		ldx		#>block03Buf
		ldy		#<block03Buf
		jmp		@FDS09
@FDS07:
		ldy		readBufPtr+1
		ldx		readBufPtr+2
@FDS09:
		lda		#$0f
		sta		readCnt

		lda		#$03
		jsr		ReadBlockNN

		inc		fileCnt

;----- Block 04 (読み飛ばし)
		lda		readBufPtr+1
		sta		tempzp
		lda		readBufPtr+2
		sta		tempzp+1

		ldy		#$0c
		lda		(tempzp),y
		sta		readCnt
		iny
		lda		(tempzp),y
		sta		readCnt+1

		jsr		SkipBlock04

		lda		readBufPtr+1
		clc
		adc		#$10
		bcc		@FDS15
		inc		readBufPtr+2
@FDS15:
		sta		readBufPtr+1
		pla
		tax
		dex
		bne		@FDS05

		jsr		EndFDS

ErrEnd:
		rts

;------------------------------------------------------------------------------
readCnt:.res	2

fileCnt:.res	1
fileAmount:
		.res	1
diskHeader:
		.res	$39


		.org	$d6fe
bufPtr:	.res	2
;--- FDS,BASIC work save Area

block03Buf:
		.res	$10 * 10

tempzpSav:
		.res	$10
joypadSav:
		.res	$10


