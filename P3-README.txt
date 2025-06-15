# ===========================================================
# Identificacao do grupo: T
#
# Membros [istID, primeiro + ultimo nome]
# 1. ist1114584- Beatriz Alves
# 2. ist1114263- Beatriz Medvedyuk
# 3. ist1114134- Bruno Fontenele
$
# ===========================================================
# Descricao da ISA Implementada
#
# == Formato das Instrucoes ==
# Indicar a divisao dos campos da instrucao
# Justificar decisoes: Por que escolheram esse numero de bits? Ha instrucoes com formatos diferentes?
#
# == Sumario dos Estagios do Pipeline==
# Descrever brevemente cada estagio (componentes de hardware utilizados)
#
# == Sinais de Controlo ==
# Explicar o que cada sinal ativa/desativa/seleciona e como sao gerados.
#
#
# ===========================================================
# Requisitos do enunciado que *nao* estao corretamente implementados:
# (indicar um por linha, ou responder "nenhum")
# -
#
# ===========================================================
# Top-3 das otimizacoes que a vossa solucao incorpora:
# (maximo 140 caracteres por cada otimizacao)
#
# 1. Formato único de instruções simplifica a decodificação e reduz a complexidade do circuito.
#
# 2. ALU modular permite facilmente adicionar novas instruções aritméticas no futuro.
# A ALU foi projetada de forma modular, com cada operação implementada como um bloco separado,
# selecionado por um multiplexador. Isso facilita a adição de novas instruções no futuro.
#
# 3. As instruções abs e relu foram implementadas com uso inteligente de multiplexadores,
# evitando circuitos redundantes. Em vez de criar lógica dedicada complexa, usa-se um comparador
# simples para verificar o sinal de R1 e um mux seleciona o valor correto.
#
# ===========================================================
