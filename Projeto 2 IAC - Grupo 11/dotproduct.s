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
        
# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
  li a7, 93            # Exit system call
  ecall                # Terminate program
