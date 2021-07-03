; 60hz.asm
; MSX-DOS program to enable 60Hz mode on MSX2/2+/TR
; v1.0 03-Jul-2021 Jurgen Kramer

; Assemble with zasm


BDOS	equ	0005h
CALSLT  equ 001ch
EXPTBL  equ 0fcc1h
WRTVDP  equ 0047h
RDSLT   equ 000ch


MSXVER  equ 002dh
REG9SAV equ 0ffe8h

    org 0100h


    call GETVER
    or a                        ; MSX 1 = 0, MSX2 = 1, MSX2+ = 2, Turbo-R = 3
    jr z,end

    ld a,(REG9SAV)
    and 11111101b               ; Set bit 1 to 0 /NT = 0 for NTSC
    ld b,a

    ld ix,WRTVDP                ; BIOS call in ix
    ld c,9                      ; VDP register #9
    call BIOS

; Exit to DOS

end:
    ld  c,0
    jp BDOS


; BIOS calls

BIOS:
    ld iy,(EXPTBL-1)           ; BIOS slot in iy
    jp CALSLT


; Get MSX version

GETVER:
    ld ix,RDSLT                 ; Function to call in ix
    ld hl,MSXVER                ; Address to read in HL
    ld a,(EXPTBL)               ; SLOT to read in A
    jr BIOS
 

