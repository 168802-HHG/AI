% Representación del estado del juego: estado(MisionerosIzq, CanibalesIzq, BarcoIzq, MisionerosDer, CanibalesDer, BarcoDer)
estado(3, 3, izquierda, 0, 0, derecha).

% Reglas para mover a las personas de un lado a otro del río
mover(estado(MI, CI, izquierda, MD, CD, derecha), estado(NMI, NCI, derecha, NMD, NCD, izquierda)) :-
    % Mover dos misioneros
    between(0, 2, X),
    NMI is MI - X,
    NMD is MD + X,
    % Mover dos caníbales
    between(0, 2, Y),
    NCI is CI - Y,
    NCD is CD + Y,
    % Asegurarse de que no haya más caníbales que misioneros en ningún lado
    no_comen(NMI, NCI),
    no_comen(NMD, NCD),
    % Asegurarse de que el estado no se haya visitado previamente
    not(visitado([estado(NMI, NCI, derecha, NMD, NCD, izquierda)|_])),
    % Marcar el estado actual como visitado
    asserta(visitado([estado(NMI, NCI, derecha, NMD, NCD, izquierda)|_])),
    write('Movimiento exitoso: '), write([NMI, NCI, NMD, NCD]), nl.

% Verificar si en un lado del río no hay más caníbales que misioneros
no_comen(Misioneros, Canibales) :-
    (Misioneros >= Canibales ; Misioneros = 0),
    (3 - Misioneros >= 3 - Canibales ; 3 - Misioneros = 0).

% Regla principal para resolver el rompecabezas
resolver :-
    % Iniciar con el estado inicial
    estado(MI, CI, BI, MD, CD, BD),
    % Llamar a la regla de búsqueda
    retractall(visitado(_)),
    asserta(visitado([estado(MI, CI, BI, MD, CD, BD)])),
    buscar([estado(MI, CI, BI, MD, CD, BD)], Solucion),
    % Imprimir la solución
    imprimir_solucion(Solucion).

% Regla de búsqueda utilizando la recursión y reversión de la lista
buscar([Estado | Resto], Solucion) :- reverse([Estado | Resto], Solucion).
buscar([Estado | Resto], Solucion) :-
    mover(Estado, NuevoEstado),
    buscar([NuevoEstado | [Estado | Resto]], Solucion).

% Regla para imprimir la solución
imprimir_solucion([]).
imprimir_solucion([Estado | Resto]) :-
    writeln(Estado),
    imprimir_solucion(Resto).

% Regla dinámica para mantener la lista de estados visitados
:- dynamic visitado/1.
