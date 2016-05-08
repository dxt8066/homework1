 /******************************************************************************
* ProgramExam _cse2312
* @AUTHOR Deva Timsina
* ID:1001098066
* PROGRAM EXAM
******************************************************************************/
.global main
.func main
   
main:
    MOV R0, #0                @move return value R0

writearray:
    CMP R0, #10            
    BEQ scandone
    MOV R5, R0
    BL _scanf                   @call scanf procedure
    MOV R3, R0 
    MOV R0, R5
    LDR R1, =array_a     	  @R1 contains address of array_a          
    LSL R2, R0, #2
    ADD R2, R1, R2
    STR R3, [R2]
    ADD R0, R0, #1 
    B writearray

scandone:
    MOV R0, #0

_readloop:
    CMP R0, #10            
    BEQ readdone            
    LDR R1, =array_a     @R1 contains address of array_a        
    LSL R2, R0, #2          
    ADD R2, R1, R2          
    LDR R1, [R2] 
    MOV R6, R1          @ store array value for min, max and sum   
    PUSH {R0}               
    PUSH {R1}               
    PUSH {R2}              
    MOV R2, R1              
    MOV R1, R0              
    BL  _printf         @call printf procedure

    POP {R2}                
    POP {R1}                
    POP {R0}
    
    CMP R0, #0
    MOVEQ R7, R6
    CMP R0, #0
    MOVEQ R4, R6
    CMP R0, #0
    MOVEQ R5, #0

    CMP R6, R7
    MOVLT R7, R6

    CMP R6, R4
    MOVGT R4, R6  

    ADD R5, R5, R6      
                    
    ADD R0, R0, #1          
    B   _readloop  

readdone:
    BL _printminmaxsum                 @call printminmaxsum procedure
    B _exit 

_printminmaxsum:
    PUSH {R7}
    PUSH {R4}
    PUSH {R5}
    MOV R1, R7
    BL _printmin                         @call printmin procedure
    MOV R1, R4
    BL _printmax   
    MOV R1, R5
    BL _printsum                         @call printsum procedure
    POP {R7}
    POP {R4}
    POP {R5}

_exit:  
    MOV R7, #4              
    MOV R0, #1              
    MOV R2, #21             
    LDR R1, =exit_str       
    SWI 0                @execute syscall           
    MOV R7, #1              
    SWI 0                  @execute syscall

_scanf:
    MOV R4, LR              
    SUB SP, SP, #4          
    LDR R0, =format_str     
    MOV R1, SP              
    BL scanf                 @call scanf procedure
    LDR R0, [SP]            
    ADD SP, SP, #4          
    MOV PC, R4             @return     

_printf:
    PUSH {LR}               
    LDR R0, =printf_str     
    BL printf               
    POP {PC}  

_printmax:
    PUSH {LR}               
    LDR R0, =printf_max    
    BL printf               
    POP {PC}  

_printmin:
    PUSH {LR}               
    LDR R0, =printf_min   
    BL printf               
    POP {PC}  

_printsum:
    PUSH {LR}               
    LDR R0, =printf_sum    
    BL printf               
    POP {PC}    

.data

.balign 4
array_a:		.skip       40	
format_str: 	.asciz 		"%d"	
printf_str:     .asciz      "array_a[%d] = %d\n"
printf_min:     .asciz      "minimum = %d\n"
printf_max:     .asciz      "maximum = %d\n"
printf_sum:     .asciz      "sum = %d\n"
exit_str:       .ascii      "Terminating program.\n"
