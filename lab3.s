.global main
.func main

.data

askingn: .asciiz "\Enter positive integer number n: "
pa1: .asciiz "array_a["
pa2: .asciiz "]= "
pa3: .asciiz ". array_b["
pa4: .asciiz ". \n"
array_a: .space 80
array_b: .space 80

.text

main:
   li $v0, 4            #load op code for print a string
   la $a0,askingn       #load askingn in $a0, for print the string
   syscall            #reads register $v0 for op code, sees 4 and prints the string

   li $v0,5           #load op code for read an int
   syscall
  
   move $t0,$v0       # $t0=$v0
   li $t1,0
   li $t2,20
   la $a0,array_a
   la $a2,array_b
   li $a1,0
cycle1:                   #populate array_a
   add $a1,$t0,$t1
   sb $a1,($a0)       #save the value into array_a
   addi $a0,$a0,4       #move the pointer to array_a
   addi $a1,$a1,1
   sub $a1,$0,$a1
   sb $a1,($a0)       #save the value into array_a
   addi $a0,$a0,4       #move the pointer to array_a
   addi $t1,$t1,2
   bne $t1,$t2, cycle1
   j printing
  
#sort array_b
   la $s0, array_b
   la $a1,array_b
   li $t0,0
   li $t1,20
   li $a3,4
cycle2:
   lb $t2,($s0)
   move $a1,$s0
   addi $a1,$a1,4
   move $t4,$t0


inner_c:
   lb $t3,($a1)

   move $a0,$t3
   li $v0,1
   syscall
   move $a0,$t2
   li $v0,1
   syscall

   blt $t3,$t2, mini
   addi $a1,$a1,4
   addi $t4,$t4,1


   bne $t4,$t1,inner_c
  

   j change

change:
   lb $t6,($s0)
   move $a1,$s0
   sb $t2,($s0)
   li $t7,0
change_c:
   addi $a1,$a1,4
   addi $t7,$t7,1
   bne $t7,$t5,change_c

   sb $t6,($a1)
   addi $s0,$s0,4
   addi $t0,$t0,1
   beq $t0,$t1, printing
   j cycle2

mini:

   move $t2,$t3
   move $t5,$t4
   j inner_c
  
  
printing:
   la $t0, array_a
   la $t3, array_b
   li $t1,0
   li $t2,20
p_cycle:
   li $v0, 4            #load op code for print a string
   la $a0,pa1           #load askingn in $a0, for print the string
   syscall            #reads register $v0 for op code, sees 4 and prints the string
   move $a0,$t1
   li $v0,1
   syscall
   li $v0, 4            #load op code for print a string
   la $a0,pa2           #load askingn in $a0, for print the string
   syscall            #reads register $v0 for op code, sees 4 and prints the string
   lb $a0, ($t0)
   li $v0,1
   syscall
   li $v0, 4            #load op code for print a string
   la $a0,pa3           #load askingn in $a0, for print the string
   syscall            #reads register $v0 for op code, sees 4 and prints the string
   move $a0,$t1
   li $v0,1
   syscall
   li $v0, 4            #load op code for print a string
   la $a0,pa2           #load askingn in $a0, for print the string
   syscall            #reads register $v0 for op code, sees 4 and prints the string
   lb $a0, ($t3)
   li $v0,1
   syscall
   li $v0, 4            #load op code for print a string
   la $a0,pa4           #load askingn in $a0, for print the string
   syscall            #reads register $v0 for op code, sees 4 and prints the string

  
   addi $t0,$t0,4
   addi $t1,$t1,1
   bne $t1,$t2,p_cycle
  
   li $v0, 10
   syscall