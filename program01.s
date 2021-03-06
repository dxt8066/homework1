/******************************************************************************
* Program01 _cse2312
*  Following operations are performed on this program:
* >> SUM: Adds registers R1 and R2, returning result in register R0.
* >> DIFFERENCE: Subtracts register R2 from R1, returning result in register R0. 
* >> PRODUCT: Multiplies registers R1 and R2, returning the result in register R0.
* >> MAX: Compares two registers R1 and R2, returning the maximum of the two values in R0
* @AUTHOR Deva Timsina
* ID:1001098066
* PROGRAM 01
******************************************************************************/


.global main 
.func main

main:
  BL prompt_integer           @branch to prompt_integer procedure with return                 
  BL scanf_procedure          @branch to scanf_procedure with return
  MOV R6, R0                  @move return value R0 to argument register R1
  
  BL prompt_integer           @branch to prompt_integer procedure with return
  BL scanf_procedure          @branch to scanf_procedure with return
  MOV R8, R0                  @move return value R0 to argument register R2
  
  BL prompt_operator          @branch to prompt_integer procedure with return
  BL store_operator           @branch to scanf_procedure with return
  MOV R3, R0                  @move return value R0 to argument register R2
  
  
  MOV R1, R6                  @move value to argument register R1  
  MOV R2, R8                  @move value to argument register R2 
  
  
  BL compare_operator         @branch to compare_operator with return              
  MOV R1, R0                  @move return value R0 to argument register R1      
  BL printf_result            @branch to printf_result with return
  B main                      @branch to main procedure for loop
  

@prompt_integer procedure prompts the user with print statement to input integer
prompt_integer:               
  MOV R7, #4                  @write syscall, 4            
  MOV R0, #1                  @output stream to monitor, 1
  MOV R2, #39                 @length of print string
  LDR R1, =prompt_statement   @string at prompt_statement  
  SWI 0                       @execute syscall    
  MOV PC, LR                  @return  
  
  
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
  
  
@printf_result procedure prints string at printf_statement 
printf_result:
  MOV R4, LR                  @store LR since printf call overwrites
  LDR R0, =printf_statement   @R0 contains address of printf_statement  
  MOV R1, R1                  @R1 contains printf argument
  BL printf                   @call printf procedure
  MOV PC, R4                  @return
  

@add_operation procedure Adds registers R1 and R2, returning result in register R0
add_operation:
  ADD R0, R1, R2              @Adds registers R1 and R2, returning result in register R0
  MOV PC, LR                  @return
  
  
@subtraction_operation procedure Subtracts register R2 from R1, returning result in register R0
subtraction_operation:
  SUB R0, R1, R2              @Subtracts register R2 from R1, returning result in register R0
  MOV PC, LR                  @return  
  
 
@multiplication_operation procedure Multiplies registers R1 and R2, returning the result in register R0.
multiplication_operation:
  MUL R0, R1, R2              @Multiplies registers R1 and R2, returning the result in register R0.      
  MOV PC, LR                  @return   
  
  
@compare_max procedure Compares registers R1 and R2, returning the maximum of the two values in R0 
compare_max:  
  CMP R1, R2                  @Compares registers R1 and R2,      
  MOVGT R0, R1                @move greater than          
  MOVLT R0, R2                @move less than        
  MOV PC, LR                  @return    
  
 
@store_operator 
store_operator:
  MOV R7, #3                  @write syscall, 3                      
  MOV R0, #0                  @input stream from monitor, 0          
  MOV R2, #1                  @read a single character            
  LDR R1, =operation_type     @store the character in data memory          
  SWI 0                       @execute the system call        
  LDR R0, [R1]                @move the character to the return register R0        
  AND R0, #0xFF               @mask out all but the lowest 8 bits      
  MOV PC, LR                  @return  
  

@prompt_operator procedure prompts with user with print statement to input character for operation   
prompt_operator:
  MOV R7, #4                  @write syscall, 4                
  MOV R0, #1                  @output stream to monitor, 1
  MOV R2, #108                @length of print string      
  LDR R1, =printf_operator    @string at label printf_operator          
  SWI 0                       @execute syscall        
  MOV PC, LR                  @return 
  
    
@compare_operator procedure compares the user input character and perfroms the operation    
compare_operator:
  CMP R3, #'+'                @compare the user input with '+'   
  BEQ add_operation           @branch to equal handler, add_operation      
  CMP R3, #'-'                @compare the user input with '-'        
  BEQ subtraction_operation   @branch to equal handler, subtraction_operation      
  CMP R3, #'*'                @compare the user input with '*'           
  BEQ multiplication_operation  @branch to equal handler, multiplication_operation       
  CMP R3, #'M'                @compare the user input with 'M'      
  BEQ compare_max             @branch to equal handler, compare_max 
  BNE main                    @brach to not equal handler, main procedure
  MOV PC, R4                  @return  
  
  
.data
operation_type:         .asciz    " "
scanf_statement:        .asciz    "%d"
prompt_statement:       .ascii    "Please insert a number and press Enter:"
printf_statement:       .asciz    "The Final result is: %d\n"
printf_operator:        .asciz    "Insert the type of operation '+' for addition, '-' for subtraction, '*' for multiplication, 'M' for Maximum:"
