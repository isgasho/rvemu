	.file	"echoback.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
.L3:
	li	a5,268435456
	sd	a5,-24(s0)
	nop
.L2:
	ld	a5,-24(s0)
	addi	a5,a5,5
	lbu	a5,0(a5)
	andi	a5,a5,0xff
	sext.w	a5,a5
	andi	a5,a5,1
	sext.w	a5,a5
	beq	a5,zero,.L2
	ld	a5,-24(s0)
	lbu	a5,0(a5)
	sb	a5,-25(s0)
	ld	a5,-24(s0)
	lbu	a4,-25(s0)
	sb	a4,0(a5)
	j	.L3
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"
