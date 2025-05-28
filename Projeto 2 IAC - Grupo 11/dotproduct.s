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
    bgtz a2, loop
    li a0, 38
    j exit_with_error
    loop:
        beqz a2, end
        lw t1, 0(a0)
        lw t2, 0(a1)
        mul t1, t1, t2
        add t0, t0, t1
        addi a2, a2, -1
        addi a1, a1, 4
        addi a0, a0, 4
        j loop
    end:
        mv a0, t0
        jr ra
        
# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
  li a7, 93            # Exit system call
  ecall                # Terminate program
