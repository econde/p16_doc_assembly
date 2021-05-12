	.text
add	r0, r0, r1

add	r0, r2, r1
sub	r0, r0, r3

sub	r0, r1, 3


add	r4, r2, r0
adc	r5, r3, r1

; r0 - a
mov	r0, 3045 & 0xff
movt	r0, 3045 >> 8


lsr	r1, r1, 1
rrx	r0, r0

lsr	r0, r0, 4
lsl	r2, r1, 16 - 4
add	r0, r0, r2
lsr	r1, r1, 4


lsl	r0, r0, 1
adc	r1, r1, r1

lsl	r1, r1, 4
lsr	r2, r0, 16 - 4
add	r1, r1, r2
lsl	r0, r0, 4

ror	r0, r0, 3

ror	r0, r0, 16 - 5

	mov	r1, 0b11111111
	movt	r1, 0b11101111
	and	r0, r0, r1
	
	lsr	r2, r1, 13 - 4
	mov	r3, 0b00010000
	and	r2, r2, r3
	orr	r0, r0, r3
	orr	r0, r0, r2
	
	;ro – a, r1 - b
mov	r1, r0	; * 1
lsl	r0, r0, 1
add	r1, r1, r0	; * 2
lsl	r0, r0, 1
add	r1, r1, r0	; * 4
lsl	r0, r0, 2
add	r1, r1, r0	; * 16

;r5 – i, f – r2, g - r4
	add	r5, r5, 0
	beq	label1
	add	r2, r2, 3
label1:
	sub	r4, r4, 1


;r5 – i, r3 – j, r2 - f
	cmp	r5, r3
	bne	if_else
	lsl	r2, r2, 1
	add	r5, r5, 1
	b	if_end
if_else:
	lsr	r2, r2, 2
	sub	r5, r5, 2
if_end:
	add	r3, r3, 1

;r0 = v, r1 – a
switch_case1:
    mov   r2, 1
    cmp   r0, r2
    bne   switch_case10
    mov   r1, 11
    b     switch_break;
switch_case10:
    mov   r2, 10
    cmp   r0, r2
    bne   switch_default
    mov   r1, 111
    b     switch_break;
switch_default:
    mov   r1, 0
switch_break:

;r0 – v, r1 – l
do_while:
    lsr    r0, r0, 1
    add    r1, r1, 1
    sub    r0, r0, 0
    bne    do_while
 
 
;r0 – v, r1 – l
while1:
    sub    r0, r0, 0
    beq    while_end1
    lsr    r0, r0, 1
    add    r1, r1, 1
    b      while1
while_end1:

;r0 – v, r1 – l
while2:
    b      while_cond2
while_do2:
    lsr    r0, r0, 1
    add    r1, r1, 1
while_cond2:
    sub    r0, r0, 0
    bne    while_do2
    
;r0 – i, r1 – a, r2 - n
    mov    r0, 0
    mov    r1, 1
    b      for_cond
for:
    lsl    r1, r1, 1
    add    r0, r0, 1
for_cond:
    cmp    r0, r2
    blo    for

	ror	r0, r0, 3
	bcs	label1

	add	r5, r5, 0
	beq	label1

;r0 – a, r1 – b, r2 - c
	cmp	r0, r1
	bhs	if_end1
	mov	r2, r0
if_end1:

;r0 – a, r1 - b
	cmp	r1, r0
	bhs	if_end2
	mov	r2, r0
if_end2:

x:	.byte	0
y:	.byte	0

mov  r1, x
ldrb r0, [r1]

mov  r1, y
ldr  r0, [r1]

ldr  r1, addr_x
ldrb r0, [r1]

addr_x:	.word x

; r0 – array, r1 – i, r2 - a
    mov   r1, 0
    b     for_cond1
for1:
    ldrb  r3, [r0, r1]
    add   r2, r2, r3
for_cond1:
    mov   r3, 10
    cmp   r1, r3
    blo   for1
   

; r0 – array, r1 – i
; r2 - a

    mov   r1, 0
    b     for_cond2
for2:
    lsl   r3, r1, 1
    ldr   r3, [r0, r3]
    add   r2, r2, r3
for_cond2:
    mov   r3, 10
    cmp   r1, r3
    blo   for2

  bl     delay
  
  
delay:
    mov    r0, 100
    mov    r1, 0   
for3:
    cmp    r1, r0
    bcc    for_end3
    add    r1, r1, 1
    b      for3
for_end3:
    mov    pc, lr


mov    r0, 4
mov    r1, 10
bl     multiply
str    r0, [r4, 4]
mov    r0, 8
mov    r1, 10
bl     multiply
str    r0, [r4, 6]

multiply:
	mov	r2, 0
while:
	sub	r1, r1, 0
	beq	while_end
	add	r2, r2, r0
	sub	r1, r1, 1
	b	while
while_end:
	mov	r0, r2
	mov	pc, lr




