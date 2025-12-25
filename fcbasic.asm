; ==================================================================================================================================
; ----------------------------------------------------------------------------------------------------------------------------------
; Disk BASIC Layout
; ----------------------------------------------------------------------------------------------------------------------------------
; Definitions
.enum
	INES_HDR = $10 ; size of iNES header
	PRG_SIZE = $6000 ; cut out data which would conflict with FDS BIOS
	
	DiskInfoBlock     = 1
	FileAmountBlock   = 2
	FileHeaderBlock   = 3
	FileDataBlock     = 4
	
	PRG = 0
	CHR = 1
	VRAM = 2
	FILE_COUNT = 4
	
	PPUCTRL = $2000
	NMI_FLAG = $0100
	IRQ_FLAG = $0101
	RST_FLAG = $0102
	RST_TYPE = $0103
	SND_CHN = $4015

	pNmiTrampoline =  $ed
	_Reset = $80ba

.endenum

	.define FILE "fbv3.nes"

; ----------------------------------------------------------------------------------------------------------------------------------
; Disk Structure
	.segment "SIDE1A"
	
; Disk info + file amount blocks
	.byte DiskInfoBlock
	.byte "*NINTENDO-HVC*"
	.byte "KOUJI" ; checked by save utility (these bytes are normally disk metadata)
	.byte 0,0,0,0,0
	.byte $0f ; boot read file code
	.byte $ff, $ff, $ff, $ff, $ff ; unknown
	.byte $61, $11, $27 ; manufacturing date (1986-11-27)
	.byte $49, $61, $00, $00, $02 ; country, region, unknown
	.byte $00, $5a, $00, $73, $00 ; unknown
	.byte $61, $11, $27 ; disk rewrite date (same as manufacturing date)
	.byte $FF, $FF, $FF, $FF, $FF ; unknown
	.byte $00, $00, $00, $00 ; other fields (not relevant here)
	
	.byte FileAmountBlock
	.byte FILE_COUNT

; ----------------------------------------------------------------------------------------------------------------------------------
; kyodaku file (license screen)
	.segment "FILE0_HDR"
	.import __FILE0_DAT_RUN__
	.import __FILE0_DAT_SIZE__
	.byte FileHeaderBlock
	.byte $00, $00
	.byte "KYODAKU-"
	.word __FILE0_DAT_RUN__
	.word __FILE0_DAT_SIZE__
	.byte VRAM

	.byte FileDataBlock
	.segment "FILE0_DAT"
	.incbin "kyodaku.bin"

; ----------------------------------------------------------------------------------------------------------------------------------
; IPL-PRG (unused but counts towards file count)
	.segment "FILE1_HDR"
	.import __FILE1_DAT_RUN__
	.import __FILE1_DAT_SIZE__
	.byte FileHeaderBlock
	.byte $01, $01
	.byte "IPL-PRG "
	.word __FILE1_DAT_RUN__
	.word __FILE1_DAT_SIZE__
	.byte PRG
	
	.byte FileDataBlock
	.segment "FILE1_DAT"
	.include "ipl-prg.asm"

; ----------------------------------------------------------------------------------------------------------------------------------
; CHR
	.segment "FILE2_HDR"
	.import __FILE2_DAT_RUN__
	.import __FILE2_DAT_SIZE__
	.byte FileHeaderBlock
	.byte $02, $02
	.byte "CHR-ROM "
	.word __FILE2_DAT_RUN__
	.word __FILE2_DAT_SIZE__
	.byte CHR
	
	.byte FileDataBlock
	.segment "FILE2_DAT"
	.incbin FILE, INES_HDR + $8000, $2000

; ----------------------------------------------------------------------------------------------------------------------------------
; PRG
	.segment "FILE3_HDR"
	.import __FILE3_DAT_RUN__
	.import __FILE3_DAT_SIZE__
	.byte FileHeaderBlock
	.byte $03, $03
	.byte "PRG-ROM "
	.word __FILE3_DAT_RUN__
	.word __FILE3_DAT_SIZE__
	.byte PRG
	
	.byte FileDataBlock
	.segment "FILE3_DAT"
; Prepare original dump for patching
	.incbin FILE, INES_HDR, PRG_SIZE

	
	.segment "PATCH_0"
		.byte $7f

	.segment "PATCH_1"
		.byte $80
	.segment "PATCH_2"
		.byte $80

	.segment "PATCH_3"
		.byte $7c
	.segment "PATCH_4"
		.byte $7c
	.segment "PATCH_5"
		.byte $7c

	.segment "PATCH_6"
		.byte "D"

	.segment "RESET_PATCH"
		jsr		$d000

	.segment "GAME_PATCH"
		nop
		nop
		nop
		rts

	.segment "FDS_PATCH"
#	.include	"fds.inc"

_SetScrollDir:
		lda		#$27
		sta		$4025
		jsr		$b3ab			; InitPpuApu
		rts

#	.include	"fdslib.asm"

	.segment "VECTORS_PATCH"
; Note: IRQ handler is also bad in the original (rts x3)
; (At least you can rewrite it to use IRQs in machine code programs now)
		cli
	.byte $5c, $60, $00 ; ?
	.addr $00ed ; NMI vector?
	
	; Interrupt vectors
	.addr pNmiTrampoline ; NMI #1
	.addr pNmiTrampoline ; NMI #1
	.addr pNmiTrampoline ; NMI #3, default
	.addr _Reset ; Reset
	.addr _Reset ; IRQ (unused?)

