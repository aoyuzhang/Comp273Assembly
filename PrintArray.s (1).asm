##
## programming assignment 3.1
## Haoyu Zhang(260499567)
##
## implemented a multiplication loop and used it to calculate
## the offset from the base adress of the array. ie, since the size of int is 4
## we do a multiplication by 4.


##	The program that we have to implement is:
##	int array[10] = {10, 5, 2, 20, 20, -5, 3, 19, 9, 1};
## 	void main(void) {
##			printArray(0, 9); 
##			printArray(9, 0); 
##			}
## 	void printArray(int startIndex, int endIndex) { // prints out the numbers in the order starting from startIndex // and ending at endIndex }

lw 
	.text
	.globl __start
__start: 
	la $t5,space		# store adress of space in t5. 
	la $t1,array		# load the adress of the base array.
	lw $t2,lenght		# load the lenght of array into register t2.
	li $t3,0		# initialise t3 to 0 and use it to go throught loop.
	addi $t2,$t2,-1		# get lenght -1.
for_compare:
	bgt $t3,$t2,reverse_print		# End loop check.
	move $a0,$t3		# a0 serves as a parameter(number being multiply) for multiplication.
	jal multiply
	move $t4,$v0 		# multiply t3 with 4 and use it in the offset of base array adress.
	add $t4,$t1,$t4		# get the offset of the base adress of array.
	li $v0,1
	lw $a0,0($t4)
	syscall			# print the interger on the screen.
	
	li $v0,4
	move $a0,$t5
	syscall			# print a space.
	
	addi $t3,$t3,1		# increase t3 by 1.
	j for_compare
	
	
reverse_print:
	li $t0,9		# since we print in reverse order insdead of goint 1-9 we go 9-0 --> 9-9.
	li $t3,0		# serves to go through loop.
	la $t6,return		
	move $a0,$t6
	li $v0,4
	syscall			# print a return on screen.
for_compare_r:
	bgt $t3,$t2,end_main	# if t2>t3 go to end main.
	sub $t7,$t0,$t3		# t7 gets 9-t3. 
	move $a0,$t7		# t7 is passed as argument for multy subroutine.
	jal multiply
	move $t4,$v0		# result of mult is stored back to t4.
	add $t4,$t4,$t1		# t4 gets the adress of the int to be printed.
	li $v0,1
	lw $a0,0($t4)
	syscall			# print int.
	addi $t3,$t3,1		# increment t3.
	
	li $v0,4
	move $a0,$t5
	syscall			# print a space.
	j for_compare_r
	
	
		
end_main:
	li $v0,10	
	syscall	  		# au revoire!

	
########################################################################			
multiply:
	addi $sp,$sp,-20	# multyplication stacking	
	sw $ra,16($sp)	
	sw $s3,12($sp)
	sw $s2,8($sp)
	sw $s1,4($sp)
	sw $s0,0($sp)
	sw $s4,20($sp)
	
	add $s4,$s4,$zero
	move $s0,$a0		# s0 contain the number to be multiply by 4.
	li $s2,0		# s2 will serve as counter for adding loop.
	li $s3,1		# s3 is loaded with 1 for the boolean chec in the loop.
operation_loop:
	slti $s1,$s2,4		# for loop check. if s2 is less than 3, than perform loop. 
	beq  $s1,$s3,operation  
	j end_operation
	
operation:
	add $s4,$s4,$s0
	addi $s2,$s2,1	
	j operation_loop
	
end_operation:
	move $v0,$s4
	
	
	lw $s4,20($sp)
	lw $ra,16($sp) 
	lw $s3,12($sp)
	lw $s2,8($sp)
	lw $s1,4($sp)
	lw $s0,0($sp)
	jr $ra
###########################################################################	
		
	.data
array: .word 10,5,2,20,20,-5,3,19,9,1	# this is the stored array.
lenght: .word 10			# this is the array lenght.
space: .asciiz  " "			# a space to be printed.	
return: .asciiz "\n"			# line feed to be printed.
