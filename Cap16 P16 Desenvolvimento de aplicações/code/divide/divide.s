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

/*---------------------------------------------------------------
int x = 30, y = 4, z;

int main() {
	z = div(x, y);
}
*/
	.data
x:
	.word	30
y:
	.word	4
z:
	.word	0
	
	.text
main:
	push	lr
	ldr	r0, addr_x
	ldr	r0, [r0]
	ldr	r1, addr_y
	ldr	r1, [r1]
	bl	divide
	ldr	r1, addr_z	
	str	r0, [r1]
	pop	pc

addr_x:
	.word	x
addr_y:
	.word	y
addr_z:
	.word	z

/*--------------------------------------------------------------------
<r0> uint16_t int divide(<r0> uint16 dividend, <r1> uint16_t divisor){
	<r2> uint16_t i = 16;
	<r3> uint16_t remainder = 0, <r4> quotient = 0;
	do {
		uint16 dividend_msb = dividend >> 15;
		dividend <<= 1;
		rest = ( remainder << 1) | dividend_msb;
		quotient <<= 1;
		if (remainder >= divisor) {
			remainder -= divisor;
			quotient += 1;
		}
	} while (--i > 0);
	return quotient (r0);
}
*/

divide:
	push	r4
	mov	r3, 0		; remainder = 0;
	mov	r4, 0		; quotient = 0;
	mov	r2, 16	; uint16_t i = 16;
div_while:			; uint16 dividend_msb = dividend >> 15;
	lsl	r0, r0, 1	; dividend <<= 1;
	adc	r3, r3, r3	; rest = (rest << 1) | dividend_msb;
	lsl	r4, r4, 1	; quotient <<= 1;
	cmp	r3, r1	; if ( remainder >= divisor) {
	blo	div_if_end
	sub	r3, r3, r1	; remainder -= divisor;
	add	r4, r4, 1	; quotient += 1;
div_if_end:
	sub	r2, r2, 1	; } while (--i > 0);
	bne	div_while
	mov	r0, r4	; return quotient;
	pop	r4
	mov	pc, lr
