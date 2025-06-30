:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_cors)).
:- use_module(rutas).  % Tu archivo rutas.pl

:- set_setting(http:cors, [*]).

:- http_handler('/ruta', ruta_corta_handler, []).
:- http_handler('/rapida', ruta_rapida_handler, []).
:- http_handler('/intereses', ruta_con_intereses_handler, []).


server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Ruta ms corta
ruta_corta_handler(Request) :-
    cors_enable(Request, [methods([get])]),
    http_parameters(Request, [
        origen(Origen, [atom]),
        destino(Destino, [atom])
    ]),
    (   ruta_corta(Origen, Destino, Ruta, Distancia)
    ->  reply_json(_{ruta: Ruta, distancia: Distancia})
    ;   reply_json(_{error: "Ruta no encontrada"}, [status(404)])
    ).

% Ruta ms rpida
ruta_rapida_handler(Request) :-
    cors_enable(Request, [methods([get])]),
    http_parameters(Request, [
        origen(Origen, [atom]),
        destino(Destino, [atom])
    ]),
    (   ruta_rapida(Origen, Destino, Ruta, Tiempo)
    ->  reply_json(_{ruta: Ruta, tiempo: Tiempo})
    ;   reply_json(_{error: "Ruta no encontrada"}, [status(404)])
    ).

% Ruta con intereses
ruta_con_intereses_handler(Request) :-
    cors_enable(Request, [methods([get])]),
    http_parameters(Request, [
        origen(Origen, [atom]),
        destino(Destino, [atom]),
        intereses(InteresesStr, [atom])
    ]),
    atomic_list_concat(InteresesLista, ',', InteresesStr),
    (   ruta_con_intereses(Origen, Destino, InteresesLista, Ruta, Distancia)
    ->  reply_json(_{ruta: Ruta, distancia: Distancia, intereses: InteresesLista})
    ;   reply_json(_{error: "No se encontró una ruta que pase por todos los intereses"}, [status(404)])
    ).
