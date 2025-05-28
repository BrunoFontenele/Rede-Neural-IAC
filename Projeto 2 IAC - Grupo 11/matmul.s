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


#argumento opcional: a3 - representa o deslocamento da
#segunda função (step).

# t0 - ponteiro matriz 2
# t1 - elemento da matriz 1
# t2 - elemento da matriz 2
# t3 - soma
# t4 - step
# t5 - contador

dotproduct:
    blez a2, exit_with_error38
    mv t0, a1
    mv t1, x0
    mv t2, x0
    mv t3, x0
    slli t4, a3, 2 #convertendo em bytes
    mv t5, x0 #preparando contador
    bne a3, x0, jump_loop #se o step não for 0, iremos ver
    #os elementos da coluna
    normal_loop:
        beq t5, a2, end #chegamos no fim do vetor
        lw t1, 0(a0)
        lw t2, 0(t0)
        mul t1, t1, t2
        add t3, t3, t1
        addi t5, t5, 1 #aumentando contador
        addi a0, a0, 4 #andando no vetor 1
        addi t0, t0, 4 #andando no vetor 2
        j normal_loop
     jump_loop:
        beq t5, a2, end #chegamos no fim do vetor
        lw t1, 0(a0)
        lw t2, 0(t0)
        mul t1, t1, t2
        add t3, t3, t1
        addi t5, t5, 1 #aumentando contador
        addi a0, a0, 4 #andando no vetor 1
        add t0, t0, t4 #deslocando no vetor 2
        j jump_loop
    end:
        mv a0, t3
        jr ra
        
    exit_with_error38:
      li a0, 38
      li a7, 93            # Exit system call
      ecall                # Terminate program
         

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
    

# s0 - ponteiro para matriz 1
# s1 - ponteiro para matriz 2 (se move)
# s2 - ponteiro para matriz 2 (estatico)
# s3 - contador interno
# s4 - contador externo
# s5 - deslocamento (step)

    blez a2, exit_with_error_39
    blez a3, exit_with_error_39
    blez a4, exit_with_error_39    
    blez a5, exit_with_error_39
    bne a3, a4, exit_with_error_40
    
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a2, 4(sp)
    mv s0, a0 #guardando matriz 1
    mv s1, a1 #guardando matriz 2
    mv s2, a1 #guardando matriz 2 (estatico)
    mv s3, x0 #preparando contador interno
    mv s4, x0 #preparando contador externo
    slli s5, a3, 2 #preparando step

    
    loop_mat:
        mv a0, s0 #reiniciando a0
        mv a1, s1 #reiniciando a1
        add a3, a5, x0 #guardando step do dotproduct
        add a2, a4, x0
        jal dotproduct
        sw a0, 0(a6) #guardando resultado na matriz final
        addi s3, s3, 1 #aumentando contador interno
        addi s1, s1, 4 #saltando para a proxima coluna da segunda
        beq s3, a5, loop_end #atingimos o fim da segunda matriz
        addi a6, a6, 4 #indo para o proximo elemento do resultado
        j loop_mat
        
    loop_end:
        mv s3, x0 #reiniciando contador interno
        mv s1, s2 #reiniciando segunda matriz
        add s0, s0, s5 #indo para a proxima linha da matriz 1
        addi s4, s4, 1 #aumentando contador externo
        lw a2, 4(sp)
        beq s4, a2, end_mat #chegamos na ultima linha da primeira matriz
        addi a6, a6, 4 #indo para o proximo elemento do resultado
        j loop_mat
        
    end_mat:
        lw ra, 0(sp)
        addi sp, sp, 8
        jr ra
        
# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error_39:
  li a0, 39
  li a7, 93            # Exit system call
  ecall                # Terminate program

exit_with_error_40:
  li a0, 40
  li a7, 93            # Exit system call
  ecall                # Terminate program
