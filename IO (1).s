## HaoyuZhang(260499567)
## Assignment 3.2
##
## allocation of memory using heap.
## local variables stored in stack.
## cannot read negative numbers
##
##
	.text 
	.globl main

############################################################################################3	
main:
	la $a0,string		# get ready to print the string in the screen by loading it in a0.
	li $v0,4		# syscall for print string.
	syscall		
	li $t0,10		# serves as the number of times of the loop to get the intergers.
	li $t1,1		# serves to track the times went thought loop.
	li $v0,9
	li $a0,40
	syscall			# allocate memory and adress is stored in v0
	move $t2,$v0		# put the adress into t2
	move $t4,$v0		# make a copy of the adress.
main_loop:	
	bgt $t1,$t0 main_end_loop	# if t1>t0(10) go to end_loop. for (t1=1:t1<=10;ti++)
	jal readint		# read an interger from the user.
	sw  $v1,0($t2)		# store the word in the array.
	addi $t2,$t2,4		# so t2 point to next word in the memory adress.
	addi $t1,$t1,1		# increment the counter.
	j main_loop		# jump to main_loop
main_end_loop: 
        li $v0,11
	li $a0,10
	syscall			# print carriage return on the screen.
	li $t1,1		# serves to go though loop.
	move $t2,$t4		# put the adress of array into t2.
print_loop:
	bgt $t1,$t0 end_print_loop	# go to reverse print if done.
	lw $t3,0($t2)		# put the int stored in 0(t2) into t3.
	move $a0,$t3
	li $v0,1
	syscall			# print int on the screen.
	li $v0,11
	li $a0,32
	syscall			# print space on the screen.
	addi $t2,$t2,4		# increment t2 to point to the next interger.
	addi $t1,$t1,1		# increment t1
	j print_loop		# jump to print loop
	
end_print_loop:
	li $v0,11
	li $a0,10
	syscall			# print carriage return on the screen.
	li $t1,1		# serves to go though loop.
	move $t2,$t4		# put the adress of array into t2.
	addi $t2,$t2,36		# let it point to the last int.
rprint_loop:
	bgt $t1,$t0 end_main	# if(t1>10) go to end main.
	lw $t3,0($t2)		# put the int stored in 0(t2) into t3.
	move $a0,$t3
	li $v0,1
	syscall			# print int on the screen.
	li $v0,11
	li $a0,32
	syscall			# print space on the screen.
	addi $t2,$t2,-4		# decrement t2 to point to the next interger.
	addi $t1,$t1,1		# increment t1
	j rprint_loop		# jump to print rprint_loop
		
end_main:
	li $v0,10
	syscall			# au revoir!				
	
			
########################################################################################
	
			
###############################################			
readint:	# this subroutine takes strings input and store it as interger in v1. 
    		# if character is not a digit then it stores 0.
	addi $sp,$sp,-36
	sw $ra,32($sp)	
	sw $s0,28($sp)
	sw $s1,24($sp)
	sw $s2,20($sp)
	sw $s3,16($sp)
	sw $s4,12($sp)
	sw $s5,8($sp)
	sw $s6,4($sp)
	sw $s7,0($sp)		# Pushing.
	
	li $s4,10		# s4 is stored with 10 to be exponentiated.	
	li $s5,0		# $s5 serves to count the number of characters. 
	addi $s6,$zero,0	# s6 will serve as sum.
	li $s1,1		# s1 will go through loop in the string.
while_read:	
	jal getc
	move $s0,$v1		# Store the read character in s0.
	beq  $s0,10,end_while_read_loop	# if s0 is 10, this means that it is a carriage return.
	beq $zero,$s0,end_while_read_loop	# if s0 is null, jump to end
	beq $s0,32,end_while_read_loop	#if it is a scape then go to end_while_read_loop.
	addi $sp,$sp,-1		# make space in stack.
	sb $s0,0($sp)		# push the character into stack.
	addi $s5,$s5,1		# Increment s5 by one as s5 count the number of characters stored.
	j while_read
end_while_read_loop:
	bgt $s1,$s5 end_loop	# if s1>=s5 so exit for loop
	lb $s0,0($sp)		# store the value in sp(read character) into s0.
	addi $sp,$sp,1		# restore sp.
	addi $s0, $s0,-48	# this gives the value of int of that ascii character. it is then stored in s0.
	bgt $s0,9 end_readint	# if s0 is greater than 9 then it is not a digit so go to exit and return 0.
	blt $s0,0 end_readint 	# If s0 is less than 0 then it is not a digit , return 0.
	# Now s0 is stored with the last digit of the int. it must be multiply by 10^s1
	
	li $s2,2		# s2 go through the loop of the power of 10.
	li $s3,1		#s3 will store the result of multiplication.
# if s1=1 then we do 10^0, similarily s1=2 then we do 10^1.
checks1:
	beq $s1,1,end_mult_loop	# if s1=1 then 10^0.	
mult_loop:
	bgt   $s2,$s1,end_mult_loop	# if s2>=s1 end loop.
	mult $s3,$s4		# multiply s4(10) with s3 and store in s3(s3*10).
	mflo  $s3		# put result in s3
	addi $s2,$s2,1		# increment s2 as it go throught the multloop once.
	j mult_loop		# jump to the loop			
end_mult_loop:	
	mult $s3,$s0		# multiply a0^some_power with the digit.
	mflo $s3		# store the result in $s3.
	add $s6,$s6,$s3		# s6 store the sum of the converted interger.
	addi $s1,$s1,1		# increment s1 by one as it goes throught the loop once.
	j end_while_read_loop	# go to the loop again.
end_loop:	
	move $v1,$s6 		# Store v1(the conventional retun value register) with s6
	j pop			# skip store v1 with 0.
	
end_readint:	
	move $v1,$zero
	
pop:	
	
	lw $ra,32($sp)		# Poping.
	lw $s0,28($sp)
	lw $s1,24($sp)
	lw $s2,20($sp)
	lw $s3,16($sp)
	lw $s4,12($sp)
	lw $s5,8($sp)
	lw $s6,4($sp)
	lw $s7,0($sp)
	addi $sp,$sp 36
	jr $ra
############################################

#####################################################3	
getc:	# this subroutine takes a character from stdin and store it in v1.
	li $v0,12
	syscall
	move $v1,$v0		# vi gets the ascii of the character.
	jr $ra
#####################################################################	

####################################################	
putc: 	# this subroutine simply prints the character stored in a0 to the screen.
	
	li $v0,11 		# Assuming that a0 is stored with the character.
	syscall
	jr $ra			
######################################################


######################################################3			
puts:	# This subroutine takes the adress of an array of string stored in a0 and prints it on the screen.
	addi $sp,$sp,-36
	sw $ra,32($sp)	
	sw $s0,28($sp)
	sw $s1,24($sp)
	sw $s2,20($sp)
	sw $s3,16($sp)
	sw $s4,12($sp)
	sw $s5,8($sp)
	sw $s6,4($sp)
	sw $s7,0($sp)		# Pushing.
	
	move $s0,$a0		# Store the value of adress of array at s0.
puts_loop:	
	lb $s2,0($s0)		# store the ascii value pointed by the adress stored in s0 to s2.
	beq  $zero,$s2,puts_end	# if s2 is zero. that means the character stored is null so end of print.	
	move $a0,$s2 		# Store the value of s2 into a0 so that i can use it in the putc function as parameter.
	jal  putc
	addi $s0,$s0,1		# Increment s0 so that it point to the next byte.
	j puts_loop
puts_end:

	li $v0,10
	syscall
	lw $ra,32($sp)		# Poping.
	lw $s0,28($sp)
	lw $s1,24($sp)
	lw $s2,20($sp)
	lw $s3,16($sp)
	lw $s4,12($sp)
	lw $s5,8($sp)
	lw $s6,4($sp)
	lw $s7,0($sp)
	addi $sp,$sp 36
	jr $ra
###############################################
			
#####################################################################			
gets:
	addi $sp,$sp,-36	#  stacking pushing.	
	sw $ra,32($sp)	
	sw $s0,28($sp)
	sw $s1,24($sp)
	sw $s2,20($sp)
	sw $s3,16($sp)
	sw $s4,12($sp)
	sw $s5,8($sp)
	sw $s6,4($sp)
	sw $s7,0($sp) 
	
	move $s3,$a0		# the adress of the label is stored in s3.
	li $s0,10		# The ascii value for carriage return is 10.	
loop:	
	jal getc
	beq $v1,10,gets_endcr	# if theinput is CR, then jump to gets ed
	beq $v1,0,gets_endnull
	sb $v1,0($s3)		# Store the character in the memory.
	addi $s3,$s3,1		# increment the offset of memory
	j loop	
gets_endcr:
	sb $s0,0($s3)		# Store enter.
	addi $s3,$s3,1		# increment offset of memory
gets_endnull:	
	sb $zero,0($s3)		# Store null at the end of character array.

	lw $ra,32($sp)		# Poping.
	lw $s0,28($sp)
	lw $s1,24($sp)
	lw $s2,20($sp)
	lw $s3,16($sp)
	lw $s4,12($sp)
	lw $s5,8($sp)
	lw $s6,4($sp)
	lw $s7,0($sp)
	addi $sp,$sp 36
	jr $ra
####################################################	
	
	
	


	



	
	
	.data
string: .asciiz "Please enter 10 number to be printed!\n"


