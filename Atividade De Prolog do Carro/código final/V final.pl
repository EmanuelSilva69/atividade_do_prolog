% Base de sintomas, sensores e diagnósticos
%temos a possibilidade de botar os valores dinâmicos né? vou botar aqui por segurança 
:- dynamic(bateria/1).
:- dynamic(temperatura_motor/1).
:- dynamic(nivel_oleo/1).
:- dynamic(sensor_oxigenio/1).
:- dynamic(rotacao_motor/1).
:- dynamic(sensor_vibracao/1).
:- dynamic(luz_check_engine/0).
:- dynamic(luz_bateria/0).
:- dynamic(falha_ignicao/0).
:- dynamic(barulho_incomum/0).
:- dynamic(perda_potencia/0).
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
causa(ruidos_motor, problema_transmissao).

causa(perda_potencia, problema_transmissao).
causa(perda_potencia, falha_injecao).
causa(superaquecimento_motor,superaquecimento).
causa(motor_engasgado, problema_injecao).
causa(motor_engasgado, falha_combustivel).





% Diagnóstico com múltiplos sintomas combinados
diagnostico_combinado(Sintomas, DiagnosticosUnicos) :-
    findall(Causa, (
        member(Sintoma, Sintomas),
        diagnostico(Sintoma, Causa)
    ), DiagnosticosComDuplicatas),
    sort(DiagnosticosComDuplicatas, DiagnosticosUnicos).  % Remove duplicatas

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
acao(problema_transmissao, trocar_transmissao).
acao(superaquecimento,esfriar_motor).

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
explicacao(problema_transmissao, "O problema está na transmissão do carro, é bom trocar.").
explicacao(sensor_virabrequim_problema, "O sensor de virabrequim está apresentando falhas e pode precisar ser substituído.").
explicacao(catalisador_problema, "O catalisador pode estar entupido ou com falhas, afetando o desempenho do motor.").
explicacao(falha_bielas, "As bielas estão com falhas, o que pode causar barulhos incomuns no motor.").
explicacao(pistoes_problema, "Os pistões apresentam problemas, o que pode afetar o funcionamento do motor.").
explicacao(falha_injecao, "A injeção está apresentando problemas, prejudicando o desempenho do motor.").
explicacao(superaquecimento,"O motor está MUITO quente. Espere um pouco até ele esfriar.").
explicacao(problema_injecao, "Há um problema no sistema de injeção eletrônica que está afetando o motor.").
explicacao(falha_combustivel, "Há uma falha no sistema de combustível, possivelmente devido à falta ou má qualidade do combustível.").
% Sensores disponíveis
sensor(temperatura_motor).
sensor(tensao_bateria).
sensor(nivel_oleo).
sensor(rotacao_motor).
sensor(sensor_vibracao).
sensor(sensor_oxigenio).  

% Limites críticos dos sensores
limite_critico(temperatura_motor, 100, superaquecimento).  % Temperatura acima de 100°C
limite_critico(tensao_bateria, 12, bateria_fraca).  % Tensão abaixo de 12V
limite_critico(nivel_oleo, minimo, baixo_oleo).  % Nível de óleo baixo
limite_critico(rotacao_motor, anormal, problema_injecao).  % Rotações anormais do motor
limite_critico(sensor_vibracao, anormal, problema_mecanico).  % Vibrações anormais no motor
limite_critico(sensor_oxigenio, fora_da_faixa, sensor_oxigenio_falha).  % Sensor de oxigênio fora da faixa
% Exemplo de leituras de sensores
leitura_sensor(temperatura_motor, 105).
leitura_sensor(tensao_bateria, 11.8).
leitura_sensor(nivel_oleo, baixo).
leitura_sensor(rotacao_motor, anormal).
leitura_sensor(sensor_oxigenio, fora_da_faixa).
leitura_sensor(sensor_vibracao, anormal).
% Probabilidade de causas
probabilidade(falha_ignicao, bateria_fraca) :-
    leitura_sensor(tensao_bateria, T), T < 12, !.
      % Corte para garantir que não seja checado para outras causas.

probabilidade(falha_ignicao, vela_ignicao_defeituosa) :-
    sintoma(falha_ignicao),
    leitura_sensor(tensao_bateria, T), T >= 12.
      % Corte para evitar diagnóstico incorreto.

probabilidade(luz_check_engine, sensor_oxigenio_falha) :-
    leitura_sensor(sensor_oxigenio, fora_da_faixa),!.
      % Corte para garantir que falha no sensor de oxigênio seja priorizada.

probabilidade(luz_check_engine, sistema_injecao_problema) :-
    sintoma(luz_check_engine).
      % Se o Check Engine estiver aceso, verifica o sistema de injeção, mas o corte garante que seja priorizado.

probabilidade(luz_bateria, alternador_defeito) :-
    sintoma(luz_bateria),
    leitura_sensor(tensao_bateria, T), T < 12, !.
      % A falha do alternador é priorizada quando a tensão da bateria está baixa.

probabilidade(luz_bateria, correia_acessorios_rompida) :-
    sintoma(luz_bateria),
    leitura_sensor(rotacao_motor, anormal).
      % Se a rotação do motor for anormal, a causa mais provável é a correia rompida.

probabilidade(barulho_motor, falha_bielas) :-
    sintoma(barulho_motor),
    leitura_sensor(sensor_vibracao, anormal),!.
      % Se o sensor de vibração for anormal, priorizamos falha nas bielas.

probabilidade(barulho_motor, pistoes_problema) :-
     leitura_sensor(rotacao_motor, normal),
    \+ probabilidade(barulho_motor, falha_bielas).
      % Se a rotação do motor for normal, então investigamos pistões.
% Probabilidade de falha no sensor de oxigênio

% Probabilidade de superaquecimento
probabilidade(superaquecimento_motor, superaquecimento) :-
    leitura_sensor(temperatura_motor, T), T > 100,!.
      % Corte para garantir que o superaquecimento seja priorizado.

% Probabilidade de baixo nível de óleo
probabilidade(superaquecimento_motor, vazamento_ou_falta_oleo) :-
    leitura_sensor(nivel_oleo, N), N == baixo.
      % Se o nível de óleo estiver baixo, a causa mais provável é vazamento ou falta de troca.

% Probabilidade de falha no sensor de oxigênio em motor engasgado
probabilidade(motor_engasgado, sensor_oxigenio_falha) :-
    leitura_sensor(sensor_oxigenio, ForaFaixa),
    ForaFaixa == fora_da_faixa,!.
      % Se o sensor de oxigênio estiver fora da faixa, prioriza-se falha do sensor.

% Probabilidade de problema de injeção no motor engasgado
probabilidade(motor_engasgado, problema_injecao) :-
    sintoma(luz_check_engine).
      % Se a luz de Check Engine estiver acesa, é prioritário verificar o sistema de injeção eletrônica.

% Probabilidade de falha nas bielas em ruídos do motor
probabilidade(ruidos_motor, falha_bielas) :-
    sintoma(barulho_motor),
    leitura_sensor(sensor_vibracao, anormal), !.
      % Se o sensor de vibração for anormal, prioriza-se falha nas bielas.
% Probabilidade de problema na transmissão
probabilidade(perda_potencia, problema_transmissao) :-
    leitura_sensor(sensor_vibracao, anormal).

probabilidade(ruidos_motor, problema_transmissao) :-
    leitura_sensor(sensor_vibracao, anormal). 

% Probabilidade de falha nos pistões (prioridade menor que bielas)
probabilidade(barulho_motor, pistoes_problema) :-
    leitura_sensor(rotacao_motor, normal),
    \+ probabilidade(barulho_motor, falha_bielas),!.
% Diagnóstico usando as probabilidades
diagnostico(Sintoma, Causa) :-
    probabilidade(Sintoma, Causa).


diagnosticar :-
    % Solicita os sintomas observados
    write('Digite os sintomas observados como uma lista (exemplo: [falha_ignicao, luz_check_engine]): '),
    read(Sintomas),
    % Verifica sintomas válidos e inválidos
    verificar_sintomas(Sintomas, SintomasValidos, SintomasInvalidos),
    % Exibe mensagem para sintomas inválidos
    (SintomasInvalidos \= [] ->
        format('Os seguintes sintomas não foram reconhecidos e serão ignorados: ~w\n', [SintomasInvalidos]);
        true
    ),
    % Diagnosticar com sintomas válidos
    (SintomasValidos \= [] ->
        diagnostico_combinado(SintomasValidos);
        write('Nenhum sintoma válido foi fornecido.\n')
    ).

% Diagnóstico combinado priorizado para múltiplos sintomas
diagnostico_combinado(Sintomas) :-
    findall([Sintoma, Diagnosticos], (
        member(Sintoma, Sintomas),
        diagnostico_prioritario(Sintoma, Diagnosticos)
    ), Resultados),
    listar_diagnosticos(Resultados).

% Listar diagnósticos com causas principais e alternativas
% Listar diagnósticos com causas principais e alternativas
listar_diagnosticos([]).
listar_diagnosticos([[Sintoma, Diagnosticos] | Resto]) :-
    (Diagnosticos = [CausaPrincipal | Alternativas] ->
        % Exibe a causa principal
        format('Sintoma analisado: ~w\n', [Sintoma]),
        format('Causa principal: ~w\n', [CausaPrincipal]),
        (acao(CausaPrincipal, AcaoPrincipal) ->
            format('Ação sugerida: ~w\n', [AcaoPrincipal]);
            write('Nenhuma ação sugerida disponível para esta causa.\n')),
        (explicacao(CausaPrincipal, ExplicacaoPrincipal) ->
            format('Explicação: ~w\n\n', [ExplicacaoPrincipal]);
            write('Nenhuma explicação disponível para esta causa.\n')),
        % Exibe as alternativas
        listar_alternativas(Alternativas);
        % Caso nenhum diagnóstico seja encontrado
        format('Sintoma analisado: ~w\nNenhuma causa encontrada para este sintoma.\n\n', [Sintoma])
    ),
    listar_diagnosticos(Resto).

% Listar alternativas para um diagnóstico
listar_alternativas([]).
listar_alternativas([Alternativa | Outras]) :-
    format('Alternativa: ~w\n', [Alternativa]),
    (acao(Alternativa, AcaoAlternativa) ->
        format('Ação sugerida: ~w\n', [AcaoAlternativa]);
        write('Nenhuma ação sugerida disponível para esta alternativa.\n')),
    (explicacao(Alternativa, ExplicacaoAlternativa) ->
        format('Explicação: ~w\n\n', [ExplicacaoAlternativa]);
        write('Nenhuma explicação disponível para esta alternativa.\n')),
    listar_alternativas(Outras).

% Diagnóstico priorizado com causas e alternativas
diagnostico_prioritario(Sintoma, Diagnosticos) :-
    sintoma(Sintoma),
    findall(Causa, probabilidade(Sintoma, Causa), Causas),
    (Causas \= [] ->
        Diagnosticos = Causas;  % Usa todas as causas retornadas por probabilidade/2
        findall(CausaGeral, causa(Sintoma, CausaGeral), TodasCausas),
        sort(TodasCausas, Diagnosticos)
    ).

% Verifica sintomas válidos e inválidos
verificar_sintomas([], [], []).
verificar_sintomas([Sintoma | Resto], [Sintoma | Validos], Invalidos) :-
    sintoma(Sintoma), !,
    verificar_sintomas(Resto, Validos, Invalidos).
verificar_sintomas([Sintoma | Resto], Validos, [Sintoma | Invalidos]) :-
    \+ sintoma(Sintoma),
    verificar_sintomas(Resto, Validos, Invalidos).

% Justificativas para "Por que não?"
justificar(Sintoma, Causa) :-
    probabilidade(Sintoma, Causa),
    format('A causa mais provável para ~w é ~w com base nas leituras dos sensores.\n', [Sintoma, Causa]), !.

justificar(Sintoma, OutraCausa) :-
    causa(Sintoma, OutraCausa),
    \+ probabilidade(Sintoma, OutraCausa),
    format('A causa ~w foi descartada para ~w porque não atende às condições dos sensores.\n', [OutraCausa, Sintoma]).

    % Casos de teste
caso_teste(1, [falha_ignicao, luz_bateria], [alternador_defeito,bateria_fraca]).
caso_teste(2, [superaquecimento_motor, luz_check_engine], [sensor_oxigenio_falha, superaquecimento]).
caso_teste(3, [motor_engasgado, luz_check_engine], [sensor_oxigenio_falha]).% Sempre vai ser só "sensor_oxigenio falha" pois o valor o do oxigênio tá alterado, n tem pra que botar outro sintoma , que seja o problema na falha da injeção, ai. A MENOS QUE ALTERE os dados, ai vai aaprecer sistema de injeção, mas esse comentário tá aqui pra isso
caso_teste(4, [ruidos_motor, perda_potencia], [falha_bielas, problema_transmissao]).

% Executar um único teste
executar_teste(Caso) :-
    caso_teste(Caso, Sintomas, Esperados),
    diagnostico_combinado(Sintomas, Diagnosticos),
    format('Teste ~w:\n', [Caso]),
    format('Sintomas analisados: ~w\n', [Sintomas]),
    format('Diagnósticos esperados: ~w\n', [Esperados]),
    format('Diagnósticos obtidos: ~w\n', [Diagnosticos]),
    (Esperados == Diagnosticos ->
        format('Resultado: Passou\n\n');
        format('Resultado: Falhou\n\n')).

% Executar todos os testes
executar_todos_testes :-
    forall(caso_teste(Caso, _, _), executar_teste(Caso)).
