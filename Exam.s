/******************************************************************************
* ProgramExam _cse2312
* @AUTHOR Deva Timsina
* ID:1001098066
* PROGRAM EXAM
******************************************************************************/


.global main
.func main
   
main:

    BL prompt_integers
    BL storing_integers
    MOV R7, R0
    MOV R0, #0              @ initialze index variable
    
prompt_integers:
  PUSH {LR}                       @ store LR since printf call overwrites
  LDR R0,=prompt_statement        @ R0 contains formatted string address
  BL printf                       @ call printf
  POP {PC}                        @ return

storing_integers:
  MOV R4, LR                      @ store LR since scanf_procedure call overwrites LR, R0, R1
  MOV R5, #0                      @ initialize loop counter
  store_loop: 
       BL _scanf        @ get a number from console
       PUSH {R0}                  @ push the number to the stack
       ADD R5, R5, #1             @ increment loop counter
       CMP R5, #10                @ check for end of loop
       BNE store_loop             @ loop if necessary
       MOV PC, R4                 @ return







readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =array_a        @ get address of array_a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address  
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
    
readdone:
    B _exit                 @ exit if done


_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_scanf:
  PUSH {LR}                 @ store LR since scanf call overwrites
  SUB SP, SP, #4            @ make room on stack
  LDR R0, =scanf_str        @ R0 contains address of format string
  MOV R1, SP                @ move SP to R1 to store entry on stack
  BL scanf                  @ call scanf
  LDR R0, [SP]              @ load value at SP into R0
  ADD SP, SP, #4            @ restore the stack pointer
  POP {PC}                  @ return


_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

   
.data

.balign 4
array_a:              .skip       40
printf_str:           .asciz      "array_a[%d] = %d\n"
scanf_str:             .asciz     "%d"
result_statement:	 .asciz 	  "Minimum = %10d\n  Maximum = %10d\n Sum = %10d\n"
exit_str:             .ascii      "Terminating program.\n"


