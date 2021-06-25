;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 20100416.1
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Tue Aug 25 12:21:29 2020



	MODULE	mk1.c


	INCLUDE "z80_crt0.hdr"


	XREF _nametable
	LIB cpc_KeysData
	LIB cpc_UpdTileTable
	LIB cpc_InvalidateRect
	._def_keys
	defw $4404 ; LEFT O
	defw $4308 ; RIGHT P
	defw $4808 ; UP Q
	defw $4820 ; DOWN A
	defw $4580 ; BUTTON_A SPACE
	defw $4808 ; BUTTON_B Q
	defw $4204 ; KEY_ENTER
	defw $4804 ; KEY_ESC
	defw $4440 ; KEY_AUX1 M
	defw $4608 ; KEY_AUX2 T
	defw $4801 ; KEY_AUX3 1
	defw $4802 ; KEY_AUX4 2
	.vpClipStruct defb 1, 1 + 20, 1, 1 + 30
	.fsClipStruct defb 0, 24, 0, 32
;	SECTION	text

._spacer
	defw	i_1+0
;	SECTION	code

;	SECTION	text

._warp_to_level
	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._level_str
	defw	i_1+13
;	SECTION	code

	._def_keys_joy
	defw 0x4904, 0x4908, 0x4901, 0x4902, 0x4920, 0x4910
	defw 0x4004, 0x4804, 0x4880, 0x4780, 0x4801, 0x4802
	; aPPack decompressor
	; original source by dwedit
	; very slightly adapted by utopian
	; optimized by Metalbrain
	;hl = source
	;de = dest
	.depack ld ixl,128
	.apbranch1 ldi
	.aploop0 ld ixh,1 ;LWM = 0
	.aploop call ap_getbit
	jr nc,apbranch1
	call ap_getbit
	jr nc,apbranch2
	ld b,0
	call ap_getbit
	jr nc,apbranch3
	ld c,16 ;get an offset
	.apget4bits call ap_getbit
	rl c
	jr nc,apget4bits
	jr nz,apbranch4
	ld a,b
	.apwritebyte ld (de),a ;write a 0
	inc de
	jr aploop0
	.apbranch4 and a
	ex de,hl ;write a previous byte (1-15 away from dest)
	sbc hl,bc
	ld a,(hl)
	add hl,bc
	ex de,hl
	jr apwritebyte
	.apbranch3 ld c,(hl) ;use 7 bit offset, length = 2 or 3
	inc hl
	rr c
	ret z ;if a zero is encountered here, it is EOF
	ld a,2
	adc a,b
	push hl
	ld iyh,b
	ld iyl,c
	ld h,d
	ld l,e
	sbc hl,bc
	ld c,a
	jr ap_finishup2
	.apbranch2 call ap_getgamma ;use a gamma code * 256 for offset, another gamma code for length
	dec c
	ld a,c
	sub ixh
	jr z,ap_r0_gamma ;if gamma code is 2, use old r0 offset,
	dec a
	;do I even need this code?
	;bc=bc*256+(hl), lazy 16bit way
	ld b,a
	ld c,(hl)
	inc hl
	ld iyh,b
	ld iyl,c
	push bc
	call ap_getgamma
	ex (sp),hl ;bc = len, hl=offs
	push de
	ex de,hl
	ld a,4
	cp d
	jr nc,apskip2
	inc bc
	or a
	.apskip2 ld hl,127
	sbc hl,de
	jr c,apskip3
	inc bc
	inc bc
	.apskip3 pop hl ;bc = len, de = offs, hl=junk
	push hl
	or a
	.ap_finishup sbc hl,de
	pop de ;hl=dest-offs, bc=len, de = dest
	.ap_finishup2 ldir
	pop hl
	ld ixh,b
	jr aploop
	.ap_r0_gamma call ap_getgamma ;and a new gamma code for length
	push hl
	push de
	ex de,hl
	ld d,iyh
	ld e,iyl
	jr ap_finishup
	.ap_getbit ld a,ixl
	add a,a
	ld ixl,a
	ret nz
	ld a,(hl)
	inc hl
	rla
	ld ixl,a
	ret
	.ap_getgamma ld bc,1
	.ap_getgammaloop call ap_getbit
	rl c
	rl b
	call ap_getbit
	jr c,ap_getgammaloop
	ret

._unpack
	ld	hl,4	;const
	call	l_gintsp	;
	ld	(_ram_address),hl
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(_ram_destination),hl
	ld hl, (_ram_address)
	ld de, (_ram_destination)
	call depack
	ret


	._s_title
	BINARY "../bin/titlec.bin"
	._s_marco
	._s_ending
	BINARY "../bin/endingc.bin"

._blackout
	ld	hl,63 % 256	;const
	ld	a,l
	ld	(_rda),a
	ld a, 0xc0
	.bo_l1
	ld h, a
	ld l, 0
	ld b, a
	ld a, (_rda)
	ld (hl), a
	ld a, b
	ld d, a
	ld e, 1
	ld bc, 0x5ff
	ldir
	add 8
	jr nz, bo_l1
	ret


;	SECTION	text

._my_inks
	defm	""
	defb	13

	defm	""
	defb	4

	defm	""
	defb	21

	defm	""
	defb	11

	defm	""
	defb	22

	defm	""
	defb	18

	defm	""
	defb	19

	defm	""
	defb	6

	defm	""
	defb	28

	defm	""
	defb	12

	defm	""
	defb	14

	defm	""
	defb	23

	defm	""
	defb	30

	defm	""
	defb	0

	defm	""
	defb	20

	defm	""
	defb	10

;	SECTION	code


	._level_data defs 16
	._mapa defs 1 * 24 * 75
	._cerrojos defs 128 ; 32 * 4
	XDEF _ts
	XDEF tiles
	._tileset
	.tiles
	._font
	BINARY "../bin/font.bin"
	._tspatterns
	BINARY "../bin/work.bin"
	._malotes defs 1 * 24 * 3 * 10
	._hotspots defs 1 * 24 * 3
	._behs defs 48
	._sprites
	BINARY "../bin/sprites.bin"
	._sprite_17_a
	BINARY "../bin/sprites_extra.bin"
	._sprite_18_a
	defs 96, 0
	._sprite_19_a
	BINARY "../bin/sprites_bullet.bin"
	._map_bolts0
	BINARY "../bin/mapa0c.bin"
	._map_bolts1
	BINARY "../bin/mapa1c.bin"
	._map_bolts2
	BINARY "../bin/mapa2c.bin"
	._enems_hotspots0
	BINARY "../bin/enems_hotspots0c.bin"
	._enems_hotspots1
	BINARY "../bin/enems_hotspots1c.bin"
	._enems_hotspots2
	BINARY "../bin/enems_hotspots2c.bin"
	._enems_hotspots3
	BINARY "../bin/enems_hotspots3c.bin"
	._enems_hotspots4
	BINARY "../bin/enems_hotspots4c.bin"
	._behs0_1
	BINARY "../bin/behs0_1c.bin"
;	SECTION	text

._levels
	defb	1
	defb	24
	defb	23
	defb	13
	defb	7
	defb	99
	defw	_map_bolts2
	defw	_enems_hotspots4
	defw	_behs0_1
	defb	1
	defb	1
	defb	24
	defb	17
	defb	12
	defb	7
	defb	99
	defw	_map_bolts2
	defw	_enems_hotspots4
	defw	_behs0_1
	defb	3
	defb	1
	defb	24
	defb	23
	defb	12
	defb	7
	defb	99
	defw	_map_bolts0
	defw	_enems_hotspots0
	defw	_behs0_1
	defb	1
	defb	1
	defb	24
	defb	23
	defb	12
	defb	7
	defb	99
	defw	_map_bolts1
	defw	_enems_hotspots1
	defw	_behs0_1
	defb	3
	defb	1
	defb	24
	defb	11
	defb	12
	defb	7
	defb	99
	defw	_map_bolts2
	defw	_enems_hotspots4
	defw	_behs0_1
	defb	1
	defb	1
	defb	24
	defb	23
	defb	12
	defb	7
	defb	99
	defw	_map_bolts0
	defw	_enems_hotspots2
	defw	_behs0_1
	defb	3
	defb	1
	defb	24
	defb	23
	defb	12
	defb	7
	defb	99
	defw	_map_bolts1
	defw	_enems_hotspots3
	defw	_behs0_1
	defb	1
	defb	1
	defb	24
	defb	5
	defb	12
	defb	7
	defb	99
	defw	_map_bolts2
	defw	_enems_hotspots4
	defw	_behs0_1
	defb	3

;	SECTION	code

;	SECTION	text

._sm_cox
	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._sm_coy
	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._sm_invfunc
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16
	defw	cpc_PutSpTileMap8x16

;	SECTION	code

;	SECTION	text

._sm_updfunc
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b
	defw	cpc_PutTrSp8x16TileMap2b

;	SECTION	code

	._sm_sprptr
	defw _sprites + 0x000, _sprites + 0x040, _sprites + 0x080, _sprites + 0x0C0
	defw _sprites + 0x100, _sprites + 0x140, _sprites + 0x180, _sprites + 0x1C0
	defw _sprites + 0x200, _sprites + 0x240, _sprites + 0x280, _sprites + 0x2C0
	defw _sprites + 0x300, _sprites + 0x340, _sprites + 0x380, _sprites + 0x3C0
	defw _sprites + 0x400, _sprites + 0x440
	; LUT for transparent pixels in sprites
	; taken from CPCTelera
	._trpixlutc
	BINARY "assets/trpixlutc.bin"
;	SECTION	text

._decos_computer
	defm	"c s!"
	defb	131

	defm	""
	defb	34

	defm	"d$t%"
	defb	132

	defm	"&"
	defb	255

;	SECTION	code


;	SECTION	text

._decos_bombs
	defm	"D"
	defb	17

	defm	"B"
	defb	17

	defm	"q"
	defb	17

	defm	""
	defb	162

	defm	""
	defb	17

	defm	""
	defb	164

	defm	""
	defb	17

	defm	""
	defb	255

;	SECTION	code


;	SECTION	text

._decos_moto
	defm	""
	defb	19

	defm	"(#)"
	defb	255

;	SECTION	code


;	SECTION	text

._my_inks_2
	defm	""
	defb	13

	defm	""
	defb	4

	defm	""
	defb	21

	defm	""
	defb	27

	defm	""
	defb	23

	defm	""
	defb	19

	defm	""
	defb	31

	defm	""
	defb	6

	defm	""
	defb	4

	defm	""
	defb	21

	defm	""
	defb	29

	defm	""
	defb	13

	defm	""
	defb	30

	defm	""
	defb	0

	defm	""
	defb	20

	defm	""
	defb	10

;	SECTION	code


;	SECTION	text

._my_inks_3
	defm	""
	defb	13

	defm	""
	defb	4

	defm	""
	defb	21

	defm	""
	defb	3

	defm	""
	defb	22

	defm	""
	defb	0

	defm	""
	defb	19

	defm	""
	defb	6

	defm	""
	defb	28

	defm	""
	defb	5

	defm	""
	defb	7

	defm	""
	defb	29

	defm	""
	defb	30

	defm	""
	defb	0

	defm	""
	defb	20

	defm	""
	defb	10

;	SECTION	code


;	SECTION	text

._my_inks_4
	defm	""
	defb	13

	defm	""
	defb	4

	defm	""
	defb	21

	defm	""
	defb	27

	defm	""
	defb	22

	defm	""
	defb	18

	defm	""
	defb	31

	defm	""
	defb	6

	defm	""
	defb	4

	defm	""
	defb	21

	defm	""
	defb	29

	defm	""
	defb	13

	defm	""
	defb	30

	defm	""
	defb	0

	defm	""
	defb	20

	defm	""
	defb	10

;	SECTION	code


;	SECTION	text

._level_pal
	defw	_my_inks
	defw	_my_inks_3
	defw	_my_inks
	defw	_my_inks_2
	defw	_my_inks_4
	defw	_my_inks_3
	defw	_my_inks_4
	defw	_my_inks_3

;	SECTION	code

;	SECTION	text

._level_names
	defw	i_1+22
	defw	i_1+35
	defw	i_1+48
	defw	i_1+62
	defw	i_1+76
	defw	i_1+89
	defw	i_1+102
	defw	i_1+115

;	SECTION	code

;	SECTION	text

._level_briefings
	defw	i_1+129
	defw	i_1+158
	defw	0
	defw	0
	defw	i_1+182
	defw	0
	defw	0
	defw	i_1+212

;	SECTION	code

;	SECTION	text

._l_is_classic
	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	1

	defm	""
	defb	1

	defm	""
	defb	0

	defm	""
	defb	1

	defm	""
	defb	1

	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._l_max_life
	defm	""
	defb	5

	defm	""
	defb	5

	defm	""
	defb	10

	defm	""
	defb	10

	defm	""
	defb	5

	defm	""
	defb	10

	defm	""
	defb	10

	defm	""
	defb	5

;	SECTION	code



._attr
	ld	hl,4	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	hl,15	;const
	call	l_uge
	jp	c,i_24
	ld	hl,2	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	hl,10	;const
	call	l_uge
	jp	nc,i_23
.i_24
	ld	hl,0 % 256	;const
	ret


.i_23
	ld	hl,_map_attr
	push	hl
	ld	hl,6	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,6	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	add	hl,de
	ex	de,hl
	ld	hl,6-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	pop	de
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ret



._qtile
	ld	hl,_map_buff
	push	hl
	ld	hl,6	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,6	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	add	hl,de
	ex	de,hl
	ld	hl,6-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	pop	de
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ret



.__tile_address
	ld a, (__y)
	add a, a ; 2 4
	add a, a ; 4 4
	add a, a ; 8 4
	ld h, 0 ; 2
	ld l, a ; 4
	add hl, hl ; 16 11
	add hl, hl ; 32 11
	; 44 t-states
	; HL = _y * 32
	ld a, (__x)
	ld e, a
	ld d, 0
	add hl, de
	; HL = _y * 32 + _x
	ld de, _nametable
	add hl, de
	ex de, hl
	; DE = buffer address
	ret



._draw_coloured_tile
	call __tile_address ; DE = buffer address
	ex de, hl
	ld a, (__t)
	sla a
	sla a
	add 64
	ld (hl), a
	inc hl
	inc a
	ld (hl), a
	ld bc, 31
	add hl, bc
	inc a
	ld (hl), a
	inc hl
	inc a
	ld (hl), a
	ret



._invalidate_tile
	ld a, (__x)
	ld e, a
	ld a, (__y)
	ld d, a
	call cpc_UpdTileTable
	inc e
	call cpc_UpdTileTable
	dec e
	inc d
	call cpc_UpdTileTable
	inc e
	call cpc_UpdTileTable
	ret



._invalidate_viewport
	ld B, 1
	ld C, 1
	ld D, 1+19
	ld E, 1+29
	call cpc_InvalidateRect
	ret



._draw_invalidate_coloured_tile_g
	call	_draw_coloured_tile_gamearea
	call	_invalidate_tile
	ret



._draw_coloured_tile_gamearea
	ld	a,(__x)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asl
	ld	de,1
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	a,(__y)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asl
	ld	de,1
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__y),a
	call	_draw_coloured_tile
	ret



._draw_decorations
	ld hl, (__gp_gen)
	._draw_decorations_loop
	ld a, (hl)
	cp 0xff
	ret z
	ld a, (hl)
	inc hl
	ld c, a
	and 0x0f
	ld (__y), a
	ld a, c
	srl a
	srl a
	srl a
	srl a
	ld (__x), a
	ld a, (hl)
	inc hl
	ld (__t), a
	push hl
	ld b, 0
	ld c, a
	ld hl, _behs
	add hl, bc
	ld a, (hl)
	ld (__n), a
	call _update_tile
	pop hl
	jr _draw_decorations_loop
	ret


;	SECTION	text

._utaux
	defm	""
	defb	0

;	SECTION	code



._update_tile
	ld a, (__x)
	ld c, a
	ld a, (__y)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	add c
	ld b, 0
	ld c, a
	ld hl, _map_attr
	add hl, bc
	ld a, (__n)
	ld (hl), a
	ld hl, _map_buff
	add hl, bc
	ld a, (__t)
	ld (hl), a
	call _draw_coloured_tile_gamearea
	ld a, (_is_rendering)
	or a
	ret nz
	call _invalidate_tile
	ret



._print_number2
	ld	a,(__t)
	ld	e,a
	ld	d,0
	ld	hl,10	;const
	call	l_div_u
	ld	de,16
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_rda),a
	ld	a,(__t)
	ld	e,a
	ld	d,0
	ld	hl,10	;const
	call	l_div_u
	ex	de,hl
	ld	de,16
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_rdb),a
	call __tile_address ; DE = buffer address
	ld a, (_rda)
	ld (de), a
	inc de
	ld a, (_rdb)
	ld (de), a
	ld a, (__x)
	ld e, a
	ld a, (__y)
	ld d, a
	call cpc_UpdTileTable
	inc e
	call cpc_UpdTileTable
	ret



._draw_objs
	ld	a,#(27 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_p_objs)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ret



._print_str
	xor a
	ld (_rdn), a ; Strlen
	call __tile_address ; DE = buffer address
	ld hl, (__gp_gen)
	.print_str_loop
	ld a, (hl)
	or a
	jr z, print_str_inv
	sub 32
	ld (de), a
	inc hl
	inc de
	ld a, (_rdn)
	inc a
	ld (_rdn), a
	jr print_str_loop
	.print_str_inv
	; Invalidate cells based upon strlen.
	ld a, (__y)
	ld b, a
	ld d, a
	ld a, (__x)
	ld c, a
	ld a, (_rdn)
	add c
	dec a
	ld e, a
	call cpc_InvalidateRect
	ret



._blackout_area
	xor a
	ld hl, _nametable
	ld (hl), a
	ld de, _nametable+1
	ld bc, 767
	ldir
	ret



._clear_sprites
	ret



._pal_set
	ld	hl,16 % 256	;const
	ld	a,l
	ld	(_gpit),a
.i_27
	ld	hl,_gpit
	ld	a,(hl)
	dec	(hl)
	ld	l,a
	and	a
	jp	z,i_28
	ld	hl,(_gpit)
	ld	h,0
	push	hl
	ld	hl,4	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,(_gpit)
	ld	h,0
	pop	de
	add	hl,de
	ld	l,(hl)
	ld	h,0
	push	hl
	call	cpc_SetColour
	pop	bc
	pop	bc
	jp	i_27
.i_28
	ret



._cpc_UpdateNow
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	a,l
	and	a
	jp	z,i_29
	ld b, 0
	._cpc_screen_update_inv_loop
	push bc
	ld a, b
	sla a
	sla a
	sla a
	sla a
	ld d, 0
	ld e, a
	ld hl, _sp_sw
	add hl, de
	ld b, h
	ld c, l
	ld de, _cpc_screen_update_inv_ret
	push de
	ld de, 12
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	ld h, b
	ld l, c
	ret
	._cpc_screen_update_inv_ret
	pop bc
	inc b
	ld a, b
	cp 1 + 3 + 3 + 0
	jr nz, _cpc_screen_update_inv_loop
.i_29
	._cpc_screen_update_upd_buffer
	call cpc_UpdScr
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	a,l
	and	a
	jp	z,i_30
	ld b, 1 + 3 + 3 + 0
	._cpc_screen_update_upd_loop
	dec b
	push bc
	ld a, b
	sla a
	sla a
	sla a
	sla a
	ld d, 0
	ld e, a
	ld hl, _sp_sw
	add hl, de
	ld b, h
	ld c, l
	ld de, _cpc_screen_update_upd_ret
	push de
	ld de, 14
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	ld h, b
	ld l, c
	ret
	._cpc_screen_update_upd_ret
	pop bc
	xor a
	or b
	jr nz, _cpc_screen_update_upd_loop
	._cpc_screen_update_done
.i_30
	call cpc_ShowTouchedTiles
	call cpc_ResetTouchedTiles
	ret



._ingame_text
	ld	a,#(1 % 256 % 256)
	ld	(__x),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(__y),a
	call	_print_str
	ret



._win_level
	call	_wyz_stop_sound
	ld	hl,0	;const
	call	_wyz_play_sound
	ld	hl,50	;const
	push	hl
	call	_espera_activa
	pop	bc
	ld	a,#(1 % 256 % 256)
	ld	(_success),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
	ret



._persist_tile
	ld	hl,(_c_screen_address)
	push	hl
	ld	a,(_gpaux)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asr_u
	pop	de
	add	hl,de
	ld	(__gp_gen),hl
	ld	a,(hl)
	ld	(_rda),a
	ld	hl,_gpaux
	ld	a,(hl)
	rrca
	jp	nc,i_31
	ld	a,(_rda)
	ld	e,a
	ld	d,0
	ld	hl,240	;const
	call	l_and
	ex	de,hl
	ld	hl,(_rdt)
	ld	h,0
	call	l_or
	ld	h,0
	ld	a,l
	ld	(_rda),a
	jp	i_32
.i_31
	ld	a,(_rda)
	ld	e,a
	ld	d,0
	ld	hl,15	;const
	call	l_and
	push	hl
	ld	a,(_rdt)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	call	l_or
	ld	h,0
	ld	a,l
	ld	(_rda),a
.i_32
	ld	hl,(__gp_gen)
	ex	de,hl
	ld	hl,_rda
	ld	a,(hl)
	ld	(de),a
	ld	l,a
	ld	h,0
	ret



._collide
	ld	hl,(_gpx)
	ld	h,0
	ld	bc,8
	add	hl,bc
	ex	de,hl
	ld	hl,(_cx2)
	ld	h,0
	call	l_uge
	jp	nc,i_33
	ld	hl,(_gpx)
	ld	h,0
	push	hl
	ld	hl,(_cx2)
	ld	h,0
	ld	bc,8
	add	hl,bc
	pop	de
	call	l_ule
	jp	nc,i_33
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,8
	add	hl,bc
	ex	de,hl
	ld	hl,(_cy2)
	ld	h,0
	call	l_uge
	jp	nc,i_33
	ld	hl,(_gpy)
	ld	h,0
	push	hl
	ld	hl,(_cy2)
	ld	h,0
	ld	bc,8
	add	hl,bc
	pop	de
	call	l_ule
	jp	nc,i_33
	ld	hl,1	;const
	jr	i_34
.i_33
	ld	hl,0	;const
.i_34
	ld	h,0
	ret



._cm_two_points
	ld a, (_cx1)
	cp 15
	jr nc, _cm_two_points_at1_reset
	ld a, (_cy1)
	cp 10
	jr c, _cm_two_points_at1_do
	._cm_two_points_at1_reset
	xor a
	jr _cm_two_points_at1_done
	._cm_two_points_at1_do
	ld a, (_cy1)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	ld b, a
	ld a, (_cx1)
	add b
	ld e, a
	ld d, 0
	ld hl, _map_attr
	add hl, de
	ld a, (hl)
	._cm_two_points_at1_done
	ld (_at1), a
	ld a, (_cx2)
	cp 15
	jr nc, _cm_two_points_at2_reset
	ld a, (_cy2)
	cp 10
	jr c, _cm_two_points_at2_do
	._cm_two_points_at2_reset
	xor a
	jr _cm_two_points_at2_done
	._cm_two_points_at2_do
	ld a, (_cy2)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	ld b, a
	ld a, (_cx2)
	add b
	ld e, a
	ld d, 0
	ld hl, _map_attr
	add hl, de
	ld a, (hl)
	._cm_two_points_at2_done
	ld (_at2), a
	ret



._rand
	.rand16
	ld hl, _seed
	ld a, (hl)
	ld e, a
	inc hl
	ld a, (hl)
	ld d, a
	;; Ahora DE = [SEED]
	ld a, d
	ld h, e
	ld l, 253
	or a
	sbc hl, de
	sbc a, 0
	sbc hl, de
	ld d, 0
	sbc a, d
	ld e, a
	sbc hl, de
	jr nc, nextrand
	inc hl
	.nextrand
	ld d, h
	ld e, l
	ld hl, _seed
	ld a, e
	ld (hl), a
	inc hl
	ld a, d
	ld (hl), a
	;; Ahora [SEED] = HL
	ld l, e
	ret
	ret



._abs
	pop	bc
	pop	hl
	push	hl
	push	bc
	xor	a
	or	h
	jp	p,i_35
	pop	bc
	pop	hl
	push	hl
	push	bc
	call	l_neg
	ret


.i_35
	pop	bc
	pop	hl
	push	hl
	push	bc
	ret


.i_36
	ret



._break_wall
	ld	hl,(__x)
	ld	h,0
	push	hl
	ld	a,(__y)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	add	hl,de
	ex	de,hl
	ld	hl,(__y)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	ld	h,0
	ld	a,l
	ld	(_gpaux),a
	ld	de,_brk_buff
	ld	hl,(_gpaux)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(1 % 256)
	jp	z,i_37
	jp	nc,i_37
	ld	de,_brk_buff
	ld	hl,(_gpaux)
	ld	h,0
	add	hl,de
	inc	(hl)
	ld	a,#(1 % 256 % 256)
	ld	(_gpit),a
	ld	hl,31 % 256	;const
	ld	a,l
	ld	(__t),a
	call	_draw_invalidate_coloured_tile_g
	jp	i_38
.i_37
	ld	a,#(0 % 256 % 256)
	ld	(__n),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(__t),a
	call	_update_tile
	ld	a,#(2 % 256 % 256)
	ld	(_gpit),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_rdt),a
	call	_persist_tile
.i_38
	ld	hl,(_gpit)
	ld	h,0
	call	_wyz_play_sound
	ret



._bullets_init
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_b_it),a
.i_39
	ld	a,(_b_it)
	cp	#(3 % 256)
	jp	z,i_40
	jp	nc,i_40
	ld	de,_bullets_estado
	ld	hl,(_b_it)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,(_b_it)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_b_it),a
	jp	i_39
.i_40
	ret



._bullets_update
	ld de, (_b_it)
	ld d, 0
	ld hl, _bullets_estado
	add hl, de
	ld a, (__b_estado)
	ld (hl), a
	ld hl, _bullets_x
	add hl, de
	ld a, (__b_x)
	ld (hl), a
	ld hl, _bullets_y
	add hl, de
	ld a, (__b_y)
	ld (hl), a
	ld hl, _bullets_mx
	add hl, de
	ld a, (__b_mx)
	ld (hl), a
	ld hl, _bullets_my
	add hl, de
	ld a, (__b_my)
	ld (hl), a
	ret


;	SECTION	text

.__bxo
	defm	""
	defb	12

	defm	""
	defb	252

	defm	""
	defb	6

	defm	""
	defb	2

;	SECTION	code


;	SECTION	text

.__byo
	defm	""
	defb	6

	defm	""
	defb	6

	defm	""
	defb	4

	defm	""
	defb	12

;	SECTION	code


;	SECTION	text

.__bmxo
	defm	""
	defb	8

	defm	""
	defb	248

	defm	""
	defb	0

	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

.__bmyo
	defm	""
	defb	0

	defm	""
	defb	0

	defm	""
	defb	248

	defm	""
	defb	8

;	SECTION	code



._bullets_fire
	ld	hl,(_p_ammo)
	ld	h,0
	call	l_lneg
	jp	nc,i_45
	ret


.i_45
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_b_it),a
	jp	i_48
.i_46
	ld	hl,(_b_it)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_b_it),a
.i_48
	ld	a,(_b_it)
	cp	#(3 % 256)
	jp	z,i_47
	jp	nc,i_47
	ld	de,_bullets_estado
	ld	hl,(_b_it)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	nz,i_49
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(__b_estado),a
	ld a, (_p_facing)
	srl a
	ld c, a
	ld b, 0
	ld hl, __bxo
	add hl, bc
	ld d, (hl)
	ld a, (_gpx)
	add d
	ld (__b_x),a
	ld hl, __byo
	add hl, bc
	ld d, (hl)
	ld a, (_gpy)
	add d
	ld (__b_y),a
	ld hl, __bmxo
	add hl, bc
	ld a, (hl)
	ld (__b_mx),a
	ld hl, __bmyo
	add hl, bc
	ld a, (hl)
	ld (__b_my),a
	ld	hl,4	;const
	call	_wyz_play_sound
	call	_bullets_update
	ld	hl,(_p_ammo)
	ld	h,0
	dec	hl
	ld	a,l
	ld	(_p_ammo),a
	jp	i_47
.i_49
	jp	i_46
.i_47
	ret



._bullets_move
	ld	a,#(4 % 256 % 256)
	ld	(_bspr_it),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_b_it),a
	jp	i_52
.i_50
	ld	hl,_b_it
	ld	a,(hl)
	inc	(hl)
.i_52
	ld	a,(_b_it)
	cp	#(3 % 256)
	jp	z,i_51
	jp	nc,i_51
	ld	de,_bullets_estado
	ld	hl,(_b_it)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	a,l
	and	a
	jp	z,i_53
	ld de, (_b_it)
	ld d, 0
	ld hl, _bullets_x
	add hl, de
	ld a, (hl)
	ld (__b_x), a
	ld hl, _bullets_y
	add hl, de
	ld a, (hl)
	ld (__b_y), a
	ld hl, _bullets_mx
	add hl, de
	ld a, (hl)
	ld (__b_mx), a
	ld hl, _bullets_my
	add hl, de
	ld a, (hl)
	ld (__b_my), a
	ld a, 1
	ld (__b_estado), a
	ld	hl,__b_mx
	call	l_gchar
	ld	a,h
	or	l
	jp	z,i_54
	ld	hl,(__b_x)
	ld	h,0
	push	hl
	ld	hl,__b_mx
	call	l_gchar
	pop	de
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__b_x),a
	cp	#(232 % 256)
	jp	z,i_55
	jp	c,i_55
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(__b_estado),a
.i_55
.i_54
	ld	hl,__b_my
	call	l_gchar
	ld	a,h
	or	l
	jp	z,i_56
	ld	hl,(__b_y)
	ld	h,0
	push	hl
	ld	hl,__b_my
	call	l_gchar
	pop	de
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__b_y),a
	cp	#(152 % 256)
	jp	z,i_57
	jp	c,i_57
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(__b_estado),a
.i_57
.i_56
	ld	hl,(__b_x)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(__x),a
	ld	hl,(__b_y)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(__y),a
	ld	hl,(__x)
	ld	h,0
	push	hl
	ld	hl,(__y)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	a,l
	ld	(_rda),a
	ld	hl,_rda
	ld	a,(hl)
	and	#(16 % 256)
	jp	z,i_58
	ld	l,a
	ld	h,0
	call	_break_wall
.i_58
	ld	a,(_rda)
	cp	#(7 % 256)
	jp	z,i_59
	jp	c,i_59
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(__b_estado),a
.i_59
	ld	a,(__b_estado)
	and	a
	jp	z,i_60
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_bspr_it)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	push	hl
	ld	hl,(__b_x)
	ld	h,0
	ld	bc,8
	add	hl,bc
	ex	de,hl
	ld	l,#(2 % 256)
	call	l_asr_u
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_bspr_it)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	push	hl
	ld	hl,(__b_y)
	ld	h,0
	ld	bc,8
	add	hl,bc
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_bspr_it)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_19_a
	call	l_pint_pop
.i_60
	call	_bullets_update
	jp	i_61
.i_53
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_bspr_it)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	(hl),#(2 % 256 % 256)
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_bspr_it)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	ld	(hl),#(8 % 256 % 256)
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_bspr_it)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
.i_61
	ld	hl,(_bspr_it)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_bspr_it),a
	jp	i_50
.i_51
	ret



._prepare_level
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	ld	bc,6
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_mapa
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_malotes
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	ld	bc,10
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_behs
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	ld	hl,_level_data
	push	hl
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,_level_data+1
	push	hl
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	inc	hl
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	a,(_warp_to_level)
	and	a
	jp	nz,i_62
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	(_n_pant),a
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	inc	hl
	ld	e,(hl)
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	ld	(_p_x),hl
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	ld	bc,4
	add	hl,bc
	ld	e,(hl)
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	ld	(_p_y),hl
.i_62
	ret



._game_ending
	call	_blackout
	ld	hl,_my_inks
	push	hl
	call	_pal_set
	pop	bc
	ld	hl,_s_ending
	push	hl
	ld	hl,36864	;const
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	ld	hl,1	;const
	call	cpc_ShowTileMap
	ld	a,#(7 % 256 % 256)
	ld	(__x),a
	ld	a,#(20 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+241
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(2 % 256 % 256)
	ld	(__x),a
	ld	a,#(22 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+260
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,0	;const
	call	_wyz_play_music
	ld	hl,500	;const
	push	hl
	call	_espera_activa
	pop	bc
	call	_wyz_stop_sound
	ret



._game_over
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(11 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(12 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+288
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,2	;const
	call	_wyz_play_music
	ld	hl,500	;const
	push	hl
	call	_espera_activa
	pop	bc
	call	_wyz_stop_sound
	call	_blackout_area
	ret



._pause_screen
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(11 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(12 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+301
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ret



._zone_clear
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(11 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(12 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+314
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,4	;const
	call	_wyz_play_music
	ld	hl,250	;const
	push	hl
	call	_espera_activa
	pop	bc
	call	_wyz_stop_sound
	ret



._addsign
	ld	hl,4	;const
	call	l_gintsp	;
	xor	a
	or	h
	jp	m,i_63
	pop	bc
	pop	hl
	push	hl
	push	bc
	ret


.i_63
	pop	bc
	pop	hl
	push	hl
	push	bc
	call	l_neg
	ret


.i_64
	ret



._espera_activa
.i_65
	call	cpc_AnyKeyPressed
	ld	a,h
	or	l
	jp	nz,i_65
.i_66
.i_69
	halt
	halt
	halt
	halt
	halt
	halt
	call	cpc_AnyKeyPressed
	ld	a,h
	or	l
	jp	nz,i_68
.i_70
.i_67
	pop	de
	pop	hl
	dec	hl
	push	hl
	push	de
	ld	a,h
	or	l
	jp	nz,i_69
.i_68
	ret



._process_tile
	ld	hl,4	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_71
	ld	a,#(1 % 256 % 256)
	ld	(_p_disparando),a
	ld	hl,(_x0)
	ld	h,0
	push	hl
	ld	hl,(_y0)
	ld	h,0
	push	hl
	call	_qtile
	pop	bc
	pop	bc
	ld	de,14	;const
	call	l_eq
	jp	nc,i_73
	ld	hl,(_x1)
	ld	h,0
	push	hl
	ld	hl,(_y1)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	de,0	;const
	call	l_eq
	jp	nc,i_73
	ld	a,(_x1)
	cp	#(15 % 256)
	jp	z,i_73
	jp	nc,i_73
	ld	a,(_y1)
	cp	#(10 % 256)
	jp	z,i_73
	jr	c,i_74_i_73
.i_73
	jp	i_72
.i_74_i_73
	ld	hl,_map_buff
	push	hl
	ld	hl,(_x1)
	ld	h,0
	push	hl
	ld	a,(_y1)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	add	hl,de
	ex	de,hl
	ld	hl,(_y1)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	pop	de
	add	hl,de
	ld	a,(hl)
	ld	(_rda),a
	ld	a,(_x0)
	ld	(__x),a
	ld	hl,(_y0)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	a,#(0 % 256 % 256)
	ld	(__t),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(__n),a
	call	_update_tile
	ld	a,(_x1)
	ld	(__x),a
	ld	hl,(_y1)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	a,#(14 % 256 % 256)
	ld	(__t),a
	ld	hl,10 % 256	;const
	ld	a,l
	ld	(__n),a
	call	_update_tile
	ld	hl,3	;const
	call	_wyz_play_sound
	ld a, (_x1)
	sla a
	sla a
	sla a
	sla a
	ld (_rdx), a
	ld a, (_y1)
	sla a
	sla a
	sla a
	sla a
	ld (_rdy), a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_enit),a
	jp	i_77
.i_75
	ld	hl,(_enit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_enit),a
.i_77
	ld	a,(_enit)
	cp	#(3 % 256)
	jp	z,i_76
	jp	nc,i_76
	ld	de,(_enoffs)
	ld	d,0
	ld	hl,(_enit)
	ld	h,d
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_enoffsmasi),a
	ld hl, (_enoffsmasi)
	ld h, 0
	add hl, hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de
	ld de, _malotes
	add hl, de
	ld (__baddies_pointer), hl
	ld a, (hl)
	ld (__en_x), a
	inc hl
	ld a, (hl)
	ld (__en_y), a
	ld bc, 7
	add hl, bc
	ld a, (hl)
	ld (__en_t), a
	cp 3
	jp c, _on_tile_pushed_continue
	._on_tile_pushed_check_top
	ld a, (__en_y)
	and 0xf0
	ld c, a
	ld a, (_rdy)
	cp c
	jr nz, _on_tile_pushed_check_bottom
	ld a, (__en_x)
	and 0xf0
	ld c, a
	ld a, (_rdx)
	cp c
	jr z, _on_tile_pushed_overlaps
	ld a, (__en_x)
	add 15
	and 0xf0
	ld c, a
	ld a, (_rdx)
	cp c
	jr z, _on_tile_pushed_overlaps
	jp _on_tile_pushed_continue
	._on_tile_pushed_check_bottom
	ld a, (__en_y)
	add 15
	and 0xf0
	ld c, a
	ld a, (_rdy)
	cp c
	jp nz, _on_tile_pushed_continue
	ld a, (__en_x)
	and 0xf0
	ld c, a
	ld a, (_rdx)
	cp c
	jr z, _on_tile_pushed_overlaps
	ld a, (__en_x)
	add 15
	and 0xf0
	ld c, a
	ld a, (_rdx)
	cp c
	jp nz, _on_tile_pushed_continue
	._on_tile_pushed_overlaps
	ld a, (__en_t)
	cp 3
	jp nz, _on_tile_pushed_do
	jp _on_tile_pushed_kill_enemy
	._on_tile_pushed_do
	ld a, (_x0)
	ld c, a
	ld a, (_x1)
	cp c
	jr z, _on_tile_pushed_vertically
	._on_tile_pushed_horizontally
	jr nc, _on_tile_pushed_right
	._on_tile_pushed_left
	ld a, (__en_x)
	dec a
	and 0xf0
	ld (__en_x), a
	jr _on_tile_pushed_horizontally_do
	._on_tile_pushed_right
	ld a, (__en_x)
	add 16
	and 0xf0
	ld (__en_x), a
	._on_tile_pushed_horizontally_do
	cp 240
	jp nc, _on_tile_pushed_kill_enemy
	call _on_tile_pushed_sr4
	ld (_cx1), a
	ld (_cx2), a
	ld a, (__en_y)
	call _on_tile_pushed_sr4
	ld (_cy1), a
	ld a, (__en_y)
	add 15
	call _on_tile_pushed_sr4
	ld (_cy2), a
	call _cm_two_points
	ld a, (_at1)
	ld c, a
	ld a, (_at2)
	or c
	jp nz, _on_tile_pushed_kill_enemy
	jr _on_tile_pushed_done
	._on_tile_pushed_vertically
	ld a, (_y0)
	ld c, a
	ld a, (_y1)
	cp c
	jr nc, _on_tile_pushed_down
	._on_tile_pushed_up
	ld a, (__en_y)
	dec a
	and 0xf0
	ld (__en_y), a
	jr _on_tile_pushed_vertically_done
	._on_tile_pushed_down
	ld a, (__en_y)
	add 16
	and 0xf0
	ld (__en_y), a
	._on_tile_pushed_vertically_done
	cp 160
	jr nc, _on_tile_pushed_kill_enemy
	call _on_tile_pushed_sr4
	ld (_cy1), a
	ld (_cy2), a
	ld a, (__en_x)
	call _on_tile_pushed_sr4
	ld (_cx1), a
	ld a, (__en_x)
	add 15
	call _on_tile_pushed_sr4
	ld (_cx2), a
	call _cm_two_points
	ld a, (_at1)
	ld c, a
	ld a, (_at2)
	or c
	jp nz, _on_tile_pushed_kill_enemy
	._on_tile_pushed_done
	ld hl, (__baddies_pointer)
	ld a, (__en_x)
	ld (hl), a
	inc hl
	ld a, (__en_y)
	ld (hl), a
	inc hl
	jr _on_tile_pushed_continue
	._on_tile_pushed_sr4
	srl a
	srl a
	srl a
	srl a
	ret
	._on_tile_pushed_kill_enemy
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(4 % 256 % 256)
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(12 % 256 % 256)
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_17_a
	call	l_pint_pop
	ld	hl,6	;const
	call	_wyz_play_sound
	call	_enems_pursuers_init
	call	_enems_kill
	ld hl, (__baddies_pointer)
	ld bc, 8
	add hl, bc
	ld a, (__en_t)
	ld (hl), a
	._on_tile_pushed_continue
	jp	i_75
.i_76
.i_72
.i_71
	ld	hl,(_x0)
	ld	h,0
	push	hl
	ld	hl,(_y0)
	ld	h,0
	push	hl
	call	_qtile
	pop	bc
	pop	bc
	ld	de,15	;const
	call	l_eq
	jp	nc,i_79
	ld	a,(_p_keys)
	and	a
	jr	nz,i_80_i_79
.i_79
	jp	i_78
.i_80_i_79
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_83
.i_81
	ld	hl,(_gpit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_gpit),a
.i_83
	ld	a,(_gpit)
	cp	#(32 % 256)
	jp	z,i_82
	jp	nc,i_82
	ld	hl,_cerrojos
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	ld	a,(_x0)
	cp	(hl)
	jp	nz,i_85
	ld	hl,_cerrojos
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	a,(_y0)
	cp	(hl)
	jp	nz,i_85
	ld	hl,_cerrojos
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	a,(_n_pant)
	cp	(hl)
	jr	z,i_86_i_85
.i_85
	jp	i_84
.i_86_i_85
	ld	hl,_cerrojos
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_82
.i_84
	jp	i_81
.i_82
	ld	a,(_x0)
	ld	(__x),a
	ld	hl,(_y0)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	a,#(0 % 256 % 256)
	ld	(__t),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(__n),a
	call	_update_tile
	ld	hl,(_p_keys)
	ld	h,0
	dec	hl
	ld	a,l
	ld	(_p_keys),a
	ld	hl,3	;const
	call	_wyz_play_sound
.i_78
	ret



._draw_scr_background
	ld	hl,_mapa
	push	hl
	ld	hl,(_n_pant)
	ld	h,0
	ld	de,75
	call	l_mult
	pop	de
	add	hl,de
	ld	(_map_pointer),hl
	ld	hl,(_n_pant)
	ld	h,0
	ld	(_seed),hl
	ld	a,#(1 % 256 % 256)
	ld	(__x),a
	ld	a,#(1 % 256 % 256)
	ld	(__y),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_89
.i_87
	ld	hl,(_gpit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_gpit),a
.i_89
	ld	a,(_gpit)
	ld	e,a
	ld	d,0
	ld	hl,150	;const
	call	l_ult
	jp	nc,i_88
	ld a, (_gpit)
	and 1
	jr nz, _draw_scr_packed_existing
	._draw_scr_packed_new
	ld hl, (_map_pointer)
	ld a, (hl)
	ld (_gpc), a
	inc hl
	ld (_map_pointer), hl
	srl a
	srl a
	srl a
	srl a
	jr _draw_scr_packed_done
	._draw_scr_packed_existing
	ld a, (_gpc)
	and 15
	._draw_scr_packed_done
	ld (__t), a
	ld b, 0
	ld c, a
	ld hl, _behs
	add hl, bc
	ld a, (hl)
	ld bc, (_gpit)
	ld b, 0
	ld hl, _map_attr
	add hl, bc
	ld (hl), a
	ld a, (__t)
	or a
	jr nz, _draw_scr_packed_noalt
	._draw_scr_packed_alt
	call _rand
	ld a, l
	and 15
	cp 1
	jr z, _draw_scr_packed_alt_subst
	ld a, (__t)
	jr _draw_scr_packed_noalt
	._draw_scr_packed_alt_subst
	ld a, 19
	ld (__t), a
	._draw_scr_packed_noalt
	ld a, (__t)
	or a
	jr nz, _ds_custom_packed_noalt
	._ds_custom_packed_alt
	call _rand
	ld a, l
	and 15
	cp 1
	jr z, _ds_custom_packed_alt_subst
	ld a, (__t)
	jr _ds_custom_packed_noalt
	._ds_custom_packed_alt_subst
	ld a, 30
	ld (__t), a
	._ds_custom_packed_noalt
	cp 13
	jr nz, _ds_custom_end
	ld a, (_level)
	dec a
	jr nz, _ds_custom_end
	ld a, 128
	ld hl, _map_attr
	add hl, bc
	ld (hl), a
	ld a, 21
	ld (__t), a
	._ds_custom_end
	ld hl, _map_buff
	add hl, bc
	ld (hl), a
	ld hl, _brk_buff
	add hl, bc
	xor a
	ld (hl), a
	call	_draw_coloured_tile
	ld a, (__x)
	add 2
	cp 30 + 1
	jr c, _advance_worm_no_inc_y
	ld a, (__y)
	add 2
	ld (__y), a
	ld a, 1
	._advance_worm_no_inc_y
	ld (__x), a
	jp	i_87
.i_88
	ret



._draw_scr
	call	cpc_ResetTouchedTiles
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_is_rendering),a
	call	_draw_scr_background
	call	_enems_load
	ld	hl,_mapa
	push	hl
	ld	hl,(_n_pant)
	ld	h,0
	ld	de,75
	call	l_mult
	pop	de
	add	hl,de
	ld	(_c_screen_address),hl
	ld	hl,_level_briefings
	push	hl
	ld	hl,(_level)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	ld	(__gp_gen),hl
	ld	a,(_c_is_classic)
	and	a
	jp	z,i_90
	ld	hl,i_1+327
	ld	(__gp_gen),hl
	ld	a,(_n_pant)
	and	a
	jp	nz,i_91
	ld	hl,_decos_computer
	ld	(__gp_gen),hl
	call	_draw_decorations
	ld	a,(_f_1)
	and	a
	jp	z,i_92
	ld	hl,_decos_bombs
	ld	(__gp_gen),hl
	call	_draw_decorations
	ld	hl,i_1+357
	ld	(__gp_gen),hl
	jp	i_93
.i_92
	ld	hl,i_1+388
	ld	(__gp_gen),hl
.i_93
	jp	i_94
.i_91
	ld	a,(_level)
	cp	#(4 % 256)
	jp	z,i_96
	jp	c,i_96
	ld	a,(_n_pant)
	cp	#(23 % 256)
	jp	z,i_96
	jr	c,i_97_i_96
.i_96
	jp	i_95
.i_97_i_96
	ld	hl,i_1+417
	ld	(__gp_gen),hl
.i_95
.i_94
.i_90
	ld	a,(_level)
	cp	#(1 % 256)
	jp	nz,i_99
	ld	a,(_n_pant)
	cp	#(17 % 256)
	jp	nz,i_100
	ld	a,(_f_3)
	and	a
	jp	z,i_100
	ld	hl,1	;const
	jr	i_101
.i_100
	ld	hl,0	;const
.i_101
	ld	a,h
	or	l
	jp	nz,i_99
	jr	i_102
.i_99
	ld	hl,1	;const
.i_102
	ld	a,h
	or	l
	call	nz,_ingame_text
.i_98
	ld	a,#(0 % 256 % 256)
	ld	(_f_3),a
	ld	a,(_n_pant)
	cp	#(21 % 256)
	jp	nz,i_104
	ld	a,(_level)
	cp	#(2 % 256)
	jp	z,i_105
	ld	a,(_level)
	cp	#(5 % 256)
	jp	nz,i_104
.i_105
	jr	i_107_i_104
.i_104
	jp	i_103
.i_107_i_104
	ld	hl,_decos_moto
	ld	(__gp_gen),hl
	call	_draw_decorations
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_f_0),a
	jp	i_108
.i_103
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_f_0),a
.i_108
	ld	a,(_level)
	cp	#(7 % 256)
	jp	nz,i_110
	ld	a,(_n_pant)
	cp	#(5 % 256)
	jr	z,i_111_i_110
.i_110
	jp	i_109
.i_111_i_110
	ld	hl,_decos_moto
	ld	(__gp_gen),hl
	call	_draw_decorations
.i_109
	ld	a,(_n_pant)
	cp	#(23 % 256)
	jp	nz,i_113
	ld	a,(_f_1)
	and	a
	jr	nz,i_114_i_113
.i_113
	jp	i_112
.i_114_i_113
	call	_win_level
.i_112
	ld a, 240
	ld (_hotspot_y), a
	ld a, (_n_pant)
	ld b, a
	sla a
	add b
	ld c, a
	ld b, 0
	ld hl, _hotspots
	add hl, bc
	ld a, (hl)
	ld b, a
	srl a
	srl a
	srl a
	srl a
	ld (__x), a
	ld a, b
	and 15
	ld (__y), a
	inc hl
	ld b, (hl)
	inc hl
	ld c, (hl)
	xor a
	or b
	jr z, _hotspots_setup_done
	xor a
	or c
	jr z, _hotspots_setup_done
	._hotspots_setup_do
	ld a, (__x)
	ld e, a
	sla a
	sla a
	sla a
	sla a
	ld (_hotspot_x), a
	ld a, (__y)
	ld d, a
	sla a
	sla a
	sla a
	sla a
	ld (_hotspot_y), a
	sub d
	add e
	ld e, a
	ld d, 0
	ld hl, _map_buff
	add hl, de
	ld a, (hl)
	ld (_orig_tile), a
	ld a, b
	cp 3
	jp nz, _hotspots_setup_set
	._hotspots_setup_set_refill
	xor a
	._hotspots_setup_set
	add 16
	ld (__t), a
	call _draw_coloured_tile_gamearea
	._hotspots_setup_done
	ld hl, _cerrojos
	ld b, 32
	._open_locks_loop
	push bc
	ld a, (_n_pant)
	ld c, a
	ld b, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld e, (hl)
	inc hl
	ld a, (hl)
	inc hl
	or a
	jr nz, _open_locks_done
	ld a, b
	cp c
	jr nz, _open_locks_done
	ld a, b
	or d
	or e
	jr z, _open_locks_done
	._open_locks_do
	ld a, d
	ld (__x), a
	ld a, e
	ld (__y), a
	sla a
	sla a
	sla a
	sla a
	sub e
	add d
	ld b, 0
	ld c, a
	xor a
	push hl
	ld hl, _map_attr
	add hl, bc
	ld (hl), a
	ld hl, _map_buff
	add hl, bc
	ld (hl), a
	ld (__t), a
	call _draw_coloured_tile_gamearea
	pop hl
	._open_locks_done
	pop bc
	dec b
	jr nz, _open_locks_loop
	call	_bullets_init
	call	_invalidate_viewport
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_is_rendering),a
	ret



._mons_col_sc_x
	ld	hl,__en_mx
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_115
	ld	hl,(__en_x)
	ld	h,0
	ld	bc,15
	add	hl,bc
	jp	i_116
.i_115
	ld	hl,(__en_x)
	ld	h,0
.i_116
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	ld	(_cx1),a
	ld	a,(__en_y)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_cy1),a
	ld	hl,(__en_y)
	ld	h,0
	ld	bc,15
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	call	_cm_two_points
	ld	a,(_at1)
	and	a
	jp	nz,i_117
	ld	a,(_at2)
	and	a
	jp	nz,i_117
	ld	hl,0	;const
	jr	i_118
.i_117
	ld	hl,1	;const
.i_118
	ld	h,0
	ret



._mons_col_sc_y
	ld	hl,__en_my
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_119
	ld	hl,(__en_y)
	ld	h,0
	ld	bc,15
	add	hl,bc
	jp	i_120
.i_119
	ld	hl,(__en_y)
	ld	h,0
.i_120
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	ld	(_cy1),a
	ld	a,(__en_x)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_cx1),a
	ld	hl,(__en_x)
	ld	h,0
	ld	bc,15
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	call	_cm_two_points
	ld	a,(_at1)
	and	a
	jp	nz,i_121
	ld	a,(_at2)
	and	a
	jp	nz,i_121
	ld	hl,0	;const
	jr	i_122
.i_121
	ld	hl,1	;const
.i_122
	ld	h,0
	ret



._limit
	ld	hl,6	;const
	call	l_gintspsp	;
	ld	hl,6	;const
	call	l_gintsp	;
	pop	de
	call	l_lt
	jp	nc,i_123
	ld	hl,4	;const
	call	l_gintsp	;
	ret


.i_123
	ld	hl,6	;const
	call	l_gintspsp	;
	ld	hl,4	;const
	call	l_gintsp	;
	pop	de
	call	l_gt
	jp	nc,i_124
	pop	bc
	pop	hl
	push	hl
	push	bc
	ret


.i_124
	ld	hl,6	;const
	call	l_gintsp	;
	ret



._player_init
	ld	hl,0	;const
	ld	(_p_vy),hl
	ld	(_p_vx),hl
	ld	a,#(1 % 256 % 256)
	ld	(_p_cont_salto),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_saltando),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_frame),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_subframe),a
	ld	a,#(6 % 256 % 256)
	ld	(_p_facing),a
	ld	hl,255 % 256	;const
	ld	a,l
	ld	(_p_facing_h),a
	ld	(_p_facing_v),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_estado),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_ct_estado),a
	ld	de,_l_max_life
	ld	hl,(_level)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(_p_life),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_objs),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_keys),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_killed),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_disparando),a
	ld	hl,99 % 256	;const
	ld	a,l
	ld	(_p_ammo),a
	ret



._player_calc_bounding_box
	ld a, (_gpx)
	add 4
	srl a
	srl a
	srl a
	srl a
	ld (_ptx1), a
	ld a, (_gpx)
	add 11
	srl a
	srl a
	srl a
	srl a
	ld (_ptx2), a
	ld a, (_gpy)
	add 8
	srl a
	srl a
	srl a
	srl a
	ld (_pty1), a
	ld a, (_gpy)
	add 15
	srl a
	srl a
	srl a
	srl a
	ld (_pty2), a
	ret



._player_move
	ld	hl,2	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	nz,i_126
	ld	hl,3	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	nz,i_126
	jr	i_127
.i_126
	ld	hl,1	;const
.i_127
	call	l_lneg
	jp	nc,i_125
	ld	a,#(255 % 256 % 256)
	ld	(_p_facing_v),a
	ld	a,#(0 % 256 % 256)
	ld	(_wall_v),a
	ld	hl,(_p_vy)
	xor	a
	or	h
	jp	m,i_128
	or	l
	jp	z,i_128
	ld	hl,(_p_vy)
	ld	bc,-64
	add	hl,bc
	ld	(_p_vy),hl
	xor	a
	or	h
	jp	p,i_129
	ld	hl,0	;const
	ld	(_p_vy),hl
.i_129
	jp	i_130
.i_128
	ld	hl,(_p_vy)
	xor	a
	or	h
	jp	p,i_131
	ld	hl,(_p_vy)
	ld	bc,64
	add	hl,bc
	ld	(_p_vy),hl
	xor	a
	or	h
	jp	m,i_132
	or	l
	jp	z,i_132
	ld	hl,0	;const
	ld	(_p_vy),hl
.i_132
.i_131
.i_130
.i_125
	ld	hl,2	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_133
	ld	a,#(4 % 256 % 256)
	ld	(_p_facing_v),a
	ld	hl,(_p_vy)
	ld	de,65280	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_134
	ld	hl,(_p_vy)
	ld	bc,-48
	add	hl,bc
	ld	(_p_vy),hl
.i_134
.i_133
	ld	hl,3	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_135
	ld	a,#(6 % 256 % 256)
	ld	(_p_facing_v),a
	ld	hl,(_p_vy)
	ld	de,256	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_136
	ld	hl,(_p_vy)
	ld	bc,48
	add	hl,bc
	ld	(_p_vy),hl
.i_136
.i_135
	ld	de,(_p_y)
	ld	hl,(_p_vy)
	add	hl,de
	ld	(_p_y),hl
	xor	a
	or	h
	jp	p,i_137
	ld	hl,0	;const
	ld	(_p_y),hl
.i_137
	ld	hl,(_p_y)
	ld	de,9216	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_138
	ld	hl,9216	;const
	ld	(_p_y),hl
.i_138
	ld	hl,(_p_y)
	ex	de,hl
	ld	l,#(6 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	call	_player_calc_bounding_box
	ld	a,#(0 % 256 % 256)
	ld	(_hit_v),a
	ld	a,(_ptx1)
	ld	(_cx1),a
	ld	a,(_ptx2)
	ld	(_cx2),a
	ld	hl,(_p_vy)
	xor	a
	or	h
	jp	p,i_139
	ld	hl,(_pty1)
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	ld	(_cy1),a
	call	_cm_two_points
	ld	hl,_at1
	ld	a,(hl)
	and	#(8 % 256)
	jp	nz,i_141
	ld	hl,_at2
	ld	a,(hl)
	and	#(8 % 256)
	jp	z,i_140
.i_141
	ld	hl,0	;const
	ld	(_p_vy),hl
	ld	hl,(_pty1)
	ld	h,0
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asl
	ld	bc,-8
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	ld	(_p_y),hl
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_wall_v),a
.i_140
.i_139
	ld	hl,(_p_vy)
	xor	a
	or	h
	jp	m,i_143
	or	l
	jp	z,i_143
	ld	hl,(_pty2)
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	ld	(_cy1),a
	call	_cm_two_points
	ld	hl,_at1
	ld	a,(hl)
	and	#(8 % 256)
	jp	nz,i_145
	ld	hl,_at2
	ld	a,(hl)
	and	#(8 % 256)
	jp	z,i_144
.i_145
	ld	hl,0	;const
	ld	(_p_vy),hl
	ld	hl,(_pty2)
	ld	h,0
	dec	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	ld	(_p_y),hl
	ld	hl,2 % 256	;const
	ld	a,l
	ld	(_wall_v),a
.i_144
.i_143
	ld	hl,(_p_vy)
	ld	a,h
	or	l
	jp	z,i_147
	ld	hl,_at1
	ld	a,(hl)
	rrca
	jp	c,i_148
	ld	hl,_at2
	ld	a,(hl)
	rrca
	jp	c,i_148
	ld	hl,0	;const
	jr	i_149
.i_148
	ld	hl,1	;const
.i_149
	ld	h,0
	ld	a,l
	ld	(_hit_v),a
.i_147
	ld	a,(_gpx)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_gpxx),a
	ld	a,(_gpy)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_gpyy),a
	ld	hl,0	;const
	call	cpc_TestKey
	ld	a,h	
	or	l
	jp	nz,i_151
	inc	hl
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	nz,i_151
	jr	i_152
.i_151
	ld	hl,1	;const
.i_152
	call	l_lneg
	jp	nc,i_150
	ld	a,#(255 % 256 % 256)
	ld	(_p_facing_h),a
	ld	hl,(_p_vx)
	xor	a
	or	h
	jp	m,i_153
	or	l
	jp	z,i_153
	ld	hl,(_p_vx)
	ld	bc,-64
	add	hl,bc
	ld	(_p_vx),hl
	xor	a
	or	h
	jp	p,i_154
	ld	hl,0	;const
	ld	(_p_vx),hl
.i_154
	jp	i_155
.i_153
	ld	hl,(_p_vx)
	xor	a
	or	h
	jp	p,i_156
	ld	hl,(_p_vx)
	ld	bc,64
	add	hl,bc
	ld	(_p_vx),hl
	xor	a
	or	h
	jp	m,i_157
	or	l
	jp	z,i_157
	ld	hl,0	;const
	ld	(_p_vx),hl
.i_157
.i_156
.i_155
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_wall_h),a
.i_150
	ld	hl,0	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_158
	ld	a,#(2 % 256 % 256)
	ld	(_p_facing_h),a
	ld	hl,(_p_vx)
	ld	de,65280	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_159
	ld	hl,(_p_vx)
	ld	bc,-48
	add	hl,bc
	ld	(_p_vx),hl
.i_159
.i_158
	ld	hl,1	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_160
	ld	a,#(0 % 256 % 256)
	ld	(_p_facing_h),a
	ld	hl,(_p_vx)
	ld	de,256	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_161
	ld	hl,(_p_vx)
	ld	bc,48
	add	hl,bc
	ld	(_p_vx),hl
.i_161
.i_160
	ld	de,(_p_x)
	ld	hl,(_p_vx)
	add	hl,de
	ld	(_p_x),hl
	xor	a
	or	h
	jp	p,i_162
	ld	hl,0	;const
	ld	(_p_x),hl
.i_162
	ld	hl,(_p_x)
	ld	de,14336	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_163
	ld	hl,14336	;const
	ld	(_p_x),hl
.i_163
	ld	a,(_gpx)
	ld	(_gpox),a
	ld	hl,(_p_x)
	ex	de,hl
	ld	l,#(6 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	call	_player_calc_bounding_box
	ld	a,#(0 % 256 % 256)
	ld	(_hit_h),a
	ld	a,(_pty1)
	ld	(_cy1),a
	ld	a,(_pty2)
	ld	(_cy2),a
	ld	hl,(_p_vx)
	xor	a
	or	h
	jp	p,i_164
	ld	hl,(_ptx1)
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	ld	(_cx1),a
	call	_cm_two_points
	ld	hl,_at1
	ld	a,(hl)
	and	#(8 % 256)
	jp	nz,i_166
	ld	hl,_at2
	ld	a,(hl)
	and	#(8 % 256)
	jp	z,i_165
.i_166
	ld	hl,0	;const
	ld	(_p_vx),hl
	ld	hl,(_ptx1)
	ld	h,0
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asl
	ld	bc,-4
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	ld	(_p_x),hl
	ld	hl,3 % 256	;const
	ld	a,l
	ld	(_wall_h),a
	jp	i_168
.i_165
	ld	hl,_at1
	ld	a,(hl)
	rrca
	jp	c,i_169
	ld	hl,_at2
	ld	a,(hl)
	rrca
	jp	c,i_169
	ld	hl,0	;const
	jr	i_170
.i_169
	ld	hl,1	;const
.i_170
	ld	h,0
	ld	a,l
	ld	(_hit_h),a
.i_168
.i_164
	ld	hl,(_p_vx)
	xor	a
	or	h
	jp	m,i_171
	or	l
	jp	z,i_171
	ld	hl,(_ptx2)
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	ld	(_cx1),a
	call	_cm_two_points
	ld	hl,_at1
	ld	a,(hl)
	and	#(8 % 256)
	jp	nz,i_173
	ld	hl,_at2
	ld	a,(hl)
	and	#(8 % 256)
	jp	z,i_172
.i_173
	ld	hl,0	;const
	ld	(_p_vx),hl
	ld	a,(_ptx1)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	bc,4
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	ld	(_p_x),hl
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(_wall_h),a
	jp	i_175
.i_172
	ld	hl,_at1
	ld	a,(hl)
	rrca
	jp	c,i_176
	ld	hl,_at2
	ld	a,(hl)
	rrca
	jp	c,i_176
	ld	hl,0	;const
	jr	i_177
.i_176
	ld	hl,1	;const
.i_177
	ld	h,0
	ld	a,l
	ld	(_hit_h),a
.i_175
.i_171
	ld	a,(_p_facing_v)
	cp	#(255 % 256)
	jp	z,i_178
	ld	hl,(_p_facing_v)
	ld	h,0
	ld	a,l
	ld	(_p_facing),a
	jp	i_179
.i_178
	ld	a,(_p_facing_h)
	cp	#(255 % 256)
	jp	z,i_180
	ld	hl,(_p_facing_h)
	ld	h,0
	ld	a,l
	ld	(_p_facing),a
.i_180
.i_179
	ld	hl,(_gpx)
	ld	h,0
	ld	bc,8
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_p_tx),a
	ld	(_cx1),a
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,8
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_p_ty),a
	ld	(_cy1),a
	ld	hl,(_cx1)
	ld	h,0
	push	hl
	ld	hl,(_cy1)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	a,l
	ld	(_rdb),a
	ld	hl,_rdb
	ld	a,(hl)
	rlca
	jp	nc,i_181
	ld	l,a
	ld	h,0
	ld a, (_cy1)
	ld c, a
	ld (__y), a
	xor a
	ld (__t), a
	ld (__n), a
	ld a, c
	sla a
	sla a
	sla a
	sla a
	sub c
	ld c, a
	ld a, (_cx1)
	ld (__x), a
	add c
	ld (_gpaux), a
	call _update_tile
	call _persist_tile
	ld hl, _f_2
	dec (hl)
	ld hl, _nametable + 14
	ld de, 0x000E
	ld a, (_f_2)
	add 16
	ld (hl), a
	call cpc_UpdTileTable
	ld	hl,8	;const
	call	_wyz_play_sound
.i_181
	ld	a,(_wall_v)
	cp	#(1 % 256)
	jp	nz,i_182
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,7
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_cy1),a
	ld	hl,(_cx1)
	ld	h,0
	push	hl
	ld	hl,(_cy1)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	de,10	;const
	call	l_eq
	jp	nc,i_183
	ld	hl,(_cx1)
	ld	h,0
	ld	a,l
	ld	(_x1),a
	ld	(_x0),a
	ld	a,(_cy1)
	ld	(_y0),a
	ld	hl,(_cy1)
	ld	h,0
	dec	hl
	ld	h,0
	ld	a,l
	ld	(_y1),a
	call	_process_tile
.i_183
	jp	i_184
.i_182
	ld	a,(_wall_v)
	cp	#(2 % 256)
	jp	nz,i_185
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,16
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_cy1),a
	ld	hl,(_cx1)
	ld	h,0
	push	hl
	ld	hl,(_cy1)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	de,10	;const
	call	l_eq
	jp	nc,i_186
	ld	hl,(_cx1)
	ld	h,0
	ld	a,l
	ld	(_x1),a
	ld	(_x0),a
	ld	a,(_cy1)
	ld	(_y0),a
	ld	hl,(_cy1)
	ld	h,0
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_y1),a
	call	_process_tile
.i_186
	jp	i_187
.i_185
	ld	a,(_wall_h)
	cp	#(3 % 256)
	jp	nz,i_188
	ld	hl,(_gpx)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_cx1),a
	ld	l,a
	ld	h,0
	push	hl
	ld	hl,(_cy1)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	de,10	;const
	call	l_eq
	jp	nc,i_189
	ld	hl,(_cy1)
	ld	h,0
	ld	a,l
	ld	(_y1),a
	ld	(_y0),a
	ld	a,(_cx1)
	ld	(_x0),a
	ld	hl,(_cx1)
	ld	h,0
	dec	hl
	ld	h,0
	ld	a,l
	ld	(_x1),a
	call	_process_tile
.i_189
	jp	i_190
.i_188
	ld	a,(_wall_h)
	cp	#(4 % 256)
	jp	nz,i_191
	ld	hl,(_gpx)
	ld	h,0
	ld	bc,12
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(_cx1),a
	ld	l,a
	ld	h,0
	push	hl
	ld	hl,(_cy1)
	ld	h,0
	push	hl
	call	_attr
	pop	bc
	pop	bc
	ld	de,10	;const
	call	l_eq
	jp	nc,i_192
	ld	hl,(_cy1)
	ld	h,0
	ld	a,l
	ld	(_y1),a
	ld	(_y0),a
	ld	a,(_cx1)
	ld	(_x0),a
	ld	hl,(_cx1)
	ld	h,0
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_x1),a
	call	_process_tile
.i_192
.i_191
.i_190
.i_187
.i_184
	ld	hl,4	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_194
	ld	a,(_p_disparando)
	cp	#(0 % 256)
	jr	z,i_195_i_194
.i_194
	jp	i_193
.i_195_i_194
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_p_disparando),a
	call	_bullets_fire
.i_193
	ld	hl,4	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	nz,i_196
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_disparando),a
.i_196
	ld	a,#(0 % 256 % 256)
	ld	(_hit),a
	ld	a,(_hit_v)
	and	a
	jp	z,i_197
	ld	a,#(1 % 256 % 256)
	ld	(_hit),a
	ld	hl,(_p_vy)
	call	l_neg
	push	hl
	ld	hl,256	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	ld	(_p_vy),hl
	jp	i_198
.i_197
	ld	a,(_hit_h)
	and	a
	jp	z,i_199
	ld	a,#(1 % 256 % 256)
	ld	(_hit),a
	ld	hl,(_p_vx)
	call	l_neg
	push	hl
	ld	hl,256	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	ld	(_p_vx),hl
.i_199
.i_198
	ld	a,(_hit)
	and	a
	jp	z,i_200
	ld	a,(_p_estado)
	and	a
	jp	nz,i_201
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_201
.i_200
	ld	hl,(_p_vx)
	ld	a,h
	or	l
	jp	nz,i_203
	ld	hl,(_p_vy)
	ld	a,h
	or	l
	jp	nz,i_203
	jr	i_204
.i_203
	ld	hl,1	;const
.i_204
	ld	a,h
	or	l
	jp	z,i_202
	ld	hl,(_p_subframe)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_p_subframe),a
	cp	#(4 % 256)
	jp	nz,i_205
	ld	a,#(0 % 256 % 256)
	ld	(_p_subframe),a
	ld	hl,(_p_frame)
	ld	h,0
	call	l_lneg
	ld	hl,0	;const
	rl	l
	ld	a,l
	ld	(_p_frame),a
.i_205
.i_202
	ld	hl,_sp_sw
	push	hl
	ld	hl,_sm_sprptr
	push	hl
	ld	de,(_p_facing)
	ld	d,0
	ld	hl,(_p_frame)
	ld	h,d
	add	hl,de
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	call	l_pint_pop
	ld	hl,_sp_sw+8
	push	hl
	ld	hl,(_gpx)
	ld	h,0
	ld	bc,8
	add	hl,bc
	push	hl
	ld	hl,_sp_sw+6
	call	l_gchar
	pop	de
	add	hl,de
	ex	de,hl
	ld	l,#(2 % 256)
	call	l_asr_u
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_sp_sw+9
	push	hl
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,8
	add	hl,bc
	push	hl
	ld	hl,_sp_sw+7
	call	l_gchar
	pop	de
	add	hl,de
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_p_estado
	ld	a,(hl)
	and	#(2 % 256)
	jp	z,i_207
	ld	a,(_half_life)
	and	a
	jr	nz,i_208_i_207
.i_207
	jp	i_206
.i_208_i_207
	ld	hl,_sp_sw
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
.i_206
	ret



._player_deplete
	ld	de,(_p_life)
	ld	d,0
	ld	hl,(_p_kill_amt)
	ld	h,d
	call	l_ugt
	jp	nc,i_209
	ld	de,(_p_life)
	ld	d,0
	ld	hl,(_p_kill_amt)
	ld	h,d
	ex	de,hl
	and	a
	sbc	hl,de
	jp	i_210
.i_209
	ld	hl,0	;const
.i_210
	ld	h,0
	ld	a,l
	ld	(_p_life),a
	ret



._player_kill
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_killme),a
	call	_player_deplete
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	call	_wyz_play_sound
	ld	a,#(2 % 256 % 256)
	ld	(_p_estado),a
	ld	hl,50 % 256	;const
	ld	a,l
	ld	(_p_ct_estado),a
	ret



._enems_pursuers_init
	ld	de,_en_an_alive
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	de,_en_an_dead_row
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	push	hl
	call	_rand
	ld	de,15	;const
	call	l_and
	ld	de,16
	add	hl,de
	pop	de
	ld	a,l
	ld	(de),a
	ret



._enems_load
	ld	hl,(_n_pant)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	ld	a,l
	ld	(_enoffs),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_enit),a
	jp	i_213
.i_211
	ld	hl,(_enit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_enit),a
.i_213
	ld	a,(_enit)
	cp	#(3 % 256)
	jp	z,i_212
	jp	nc,i_212
	ld	de,_en_an_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(3 % 256 % 256)
	ld	de,(_enoffs)
	ld	d,0
	ld	hl,(_enit)
	ld	h,d
	add	hl,de
	ld	a,l
	ld	(_enoffsmasi),a
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	a,(hl)
	and	#(15 % 256)
	cp	#(6 % 256)
	ld	hl,0
	jp	z,i_214
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	push	hl
	ld	a,(hl)
	and	#(239 % 256)
	pop	de
	ld	(de),a
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	ld	(hl),#(2 % 256 % 256)
.i_214
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	a,(hl)
	and	#(31 % 256)
	ld	l,a
	ld	h,0
	ld	h,0
	ld	a,l
	ld	(_rdt),a
	and	a
	jp	z,i_215
	ld	hl,(_rdt)
	ld	h,0
.i_218
	ld	a,l
	cp	#(1% 256)
	jp	z,i_219
	cp	#(2% 256)
	jp	z,i_220
	cp	#(3% 256)
	jp	z,i_221
	cp	#(4% 256)
	jp	z,i_222
	cp	#(6% 256)
	jp	z,i_223
	cp	#(7% 256)
	jp	z,i_224
	jp	i_225
.i_219
.i_220
.i_221
.i_222
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	l,(hl)
	ld	h,0
	dec	hl
	add	hl,hl
	ld	de,8
	add	hl,de
	pop	de
	ld	a,l
	ld	(de),a
	jp	i_217
.i_223
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(16 % 256 % 256)
	ld	hl,_en_an_x
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	e,(hl)
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	call	l_pint_pop
	ld	hl,_en_an_y
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	inc	hl
	ld	e,(hl)
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	call	l_pint_pop
	ld	hl,_en_an_vx
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_en_an_vy
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	ld	de,0	;const
	ex	de,hl
	call	l_pint
	call	l_pint_pop
	ld	hl,_malotes
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	ld	(hl),#(10 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_217
.i_224
	call	_enems_pursuers_init
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_217
.i_225
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(255 % 256 % 256)
	ld	l,(hl)
	ld	h,0
.i_217
	jp	i_226
.i_215
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(255 % 256 % 256)
.i_226
	ld	hl,(_enit)
	ld	h,0
	ld	de,1
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_rda),a
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,255	;const
	call	l_ne
	ld	hl,0	;const
	rl	l
	ld	a,l
	ld	(_rdb),a
	ld	a,h
	or	l
	jp	z,i_227
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,6
	add	hl,bc
	push	hl
	ld	de,_sm_cox
	ld	hl,(_rdb)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,7
	add	hl,bc
	push	hl
	ld	de,_sm_coy
	ld	hl,(_rdb)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,12
	add	hl,bc
	push	hl
	ld	hl,_sm_invfunc
	push	hl
	ld	hl,(_rdb)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	call	l_pint_pop
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,14
	add	hl,bc
	push	hl
	ld	hl,_sm_updfunc
	push	hl
	ld	hl,(_rdb)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	call	l_pint_pop
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sm_sprptr
	push	hl
	ld	hl,(_rdb)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	call	l_pint_pop
	jp	i_228
.i_227
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
.i_228
	ld	a,(_rdt)
	cp	#(7 % 256)
	jp	nz,i_229
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
.i_229
	jp	i_211
.i_212
	ret



._enems_kill
	ld	hl,__en_t
	call	l_gchar
	ld	de,7	;const
	ex	de,hl
	call	l_ne
	jp	nc,i_230
	ld	hl,__en_t
	call	l_gchar
	ld	de,16	;const
	call	l_or
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(__en_t),a
.i_230
	ld	a,(_p_killed)
	inc	a
	ld	(_p_killed),a
	ld	hl,__en_t
	call	l_gchar
	ld	de,22	;const
	call	l_eq
	jp	nc,i_231
	ld	a,(_p_keys)
	inc	a
	ld	(_p_keys),a
	ld	hl,10	;const
	call	_wyz_play_sound
.i_231
	ret



._enems_move
	ld	hl,0	;const
	ld	(_ptgmy),hl
	ld	(_ptgmx),hl
	ld	h,0
	ld	a,l
	ld	(_p_gotten),a
	ld	(_tocado),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_enit),a
	jp	i_234
.i_232
	ld	hl,_enit
	ld	a,(hl)
	inc	(hl)
.i_234
	ld	a,(_enit)
	cp	#(3 % 256)
	jp	z,i_233
	jp	nc,i_233
	ld	a,#(0 % 256 % 256)
	ld	(_active),a
	ld	de,(_enoffs)
	ld	d,0
	ld	hl,(_enit)
	ld	h,d
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_enoffsmasi),a
	ld hl, (_enoffsmasi)
	ld h, 0
	add hl, hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de
	ld de, _malotes
	add hl, de
	ld (__baddies_pointer), hl
	ld a, (hl)
	ld (__en_x), a
	inc hl
	ld a, (hl)
	ld (__en_y), a
	inc hl
	ld a, (hl)
	ld (__en_x1), a
	inc hl
	ld a, (hl)
	ld (__en_y1), a
	inc hl
	ld a, (hl)
	ld (__en_x2), a
	inc hl
	ld a, (hl)
	ld (__en_y2), a
	inc hl
	ld a, (hl)
	ld (__en_mx), a
	inc hl
	ld a, (hl)
	ld (__en_my), a
	inc hl
	ld a, (hl)
	ld (__en_t), a
	and 0x1f
	ld (_rdt), a
	inc hl
	ld a, (hl)
	ld (__en_life), a
	ld	a,(__en_x)
	ld	(__en_cx),a
	ld	hl,(__en_y)
	ld	h,0
	ld	a,l
	ld	(__en_cy),a
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(4 % 256)
	jp	nz,i_235
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	dec	(hl)
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	nz,i_236
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
	jp	i_232
.i_236
.i_235
	ld	hl,(_rdt)
	ld	h,0
.i_239
	ld	a,l
	cp	#(1% 256)
	jp	z,i_240
	cp	#(2% 256)
	jp	z,i_241
	cp	#(3% 256)
	jp	z,i_242
	cp	#(4% 256)
	jp	z,i_243
	cp	#(6% 256)
	jp	z,i_244
	cp	#(7% 256)
	jp	z,i_245
	jp	i_238
.i_240
.i_241
.i_242
.i_243
	ld a, 1
	ld (_active), a
	ld a, (__en_mx)
	ld c, a
	ld a, (__en_x)
	add a, c
	ld (__en_x), a
	ld c, a
	ld a, (__en_x1)
	cp c
	jr z, _enems_lm_change_axis_x
	ld a, (__en_x2)
	cp c
	jr z, _enems_lm_change_axis_x
	call _mons_col_sc_x
	xor a
	or l
	jr z, _enems_lm_change_axis_x_done
	._enems_lm_change_axis_x
	ld a, (__en_mx)
	neg
	ld (__en_mx), a
	._enems_lm_change_axis_x_done
	ld a, (__en_my)
	ld c, a
	ld a, (__en_y)
	add a, c
	ld (__en_y), a
	ld c, a
	ld a, (__en_y1)
	cp c
	jr z, _enems_lm_change_axis_y
	ld a, (__en_y2)
	cp c
	jr z, _enems_lm_change_axis_y
	call _mons_col_sc_y
	xor a
	or l
	jr z, _enems_lm_change_axis_y_done
	._enems_lm_change_axis_y
	ld a, (__en_my)
	neg
	ld (__en_my), a
	._enems_lm_change_axis_y_done
	jp	i_238
.i_244
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_active),a
	ld a, (_enit)
	sla a
	ld c, a
	ld b, 0
	ld hl, _en_an_x
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (__en_an_x), de
	ld hl, _en_an_y
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (__en_an_y), de
	ld hl, _en_an_vx
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (__en_an_vx), de
	ld hl, _en_an_vy
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (__en_an_vy), de
	ld	hl,(__en_an_x)
	ex	de,hl
	ld	l,#(6 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(__en_x),a
	ld	(_cx2),a
	ld	hl,(__en_an_y)
	ex	de,hl
	ld	l,#(6 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(__en_y),a
	ld	(_cy2),a
	ld	hl,(__en_an_vx)
	push	hl
	ld	de,(_p_x)
	ld	hl,(__en_an_x)
	ex	de,hl
	and	a
	sbc	hl,de
	push	hl
	ld	hl,6	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	pop	de
	add	hl,de
	push	hl
	ld	hl,65408	;const
	push	hl
	ld	hl,128	;const
	push	hl
	call	_limit
	pop	bc
	pop	bc
	pop	bc
	ld	(__en_an_vx),hl
	ld	hl,(__en_an_vy)
	push	hl
	ld	de,(_p_y)
	ld	hl,(__en_an_y)
	ex	de,hl
	and	a
	sbc	hl,de
	push	hl
	ld	hl,6	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	pop	de
	add	hl,de
	push	hl
	ld	hl,65408	;const
	push	hl
	ld	hl,128	;const
	push	hl
	call	_limit
	pop	bc
	pop	bc
	pop	bc
	ld	(__en_an_vy),hl
	ld	de,(__en_an_x)
	ld	hl,(__en_an_vx)
	add	hl,de
	push	hl
	ld	hl,0	;const
	push	hl
	ld	hl,14336	;const
	push	hl
	call	_limit
	pop	bc
	pop	bc
	pop	bc
	ld	(__en_an_x),hl
	ld	de,(__en_an_y)
	ld	hl,(__en_an_vy)
	add	hl,de
	push	hl
	ld	hl,0	;const
	push	hl
	ld	hl,9216	;const
	push	hl
	call	_limit
	pop	bc
	pop	bc
	pop	bc
	ld	(__en_an_y),hl
	ld	hl,(__en_an_x)
	ex	de,hl
	ld	l,#(6 % 256)
	call	l_asr
	ld	a,l
	ld	(__en_x),a
	ld	hl,(__en_an_y)
	ex	de,hl
	ld	l,#(6 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(__en_y),a
	ld a, (_enit)
	sla a
	ld c, a
	ld b, 0
	ld hl, _en_an_x
	add hl, bc
	ld de, (__en_an_x)
	ld (hl), e
	inc hl
	ld (hl), d
	ld hl, _en_an_y
	add hl, bc
	ld de, (__en_an_y)
	ld (hl), e
	inc hl
	ld (hl), d
	ld hl, _en_an_vx
	add hl, bc
	ld de, (__en_an_vx)
	ld (hl), e
	inc hl
	ld (hl), d
	ld hl, _en_an_vy
	add hl, bc
	ld de, (__en_an_vy)
	ld (hl), e
	inc hl
	ld (hl), d
	jp	i_238
.i_245
	ld bc, (_enit)
	ld b, 0
	ld hl, _en_an_alive
	add hl, bc
	ld a, (hl)
	cp 1
	jp z, _eij_state_appearing
	cp 2
	jp z, _eij_state_moving
	._eij_state_idle
	ld hl, _en_an_dead_row
	add hl, bc
	ld a, (hl)
	or a
	jr nz, _eij_state_still_idle
	ld a, (__en_y1)
	ld d, a
	sla a
	sla a
	sla a
	sla a
	sub d
	ld d, a
	ld a, (__en_x1)
	add d
	ld e, a
	ld d, 0
	ld hl, _map_attr
	add hl, de
	ld a, (hl)
	or a
	jr nz, _eij_state_still_idle
	ld a, (__en_x1)
	ld (__en_x), a
	ld a, (__en_y1)
	ld (__en_y), a
	ld hl, _en_an_alive
	add hl, bc
	ld a, 1
	ld (hl), a
	push bc
	call _rand
	ld a, l
	and 3
	ld l, a
	ld h, 0
	ld de, 1
	call l_asl
	ld a, l
	pop bc
	cp 2+1
	jr c, _eij_rawv_set
	ld a, 2
	._eij_rawv_set
	ld hl, _en_an_rawv
	add hl, bc
	ld (hl), a
	call _rand
	ld a, l
	and 15
	add 16
	ld hl, _en_an_dead_row
	add hl, bc
	ld (hl), a
	ld a, 2
	ld (__en_life), a
	jp _eij_state_done
	._eij_state_still_idle
	dec a
	ld (hl), a
	jp _eij_state_done
	._eij_state_appearing
	ld hl, _en_an_dead_row
	add hl, bc
	ld a, (hl)
	or a
	jr nz, _eij_state_still_appearing
	ld a, 8 + 3*2
	ld hl, _en_an_base_frame
	add hl, bc
	ld (hl), a
	ld a, 2
	ld hl, _en_an_alive
	add hl, bc
	ld (hl), a
	jp _eij_state_done
	._eij_state_still_appearing
	dec a
	ld (hl), a
	ld hl, _en_an_next_frame
	add hl, bc
	add hl, bc
	ld de, _sprite_17_a
	ex de, hl
	call l_pint
	jp _eij_state_done
	._eij_state_moving
	ld a, 1
	ld (_active), a
	ld hl, _en_an_rawv
	add hl, bc
	ld a, (hl)
	ld (_rda), a
	ld a, (_p_estado)
	or a
	jr nz, _eij_state_done
	._eij_state_moving_x
	call _rand
	ld a, l
	and 3
	jr z, _eij_state_moving_y
	ld a, (__en_x)
	ld d, a
	ld a, (_gpx)
	cp d
	jr z, _eij_state_moving_y
	jr c, _eij_state_moving_x_left
	._eij_state_moving_x_right
	ld a, (_rda)
	ld (__en_mx), a
	jr _eij_state_moving_x_set
	._eij_state_moving_x_left
	ld a, (_rda)
	neg
	ld (__en_mx), a
	._eij_state_moving_x_set
	add d
	ld (__en_x), a
	call _mons_col_sc_x
	xor a
	or l
	jr z, _eij_state_moving_y
	ld a, (__en_cx)
	ld (__en_x), a
	._eij_state_moving_y
	call _rand
	ld a, l
	and 3
	jr z, _eij_state_done
	ld a, (__en_y)
	ld d, a
	ld a, (_gpy)
	cp d
	jr z, _eij_state_done
	jr c, _eij_state_moving_y_up
	._eij_state_moving_y_down
	ld a, (_rda)
	ld (__en_my), a
	jr _eij_state_moving_y_set
	._eij_state_moving_y_up
	ld a, (_rda)
	neg
	ld (__en_my), a
	._eij_state_moving_y_set
	add d
	ld (__en_y), a
	call _mons_col_sc_y
	xor a
	or l
	jr z, _eij_state_done
	ld a, (__en_cy)
	ld (__en_y), a
	._eij_state_done
.i_238
	ld	a,(_active)
	and	a
	jp	z,i_246
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,99	;const
	call	l_ne
	jp	nc,i_247
	ld bc, (_enit)
	ld b, 0
	ld hl, _en_an_count
	add hl, bc
	ld a, (hl)
	inc a
	ld (hl), a
	cp 4
	jr nz, _enems_move_update_frame_done
	xor a
	ld (hl), a
	ld hl, _en_an_frame
	add hl, bc
	ld a, (hl)
	xor 1
	ld (hl), a
	ld hl, _en_an_base_frame
	add hl, bc
	ld d, (hl)
	add d ; A = en_an_base_frame [enit] + en_an_frame [enit]]
	sla c ; Index 16 bits; it never overflows.
	ld hl, _en_an_next_frame
	add hl, bc
	ex de, hl ; DE -> en_an_next_frame [enit]
	sla a
	ld c, a
	ld b, 0
	ld hl, _sm_sprptr
	add hl, bc ; HL -> enem_cells [en_an_base_frame [enit] + en_an_frame [enit]]
	ldi
	ldi ; Copy 16 bit
	._enems_move_update_frame_done
.i_247
	ld	a,(__en_x)
	ld	(_cx2),a
	ld	a,(__en_y)
	ld	(_cy2),a
	ld	hl,(_tocado)
	ld	h,0
	call	l_lneg
	jp	nc,i_249
	call	_collide
	ld	a,h
	or	l
	jp	z,i_249
	ld	a,(_p_estado)
	cp	#(0 % 256)
	jr	z,i_250_i_249
.i_249
	jp	i_248
.i_250_i_249
	ld	a,#(1 % 256 % 256)
	ld	(_tocado),a
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_248
.i_251
	ld	a,(_rdt)
	cp	#(3 % 256)
	jr	z,i_252_uge
	jp	c,i_252
.i_252_uge
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpjt),a
	jp	i_255
.i_253
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
.i_255
	ld	a,(_gpjt)
	cp	#(3 % 256)
	jp	z,i_254
	jp	nc,i_254
	ld	de,_bullets_estado
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(1 % 256)
	jp	nz,i_256
	ld	de,_bullets_x
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_blx),a
	ld	de,_bullets_y
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ld	a,l
	ld	(_bly),a
	ld	de,(_blx)
	ld	d,0
	ld	hl,(__en_x)
	ld	h,d
	call	l_uge
	jp	nc,i_258
	ld	hl,(_blx)
	ld	h,0
	push	hl
	ld	hl,(__en_x)
	ld	h,0
	ld	bc,15
	add	hl,bc
	pop	de
	call	l_ule
	jp	nc,i_258
	ld	de,(_bly)
	ld	d,0
	ld	hl,(__en_y)
	ld	h,d
	call	l_uge
	jp	nc,i_258
	ld	hl,(_bly)
	ld	h,0
	push	hl
	ld	hl,(__en_y)
	ld	h,0
	ld	bc,15
	add	hl,bc
	pop	de
	call	l_ule
	jr	c,i_259_i_258
.i_258
	jp	i_257
.i_259_i_258
	ld	hl,__en_t
	call	l_gchar
	ld	de,6	;const
	call	l_eq
	jp	nc,i_260
	ld	hl,_en_an_vx
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	de,_bullets_mx
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	call	l_gchar
	push	hl
	ld	hl,128	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	pop	de
	add	hl,de
	call	l_pint_pop
.i_260
	ld	a,(__en_cx)
	ld	(__en_x),a
	ld	a,(__en_cy)
	ld	(__en_y),a
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_17_a
	call	l_pint_pop
	ld	de,_bullets_estado
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,__en_life
	call	l_gchar
	dec	hl
	ld	a,l
	ld	(__en_life),a
	ld	hl,__en_life
	call	l_gchar
	ld	a,h
	or	l
	jp	nz,i_261
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(4 % 256 % 256)
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(12 % 256 % 256)
	ld	hl,6	;const
	call	_wyz_play_sound
	call	_enems_pursuers_init
	call	_enems_kill
.i_261
	ld	hl,7	;const
	call	_wyz_play_sound
.i_257
.i_256
	jp	i_253
.i_254
.i_252
.i_246
	ld	hl,(_enit)
	ld	h,0
	ld	de,1
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_rda),a
	ld	de,_en_an_sprid
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	ld	(_rdt),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	push	hl
	ld	hl,(__en_x)
	ld	h,0
	ld	bc,8
	add	hl,bc
	push	hl
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,6
	add	hl,bc
	call	l_gchar
	pop	de
	add	hl,de
	ex	de,hl
	ld	l,#(2 % 256)
	call	l_asr_u
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	push	hl
	ld	hl,(__en_y)
	ld	h,0
	ld	bc,8
	add	hl,bc
	push	hl
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,7
	add	hl,bc
	call	l_gchar
	pop	de
	add	hl,de
	pop	de
	ld	a,l
	ld	(de),a
	ld	a,(_rdt)
	cp	#(255 % 256)
	jp	z,i_262
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_en_an_next_frame
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	call	l_pint_pop
	jp	i_263
.i_262
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_rda)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	call	l_pint_pop
.i_263
	ld hl, (__baddies_pointer)
	ld a, (__en_x)
	ld (hl), a
	inc hl
	ld a, (__en_y)
	ld (hl), a
	inc hl
	ld a, (__en_x1)
	ld (hl), a
	inc hl
	ld a, (__en_y1)
	ld (hl), a
	inc hl
	ld a, (__en_x2)
	ld (hl), a
	inc hl
	ld a, (__en_y2)
	ld (hl), a
	inc hl
	ld a, (__en_mx)
	ld (hl), a
	inc hl
	ld a, (__en_my)
	ld (hl), a
	inc hl
	ld a, (__en_t)
	ld (hl), a
	inc hl
	ld a, (__en_life)
	ld (hl), a
	jp	i_232
.i_233
	ret



._hotspots_do
	ld	hl,_hotspots
	push	hl
	ld	hl,(_n_pant)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	a,l
	and	a
	jp	nz,i_264
	ret


.i_264
	ld	a,(_hotspot_x)
	ld	(_cx2),a
	ld	hl,(_hotspot_y)
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	call	_collide
	ld	a,h
	or	l
	jp	z,i_265
	ld	a,#(1 % 256 % 256)
	ld	(_hotspot_destroy),a
	ld	hl,_hotspots
	push	hl
	ld	hl,(_n_pant)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	pop	de
	add	hl,de
	inc	hl
	ld	l,(hl)
	ld	h,0
.i_268
	ld	a,l
	cp	#(1% 256)
	jp	z,i_269
	cp	#(2% 256)
	jp	z,i_270
	cp	#(3% 256)
	jp	z,i_271
	cp	#(4% 256)
	jp	z,i_272
	jp	i_267
.i_269
	ld	a,(_p_objs)
	inc	a
	ld	(_p_objs),a
	ld	hl,5	;const
	call	_wyz_play_sound
	jp	i_267
.i_270
	ld	hl,_p_keys
	ld	a,(hl)
	inc	(hl)
	ld	hl,10	;const
	call	_wyz_play_sound
	jp	i_267
.i_271
	ld	hl,(_p_life)
	ld	h,0
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_p_life),a
	ld	de,_l_max_life
	ld	hl,(_level)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	ld	(_p_life),a
	ld	hl,11	;const
	call	_wyz_play_sound
	jp	i_267
.i_272
	ld	hl,(_p_ammo)
	ld	h,0
	ld	de,99
	ex	de,hl
	and	a
	sbc	hl,de
	ld	de,25	;const
	ex	de,hl
	call	l_ugt
	jp	nc,i_273
	ld	hl,(_p_ammo)
	ld	h,0
	ld	bc,25
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_p_ammo),a
	jp	i_274
.i_273
	ld	hl,99 % 256	;const
	ld	a,l
	ld	(_p_ammo),a
.i_274
	ld	hl,11	;const
	call	_wyz_play_sound
.i_267
	ld	a,(_hotspot_destroy)
	and	a
	jp	z,i_275
	ld	hl,_hotspots
	push	hl
	ld	hl,(_n_pant)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	(hl),#(0 % 256 % 256)
	ld	a,(_hotspot_x)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	a,(_hotspot_y)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	a,l
	ld	(__y),a
	ld	hl,(_orig_tile)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_draw_invalidate_coloured_tile_g
	ld	hl,240 % 256	;const
	ld	a,l
	ld	(_hotspot_y),a
.i_275
.i_265
	ret


	.EFECTO0
	defb 0x25, 0x1C, 0x00
	defb 0x3A, 0x0F, 0x00
	defb 0x2D, 0x0F, 0x00
	defb 0xE2, 0x0F, 0x00
	defb 0xBC, 0x0F, 0x00
	defb 0x96, 0x0D, 0x00
	defb 0x4B, 0x0D, 0x00
	defb 0x32, 0x0D, 0x00
	defb 0x3A, 0x0D, 0x00
	defb 0x2D, 0x0D, 0x00
	defb 0xE2, 0x0D, 0x00
	defb 0xBC, 0x0D, 0x00
	defb 0x96, 0x0D, 0x00
	defb 0x4B, 0x0D, 0x00
	defb 0x32, 0x0D, 0x00
	defb 0x3A, 0x0D, 0x00
	defb 0x2D, 0x0C, 0x00
	defb 0xE2, 0x0C, 0x00
	defb 0xBC, 0x0C, 0x00
	defb 0x96, 0x0B, 0x00
	defb 0x4B, 0x0B, 0x00
	defb 0x32, 0x0B, 0x00
	defb 0x3A, 0x0B, 0x00
	defb 0x2D, 0x0B, 0x00
	defb 0xE2, 0x0B, 0x00
	defb 0xBC, 0x0B, 0x00
	defb 0x96, 0x0B, 0x00
	defb 0x4B, 0x0A, 0x00
	defb 0x32, 0x0A, 0x00
	defb 0x3A, 0x0A, 0x00
	defb 0x2D, 0x09, 0x00
	defb 0xE2, 0x09, 0x00
	defb 0xBC, 0x08, 0x00
	defb 0x96, 0x08, 0x00
	defb 0x4B, 0x08, 0x00
	defb 0x32, 0x07, 0x00
	defb 0x3A, 0x07, 0x00
	defb 0x2D, 0x06, 0x00
	defb 0xE2, 0x06, 0x00
	defb 0xBC, 0x06, 0x00
	defb 0x96, 0x05, 0x00
	defb 0x4B, 0x05, 0x00
	defb 0x32, 0x05, 0x00
	defb 0x3A, 0x04, 0x00
	defb 0x2D, 0x04, 0x00
	defb 0xE2, 0x03, 0x00
	defb 0xBC, 0x03, 0x00
	defb 0x96, 0x03, 0x00
	defb 0x4B, 0x03, 0x00
	defb 0x32, 0x02, 0x00
	defb 0x3A, 0x01, 0x00
	defb 0x2D, 0x01, 0x00
	defb 0xE2, 0x01, 0x00
	defb 0xBC, 0x01, 0x00
	defb 0xFF
	.EFECTO1
	defb 0xC3, 0x0E, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xA6, 0x0F, 0x00
	defb 0xE8, 0x1B, 0x00
	defb 0x80, 0x2B, 0x00
	defb 0xFF
	.EFECTO2
	defb 0x1F, 0x0B, 0x00
	defb 0x5A, 0x0F, 0x00
	defb 0x3C, 0x0F, 0x00
	defb 0x1E, 0x0A, 0x00
	defb 0x2D, 0x0A, 0x00
	defb 0x5A, 0x05, 0x00
	defb 0x3C, 0x05, 0x00
	defb 0x1E, 0x04, 0x00
	defb 0x2D, 0x02, 0x00
	defb 0xB4, 0x01, 0x00
	defb 0xFF
	.EFECTO3
	defb 0xE8, 0x1B, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xA6, 0x0F, 0x00
	defb 0x00, 0x00, 0x00
	defb 0x80, 0x0F, 0x00
	defb 0xFF
	.EFECTO4
	defb 0x1F, 0x0B, 0x00
	defb 0xAF, 0x0F, 0x00
	defb 0x8A, 0x0F, 0x00
	defb 0x71, 0x0F, 0x00
	defb 0x64, 0x0F, 0x00
	defb 0x3E, 0x0C, 0x00
	defb 0x25, 0x0C, 0x00
	defb 0x25, 0x0C, 0x00
	defb 0x25, 0x0C, 0x00
	defb 0x25, 0x0A, 0x00
	defb 0x4B, 0x0A, 0x00
	defb 0x4B, 0x0A, 0x00
	defb 0x4B, 0x0A, 0x00
	defb 0x3E, 0x08, 0x00
	defb 0x3E, 0x08, 0x00
	defb 0x3E, 0x08, 0x00
	defb 0x71, 0x08, 0x00
	defb 0x3E, 0x07, 0x00
	defb 0x25, 0x05, 0x00
	defb 0x25, 0x02, 0x00
	defb 0xFF
	.EFECTO5
	defb 0x1F, 0x0B, 0x00
	defb 0x5A, 0x0F, 0x00
	defb 0x3C, 0x0F, 0x00
	defb 0x1E, 0x0A, 0x00
	defb 0x2D, 0x0A, 0x00
	defb 0x5A, 0x05, 0x00
	defb 0x3C, 0x05, 0x00
	defb 0x1E, 0x04, 0x00
	defb 0x2D, 0x02, 0x00
	defb 0xB4, 0x01, 0x00
	defb 0xFF
	.EFECTO6
	defb 0xE8, 0x1B, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xE2, 0x0F, 0x00
	defb 0x56, 0x0F, 0x00
	defb 0xF6, 0x0F, 0x00
	defb 0x14, 0x0E, 0x00
	defb 0x64, 0x0E, 0x00
	defb 0x62, 0x0D, 0x00
	defb 0xD0, 0x0D, 0x00
	defb 0xF1, 0x0C, 0x00
	defb 0xFF
	.EFECTO7
	defb 0xC3, 0x0E, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xA6, 0x0F, 0x00
	defb 0xE8, 0x1B, 0x00
	defb 0x80, 0x2B, 0x00
	defb 0xFF
	.EFECTO8
	defb 0x1F, 0x0B, 0x00
	defb 0x5A, 0x0F, 0x00
	defb 0x3C, 0x0F, 0x00
	defb 0x1E, 0x0A, 0x00
	defb 0x2D, 0x0A, 0x00
	defb 0x5A, 0x05, 0x00
	defb 0x3C, 0x05, 0x00
	defb 0x1E, 0x04, 0x00
	defb 0x2D, 0x02, 0x00
	defb 0xB4, 0x01, 0x00
	defb 0xFF
	.EFECTO9
	defb 0xE8, 0x1B, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xA6, 0x0F, 0x00
	defb 0x00, 0x00, 0x00
	defb 0x80, 0x0F, 0x00
	defb 0xFF
	.EFECTO10
	defb 0x1F, 0x0B, 0x00
	defb 0x5A, 0x0F, 0x00
	defb 0x3C, 0x0F, 0x00
	defb 0x1E, 0x0A, 0x00
	defb 0x2D, 0x0A, 0x00
	defb 0x5A, 0x05, 0x00
	defb 0x3C, 0x05, 0x00
	defb 0x1E, 0x04, 0x00
	defb 0x2D, 0x02, 0x00
	defb 0xB4, 0x01, 0x00
	defb 0xFF
	.EFECTO11
	defb 0x1A, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xB4, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x87, 0x0E, 0x00
	defb 0x78, 0x0E, 0x00
	defb 0x78, 0x0E, 0x00
	defb 0x78, 0x0D, 0x00
	defb 0x78, 0x0D, 0x00
	defb 0x78, 0x0D, 0x00
	defb 0x78, 0x0D, 0x00
	defb 0x78, 0x0D, 0x00
	defb 0x78, 0x0D, 0x00
	defb 0x78, 0x0C, 0x00
	defb 0x78, 0x09, 0x00
	defb 0x78, 0x06, 0x00
	defb 0x78, 0x05, 0x00
	defb 0xFF
	.EFECTO12
	defb 0xE8, 0x1B, 0x00
	defb 0xB4, 0x0F, 0x00
	defb 0xA0, 0x0E, 0x00
	defb 0x90, 0x0D, 0x00
	defb 0x87, 0x0D, 0x00
	defb 0x78, 0x0C, 0x00
	defb 0x6C, 0x0B, 0x00
	defb 0x60, 0x0A, 0x00
	defb 0x5A, 0x09, 0x00
	defb 0xFF
	.EFECTO13
	defb 0xE8, 0x1B, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xA6, 0x0F, 0x00
	defb 0x00, 0x00, 0x00
	defb 0x80, 0x0F, 0x00
	defb 0xFF
	.EFECTO14
	defb 0xE8, 0x1B, 0x00
	defb 0x5F, 0x0F, 0x00
	defb 0xA6, 0x0F, 0x00
	defb 0x00, 0x00, 0x00
	defb 0x80, 0x0F, 0x00
	defb 0xFF
	; Tabla de instrumentos
	.TABLA_PAUTAS
	defw PAUTA_0,PAUTA_1,PAUTA_2,PAUTA_3,PAUTA_4,PAUTA_5,0,PAUTA_7,PAUTA_8,PAUTA_9,PAUTA_10,PAUTA_11,PAUTA_12,PAUTA_13,PAUTA_14,PAUTA_15,PAUTA_16
	; Tabla de efectos
	.TABLA_SONIDOS
	defw SONIDO0,SONIDO1,SONIDO2,SONIDO3,SONIDO4,SONIDO5,SONIDO6,SONIDO7,SONIDO8,SONIDO9
	;Pautas (instrumentos)
	;Instrumento 'Piano'
	.PAUTA_0
	defb 8,0,7,0,6,0,5,0,129
	;Instrumento 'Piano Reverb'
	.PAUTA_1
	defb 11,0,12,0,11,0,10,0,9,0,9,0,9,0,9,0,9,0,9,0,8,0,8,0,8,0,8,0,136
	;Instrumento 'Fade In FX'
	.PAUTA_2
	defb 2,0,3,0,4,8,4,-1,5,-4,5,20,5,-24,4,4,132
	;Instrumento 'Guitar 1'
	.PAUTA_3
	defb 14,0,14,0,12,0,12,0,10,0,9,1,9,1,9,-1,8,-1,8,0,8,0,134
	;Instrumento 'Guitar 2'
	.PAUTA_4
	defb 13,0,13,0,12,0,11,0,9,0,8,1,8,0,8,0,8,-1,8,0,8,0,134
	;Instrumento 'Eco guitar'
	.PAUTA_5
	defb 7,0,7,0,7,0,6,0,6,0,6,0,6,0,6,0,5,0,5,0,5,0,5,0,5,0,4,0,4,0,4,0,4,0,3,0,0,0,129
	;Instrumento 'Solo Guitar'
	.PAUTA_7
	defb 76,0,11,0,11,0,11,0,10,0,9,1,9,0,9,-1,9,0,9,0,9,-1,9,0,9,1,9,0,9,0,138
	;Instrumento 'Eco Solo Guitar'
	.PAUTA_8
	defb 70,0,6,0,6,0,5,0,5,0,5,0,5,0,5,0,4,0,4,0,4,0,4,0,4,0,4,0,3,0,3,0,3,0,3,0,3,0,3,0,2,0,2,0,2,0,1,0,129
	;Instrumento 'Slap Bass'
	.PAUTA_9
	defb 45,0,12,4,11,-4,10,3,9,-5,8,0,129
	;Instrumento 'Robo'
	.PAUTA_10
	defb 7,-1,23,5,23,9,6,0,22,5,22,9,5,0,21,5,21,9,4,0,20,5,20,9,3,0,19,5,19,9,131
	;Instrumento 'Chip'
	.PAUTA_11
	defb 70,0,7,0,40,0,7,0,6,0,5,0,129
	;Instrumento 'Clipclop'
	.PAUTA_12
	defb 12,0,11,0,10,0,9,0,9,0,9,0,9,0,9,0,8,0,8,0,8,0,8,0,8,0,138
	;Instrumento 'Eco'
	.PAUTA_13
	defb 9,0,8,0,7,0,6,0,129
	;Instrumento 'Harmonica'
	.PAUTA_14
	defb 42,0,11,0,12,0,11,0,10,0,9,0,129
	;Instrumento 'Onda'
	.PAUTA_15
	defb 73,0,10,0,11,0,12,0,11,0,10,0,9,0,6,0,129
	;Instrumento 'Teeth'
	.PAUTA_16
	defb 73,0,10,0,42,0,9,0,8,0,7,0,7,0,7,0,7,0,6,0,6,0,6,0,6,0,136
	;Efectos
	;Efecto 'Bass Drum'
	.SONIDO0
	defb 209,60,0,15,124,0,255
	;Efecto 'Bass Drum Vol 2'
	.SONIDO1
	defb 186,58,0,0,102,0,162,131,0,255
	;Efecto 'Drum'
	.SONIDO2
	defb 231,46,0,115,43,1,100,42,2,255
	;Efecto 'Drum 2'
	.SONIDO3
	defb 19,63,0,0,13,1,0,10,1,0,8,1,255
	;Efecto 'Hit hat'
	.SONIDO4
	defb 0,12,1,0,6,1,255
	;Efecto 'Hit Hat 2'
	.SONIDO5
	defb 0,12,1,255
	;Efecto 'Bongo 1'
	.SONIDO6
	defb 186,30,0,232,25,0,0,40,0,69,38,0,255
	;Efecto 'Bongo 2'
	.SONIDO7
	defb 69,46,0,186,41,0,46,56,0,232,54,0,255
	;Efecto 'Drum 3'
	.SONIDO8
	defb 232,44,0,0,92,5,23,108,5,232,124,5,255
	;Efecto 'Mute'
	.SONIDO9
	defb 0,0,0,255
	;Frecuencias para las notas
	._00_title_mus_bin
	BINARY "../mus/00_title.mus.bin"
	._01_ingamea_mus_bin
	BINARY "../mus/01_ingamea.mus.bin"
	._02_gover_mus_bin
	BINARY "../mus/02_gover.mus.bin"
	._03_ingameb_mus_bin
	BINARY "../mus/03_ingameb.mus.bin"
	._04_sclear_mus_bin
	BINARY "../mus/04_sclear.mus.bin"
	._wyz_songs
	defw _00_title_mus_bin, _01_ingamea_mus_bin, _02_gover_mus_bin
	defw _03_ingameb_mus_bin, _04_sclear_mus_bin

._wyz_init
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_isr_player_on),a
	call WYZPLAYER_INIT
	ret



._wyz_play_music
	push	hl
	ld	hl,_wyz_songs
	push	hl
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,35840	;const
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	ld a, 0
	call CARGA_CANCION
	ld a, 1
	ld (_isr_player_on), a
	pop	bc
	ret



._wyz_play_sound
	push	hl
	; Sound number is in L
	ld a, l
	ld b, 1
	call INICIA_EFECTO
	pop	bc
	ret



._wyz_stop_sound
	call PLAYER_OFF
	xor a
	ld (_isr_player_on), a
	ret


	; 1 PSG proPLAYER V 0.47c - WYZ 19.03.2016
	; (WYZTracker 2.0 o superior)
	.WYZPLAYER_INIT
	CALL PLAYER_OFF
	LD DE, 0x0020 ; No. BYTES RESERVADOS POR CANAL
	LD HL, 0xDF80 ;* RESERVAR MEMORIA PARA BUFFER DE SONIDO!!!!!
	LD (CANAL_A), HL
	ADD HL, DE
	LD (CANAL_B), HL
	ADD HL, DE
	LD (CANAL_C), HL
	ADD HL, DE
	LD (CANAL_P), HL
	RET
	.INICIO
	.WYZ_PLAYER_ISR
	CALL ROUT
	LD HL,PSG_REG
	LD DE,PSG_REG_SEC
	LD BC,14
	LDIR
	CALL REPRODUCE_SONIDO
	CALL PLAY
	JP REPRODUCE_EFECTO
	; REPRODUCE UN SONIDO POR EL CANAL ESPECIFICADO
	; IN
	; A = NUMERO DE SONIDO
	; B = CANAL
	.INICIA_SONIDO
	LD HL, TABLA_SONIDOS
	CALL EXT_WORD
	LD (PUNTERO_SONIDO), DE
	LD HL, INTERR
	SET 2, (HL)
	; na_th_an :: Percussion channel is fixed to 1
	;LD A, 1
	;LD HL, TABLA_DATOS_CANAL_SFX
	;CALL EXT_WORD
	;LD (SONIDO_REGS), DE
	RET
	; REPRODUCE UN FX POR EL CANAL ESPECIFICADO
	; IN
	; A = NUMERO DE SONIDO
	; B = CANAL
	.INICIA_EFECTO
	LD HL, TABLA_EFECTOS
	CALL EXT_WORD
	LD (PUNTERO_EFECTO), DE
	LD HL, INTERR
	SET 3, (HL)
	LD A, B
	LD HL, TABLA_DATOS_CANAL_SFX
	CALL EXT_WORD
	LD (EFECTO_REGS), DE
	RET
	;REPRODUCE EFECTOS DE SONIDO
	.REPRODUCE_SONIDO
	LD HL, INTERR
	BIT 2,(HL) ;ESTA ACTIVADO EL EFECTO?
	RET Z
	LD HL, (SONIDO_REGS)
	PUSH HL
	POP IX
	LD HL, (PUNTERO_SONIDO)
	CALL REPRODUCE_SONIDO_O_EFECTO
	OR A
	JR Z, REPRODUCE_SONIDO_LIMPIA_BIT
	LD (PUNTERO_SONIDO), HL
	RET
	.REPRODUCE_SONIDO_LIMPIA_BIT
	LD HL, INTERR
	RES 2, (HL)
	RET
	.REPRODUCE_EFECTO
	LD HL, INTERR
	BIT 3, (HL)
	RET Z
	LD HL, (EFECTO_REGS)
	PUSH HL
	POP IX
	LD HL, (PUNTERO_EFECTO)
	CALL REPRODUCE_SONIDO_O_EFECTO
	OR A
	JR Z, REPRODUCE_EFECTO_LIMPIA_BIT
	LD (PUNTERO_EFECTO), HL
	RET
	.REPRODUCE_EFECTO_LIMPIA_BIT
	LD HL, INTERR
	RES 3, (HL)
	RET
	.REPRODUCE_SONIDO_O_EFECTO
	LD A,(HL)
	CP 0xFF
	JR Z,FIN_SONIDO
	LD E, (IX+0) ; IX+0 -> SFX_L LO
	LD D, (IX+1) ; IX+1 -> SFX_L HI
	LD (DE),A
	INC HL
	LD A,(HL)
	RRCA
	RRCA
	RRCA
	RRCA
	AND 00001111B
	LD E, (IX+2) ; IX+2 -> SFX_H LO
	LD D, (IX+3) ; IX+3 -> SFX_H HI
	LD (DE),A
	LD A,(HL)
	AND 00001111B
	LD E, (IX+4) ; IX+4 -> SFX_V LO
	LD D, (IX+5) ; IX+5 -> SFX_V HI
	LD (DE),A
	INC HL
	LD A,(HL)
	LD B,A
	BIT 7,A ;09.08.13 BIT MAS SIGINIFICATIVO ACTIVA ENVOLVENTES
	JR Z,NO_ENVOLVENTES_SONIDO
	LD A,0x12
	LD (DE),A
	INC HL
	LD A,(HL)
	LD (PSG_REG_SEC+11),A
	INC HL
	LD A,(HL)
	LD (PSG_REG_SEC+12),A
	INC HL
	LD A,(HL)
	CP 1
	JR Z,NO_ENVOLVENTES_SONIDO ;NO ESCRIBE LA ENVOLVENTE SI SU VALOR ES 1
	LD (PSG_REG_SEC+13),A
	.NO_ENVOLVENTES_SONIDO
	LD A,B
	AND 0x7F ; RES 7,A ; AND A
	JR Z,NO_RUIDO
	LD (PSG_REG_SEC+6),A
	LD A, (IX+6) ; IX+6 -> SFX_MIX
	JR SI_RUIDO
	.NO_RUIDO XOR A
	LD (PSG_REG_SEC+6),A
	LD A,10111000B
	.SI_RUIDO LD (PSG_REG_SEC+7),A
	INC HL
	LD A, 1
	RET
	.FIN_SONIDO
	LD A,(ENVOLVENTE_BACK) ;NO RESTAURA LA ENVOLVENTE SI ES 0
	AND A
	JR Z,FIN_NOPLAYER
	;xor a ; ***
	LD (PSG_REG_SEC+13),A ;08.13 RESTAURA LA ENVOLVENTE TRAS EL SFX
	.FIN_NOPLAYER
	LD A,10111000B
	LD (PSG_REG_SEC+7),A
	XOR A
	RET
	;VUELCA BUFFER DE SONIDO AL PSG
	.ROUT
	LD A,(PSG_REG+13)
	AND A ;ES CERO?
	JR Z,NO_BACKUP_ENVOLVENTE
	LD (ENVOLVENTE_BACK),A ;08.13 / GUARDA LA ENVOLVENTE EN EL BACKUP
	XOR A
	.NO_BACKUP_ENVOLVENTE
	;VUELCA BUFFER DE SONIDO AL PSG
	LD HL,PSG_REG_SEC
	.LOUT
	CALL WRITEPSGHL
	INC A
	CP 13
	JR NZ,LOUT
	LD A,(HL)
	AND A
	RET Z
	LD A,13
	CALL WRITEPSGHL
	XOR A
	LD (PSG_REG+13),A
	LD (PSG_REG_SEC+13),A
	RET
	;; A = REGISTER
	;; (HL) = VALUE
	.WRITEPSGHL
	LD B,0xF4
	OUT (C),A
	LD BC,0xF6C0
	OUT (C),C
	DEFB 0xED
	DEFB 0x71
	LD B,0xF5
	OUTI
	LD BC,0xF680
	OUT (C),C
	DEFB 0xED
	DEFB 0x71
	RET
	;PLAYER OFF
	.PLAYER_OFF
	XOR A ;***** IMPORTANTE SI NO HAY MUSICA ****
	LD (INTERR),A
	;LD (FADE),A ;solo si hay fade out
	.CLEAR_PSG_BUFFER
	LD HL,PSG_REG
	LD DE,PSG_REG+1
	LD BC,14
	LD (HL),A
	LDIR
	LD A,10111000B ; **** POR SI ACASO ****
	LD (PSG_REG+7),A
	LD HL,PSG_REG
	LD DE,PSG_REG_SEC
	LD BC,14
	LDIR
	JP ROUT
	;CARGA UNA CANCION
	;.IN(A)=N� DE CANCION
	.CARGA_CANCION
	LD HL,INTERR ;CARGA CANCION
	SET 1,(HL) ;REPRODUCE CANCION
	LD HL,SONG
	LD (HL),A ;N� A
	;DECODIFICAR
	;IN-> INTERR 0 ON
	; SONG
	;CARGA CANCION SI/NO
	.DECODE_SONG
	LD A,(SONG)
	;LEE CABECERA DE LA CANCION
	;BYTE 0=TEMPO
	LD HL,TABLA_SONG
	CALL EXT_WORD
	LD A,(DE)
	LD (TEMPO),A
	DEC A
	LD (TTEMPO),A
	;HEADER BYTE 1
	;[-|-|-|-| 3-1 | 0 ]
	;[-|-|-|-|FX CHN|LOOP]
	INC DE ;LOOP 1=ON/0=OFF?
	LD A,(DE)
	BIT 0,A
	JR Z,NPTJP0
	LD HL,INTERR
	SET 4,(HL)
	;SELECCION DEL CANAL DE EFECTOS DE RITMO
	.NPTJP0
	AND 00000110B
	RRA
	;LD (SELECT_CANAL_P),A
	PUSH DE
	; na_th_an :: Percussion channel is fixed to 1
	;LD HL, TABLA_DATOS_CANAL_SFX
	;CALL EXT_WORD
	;LD (SONIDO_REGS), DE
	POP HL
	INC HL ;2 BYTES RESERVADOS
	INC HL
	INC HL
	;BUSCA Y GUARDA INICIO DE LOS CANALES EN EL MODULO MUS (OPTIMIZAR****************)
	;A�ADE OFFSET DEL LOOP
	PUSH HL ;IX INICIO OFFSETS LOOP POR CANAL
	POP IX
	LD DE,0x0008 ;HASTA INICIO DEL CANAL A
	ADD HL,DE
	LD (PUNTERO_P_DECA),HL ;GUARDA PUNTERO INICIO CANAL
	LD E,(IX+0)
	LD D,(IX+1)
	ADD HL,DE
	LD (PUNTERO_L_DECA),HL ;GUARDA PUNTERO INICIO LOOP
	CALL BGICMODBC1
	LD (PUNTERO_P_DECB),HL
	LD E,(IX+2)
	LD D,(IX+3)
	ADD HL,DE
	LD (PUNTERO_L_DECB),HL
	CALL BGICMODBC1
	LD (PUNTERO_P_DECC),HL
	LD E,(IX+4)
	LD D,(IX+5)
	ADD HL,DE
	LD (PUNTERO_L_DECC),HL
	CALL BGICMODBC1
	LD (PUNTERO_P_DECP),HL
	LD E,(IX+6)
	LD D,(IX+7)
	ADD HL,DE
	LD (PUNTERO_L_DECP),HL
	;LEE DATOS DE LAS NOTAS
	;[|][|||||] LONGITUD\NOTA
	.INIT_DECODER
	LD DE,(CANAL_A)
	LD (PUNTERO_A),DE
	LD HL,(PUNTERO_P_DECA)
	CALL DECODE_CANAL ;CANAL A
	LD (PUNTERO_DECA),HL
	LD DE,(CANAL_B)
	LD (PUNTERO_B),DE
	LD HL,(PUNTERO_P_DECB)
	CALL DECODE_CANAL ;CANAL B
	LD (PUNTERO_DECB),HL
	LD DE,(CANAL_C)
	LD (PUNTERO_C),DE
	LD HL,(PUNTERO_P_DECC)
	CALL DECODE_CANAL ;CANAL C
	LD (PUNTERO_DECC),HL
	LD DE,(CANAL_P)
	LD (PUNTERO_P),DE
	LD HL,(PUNTERO_P_DECP)
	CALL DECODE_CANAL ;CANAL P
	LD (PUNTERO_DECP),HL
	RET
	;BUSCA INICIO DEL CANAL
	.BGICMODBC1
	LD E,0x3F ;CODIGO INSTRUMENTO 0
	.BGICMODBC2
	XOR A ;BUSCA EL BYTE 0
	LD B,0xFF ;EL MODULO DEBE TENER UNA LONGITUD MENOR DE 0xFF00 ... o_O!
	CPIR
	DEC HL
	DEC HL
	LD A,E ;ES EL INSTRUMENTO 0??
	CP (HL)
	INC HL
	INC HL
	JR Z,BGICMODBC2
	DEC HL
	DEC HL
	DEC HL
	LD A,E ;ES VOLUMEN 0??
	CP (HL)
	INC HL
	INC HL
	INC HL
	JR Z,BGICMODBC2
	RET
	;DECODIFICA NOTAS DE UN CANAL
	;IN (DE)=DIRECCION DESTINO
	;NOTA=0 FIN CANAL
	;NOTA=1 SILENCIO
	;NOTA=2 PUNTILLO
	;NOTA=3 COMANDO I
	.DECODE_CANAL
	LD A,(HL)
	AND A ;FIN DEL CANAL?
	JR Z,FIN_DEC_CANAL
	CALL GETLEN
	CP 00000001B ;ES SILENCIO?
	JR NZ,NO_SILENCIO
	OR 0x40 ; SET 6,A
	JR NO_MODIFICA
	.NO_SILENCIO
	CP 00111110B ;ES PUNTILLO?
	JR NZ,NO_PUNTILLO
	OR A
	RRC B
	XOR A
	JR NO_MODIFICA
	.NO_PUNTILLO
	CP 00111111B ;ES COMANDO?
	JR NZ,NO_MODIFICA
	BIT 0,B ;COMADO=INSTRUMENTO?
	JR Z,NO_INSTRUMENTO
	LD A,11000001B ;CODIGO DE INSTRUMENTO
	LD (DE),A
	INC HL
	INC DE
	LDI ;N� DE INSTRUMENTO
	; LD A,(HL)
	; LD (DE),A
	; INC DE
	; INC HL
	LDI ;VOLUMEN RELATIVO DEL INSTRUMENTO
	; LD A,(HL)
	; LD (DE),A
	; INC DE
	; INC HL
	JR DECODE_CANAL
	.NO_INSTRUMENTO
	BIT 2,B
	JR Z,NO_ENVOLVENTE
	LD A,11000100B ;CODIGO ENVOLVENTE
	LD (DE),A
	INC DE
	INC HL
	LDI
	; LD A,(HL)
	; LD (DE),A
	; INC DE
	; INC HL
	JR DECODE_CANAL
	.NO_ENVOLVENTE
	BIT 1,B
	JR Z,NO_MODIFICA
	LD A,11000010B ;CODIGO EFECTO
	LD (DE),A
	INC HL
	INC DE
	LD A,(HL)
	CALL GETLEN
	.NO_MODIFICA
	LD (DE),A
	INC DE
	XOR A
	DJNZ NO_MODIFICA
	OR 0x81 ; SET 7,A ; SET 0,A
	LD (DE),A
	INC DE
	INC HL
	RET ;** JR DECODE_CANAL
	.FIN_DEC_CANAL
	OR 0x80 ; SET 7,A
	LD (DE),A
	INC DE
	RET
	.GETLEN
	LD B,A
	AND 00111111B
	PUSH AF
	LD A,B
	AND 11000000B
	RLCA
	RLCA
	INC A
	LD B,A
	LD A,10000000B
	.DCBC0
	RLCA
	DJNZ DCBC0
	LD B,A
	POP AF
	RET
	;PLAY _______________________________
	.PLAY
	LD HL,INTERR ;PLAY BIT 1 ON?
	BIT 1,(HL)
	RET Z
	;TEMPO
	LD HL,TTEMPO ;CONTADOR TEMPO
	INC (HL)
	LD A,(TEMPO)
	CP (HL)
	JR NZ,PAUTAS
	LD (HL),0
	;INTERPRETA
	LD IY,PSG_REG
	LD IX,PUNTERO_A
	LD BC,PSG_REG+8
	CALL LOCALIZA_NOTA
	LD IY,PSG_REG+2
	LD IX,PUNTERO_B
	LD BC,PSG_REG+9
	CALL LOCALIZA_NOTA
	LD IY,PSG_REG+4
	LD IX,PUNTERO_C
	LD BC,PSG_REG+10
	CALL LOCALIZA_NOTA
	LD IX,PUNTERO_P ;EL CANAL DE EFECTOS ENMASCARA OTRO CANAL
	CALL LOCALIZA_EFECTO
	;PAUTAS
	.PAUTAS
	LD IY,PSG_REG+0
	LD IX,PUNTERO_P_A
	LD HL,PSG_REG+8
	CALL PAUTA ;PAUTA CANAL A
	LD IY,PSG_REG+2
	LD IX,PUNTERO_P_B
	LD HL,PSG_REG+9
	CALL PAUTA ;PAUTA CANAL B
	LD IY,PSG_REG+4
	LD IX,PUNTERO_P_C
	LD HL,PSG_REG+10
	JP PAUTA ;PAUTA CANAL C
	;LOCALIZA NOTA CANAL A
	;IN (PUNTERO_A)
	;LOCALIZA NOTA CANAL A
	;IN (PUNTERO_A)
	.LOCALIZA_NOTA
	LD L,(IX+PUNTERO_A-PUNTERO_A) ;HL=(PUNTERO_A_C_B)
	LD H,(IX+PUNTERO_A-PUNTERO_A+1)
	LD A,(HL)
	AND 11000000B ;COMANDO?
	CP 11000000B
	JR NZ,LNJP0
	;BIT(0)=INSTRUMENTO
	.COMANDOS
	LD A,(HL)
	BIT 0,A ;INSTRUMENTO
	JR Z,COM_EFECTO
	INC HL
	LD A,(HL) ;N� DE PAUTA
	INC HL
	LD E,(HL)
	PUSH HL ;;TEMPO ******************
	LD HL,TEMPO
	BIT 5,E
	JR Z,NO_DEC_TEMPO
	DEC (HL)
	.NO_DEC_TEMPO
	BIT 6,E
	JR Z,NO_INC_TEMPO
	INC (HL)
	.NO_INC_TEMPO
	RES 5,E ;SIEMPRE RESETEA LOS BITS DE TEMPO
	RES 6,E
	POP HL
	LD (IX+VOL_INST_A-PUNTERO_A),E ;REGISTRO DEL VOLUMEN RELATIVO
	INC HL
	LD (IX+PUNTERO_A-PUNTERO_A),L
	LD (IX+PUNTERO_A-PUNTERO_A+1),H
	LD HL,TABLA_PAUTAS
	CALL EXT_WORD
	LD (IX+PUNTERO_P_A0-PUNTERO_A),E
	LD (IX+PUNTERO_P_A0-PUNTERO_A+1),D
	LD (IX+PUNTERO_P_A-PUNTERO_A),E
	LD (IX+PUNTERO_P_A-PUNTERO_A+1),D
	LD L,C
	LD H,B
	RES 4,(HL) ;APAGA EFECTO ENVOLVENTE
	XOR A
	LD (PSG_REG_SEC+13),A
	LD (PSG_REG+13),A
	;LD (ENVOLVENTE_BACK),A ;08.13 / RESETEA EL BACKUP DE LA ENVOLVENTE
	JR LOCALIZA_NOTA
	.COM_EFECTO
	BIT 1,A ;EFECTO DE SONIDO
	JR Z,COM_ENVOLVENTE
	INC HL
	LD A,(HL)
	INC HL
	LD (IX+PUNTERO_A-PUNTERO_A),L
	LD (IX+PUNTERO_A-PUNTERO_A+1),H
	JP INICIA_SONIDO
	.COM_ENVOLVENTE
	BIT 2,A
	RET Z ;IGNORA - ERROR
	INC HL
	LD A,(HL) ;CARGA CODIGO DE ENVOLVENTE
	LD (ENVOLVENTE),A
	INC HL
	LD (IX+PUNTERO_A-PUNTERO_A),L
	LD (IX+PUNTERO_A-PUNTERO_A+1),H
	LD L,C
	LD H,B
	LD (HL),00010000B ;ENCIENDE EFECTO ENVOLVENTE
	JR LOCALIZA_NOTA
	.LNJP0
	LD A,(HL)
	INC HL
	BIT 7,A
	JR Z,NO_FIN_CANAL_A ;
	BIT 0,A
	JR Z,FIN_CANAL_A
	.FIN_NOTA_A
	LD E,(IX+CANAL_A-PUNTERO_A)
	LD D,(IX+CANAL_A-PUNTERO_A+1) ;PUNTERO BUFFER AL INICIO
	LD (IX+PUNTERO_A-PUNTERO_A),E
	LD (IX+PUNTERO_A-PUNTERO_A+1),D
	LD L,(IX+PUNTERO_DECA-PUNTERO_A) ;CARGA PUNTERO DECODER
	LD H,(IX+PUNTERO_DECA-PUNTERO_A+1)
	PUSH BC
	CALL DECODE_CANAL ;DECODIFICA CANAL
	POP BC
	LD (IX+PUNTERO_DECA-PUNTERO_A),L ;GUARDA PUNTERO DECODER
	LD (IX+PUNTERO_DECA-PUNTERO_A+1),H
	JP LOCALIZA_NOTA
	.FIN_CANAL_A
	LD HL,INTERR ;LOOP?
	BIT 4,(HL)
	JR NZ,FCA_CONT
	POP AF
	JP PLAYER_OFF
	.FCA_CONT
	LD L,(IX+PUNTERO_L_DECA-PUNTERO_A) ;CARGA PUNTERO INICIAL DECODER
	LD H,(IX+PUNTERO_L_DECA-PUNTERO_A+1)
	LD (IX+PUNTERO_DECA-PUNTERO_A),L
	LD (IX+PUNTERO_DECA-PUNTERO_A+1),H
	JR FIN_NOTA_A
	.NO_FIN_CANAL_A
	LD (IX+PUNTERO_A-PUNTERO_A),L ;(PUNTERO_A_B_C)=HL GUARDA PUNTERO
	LD (IX+PUNTERO_A-PUNTERO_A+1),H
	AND A ;NO REPRODUCE NOTA SI NOTA=0
	JR Z,FIN_RUTINA
	BIT 6,A ;SILENCIO?
	JR Z,NO_SILENCIO_A
	LD A,(BC)
	AND 00010000B
	JR NZ,SILENCIO_ENVOLVENTE
	XOR A
	LD (BC),A ;RESET VOLUMEN DEL CORRESPODIENTE CHIP
	LD (IY+0),A
	LD (IY+1),A
	RET
	.SILENCIO_ENVOLVENTE
	LD A,0xFF
	LD (PSG_REG+11),A
	LD (PSG_REG+12),A
	XOR A
	LD (PSG_REG+13),A
	LD (IY+0),A
	LD (IY+1),A
	RET
	.NO_SILENCIO_A
	LD (IX+REG_NOTA_A-PUNTERO_A),A ;REGISTRO DE LA NOTA DEL CANAL
	CALL NOTA ;REPRODUCE NOTA
	LD L,(IX+PUNTERO_P_A0-PUNTERO_A) ;HL=(PUNTERO_P_A0) RESETEA PAUTA
	LD H,(IX+PUNTERO_P_A0-PUNTERO_A+1)
	LD (IX+PUNTERO_P_A-PUNTERO_A),L ;(PUNTERO_P_A)=HL
	LD (IX+PUNTERO_P_A-PUNTERO_A+1),H
	.FIN_RUTINA
	RET
	;LOCALIZA EFECTO
	;IN HL=(PUNTERO_P)
	.LOCALIZA_EFECTO
	LD L,(IX+0) ;HL=(PUNTERO_P)
	LD H,(IX+1)
	LD A,(HL)
	CP 11000010B
	JR NZ,LEJP0
	INC HL
	LD A,(HL)
	INC HL
	LD (IX+00),L
	LD (IX+01),H
	JP INICIA_SONIDO
	.LEJP0
	INC HL
	BIT 7,A
	JR Z,NO_FIN_CANAL_P ;
	BIT 0,A
	JR Z,FIN_CANAL_P
	.FIN_NOTA_P
	LD DE,(CANAL_P)
	LD (IX+0),E
	LD (IX+1),D
	LD HL,(PUNTERO_DECP) ;CARGA PUNTERO DECODER
	PUSH BC
	CALL DECODE_CANAL ;DECODIFICA CANAL
	POP BC
	LD (PUNTERO_DECP),HL ;GUARDA PUNTERO DECODER
	JP LOCALIZA_EFECTO
	.FIN_CANAL_P
	LD HL,(PUNTERO_L_DECP) ;CARGA PUNTERO INICIAL DECODER
	LD (PUNTERO_DECP),HL
	JR FIN_NOTA_P
	.NO_FIN_CANAL_P
	LD (IX+0),L ;(PUNTERO_A_B_C)=HL GUARDA PUNTERO
	LD (IX+1),H
	RET
	; PAUTA DE LOS 3 CANALES
	; .IN(IX):PUNTERO DE LA PAUTA
	; (HL):REGISTRO DE VOLUMEN
	; (IY):REGISTROS DE FRECUENCIA
	; FORMATO PAUTA
	; 7 6 5 4 3-0 3-0
	; BYTE 1 [LOOP|OCT-1|OCT+1|ORNMT|VOL] - BYTE 2 [ | | | |PITCH/NOTA]
	.PAUTA
	BIT 4,(HL) ;SI LA ENVOLVENTE ESTA ACTIVADA NO ACTUA PAUTA
	RET NZ
	LD A,(IY+0)
	LD B,(IY+1)
	OR B
	RET Z
	PUSH HL
	.PCAJP4
	LD L,(IX+0)
	LD H,(IX+1)
	LD A,(HL)
	BIT 7,A ;LOOP / EL RESTO DE BITS NO AFECTAN
	JR Z,PCAJP0
	AND 00011111B ;M�XIMO LOOP PAUTA (0,32)X2!!!-> PARA ORNAMENTOS
	RLCA ;X2
	LD D,0
	LD E,A
	SBC HL,DE
	LD A,(HL)
	.PCAJP0
	BIT 6,A ;OCTAVA -1
	JR Z,PCAJP1
	LD E,(IY+0)
	LD D,(IY+1)
	AND A
	RRC D
	RR E
	LD (IY+0),E
	LD (IY+1),D
	JR PCAJP2
	.PCAJP1
	BIT 5,A ;OCTAVA +1
	JR Z,PCAJP2
	LD E,(IY+0)
	LD D,(IY+1)
	AND A
	RLC E
	RL D
	LD (IY+0),E
	LD (IY+1),D
	.PCAJP2
	LD A,(HL)
	BIT 4,A
	JR NZ,PCAJP6 ;ORNAMENTOS SELECCIONADOS
	INC HL ;______________________ FUNCION PITCH DE FRECUENCIA__________________
	PUSH HL
	LD E,A
	LD A,(HL) ;PITCH DE FRECUENCIA
	LD L,A
	AND A
	LD A,E
	JR Z,ORNMJP1
	LD A,(IY+0) ;SI LA FRECUENCIA ES 0 NO HAY PITCH
	ADD A,(IY+1)
	AND A
	LD A,E
	JR Z,ORNMJP1
	BIT 7,L
	JR Z,ORNNEG
	LD H,0xFF
	JR PCAJP3
	.ORNNEG
	LD H,0
	.PCAJP3
	LD E,(IY+0)
	LD D,(IY+1)
	ADC HL,DE
	LD (IY+0),L
	LD (IY+1),H
	JR ORNMJP1
	.PCAJP6
	INC HL ;______________________ FUNCION ORNAMENTOS__________________
	PUSH HL
	PUSH AF
	LD A,(IX+REG_NOTA_A-PUNTERO_P_A) ;RECUPERA REGISTRO DE NOTA EN EL CANAL
	LD E,(HL) ;
	ADC E ;+- NOTA
	CALL TABLA_NOTAS
	POP AF
	.ORNMJP1
	POP HL
	INC HL
	LD (IX+0),L
	LD (IX+1),H
	.PCAJP5
	POP HL
	LD B,(IX+VOL_INST_A-PUNTERO_P_A) ;VOLUMEN RELATIVO
	ADD B
	JP P,PCAJP7
	LD A,1 ;NO SE EXTIGUE EL VOLUMEN
	.PCAJP7
	AND 00001111B ;VOLUMEN FINAL MODULADO
	LD (HL),A
	RET
	;NOTA - REPRODUCE UNA NOTA
	;IN (A)=CODIGO DE LA NOTA
	; (IY)=REGISTROS DE FRECUENCIA
	.NOTA
	LD L,C
	LD H,B
	BIT 4,(HL)
	LD B,A
	JR NZ,EVOLVENTES
	LD A,B
	.TABLA_NOTAS
	LD HL,DATOS_NOTAS ;BUSCA FRECUENCIA
	CALL EXT_WORD
	LD (IY+0),E
	LD (IY+1),D
	RET
	;IN (A)=CODIGO DE LA ENVOLVENTE
	; (IY)=REGISTRO DE FRECUENCIA
	.EVOLVENTES
	LD HL,DATOS_NOTAS
	;SUB 12
	RLCA ;X2
	LD D,0
	LD E,A
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	PUSH DE
	LD A,(ENVOLVENTE) ;FRECUENCIA DEL CANAL ON/OFF
	RRA
	JR NC,FRECUENCIA_OFF
	LD (IY+0),E
	LD (IY+1),D
	JR CONT_ENV
	.FRECUENCIA_OFF
	LD DE,0x0000
	LD (IY+0),E
	LD (IY+1),D
	;CALCULO DEL RATIO (OCTAVA ARRIBA)
	.CONT_ENV
	POP DE
	PUSH AF
	PUSH BC
	AND 00000011B
	LD B,A
	;INC B
	;AND A ;1/2
	RR D
	RR E
	.CRTBC0
	;AND A ;1/4 - 1/8 - 1/16
	RR D
	RR E
	DJNZ CRTBC0
	LD A,E
	LD (PSG_REG+11),A
	LD A,D
	AND 00000011B
	LD (PSG_REG+12),A
	POP BC
	POP AF ;SELECCION FORMA DE ENVOLVENTE
	RRA
	AND 00000110B ;0x08,0x0A,0x0C,0x0E
	ADD 8
	LD (PSG_REG+13),A
	LD (ENVOLVENTE_BACK),A
	RET
	;EXTRAE UN WORD DE UNA TABLA
	;.IN(HL)=DIRECCION TABLA
	; (A)= POSICION
	;OUT(DE)=WORD
	.EXT_WORD
	LD D,0
	RLCA
	LD E,A
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	RET
	;TABLA DE DATOS DEL SELECTOR DEL CANAL DE EFECTOS DE RITMO
	.TABLA_DATOS_CANAL_SFX
	defw SELECT_CANAL_A,SELECT_CANAL_B,SELECT_CANAL_C
	;BYTE 0:SFX_L
	;BYTE 1:SFX_H
	;BYTE 2:SFX_V
	;BYTE 3:SFX_MIX
	.SELECT_CANAL_A
	defw PSG_REG_SEC+0, PSG_REG_SEC+1, PSG_REG_SEC+8
	defb 10110001B
	.SELECT_CANAL_B
	defw PSG_REG_SEC+2, PSG_REG_SEC+3, PSG_REG_SEC+9
	defb 10101010B
	.SELECT_CANAL_C
	defw PSG_REG_SEC+4, PSG_REG_SEC+5, PSG_REG_SEC+10
	defb 10011100B
	;_______________________________
	.INTERR
	defb 0 ;INTERRUPTORES 1=ON 0=OFF
	;BIT 0=CARGA CANCION ON/OFF
	;BIT 1=PLAYER ON/OFF
	;BIT 2=EFECTOS ON/OFF
	;BIT 3=SFX ON/OFF
	;BIT 4=LOOP
	;MUSICA **** EL ORDEN DE LAS VARIABLES ES FIJO ******
	.SONG defb 0 ;DBN� DE CANCION
	.TEMPO defb 0 ;DB TEMPO
	.TTEMPO defb 0 ;DB CONTADOR TEMPO
	.PUNTERO_A defw 0 ;DW PUNTERO DEL CANAL A
	.PUNTERO_B defw 0 ;DW PUNTERO DEL CANAL B
	.PUNTERO_C defw 0 ;DW PUNTERO DEL CANAL C
	.CANAL_A defw 0 ;DW DIRECION DE INICIO DE LA MUSICA A
	.CANAL_B defw 0 ;DW DIRECION DE INICIO DE LA MUSICA B
	.CANAL_C defw 0 ;DW DIRECION DE INICIO DE LA MUSICA C
	.PUNTERO_P_A defw 0 ;DW PUNTERO PAUTA CANAL A
	.PUNTERO_P_B defw 0 ;DW PUNTERO PAUTA CANAL B
	.PUNTERO_P_C defw 0 ;DW PUNTERO PAUTA CANAL C
	.PUNTERO_P_A0 defw 0 ;DW INI PUNTERO PAUTA CANAL A
	.PUNTERO_P_B0 defw 0 ;DW INI PUNTERO PAUTA CANAL B
	.PUNTERO_P_C0 defw 0 ;DW INI PUNTERO PAUTA CANAL C
	.PUNTERO_P_DECA defw 0 ;DW PUNTERO DE INICIO DEL DECODER CANAL A
	.PUNTERO_P_DECB defw 0 ;DW PUNTERO DE INICIO DEL DECODER CANAL B
	.PUNTERO_P_DECC defw 0 ;DW PUNTERO DE INICIO DEL DECODER CANAL C
	.PUNTERO_DECA defw 0 ;DW PUNTERO DECODER CANAL A
	.PUNTERO_DECB defw 0 ;DW PUNTERO DECODER CANAL B
	.PUNTERO_DECC defw 0 ;DW PUNTERO DECODER CANAL C
	.PUNTERO_EFECTO defw 0 ;DW PUNTERO DEL SONIDO QUE SE REPRODUCE
	.REG_NOTA_A defb 0 ;DB REGISTRO DE LA NOTA EN EL CANAL A
	.VOL_INST_A defb 0 ;DB VOLUMEN RELATIVO DEL INSTRUMENTO DEL CANAL A
	.REG_NOTA_B defb 0 ;DB REGISTRO DE LA NOTA EN EL CANAL B
	.VOL_INST_B defb 0 ;DB VOLUMEN RELATIVO DEL INSTRUMENTO DEL CANAL B ;VACIO
	.REG_NOTA_C defb 0 ;DB REGISTRO DE LA NOTA EN EL CANAL C
	.VOL_INST_C defb 0 ;DB VOLUMEN RELATIVO DEL INSTRUMENTO DEL CANAL C
	.PUNTERO_L_DECA defw 0 ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL A
	.PUNTERO_L_DECB defw 0 ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL B
	.PUNTERO_L_DECC defw 0 ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL C
	;CANAL DE EFECTOS DE RITMO - ENMASCARA OTRO CANAL
	.PUNTERO_P defw 0 ;DW PUNTERO DEL CANAL EFECTOS
	.CANAL_P defw 0 ;DW DIRECION DE INICIO DE LOS EFECTOS
	.PUNTERO_P_DECP defw 0 ;DW PUNTERO DE INICIO DEL DECODER CANAL P
	.PUNTERO_DECP defw 0 ;DW PUNTERO DECODER CANAL P
	.PUNTERO_L_DECP defw 0 ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL P
	;SELECT_CANAL_P defb INTERR+0x36 ;DB SELECCION DE CANAL DE EFECTOS DE RITMO
	.SFX_L defw 0 ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO BAJO
	.SFX_H defw 0 ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO ALTO
	.SFX_V defw 0 ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO VOLUMEN
	.SFX_MIX defw 0 ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO MIXER
	;EFECTOS DE SONIDO
	.N_SONIDO defb 0 ;DB : NUMERO DE SONIDO
	.PUNTERO_SONIDO defw 0 ;DW : PUNTERO DEL SONIDO QUE SE REPRODUCE
	.EFECTO_REGS defw 0
	.SONIDO_REGS defw SELECT_CANAL_B ; na_th_an :: Percussion channel is fixed to 1
	;DB (13) BUFFERs DE REGISTROS DEL PSG
	.PSG_REG defs 16
	.PSG_REG_SEC defs 16
	.ENVOLVENTE
	defb 0 ;DB : FORMA DE LA ENVOLVENTE
	;BIT 0 : FRECUENCIA CANAL ON/OFF
	;BIT 1-2 : RATIO
	;BIT 3-3 : FORMA
	.ENVOLVENTE_BACK defb 0 ;.defb BACKUP DE LA FORMA DE LA ENVOLENTE
	.DATOS_NOTAS
	defw 0x0000, 0x0000
	defw 964,910,859,811,766,722,682,644,608,573
	defw 541,511,482,455,430,405,383,361,341,322
	defw 304,287,271,255,241,228,215,203,191,180
	defw 170,161,152,143,135,128,121,114,107,101
	defw 96,90,85,81,76,72,68,64,60,57
	defw 54,51,48,45,43,40,38,36,34,32
	.TABLA_SONG
	defw 0x8C00
	.TABLA_EFECTOS
	defw EFECTO0, EFECTO1, EFECTO2, EFECTO3, EFECTO4, EFECTO5, EFECTO6, EFECTO7
	defw EFECTO8, EFECTO9, EFECTO10, EFECTO11, EFECTO12, EFECTO13, EFECTO14

._title_screen
	call	_blackout
	ld	hl,_s_title
	push	hl
	ld	hl,36864	;const
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	ld	hl,1	;const
	call	cpc_ShowTileMap
	ld	a,#(13 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+447
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(14 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+454
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(2 % 256 % 256)
	ld	(__x),a
	ld	a,#(18 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+462
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(5 % 256 % 256)
	ld	(__x),a
	ld	a,#(19 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+491
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,0	;const
	call	_wyz_play_music
.i_276
	ld	hl,10	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_278
	ld	hl,_def_keys
	ld	(__gp_gen),hl
	jp	i_277
.i_278
	ld	hl,11	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_279
	ld	hl,_def_keys_joy
	ld	(__gp_gen),hl
	jp	i_277
.i_279
	jp	i_276
.i_277
	call	_wyz_stop_sound
	._copy_keys_to_extern
	ld hl, (__gp_gen)
	ld de, cpc_KeysData + 12
	ld bc, 24
	ldir
	ret



._main
	call	_wyz_init
	di
	ld hl, 0xC000
	xor a
	ld (hl), a
	ld de, 0xC001
	ld bc, 0x3DFF
	ldir
	ld a, 195
	ld (0x38), a
	ld hl, _isr
	ld (0x39), hl
	jp isr_done
	._isr
	push af
	ld a, (_isr_player_on)
	or a
	jr z, _skip_wyz
	ld a, (isr_c1)
	inc a
	cp 6
	jr c, _skip_wyz
	push hl
	push de
	push bc
	push ix
	push iy
	call WYZ_PLAYER_ISR
	pop iy
	pop ix
	pop bc
	pop de
	pop hl
	xor a
	._skip_wyz
	ld (isr_c1), a
	pop af
	ei
	ret
	.isr_c1
	defb 0
	.isr_done
	ld a, 0x54
	ld bc, 0x7F11
	out (c), c
	out (c), a
	ld	hl,_trpixlutc
	push	hl
	ld	hl,65024	;const
	push	hl
	call	_unpack
	pop	bc
	pop	bc
	call	_blackout
	ld	hl,_my_inks
	push	hl
	call	_pal_set
	pop	bc
	ld	hl,0	;const
	call	cpc_SetMode
	; Horizontal chars (32), CRTC REG #1
	ld b, 0xbc
	ld c, 1 ; REG = 1
	out (c), c
	inc b
	ld c, 32 ; VALUE = 32
	out (c), c
	; Horizontal pos (42), CRTC REG #2
	ld b, 0xbc
	ld c, 2 ; REG = 2
	out (c), c
	inc b
	ld c, 42 ; VALUE = 42
	out (c), c
	; Vertical chars (24), CRTC REG #6
	ld b, 0xbc
	ld c, 6 ; REG = 6
	out (c), c
	inc b
	ld c, 24 ; VALUE = 24
	out (c), c
	ld	hl,_sp_sw+6
	push	hl
	ld	hl,(_sm_cox)
	ld	h,0
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_sp_sw+7
	push	hl
	ld	hl,(_sm_coy)
	ld	h,0
	ld	a,l
	call	l_sxt
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_sp_sw+12
	ld	hl,(_sm_invfunc)
	call	l_pint
	ld	de,_sp_sw+14
	ld	hl,(_sm_updfunc)
	call	l_pint
	ld	hl,_sp_sw
	push	hl
	inc	hl
	inc	hl
	ex	de,hl
	ld	hl,(_sm_sprptr)
	call	l_pint
	call	l_pint_pop
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_282
.i_280
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_282
	ld	a,(_gpit)
	cp	#(4 % 256)
	jp	z,i_281
	jp	nc,i_281
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,12
	add	hl,bc
	push	hl
	ld	hl,cpc_PutSpTileMap4x8
	call	l_pint_pop
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,14
	add	hl,bc
	push	hl
	ld	hl,cpc_PutTrSp4x8TileMap2b
	call	l_pint_pop
	jp	i_280
.i_281
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_285
.i_283
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_285
	ld	a,(_gpit)
	cp	#(7 % 256)
	jp	z,i_284
	jp	nc,i_284
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,6
	add	hl,bc
	push	hl
	pop	de
	xor	a
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,7
	add	hl,bc
	push	hl
	pop	de
	xor	a
	ld	(de),a
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,12
	add	hl,bc
	push	hl
	ld	hl,cpc_PutSpTileMap4x8
	call	l_pint_pop
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,14
	add	hl,bc
	push	hl
	ld	hl,cpc_PutTrSp4x8TileMap2b
	call	l_pint_pop
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sp_sw+1+1
	push	hl
	ld	hl,_sprite_19_a
	call	l_pint_pop
	call	l_pint_pop
	jp	i_283
.i_284
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_288
.i_286
	ld	hl,(_gpit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_gpit),a
.i_288
	ld	a,(_gpit)
	cp	#(7 % 256)
	jp	z,i_287
	jp	nc,i_287
	ld	de,_spr_on
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,10
	add	hl,bc
	ld	(hl),#(2 % 256 % 256)
	ld	hl,_sp_sw
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,11
	add	hl,bc
	ld	(hl),#(8 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_286
.i_287
	ei
.i_289
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_level),a
	call	_title_screen
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_warp_to_level),a
.i_291
	call	_blackout_area
	call	_invalidate_viewport
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,_my_inks
	push	hl
	call	_pal_set
	pop	bc
	ld	hl,(_level_str)
	ld	bc,7
	add	hl,bc
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,49
	add	hl,de
	pop	de
	ld	a,l
	ld	(de),a
	ld	a,#(12 % 256 % 256)
	ld	(__x),a
	ld	a,#(11 % 256 % 256)
	ld	(__y),a
	ld	hl,(_level_str)
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	hl,_level_names
	push	hl
	ld	hl,(_level)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,1	;const
	call	_wyz_play_sound
	ld	hl,100	;const
	push	hl
	call	_espera_activa
	pop	bc
	call	_blackout_area
	call	_invalidate_viewport
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,(_level)
	ld	h,0
	push	hl
	call	_prepare_level
	pop	bc
	; Makes debugging easier
	._game_loop_init
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_playing),a
	call	_player_init
	ld	a,#(0 % 256 % 256)
	ld	(_maincounter),a
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	ld	de,13
	call	l_mult
	pop	de
	add	hl,de
	ld	bc,12
	add	hl,bc
	ld	l,(hl)
	ld	h,0
	call	_wyz_play_music
	xor a
	ld (_f_0), a
	ld (_f_1), a
	inc a
	ld (_f_3), a
	ld a, 5
	ld (_f_2), a
	ld	hl,_level_pal
	push	hl
	ld	hl,(_level)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	push	hl
	call	_pal_set
	pop	bc
	ld	de,_l_is_classic
	ld	hl,(_level)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(_c_is_classic),a
	ld	a,(_level)
	cp	#(4 % 256)
	jp	nz,i_293
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_ammo),a
.i_293
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_half_life),a
	ld	(_success),a
	ld	a,l
	ld	(_p_killme),a
	ld	hl,255 % 256	;const
	ld	a,l
	ld	(_killed_old),a
	ld	(_life_old),a
	ld	h,0
	ld	a,l
	ld	(_keys_old),a
	ld	(_objs_old),a
	ld	a,#(255 % 256 % 256)
	ld	(_ammo_old),a
	ld	hl,255 % 256	;const
	ld	a,l
	ld	(_o_pant),a
.i_294
	ld	hl,(_playing)
	ld	a,l
	and	a
	jp	z,i_295
	; Makes debugging easier
	._game_loop_do
	ld	a,#(1 % 256 % 256)
	ld	(_p_kill_amt),a
	ld	de,(_o_pant)
	ld	d,0
	ld	hl,(_n_pant)
	ld	h,d
	call	l_ne
	jp	nc,i_296
	call	_draw_scr
	ld	a,((_n_pant))
	ld	(_o_pant),a
.i_296
	ld	de,(_p_objs)
	ld	d,0
	ld	hl,(_objs_old)
	ld	h,d
	call	l_ne
	jp	nc,i_297
	call	_draw_objs
	ld	a,((_p_objs))
	ld	(_objs_old),a
.i_297
	ld	de,(_p_life)
	ld	d,0
	ld	hl,(_life_old)
	ld	h,d
	call	l_ne
	jp	nc,i_298
	ld	a,#(3 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_p_life)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ld	a,((_p_life))
	ld	(_life_old),a
.i_298
	ld	de,(_p_keys)
	ld	d,0
	ld	hl,(_keys_old)
	ld	h,d
	call	l_ne
	jp	nc,i_299
	ld	a,#(22 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_p_keys)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ld	a,((_p_keys))
	ld	(_keys_old),a
.i_299
	ld	de,(_p_ammo)
	ld	d,0
	ld	hl,(_ammo_old)
	ld	h,d
	call	l_ne
	jp	nc,i_300
	ld	a,#(8 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_p_ammo)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ld	a,((_p_ammo))
	ld	(_ammo_old),a
.i_300
	ld	hl,_maincounter
	ld	a,(hl)
	inc	(hl)
	ld	hl,(_half_life)
	ld	h,0
	call	l_lneg
	ld	hl,0	;const
	rl	l
	ld	a,l
	ld	(_half_life),a
	call	_player_move
	call	_enems_move
	ld	a,(_p_killme)
	and	a
	jp	z,i_301
	ld	a,(_p_life)
	and	a
	jp	z,i_302
	ld	hl,(_p_killme)
	ld	h,0
	push	hl
	call	_player_kill
	pop	bc
	jp	i_303
.i_302
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
.i_303
.i_301
	call	_bullets_move
	ld	de,(_o_pant)
	ld	d,0
	ld	hl,(_n_pant)
	ld	h,d
	call	l_eq
	jp	nc,i_304
	ld	hl,1	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
.i_304
	ld	a,(_p_estado)
	cp	#(2 % 256)
	jp	nz,i_305
	ld	hl,_p_ct_estado
	ld	a,(hl)
	dec	(hl)
	ld	a,(_p_ct_estado)
	and	a
	jp	nz,i_306
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_estado),a
.i_306
.i_305
	call	_hotspots_do
	ld	hl,6	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_307
.i_308
	ld	hl,6	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	nz,i_308
.i_309
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_isr_player_on),a
	call	_clear_sprites
	call	_pause_screen
.i_310
	ld	hl,6	;const
	call	cpc_TestKey
	call	l_lneg
	jp	c,i_310
.i_311
.i_312
	ld	hl,6	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	nz,i_312
.i_313
	call	_draw_scr
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_isr_player_on),a
.i_307
	ld	hl,7	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_314
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
.i_314
	ld	hl,8	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_316
	ld	hl,9	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jr	nz,i_317_i_316
.i_316
	jp	i_315
.i_317_i_316
	ld	a,#(0 % 256 % 256)
	ld	(_playing),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_success),a
.i_315
	ld	a,(_gpy)
	cp	#(0 % 256)
	jp	nz,i_319
	ld	hl,(_p_vy)
	ld	de,0	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_319
	ld	de,(_n_pant)
	ld	d,0
	ld	hl,(_level_data)
	ld	h,d
	call	l_uge
	jr	c,i_320_i_319
.i_319
	jp	i_318
.i_320_i_319
	ld	de,(_n_pant)
	ld	d,0
	ld	hl,(_level_data)
	ld	h,d
	ex	de,hl
	and	a
	sbc	hl,de
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	a,#(144 % 256 % 256)
	ld	(_gpy),a
	ld	hl,9216	;const
	ld	(_p_y),hl
.i_318
	ld	a,(_gpy)
	cp	#(144 % 256)
	jr	z,i_322_uge
	jp	c,i_322
.i_322_uge
	ld	hl,(_p_vy)
	ld	de,0	;const
	ex	de,hl
	call	l_gt
	jr	c,i_323_i_322
.i_322
	jp	i_321
.i_323_i_322
	ld	hl,(_n_pant)
	ld	h,0
	push	hl
	ld	hl,(_level_data)
	ld	h,0
	push	hl
	ld	hl,(_level_data+1)
	ld	h,0
	dec	hl
	pop	de
	call	l_mult
	pop	de
	call	l_ult
	jp	nc,i_324
	ld	de,(_n_pant)
	ld	d,0
	ld	hl,(_level_data)
	ld	h,d
	add	hl,de
	ld	a,l
	ld	(_n_pant),a
	ld	hl,0	;const
	ld	(_p_y),hl
	ld	a,l
	ld	(_gpy),a
	ld	hl,(_p_vy)
	ld	de,256	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_325
	ld	hl,256	;const
	ld	(_p_vy),hl
.i_325
.i_324
.i_321
	jp	i_326
	ld	a,#(1 % 256 % 256)
	ld	(_success),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
.i_326
	ld	a,(_c_is_classic)
	and	a
	jp	z,i_328
	ld	a,(_n_pant)
	cp	#(0 % 256)
	jp	nz,i_328
	ld	a,(_f_1)
	cp	#(0 % 256)
	jp	nz,i_328
	ld	a,(_gpy)
	cp	#(96 % 256)
	jp	z,i_328
	jp	nc,i_328
	ld	a,(_p_objs)
	cp	#(5 % 256)
	jr	z,i_329_i_328
.i_328
	jp	i_327
.i_329_i_328
	ld	a,#(1 % 256 % 256)
	ld	(_f_1),a
	ld	hl,_decos_bombs
	ld	(__gp_gen),hl
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_332
.i_330
	ld	hl,(_gpit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_gpit),a
.i_332
	ld	a,(_gpit)
	cp	#(5 % 256)
	jp	z,i_331
	jp	nc,i_331
	ld	hl,(__gp_gen)
	ld	a,(hl)
	ld	(_rda),a
	ld	hl,(__gp_gen)
	inc	hl
	inc	hl
	ld	(__gp_gen),hl
	ld	a,(_rda)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	a,(_rda)
	ld	e,a
	ld	d,0
	ld	hl,15	;const
	call	l_and
	ld	a,l
	ld	(__y),a
	ld	hl,17 % 256	;const
	ld	a,l
	ld	(__t),a
	call	_update_tile
	ld	hl,1	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,14	;const
	call	_wyz_play_sound
	ld	hl,25	;const
	push	hl
	call	_espera_activa
	pop	bc
	jp	i_330
.i_331
	ld	hl,i_1+514
	ld	(__gp_gen),hl
	call	_ingame_text
.i_327
	ld	a,(_f_0)
	and	a
	jp	z,i_333
	ld	a,(_gpx)
	cp	#(64 % 256)
	jp	z,i_335
	jp	nc,i_335
	ld	a,(_gpy)
	cp	#(16 % 256)
	jr	z,i_335_uge
	jp	c,i_335
.i_335_uge
	ld	a,(_gpy)
	cp	#(80 % 256)
	jp	z,i_335
	jr	c,i_336_i_335
.i_335
	jp	i_334
.i_336_i_335
	ld	a,#(0 % 256 % 256)
	ld	(_f_0),a
	ld	hl,0	;const
	call	_wyz_play_sound
	ld	hl,i_1+545
	ld	(__gp_gen),hl
	call	_ingame_text
.i_334
.i_333
	ld	hl,(_level)
	ld	h,0
.i_339
	ld	a,l
	cp	#(0% 256)
	jp	z,i_340
	cp	#(4% 256)
	jp	z,i_341
	cp	#(1% 256)
	jp	z,i_347
	cp	#(7% 256)
	jp	z,i_349
	jp	i_338
.i_340
.i_341
	ld	a,(_n_pant)
	cp	#(18 % 256)
	jp	z,i_343
	ld	a,(_n_pant)
	cp	#(6 % 256)
	jp	nz,i_345
.i_343
	ld	a,(_gpy)
	cp	#(48 % 256)
	jp	z,i_345
	jr	c,i_346_i_345
.i_345
	jp	i_342
.i_346_i_345
	call	_win_level
.i_342
	jp	i_338
.i_347
	ld	hl,(_f_2)
	ld	h,0
	ld	a,h
	or	l
	call	z,_win_level
.i_348
	jp	i_338
.i_349
	ld	a,(_n_pant)
	cp	#(5 % 256)
	jp	nz,i_351
	ld	a,(_p_objs)
	and	a
	jp	z,i_351
	ld	a,(_gpy)
	cp	#(48 % 256)
	jp	z,i_351
	jp	nc,i_351
	ld	a,(_gpx)
	cp	#(80 % 256)
	jp	z,i_351
	jr	c,i_352_i_351
.i_351
	jp	i_350
.i_352_i_351
	call	_win_level
.i_350
.i_338
	jp	i_294
.i_295
	call	_wyz_stop_sound
	ld	hl,i_1+576
	ld	(__gp_gen),hl
	call	_ingame_text
	ld	hl,(_success)
	ld	a,l
	and	a
	jp	z,i_353
	call	_zone_clear
	ld	a,(_warp_to_level)
	and	a
	jp	nz,i_354
	ld	hl,(_level)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_level),a
.i_354
	ld	a,(_level)
	ld	e,a
	ld	d,0
	ld	hl,8	;const
	call	l_uge
	jp	nc,i_355
	call	_game_ending
	jp	i_292
.i_355
	jp	i_356
.i_353
	call	_game_over
	ld	a,(_level)
	and	a
	jp	z,i_357
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(12 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+607
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+619
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(14 % 256 % 256)
	ld	(__y),a
	ld	hl,i_1+632
	ld	(__gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(15 % 256 % 256)
	ld	(__y),a
	ld	hl,(_spacer)
	ld	(__gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	_cpc_UpdateNow
	pop	bc
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_rda),a
.i_358
	ld	hl,11	;const
	call	cpc_TestKey
	call	l_lneg
	jp	nc,i_359
	ld	hl,10	;const
	call	cpc_TestKey
	ld	a,h
	or	l
	jp	z,i_360
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_rda),a
	jp	i_359
.i_360
	jp	i_358
.i_359
	ld	hl,(_rda)
	ld	a,l
	and	a
	jp	nz,i_291
.i_361
.i_357
	call	_wyz_stop_sound
	jp	i_292
.i_356
	jp	i_291
.i_292
	call	_clear_sprites
	ld	hl,_my_inks
	push	hl
	call	_pal_set
	pop	bc
	jp	i_289
.i_290
	ret


;	SECTION	text

.i_1
	defm	"            "
	defb	0

	defm	"LEVEL 0X"
	defb	0

	defm	" FIRST BOOT!"
	defb	0

	defm	" GET'EM SAFE"
	defb	0

	defm	"EVIL COMPUTER"
	defb	0

	defm	"NIGHT MISSION"
	defb	0

	defm	" PEACE MAKER"
	defb	0

	defm	" GHOST ARMY!"
	defb	0

	defm	" GHOST NIGHT"
	defb	0

	defm	"BIKE RENEWAL!"
	defb	0

	defm	"  MAKE YOUR WAY TO THE GOAL!"
	defb	0

	defm	"      RESCUE 5 HOSTAGES"
	defb	0

	defm	" REACH THE GOAL WITH NO AMMO!"
	defb	0

	defm	"  BLAST THE BIKE WITH A BOMB"
	defb	0

	defm	"CONGRATS SARGENT!!"
	defb	0

	defm	"YOU CAN NOW GO TO WAR KIDDO"
	defb	0

	defm	" GAME UNDER "
	defb	0

	defm	"   PAUSED   "
	defb	0

	defm	" ZONE CLEAR "
	defb	0

	defm	" SET 5 BOMBS IN EVIL COMPUTER"
	defb	0

	defm	"BOMBS ARE SET! RETURN TO BASE!"
	defm	""
	defb	0

	defm	"  SET BOMBS IN EVIL COMPUTER"
	defb	0

	defm	" KILL GHOSTS TO COLLECT KEYS!"
	defb	0

	defm	"1 POQA"
	defb	0

	defm	"2 STICK"
	defb	0

	defm	"DEDICADO A IGNACIO Y PAQUITO"
	defb	0

	defm	"@ 2020 THE MOJON TWINS"
	defb	0

	defm	"  DONE! NOW GO BACK TO BASE!  "
	defm	""
	defb	0

	defm	" HALF NEW MOTORBIKE FOR SALE! "
	defm	""
	defb	0

	defm	"                              "
	defm	""
	defb	0

	defm	" CONTINUE? "
	defb	0

	defm	"   1   YES  "
	defb	0

	defm	"   2   NO   "
	defb	0

;	SECTION	code



; --- Start of Static Variables ---

;	SECTION	bss

.__en_t	defs	1
.__en_x	defs	1
.__en_y	defs	1
._isr_player_on	defs	1
._bspr_it	defs	1
._gpen_cx	defs	1
._gpen_cy	defs	1
.__en_x1	defs	1
.__en_x2	defs	1
.__en_y1	defs	1
.__en_y2	defs	1
.__en_cx	defs	1
.__en_cy	defs	1
._hotspot_x	defs	1
._hotspot_y	defs	1
._half_life	defs	1
._map_pointer	defs	2
.__en_mx	defs	1
.__en_my	defs	1
._flags	defs	2
._p_facing	defs	1
._p_frame	defs	1
._pregotten	defs	1
._hit_h	defs	1
._p_kill_amt	defs	1
._hit_v	defs	1
._killed_old	defs	1
._gpaux	defs	1
._active	defs	1
._p_ct_estado	defs	1
._level	defs	1
._c_screen_address	defs	2
._hotspot_destroy	defs	1
._x0	defs	1
._y0	defs	1
._x1	defs	1
._y1	defs	1
.__n	defs	1
.__t	defs	1
.__x	defs	1
.__y	defs	1
.__en_an_vx	defs	2
.__en_an_vy	defs	2
._life_old	defs	1
.__gp_gen	defs	2
._gen_pt	defs	2
._ptgmx	defs	2
._ptgmy	defs	2
.__b_x	defs	1
.__b_y	defs	1
._enoffs	defs	1
._b_it	defs	1
._p_estado	defs	1
.__b_estado	defs	1
._p_killed	defs	1
._p_ammo	defs	1
._gpen_x	defs	1
._gpen_y	defs	1
._pad0	defs	1
._p_killme	defs	1
._n_pant	defs	1
._p_cont_salto	defs	1
._enspit	defs	1
._o_pant	defs	1
._p_life	defs	1
._enit	defs	1
._p_fuel	defs	1
._p_objs	defs	1
._p_gotten	defs	1
._gpcx	defs	1
._gpcy	defs	1
._gpit	defs	1
._p_keys	defs	1
._gpjt	defs	1
._ammo_old	defs	1
._playing	defs	1
._gpox	defs	1
._seed	defs	2
._p_tx	defs	1
._p_ty	defs	1
._asm_int_2	defs	2
._p_vx	defs	2
._p_vy	defs	2
._gpxx	defs	1
.__en_an_x	defs	2
.__en_an_y	defs	2
._gpyy	defs	1
._objs_old	defs	1
._maincounter	defs	1
._ptx1	defs	1
._ptx2	defs	1
._pty1	defs	1
._pty2	defs	1
._asm_number	defs	1
._f_0	defs	1
._f_1	defs	1
._f_2	defs	1
._f_3	defs	1
._at1	defs	1
._at2	defs	1
.__en_life	defs	1
._cx1	defs	1
._cx2	defs	1
._cy1	defs	1
._cy2	defs	1
._p_subframe	defs	1
._blx	defs	1
._bly	defs	1
._gpc	defs	1
._gpd	defs	1
._hit	defs	1
._gpt	defs	1
._rda	defs	1
._rdb	defs	1
._rdc	defs	1
._gpx	defs	1
._gpy	defs	1
._p_x	defs	2
._p_y	defs	2
._rdd	defs	1
._itj	defs	2
._rdn	defs	1
._keys_old	defs	1
._rdt	defs	1
._rdx	defs	1
._rdy	defs	1
._wall_h	defs	1
._enoffsmasi	defs	1
._wall_v	defs	1
._tocado	defs	1
._is_rendering	defs	1
._slevel	defs	1
._asm_int	defs	2
._p_facing_h	defs	1
._c_is_classic	defs	1
.__baddies_pointer	defs	2
._p_facing_v	defs	1
._p_saltando	defs	1
._possee	defs	1
._orig_tile	defs	1
._success	defs	1
._ram_destination	defs	2
._p_disparando	defs	1
.__b_mx	defs	1
.__b_my	defs	1
._ram_address	defs	2
;	SECTION	code



; --- Start of Scope Defns ---

	XDEF	__en_t
	XDEF	__en_x
	XDEF	__en_y
	XDEF	_isr_player_on
	XDEF	_hotspots
	XDEF	_mons_col_sc_x
	XDEF	_mons_col_sc_y
	XDEF	_draw_scr
	XDEF	__bmxo
	XDEF	__bmyo
	XDEF	_prepare_level
	XDEF	_spr_next
	defc	_spr_next	=	58992
	XDEF	_wyz_play_music
	XDEF	_trpixlutc
	LIB	cpc_PrintGphStrXY
	XDEF	_sm_invfunc
	LIB	cpc_WyzConfigurePlayer
	LIB	cpc_PrintGphStrStdXY
	XDEF	_blackout_area
	XDEF	_bspr_it
	LIB	cpc_PutTiles
	XDEF	_sprites
	XDEF	_map_bolts0
	XDEF	_map_bolts1
	XDEF	_map_bolts2
	XDEF	_gpen_cx
	XDEF	_tilanims_do
	XDEF	_gpen_cy
	XDEF	__en_x1
	XDEF	__en_x2
	XDEF	__en_y1
	XDEF	_def_keys
	XDEF	_cortina
	XDEF	__en_y2
	XDEF	_bullets_mx
	defc	_bullets_mx	=	54856
	XDEF	_bullets_my
	defc	_bullets_my	=	54859
	LIB	cpc_PrintGphStrM12X
	XDEF	_sg_submenu
	XDEF	_enems_kill
	XDEF	_enems_load
	XDEF	_en_an_base_frame
	defc	_en_an_base_frame	=	54784
	XDEF	_enems_init
	XDEF	_draw_objs
	XDEF	__en_cx
	XDEF	__en_cy
	XDEF	_wyz_play_sound
	XDEF	_hotspot_x
	XDEF	_hotspot_y
	XDEF	_half_life
	LIB	cpc_WyzInitPlayer
	XDEF	_map_pointer
	LIB	cpc_ShowScrTileMap
	XDEF	__en_mx
	XDEF	__en_my
	LIB	cpc_SetMode
	LIB	cpc_ClrScr
	LIB	cpc_SetModo
	LIB	cpc_PutMaskSpriteTileMap2b
	LIB	cpc_PutTrSpriteTileMap2b
	XDEF	_en_an_state
	defc	_en_an_state	=	54796
	XDEF	_level_briefings
	XDEF	_enems_move
	LIB	cpc_SetInkGphStr
	XDEF	_flags
	XDEF	_en_an_sprid
	defc	_en_an_sprid	=	54793
	XDEF	_p_facing
	XDEF	_invalidate_tile
	XDEF	_p_frame
	XDEF	_enems_pursuers_init
	LIB	cpc_ShowTouchedTiles2
	LIB	cpc_SetTile
	XDEF	_malotes
	LIB	cpc_WyzSetTempo
	LIB	cpc_CollSp
	LIB	cpc_PutMaskSp4x16
	XDEF	_tilanims_add
	XDEF	_pregotten
	XDEF	_hit_h
	XDEF	_blackout
	XDEF	_map_buff
	defc	_map_buff	=	50838
	LIB	cpc_PrintGphStrStd
	XDEF	_p_kill_amt
	XDEF	_hit_v
	XDEF	_killed_old
	XDEF	_gpaux
	XDEF	_time_over
	XDEF	_map_attr
	defc	_map_attr	=	50688
	XDEF	_pal_set
	XDEF	_invalidate_viewport
	XDEF	_active
	XDEF	_l_max_life
	XDEF	_behs0_1
	XDEF	_p_ct_estado
	LIB	cpc_ShowTileMap
	XDEF	_level
	LIB	cpc_PutTile2x8
	XDEF	_c_screen_address
	XDEF	_limit
	XDEF	_decos_moto
	LIB	cpc_ShowScrTileMap2
	LIB	cpc_Uncrunch
	XDEF	_hotspot_destroy
	XDEF	_cpc_UpdateNow
	XDEF	_hotspots_init
	XDEF	_x0
	XDEF	_espera_activa
	XDEF	_y0
	XDEF	_x1
	XDEF	_y1
	LIB	cpc_SpRLM1
	XDEF	_get_resource
	XDEF	__n
	XDEF	_title_screen
	XDEF	_player_kill
	XDEF	__t
	XDEF	_player_init
	XDEF	_wyz_init
	XDEF	_player_hidden
	XDEF	__x
	XDEF	__y
	LIB	cpc_PrintGphStrXY2X
	XDEF	__en_an_vx
	XDEF	__en_an_vy
	LIB	cpc_SpRRM1
	XDEF	_life_old
	XDEF	_level_pal
	XDEF	_sm_sprptr
	LIB	cpc_PrintGphStrXYM1
	XDEF	_tape_load
	LIB	cpc_PutSpriteXOR
	XDEF	_run_fire_script
	LIB	cpc_TestKey
	LIB	cpc_PutSprite
	XDEF	_player_move
	LIB	cpc_PutSpTileMap4x8
	XDEF	_bullets_estado
	defc	_bullets_estado	=	54862
	XDEF	__gp_gen
	LIB	cpc_PutSpTileMap
	LIB	cpc_InitTileMap
	XDEF	_gen_pt
	XDEF	_tilanims_reset
	XDEF	_enems_draw_current
	XDEF	_s_marco
	XDEF	_addsign
	XDEF	_tape_save
	XDEF	_level_str
	XDEF	_sp_sw
	defc	_sp_sw	=	58880
	XDEF	_cm_two_points
	LIB	cpc_TouchTileXY
	LIB	cpc_SetTouchTileXY
	XDEF	_ptgmx
	XDEF	_ptgmy
	XDEF	_qtile
	XDEF	_mem_load
	XDEF	_sprite_17_a
	XDEF	_decos_computer
	XDEF	_warp_to_level
	XDEF	_sprite_18_a
	XDEF	_sprite_19_a
	XREF	_sprite_19_b
	XDEF	_decos_bombs
	LIB	cpc_WyzSetPlayerOff
	XDEF	_spr_x
	defc	_spr_x	=	59013
	XDEF	_beep_fx
	XDEF	_spr_y
	defc	_spr_y	=	59020
	XDEF	__b_x
	LIB	cpc_WyzLoadSong
	XDEF	__b_y
	XDEF	_mem_save
	XDEF	_enoffs
	XDEF	_safe_byte
	defc	_safe_byte	=	51199
	LIB	cpc_PutSpTr
	XDEF	_b_it
	LIB	cpc_DisableFirmware
	LIB	cpc_EnableFirmware
	XDEF	_locks_init
	XDEF	_utaux
	XDEF	__bxo
	XDEF	__byo
	XDEF	_behs
	XDEF	_en_an_rawv
	defc	_en_an_rawv	=	54829
	XDEF	_draw_invalidate_coloured_tile_g
	XDEF	_p_estado
	XDEF	__b_estado
	XDEF	_bullets_fire
	XDEF	_p_killed
	XDEF	_bullets_x
	defc	_bullets_x	=	54850
	XDEF	_bullets_y
	defc	_bullets_y	=	54853
	XDEF	_p_ammo
	XDEF	_gpen_x
	XDEF	_gpen_y
	LIB	cpc_PrintGphStrXYM12X
	LIB	cpc_SetInk
	XDEF	_pad0
	XDEF	__tile_address
	XDEF	_p_killme
	XDEF	_n_pant
	XDEF	_bullets_life
	defc	_bullets_life	=	54865
	XDEF	_def_keys_joy
	LIB	cpc_SetBorder
	LIB	cpc_RLI
	XDEF	_bullets_init
	LIB	cpc_RRI
	LIB	cpc_GetSp
	XDEF	_p_cont_salto
	XDEF	_enspit
	XDEF	_o_pant
	XDEF	_p_life
	XDEF	_enit
	LIB	cpc_SpUpdX
	LIB	cpc_SpUpdY
	LIB	cpc_PutTile4x16
	XDEF	_print_number2
	XDEF	_pause_screen
	XDEF	_p_fuel
	XDEF	_mapa
	XDEF	_main
	XDEF	_draw_coloured_tile
	XDEF	_attr
	LIB	cpc_ResetTouchedTiles
	LIB	cpc_ShowTouchedTiles
	XDEF	_p_objs
	XDEF	_p_gotten
	XDEF	_gpcx
	XDEF	_gpcy
	XDEF	_s_title
	XDEF	_level_names
	XDEF	_gpit
	LIB	cpc_PutMaskSp2x8
	XDEF	_p_keys
	XDEF	_en_an_vx
	defc	_en_an_vx	=	54811
	XDEF	_en_an_vy
	defc	_en_an_vy	=	54817
	LIB	cpc_ScanKeyboard
	XDEF	_bullets_move
	XDEF	_player_calc_bounding_box
	XDEF	_gpjt
	LIB	cpc_SetColour
	XDEF	_ammo_old
	XDEF	_playing
	XDEF	_enems_hotspots0
	XDEF	_enems_hotspots1
	XDEF	_enems_hotspots2
	XDEF	_gpox
	XDEF	_enems_hotspots3
	XDEF	_enems_hotspots4
	XDEF	_sm_updfunc
	XDEF	_rand
	XDEF	_seed
	XDEF	_p_tx
	XDEF	_p_ty
	XDEF	_print_str
	XDEF	_levels
	XDEF	_asm_int_2
	LIB	cpc_DeleteKeys
	XDEF	_player_deplete
	XDEF	_p_vx
	XDEF	_p_vy
	XDEF	_gpxx
	XDEF	__en_an_x
	XDEF	__en_an_y
	LIB	cpc_WyzTestPlayer
	XDEF	_gpyy
	XDEF	_objs_old
	XDEF	_maincounter
	XDEF	_ptx1
	XDEF	_ptx2
	XDEF	_pty1
	XDEF	_pty2
	XDEF	_asm_number
	LIB	cpc_PutMaskSpTileMap2b
	LIB	cpc_PutTrSpTileMap2b
	LIB	cpc_PutORSpTileMap2b
	LIB	cpc_PutSpTileMap2b
	LIB	cpc_PutCpSpTileMap2b
	LIB	cpc_PutTrSp4x8TileMap2b
	LIB	cpc_UpdScr
	LIB	cpc_PutTrSp8x16TileMap2b
	LIB	cpc_PutTrSp8x24TileMap2b
	XDEF	_f_0
	XDEF	_f_1
	XDEF	_f_2
	XDEF	_f_3
	XDEF	_break_wall
	XDEF	_update_tile
	XDEF	_cerrojos
	XDEF	_en_an_next_frame
	defc	_en_an_next_frame	=	54844
	LIB	cpc_ScrollLeft0
	XDEF	_my_inks
	XDEF	_at1
	XDEF	_at2
	XDEF	_level_data
	LIB	cpc_AnyKeyPressed
	XDEF	_step
	XDEF	__en_life
	XDEF	_draw_coloured_tile_gamearea
	LIB	cpc_WyzSetPlayerOn
	XDEF	_cx1
	XDEF	_cx2
	LIB	cpc_AssignKey
	XDEF	_cy1
	XDEF	_cy2
	XDEF	_draw_decorations
	XDEF	_p_subframe
	LIB	cpc_TouchTiles
	XDEF	_en_an_dead_row
	defc	_en_an_dead_row	=	54826
	XDEF	_abs
	LIB	cpc_ScrollRight0
	LIB	cpc_PrintGphStr
	XDEF	_game_ending
	XDEF	_s_ending
	XDEF	_bullets_update
	LIB	cpc_UnExo
	XDEF	_blx
	XDEF	_bly
	XDEF	_gpc
	XDEF	_gpd
	LIB	cpc_SetInkGphStrM1
	XDEF	_en_an_x
	defc	_en_an_x	=	54799
	XDEF	_en_an_y
	defc	_en_an_y	=	54805
	XDEF	_brk_buff
	defc	_brk_buff	=	50988
	XDEF	_hit
	XDEF	_hotspots_do
	LIB	cpc_UpdateTileMap
	XDEF	_gpt
	XDEF	_rda
	XDEF	_rdb
	XDEF	_rdc
	XDEF	_gpx
	XDEF	_gpy
	XDEF	_p_x
	XDEF	_p_y
	XDEF	_cocos_mx
	defc	_cocos_mx	=	54838
	XDEF	_cocos_my
	defc	_cocos_my	=	54841
	XDEF	_rdd
	XDEF	_itj
	XDEF	_rdn
	XDEF	_keys_old
	LIB	cpc_TestKeyF
	XDEF	_rdt
	XDEF	_rdx
	XDEF	_rdy
	XDEF	_sm_cox
	XDEF	_sm_coy
	XDEF	_process_tile
	XDEF	_tileset
	LIB	cpc_PutSpTileMap8x16
	LIB	cpc_PutSpTileMap8x24
	XDEF	_wyz_stop_sound
	LIB	cpc_ReadTile
	LIB	cpc_PutMaskSprite
	XDEF	_wall_h
	LIB	cpc_PutSpTileMapO
	XDEF	_enoffsmasi
	LIB	cpc_PutSp
	XDEF	_spacer
	LIB	cpc_UpdScrAddresses
	XDEF	_persist_tile
	XDEF	_wall_v
	XDEF	_tspatterns
	XDEF	_tocado
	XDEF	_en_an_alive
	defc	_en_an_alive	=	54823
	XDEF	_is_rendering
	XDEF	_cocos_x
	defc	_cocos_x	=	54832
	XDEF	_SetRAMBank
	XDEF	_cocos_y
	defc	_cocos_y	=	54835
	XDEF	_my_inks_2
	XDEF	_my_inks_3
	XDEF	_simple_coco_init
	XDEF	_slevel
	XDEF	_my_inks_4
	XDEF	_asm_int
	XDEF	_p_facing_h
	XDEF	_l_is_classic
	XDEF	_c_is_classic
	XDEF	__baddies_pointer
	XDEF	_p_facing_v
	LIB	cpc_TouchTileSpXY
	XDEF	_p_saltando
	XDEF	_zone_clear
	LIB	cpc_SuperbufferAddress
	LIB	cpc_GetScrAddress
	XDEF	_wyz_songs
	XDEF	_possee
	LIB	cpc_PutMaskSp
	XDEF	_collide
	XDEF	_orig_tile
	XDEF	_en_an_frame
	defc	_en_an_frame	=	54787
	XDEF	_success
	LIB	cpc_RedefineKey
	XDEF	_simple_coco_shoot
	XDEF	_ram_destination
	XDEF	_en_an_count
	defc	_en_an_count	=	54790
	XDEF	_select_joyfunc
	LIB	cpc_GetTiles
	XDEF	_unpack
	XDEF	_clear_sprites
	XDEF	_spr_on
	defc	_spr_on	=	59006
	XDEF	_p_disparando
	LIB	cpc_PutSpXOR
	LIB	cpc_PrintStr
	XDEF	_distance
	XDEF	_draw_scr_background
	XDEF	__b_mx
	XDEF	__b_my
	XDEF	_simple_coco_update
	LIB	cpc_PrintGphStr2X
	XDEF	_win_level
	XDEF	_game_over
	LIB	cpc_PrintGphStrM1
	XDEF	_ingame_text
	XDEF	_ram_address
	LIB	cpc_WyzStartEffect


; --- End of Scope Defns ---


; --- End of Compilation ---
