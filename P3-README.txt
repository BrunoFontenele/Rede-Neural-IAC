# ===========================================================
# Identificação do grupo: 11
#
# Membros [istID, primeiro + ultimo nome]
# 1. ist1114584- Beatriz Alves
# 2. ist1114263- Beatriz Medvedyuk
# 3. ist1113976- Bruno Fontenele
$
# ===========================================================
# Descrição da ISA Implementada
#
# == Formato das Instruções ==
# - 2 bits para o opcode das instruções que necessitam de imediato (li, addi e subi), sendo esse
# o número mínimo possível para o opcode nessas situações.
# - 4 bits para o opcode das intruções que não necessitam de imediato (abs e relu). Foram utilizados
# 4 por conta da comparação dos multiplexers dos casos em que o opcode é 11X, se fosse 1 bit extra
# acabaria existindo conflito com os opcodes de 2 bits.
#
# == Sumario dos Estagios do Pipeline==
# - PC Counter: Contador que avança as instruções da ROM.
# - ROM: Local onde as instruções estão escritas e são lidas.
# - Distribuidor: Separa os bits das instruções, assim permitindo analisar o opcode e o imediato (se for necessário).
# - Extensor de Sinal: Extende o imediato de 6 para 8 bits (signed)
# - Registro R1: Registro do processador, armazena o valor atual.
# - ALU: Realiza as operações de soma, subtração, abs e RELU.
# - Control Unit: Analisa o Opcode, buscando um bit extra se necessário e enviando a operação para a ALU.
#
# == Sinais de Controlo ==
# Explicar o que cada sinal ativa/desativa/seleciona e como sao gerados.
# - Bit a 1 no PC Counter: Ativa WE do Registro e envia C in para o somador, realizando a soma.
# - Clock: Executa os ciclos e ativa o WE do Registro R1.
# - Distribuidor: Separa os bits da instrução vinda da ROM entre Opcode e Imediato.
# - Blocos da Control Unit: Recebem Opcode (inicialmente 2 bits) e com comparadores se é o Opcode que tem escritas, se sim devolvem o
# número da instrução na ALU. Caso o Opcode seja 11, são utilizados comparadores verifica se é 01 (Abs) ou 10 (RELU). No final, existe uma porta
# OR que recebe apenas um resultado de todos os blocos, indicando qual a operação será escolhida no Multiplexer da ALU.
# - ALU: Realiza soma com um somador (entrada 1 do multiplexer), subtração com o subtrator (entrada 2 do multiplexer),
# faz o absoluto invertendo os bits e somando 1 (complemento para 2) caso o número seja negativo (verifica com um comparador
# com 0) (entrada 3 do multiplexer), faz RELU escolhendo 0 com num multiplexer com o resultado do comparador com 0 (entrada 4 do multiplexer)
# e faz li somando o imediato com 0 (saída do 5 multiplexer). Assim, a operação adequada é escolhida com a saída da Control Unit.
#
# ===========================================================
# Top-3 das otimizacoes que a vossa solucao incorpora:
# (maximo 140 caracteres por cada otimizacao)
#
# 1. Formato único de instruções simplifica a decodificação e reduz a complexidade do circuito.
#
# 2. A ALU foi criada de forma modular, ou seja, todas as operações estão divididas em blocos separados que
# posteriormente serão selecionados por um multiplexer. Isso ajuda caso quisermos adicionar outras intruções futuramente. 
#
# 3. As instruções abs e RELU foram implementadas com uso de multiplexers à parte,
# evitando circuitos redundantes. Em vez de algo complexo, utilizamos um comparador
# simples para verificar o sinal de R1 e um multiplexer que seleciona o valor correto.
#
# ===========================================================

