	.section .startup

	b	_start

_start:
	ldr	sp, addr_stack_top
	bl	main
	b	.

addr_stack_top:
	.word	stack_top

	.section .stack
	.equ	STACK_SIZE, 64
stack:
	.space	STACK_SIZE
stack_top:

/*-----------------------------------------------------
int x = 30, y = 4, z;

int main() {
	z = x + y;
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
	ldr	r0, addr_x
	ldrb	r0, [r0]
	ldr	r1, addr_y
	ldr	r1, [r1]
	add	r0, r0, r1
	ldr	r1, addr_z	
	str	r0, [r1]
	mov	pc, lr

addr_x:
	.word	x
addr_y:
	.word	y
addr_z:
	.word	z
