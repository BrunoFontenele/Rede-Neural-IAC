.data
# Sample input arrays
# You can change this array to test other values (remember to modify the dimensions in the main)

arr0: .word 3, 2, 17, 1
arr1: .word 2, 4, 6, 8
.text

main:	
    # Set up arguments for dotproduct(arr0, arr1, 4)
    la a0, arr0         # a0 = &arr0
    la a1, arr1         # a1 = &arr1
    li a2, 4            # a2 = number of elements

    jal ra, dotproduct  # Call dotproduct function

    # The result of the dot product is now in a0, 
    
exit:
    li a7, 10     # Exit syscall code
    ecall         # Terminate the program


# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) - Pointer to the start of arr0
#   a1 (int*) - Pointer to the start of arr1
#   a2 (int)  - Number of elements to use	
# Returns:
#   a0 (int)  - The dot product of arr0 and arr1
# Exceptions:
#   - If a2 < 1, exit with error code 38x
# =======================================================
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
        
# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
  li a7, 93            # Exit system call
  ecall                # Terminate program
