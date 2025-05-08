.data

# You can change this array to test other values

array: .word -3, 0, -1, 7, -2 # Initial array values

.text

main:

la a0, array # a0 = pointer to array
li a1, 5 # a1 = number of elements in the array

jal ra, relu # Call relu function


# Result: the array now has its negative values replaced by zero


exit:

li a7, 10 # Exit syscall code
ecall # Terminate the program


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

# Verificar se o tamanho do vetor é válido

addi x6, x0, 1 # load immediate o valor 1 em t0
blt a1, x6, exit_with_error # Se a1 < 1,erro

addi x6, x6, -1 

# TO DO

start:
    lw x7, 0(a0) 

    bgt x7, x0, end
    sw zero, 0(a0)
    
end:
    addi x6, x6, 1
     beq a1, x6, loop_end
    addi a0, a0, 4
    j start    
    
loop_end:
  jr ra                  # normal return


# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
  li a0, 36
  li a7, 93            # Exit system call
  ecall                # Terminate program
