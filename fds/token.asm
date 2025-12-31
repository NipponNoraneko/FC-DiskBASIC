;.include	"fnc.inc"
; ----------------------------------------------------------------------------
tTokenTable:
iGOTO:  .byte   $80,$47,$4F,$54,$4F             ; CCAB 80 47 4F 54 4F           .GOTO
iGOSUB: .byte   $81,$47,$4F,$53,$55,$42         ; CCB0 81 47 4F 53 55 42        .GOSUB
iRUN:   .byte   $82,$52,$55,$4E                 ; CCB6 82 52 55 4E              .RUN
iRETURN:.byte   $83,$52,$45,$54,$55,$52,$4E     ; CCBA 83 52 45 54 55 52 4E     .RETURN
iRESTORE:
        .byte   $84,$52,$45,$53,$54,$4F,$52,$45 ; CCC1 84 52 45 53 54 4F 52 45  .RESTORE
iTHEN:  .byte   $85,$54,$48,$45,$4E             ; CCC9 85 54 48 45 4E           .THEN
iLIST:  .byte   $86,$4C,$49,$53,$54             ; CCCE 86 4C 49 53 54           .LIST
iSYSTEM:.byte   $87,$53,$59,$53,$54,$45,$4D     ; CCD3 87 53 59 53 54 45 4D     .SYSTEM
iTO:    .byte   $88,$54,$4F                     ; CCDA 88 54 4F                 .TO
iSTEP:  .byte   $89,$53,$54,$45,$50             ; CCDD 89 53 54 45 50           .STEP
iSPRITE:.byte   $8A,$53,$50,$52,$49,$54,$45     ; CCE2 8A 53 50 52 49 54 45     .SPRITE
iPRINT: .byte   $8B,$50,$52,$49,$4E,$54         ; CCE9 8B 50 52 49 4E 54        .PRINT
iFOR:   .byte   $8C,$46,$4F,$52                 ; CCEF 8C 46 4F 52              .FOR
iNEXT:  .byte   $8D,$4E,$45,$58,$54             ; CCF3 8D 4E 45 58 54           .NEXT
iPAUSE: .byte   $8E,$50,$41,$55,$53,$45         ; CCF8 8E 50 41 55 53 45        .PAUSE
iINPUT: .byte   $8F,$49,$4E,$50,$55,$54         ; CCFE 8F 49 4E 50 55 54        .INPUT
iLINPUT:.byte   $90,$4C,$49,$4E,$50,$55,$54     ; CD04 90 4C 49 4E 50 55 54     .LINPUT
iDATA:  .byte   $91,$44,$41,$54,$41             ; CD0B 91 44 41 54 41           .DATA
iIF:    .byte   $92,$49,$46                     ; CD10 92 49 46                 .IF
iREAD:  .byte   $93,$52,$45,$41,$44             ; CD13 93 52 45 41 44           .READ
iDIM:   .byte   $94,$44,$49,$4D                 ; CD18 94 44 49 4D              .DIM
iREM:   .byte   $95,$52,$45,$4D                 ; CD1C 95 52 45 4D              .REM
iSTOP:  .byte   $96,$53,$54,$4F,$50             ; CD20 96 53 54 4F 50           .STOP
iCONT:  .byte   $97,$43,$4F,$4E,$54             ; CD25 97 43 4F 4E 54           .CONT
iCLS:   .byte   $98,$43,$4C,$53                 ; CD2A 98 43 4C 53              .CLS
iCLEAR: .byte   $99,$43,$4C,$45,$41,$52         ; CD2E 99 43 4C 45 41 52        .CLEAR
iON:    .byte   $9A,$4F,$4E                     ; CD34 9A 4F 4E                 .ON
iOFF:   .byte   $9B,$4F,$46,$46,$9C,$43,$55,$54 ; CD37 9B 4F 46 46 9C 43 55 54  .OFF.CUT
iNEW:   .byte   $9D,$4E,$45,$57                 ; CD3F 9D 4E 45 57              .NEW
iPOKE:  .byte   $9E,$50,$4F,$4B,$45             ; CD43 9E 50 4F 4B 45           .POKE
iCGSET: .byte   $9F,$43,$47,$53,$45,$54         ; CD48 9F 43 47 53 45 54        .CGSET
iVIEW:  .byte   $A0,$56,$49,$45,$57             ; CD4E A0 56 49 45 57           .VIEW
iMOVE:  .byte   $A1,$4D,$4F,$56,$45             ; CD53 A1 4D 4F 56 45           .MOVE
iEND:   .byte   $A2,$45,$4E,$44                 ; CD58 A2 45 4E 44              .END
iPLAY:  .byte   $A3,$50,$4C,$41,$59             ; CD5C A3 50 4C 41 59           .PLAY
iBEEP:  .byte   $A4,$42,$45,$45,$50             ; CD61 A4 42 45 45 50           .BEEP
iLOAD:  .byte   $A5,$4C,$4F,$41,$44             ; CD66 A5 4C 4F 41 44           .LOAD
iSAVE:  .byte   $A6,$53,$41,$56,$45             ; CD6B A6 53 41 56 45           .SAVE
iPOSITION:
        .byte   $A7,$50,$4F,$53,$49,$54,$49,$4F ; CD70 A7 50 4F 53 49 54 49 4F  .POSITIO
        .byte   $4E                             ; CD78 4E                       N
iKEY:   .byte   $A8,$4B,$45,$59                 ; CD79 A8 4B 45 59              .KEY
iCOLOR: .byte   $A9,$43,$4F,$4C,$4F,$52         ; CD7D A9 43 4F 4C 4F 52        .COLOR
iDEF:   .byte   $AA,$44,$45,$46                 ; CD83 AA 44 45 46              .DEF
iCGEN:  .byte   $AB,$43,$47,$45,$4E             ; CD87 AB 43 47 45 4E           .CGEN
iSWAP:  .byte   $AC,$53,$57,$41,$50             ; CD8C AC 53 57 41 50           .SWAP
iCALL:  .byte   $AD,$43,$41,$4C,$4C             ; CD91 AD 43 41 4C 4C           .CALL
iLOCATE:.byte   $AE,$4C,$4F,$43,$41,$54,$45     ; CD96 AE 4C 4F 43 41 54 45     .LOCATE
iPALET: .byte   $AF,$50,$41,$4C,$45,$54         ; CD9D AF 50 41 4C 45 54        .PALET
iERA:   .byte   $B0,$45,$52,$41                 ; CDA3 B0 45 52 41              .ERA
iTR:    .byte   $B1,$54,$52                     ; CDA7 B1 54 52                 .TR
iFIND:  .byte   $B2,$46,$49,$4E,$44             ; CDAA B2 46 49 4E 44           .FIND
FDS:	.byte   $B3,"FDS"
iBGTOOL:.byte   $B4,$42,$47,$54,$4F,$4F,$4C     ; CDB4 B4 42 47 54 4F 4F 4C     .BGTOOL
iAUTO:  .byte   $B5,$41,$55,$54,$4F             ; CDBB B5 41 55 54 4F           .AUTO
iDELETE:.byte   $B6,$44,$45,$4C,$45,$54,$45     ; CDC0 B6 44 45 4C 45 54 45     .DELETE
iRENUM: .byte   $B7,$52,$45,$4E,$55,$4D         ; CDC7 B7 52 45 4E 55 4D        .RENUM
iFILTER:.byte   $B8,$46,$49,$4C,$54,$45,$52     ; CDCD B8 46 49 4C 54 45 52     .FILTER
iCLICK: .byte   $B9,$43,$4C,$49,$43,$4B         ; CDD4 B9 43 4C 49 43 4B        .CLICK
iSCREEN:.byte   $BA,$53,$43,$52,$45,$45,$4E     ; CDDA BA 53 43 52 45 45 4E     .SCREEN
iBACKUP:.byte   $BB,$42,$41,$43,$4B,$55,$50     ; CDE1 BB 42 41 43 4B 55 50     .BACKUP
iERROR: .byte   $BC,$45,$52,$52,$4F,$52         ; CDE8 BC 45 52 52 4F 52        .ERROR
iRESUME:.byte   $BD,$52,$45,$53,$55,$4D,$45     ; CDEE BD 52 45 53 55 4D 45     .RESUME
iBGPUT: .byte   $BE,$42,$47,$50,$55,$54         ; CDF5 BE 42 47 50 55 54        .BGPUT
iBGGET: .byte   $BF,$42,$47,$47,$45,$54         ; CDFB BF 42 47 47 45 54        .BGGET
iCAN:   .byte   $C0,$43,$41,$4E                 ; CE01 C0 43 41 4E              .CAN
iXOR:   .byte   $EF,$58,$4F,$52                 ; CE05 EF 58 4F 52              .XOR
iOR:    .byte   $F0,$4F,$52                     ; CE09 F0 4F 52                 .OR
iAND:   .byte   $F1,$41,$4E,$44                 ; CE0C F1 41 4E 44              .AND
iNOT:   .byte   $F2,$4E,$4F,$54                 ; CE10 F2 4E 4F 54              .NOT
i_NE:   .byte   $F3,$3C,$3E                     ; CE14 F3 3C 3E                 .<>
i_GE:   .byte   $F4,$3E,$3D                     ; CE17 F4 3E 3D                 .>=
i_LE:   .byte   $F5,$3C,$3D                     ; CE1A F5 3C 3D                 .<=
i_EQ:   .byte   $F6,$3D                         ; CE1D F6 3D                    .=
i_GT:   .byte   $F7,$3E                         ; CE1F F7 3E                    .>
i_LT:   .byte   $F8,$3C                         ; CE21 F8 3C                    .<
i_PLUS: .byte   $F9,$2B                         ; CE23 F9 2B                    .+
i_MINUS:.byte   $FA,$2D                         ; CE25 FA 2D                    .-
iMOD:   .byte   $FB,$4D,$4F,$44                 ; CE27 FB 4D 4F 44              .MOD
i_DIV:  .byte   $FC,$2F                         ; CE2B FC 2F                    ./
i_MUL:  .byte   $FD,$2A                         ; CE2D FD 2A                    .*
iABS:   .byte   $CA,$41,$42,$53                 ; CE2F CA 41 42 53              .ABS
iASC:   .byte   $CB,$41,$53,$43                 ; CE33 CB 41 53 43              .ASC
iSTR_STR:
        .byte   $CC,$53,$54,$52,$24             ; CE37 CC 53 54 52 24           .STR$
iFRE:   .byte   $CD,$46,$52,$45                 ; CE3C CD 46 52 45              .FRE
iLEN:   .byte   $CE,$4C,$45,$4E                 ; CE40 CE 4C 45 4E              .LEN
iPEEK:  .byte   $CF,$50,$45,$45,$4B             ; CE44 CF 50 45 45 4B           .PEEK
iRND:   .byte   $D0,$52,$4E,$44                 ; CE49 D0 52 4E 44              .RND
iSGN:   .byte   $D1,$53,$47,$4E                 ; CE4D D1 53 47 4E              .SGN
iSPC:   .byte   $D2,$53,$50,$43                 ; CE51 D2 53 50 43              .SPC
iTAB:   .byte   $D3,$54,$41,$42                 ; CE55 D3 54 41 42              .TAB
iMID_STR:
        .byte   $D4,$4D,$49,$44,$24             ; CE59 D4 4D 49 44 24           .MID$
iSTICK: .byte   $D5,$53,$54,$49,$43,$4B         ; CE5E D5 53 54 49 43 4B        .STICK
iSTRIG: .byte   $D6,$53,$54,$52,$49,$47         ; CE64 D6 53 54 52 49 47        .STRIG
iXPOS:  .byte   $D7,$58,$50,$4F,$53             ; CE6A D7 58 50 4F 53           .XPOS
iYPOS:  .byte   $D8,$59,$50,$4F,$53             ; CE6F D8 59 50 4F 53           .YPOS
iVAL:   .byte   $D9,$56,$41,$4C                 ; CE74 D9 56 41 4C              .VAL
iPOS:   .byte   $DA,$50,$4F,$53                 ; CE78 DA 50 4F 53              .POS
iCSRLIN:.byte   $DB,$43,$53,$52,$4C,$49,$4E     ; CE7C DB 43 53 52 4C 49 4E     .CSRLIN
iCHR_STR:
        .byte   $DC,$43,$48,$52,$24             ; CE83 DC 43 48 52 24           .CHR$
iHEX_STR:
        .byte   $DD,$48,$45,$58,$24             ; CE88 DD 48 45 58 24           .HEX$
iINKEY_STR:
        .byte   $DE,$49,$4E,$4B,$45,$59,$24     ; CE8D DE 49 4E 4B 45 59 24     .INKEY$
iRIGHT_STR:
        .byte   $DF,$52,$49,$47,$48,$54,$24     ; CE94 DF 52 49 47 48 54 24     .RIGHT$
iLEFT_STR:
        .byte   $E0,$4C,$45,$46,$54,$24         ; CE9B E0 4C 45 46 54 24        .LEFT$
iSCR_STR:
        .byte   $E1,$53,$43,$52,$24             ; CEA1 E1 53 43 52 24           .SCR$
iINSTR: .byte   $E2,$49,$4E,$53,$54,$52         ; CEA6 E2 49 4E 53 54 52        .INSTR
iCRASH: .byte   $E3,$43,$52,$41,$53,$48         ; CEAC E3 43 52 41 53 48        .CRASH
iERR:   .byte   $E4,$45,$52,$52                 ; CEB2 E4 45 52 52              .ERR
iERL:   .byte   $E5,$45,$52,$4C                 ; CEB6 E5 45 52 4C              .ERL
iVCT:   .byte   $E6,$56,$43,$54,$FF             ; CEBA E6 56 43 54 FF           .VCT.
; ----------------------------------------------------------------------------
tCommandAddr:
        .addr   GOTO                            ; CEBF C6 96                    ..
        .addr   GOSUB                           ; CEC1 48 96                    H.
        .addr   RUN                             ; CEC3 B0 86                    ..
        .addr   RETURN                          ; CEC5 A6 96                    ..
        .addr   RESTORE                         ; CEC7 C9 9E                    ..
        .addr   ErrorSyntax                     ; CEC9 91 84                    ..
        .addr   LIST                            ; CECB 67 87                    g.
        .addr   SYSTEM_BACKUP                   ; CECD 8F 81                    ..
        .addr   ErrorSyntax                     ; CECF 91 84                    ..
        .addr   ErrorSyntax                     ; CED1 91 84                    ..
        .addr   SPRITE                          ; CED3 FC AF                    ..
        .addr   PRINT                           ; CED5 C5 88                    ..
        .addr   FOR                             ; CED7 FC 97                    ..
        .addr   NEXT                            ; CED9 87 98                    ..
        .addr   PAUSE                           ; CEDB 16 97                    ..
        .addr   INPUT                           ; CEDD 3C 99                    <.
        .addr   LINPUT                          ; CEDF 6C 9A                    l.
        .addr   DATA_REM                        ; CEE1 67 84                    g.
        .addr   IF                              ; CEE3 82 97                    ..
        .addr   READ                            ; CEE5 36 9F                    6.
        .addr   DIM                             ; CEE7 0C 9C                    ..
        .addr   DATA_REM                        ; CEE9 67 84                    g.
        .addr   STOP                            ; CEEB 5B 88                    [.
        .addr   CONT                            ; CEED 9C 88                    ..
        .addr   LAE0A                           ; CEEF 0A AE                    ..
        .addr   CLEAR                           ; CEF1 A4 97                    ..
        .addr   ON                              ; CEF3 FD 9A                    ..
        .addr   ErrorSyntax                     ; CEF5 91 84                    ..
        .addr   CUT                             ; CEF7 DC CB                    ..
        .addr   NEW                             ; CEF9 B6 84                    ..
        .addr   POKE                            ; CEFB 5D 97                    ].
        .addr   CGSET                           ; CEFD 4F AF                    O.
        .addr   VIEW                            ; CEFF 53 B1                    S.
        .addr   MOVE                            ; CF01 B3 CB                    ..
        .addr   END                             ; CF03 6A 82                    j.
        .addr   PLAY                            ; CF05 1E A0                    ..
        .addr   BEEP                            ; CF07 D0 BC                    ..
        .addr   LOAD                            ; CF09 E1 9D                    ..
        .addr   SAVE                            ; CF0B 64 9D                    d.
        .addr   POSITON                         ; CF0D 9B CB                    ..
        .addr   KEY                             ; CF0F 68 9B                    h.
        .addr   COLOR                           ; CF11 CA C4                    ..
        .addr   DEF                             ; CF13 98 B0                    ..
        .addr   CGEN                            ; CF15 D1 AE                    ..
        .addr   SWAP                            ; CF17 0E 9A                    ..
        .addr   CALL                            ; CF19 0A 97                    ..
        .addr   LOCATE                          ; CF1B 48 97                    H.
        .addr   PALET                           ; CF1D F3 AE                    ..
        .addr   ERA                             ; CF1F D9 CB                    ..
        .addr   TR                              ; CF21 2B 96                    +.
        .addr   FIND                            ; CF23 73 95                    s.
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
