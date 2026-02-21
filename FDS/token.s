;.include	"fnc.inc"
; ----------------------------------------------------------------------------
tTokenTable:
		.byte   $80,"GOTO"
		.byte   $81,"GOSUB"
		.byte   $82,"RUN"
		.byte   $83,"RETURN"
		.byte   $84,"RESTORE"
		.byte   $85,"THEN"
		.byte   $86,"LIST"
		.byte   $87,"SYSTEM"
		.byte   $88,"TO"
		.byte   $89,"STEP"
		.byte   $8A,$53,$50,$52,$49,$54,$45     ; SPRITE
		.byte   $8B,$50,$52,$49,$4E,$54         ; PRINT
		.byte   $8C,$46,$4F,$52                 ; FOR
		.byte   $8D,$4E,$45,$58,$54             ; NEXT
		.byte   $8E,$50,$41,$55,$53,$45         ; PAUSE
		.byte   $8F,$49,$4E,$50,$55,$54         ; INPUT
		.byte   $90,$4C,$49,$4E,$50,$55,$54     ; LINPUT
		.byte   $91,$44,$41,$54,$41             ; DATA
		.byte   $92,$49,$46                     ; IF
		.byte   $93,$52,$45,$41,$44             ; READ
		.byte   $94,$44,$49,$4D                 ; DIM
		.byte   $95,$52,$45,$4D                 ; REM
		.byte   $96,$53,$54,$4F,$50             ; STOP
		.byte   $97,$43,$4F,$4E,$54             ; CONT
		.byte   $98,$43,$4C,$53                 ; CLS
		.byte   $99,$43,$4C,$45,$41,$52         ; CLEAR
		.byte   $9A,$4F,$4E                     ; ON
		.byte   $9B,$4F,$46,$46					; OFF
		.byte	$9C,$43,$55,$54					; CUT
		.byte   $9D,$4E,$45,$57                 ; NEW
		.byte   $9E,$50,$4F,$4B,$45             ; POKE
		.byte   $9F,$43,$47,$53,$45,$54         ; CGSET
		.byte   $A0,$56,$49,$45,$57             ; VIEW
		.byte   $A1,$4D,$4F,$56,$45             ; MOVE
		.byte   $A2,$45,$4E,$44                 ; END
		.byte   $A3,$50,$4C,$41,$59             ; PLAY
		.byte   $A4,$42,$45,$45,$50             ; BEEP
		.byte   $A5,"LOAD"						; LOAD
		.byte   $A6,"SAVE"						; SAVE
		.byte   $A7,$50,$4F,$53,$49,$54,$49,$4F,$4E ; POSITION
		.byte   $A8,$4B,$45,$59                 ; KEY
		.byte   $A9,$43,$4F,$4C,$4F,$52         ; COLOR
		.byte   $AA,$44,$45,$46                 ; DEF
		.byte   $AB,$43,$47,$45,$4E             ; CGEN
		.byte   $AC,$53,$57,$41,$50             ; SWAP
		.byte   $AD,$43,$41,$4C,$4C             ; CALL
		.byte   $AE,$4C,$4F,$43,$41,$54,$45     ; LOCATE
		.byte   $AF,$50,$41,$4C,$45,$54         ; PALET
		.byte   $B0,$45,$52,$41                 ; ERA
		.byte   $B1,$54,$52                     ; TR
		.byte   $B2,$46,$49,$4E,$44             ; FIND
		.byte   $B3,"FDS"
		.byte   $B4,$42,$47,$54,$4F,$4F,$4C     ; BGTOOL
		.byte   $B5,$41,$55,$54,$4F             ; AUTO
		.byte   $B6,$44,$45,$4C,$45,$54,$45     ; DELETE
		.byte   $B7,$52,$45,$4E,$55,$4D         ; RENUM
		.byte   $B8,$46,$49,$4C,$54,$45,$52     ; FILTER
		.byte   $B9,$43,$4C,$49,$43,$4B         ; CLICK
		.byte   $BA,$53,$43,$52,$45,$45,$4E     ; SCREEN
		.byte   $BB,$42,$41,$43,$4B,$55,$50     ; BACKUP
		.byte   $BC,$45,$52,$52,$4F,$52         ; ERROR
		.byte   $BD,$52,$45,$53,$55,$4D,$45     ; RESUME
		.byte   $BE,$42,$47,$50,$55,$54         ; BGPUT
		.byte   $BF,$42,$47,$47,$45,$54         ; BGGET
		.byte   $C0,$43,$41,$4E                 ; CAN
		.byte   $C1,"PCG"						; PCG
		.byte   $C2,"MON"						; MON

		.byte   $EF,$58,$4F,$52                 ;XOR
		.byte   $F0,$4F,$52                     ;OR
		.byte   $F1,$41,$4E,$44                 ;AND
		.byte   $F2,$4E,$4F,$54                 ;NOT
		.byte   $F3,$3C,$3E                     ;<>
		.byte   $F4,$3E,$3D                     ;>=
		.byte   $F5,$3C,$3D                     ;<=
		.byte   $F6,$3D                         ;=
		.byte   $F7,$3E                         ;>
		.byte   $F8,$3C                         ;<
		.byte   $F9,'+'                         ;+
		.byte   $FA,$2D                         ;-
		.byte   $FB,$4D,$4F,$44                 ;MOD
		.byte   $FC,$2F                         ;/
		.byte   $FD,$2A                         ;*
		.byte   $CA,$41,$42,$53                 ;ABS
		.byte   $CB,$41,$53,$43                 ;ASC
		.byte   $CC,$53,$54,$52,$24             ;STR$
		.byte   $CD,$46,$52,$45                 ;FRE
		.byte   $CE,$4C,$45,$4E                 ;LEN
		.byte   $CF,$50,$45,$45,$4B             ;PEEK
		.byte   $D0,$52,$4E,$44                 ;RND
		.byte   $D1,$53,$47,$4E                 ;SGN
		.byte   $D2,$53,$50,$43                 ;SPC
		.byte   $D3,$54,$41,$42                 ;TAB
		.byte   $D4,$4D,$49,$44,$24             ;MID$
		.byte   $D5,$53,$54,$49,$43,$4B         ;STICK
		.byte   $D6,$53,$54,$52,$49,$47         ;STRIG
		.byte   $D7,$58,$50,$4F,$53             ;XPOS
		.byte   $D8,$59,$50,$4F,$53             ;YPOS
		.byte   $D9,$56,$41,$4C                 ;VAL
		.byte   $DA,$50,$4F,$53                 ;POS
		.byte   $DB,$43,$53,$52,$4C,$49,$4E     ;CSRLIN
		.byte   $DC,$43,$48,$52,$24             ;CHR$
		.byte   $DD,$48,$45,$58,$24             ;HEX$
		.byte   $DE,$49,$4E,$4B,$45,$59,$24     ;INKEY$
		.byte   $DF,$52,$49,$47,$48,$54,$24     ;RIGHT$
		.byte   $E0,$4C,$45,$46,$54,$24         ;LEFT$
		.byte   $E1,$53,$43,$52,$24             ;SCR$
		.byte   $E2,$49,$4E,$53,$54,$52         ;INSTR
		.byte   $E3,$43,$52,$41,$53,$48         ;CRASH
		.byte   $E4,$45,$52,$52                 ;ERR
		.byte   $E5,$45,$52,$4C                 ;ERL
		.byte   $E6,$56,$43,$54					;VCT.
		.byte	$FF
; ----------------------------------------------------------------------------
tCommandAddr:
        .addr   GOTO                            ;
        .addr   GOSUB                           ;
        .addr   RUN                             ;
        .addr   RETURN                          ;
        .addr   RESTORE                         ;
        .addr   ErrorSyntax                     ;
        .addr   LIST                            ;
        .addr   SYSTEM_BACKUP                   ;
        .addr   ErrorSyntax                     ;
        .addr   ErrorSyntax                     ;
        .addr   SPRITE                          ;
        .addr   PRINT                           ;
        .addr   FOR                             ;
        .addr   NEXT                            ;
        .addr   PAUSE                           ;
        .addr   INPUT                           ;
        .addr   LINPUT                          ;
        .addr   DATA_REM                        ;
        .addr   IF                              ;
        .addr   READ                            ;
        .addr   DIM                             ;
        .addr   DATA_REM                        ;
        .addr   STOP                            ;
        .addr   CONT                            ;
        .addr   LAE0A                           ;
        .addr   CLEAR                           ;
        .addr   ON                              ;
        .addr   ErrorSyntax                     ;
        .addr   CUT                             ;
        .addr   NEW                             ;
        .addr   POKE                            ;
        .addr   CGSET                           ;
        .addr   VIEW                            ;
        .addr   MOVE                            ;
        .addr   END                             ;
        .addr   PLAY                            ;
        .addr   BEEP                            ;
        .addr   LOAD                            ;
        .addr   SAVE                            ;
        .addr   POSITON                         ;
        .addr   KEY                             ;
        .addr   COLOR                           ;
        .addr   DEF                             ;
        .addr   CGEN                            ;
        .addr   SWAP                            ;
        .addr   CALL                            ;
        .addr   LOCATE                          ;
        .addr   PALET                           ;
        .addr   ERA                             ;
        .addr   TR                              ;
        .addr   FIND                            ;
        .addr   CmdFDS
        .addr   BGTOOL                          ; CF27 D1 BF                    ..
        .addr   AUTO                            ; CF29 DA 8B                    ..
        .addr   DELETE                          ; CF2B 58 87                    X.
        .addr   RENUM                           ; CF2D 30 8C                    0.
        .addr   FILTER                          ; CF2F B8 AE                    ..
        .addr   CLICK                           ; CF31 25 96                    %.
        .addr   SCREEN                          ; CF33 48 AE                    H.
        .addr   SYSTEM_BACKUP                   ; CF35 8F 81                    ..
        .addr   ERROR_                          ; CF37 10 95                    ..
        .addr   RESUME                          ; CF39 27 95                    '.
        .addr   BGPUT                           ; CF3B 01 B2                    ..
        .addr   BGGET                           ; CF3D B8 B1                    ..
        .addr   CAN                             ; CF3F 6C CC                    l.
		.addr	CmdPCG
		.addr	CmdMON

tFunctionPtr:
        .addr   FnABS                           ; CF41 84 A9                    ..
        .addr   FnASC                           ; CF43 28 AA                    (.
        .addr   FnSTR_STR                       ; CF45 A6 AA                    ..
        .addr   FnFRE                           ; CF47 1F A9                    ..
        .addr   FnLEN                           ; CF49 1D AA                    ..
        .addr   FnPEEK                          ; CF4B 73 A9                    s.
        .addr   FnRND                           ; CF4D BD A9                    ..
        .addr   FnSGN                           ; CF4F 9C A9                    ..
        .addr   ErrorSyntax                     ; CF51 91 84                    ..
        .addr   ErrorSyntax                     ; CF53 91 84                    ..
        .addr   FnMID_STR                       ; CF55 81 AC                    ..
        .addr   FnSTICK                         ; CF57 38 AD                    8.
        .addr   FnSTRIG                         ; CF59 47 AD                    G.
        .addr   FnXPOS                          ; CF5B 58 A9                    X.
        .addr   FnYPOS                          ; CF5D 61 A9                    a.
        .addr   FnVAL                           ; CF5F DF AA                    ..
        .addr   FnPOS                           ; CF61 33 A9                    3.
        .addr   FnCSRLIN                        ; CF63 E6 A8                    ..
        .addr   FnCHR_STR                       ; CF65 82 AA                    ..
        .addr   FnHEX_STR                       ; CF67 D6 AA                    ..
        .addr   FnINKEY_STR                     ; CF69 58 AB                    X.
        .addr   FnRIGHT_STR                     ; CF6B 41 AC                    A.
        .addr   FnLEFT_STR                      ; CF6D ED AB                    ..
        .addr   FnSCR_STR                       ; CF6F 3B AA                    ;.
        .addr   FnINSTR                         ; CF71 AF AB                    ..
        .addr   FnCRASH                         ; CF73 04 CC                    ..
        .addr   FnERR                           ; CF75 0D A9                    ..
        .addr   FnERL                           ; CF77 14 A9                    ..
        .addr   FnVCT                           ; CF79 6A A9                    j.
; ----------------------------------------------------------------------------
