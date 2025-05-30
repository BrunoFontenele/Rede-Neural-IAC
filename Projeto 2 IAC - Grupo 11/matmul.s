.data
# You can change this array to test other values (remember to modify the dimentions in the main)
m0: .word 1, 2, 3, 4, 5, 6        # Matrix A (2x3) in row-major order
m1: .word 7, 8, 9, 10, 11, 12     # Matrix B (3x2) in row-major order
d:  .word 0, 0, 0, 0              # Output matrix C (2x2), initialized to 0

.text
main:
  # Load pointers to matrices
  la a0, m0                     # a0 = address of matrix A
  la a1, m1                     # a1 = address of matrix B
  la a6, d                      # a6 = address of output matrix C

  # Load matrix dimensions
  li a2, 2                      # a2 = rows of A = 2
  li a3, 3                      # a3 = cols of A = 3
  li a4, 3                      # a4 = rows of B = 3
  li a5, 2                      # a5 = cols of B = 2
  
  # Load input type 
  jal ra, matmul                # Call matrix multiplication function

  # The contents of matrix d now have the result of matmul(m0,m1)

exit:
  li a7, 10              # Exit syscall code
  ecall                  # Terminate the program

dotproduct:
    # t0 - pointer to array 2
    # t1 - array 1 element
    # t2 - array 2 element
    # t3 - sum
    # t4 - step
    # t5 - counter

    blez a2, exit_with_error_38 #verifying error
    
    #Preparing registers
    mv t0, a1
    mv t1, x0
    mv t2, x0
    mv t3, x0
    slli t4, a3, 2 #converting step to bytes
    mv t5, x0 
    
    jump_loop_dotprod:
        lw t1, 0(a0)
        lw t2, 0(t0)
        mul t1, t1, t2
        add t3, t3, t1 #doing the sum
        addi t5, t5, 1 #adding the counter
        addi a0, a0, 4 #going to the next column in array 1
        add t0, t0, t4 #going to the next line in array 2
        bne t5, a2, jump_loop_dotprod #reached the end
        
    end_dotprod:
        mv a0, t3
        jr ra
        
    exit_with_error_38:
        li a0, 38
        j exit_with_error

# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
#
# Arguments:
#   a0 (int*)  - pointer to the start of m0     (Matrix A)
#   a1 (int*)  - pointer to the start of m1     (Matrix B)
#   a2 (int)   - number of rows in m0 (A)             [rows_A]
#   a3 (int)   - number of columns in m0 (A)          [cols_A]
#   a4 (int)   - number of rows in m1 (B)             [rows_B]
#   a5 (int)   - number of columns in m1 (B)          [cols_B]
#   a6 (int*)  - pointer to the start of d            (Matrix C = A x B)
#
# Returns:
#   None (void); result is stored in memory pointed to by a6 (d)
#
# Exceptions:
#  - If the height or width of any of the matrices is less than 1, 
#    this function terminates the program with error core 38
#  - If the number of columns in matrix A is not equal to the number 
#    of rows in matrix B, it terminates with error code 38
# =======================================================
matmul:
    

# s0 - Pointer to Matrix 1
# s1 - Pointer to Matrix 2 
# s2 - Pointer to Static Matrix 2
# s3 - Internal counter
# s4 - External counter
# s5 - step
# s6 - number of rows in matrix 1

    blez a2, exit_with_error_39
    blez a3, exit_with_error_39
    blez a4, exit_with_error_39    
    blez a5, exit_with_error_39
    bne a3, a4, exit_with_error_40
    
    #Preparing registers
    addi sp, sp, -4
    sw ra, 0(sp)
    mv s0, a0 
    mv s1, a1 
    mv s2, a1 
    mv s3, x0 
    mv s4, x0 
    slli s5, a3, 2 #converting step to bytes
    mv s6, a2

    
    loop_mat:
        mv a0, s0 #restarting matrix 1
        mv a1, s1 #restarting matrix 2
        mv a3, a5 #setting step for dotprod
        mv a2, a4 #setting number of elements for dotprod
        jal dotproduct
        sw a0, 0(a6) #storing answer in the final matrix
        addi s3, s3, 1 #adding internal counter
        addi s1, s1, 4 #going to the next column of matrix 2
        beq s3, a5, loop_end #ending of matrix 2 was reached
        addi a6, a6, 4 #going to the next element of final matrix
        
    loop_end:
        mv s3, x0 #restarting internal counter
        mv s1, s2 #restarting matrix 2
        add s0, s0, s5 #going to the next column of matrix 1
        addi s4, s4, 1 #adding external counter
        beq s4, s6, end_mat #reached the last line of matrix 1
        addi a6, a6, 4 #going to the next element of final matrix
        j loop_mat
        
    end_mat:
        lw ra, 0(sp)
        addi sp, sp, 4
        jr ra
        
    exit_with_error_39:
        li a0, 39
        j exit_with_error

    exit_with_error_40:
        li a0, 40
        j exit_with_error
