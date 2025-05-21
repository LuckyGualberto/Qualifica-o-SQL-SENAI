use brasileirao;

-- 01. Deseja-se saber o total de gols em cada estádio
/*exemplo:
nome_estadio									quantidade
Mineirão (Estádio Governador Magalhães Pinto)	87
Morumbi (Estádio Cícero Pompeu de Toledo)		80
Maracanã										77
Neo Química Arena								48
Estádio Alfredo Jaconi							48
*/


SELECT 
    e.nome, SUM(gol_mandante + gol_visitante) gol_total
FROM
    estadio e
        INNER JOIN
    partida p ON e.id_estadio = p.id_estadio
GROUP BY e.nome
ORDER BY gol_total DESC;



-- 02. Deseja-se saber a quantidade dos eventos seguintes eventos realizado pelos times:
-- "Bola na Trave", "Pênalti Perdido" , "Gol anulado (Var)" pelos clubes
/*exemplo:
sigla 	Bola na Trave 	Pênalti Perdido Gol anulado (Var)
ACG		4				2				2
CAP		12				1				1
CAM		16				1				3
BAH		12				0				1
BOT		10				2				1
.
.
*/

select 
sigla,
count(case when descricao = 'Bola na Trave' then 1 end) "Bola na Trave",
count(case when descricao = 'Pênalti Perdido' then 1 end) "Pênalti Perdido",
count(case when descricao = 'Gol anulado (Var)' then 1 end) "Gol anulado (Var)" 
 from time t
inner join jogador j on t.id_time = j.id_time
inner join evento e on e.id_jogador = j.id_jogador
where descricao in('Bola na trave','Pênalti Perdido','Gol anulado (Var)')
group by sigla order by sigla asc

;







-- 03. Elabore um relatório por minuto e a quantidade de gols (não pode contar "Gol anulado (Var)")
-- e ordene pela quantidade do maior para o menor
/*exemplo:
minuto 	qt_gols
90		75
45		48
52		14
61		14
.
.
*/

select 
minuto,
count(*)qt_gols
from evento e
where descricao like '%Gol%'
and descricao not like '%Var%'
group by minuto order by qt_gols desc
;




-- 04. Elabore um relatório por idade e quantidade de jogadores
-- remover data nula e posições "Auxiliar técnico" e "Técnico"
-- ordene pela idade do mais velho ao mais novo
-- select substring(curdate(),1,4) - substr(dt_nascimento,1,4) idade from jogador;
/*exemplo:
idade 	quantidade
44		1
43		1
41		1
40		1
39		3
38		4
*/


SELECT 
    SUBSTRING(CURDATE(), 1, 4) - SUBSTR(dt_nascimento, 1, 4) idade,
    COUNT(*) quantidade
FROM
    jogador
WHERE
    posicao NOT IN ('Auxiliar técnico' , 'Técnico')
        AND dt_nascimento IS NOT NULL
GROUP BY idade
ORDER BY idade DESC;




-- 05. Elabore um relatório por jogador e quantidade de cartões, 
-- detalhar também a quantidade de Cartões Vermelho e Amarelo
-- ordene pela quantidade total de Cartões'
/* exemplo:
numero 	nome 			qt_amarelo 	qt_vermelho qt_total
16		Jadson			15			1			16
19		Emanuel Brítez	12			2			14
3		Zé Marcos		12			2			14
10		Luciano			12			1			13
.
.
*/
SELECT 
    tb.*, qt_amarelo + qt_vermelho qt_total
FROM
    (SELECT 
        numero,
            j.nome,
            COUNT(CASE
                WHEN descricao LIKE '%Amarelo%' THEN 1
            END) qt_amarelo,
            COUNT(CASE
                WHEN descricao LIKE '%Vermelho%' THEN 1
            END) qt_vermelho
    FROM
        jogador j
    INNER JOIN evento e ON j.id_jogador = e.id_jogador
    WHERE
        descricao LIKE '%Cartao%'
    GROUP BY numero , j.nome) tb
    ORDER BY qt_total desc;
 
 
 


-- 06. Deseja-se saber qual a quantidade de jogos que aconteceram por dia
/* exemplo:
dia		quantidade
sábado	98
domingo	121
terça	11
quarta	64
quinta	29
segunda	11
sexta	8
*/

-- select 

-- dayname(horario) dia ,
-- count(case when dayname(horario) = 'saturday' then 1 end) "Sábado",
-- count(case when dayname(horario) = 'Sunday' then 1 end) "Domingo" ,
-- count(case when dayname(horario) = 'Monday' then 1 end) "Segunda",
-- count(case when dayname(horario) = 'Tuesday' then 1 end) "Terça",
-- count(case when dayname(horario) = 'Wednesday' then 1 end) "Quarta",
-- count(case when dayname(horario) = 'thursday' then 1 end) "Quinta",
-- count(case when dayname(horario) = 'Friday' then 1 end) "Sexta",
-- count(dayname(horario)) quantidade
--  from partida
 -- group by dayname(horario);
 
 set lc_time_names=pt_BR; -- modificar o idioma pra pt_BR
select DAYNAME(horario) dia,
 count(*)quantidade
 from partida 
 group by dia;




-- 07. Desejase saber a quantidade total de cada evento 
-- e quantos aconteceram ate os 45min e depois dos 45min
/*exemplo:
descricao									total	ate_45		depois_45
Gol (Gol de campo)							734		327			407
Cartão Amarelo								1806	658			1148
Substituição								3256	112			3144
Bola na Trave								217		93			124
Pênalti Perdido								23		12			11
Cartão Vermelho								80		25			55
Gol anulado (Var)							39		17			22
Cartão Vermelho (Segundo Cartão Amarelo)	44		7			37
Gol (Pênalti)								71		37			34
Gol (Gol Contra)							14		5			9
*/

select 
    descricao,
    count(*) total,
    count(case when minuto <= 45 then 1 end) qt_ate45,
    count(case when minuto > 45 then 1 end) qt_ate45
from
    evento e
group by descricao;



-- 08. Deseja-se saber a quantidade de jogador por faixa etária
/*exemplo:
faixa_etaria	qt
Entre 30 e 39	191
Entre 20 e 29	405
Entre 10 e 19	30
Entre 40 e 49	4
*/


select 
	case 
       when idade between 10 and 19 then 'Entre 10 e 19'
       when idade between 20 and 29 then 'Entre 20 e 29'
       when idade between 30 and 39 then 'Entre 30 e 39'
       when idade between 40 and 49 then 'Entre 40 e 49'
       else'50 ou mais'
       end "faixa_etaria",
       count(*) qt
from (
select
    SUBSTRING(CURDATE(), 1, 4) - SUBSTR(dt_nascimento, 1, 4) idade
from jogador 
where dt_nascimento is not null) tb
group by
      case 
       when idade between 10 and 19 then 'Entre 10 e 19'
       when idade between 20 and 29 then 'Entre 20 e 29'
       when idade between 30 and 39 then 'Entre 30 e 39'
       when idade between 40 and 49 then 'Entre 40 e 49'
       else'50 ou mais'
       end ;
