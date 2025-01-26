% ------------------------------
% Definições básicas: Animais e Plantas
% ------------------------------
animal(lobo).
animal(coelho).
animal(falcao).
animal(peixe).
animal(urso).
animal(abelha).

planta(flor).
planta(arvore).
planta(alga).
planta(fruta).
% ------------------------------
% Características de Animais e Plantas
% ------------------------------
caracteristica(lobo, mamifero).
caracteristica(coelho, mamifero).
caracteristica(falcao, ave).
caracteristica(peixe, aquatico).
caracteristica(urso, mamifero).
caracteristica(abelha, inseto).

caracteristica(falcao, tem_asas).
caracteristica(peixe, tem_escamas).
caracteristica(coelho, herbivoro).
caracteristica(lobo, carnivoro).
caracteristica(urso, onivoro).
caracteristica(abelha, polinizador).

caracteristica(flor, polinizavel).
caracteristica(alga, aquatica).
caracteristica(arvore, fornece_sombra).

% ------------------------------
% Hábitats
% ------------------------------
habitat(lobo, floresta).
habitat(coelho, campo).
habitat(falcao, montanhas).
habitat(peixe, rio).
habitat(urso, floresta).
habitat(abelha, campo).

habitat(flor, campo).
habitat(arvore, floresta).
habitat(alga, oceano).

% ------------------------------
% Relações de Cadeia Alimentar
% ------------------------------
predador_de(lobo, coelho).
predador_de(falcao, coelho).
predador_de(urso, peixe).
predador_de(urso, coelho).

presa_de(coelho, flor).
presa_de(peixe, alga).
presa_de(lobo, coelho).
presa_de(falcao, coelho).
presa_de(urso, peixe).
presa_de(urso, coelho).
presa_de(urso, fruta).

% ------------------------------
% Relações Ecológicas
% ------------------------------
poliniza(abelha, flor).
sombra_fornecida_por(arvore, campo).
sombra_fornecida_por(arvore, floresta).
% ------------------------------
% Regras para Inferência
% ------------------------------

% Um animal é um predador se for predador de algo, garantindo uma única instância
eh_predador(X) :- setof(X, Y^predador_de(X, Y), Predadores), member(X, Predadores).

% Um animal é uma presa se for presa de algo, garantindo uma única instância
eh_presa(X) :- setof(X, Y^(presa_de(Y, X), animal(X)), Presas), 
    member(X, Presas).

% Um ser vivo é herbívoro se sua presa for uma planta, garantindo uma única instância
eh_herbivoro(X) :- setof(X, Y^(presa_de(X, Y), planta(Y)), Herbivoros), member(X, Herbivoros).

% Um ser vivo é carnívoro se consumir algum animal, garantindo uma única instância
eh_carnivoro(X) :- 
    setof(X, Y^(presa_de(X, Y), animal(Y)), Carnivoros), 
    member(X, Carnivoros).

% Um animal é onívoro se for predador de animais e herbívoro, garantindo uma única instância
eh_onivoro(X) :-eh_carnivoro(X), eh_herbivoro(X).

% Um animal é polinizador se poliniza algo
eh_polinizador(X) :- poliniza(X, _).

% Um lugar tem sombra se uma árvore estiver presente
tem_sombra(Lugar) :- sombra_fornecida_por(arvore, Lugar).

% Regras para perguntar o habitat de um animal ou planta
vive_em(X, Lugar) :- habitat(X, Lugar).

% Regras avançadas de cadeia alimentar: quem come quem indiretamente
topo_da_cadeia(X) :- eh_predador(X), \+ eh_presa(X).
base_da_cadeia(X) :- eh_presa(X), \+ eh_predador(X).

% Regras de dependência ecológica
dependente_de(Y, X) :- poliniza(X, Y). % Um ser vivo depende de seu polinizador
dependente_de(X, Y) :- presa_de(X, Y). % Um ser vivo depende do que ele consome
% ------------------------------
% Consultas possíveis
% ------------------------------
% 1. Quais animais são predadores?
% ?- eh_predador(X).

% 2. Quais animais são presas?
% ?- eh_presa(X).

% 3. Quais são os animais herbívoros?
% ?- eh_herbivoro(X).

% 4. Quais são os animais carnívoros?
% ?- eh_carnivoro(X).

% 5. Quais são os animais onívoros?
% ?- eh_onivoro(X).

% 6. Quem está no topo da cadeia alimentar?
% ?- topo_da_cadeia(X).

% 7. Quem está na base da cadeia alimentar?
% ?- base_da_cadeia(X).

% 8. Quem depende de quem?
% ?- dependente_de(X, Y).

% 9. Qual é o habitat de um animal ou planta?
% ?- vive_em(X, Lugar).

% 10. Quais locais têm sombra?
% ?- tem_sombra(Lugar).
