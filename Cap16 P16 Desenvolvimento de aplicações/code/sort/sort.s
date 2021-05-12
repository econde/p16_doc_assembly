.section .startup
	b	_start	
	b	.
_start:
	ldr	sp, addr_stack_top
	ldr	r0, addr_main
	mov	r1, pc
	add	lr, r1, 4
	mov	pc, r0
	b	.
addr_stack_top:
	.word	stack_top
addr_main:
	.word	main

	.section .stack
	.equ	STACK_SIZE, 1024
	.space	STACK_SIZE
stack_top:

/*-----------------------------------------------------------------------
uint16_t array[] = { 20, 3, 45, 7, 5, 9, 15, 2};

int main() {
	sort(array, sizeof(array) / sizeof(array[0]));
}
*/
	.data
array:	
	.word	20, 3, 45, 7, 5, 9, 15, 2
array_end:

	.text
main:
	push	lr
	ldr	r0, addr_array
	mov	r1, (array_end - array) / 2
	bl	sort
	pop	pc
	
addr_array:
	.word	array

/*-----------------------------------------------------------------------
typedef enum boolean {false = 0, true = !false} Boolean;
void sort(<r0> uint16_t a[], <r1> int dim) {
	<r2> Boolean swapped;
	do {
		swapped = false;
		for (<r3> int i = 0; i < dim - 1; i++)
			if ( a[i] > a[i + 1]) {
				int aux = a[i];
				a[i] = a[i + 1];
				a[i + 1] = aux;
				swapped = true;
			};
		dim--;
	} while (swapped);
}
*/

	.equ	false, 0
	.equ	true, !false
sort:
	push	r4
	push	r5
	push	r6
	sub	r1, r1, 1	; dim - 1
sort_do:
	mov	r2, false	; do {
	mov	r3, 0		; i = 0
	mov	r4, r0		; r4 = endereço de a[0]
sort_for:
	cmp	r3, r1		; i – (dim - 1)
	bhs	sort_for_end	; if (i < dim-1) 
	ldr	r5, [r4]	; r0 = a[i]
	ldr	r6, [r4, 2]	; r4 = a[i + 1]
	cmp	r6, r5		; a[i + 1] - a[i]
	bge	sort_if_end	; if (a[i] < a[i + 1])
	str	r6, [r4]	; troca a[i] com a[i + 1]
	str	r5, [r4, 2]	
	mov	r2, true	; swap = true
sort_if_end:
	add	r3, r3, 1	; i++
	add	r4, r4, 2	; r6 = endereço de a[i]
	b	sort_for
sort_for_end:
	sub	r1, r1, 1	; dim--
	mov	r4, true
	cmp	r2, r4
	beq	sort_do		; } while (swapped)
	pop	r6
	pop	r5
	pop	r4
	mov	pc, lr		; return
