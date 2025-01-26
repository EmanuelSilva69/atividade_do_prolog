% Base de sintomas, sensores e diagnósticos

% Sintomas básicos
sintoma(falha_ignicao).
sintoma(luz_check_engine).
sintoma(luz_bateria).
sintoma(barulho_motor).
sintoma(superaquecimento_motor).
sintoma(motor_engasgado).
sintoma(ruidos_motor).
sintoma(perda_potencia).

% Possíveis causas de sintomas
causa(falha_ignicao, bateria_fraca).
causa(falha_ignicao, vela_ignicao_defeituosa).
causa(falha_ignicao, sensor_virabrequim_problema).

causa(luz_check_engine, sensor_oxigenio_falha).
causa(luz_check_engine, sistema_injecao_problema).
causa(luz_check_engine, catalisador_problema).

causa(luz_bateria, alternador_defeito).
causa(luz_bateria, correia_acessorios_rompida).

causa(barulho_motor, falha_bielas).
causa(barulho_motor, pistoes_problema).

causa(ruidos_motor, falha_bielas).
causa(ruidos_motor, pistoes_problema).
causa(ruidos_motor, problema_transmissao).

causa(perda_potencia, problema_transmissao).
causa(perda_potencia, falha_injecao).

% Sensores disponíveis
sensor(temperatura_motor).
sensor(tensao_bateria).
sensor(nivel_oleo).
sensor(rotacao_motor).
sensor(sensor_vibracao).
sensor(sensor_oxigenio).

% Limites críticos dos sensores
limite_critico(temperatura_motor, 100, superaquecimento).
limite_critico(tensao_bateria, 12, bateria_fraca).
limite_critico(nivel_oleo, minimo, baixo_oleo).
limite_critico(rotacao_motor, anormal, problema_injecao).
limite_critico(sensor_vibracao, anormal, problema_mecanico).
limite_critico(sensor_oxigenio, fora_da_faixa, sensor_oxigenio_falha).

% Probabilidades de causas
probabilidade(falha_ignicao, bateria_fraca) :-
    leitura_sensor(tensao_bateria, T),
    T < 12, !.

probabilidade(falha_ignicao, vela_ignicao_defeituosa) :-
    leitura_sensor(tensao_bateria, T),
    T >= 12, !.

probabilidade(luz_check_engine, sensor_oxigenio_falha) :-
    leitura_sensor(sensor_oxigenio, fora_da_faixa), !.

probabilidade(luz_check_engine, sistema_injecao_problema) :-
    leitura_sensor(rotacao_motor, anormal), !.

probabilidade(luz_bateria, alternador_defeito) :-
    leitura_sensor(tensao_bateria, T),
    T < 12, !.

probabilidade(luz_bateria, correia_acessorios_rompida) :-
    leitura_sensor(rotacao_motor, anormal), !.

probabilidade(barulho_motor, falha_bielas) :-
    leitura_sensor(sensor_vibracao, anormal), !.

probabilidade(barulho_motor, pistoes_problema) :-
    leitura_sensor(rotacao_motor, normal), !.

probabilidade(superaquecimento_motor, superaquecimento) :-
    leitura_sensor(temperatura_motor, T),
    T > 100, !.

probabilidade(superaquecimento_motor, baixo_oleo) :-
    leitura_sensor(nivel_oleo, baixo), !.

probabilidade(ruidos_motor, problema_transmissao) :-
    sintoma(perda_potencia),
    leitura_sensor(sensor_vibracao, anormal), !.

% Diagnóstico baseado em probabilidade
diagnostico(Sintoma, Causa) :-
    sintoma(Sintoma),
    probabilidade(Sintoma, Causa), !.
diagnostico(Sintoma, Causa) :-
    sintoma(Sintoma),
    causa(Sintoma, Causa).

% Diagnóstico com múltiplos sintomas combinados
diagnostico_combinado(Sintomas, CausasCombinadas) :-
    findall(Causa, (
        member(Sintoma, Sintomas),
        diagnostico(Sintoma, Causa)
    ), Causas),
    combinar_causas_multipla(Causas, CausasCombinadas).

% Combinação de causas para múltiplos sintomas
combinar_causas_multipla(Causas, Combinadas) :-
    sort(Causas, Unicas),
    maplist(acao_corretiva, Unicas, Combinadas).

% Ações corretivas detalhadas
acao_corretiva(bateria_fraca, recarregar_ou_substituir_bateria).
acao_corretiva(alternador_defeito, verificar_ou_substituir_alternador).
acao_corretiva(correia_acessorios_rompida, verificar_correia_e_substituir).
acao_corretiva(sensor_oxigenio_falha, substituir_sensor_oxigenio).
acao_corretiva(problema_transmissao, verificar_caixa_cambio).
acao_corretiva(pistoes_problema, verificar_ou_reparar_pistoes).
acao_corretiva(falha_bielas, revisar_bielas_e_conectar_componentes).

% Explicação de exclusões ("Por que não?")
justificativa(Sintoma, Causa) :-
    probabilidade(Sintoma, Causa), !,
    format('A causa mais provável para ~w é ~w devido às leituras dos sensores.\n', [Sintoma, Causa]).
justificativa(Sintoma, OutraCausa) :-
    causa(Sintoma, OutraCausa),
    \+ probabilidade(Sintoma, OutraCausa),
    format('A causa ~w foi descartada para ~w pois não atende às condições dos sensores.\n', [OutraCausa, Sintoma]).

% Testes automatizados
caso_teste(1, [falha_ignicao, luz_bateria], [bateria_fraca]).
caso_teste(2, [superaquecimento_motor, luz_check_engine], [superaquecimento, sensor_oxigenio_falha]).
caso_teste(3, [motor_engasgado, luz_check_engine], [sensor_oxigenio_falha, problema_injecao]).
caso_teste(4, [ruidos_motor, perda_potencia], [falha_bielas, problema_transmissao]).

executar_teste(Caso) :-
    caso_teste(Caso, Sintomas, Esperadas),
    diagnostico_combinado(Sintomas, Diagnosticos),
    format('Teste ~w:\n', [Caso]),
    format('Sintomas: ~w\n', [Sintomas]),
    format('Diagnósticos esperados: ~w\n', [Esperadas]),
    format('Diagnósticos obtidos: ~w\n', [Diagnosticos]),
    (Esperadas == Diagnosticos ->
        format('Resultado: Passou\n\n');
        format('Resultado: Falhou\n\n')).

% Rodar todos os casos de teste
executar_todos_testes :-
    forall(caso_teste(Caso, _, _), executar_teste(Caso)).
