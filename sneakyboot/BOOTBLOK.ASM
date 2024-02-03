        ORG   &HC000

; VARIABELEN DIE PER QUASAR VERSCHILLEND KUNNEN ZIJN, NAAR WENS VERANDEREN

ADRES:  EQU   &HC100          ; HIER KOMT DE TE LADEN DATA
PROGRA: EQU   &HC100          ; HIER WORDT NA HET LADEN NAAR TOE GESPRONGEN

; BOOT SECTOR VOOR QUASAS #X, (C) FCS 1991 (TURBO-R/MSX DOS 2.xx  COMPATIBLE)
; KMcs 1991

; NU KOMT EERST DE GEWONE INDELING                                :   ADRES :

        DB    &HEB            ; DIT IS EEN DOS DISK               :  &H00
        DB    &HFE            ; ???  jump instructie 8086         :  &H01
        DB    &H90            ; ???                               :  &H02
        DB    "QUASAR#5"      ; VOLUME NAAM (TURBO-R)             :  &H03-&H0A
        DB    &H00,&H02       ; 512 BYTES/SECTOR                  :  &H0B-&H0C
        DB    &H02            ; AANTAL SECTOREN/CLUSTER           :  &H0D
        DB    &H01,&H00       ; AANTAL GERESERVEERDE SECTOREN     :  &H0E,&H0F
        DB    &H02            ; AANTAL FAT'S                      :  &H10
        DB    &H70,&H00       ; AANTAL DIRECTORY ENTRIES          :  &H11-&H12
        DB    &HA0,&H05       ; AANTAL SECTOREN OP SCHIJF         :  &H13-&H14
        DB    &HF9            ; MEDIUM 80 tr.,9 sec./tr.,2 sides  :  &H15
        DB    &H03,&H00       ; AANTAL SECTOREN PER FAT           :  &H16-&H17
        DB    &H09,&H00       ; AANTAL SECTOREN PER TRACK         :  &H18-&H19
        DB    &H02,&H00       ; AANTAL ZIJDEN                     :  &H1A-&H1B
        DB    &H00,&H00       ; AANTAL VERBORGEN SECTOREN         :  &H1C-&H1D
        DB    &H18,&H10       ; JR &HC030 voor "oude" diskroms    :  &H1E-&H1F
        DB    "VOL_ID"        ; VOLUME ID                         :  &H20-&H2F
        DB    " FCS "         ; ""     ""                         :
        DB    "1991 "         ;



; QUASAR BOOT PROGRAMMA
; (C) 1990-1991 Jurgen Kramer
; (C) KMcs '90,91
; (C) FCS 1991

        ORG   &HC030

; SCHAKEL MAINROM IN

        DI
        LD    A,(&HFCC1)
        LD    HL,&H00
        CALL  &H24

; ANTI-STOP

        XOR   A
        LD    HL,&HFBB0
        LD    (HL),A
        INC   A
        INC   HL
        LD    (HL),A

; SCHERM KLEUREN OP NUL

        XOR   A
        LD    HL,&HF3E9       ; VOORGROND
        LD    (HL),A
        INC   HL
        LD    (HL),A          ; ACHTERGROND
        INC   HL
        LD    (HL),A          ; RAND

; SCHERM NUL INSCHAKELEN

        CALL  &H5F

; LEES KLOKCHIP UIT M.B.V. OUT'S
; (C) 1991 by KMcs, Jurgen Kramer

; stel klokchip in

; VOORGRONDKLEUR

        DI
        LD    A,&H0D
        OUT   (&HB4),A
        INC   A               ;  LD A,&H0E
        OUT   (&HB5),A
        LD    A,&H06
        OUT   (&HB4),A

; SLA INGESTELD WAARDE OP (&HFB18) & SCHIJF NIEWE WAARDE

        IN    A,(&HB5)
        LD    (&HFB18),A      ; OUDE WAARDE
        XOR   A               ; A=0
        OUT   (&HB5),A        ; NIEUWE

; ACHTERGRONDKLEUR

        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H07
        OUT   (&HB4),A

; SLA INGESTELD WAARDE OP (&HFB19) & SCHIJF NIEWE WAARDE

        IN    A,(&HB5)
        LD    (&HFB19),A      ; OUDE WAARDE
        XOR   A               ; A=0
        OUT   (&HB5),A        ; NIEUWE

;RANDKLEUR

        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H08
        OUT   (&HB4),A

; SLA INGESTELD WAARDE OP (&HFB1A) & SCHIJF NIEWE WAARDE

        IN    A,(&HB5)
        LD    (&HFB1A),A      ; OUDE WAARDE
        XOR   A               ; A=0
        OUT   (&HB5),A        ; NIEUWE
        EI

; SET AUTOSTART HOOK + GA NAAR BASIC
; (C) FCS 1991, KMcs 1991, Jurgen Kramer

BASIC:  EQU   &H4022          ; HIER MOET NAARTOE WORDEN GESPRONGEN OM BASIC
;                             ; IN TE SCHAKELEN (ALLEEN VANAF BOOT!!)
HAUTO:  EQU   &HFEDA          ; ADRES AUTOSTART HOOK

; SET AUTO HOOK

        LD    A,&HC3          ; JUMP INSTRUCTIE
        LD    (HAUTO),A
        LD    HL,CONT         ; ADRES WAAR NAARTOE WORDT GESPRONGEN
        LD    (HAUTO+1),HL

; SCHAKEL BASIC IN

        JP    BASIC

; BASIC ROEPT DIT PROGRAMMA WEER AAN OP ADRES "CONT"

CONT:   PUSH  AF
        PUSH  BC
        PUSH  DE
        PUSH  HL

        LD    A,&HC9          ; SCHAKEL HOOK WEER UIT
        LD    (HAUTO),A

; LEES ORG. WAARDEN UIT GEHEUGEN EN ZET ZE WEER IN DE KLOKCHIP
; (C) 1991 by KMcs, Jurgen Kramer

; stel klokchip in

; VOORGRONDKLEUR

        DI
        LD    A,&H0D
        OUT   (&HB4),A
        INC   A               ;    LD    A,&H0E
        OUT   (&HB5),A
        LD    A,&H06
        OUT   (&HB4),A

; HAAL INGESTELDE WAARDE OP (&HFB18) & SCHIJF WEG

        LD    A,(&HFB18)
        OUT   (&HB5),A

; ACHTERGRONDKLEUR

        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H07
        OUT   (&HB4),A

; HAAL INGESTELDE WAARDE OP (&HFB19) & SCHIJF WEG

        LD    A,(&HFB19)
        OUT   (&HB5),A

; RANDKLEUR

        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H08
        OUT   (&HB4),A

; HAAL INGESTELDE WAARDE OP (&HFB1A) & SCHIJF WEG

        LD    A,(&HFB1A)
        OUT   (&HB5),A
        EI

; diskread II nu via de MAIN-ROM
; (C) Jurgen Kramer 1991, (C) FCS 1991

        LD    HL,&HD000       ; HIER KOMT INGELZEN DATA
        LD    DE,14           ; SECTOR NUMMER
        LD    BC,&H02F9       ; AANTAL SECTOREN + SOORT DISK
        XOR   A               ; DRIVE NUMMER
        CALL  &H0144          ; ROUTINE 'PHYDIO'

        JP    &HD000

; DEZE MANIER IS WEL 'VEILIGER' DAN DISKRD I

; PLAATS TEKST IN BOOTBLOK

        ORG   &HC100

        DB    "----------------"
        DB    "-              -"
        DB    "-  QUASAR  #6  -"
        DB    "-              -"
        DB    "----------------"

        DB    "                "
        DB    " Copyright 1991 "
        DB    "                "
        DB    "  First         "
        DB    "  Class         "
        DB    "  Software      "
        DB    "                "
        DB    "Jurgen Kramer   "
        DB    "Jeffrey Timmer  "
        DB    "John v Poelgeest"
        DB    "Roderik Muit    "

        END

