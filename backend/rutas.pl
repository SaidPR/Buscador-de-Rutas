:- module(rutas, [
    ruta_corta/4,
    ruta_con_intereses/5,
    camino_con_tiempo/4,
    ruta_rapida/4
]).

% Hechos
camino(zamora, jiquilpan, 59.7, optimo, poco, villamar).
camino(zamora, vistaH, 44.9, optimo, medio, ixtlan).
camino(zamora, laPiedad, 59, optimo, rapido, ecuandureo).
camino(zamora, chilchota, 27, optimo, poco, camecuaro). 
camino(vistaH, sahuayo, 41.4, optimo, medio, _).
camino(sahuayo, jiquilpan, 7.7, optimo, rapido, _).
camino(vistaH, laPiedad, 52, optimo, rapido, _).
camino(laPiedad, chilchota, 92, optimo, lento, _).

% Camino bidireccional
caminoBid(A, B, Distancia, Calidad, Trafico, LugarInteres) :-
    camino(A, B, Distancia, Calidad, Trafico, LugarInteres);
    camino(B, A, Distancia, Calidad, Trafico, LugarInteres).

% Ruta mas corta (por distancia)
ruta_corta(CiudadA, CiudadB, Ruta, Distancia) :-
    ruta_corta_aux(CiudadA, CiudadB, [CiudadA], RutaInvertida, 0, Distancia),
    reverse(RutaInvertida, Ruta).

ruta_corta_aux(CiudadA, CiudadB, Visitadas, [CiudadB|Visitadas], DistAcum, DistFinal) :-
    caminoBid(CiudadA, CiudadB, Distancia, _, _, _),
    \+ member(CiudadB, Visitadas),
    DistFinal is DistAcum + Distancia.

ruta_corta_aux(Actual, Destino, Visitadas, RutaFinal, DistAcum, DistFinal) :-
    caminoBid(Actual, Siguiente, Dist, _, _, _),
    \+ member(Siguiente, Visitadas),
    DistNueva is DistAcum + Dist,
    ruta_corta_aux(Siguiente, Destino, [Siguiente|Visitadas], RutaFinal, DistNueva, DistFinal).

% Ruta que pase por lugares de interés específicos
ruta_con_intereses(Inicio, Fin, InteresesRequeridos, Ruta, Distancia) :-
    ruta_con_intereses_aux(Inicio, Fin, InteresesRequeridos, [Inicio], RutaInvertida, 0, Distancia),
    reverse(RutaInvertida, Ruta).

ruta_con_intereses_aux(Ciudad, Ciudad, [], Ruta, Ruta, Distancia, Distancia).
ruta_con_intereses_aux(Actual, Destino, InteresesFaltantes, Visitadas, RutaFinal, DistAcum, DistFinal) :-
    caminoBid(Actual, Siguiente, Dist, _, _, LugarInteres),
    \+ member(Siguiente, Visitadas),
    DistNueva is DistAcum + Dist,
    actualizar_intereses(InteresesFaltantes, LugarInteres, InteresesRestantes),
    ruta_con_intereses_aux(Siguiente, Destino, InteresesRestantes, [Siguiente|Visitadas], RutaFinal, DistNueva, DistFinal).

actualizar_intereses(Intereses, Lugar, Intereses) :-
    (var(Lugar); Lugar == '_'), !.
actualizar_intereses(Intereses, Lugar, InteresesRestantes) :-
    eliminar(Lugar, Intereses, InteresesRestantes).

eliminar(_, [], []).
eliminar(X, [X|T], T) :- !.
eliminar(X, [H|T], [H|R]) :- eliminar(X, T, R).

% Factores de calidad y tráfico
factor_calidad(optimo, 1.0).
factor_calidad(regular, 1.5).
factor_calidad(malo, 2.0).

factor_trafico(poco, 1.0).
factor_trafico(medio, 1.5).
factor_trafico(lento, 2.0).
factor_trafico(rapido, 0.8).

% Camino con tiempo estimado
camino_con_tiempo(A, B, Distancia, TiempoEstimado) :-
    caminoBid(A, B, Distancia, Calidad, Trafico, _),
    factor_calidad(Calidad, FC),
    factor_trafico(Trafico, FT),
    TiempoEstimado is Distancia * FC * FT.

% Ruta mas rapida (según tiempo estimado)
ruta_rapida(Inicio, Fin, Ruta, TiempoTotal) :-
    ruta_rapida_aux(Inicio, Fin, [Inicio], RutaInvertida, 0, TiempoTotal),
    reverse(RutaInvertida, Ruta).

ruta_rapida_aux(Ciudad, Ciudad, Ruta, Ruta, Tiempo, Tiempo).
ruta_rapida_aux(Actual, Destino, Visitadas, RutaFinal, TiempoAcum, TiempoFinal) :-
    caminoBid(Actual, Siguiente, Distancia, Calidad, Trafico, _),
    \+ member(Siguiente, Visitadas),
    factor_calidad(Calidad, FC),
    factor_trafico(Trafico, FT),
    TiempoTramo is Distancia * FC * FT,
    TiempoNuevo is TiempoAcum + TiempoTramo,
    ruta_rapida_aux(Siguiente, Destino, [Siguiente|Visitadas], RutaFinal, TiempoNuevo, TiempoFinal).
