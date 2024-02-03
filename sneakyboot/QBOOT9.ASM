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
        DB    &H0A,&H05       ; AANTAL SECTOREN OP SCHIJF         :  &H13-&H14
        DB    &HF9            ; MEDIUM 80 tr.,9 sec./tr.,2 sides  :  &H15
        DB    &H03,&H00       ; AANTAL SECTOREN PER FAT           :  &H16-&H17
        DB    &H09,&H00       ; AANTAL SECTOREN PER TRACK         :  &H18-&H19
        DB    &H02,&H00       ; AANTAL ZIJDEN                     :  &H1A-&H1B
        DB    &H00,&H00       ; AANTAL VERBORGEN SECTOREN         :  &H1C-&H1D
        JR    &HC030          ; VOOR OUDE DISKROMS
        DB    "FIRST CLASS BOOT"

; SCHAKEL MAIN-ROM IN
        DI
        LD    A,(&HFCC1)
        LD    H,0
        CALL  &H24

; MAAK SCHERM ZWART

        LD    A,15
        LD    (&HF3E9),A      ; VOORGROND
        XOR   A
        LD    (&HF3EA),A      ; ACHTERGR.
        LD    (&HF3EB),A      ; BORDER

        LD    HL,TEXT
LOOP:   LD    A,(HL)
        CP    "$"
        JR    Z,BOOTEN
        RST   &H18
        JR    LOOP

BOOTEN:
        XOR   A
        LD    (&HFC9E),A
WAIT:   LD    A,(&HFC9E)
        CP    5
        JR    NZ,WAIT

TEXT:   DB    "No boot found in virus!$"


; ROEP SCHERM MODE AAN

        XOR   A
        LD    (&HF3E9),A
        LD    A,5             ; SCREEN 7
        CALL  &H5F            ; CHGMOD

; laadt ML

        LD    DE,14
        LD    HL,&HC000
        LD    BC,&H01F9
        CALL  &H0144

        JP    &HC000

        ORG   &HC100

        DB    "****************"
        DB    "**            **"
        DB    "** QUASAR  #9 **"
        DB    "**            **"
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

