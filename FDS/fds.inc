DISK_INFO_BLK_SIZE	= $38
FILE_HDR_BLK_SIZE	= $10
tmpAccm			= joypad

;----- BIOS area
tempzp			= $0000
joypad			= $00f0
FDS_EXT_Mirror		= $00f9
FDS_CTRL_Mirror		= $00fa
JOY1_Mirror		= $00fb
Y_SCROLL_Mirror		= $00fc
X_SCROLL_Mirror		= $00fd
PPU_MASK_Mirror		= $00fe
PPU_CTRL_Mirror		= $00ff
NMI_FLAG		= $0100
IRQ_FLAG		= $0101
RESET_FLAG		= $0102
RESET_TYPE		= $0103

;----- FDS hardware defines
FDS_IRQ_TIMER_LOW	= $4020
FDS_IRQ_TIMER_HI	= $4021
FDS_IRQ_TIMER_CTRL	= $4022
FDS_IO_ENABLE		= $4023
FDS_WRITE_DATA		= $4024
FDS_CTRL		= $4025
FDS_EXT			= $4026			; connector on back of RAM adaptor
FDS_STATUS		= $4030
FDS_READ_DATA		= $4031
FDS_DRIVE_STATUS	= $4032
FDS_BATTERY_EXT		= $4033			; bit 7 = battery, rest are shared with FDS_EXT

;--- Disk I/O
LoadFiles		= $e1f8			; paramsize 4
AppendFile		= $e237			; paramsize 4
WriteFile		= $e239			; paramsize 4
CheckFileCount		= $e2b7			; paramsize 2
AdjustFileCount		= $e2bb			; paramsize 2
SetFileCount1		= $e301			; paramsize 2
SetFileCount		= $e305			; paramsize 2
GetDiskInfo		= $e32a			; paramsize 2

;--- Low-level disk I/O
WriteLastFile		= $e26b
CheckLastFile		= $e290

SetFileCnt		= $e2ab
GetFileCount		= $e2f7

FetchDiskPtrs		= $e3e7
FetchDiskPtrs_WriteProtectCheck	= $e3ea

CheckDiskHeader		= $e445
GetNumFiles		= $e484
SetNumFiles		= $e492
FileMatchTest		= $e4a0
SkipFiles		= $e4da

LoadData		= $e4f9
ReadData		= $e506
SaveData		= $e5b5

WaitForReady		= $e64d

StopMotor		= $e685
StartMotor		= $ee17

CheckBlockType		= $e68f
WriteBlockType		= $e6b0

StartXfer		= $e6e3

EndOfBlockRead		= $e706
EndOfBlockWrite		= $e729

CheckDiskSet		= $e74c

ReadCRC_Unused		= $e761

Xfer1stByte		= $e794
XferByte		= $e7a3

;--- Disk transfer return states
XferDone		= $e778
XferFailOnCarry		= $e77c
XferFailOnNEQ		= $e77f
XferFail		= $e781

;--- Low-level helpers
AddYtoPtrA		= $e3da
LoadSizeAndSrc		= $e583
Inc0ADec0C		= $e7a7
Dec0C			= $e7ad

;--- General purpose
Delay131		= $e149
Delayms			= $e153

DisPFObj		= $e161
EnPFObj			= $e16b
DisObj			= $e171
EnObj			= $e178
DisPF			= $e17e
EnPF			= $e185

VINTWait		= $e1b2
VRAMStructWrite		= $e7bb			; paramsize 2
FetchDirectPtr		= $e844
WriteVRAMBuffer		= $e86a
ReadVRAMBuffer		= $e8b3
PrepareVRAMString	= $e8d2			; paramsize 2
PrepareVRAMStrings	= $e8e1			; paramsize 2
GetVRAMBufferByte	= $e94f
Pixel2NamConv		= $e97d
PNam2PixelConv		= $e997

Random			= $e9b1
SpriteDMA		= $e9c8
CounterLogic		= $e9d3
ReadPads		= $e9eb
OrPads			= $ea0d
ReadDownPads		= $ea1a
ReadOrDownPads		= $ea1f
ReadDownVerifyPads	= $ea36
ReadOrDownVerifyPads	= $ea4c
ReadDownExpPads		= $ea68

VRAMFill		= $ea84
MemFill			= $ead2

SetScroll		= $eaea

;--- Jump table implementation uses an inline pointer table of an arbitrary size, 
;--- which can't be represented here...
JumpEngine		= $eafd

ReadKeyboard		= $eb13

LoadTileset		= $ebaf			; paramsize 2

UploadObject		= $ec22

