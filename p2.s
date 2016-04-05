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
  BL main                         
  
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
  MOV R9, R2                  @move value from argument register R2 to R9       
  B initial_loop              @brach to initial_loop procedure  
  gcdmod_loop:
      MOV R1, R10             @move value R10 to argument register R1    
      MOV R2, R11             @move value R11 to argument register R2  
      SUB R9, R9, #1          @subtract 1 from R9 and store at R9
      B initial_loop          @brach to initial_loop procedure
  initial_loop:         
    B mod_checkloop1          @brach to mod_checkloop1  
    mod_loop1:                  
        SUB R1, R1, R9        @subract R9 from R1 and store at R1  
    mod_checkloop1:
        CMP R1, R9            @compare R1 and R9 for loop termination
        BHS mod_loop1         @brach to mod_loop1 if R1 >= R9
    B mod_checkloop2          @brach to mod_checkloop2 procedure
    mod_loop2:      
        SUB R2, R2, R9        @subtract R9 from R2 and store at R2  
    mod_checkloop2:
        CMP R2, R9            @compare R2 and R9 for loop termination
        BHS mod_loop2         @brach to mod_loop2 if R2 >= R9  
        
    MOV R6, R1                  @move value from argument register R1 to register R6
    MOV R7, R2                  @move value from argument register R1 to register R7
    CMP R6, #0                  @compare R6 and 0
    BNE gcdmod_loop             @brach not equal handler
    CMP R7, #0                  @compare R7 and 0
    BNE gcdmod_loop             @brach not equal handler
    
    MOV R0, R9                @move remainder to R0
    MOV PC, LR                @return

.data
scanf_statement:        .asciz    "%d"
prompt_statement:       .ascii    "Please insert a number and press Enter:"
printf_statement:       .asciz    "The GCD of two integers is: %d\n"
