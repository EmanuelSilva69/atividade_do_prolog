% Base de sintomas, sensores e diagnósticos

% Sintomas básicos
sintoma(falha_ignicao).
sintoma(luz_check_engine).
sintoma(luz_bateria).
sintoma(barulho_motor).

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

% Sensores disponíveis e limites críticos
sensor(temperatura_motor).
sensor(tensao_bateria).
sensor(nivel_oleo).
sensor(rotacao_motor).
sensor(sensor_vibracao).

% Limites críticos dos sensores
limite_critico(temperatura_motor, 100, superaquecimento).
limite_critico(tensao_bateria, 12, bateria_fraca).
limite_critico(nivel_oleo, minimo, baixo_oleo).
limite_critico(rotacao_motor, anormal, problema_injecao).
limite_critico(sensor_vibracao, anormal, problema_mecanico).

% Regras de diagnóstico
diagnostico(falha_ignicao, bateria_fraca) :-
    leitura_sensor(tensao_bateria, T), T < 12,
    !.
diagnostico(falha_ignicao, vela_ignicao_defeituosa) :-
    sintoma(falha_ignicao),
    leitura_sensor(tensao_bateria, T), T >= 12.

diagnostico(luz_check_engine, sensor_oxigenio_falha) :-
    leitura_sensor(sensor_oxigenio, fora_da_faixa),
    !.
diagnostico(luz_check_engine, sistema_injecao_problema) :-
    sintoma(luz_check_engine).

diagnostico(luz_bateria, alternador_defeito) :-
    sintoma(luz_bateria),
    leitura_sensor(tensao_bateria, T), T < 12.
diagnostico(luz_bateria, correia_acessorios_rompida) :-
    sintoma(luz_bateria),
    leitura_sensor(rotacao_motor, anormal).

diagnostico(barulho_motor, falha_bielas) :-
    sintoma(barulho_motor),
    leitura_sensor(sensor_vibracao, anormal).
diagnostico(barulho_motor, pistoes_problema) :-
    sintoma(barulho_motor),
    leitura_sensor(rotacao_motor, normal).
% Diagnóstico com múltiplos sintomas
diagnostico_combinado(Sintoma1, Sintoma2, CausaCombinada) :-
    sintoma(Sintoma1),
    sintoma(Sintoma2),
    causa(Sintoma1, Causa1),
    causa(Sintoma2, Causa2),
    combinar_causas(Causa1, Causa2, CausaCombinada).

% Combinando causas de dois sintomas
combinar_causas(bateria_fraca, alternador_defeito, problema_bateria_ou_alternador) :- !.
combinar_causas(vela_ignicao_defeituosa, sistema_injecao_problema, problema_ignicao_ou_injecao) :- !.
combinar_causas(falha_bielas, pistoes_problema, problema_motor) :- !.
% Ações corretivas para os diagnósticos
acao(bateria_fraca, recarregar_ou_substituir_bateria).
acao(vela_ignicao_defeituosa, limpar_ou_substituir_velas).
acao(sensor_oxigenio_falha, substituir_sensor_oxigenio).
acao(sistema_injecao_problema, verificar_sistema_injecao).
acao(alternador_defeito, verificar_ou_substituir_alternador).
acao(correia_acessorios_rompida, substituir_correia_acessorios).
acao(falha_bielas, verificar_sistema_mecanico).
acao(pistoes_problema, inspecionar_pistoes).
acao(problema_bateria_ou_alternador, verificar_bateria_e_alternador).
acao(problema_ignicao_ou_injecao, verificar_ignicao_ou_injecao).
acao(problema_motor, verificar_motor).

% Explicações do diagnóstico
explicacao(bateria_fraca, "A tensão da bateria está abaixo de 12V.").
explicacao(vela_ignicao_defeituosa, "A bateria está funcionando normalmente, mas há falha de ignição.").
explicacao(sensor_oxigenio_falha, "O sensor de oxigênio está registrando valores fora do intervalo esperado.").
explicacao(sistema_injecao_problema, "A luz de Check Engine está acesa, indicando problemas na injeção eletrônica.").
explicacao(alternador_defeito, "A luz de bateria acesa e a tensão estão baixas, indicando possível falha no alternador.").
explicacao(correia_acessorios_rompida, "A rotação do motor é anormal, indicando possível correia rompida.").
explicacao(problema_bateria_ou_alternador, "A falha pode ser tanto na bateria quanto no alternador. Verifique ambos para determinar a causa.").
explicacao(problema_ignicao_ou_injecao, "Há uma falha de ignição ou um problema no sistema de injeção eletrônica.").
explicacao(problema_motor, "O problema pode ser causado por falha nas bielas ou pistões.").

% Exemplo de leituras de sensores
leitura_sensor(temperatura_motor, 105).
leitura_sensor(tensao_bateria, 11.8).
leitura_sensor(nivel_oleo, baixo).
leitura_sensor(rotacao_motor, anormal).
leitura_sensor(sensor_oxigenio, fora_da_faixa).
leitura_sensor(sensor_vibracao, anormal).
% Probabilidade de causas
probabilidade(falha_ignicao, bateria_fraca) :-
    leitura_sensor(tensao_bateria, T), T < 12,
    !.  % Corte para garantir que não seja checado para outras causas.

probabilidade(falha_ignicao, vela_ignicao_defeituosa) :-
    sintoma(falha_ignicao),
    leitura_sensor(tensao_bateria, T), T >= 12,
    !.  % Corte para evitar diagnóstico incorreto.

probabilidade(luz_check_engine, sensor_oxigenio_falha) :-
    leitura_sensor(sensor_oxigenio, fora_da_faixa),
    !.  % Corte para garantir que falha no sensor de oxigênio seja priorizada.

probabilidade(luz_check_engine, sistema_injecao_problema) :-
    sintoma(luz_check_engine),
    !.  % Se o Check Engine estiver aceso, verifica o sistema de injeção, mas o corte garante que seja priorizado.

probabilidade(luz_bateria, alternador_defeito) :-
    sintoma(luz_bateria),
    leitura_sensor(tensao_bateria, T), T < 12,
    !.  % A falha do alternador é priorizada quando a tensão da bateria está baixa.

probabilidade(luz_bateria, correia_acessorios_rompida) :-
    sintoma(luz_bateria),
    leitura_sensor(rotacao_motor, anormal),
    !.  % Se a rotação do motor for anormal, a causa mais provável é a correia rompida.

probabilidade(barulho_motor, falha_bielas) :-
    sintoma(barulho_motor),
    leitura_sensor(sensor_vibracao, anormal),
    !.  % Se o sensor de vibração for anormal, priorizamos falha nas bielas.

probabilidade(barulho_motor, pistoes_problema) :-
    sintoma(barulho_motor),
    leitura_sensor(rotacao_motor, normal),
    !.  % Se a rotação do motor for normal, então investigamos pistões.
% Diagnóstico usando as probabilidades
diagnostico1(Sintoma, Causa) :-
    sintoma(Sintoma),
    probabilidade(Sintoma, Causa),  % Aqui usamos a probabilidade para determinar a causa mais provável
    !.  % O corte impede backtracking para soluções não prioritárias.

% Caso não encontre a causa principal, tenta uma outra abordagem
diagnostico1(Sintoma, Causa) :-
    sintoma(Sintoma),
    causa(Sintoma, Causa).
% Sistema principal de diagnóstico interativo
% Sistema de diagnóstico completo
% Diagnóstico com múltiplos sintomas combinados
diagnosticar :-
    write('Digite o sintoma(s) observado(s) (ex: falha_ignicao, luz_check_engine, luz_bateria, barulho_motor): '),
    read(Sintoma),
    (   sintoma(Sintoma)
    ->  findall(Causa, diagnostico1(Sintoma, Causa), Causas),
        (   Causas \= []
        ->  write('Diagnóstico baseado no sintoma: '), nl,
            listar_resultados(Causas)
        ;   write('Nenhuma causa identificada para o sintoma informado.'), nl
        )
    ;   write('Sintoma não reconhecido.'), nl
    ),
    % Verifica se há diagnóstico combinado
    write('Deseja verificar um diagnóstico combinado? (sim/nao): '),
    read(Resposta),
    (   Resposta == sim
    ->  write('Digite o segundo sintoma observado: '),
        read(Sintoma2),
        (   sintoma(Sintoma2)
        ->  diagnostico_combinado(Sintoma, Sintoma2, CausaCombinada),
            (   CausaCombinada \= []
            ->  write('Diagnóstico combinado: '), nl,
                listar_resultados([CausaCombinada])
            ;   write('Nenhuma causa combinada identificada para os sintomas informados.'), nl
            )
        ;   write('Segundo sintoma não reconhecido.'), nl
        )
    ;   write('Nenhum diagnóstico combinado será realizado.'), nl
    ).

% Listar as causas e ações corretivas
listar_resultados([]).
listar_resultados([Causa | T]) :-
    format('Causa provável: ~w~n', [Causa]),
    acao(Causa, Acoes),
    format('Ações corretivas: ~w~n~n', [Acoes]),
    explicacao(Causa, Explicacao),
    format('Explicação: ~w~n~n', [Explicacao]),
    listar_resultados(T).
