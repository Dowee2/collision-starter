; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $33, $30, $34, $29, $00, $00, $00

*=$0900

CAT_SPRITE_PIXELS=$2E80
MUSHROOM_SPRITE_PIXELS=CAT_SPRITE_PIXELS+64

; address of the PRINTLINE routine in the kernel
PRINTLINE=$AB1E
PROGRAM_START

        ; clear the screen
        lda #<CLEAR_CHAR
        ldy #>CLEAR_CHAR
        jsr PRINTLINE
; start your code here
        jsr LOAD_CAT_SPRITE
        jsr LOAD_MUSHROOM_SPRITE
        jsr LOAD_ROWS
        jsr MOVE_CAT



program_exit
        rts


; please don't change anything after this line.
; bad stuff will happen
CLEAR_CHAR
        BYTE 147 ; the clearscreen character
        BYTE 13, 00 ; carriage return & terminate the string


; internal variable for WAIT
JIFFY_COUNTER BYTE 00

; Pauses the program for approximately 1 second
WAIT_1_SECOND
        ; save stack
        php ; push status
        pha ; push accumulator
        txa ; push x
        pha
        tya ; push y
        pha

; count up one second
        lda $A2 ; low byte of jiffy loop
        adc #60 ; add 60 jiffies
        sta JIFFY_COUNTER

count_jiffies_loop
        lda $A2 ; changes every time!
        cmp JIFFY_COUNTER
        bne count_jiffies_loop


; repair register state
        pla ; pull y
        tay
        pla ; pull x
        tax
        pla ; pull a
        plp ; pull status

        rts


BACKGROUND_COLLISON
        LDA #1
        AND $D01F
        BEQ  set_color_white
        BNE  set_color_red

        rts

set_color_red
        LDA #$1
        STA $D027
        jsr MOVE_CAT
        rts

set_color_white
        LDA #$2
        STA $D027
        jsr MOVE_CAT

        rts

MOVE_CAT
lower_cat_loop 
        LDA $D001
        ADC #10
        STA $D001
        jsr WAIT_1_SECOND

        BNE lower_cat_loop
        BEQ lower_cat_loop

        rts

LOAD_CAT_SPRITE
        jsr LOAD_CAT_SPRITE_DATA
        jsr SET_CAT_POINTER
        jsr SET_CAT_LOCATION
        LDA #1
        STA $D015

        rts


LOAD_CAT_SPRITE_DATA
        LDX #64
load_sprite_loop        ;loads sprites into memory from ANT_DATA
        LDA CAT_SPRITE_DATA,x ;Loads the Memory Loacation from the start of ANT DATA + X into A
        STA $2E80,x     ;Stores A into Memory Location 2E80 + X
        DEX     ;x= x-1
        BNE load_sprite_loop 

        rts

SET_CAT_POINTER
        LDA #$2E80/64
        STA $07F8

        rts

SET_CAT_LOCATION
        LDA #150
        STA $D000 ;Set X Coord of Sprite
        
        LDA #150
        STA $D001 ;Set Y Coord of Sprite

        rts


LOAD_MUSHROOM_SPRITE 

        jsr LOAD_MUSHROOM_SPRITE_DATA
        jsr SET_MUSHROOM_POINTER
        jsr SET_MUSHROOM_LOCATION
        LDA #3
        STA $D015
        
        rts

LOAD_MUSHROOM_SPRITE_DATA
        LDX #64
load_sprite_MUSH_loop        ;loads sprites into memory from ANT_DATA
        LDA MUSHROOM_SPRITE_DATA,x ;Loads the Memory Loacation from the start of ANT DATA + X into A
        STA $2EC0,x     ;Stores A into Memory Location 2E80 + X
        DEX     ;x= x-1
        BNE load_sprite_MUSH_loop 

SET_MUSHROOM_POINTER
        LDA #$2EC0/64
        STA $07F9

        rts

SET_MUSHROOM_LOCATION
        LDA #150
        STA $D002 ;Set X Coord of Sprite
        
        LDA #200
        STA $D003 ;Set Y Coord of Sprite

        rts

LOAD_ROWS
        jsr LOAD_ROW_4
        jsr LOAD_ROW_11
        jsr LOAD_ROW_17
        jsr LOAD_ROW_22

        rts

LOAD_ROW_4
        LDX #$27
load_row4_loop
        LDA ROW4_DATA,x 
        STA $04a0,x - #1
        DEX
        BNE load_row4_loop

        rts

LOAD_ROW_11
        LDX #$27
load_row11_loop
        LDA ROW11_DATA,x 
        STA $06A8,x - #1
        DEX
        BNE load_row11_loop

        rts

LOAD_ROW_17
        LDX #$27
load_row17_loop
        LDA ROW17_DATA,x 
        STA $0798,x - #1
        DEX
        BNE load_row17_loop

        rts

LOAD_ROW_22
        LDX #$27
load_row22_loop
        LDA ROW22_DATA,x 
        STA $0950,x -#1 
        DEX
        BNE load_row22_loop

        rts

; Screen 1 -  Screen datA
ROW4_DATA
        BYTE    $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
ROW11_DATA
        BYTE    $53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53
ROW17_DATA
        BYTE    $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
ROW22_DATA
        BYTE    $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F

; sprite data
MUSHROOM_SPRITE_DATA
 BYTE $07,$FF,$E0
 BYTE $0F,$FF,$F0
 BYTE $19,$80,$18
 BYTE $30,$31,$8C
 BYTE $60,$31,$86
 BYTE $63,$00,$06
 BYTE $E3,$06,$07
 BYTE $C0,$06,$63
 BYTE $CC,$30,$63
 BYTE $CC,$30,$03
 BYTE $C1,$86,$1B
 BYTE $7F,$FF,$FE
 BYTE $1F,$FF,$F8
 BYTE $08,$00,$08
 BYTE $08,$C3,$08
 BYTE $08,$00,$08
 BYTE $08,$00,$08
 BYTE $08,$42,$08
 BYTE $08,$3C,$08
 BYTE $0C,$00,$18
 BYTE $07,$FF,$F0
 BYTE $00

CAT_SPRITE_DATA
 BYTE $70,$00,$0E
 BYTE $8C,$00,$31
 BYTE $B2,$00,$4D
 BYTE $BB,$00,$DD
 BYTE $B9,$FF,$9D
 BYTE $B7,$FF,$ED
 BYTE $AF,$FF,$F5
 BYTE $9F,$7E,$F9
 BYTE $7E,$BD,$7E
 BYTE $3D,$DB,$BC
 BYTE $7F,$FF,$FF
 BYTE $FF,$FF,$FF
 BYTE $FF,$E7,$FF
 BYTE $FF,$FF,$FF
 BYTE $FF,$FF,$FF
 BYTE $FF,$7E,$FF
 BYTE $FF,$BD,$FF
 BYTE $FF,$DB,$FF
 BYTE $7F,$E7,$FE
 BYTE $3F,$FF,$FC
 BYTE $0F,$FF,$F8
 BYTE $00

