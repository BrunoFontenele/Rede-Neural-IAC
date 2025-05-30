# ===========================================================
# Identificacao do grupo: T11
#
# Membros [istID, primeiro + ultimo nome]
# 1. Beatriz Alves
# 2. Beatriz Medvedyuk
# 3. Bruno Fontenele
#
# ===========================================================
# Requisitos do enunciado que *nao* estao corretamente implementados:
# (indicar um por linha, ou responder "nenhum")
# - Nenhum
# ===========================================================
# Top-5 das otimizacoes que a vossa solucao incorpora:
# (maximo 140 caracteres por cada otimizacao)
#
# 1. Nao usar o stack no matmul
#
# 2. usar xor ao colocar uma variavel a 0
#
# 3. equ dos numeros
#
# 4.
#
# 5.
#
# ===========================================================

.data

# ===========================================================
#Main data structures. These definitions cannot be changed.

#1000954


h_m0: .word 128
w_m0: .word 784
m0: .zero 401408                #h_m0 * w_m0 * 4 bytes

h_m1: .word 10
w_m1: .word 128
m1: .zero 5120                 #h_m1 * w_m1 * 4 bytes

h_input: .word 784
w_input: .word 1             #h_input * w_input * 4 bytes
input: .zero 3136

h_h: .word 128 
w_h: .word 1
h: .zero 512                    #h_h * w_h * 4 bytes

h_o: .word 10
w_o: .word 1
o: .zero 40                     #h_o * w_o * 4 bytes

# ===========================================================
# Here you can define any additional data structures that your program might need

filename: .string "C:\Users\beatr\OneDrive\Ambiente de Trabalho\IAC\classifier-files\classifier-files\input-images\output0.pgm"
path_m0: .string "C:\Users\beatr\Downloads\classifier-files\weight-matrices\m0.bin"
path_m1: .string "C:\Users\beatr\Downloads\classifier-files\weight-matrices\m1.bin"

input_byte_zero:    .zero 784
m0_byte_zero:    .zero 401408
m1_byte_zero:    .zero 5120 

 
# ===========================================================
.text

main:
    la a0, path_m0
    la a1, path_m1
    la a2, filename
    # Set up arguments for *classify* function
    #temos de dar load aqui
    #
    # TODO
    #

    # Call *classify* function
    # TODO
    #

    jal classify
    j exit
    

# ===========================================================
# FUNCTION: abs
#   Computes absolute value of the int stored at a0
# Arguments:
#   a0, a pointer to int
# Returns:
#   Nothing (modifies value in memory)
# ===========================================================

abs:
  lw t0, 0(a0)         # Load int value
  bge t0, zero, done_abs   # If value >= 0, skip negation
  sub t0, x0, t0       # t0 = -t0
  sw t0, 0(a0)         # Store back to memory

done_abs:
  jr ra # Return to the caller
    

# ============================================================
# FUNCTION: relu
#   Applies ReLU on each element of the array (in-place)
# Arguments:
#   a0 = pointer to int array
#   a1 = array length
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ============================================================
relu:

# x6 - index counter
# x7 - word in vector

blez a1, exit_with_error_36 #verifying vector size

li x6, 0 # initiliaze counter

loop_start_relu:
    lw x7, 0(a0) #read word in vector
    bgtz x7, loop_end_relu #verifying if word is positive
    sw zero, 0(a0) #storing zero instead of word
    
loop_end_relu:
    addi x6, x6, 1 #going to the next index
    beq a1, x6, end_relu #if index counter reaches vector length
    addi a0, a0, 4 #going to the next vector position
    j loop_start_relu    
    
end_relu:
  jr ra # normal return
  
exit_with_error_36:
 li a0, 36 #loading error 36
 j exit_with_error


# =================================================================
# FUNCTION: Argmax
#   Given an int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the number of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 37
# =================================================================
argmax:
    
# x6 - index counter
# x7 - word in index
# x8 - greatest element
# x9 - greatest element index

blez a1, exit_with_error_argmax #if vector length is invalid

lw x7, 0(a0) #reading word in the first index
add x8, x0, x7 #keeping the greatest element
li x9, 0 #keeping the greatest element index
li x6, 1 #initializing index counter

addi a0, a0, 4 #going to the second element
#if the element is less than the greatest
loop_start_argmax:
    lw x7, 0(a0) 
    bge x8, x7, loop_end_argmax
    add x8, x0, x7 #changing the greatest element
    add x9, x0, x6 #changing the greatest element index
    
loop_end_argmax:
    addi x6, x6, 1 #going to the next element index
    beq x6, a1, end_argmax #if the end of the vector has been reached
    addi a0, a0, 4 #going to the next element
    j loop_start_argmax

end_argmax:
    add a0, x0, x9 #storing the greatest element in a0
    jr ra # Return to the caller

exit_with_error_argmax:
    li a0, 37 #invalid vector size error
    j exit_with_error

# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) - Pointer to the start of arr0
#   a1 (int*) - Pointer to the start of arr1
#   a2 (int)  - Number of elements to use   
#   a3 (int)  - Step of the second vector (optional)
# Returns:
#   a0 (int)  - The dot product of arr0 and arr1
# Exceptions:
#   - If a2 < 1, exit with error code 38
# =======================================================
dotproduct:
    # t0 - ponteiro matriz 2
    # t1 - elemento da matriz 1
    # t2 - elemento da matriz 2
    # t3 - soma
    # t4 - step
    # t5 - contador

    blez a2, exit_with_error_38
    mv t0, a1
    mv t1, x0
    mv t2, x0
    mv t3, x0
    slli t4, a3, 2 #convertendo em bytes
    mv t5, x0 #preparando contador
     jump_loop_dotprod:
        lw t1, 0(a0)
        lw t2, 0(t0)
        mul t1, t1, t2
        add t3, t3, t1
        addi t5, t5, 1 #aumentando contador
        addi a0, a0, 4 #andando no vetor 1
        add t0, t0, t4 #deslocando no vetor 2
        bne t5, a2, jump_loop_dotprod #chegamos no fim do vetor
        
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
#    this function terminates the program with error core 39
#  - If the number of columns in matrix A is not equal to the number 
#    of rows in matrix B, it terminates with error code 40
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
        
exit_with_error_39:
  li a0, 39
  j exit_with_error

exit_with_error_40:
  li a0, 40
  j exit_with_error


######################################################################
# Function: read_file(char* filename, byte* buffer, int length)
# Input:
#   a0: pointer to null-terminated filename string
#   a1: destination buffer
#   a2: number of bytes to read
# Output:
#   a0: number of bytes read (return value from syscall)
# Exceptions:
#   - Error code 41 if error in the file descriptor
#   - Error code 42 If the length of the bytes to read is less than 1
######################################################################

read_file:
    
    li t0, 1
    blt a2, t0, exit_with_error_42    # Número de bytes passados menor que 1

    mv t1, a1    # Guarda buffer pointer
    mv t2, a2    # Guarda lenght

    li a1 0       # Flag read only
    li a7 1024    # Open (muda a0 para file descriptor)
    ecall

    blt a0, zero, exit_with_error_41    # Open devolve erro se file descriptor < 0
    mv t0, a0    # Guarda file descriptor
    mv a1, t1    # Repor ponteiro buffer
    mv a2, t2    # Repor lenght

    li a7, 63    # Read ficheiro (muda a0 para numero de bytes)
    ecall

    blt a0, zero, exit_with_error_41    # Read devolve erro se byte lidos < 0

    mv t3, a0    # Salva número de bytes lidos
    mv a0, t0    # Move file descriptor de novo para a0

    li a7, 57    # Close ficheiro
    ecall

    mv a0, t3    # Coloca número de bytes lidos em a0
    jr ra


exit_with_error_42:
    li a0, 42                    # Erro 42
    j exit_with_error                      # Terminate programm

exit_with_error_41:
    li a0, 41                    # Erro 41
    j exit_with_error          # Terminate programm
    
    jr ra                    # Return to the caller




# =======================================================
# FUNCTION: Classify decimal digit from input image
#   d = classify(A, B, input)
#
# Arguments:
#   a0 (string*)  - pathname of file with the weight matrix m0
#   a1 (string*)  - pathname of file with the weight matrix m1
#   a2 (string*)  - pathname of file with the input image in Raw PGM format
#
# Returns:
#   a0 (int) - value of the classified decimal digit
#
# =======================================================

# t0 - endereço do input
# a2 - tamanho do input
# a0 - filename
# t1 - elemento
# t2 - contador

classify:
    #passo 1 do algoritmo
    #lendo m0
    addi sp,sp,-4
    sw ra,0(sp)
    #sw #guardar todos 
    la a0, path_m0
    la a1, m0_byte_zero
    lw t0, h_m0
    lw t1, w_m0
    mul a2, t0, t1
    jal read_file
    
    #convertendo m0
    la a0, m0
    li a3, 1 #0
    jal cast_array_to_int
    
    #lendo m1
    la a0, path_m1
    la a1, m1_byte_zero
    lw t0, h_m1
    lw t1, w_m1
    mul a2, t0, t1
    jal read_file
    
    #convertendo m1
    la a0, m1
    li a3, 1 #0
    jal cast_array_to_int
    
    #lendo input
    la a0, filename
    la a1, input_byte_zero
    lw t0, h_input
    lw t1, w_input
    mul a2, t0, t1
    addi a2, a2, 12
    jal read_file
    
    #convertendo input
    la a0, input
    li a3, 0 #0
    jal cast_array_to_int
    
    
    #passo 2 do algoritmo
    la a0, m0
    la a1, input
    lw a2, h_m0
    lw a3, w_m0
    lw a4, h_input
    lw a5, w_input
    la a6, h
    jal matmul
    
    #passo 3 do algoritmo
    la a0, h #preparando o endereço de h para o relu
    lw a1, h_h
    jal relu
    
    #passo 4 do algoritmo
    la a0, m1
    lw a2, h_m1
    lw a3, w_m1
    lw a4, h_h
    lw a5, w_h
    la a6, o
    jal matmul
    
    #passo 5 do algoritmo
    la a0, o
    lw a1, h_o
    jal argmax
    
    #passo 6 do algoritmo
    li a7, 1
    ecall
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

#a0 - endereço de chegada
#a1 - endereço de entrada
#a2 - quantidade 
#a3 - flag
#t1 - contador
#t2 - step 
#t3 - elemento lido

#colocar isso como uma grande funcao e colocar cabeçalho
cast_array_to_int:
     li t1,0 #colocando contador a 0
     mv t0, a2
   
loop_cast:
    #lendo o byte
     lb t3, 0(a1) #lemos o primeiro elemento do t3 e guardamos no t0
     
     #flag para imagem
     beq a3,x0,skip_process #verificamos se a4 é menor que 0
     addi t3,t3,-32 #foi somado 32 anteriormente
skip_process:
     sw t3,0(a0) #guardamos o t0 no t3 #guardando o valor corrigido
     addi a1, a1, 1
     addi a0, a0, 4
     
     addi t1,t1,1 #aumentar o contador
     bne t1,a2, loop_cast #se chegarmos no fim
     
     jr ra





# =======================================================
# Exit procedures
# =======================================================

# Exits the program (with code 0)
exit:
    li a7, 10     # Exit syscall code
    ecall         # Terminate the program


# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
  li a7, 93            # Exit system call
  ecall                # Terminate program
