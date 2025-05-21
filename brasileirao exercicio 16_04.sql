/* banco de dados campeonatobrasilerio */

-- 01 Liste o nome e a posição de todos os jogadores.

select nome, posicao from jogador;

-- 02 Liste o nome completo e a sigla de todos os times.

select nome_completo, sigla from time;

-- 03 Mostre os nomes dos estádios e suas respectivas capacidades.

select nome, capacidade from estadio;

-- 04 Exiba todos os dados das partidas.

select * from partida;

-- 05 Liste o nome dos jogadores nascidos desde o ano 2000.

select nome, data_nascimento from jogador
where data_nascimento >= '2000-01-01';

-- 06 Mostre os eventos que ocorreram após o minuto 60.

select * from evento where minuto >= '60';

-- 07 Liste todas as partidas que terminaram empatadas.

select * from partida where gol_mandante = gol_visitante and gol_visitante = gol_mandante;

-- 08 Liste os times ordenados pela cidade em ordem alfabética.

select * from time order by cidade asc;

-- 09 Exiba os 5 jogadores mais jovens (data de nascimento mais recentes).

select nome, data_nascimento from jogador
order by data_nascimento desc limit 5;

-- 10 Liste os eventos ordenados do mais recente para o mais antigo (por minuto).

select * from evento order by minuto desc;
