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
/*--------------------------------------------------------------------
int8_t is_leap(<r0> uint16_t year) {
	return year % 4 == 0;
}
*/
	.text
is_leap:
	mov	r1, #3
	and	r0, r0, r1
	mrs	r0, cpsr
	lsr	r0, r0, 1
	mov	r0, 0
	adc	r0, r0, r0
	mov	pc, lr

/*--------------------------------------------------------------------
int16_t month_days[] =
    {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};

int16_t year_days(<r0> uint16_t year,
		  <r1> uint8_t month, <r2> uint8_t day) {
	return month_days[month - 1]
		+ (month > 2 && is_leap(year) ? 1 : 0) + day - 1;
}
*/
	.text
month_days:
	.word	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365
year_days:
	push	lr
	push	r4
	ldr	r3, addr_month_days
	sub	r4, r1, 1	; month - 1
	add	r4, r4, r4	; scale index of array by two
	ldr	r3, [r3, r4] 	; month_days[month - 1]
	sub	r1, r1, 3	; month - 3
	blo	year_days_if_end
	bl	is_leap
	add	r3, r3, r0	; + is_leap(year)
year_days_if_end:
	add	r3, r3, r2	; + day
	sub	r0, r3, 1	; - 1;
	pop	r4
	pop	pc

addr_month_days:
	.word	month_days
/*--------------------------------------------------------------------
uint16_t days_since(<r5> <r0> uint16_t year_base, <r6> <r1> uint16_t year,
			 <r7> <r2> uint8_t month, <r8> <r3> uint8_t day {
	<r4> uint16_t days  = 0;
	for ( <r5> uint16_t y = year_base; y < year; ++y)
		days += 365 + is_leap(y);
	return days + year_days(year, month, day);
}
*/	
	.text
days_since:
	push	lr
	push	r4
	push	r5
	push	r6
	push	r7
	push	r8
	push	r9
	mov	r5, r0
	mov	r6, r1
	mov	r7, r2
	mov	r8, r3
	mov	r4, 0
	mov	r9, 365 & 0xf
	movt	r9, 365 >> 8
	b	days_since_for_cond
days_since_for:
	add	r4, r4, r9
	mov	r0, r5
	bl	is_leap
	add	r4, r4, r0
	add	r5, r5, 1
days_since_for_cond:
	cmp	r5, r6
	blo	days_since_for
	mov	r0, r6
	mov	r1, r7
	mov	r2, r8
	bl	year_days
	add	r0, r4, r0
	pop	r9
	pop	r8
	pop	r7
	pop	r6
	pop	r5
	pop	r3
	pop	pc
/*--------------------------------------------------------------------
uint16_t days;
int main() {
	days = days_since(1900, 2017, 3, 30)
		- days_since(1900, 1995, 3, 8);
}
*/
	.data
days:
	.word	0

	.text
main:
	push	lr
	mov	r0, 1900 & 0xff
	movt	r0, 1900 >> 8
	mov	r1, 2017 & 0xff
	movt	r1, 2017 >> 8
	mov	r2, 3
	mov	r3, 30
	bl	days_since
	mov	r4, r0
	mov	r0, 1900 & 0xff
	movt	r0, 1900 >> 8
	mov	r0, 1995 & 0xff
	movt	r0, 1995 >> 8
	mov	r2, 3
	mov	r3, 8
	bl	days_since
	sub	r0, r4, r0
	ldr	r1, addr_days
	str	r0, [r1]
	pop	pc
addr_days:
	.word 	days
