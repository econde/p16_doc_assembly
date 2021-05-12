	.section .startup
	b	_start
	b	.	/*reservado para as insterrupções */
_start:
	mov	sp, stack_top
	bl	main
	b	.


	.section .stack
	.space	128
stack_top:

/*------------------------------------------------------
uint8_t m = 20, n = 3;

uint16_t p, q;
*/

	.data
m:
	.byte	20
n:
	.byte	3
p:
	.word	0
q:
	.word	0

/*------------------------------------------------------
int main() {
	p = multiply(m, n);
	q = multiply(4, 7);
}
*/	
	.text
main:
	push	lr
	ldr	r0, addr_m
	ldr	r0, [r0]
	ldr	r1, addr_n
	ldr	r1, [r1]
	bl	multiply
	ldr	r1, addr_p	
	str	r0, [r1]
	mov	r0, 4
	mov	r1, 7
	bl	multiply
	ldr	r1, addr_q	
	str	r0, [r1]
	pop	pc

addr_m:
	.word	m
addr_n:
	.word	n
addr_p:
	.word	p
addr_q:
	.word	q

/*-----------------------------------------------------------
int multiply(<r0> int multiplicand, <r1> int multiplier)) {
	<r2> int product = 0;
	while ( multiplier > 0 ) {
		if ( (multiplier & 1) != 0 )
			product += multiplicand;
		multiplier >>= 1;
		multiplicand <<= 1;
	}
	<r0> return product;
}
*/
multiply:
	mov	r2, 0		; <r2> int product = 0;
mul_while:
	add	r1, r1, 0	; while ( multiplier > 0 )
	beq	mul_return
	lsr	r1, r1, 1	; if ( (multiplier & 1) != 0 )
	bcc	mul_if_end
	add	r2, r2, r0	; product += multiplicand;
mul_if_end:
	lsl	r0, r0, 1	; multiplicand <<= 1;
	b	mul_while
mul_return:
	mov	r0, r2
	mov	pc, lr		; <r0> return product;
