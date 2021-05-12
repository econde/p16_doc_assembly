	.section .startup
	b	_start
	b	.
_start:
	ldr	sp, addr_stack_top
	bl	main
	b	.
addr_stack_top:
	.word	stack_top

	.section .stack
	.equ	STACK_SIZE, 64
	.space	STACK_SIZE
stack_top:
/*-------------------------------------------------------------
uint16_t a = 8, fa;
uint16_t fb;

int main() {
    fa = factorial(a);
    fb = factorial(8);
}
*/
	.data
a:
	.word	8
fa:
	.word	0
fb:
	.word	0

	.text
main:
	push	lr
	ldr	r0, addr_a
	ldr	r0, [r0]
	bl	factorial
	ldr	r1, addr_fa
	str	r0, [r1]
	mov	r0, 8
	bl	factorial
	ldr	r1, addr_fb
	str	r0, [r1]
	pop	pc
addr_a:
	.word	a
addr_fa:
	.word	fa
addr_fb:
	.word	fa
/*------------------------------------------------------------
uint16_t factorial(uint16_t n) {
	if (n == 0)
		return 1;
	else
		return(n * factorial(n - 1));
}
*/
factorial:
	add	r0, r0, 0	; if (n == 0)
	beq	factorial_1
	push	lr		; save return address
	push	r0		; save n in stack
	sub	r0, r0, 1	; factorial(n - 1)
	bl	factorial
	pop	r1		; recover n
	bl	mul16		; n * factorial(n - 1)
	add	r1, r1, 0	; multiplication overflow ?
	beq	factorial_2
	b	.
factorial_2:
	pop	pc		; restore return address and return
factorial_1:
	mov	r0, 1
	mov	pc, lr

/*-------------------------------------------------------------
uint32_t mul16(<r0> uint16_t multiplicand, <r1> uint16_t multiplier)) {
	<r2:r0> uint32_t multiplicandi = (uint32_t) multiplicand;
	<r4:r3> uint32_t product = 0;
	while ( multiplier > 0 ) {
		if ( (multiplier & 1) != 0 )
			product += multiplicandi;
		multiplier >>= 1;
		multiplicandi <<= 1;
	}
	<r1:r0> return product;
}
*/
mul16:
	push	r4
	mov	r2, 0	; <r2:r0> uint32_t multiplicandi = (uint32_t) multiplicand;
	mov	r3, 0	; <r4:r3> uint32_t product = 0;
	mov	r4, 0
mul16_while:
	add	r1, r1, 0	; while ( multiplier > 0 )
	beq	mul16_return
	lsr	r1, r1, 1	; if ( (multiplier & 1) != 0 )
	bcc	mul16_if_end
	add	r3, r3, r0	; product += multiplicandi;
	adc	r4, r4, r2
mul16_if_end:
	lsl	r0, r0, 1	; multiplicandi <<= 1;
	adc	r2, r2, r2
	b	mul16_while
mul16_return:
	mov	r0, r3		; <r1:r0> return product;
	mov	r1, r4
	pop	r4
	mov	pc, lr	
