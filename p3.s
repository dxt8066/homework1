
/******************************************************************************
* @This program prompts user for two integers and find GCD 
******************************************************************************/

.global main
.func main

main:
  BL prompt_integer           @branch to prompt_integer procedure with return                 
  BL scanf_procedure          @branch to scanf_procedure with return
  MOV R10, R0                 @move return value R0 to register R10
  
  BL prompt_integer           @branch to prompt_integer procedure with return
  BL scanf_procedure          @branch to scanf_procedure with return
  MOV R11, R0                 @move return value R0 to register R11

  MOV R1, R10                 @move value R10 to argument register R1  
  MOV R2, R11                 @move value R11 to argument register R2      
  BL Gcd_iterative            @branch to Gcd_iterative procedure with return        
  MOV R1, R0                  @move return value R0 to argument register R1      
  BL printf_result            @branch to printf_result procedure with return      
  BL main                     @branch to main procedure for continuous loop
  
@scanf_procedure is procedure which takes user input and store at R0 
scanf_procedure:                        
  MOV R4, LR                  @store LR since scanf call overwrites          
  SUB SP, SP, #4              @makes room at stack
  LDR R0, =scanf_statement    @R0 contains address of scanf_statement
  MOV R1, SP                  @move SP to R1 to store entry on stack
  BL scanf                    @call scanf procedure
  LDR R0, [SP]                @load value into R0 from SP
  ADD SP, SP, #4              @restore the stack pointer
  MOV PC, R4                  @return
  
@prompt_integer procedure prompts the user with print statement to input integer
prompt_integer:               
  MOV R7, #4                  @write syscall, 4            
  MOV R0, #1                  @output stream to monitor, 1
  MOV R2, #39                 @length of print string
  LDR R1, =prompt_statement   @string at prompt_statement  
  SWI 0                       @execute syscall    
  MOV PC, LR                  @return 
  
@printf_result procedure prints string at printf_statement 
printf_result:
  MOV R4, LR                  @store LR since printf call overwrites
  LDR R0, =printf_statement   @R0 contains address of printf_statement  
  MOV R1, R1                  @R1 contains printf argument
  BL printf                   @call printf procedure
  MOV PC, R4                  @return

@Gcd_iterative procedure computes GCD and returns GCD value at R0  
Gcd_iterative:
    PUSH {LR}                 @store the return address
    CMP R2, #0                @compare the input integer store at argument register R1 with 0
    MOVEQ R0, R1              @set return value to 1 if equal after comparison  
    POPEQ {PC}                @restore stack pointer and return if equal
    
    CMP R1, R2                @compare values at argument registers R1 and R2  
    MOVHS R3, #1              @set return value to 1 if higher or same
    CMP R2, #0                @compare value at argument register R2 with 0
    MOVGT R4, #1              @set return value to 1 if greater than
    B mod_loopcheck           @brach to mod_loopcheck procedure
    mod_loop:                   
        SUB R1, R1, R2        @subtract value at argument register R2 from R1 and store at argument register R1
    mod_loopcheck:
        CMP R1, R2            @compare values at argument registers R1 and R2   
        BHS mod_loop          @brach to mod_loop if higher or same
        MOV R0, R1            @move value from argument register R1 to return register R0
        
    MOV R1, R2                @move value from argument register R2 to register R1 
    MOV R2, R0                @move value from return register R0 to argument register R1    
    CMP R3, R4                @compare value at register R3 and R4
    MOV R3, #0                @set value at register R3 to 0
    MOV R4, #0                @set value at register R4 to 0
    BEQ Gcd_iterative         @brach to Gcd_iterative procedure
    POP {PC}                  @restore stack pointer and return

.data
scanf_statement:        .asciz    "%d"
prompt_statement:       .ascii    "Please insert a number and press Enter:"
printf_statement:       .asciz    "The GCD of two integers is: %d\n"
