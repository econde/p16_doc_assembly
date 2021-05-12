.section .startup
	b	_start
	b	.
_start:
	ldr	sp, addr_stack_top
	bl	main
	b	.

addr_stack_top:
	.word	stack_top

/*------------------------------------------------------------------------------
*/
	.equ	BUTTON_MASK, 1
	.equ	LAMP_MASK, 1
	.equ	TIME_DELAY, 10000

	.equ	SDP16_PORT_ADDRESS, 0xff00
/*
int main() {
	while (true) {
		port_output(0)	 apaga a lâmpada
		while ((port_input() & BUTTON_MASK) != 0)
			;
		while ((port_input() & BUTTON_MASK) == 0)
			;
		port_output(LAMP_MASK);	acende a lâmpada
		uint16_t delay_counter = TIME_DELAY;
		while ((port_input() & BUTTON_MASK) != 0 && delay_counter > 0)
			delay_counter--;
		while ((port_input() & BUTTON_MASK) == 0 && delay_counter > 0)
			delay_counter--;
	}
}
*/
	.text
main:
while:
	mov	r0, #0
	bl	port_output	; port_output(0)	apaga a lâmpada
while1:				; while ((port_input() & BUTTON_MASK) != 0)
	bl	port_input
	mov	r2, #BUTTON_MASK
	and	r0, r0, r2
	bzc	while1
while2:				; while ((port_input() & BUTTON_MASK) == 0)
	bl	port_input
	mov	r2, #BUTTON_MASK
	and	r0, r0, r2
	bzs	while2
	mov	r0, #LAMP_MASK
	bl	port_output		; port_output(LAMP_MASK); acende a lâmpada
	mov	r4, #TIME_DELAY & 0xff	; delay_counter = TIME_DELAY;
	movt	r4, #TIME_DELAY >> 8
while3:
	bl	port_input	; while ((port_input() & BUTTON_MASK) != 0
	mov	r2, #BUTTON_MASK
	and	r0, r0, r2
	bzs	while3_end
	sub	r4, r4, #0	; && delay_counter > 0
	bzs	while3_end
	sub	r4, r4, #1
	b	while3
while3_end:
while4:
	bl	port_input	; while ((port_input() & BUTTON_MASK) == 0
	mov	r2, #BUTTON_MASK
	and	r0, r0, r2
	bzc	while4_end
	sub	r3, r4, #0	; && delay_counter > 0
	bzs	while4_end
	sub	r4, r4, #1
	b	while4
while4_end:
	b	while

/*------------------------------------------------------------------------------
*/

port_input:
	ldr	r1, addr_port
	ldrb	r0, [r1]
	mov	pc, lr

port_output:
	ldr	r1, addr_port
	strb	r0, [r1]
	mov	pc, lr

addr_port:
	.word	SDP16_PORT_ADDRESS

/*------------------------------------------------------------------------------
*/
	.section .stack
	.equ	STACK_SIZE, 1024
	.space	STACK_SIZE
stack_top:
