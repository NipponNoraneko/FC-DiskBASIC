;------------------------------------------------------------------------------
;	FAMILY BASIC V3 symbols & address
;
;	This is extracted from the deliverables of the following project.
;		https://github.com/micahcowan/fbdasm
;		https://famibe.addictivecode.org/disassembly/fb3.nes.html
;
;------------------------------------------------------------------------------

;----- BASIC zeroPage
zpTXTTAB		=	$05
zpTXTEND		=	$07
zpTXTPTR		=	$09
zpMisc			=	$19
zpVARTAB		=	$1d
zpVAREND		=	$1f

zpPokeAddr		=	$25		; 2bytes: POKE文でのみ使用(たぶん)
zpWAccum		=	$28    		; 4bytes: Like a 16-bit Accumulator.
						; Forms both the first operand, and the result,
						;   of various 16-bit integer operations.
						;   Or: byte Len followed by word ptr, for strings.
zpWParam		=	$2c		; 3bytes ; Like a 16-bit Data register.
						; forms the second operand of various binary operators

zpPpuCtrlVal		=	$32   
zpPpuMaskVal		=	$33
zpCH			=	$48		; Current cursor column number
zpCV			=	$49		; Current cursor row number 
zpOutputStr    		 =	$52		; Pointer to null-term'd string to be queued for output

zpRkimMidMacro		=	$66

zpHaveFNameArg		=	$ea		; true when LOAD was given a filename arg
zpNmiTrampoline		=	$ed		; Contains a JMP instruction to the real NMI handler.
						; It's set to: JMP $8971
;----- BASIC area
oamBuffer		=	$0200
lineBuffer		=	$0500
bgGetRam		=	$7c00

;----- BASIC routine
PrintString		=	$895a
WaitForNmiSubcommand	=	$896a
NMI_DefaultHandler	=	$8971
QueueOutputStr		=	$893c
QueueNullForOutput	=	$894b
QueueCharForOutput	=	$894d
PrintOutBuf		=	$895d
IsEndOfCmd		=	$849c
GetTxtChar		=	$90b2
CmdFn_CLS_Scr1		=	$adfe
GetFileNameArg		=	$9e52
InitPpuApu		=	$b3ab
WaitForVBlank		=	$b42b
PrintOneChar		=	$b575 
DoCRLF			=	$b56f
BasReadKeyboard		=	$b958
ReadChar		=	$bc20
KeyClick		=	$bcd5		; length zpMisc
ShowCursor		=	$bc11
HideCursor		=	$bc18
Rkim_cancelFkeyAndReread=	$b93d
ReadKeyInsMacros	=	$b945

TxtPtrGetCharAndIncr	=	$9088
TxtPtrIncrAndGetChar	=	$9098
TxtPtrIncr		=	$908c


;
;--- jtbl_CtrlCharInputHandlers
;
ToggleInsertOrOverwriteMode=	$b8c0		;Control-A
CursorToNextLineStart	=	$b8c4		;STOP (Control-C)
ResetGraphicSettings	=	$b8c6		;Control-D
ClearToEndOfLine	=	$b8c8		;Control-E
CmdFn_BEEP		=	$b8cc		;Control-G
Backspace		=	$b76f		;BACKSPACE (Control-H)
HandleTabKey		=	$b8d0		;TAB (Control-I)
LineFeed		=	$b8d2		;LF (Control-J)
CursorHome		=	$b8d4		;HOME (Control-K)
DoCLS			=	$b8d6		;Control-L
CarriageReturn		=	$b8d8		;CR (Control-M)
InsertSpaceChar		=	$b8e2		;INSERT (Control-R)
ActivateKanaMode	=	$b8ea		;Control-V
DeactivateKanaMode	=	$b8ec		;Control-W
ClearToEndOfScreen	=	$b8f2		;Control-Z
CursorRight		=	$b8f6		;Control-\
CursorLeft		=	$b8f8		;Control-]
CursorUp		=	$b8fa		;Control-^
CursorDown		=	$b8fc		;Control-_
ControlCharNOOP		=	$b8f4

