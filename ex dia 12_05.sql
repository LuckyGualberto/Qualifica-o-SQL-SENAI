-- Desafios 
-- 01. Apresenta a tabela de classificação do campeonato brasileiro dos resultado até a rodada 15

use brasileirao;

with 
mandante as (
select 
    rodada,
	id_mandante id_time,
    gol_mandante gm,
    gol_visitante gc
from brasileirao.partida
),
visitante as (
select
    rodada, 
	id_visitante id_time,
    gol_visitante gm,
    gol_mandante gc
from brasileirao.partida
),
jogos as (
select * from mandante
union all
select * from visitante
)
select 
	t.id_time,
    sigla,
    nome,
    sum(case when gm > gc then 3 when gm = gc then 1 else 0 end) pts,
    count(*) qtj,
    count(case when gm > gc then 1 end) vit,
    count(case when gm < gc then 1 end) der,
    count(case when gm = gc then 1 end) emp,
    sum(gm) gm,
    sum(gc) gc,
    sum(gm-gc) sg
from jogos j 
inner join brasileirao.time t on j.id_time = t.id_time
where rodada <= 15
group by 
	t.id_time,
    sigla,
    nome
order by pts desc, vit desc, sg desc, gm desc
;
select * from brasileirao.vw_classificacao;


-- 02. Construa uma query que monstre por exemplo:
/*
titulo                     |qt_atores|lista_atores                                                                                                                                                                          |
---------------------------+---------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
ACADEMY DINOSAUR           |       10|PENELOPE GUINESS,CHRISTIAN GABLE,LUCILLE TRACY,SANDRA PECK,JOHNNY CAGE,MENA TEMPLE,WARREN NOLTE,OPRAH KILMER,ROCK DUKAKIS,MARY KEITEL                                                 |
ACE GOLDFINGER             |        4|BOB FAWCETT,MINNIE ZELLWEGER,SEAN GUINESS,CHRIS DEPP                                                                                                                                  |
ADAPTATION HOLES           |        5|NICK WAHLBERG,BOB FAWCETT,CAMERON STREEP,RAY JOHANSSON,JULIANNE DENCH                                                                                                                 |
AFFAIR PREJUDICE           |        5|JODIE DEGENERES,SCARLETT DAMON,KENNETH PESCI,FAY WINSLET,OPRAH KILMER                                                                                                                 |
...
*/

use locadora;

select 
	 f.titulo, 
     count(*) qt_ator, group_concat(concat_ws(' ', primeiro_nome, ultimo_nome)) lista_atores
from locadora.ator a
inner join locadora.filme_ator fa on a.ator_id = fa.ator_id
inner join locadora.filme f on f.filme_id = fa.filme_id
group by f.titulo;

-- 03. Construa uma query que monstre por exemplo:
/*
ator                |qt_filmes|lista_filmes                                                                                                                                                                                                                                                   |
--------------------+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
ADAM GRANT          |       18|ANNIE IDENTITY,BALLROOM MOCKINGBIRD,DISCIPLE MOTHER,FIREBALL PHILADELPHIA,GLADIATOR WESTWARD,GLORY TRACY,GROUNDHOG UNCUT,HAPPINESS UNITED,IDOLS SNATCHERS,LOSER HUSTLER,MARS ROMAN,MIDNIGHT WESTWARD,OPERATION OPERATION,SEABISCUIT PUNK,SPLENDOR PATTON,TADPOL|
ADAM HOPPER         |       22|BLINDNESS GUN,BLOOD ARGONAUTS,CHAMBER ITALIAN,CLERKS ANGELS,CLUELESS BUCKET,FICTION CHRISTMAS,GABLES METROPOLIS,GREASE YOUTH,HEAVEN FREEDOM,LOVERBOY ATTACKS,MASKED BUBBLE,MOCKINGBIRD HOLLYWOOD,NOON PAPI,OPEN AFRICAN,PRINCESS GIANT,SADDLE ANTITRUST,SLEEPY |
AL GARLAND          |       26|BILL OTHERS,BREAKFAST GOLDFINGER,CHITTY LOCK,DALMATIONS SWEDEN,DRIFTER COMMANDMENTS,ENOUGH RAGING,GLASS DYING,GRAIL FRANKENSTEIN,HANDICAP BOONDOCK,HOLIDAY GAMES,HOUSE DYNAMITE,JACKET FRISCO,MUPPET MILE,OSCAR GOLD,PARK CITIZEN,POTTER CONNECTICUT,ROCK INSTI|
...
*/
use locadora;

select 
        (concat_ws(' ', primeiro_nome, ultimo_nome)) ator,
        count(*) qt_filmes,
        group_concat(titulo) as lista_filmes
from locadora.ator a
inner join locadora.filme_ator fa on a.ator_id = fa.ator_id
inner join locadora.filme f on f.filme_id = fa.filme_id
group by ator
order by ator asc
;



-- 04. Construa uma query que monstre por exemplo:
/*
titulo                     |duracao_minuto|duracao_filme|
---------------------------+--------------+-------------+
ACADEMY DINOSAUR           |            86|1h:26m       |
ACE GOLDFINGER             |            48|0h:48m       |
ADAPTATION HOLES           |            50|0h:50m       |
*/


select 
     titulo, 
     duracao_do_filme duracao_minuto,
	 concat(duracao_do_filme div 60, 'h:', mod(duracao_do_filme, 60), 'm') duracao_filme
from locadora.filme;



-- 05. Construa uma query que monstre por exemplo:
/*
data_de_aluguel    |data_de_devolucao  |dias_alugado|tempo_alugado         |
-------------------+-------------------+------------+----------------------+
2005-05-24 22:53:30|2005-05-26 22:04:30|           2|0 semana(s) e 2 dia(s)|
2005-05-24 22:54:33|2005-05-28 19:40:33|           4|0 semana(s) e 4 dia(s)|
2005-05-24 23:03:39|2005-06-01 22:12:39|           8|1 semana(s) e 1 dia(s)|
...
*/

select 
     tb.*,
     concat(dias_alugados div 7, ' semana(s) e ', mod(dias_alugados, 7), ' dias') tempo_alugado
     from
(
select data_de_aluguel, 
       data_de_devolucao,
	   datediff( data_de_devolucao, data_de_aluguel) dias_alugados
     --  concat(dias_alugado div 7, 'semana(s) e', mod(dias_alugado, 7), 'dias')
	
from locadora.aluguel al) tb

;
