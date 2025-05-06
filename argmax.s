.data
# You can change this array to test other values
array: .word 5, 9, 10, 9, 2   # Initial array values

.text

main:
    la a0, array           # Load address of the array
    li a1, 5              # Number of elements in the array

    jal ra, argmax         # Call the argmax function

    # Result: the index of the largest element is now in a0

exit:
    li a7, 10              # Exit syscall code
    ecall                  # Terminate the program


# =================================================================
# FUNCTION: Given an int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the number of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    
# x6 - contador
# x7 - elemento
# x8 - maior elemento
# x9 - índice do maior elemento

blez a1, exit_with_error #se o comprimento for menor ou igual a 0

li x6, 1 #iniciando contador, ja vimos o primeiro
lw x7, 0(a0) #lendo o primeiro elemento
add x8, x0, x7 #guardando o primeiro elemento como o maior
li x9, 0 #indice do maior elemento

addi a0, a0, 4 #indo para o segundo elemento
beq x6, a1, loop_end 

start:
    lw x7, 0(a0) 
    bgeu x8, x7, end #caso o elemento salvo continue sendo o maior, ir pro fim
    add x8, x0, x7 #muda o maior elemento
    add x9, x0, x6 #muda o indice do maior elemento
end:
    addi x6, x6, 1 #ir para o proximo indice
    beq x6, a1, loop_end #caso tenhamos acabado o vetor
    addi a0, a0, 4 #ir para o proximo elemento
    j start

loop_end:
    jr ra                        # Return to the caller

# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
    li a0, 36 #tamanho inválido do vetor
    li a7, 93                    # Exit system call
    ecall                        # Terminate program
