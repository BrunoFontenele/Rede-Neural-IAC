# ===========================================================
# Identificação do grupo: 11
#
# Membros [istID, primeiro + ultimo nome]
# 1. ist1114584- Beatriz Alves
# 2. ist1114263- Beatriz Medvedyuk
# 3. ist1113976- Bruno Fontenele
$
# ===========================================================
# AVISO
#
# Para funcionar corretamente, é necessário alterar alguns valores já que estes 
# são reiniciados automaticamente quando o programa é fechado. Portanto,
# coloque os valores indicados pelos comentários a vermelhos nos locais próximos ao comentário.
#
# ===========================================================
# Descrição da ISA Implementada
#
# == Formato das Instruções ==
#
# - 2 bits para o Opcode das instruções que necessitam de imediato (li, addi e subi), sendo esse
# o número mínimo possível para o Opcode nessas situações.
# - 3 bits para o Opcode das intruções que não necessitam de imediato (abs e relu). O terceiro bit foi utilizado para a distinção entre o abs e o relu pois ambos têm os mesmos dois primeiros bits.
#
# == Sumario dos Estagios do Pipeline==
# 
# O processador é de ciclo único, ou seja, não possui pipelining. A implementação do Pipelining foi desconsiderada
# por não só ter sido pouco explorada nas aulas como por exigir diversas implementações adicionais, incluindo mais registros, 
# podendo ser desnecessário considerando a quantidade reduzida de estágios que o processador possui.
#
# - Instruction Fetch: 
# 	- PC Counter - Contador que avança as instruções da ROM.
# - Instruction Decode:
# 	- ROM: Local onde as instruções estão escritas e são lidas.
# 	- Distribuidor: Separa os bits das instruções, assim permitindo analisar o opcode e o imediato (se for necessário).
# 	- Extensor de Sinal: Extende o imediato de 6 para 8 bits (signed)
# - Execute:
# 	- ALU: Realiza as operações de soma, subtração, abs e RELU.
# 	- Control Unit: Analisa o Opcode, utilizando um bit extra se necessário e enviando a operação para a ALU.
# - Write Back:
# 	- Registro R1: Registro do processador, armazena o valor atual.
#
# == Opcode das Instruções ==
# 
# 00 - Li
# 01 - Addi
# 10 - Subi
# 110 - Abs
# 111 - RELU
#
# == Sinais de Controlo ==
# - Bit a 1 no PC Counter: Ativa WE do Registro e envia C in para o somador, realizando a soma.
# - Clock: Executa os ciclos e ativa o WE do Registro R1.
# - Distribuidor: Separa os bits da instrução vinda da ROM entre Opcode e Imediato.
# - Blocos da Control Unit: Recebem o Opcode (inicialmente 2 bits) e através de 4 comparadores verifica qual é o Opcode respetivo, após isso produz control signals de 3 bits que posteriormente serão enviados para a ALU. Caso o Opcode seja 11, são utilizados comparadores que verificam se o terceiro bit é 0 (Abs) ou 1 (RELU). No final, existe uma porta
# OR que recebe os resultado de todos os blocos e indica qual a operação escolhida para a Multiplexer da ALU.
# - ALU: Realiza soma com um somador (entrada 1 do multiplexer), subtração com o subtrator (entrada 2 do multiplexer),
# faz o absoluto com o bloco negador caso o número seja negativo (verifica utilizando um comparador
# com 0) (entrada 3 do multiplexer), faz RELU usando um comparador para verificar se o número é negativo e um mutiplexer auxiliar que devolve zero caso a condição se verifique (entrada 4 do multiplexer)
# e faz li passando o valor do imediato para o multiplexer (entrada 5 do multiplexer). Assim, a operação adequada é escolhida com a saída da Control Unit.
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
#