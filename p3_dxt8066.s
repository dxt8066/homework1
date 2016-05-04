/**
       DEVA TIMSINA
       lab03
       1001098066
					**/
                    
                    
                    
.global main
.func main

main:
	BL _scanf		@ branch to scanf 
	MOV R1, R0		@ Move R0 to R1
	MOV R0, #0		@ load R0 
	B   _generate	
    
    

GENERATE:
	CMP R0, #20		@ compare R0 with number 20
	BEQ _generateDone	
	LDR R2, =array_a	@ get address 
	LSL R3, R0, #2		
	ADD R3, R2, R3		@ R3 now has the element address
	MOV R4, #0		
	ADD R4, R0, R1		@ put the sum of n and current index in R4
	STR R4, [R3]		
	ADD R5, R0, #1		@ put value of R0 to R5
	LSL R3, R5, #2 	
	ADD R3, R2, R3		@ R3 contains element address
	MOV R4, #0		
	ADD R4, R1, R0		
	ADD R4, R4, #1		@ put the sum of R4 and 1 in R4
	MOV R5, #0		
	SUB R4, R5, R4		@ take negative of the sum 
	STR R4, [R3]		
	ADD R0, R0, #2		
	B   _generate		@ loop back 
    
    

_generated:
	MOV R0, #0		@ initialize index 
	B   _copyToB		
    

copy:
	CMP R0, #20		@ compare R0 to 20
	MOVEQ R0, #0		@ move 0 to R0 
    BEQ _sort_ascending	
	LDR R1, =array_a	@ load the address of array_a to R1
	LSL R2, R0, #2		
	ADD R2, R1, R2		
	LDR R3, =array_b	@ load the address of array_b to R3
	LSL R1, R0, #2		
	ADD R4, R1, R3		
	LDR R2, [R2]		@ get the content the address specified by R2 to R2
	STR R2, [R4]		
	ADD R0, R0, #1		@ increase index value
	B _copyToB		@ branch to begining

SortAssending:
	CMP R0, #19		@ compare R0 to 19
	MOVEQ R0, #0		@ move 0 ro R0 if equal
	BEQ _readloop		
	LDR R1, =array_b	@ get address of array_b
	MOV R4, R0		
	ADD R2, R0, #1		@ j = i + 1
	BL _innerLoop		
	LSL R8, R0, #2		
	ADD R8, R1, R8		@ get the address at index i
	LDR R9, [R8]		
	LSL R5, R4, #2 		
	ADD R5, R1, R5		
	LDR R7, [R5]		
	STR R7, [R8]		@ swapping 
	STR R9, [R5]		
	ADD R0, R0, #1		
	b _sort_ascending	@ branch back to start 

InnerLoop:
	CMP R2, #20		@ compare j with the length of array_b
	MOVEQ PC, LR		@ move to the instruction where this function was branched
	LSL R3, R2, #2		@ multiply index*4 to get the array offset
	ADD R3, R1, R3		@ R3 now has the element address
	LSL R5, R4, #2		@ multiply minimumindex*4 to get the array offset
	ADD R5, R1, R5		@ R5 now has the address of mimimum index
	LDR R3, [R3]		@ load the element at index i
	LDR R5, [R5]		@ load the element at the minimum index
	CMP R3, R5		@ compare values
	MOVLT R4, R2		@ change the minimum index to j if less than
	ADD R2, R2, #1		@ increase the index of the inner loop
	B _innerLoop		@ branch back to the start of the function

readloop:
   	CMP R0, #20             
    	BEQ readdone            @ exit loop if done
    	LDR R1, =array_a       
    	LSL R2, R0, #2         
    	ADD R2, R1, R2          @ R2 now has the element address
    	LDR R1, [R2]            @ read the array at address
	LDR R4, =array_b	
	LSL R5, R0, #2		
	ADD R4, R5, R4		
	LDR R3, [R4]		@ read the array at the address specified 
    	PUSH {R0}               
    	PUSH {R1}               @ backup register 
    	PUSH {R2}               @ backup register 
	PUSH {R3}		
    	MOV R2, R1             
    	MOV R1, R0              
    	BL  _printf             
	POP {R3}		
    	POP {R2}                @ restore register
    	POP {R1}               
    	POP {R0}                @ restore register
    	ADD R0, R0, #1          
    	B   _readloop           @ branch to next loop i

Readdone:
    	B _exit                 @ exit 
    
_exit:  
    	MOV R7, #4             
   	MOV R0, #1              
    	MOV R2, #21            
   	LDR R1, =exit_str       
    	SWI 0                   @ execute syscall
    	MOV R7, #1              @ terminate syscall, 1
    	SWI 0                   

_scanf:
	PUSH {LR}               
    	SUB SP, SP, #4          
    	LDR R0, =format_str     @ R0 contains address string
        MOV R1, SP              @ move SP to R1 
        BL scanf                @ call scanf
        LDR R0, [SP]            @ load value at SP into R0
    	ADD SP, SP, #4          r
    	POP {PC}                @ return value	

_printf:
    	PUSH {LR}               @ store the return address
    	LDR R0, =printf_str     
    	BL printf               @ call printf
    	POP {PC}                



.data

.balign	4

array_a:	.skip		80
array_b:        .skip           80
format_str:	.asciz		"%d"
printf_str:	.asciz		"array_a[%d] = %d, array_b = %d\n"
exit_str:       .ascii     	 "Terminating the program.\n"
