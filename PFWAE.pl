/* Tipos y PROLOG
 Pequeño interprete para PFWAE usando PROLOG
 Alumno:Gonzalez Duran Erick */

:- dynamic interp/3.

% Revisamos que X sea un numero.
num(X) :- number(X).

% Predicado que verifica la construccion del id.
id(X) :- equal(X, [id,_]).

% Predicado que regresa si los parametros son iguales.
equal(X,X).

% Predicado que nos ayuda a buscar un id en el ambiente.
lookup(ID, [[ID1,VAL1]|XS], VAL) :- equal(ID,ID1), equal(VAL,VAL1);
									lookup(ID,XS,VAL).

% Predicado que verfica que operacion se debe aplicar.
verificaop(OP, ENV, R) :- equal(OP, [+, X,Y]), suma(X,Y,ENV,R);
						  equal(OP,[-, X,Y]), resta(X,Y,ENV,R);
						  equal(OP, [*, X,Y]), producto(X,Y,ENV,R);
						  equal(OP, [/,X,Y]), division(X,Y,ENV,R).

% Agrega una tupla al ambiente.
addenv(ASUB, ENV, [ASUB|ENV]).

% Operacion Suma: Dada la definicion de PFWAE, la operacion suma es binara y puede ser efectuada 
% entre numeros o entre cualquier elemento de PFWAE, i.e (num,num), (PFWAE,PFWAE).
suma(X,Y,ENV,R) :- num(X), num(Y), R is X + Y;
			       num(X), lookup(Y, ENV, R1), R is X + R1;
			       num(Y), lookup(X, ENV, R2), R is Y + R2;
			       lookup(X,ENV,R4),lookup(Y,ENV,R5), R is R4 + R5.

% Operacion Resta: Dada la definicion de PFWAE, la operacion resta es binara y puede ser efectuada 
% entre numeros o entre cualquier elemento de PFWAE, i.e (num,num), (PFWAE,PFWAE).
resta(X,Y,ENV,R) :- num(X), num(Y), R is X - Y;
				num(X), lookup(Y, ENV, R1), R is X - R1;
			    num(Y), lookup(X, ENV, R2), R is Y - R2;
			    lookup(X,ENV,R4),lookup(Y,ENV,R5), R is R4 - R5.

% Operacion Producto: Dada la definicion de PFWAE, la operacion producto es binara y puede ser efectuada 
% entre numeros o entre cualquier elemento de PFWAE, i.e (num,num), (PFWAE,PFWAE).
producto(X,Y,ENV,R) :- num(X), num(Y), R is X * Y;
				   num(X), lookup(Y, ENV, R1), R is X * R1;
			       num(Y), lookup(X, ENV, R2), R is Y * R2;
			       lookup(X,ENV,R4),lookup(Y,ENV,R5), R is R4 * R5.


% Operacion Division: Dada la definicion de PFWAE, la operacion division es binara y puede ser efectuada 
% entre numeros o entre cualquier elemento de PFWAE, i.e (num,num), (PFWAE,PFWAE).
division(X,Y,ENV,R) :- num(X), num(Y), Y > 0, R is X/Y.

% Predicado que simula un with.
with(ID,VAL,BD,ENV,R) :- id(ID), equal(ENV,[]), addenv([ID,VAL],[], ENV1),interp(BD,ENV1,R);
					 id(ID), addenv([ID,VAL], ENV, ENV1), interp(BD,ENV1,R).

% Predicado que simula una funcion.
fun(ID, VAL,BD,ENV,R) :- verificaop(BD, addenv([ID|VAL],ENV,ENV1),R).

% Predicado que simula una aplicacion de funcion.
app(ID, PARAM, ENV, R) :- lookup(ID,ENV,R1),fun(ID,PARAM,R1, ENV, R).

% Predicado que simula la funcion interp de PFWAE.
interp(EXPR, ENV, R) :- num(EXPR);
						equal(EXPR,[with,ID,VAL,BD]), with(ID,VAL,BD,ENV,R);
						equal(EXPR,[app,ID,PARAM]),app(ID,PARAM,ENV,R).
						
prueba() :- interp([with, x, [fun, y, [*, y, y]], [app, [id, x], 4]], [], 16).
