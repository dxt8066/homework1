/*****
       DEVA TIMSINA
	   1001098066
	   LAB03
					*****/
.global main
.func main

main:
	BL _scanf		@ branch to scanf procedure with return
	MOV R1, R0		@ move  R0 to  R1
	MOV R0, #0		@ load R0 
	B   _generate		 @ branch n

_generate:
	CMP R0, #20		     @ compare R0 
	BEQ _generateDone	
	LDR R2, =array_a	 @ get address of array_a
	LSL R3, R0, #2		
	ADD R3, R2, R3		
	MOV R4, #0		     @ move 0 to R4
	ADD R4, R0, R1		
	STR R4, [R3]		
	ADD R5, R0, #1		
	LSL R3, R5, #2 		@ multiply index*4 to get array offset
	ADD R3, R2, R3		
	MOV R4, #0		    @ move 0 to R4
	ADD R4, R1, R0		
	ADD R4, R4, #1		@ put the sum of R4 and 1 in R4
	MOV R5, #0		    @ move 0 to R5
	SUB R4, R5, R4		@ take negative sum
	STR R4, [R3]		
	ADD R0, R0, #2		@ increase the value of index by 2
	B   _generate		@ loop back 

_generateCompleted:
	MOV R0, #0		    @ initialize 
	B   _copyToB		@ branch 

_copyToB:
	CMP R0, #20		    @ compare R0 to 20
	MOVEQ R0, #0		@ move 0 to R0 
        BEQ _sort_ascending
	LDR R1, =array_a	
	LSL R2, R0, #2		@ get the base address
	ADD R2, R1, R2		
	LDR R3, =array_b	
	LSL R1, R0, #2		
	ADD R4, R1, R3		
	LDR R2, [R2]		
	STR R2, [R4]		
	ADD R0, R0, #1		
	B _copyToB		    @ branch to begining

_sort_ascending:
	CMP R0, #19		    @ compare R0 to 19
	MOVEQ R0, #0		
	BEQ _readloop		@ branch to readloop if equal
	LDR R1, =array_b	
	MOV R4, R0		     @ minimum index equals i
	ADD R2, R0, #1		@ j = i + 1(for inner loop)
	BL _innerLoop		
	LSL R8, R0, #2		@ multiply index*4 to get array offset
	ADD R8, R1, R8		@ get the address at index i
	LDR R9, [R8]		@ temporary element for swapping
	LSL R5, R4, #2 		
	ADD R5, R1, R5		
	LDR R7, [R5]		@ the minimum index is loaded to R7
	STR R7, [R8]		@ swapping 
	STR R9, [R5]		
	ADD R0, R0, #1		
	b _sort_ascending	 @ branch to start
_innerLoop:
	CMP R2, #20		    
	MOVEQ PC, LR		@ move 
	LSL R3, R2, #2		
	ADD R3, R1, R3		@ R3 now has the element address
	LSL R5, R4, #2		
	ADD R5, R1, R5		@ R5 now has the address of mimimum index
	LDR R3, [R3]		
	LDR R5, [R5]		
	CMP R3, R5		    @ compare values
	MOVLT R4, R2		
	ADD R2, R2, #1		@ increase the index of the inner loop
	B _innerLoop		@ branch to begining

_readloop:
   	CMP R0, #20            
    	BEQ readdone            @ exit loop if done
    	LDR R1, =array_a       
    	LSL R2, R0, #2         
    	ADD R2, R1, R2          @ R2 now has the element address
    	LDR R1, [R2]            
	LDR R4, =array_b	        @ get address of array_b
	LSL R5, R0, #2		        @ multiply index*4 to get array offset
	ADD R4, R5, R4		        @ R4 now has the element address
	LDR R3, [R4]		         @ read the array at the address specified 
    	PUSH {R0}               @ backup register before printf
    	PUSH {R1}               @ backup register before printf
    	PUSH {R2}               @ backup register before printf
	PUSH {R3}		@ backup register before printf
    	MOV R2, R1              @ move array value to R2 for printf
    	MOV R1, R0              @ move array index to R1 for printf
    	BL  _printf             @ branch to print procedure with return
	POP {R3}		@ restore register
    	POP {R2}                @ restore register
    	POP {R1}                @ restore register
    	POP {R0}                @ restore register
    	ADD R0, R0, #1          @ increment index
    	B   _readloop           @ branch to next loop iteration

readdone:
    	B _exit                 @ exit if done
    
_exit:  
    	MOV R7, #4              @ write syscall, 4
   	MOV R0, #1              @ output stream to monitor, 1
    	MOV R2, #21             @ print string length
   	LDR R1, =exit_str       @ string at label exit_str:
    	SWI 0                   @ execute syscall
    	MOV R7, #1              @ terminate syscall, 1
    	SWI 0                   @ execute syscall

_scanf:
	PUSH {LR}               @ store LR since scanf call overwrites
    	SUB SP, SP, #4          @ make room on stack
    	LDR R0, =format_str     @ R0 contains address of format string
        MOV R1, SP              @ move SP to R1 to store entry on stack
        BL scanf                @ call scanf
        LDR R0, [SP]            @ load value at SP into R0
    	ADD SP, SP, #4          @ restore the stack pointer
    	POP {PC}                @ return	

_printf:
    	PUSH {LR}               @ store the return address
    	LDR R0, =printf_str     @ R0 contains formatted string address
    	BL printf               @ call printf
    	POP {PC}                @ restore the stack pointer and return



.data

.balign	4

array_a:	.skip		80
array_b:        .skip           80
format_str:	.asciz		"%d"
printf_str:	.asciz		"array_a[%d] = %d, array_b = %d\n"
exit_str:       .ascii     	 "Terminating program.\n"
