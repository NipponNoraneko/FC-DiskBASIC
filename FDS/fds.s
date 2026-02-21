; tab=8
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------

;------------------------------------------------
diskID		=	diskBuf+$0e
fileAmount	=	diskID+$0a
block03Buf	=	diskID+$0b

;------------------------------------------------------------------------------
;	SaveBasWork:	 BASIC領域の退避
;
SaveBasWork:
	ldx	#$0f
@SBW10:
	lda	tempzp,x
	sta	tempzpSav,x
	lda	joypad,x
	sta	joypadSav,x
	dex
	bpl	@SBW10
						;--- PPU setting
	lda	zpPpuMaskVal
	sta	PPU_MASK_Mirror
	lda	zpPpuCtrlVal
	sta	PPU_CTRL_Mirror

	jsr	RBEnd
	sta	FDS_CTRL_Mirror

	rts

;------------------------------------------------------------------------------
;	RestoreBasWork:	BASIC領域の復元
;
RestoreBasWork:
	ldx	#$0f
@RBW10:
	lda	tempzpSav,x
	sta	tempzp,x
	lda	joypadSav,x
	sta	joypad,x
	dex
	bpl	@RBW10
RBEnd:
	lda	#$27
	sta	FDS_CTRL

	rts

;------------------------------------------------------------------------------
VsyncOn:
	lda	#$c0
	sta	NMI_FLAG

	lda	PPU_CTRL_Mirror
	ora	#$80
	bne	SetPPU

;------------------------------------------------
VsyncOff:
	lda	#$00
	sta	NMI_FLAG

	lda	PPU_CTRL_Mirror
	and	#$7f

;------------------------------------------------
SetPPU:
	sta	PPU_CTRL
	sta	PPU_CTRL_Mirror

	lda	PPU_MASK_Mirror
	ora	#$08
	sta	PPU_MASK
	sta	PPU_MASK_Mirror

	rts

;------------------------------------------------------------------------------
;	ResetFDS:	FDSリセット
;
ResetFDS:
	jsr	EndFDS				; FDS Reset
						;----- BIOS Reset condition
	lda	#$c0				; user NMI
	sta	NMI_FLAG
	lda	#$80
	sta	IRQ_FLAG
	lda	#$53
	sta	RESET_TYPE

	rts

;------------------------------------------------------------------------------
;
EndFDS:
	lda	#$26				; $26: |H-SCRL|READ|M-STOP|RESET|
	sta	FDS_CTRL

	ldy	#$05
	jsr	Delayms

	lda	#$27				; $27: |H-SCRL|READ|M-STOP|NO-RESET|
	sta	FDS_CTRL
	sta	FDS_CTRL_Mirror

	lda	#$c0
	sta	IRQ_FLAG

	rts

;------------------------------------------------------------------------------
;	SenceCard:	DiskCard挿入状態
;
;	RET	A.d0 = 挿入状態
;
SenceCard:
	lda	FDS_DRIVE_STATUS
	and	#$01

	rts

;------------------------------------------------------------------------------
;	SenceBattly:	バッテリ・チェック
;
;	RET	CY = Battly bit
;
SenceBattly:
	lda	#$80
	sta	FDS_EXT
	lda	FDS_BATTERY_EXT

	asl	a

	rts

;------------------------------------------------------------------------------
;	ReadBtye:	1 byte読込み
;
;	RET:	A = 読込みデータ
;
ReadByte:
	lda	#$25				; $25: |H-SCRLL|READ|NO_RESET|
	sta	FDS_CTRL

	ldy	#$05
	jsr	Delayms

	lda	#$65				; $65: |CRC_CLR|H-SCRL|READ|NO_RESET|
	sta	FDS_CTRL
@RB10:						;--- Wait R/W Enable
	bit	FDS_STATUS
	bpl	@RB10

	lda	FDS_READ_DATA

	rts

;------------------------------------------------------------------------------
;	FDSStart:	
;
FDSStart:
	lda	#$00
	sta	readCnt
	sta	readCnt+1
	sta	fileCnt

	jsr	WaitForReady

	ldy	#$c5
	jsr	Delayms
	ldy	#$46
	jsr	Delayms

	rts

;------------------------------------------------------------------------------
;	ReadBlockNN:	one block read
;
;	IN	A = block number
;		XY= read buffer address
;		X: address upper
;		Y: lower
;
readBufPtr	=	RBNNptr+1
blk03Ptr	=	blk03byte+1

ReadBlock01:
	lda	#01
	bne	ReadBlockNN
ReadBlock03:
	lda	#03
	bne	ReadBlockNN
ReadBlock04:
	lda	#04
ReadBlockNN:
	sty	readBufPtr
	stx	readBufPtr+1
	sty	blk03Ptr
	stx	blk03Ptr+1

	jsr	CheckBlockType
						;---
	ldy	#$00
RBlk10:
	jsr	XferByte
RBNNptr:
	sta	readBufPtr,y
	iny
	cpy	readCnt
	bne	RBlk10

	jsr	EndOfBlockRead

	rts

;------------------------------------------------------------------------------
;	DecReadCnt
;	readCnt - 1
;
DecReadCnt:
	dec	readCnt
	bne	@DRCEnd
	lda	readCnt+1
	beq	@DRCEnd
	dec	readCnt+1
@DRCEnd:
	rts

;------------------------------------------------------------------------------
;	SkipBlockNN
;	Skip reading Block
;
;	IN	readCnt = num of skip byte
;		A = Block No.
;
SkipBlockNN:
	jsr	CheckBlockType
@SkpBlk10:
	jsr	XferByte

	jsr	DecReadCnt
	bne	@SkpBlk10	
@SkpBlkEnd:
	jsr	EndOfBlockRead

	rts

PutTotalFileSize:

	rts

PutHex2:
	rts

;------------------------------------------------------------------------------
;	MakeFileListLine:	詳細ファイル行作成
;
MakeFileListLine:
.ifdef aaa
	lda	#' '
	jsr	QueueCharForOutput
@MFL05:						;--- file no.
	ldy	#$00
	lda	(joypad),y
	iny
	ora	#'0'
@MFL07:
	jsr	QueueCharForOutput
.else
	ldy	#$01
.endif
	lda	#' '
	jsr	QueueCharForOutput
						;--- file ID
	lda	(joypad),y
	iny
	jsr	Bin2HexQ
	lda	#':'
	jsr	QueueCharForOutput
						;--- file name
	ldy	#$02
@MFL10:
	lda	(joypad),y
	iny
	jsr	QueueCharForOutput
	cpy	#10
	bne	@MFL10

	lda	#' '
	jsr	QueueCharForOutput
						;--- store address	
	iny
	lda	(joypad),y
	jsr	Bin2HexQ
	dey
	lda	(joypad),y
	jsr	Bin2HexQ

	lda	#' '
	jsr	QueueCharForOutput
						;--- file size
	iny
	iny
	iny
	lda	(joypad),y
	jsr	Bin2HexQ
	dey
	lda	(joypad),y
	jsr	Bin2HexQ

	lda	#' '
	jsr	QueueCharForOutput
						;--- file type
	iny
	iny
	lda	(joypad),y
	ora	#'0'
	jsr	QueueCharForOutput
						;--- padding
	ldy	#$02
@MFL20:
	lda	#' '
	jsr	QueueCharForOutput
	dey
	bne	@MFL20

	rts

;------------------------------------------------------------------------------
;
PrintFileLine:
	lda	#<block03Buf
	sta	tmpAccm
	lda	#>block03Buf
	sta	tmpAccm+1

	lda	#$10
	sta	tmpAccm+2
	lda	#0
	sta	tmpAccm+3

	ldx	fileCnt
@PFL10:
	txa
	pha
	jsr	MakeFileListLine		; 表示行作成
	jsr	QueueNullForOutput
	jsr	PrintOutBuf
	jsr	DoCRLF
	jsr	Add16
	pla
	tax
	dex
	bne	@PFL10

	rts

;------------------------------------------------------------------------------
;	FileList:	詳細ファイル・リスト
;
FileList:
	jsr	VsyncOff

	lda	#$00
	sta	fileCnt
	jsr	FDSStart

;----- Block 01
	ldx	#>diskInfoBlock
	ldy	#<diskInfoBlock
	lda	#DISK_INFO_BLK_SIZE-1
	sta	readCnt

	jsr	ReadBlock01

;----- Block 02 (ファイル数)
	jsr	GetNumFiles
	ldx	tempzp+6
	stx	fileAmount
@FL05:
	txa
	pha

;----- Block 03
	lda	fileCnt
	bne	@FL07

	ldx	#>block03Buf
	ldy	#<block03Buf
	jmp	@FL09
@FL07:
	ldx	readBufPtr+1
	ldy	readBufPtr
@FL09:
	lda	#FILE_HDR_BLK_SIZE-1
	sta	readCnt

	jsr	ReadBlock03			; Block 03 読込み

	inc	fileCnt

;--- Block 04 (Skip reading)
						;--- 読み込みバイト数
	lda	readBufPtr
	sta	joypad
	lda	readBufPtr+1
	sta	joypad+1

	ldy	#$0c
	lda	(joypad),y
	sta	readCnt
	iny
	lda	(joypad),y
	sta	readCnt+1

	lda	#$04
	jsr	SkipBlockNN			; Block 04読み飛ばし
						;--- 次読み込みアドレス
	lda	readBufPtr
	clc
	adc	#$10
	bcc	@FL15

	inc	readBufPtr+1
	inc	blk03byte+2
@FL15:
	sta	readBufPtr
	sta	blk03byte+1

	pla
						;--- to Next block03
	tax
	dex
	bne	@FL05

	jsr	EndFDS

	lda	#$02
	sta	diskInfoStat
ErrEnd:
	jsr	VsyncOn

	jsr	PrintFileLine

	rts

;--------------------------------------------
blk03byte:
	lda	block03Buf,y
	iny

	rts


;------------------------------------------------------------------------------
;	LoadFile:
;
LoadFile:
;--- 引数チェック
	jsr	IsEndOfCmd
	beq	@LFErr				; ファイル番号なし
	cmp	#$12				; 整数?
	bne	@LFErr				; no


	jsr	VsyncOff

	jsr	TxtPtrIncrAndGetChar		;
	jsr	BIN2BCD
	sta	loadList
						;--- Read File
	jsr	VINTWait
	jsr	LoadFiles
	.addr	diskID
	.addr	loadList
	bne	@LFErr				; Error
	
	tya
	beq	@LFErr				; 読み込んだファイルが無い

;--- BASIC file check
	ldy	$6001
	cpy	#'S'
	bne	@LFEnd
	ldy	$6000
	cpy	#'B'
	bne	@LFEnd

	sty	loadFileType

;--- Set zpTXTTAB,ZpTXTEND
	ldx	#$03
@LF30:
	lda	$6002,x
	sta	tempzpSav+zpTXTTAB,x
	dex
	bpl	@LF30

;--- ヘッダ部クリア ------------------------
	lda	#$00
	ldx	#$05
@LF50:
	sta	$6000,x
	dex
	bpl	@LF50
@LFErr:
	jsr	QueueErrMsg
@LFEnd:
	jsr	VsyncOn

	rts

;--------------------------------------------
loadList:
	.byte	$81,$FF

;--------------------------------------------
sLoadFile:
	.asciiz	"LOADING..."

;------------------------------------------------------------------------------
qFNptr	=	ReadBufX+1
ReadBufX:
	lda	qFNptr,x
	rts

;------------------------------------------------------------------------------
;
QueueFileName:
						;--- fileID
	ldx	#$00
	jsr	ReadBufX

	clc
	jsr	Bin2Hex
	lda	hexDat+1
	sta	sLineBuf,y
	iny
	lda	hexDat
	sta	sLineBuf,y
	iny

	lda	#':'
	sta	sLineBuf,y

;--- file name
	tya
	clc
	adc	#8
	tay
	ldx	#8
@QFN10:
	jsr	ReadBufX
	sta	sLineBuf,y
	dey
	dex
	bne	@QFN10

	tya
	clc
	adc	#10
	tay

	rts

;------------------------------------------------------------------------------
ClrLineBuf:
	lda	#' '
	ldx	#28-1
@CLB10:
	sta	sLineBuf,x
	dex
	bpl	@CLB10

	rts

;------------------------------------------------------------------------------
ShortFileList:
	lda	#$00
	sta	fileCnt

	lda	#<sLineBuf
	sta	zpOutputStr
	lda	#>sLineBuf
	sta	zpOutputStr+1

	ldx	#>block03Buf
	stx	qFNptr+1
	ldy	#<block03Buf
	sty	qFNptr

	ldy	#1
@SFL10:
	jsr	QueueFileName

	lda	qFNptr
	clc
	adc	#$09
	bcc	@SFL20
	inc	qFNptr+1
@SFL20:
	sta	qFNptr

	lda	fileCnt
	and	#$01
	beq	@SFL30

	jsr	PrintString
	jsr	ClrLineBuf

	ldy	#1
@SFL30:
	inc	fileCnt
	lda	fileCnt
	cmp	fileAmount
	bne	@SFL10

	and	#$01
	beq	@SFLEnd

	jsr	PrintString
@SFLEnd:
	rts

;--------------------------------------------
sLineBuf:
	.asciiz	"                            "
;	.asciiz	" hh:cccccccc hh:cccccccc    "

;------------------------------------------------------------------------------
;
SetBlk03Ptr:
						;--- diskInfoタイプ
	lda	diskInfoStat
	beq	@End
	cmp	#1
	bne	@SFN01
						; GetDiskInfo
	lda	#>block03Buf
	sta	joypad+1
	lda	#<block03Buf
	sta	joypad

	lda	#9
	bne	@SFN05
@SFN01:						; self scaned
	lda	#>(block03Buf+1)
	sta	joypad+1
	lda	#<(block03Buf+1)
	sta	joypad

	lda	#16
@SFN05:						; set record size
	sta	joypad+2
	lda	#0
	sta	joypad+3
@End:
	rts

;------------------------------------------------------------------------------
;
GetMaxFileID:
	jsr	SetBlk03Ptr

	lda	#0
	tay
	ldx	fileAmount
@L10:
	cmp	(joypad),y
	bpl	@J10
	lda	(joypad),y
@J10:
	jsr	Add16
	dex
	bne	@L10

	rts

;------------------------------------------------------------------------------
;
SearchFileName:
	jsr	SetBlk03Ptr
						;--- ファイル名比較
	ldx	#0
@SFN10:
	ldy	#8
@SFNLoop:
	lda	fileHeader,y
	cmp	(joypad),y
	bne	@SFNNext
	dey
	bne	@SFNLoop

	stx	fileNumber
	lda	(joypad),y			; file ID
	tay
	clc
	bne	@End
@SFNNext:
	jsr	Add16
	
	inx
	cpx	fileAmount
	bcc	@SFN10
@End:
	rts

;------------------------------------------------------------------------------
;
SetBasHeader:
						;--- コマンド:ファイル名有無
	jsr	GetFileNameArg
	lda	zpHaveFNameArg
	beq	@SBHEnd				; no file name

	jsr	TxtPtrIncr
						;--- copy file name
	ldx	#8-1
@fnLoop:
	lda	lineBuffer+128,x
	bne	@fn10
	lda	#' '
@fn10:
	sta	sFileName,x
	dex
	bpl	@fnLoop
						;--- ファイル名チェック
	jsr	SearchFileName
	bcc	@fn20				; 有り
						;--- 無し
	jsr	GetMaxFileID

	jsr	IncBCD
	tay

	ldx	#0
@fn20:
	sty	fileID				; file ID
	stx	fileNumber
						;--- file index "BS"
	ldx	#1
@SBH10:
	lda	sBS,x
	sta	$6000,x
	dex
	bpl	@SBH10
						;--- basPrg Start,End Address
	ldx	#3
@SBH20:
	lda	tempzpSav+zpTXTTAB,x
	sta	$6002,x
	dex
	bpl	@SBH20
@SBHEnd:
	rts

;------------------------------------------------
sBS:	.byte	"BS"

;------------------------------------------------------------------------------
;	FileSave:	ファイル・セーブ
;
FileSave:
	lda	#0
	sta	fileNumber

	jsr	SetBasHeader				;--- 

	jsr	VsyncOff
	jsr	VINTWait
							;--- 既存ファイルNo.チェック
	ldx	fileAmount
	lda	fileNumber
	bne	@FS10
	stx	fileNumber
	inc	fileAmount
	lda	#$ff					; append file
@FS10:
	stx	tempzp+6

	jsr	WriteFile
	.addr	diskID
	.addr	fileHeader
	bne	@FSEnd
							;--- ファイル数更新
	lda	fileAmount
	jsr	SetFileCount
	.addr	diskID
@FSEnd:
	pha
	jsr	VsyncOn
	pla
	jsr	QueueErrMsg
	rts

;------------------------------------------------
fileNumber:
	.byte	$00
fileHeader:
fileID:
	.byte	$84
sFileName:
	.byte	"TESTSAV3"
	.addr	$6000
	.addr	$1000
	.byte	$00
	.addr	$6000
	.byte	$00


;------------------------------------------------------------------------------
;	GetCardInfo:	DiskInfoBlock取得
;
GetCardInfo:
	jsr	SenceCard
	bne	ErrNoCard
	
	jsr	VsyncOff

	jsr	GetDiskInfo
	.addr	diskID
	bne	@GCI20			; if error

	jsr	VsyncOn

	jsr	ShortFileList

	ldx	#$01
	stx	diskInfoStat
	dex
	txa
@GCI20:
	jsr	QueueErrMsg

	rts

;------------------------------------------------------------------------------
;	ErrNoCard:	DiskCard未挿入
;
ErrNoCard:
	jsr	QueueErrMsg
	jsr	ShortBeep

	lda	#$00
	sta	diskInfoStat

	jmp	CFDSEnd


;------------------------------------------------------------------------------
;	ArgCheck:	引数チェック
;
funcPtr	=	DoFunc+1
ArgCheck:
	tay
	ldx	#$00
@AC02:
	tya
	cmp	tArg,x
	bne	@AC05

	jsr	TxtPtrIncrAndGetChar
	lda	tArg+1,x
	sta	funcPtr
	lda	tArg+2,x
	sta	funcPtr+1
	clc
	jmp	ACEnd
@AC05:
	inx
	inx
	inx
	tay
	lda	tArg,x
	cmp	#$ff
	bne	@AC02
@ACNone:
	sec
ACEnd:
	rts

;------------------------------------------------
tArg:
	.byte	$00				; DiskInfo
	.addr	GetCardInfo
	.byte	$86				; LIST
	.addr	FileList
	.byte	$a5				; LOAD
	.addr	LoadFile
	.byte	$a6				; SAVE
	.addr	FileSave
	.byte	$ff


;------------------------------------------------------------------------------
;	CmdFDS:	FDSコマンド・エントリ
;
CmdFDS:
	jsr	ArgCheck			; 引数チェック
	bcs	CFDSEnd2

	jsr	SenceCard
	bne	ErrNoCard			; No DiskCard
						;---- exec command
	jsr	SaveBasWork			; Save BASIC work
DoFunc:	jsr	NoOpe
CFDSEnd:
	jsr	RestoreBasWork
						;--- file type check
	lda	loadFileType
	cmp	#'B'
	bne	CFDSEnd2			; not BASIC file
						;--- BASIC file
	lda	#$00
	sta	loadFileType
	jsr	CLEAR				; zpVALTBL,zpVALEND初期化
CFDSEnd2:					;---- print Result
	jsr	QueueNullForOutput
	jsr	PrintOutBuf

@J10:
	jsr	IsEndOfCmd
	beq	@End

	jsr	TxtPtrIncr
	jmp	@J10
@End:
	lda	#$c0
	sta	$101
NoOpe:
	rts


;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------

;--- FDS,BASIC work save Area -----------------
tempzpSav:
	.res	$10
joypadSav:
	.res	$10

;------------------------------------------------------------------------------
bufPtr:	.res	2
fileCnt:.res	1
readCnt:.res	2
;------------------------------------------------
diskInfoBlock:
diskBuf:.res	$39+($10*$0f)



