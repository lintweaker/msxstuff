        ORG   &HC000

; NU KOMT EERST DE GEWONE INDELING                                :  ADRES:

        DB    &HEB            ; DIT IS EEN DOS DISK               :  &H00
        DB    &HFE            ; ???                               :  &H01
        DB    &H90            ; ???                               :  &H02
        DB    "FCS DISK"      ; VOLUME NAAM (TURBO-R)             :  &H03-&H0A
        DB    &H00,&H02       ; 512 BYTES/SECTOR                  :  &H0B-&H0C
        DB    &H02            ; AANTAL SECTOREN/CLUSTER           :  &H0D
        DB    &H01,&H00       ; AANTAL GERESERVEERDE SECTOREN     :  &H0E,&H0F
        DB    &H02            ; AANTAL FAT'S                      :  &H10
        DB    &H70,&H00       ; AANTAL DIRECTORY ENTRIES          :  &H11-&H12
        DB    &HD0,&H02       ; AANTAL SECTOREN OP SCHIJF         :  &H13-&H14
        DB    &HF8            ; MEDIUM 80 tr.,9 sec./tr.,2 sides  :  &H15
        DB    &H03,&H00       ; AANTAL SECTOREN PER FAT           :  &H16-&H17
        DB    &H09,&H00       ; AANTAL SECTOREN PER TRACK         :  &H18-&H19
        DB    &H01,&H00       ; AANTAL ZIJDEN                     :  &H1A-&H1B
        DB    &H00,&H00       ; AANTAL VERBORGEN SECTOREN         :  &H1C-&H1D
        JR    &HC030          ; VOOR OUDE DISKROMS
        DB    "FIRST CLASS BOOT"

; SCHAKEL MAIN-ROM IN
        DI
        LD    A,(&HFCC1)
        LD    H,0
        CALL  &H24

; MAAK SCHERM ZWART
        XOR   A
        LD    (&HF3E9),A      ; VOORGROND
        LD    (&HF3EA),A      ; ACHTERGR.
        LD    (&HF3EB),A      ; BORDER

; ROEP SCHERM MODE AAN
        LD    A,5             ; SCREEN 7
        CALL  &H5F            ; CHGMOD

; SCHAKEL RAM-BANK 3 IN OP &H8000
        LD    A,3
        OUT   (&HFE),A

; LAAD MCODE
        LD    HL,&H8000
        LD    DE,12
        LD    BC,&H20F8
        XOR   A
        CALL  &H0144
        CP    0
        JP    NZ,&H4022
        LD    HL,&HBE29
        LD    DE,&HC200
        LD    BC,&H01D7
        LDIR
        CALL  &HC200

; DEZE MCODE IS SPECIAAL GEMAAKT OM NAAR BASIC TE GAAN!!!!

; ZET CLOCKCHIP
        DI
        LD    A,&H0D
        OUT   (&HB4),A
        INC   A
        OUT   (&HB5),A
        LD    A,&H06
        OUT   (&HB4),A
        IN    A,(&HB5)
        LD    (&HFB18),A
        XOR   A
        OUT   (&HB5),A
        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H07
        OUT   (&HB4),A
        IN    A,(&HB5)
        LD    (&HFB19),A
        XOR   A
        OUT   (&HB5),A
        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H08
        OUT   (&HB4),A
        IN    A,(&HB5)
        LD    (&HFB1A),A
        XOR   A
        OUT   (&HB5),A
        EI
        LD    A,&HC3
        LD    (&HFEDA),A
        LD    HL,BASIC
        LD    (&HFEDB),HL
        JP    &H4022

BASIC:  ; DIT WORDT NA BASIC AANGEROEPEN
        PUSH  AF
        PUSH  BC
        PUSH  DE
        PUSH  HL
        LD    A,&HC9
        LD    (&HFEDA),A
        DI
        LD    A,&H0D
        OUT   (&HB4),A
        INC   A
        OUT   (&HB5),A
        LD    A,&H06
        OUT   (&HB4),A
        LD    A,(&HFB18)
        OUT   (&HB5),A
        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H07
        OUT   (&HB4),A
        LD    A,(&HFB19)
        OUT   (&HB5),A
        LD    A,&H0D
        OUT   (&HB4),A
        LD    A,&H06
        OUT   (&HB5),A
        LD    A,&H08
        OUT   (&HB4),A
        LD    A,(&HFB1A)
        OUT   (&HB5),A
        EI
        POP   HL
        POP   DE
        POP   BC
        POP   AF
        RET



        ORG   &HC100

        DB    "****************"
        DB    "**            **"
        DB    "**   QUASAR   **"
        DB    "**   SPECIAL  **"
        DB    "****************"

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

