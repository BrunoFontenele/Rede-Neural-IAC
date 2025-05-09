.data
# You can change this array to test other values
array: .word -4, -12, -12, -3, -45, -14   # Initial array values

.text

main:
    la a0, array           # Load address of the array
    li a1, 6           # Number of elements in the array

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
    
# x6 - index counter
# x7 - word in index
# x8 - greatest element
# x9 - greatest element index

blez a1, exit_with_error #if vector length is invalid

lw x7, 0(a0) #reading word in the first index
add x8, x0, x7 #keeping the greatest element
li x9, 0 #keeping the greatest element index
li x6, 1 #initializing index counter

addi a0, a0, 4 #going to the second element
#if the element is less than the greatest
start:
    lw x7, 0(a0) 
    bge x8, x7, end 
    add x8, x0, x7 #changing the greatest element
    add x9, x0, x6 #changing the greatest element index
    
end:
    addi x6, x6, 1 #going to the next element index
    beq x6, a1, loop_end #if the end of the vector has been reached
    addi a0, a0, 4 #going to the next element
    j start

loop_end:
    add a0, x0, x9 #storing the greatest element in a0
    jr ra                        # Return to the caller

# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
    li a0, 36 #invalid vector size error
    li a7, 93                    # Exit system call
    ecall                        # Terminate program
