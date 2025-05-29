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
    li a7, 93                    # Exit system call
    ecall                        # Terminate programm

exit_with_error_41:
    li a0, 41                    # Erro 41
    li a7, 93                    # Exit system call
    ecall                        # Terminate programm
