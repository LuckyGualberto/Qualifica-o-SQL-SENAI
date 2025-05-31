use dbgeral ;
use brasileirao;
-- Implemente uma função no MySQL chamada idade que recebe como entrada um valor do tipo DATE e retorne a idade atual dessa data como tipo INT.
-- A função deve ser not determinística, pois cada execução pode gerar um valor diferente, seguido de reads sql data.
-- Utilize a função interna CURDATE() ou NOW() do MySQL para obter a data atual.

delimiter $$
create function idade(dt_nasc date)
returns varchar (20)
not deterministic
reads sql data
begin
    declare data date;
    return datediff(curdate(), dt_nasc) div 365.25;
end$$
delimiter ;

select idade('1997-11-29');


-- Implemente uma função no MySQL chamada faixa_etaria que recebe como entrada um valor do tipo DATE e retorne a faixa etária em VARCHAR.

 -- A função deve ser not determinística, pois cada execução pode gerar um valor diferente, seguido de reads sql data.
-- Utilize a função idade() para obter a idade atual.
-- Utilize o calculo com div para facilitar a implementação.
-- As faixas etárias devem ser sempre ser entre *0 e *9 Exemplos:
-- A idade 08 deve ficar Entre 00 e 09 anos.
-- A idade 26 deve ficar Entre 20 e 29 anos.
-- A idade 41 deve ficar Entre 40 e 49 anos.

delimiter $$
create function faixa_etaria(dt_nas date)
returns varchar(250)
not deterministic
reads sql data
begin
    declare idade int;
    declare msg varchar(100);

    set idade = floor(datediff(curdate(), dt_nas) div 365.25);

    if idade between 0 and 9 then
        set msg = 'Entre 00 e 09 anos.';
    elseif idade between 10 and 19 then
        set msg = 'Entre 10 e 19 anos.';
    elseif idade between 20 and 29 then
        set msg = 'Entre 20 e 29 anos.';
    elseif idade between 30 and 39 then
        set msg = 'Entre 30 e 39 anos.';
    elseif idade between 40 and 49 then
        set msg = 'Entre 40 e 49 anos.';
    elseif idade between 50 and 59 then
        set msg = 'Entre 50 e 59 anos.';
    else
        set msg = '60 anos ou mais.';
    end if;

    return msg;
end$$

delimiter ;

/* modo alternativo e mais simples

delimiter $$
create function faixa_etaria(dt_nas date)
returns varchar(250)
not deterministic
reads sql data
begin
    declare idade int;
    declare fx varchar(30);
    set idade = (select dbgeral.idade(dt_nas));
    set fx = (select idade div 10);
    return replace('Entre *0 e *9', '*',fx);
end$$
delimiter ;

*/

select faixa_etaria('1987-07-21');

-- /Crie uma Stored Procedure chamada atualizar_gol_partida que preencha os campos de gols na tabela partida. A procedure deve:

-- Receber a sigla dos times mandates e visitantes
-- Receber o número de gols do mandante e visitante
-- Para teste limpe antes os resultados da rodada 38
use brasileirao;
set sql_safe_updates = 0;

update partida set gol_mandante = null, gol_visitante = null where rodada = 38;


delimiter $$
create procedure atualizar_gol_partida (sgm varchar(3), golm int, golv int, sgv varchar(3))
begin
   declare idmandante int;
   declare idvisitante int;
   declare idpartida int;
   set idmandante = (select id_time from brasileirao.time where time.sigla = sgm);
   set idvisitante = (select id_time from brasileirao.time where time.sigla = sgv);
   set idpartida = (select id_partida from brasileirao.partida where id_mandante = idmandante and id_visitante = idvisitante);
   update brasileirao.partida set gol_mandante = golm, gol_visitante= golv where id_partida = idpartida ;
end$$
delimiter ;

drop procedure atualizar_gol_partida;

CALL atualizar_gol_partida('GRE',10,10,'COR');

select * from partida where rodada = 38;



-- Crie uma Stored Procedure chamada gerar_resultado_aleatorio que preencha aleatoriamente os campos de gols em uma tabela chamada partida. A procedure deve:

-- Iterar por todos os registros da tabela partida, utilizando um contador para identificar o campo id_partida.
-- Gerar valores aleatórios para os campos:
-- gol_mandante: Um número inteiro aleatório entre 0 e 6.
-- gol_visitante: Um número inteiro aleatório entre 0 e 6.
-- Atualizar os valores gerados para cada registro identificado pelo id_partida.
-- Parar a execução ao atingir o último registro (ou quando o contador chegar a 380, que representa o número total de partidas no contexto fornecido).


delimiter $$
create  procedure gerar_resultado_aleatorio( )
begin
   declare contador int default 1;
   while contador <= 380 do
      set contador = contador +1;
      update partida set gol_mandante = round(RAND()*(6 - 0)+ 0), gol_visitante = round(RAND()*(6 - 0)+ 0) where id_partida <=380;
    end while;  
end$$
delimiter ;

call gerar_resultado_aleatorio();
select * from brasileirao.vw_classificacao;



-- CALL atualizar gol_partida('x1','x2','x3','x4');

select 
concat('CALL atualizar_gol_partida(''',
      tm.sigla,''',',
      gol_mandante,',',
      gol_visitante,',''',
      tv.sigla,'''); -- ',
      p.id_partida) 
      update_partida
from brasileirao.partida p
inner join brasileirao.time tm on p.id_mandante = tm.id_time
inner join brasileirao.time tv on p.id_visitante = tv.id_time
order by p.id_partida;

CALL atualizar_gol_partida('INT',2,4,'BAH'); -- 1
CALL atualizar_gol_partida('CRI',3,1,'JUV'); -- 2
CALL atualizar_gol_partida('FLU',3,4,'RBB'); -- 3
CALL atualizar_gol_partida('SAO',0,1,'FOR'); -- 4
CALL atualizar_gol_partida('VAS',6,1,'GRE'); -- 5
CALL atualizar_gol_partida('COR',4,4,'CAM'); -- 6
CALL atualizar_gol_partida('CAP',4,3,'CUI'); -- 7
CALL atualizar_gol_partida('ACG',3,4,'FLA'); -- 8
CALL atualizar_gol_partida('CRU',6,5,'BOT'); -- 9
CALL atualizar_gol_partida('VIT',3,4,'PAL'); -- 10
CALL atualizar_gol_partida('BAH',5,2,'FLU'); -- 11
CALL atualizar_gol_partida('GRE',2,4,'CAP'); -- 12
CALL atualizar_gol_partida('RBB',2,2,'VAS'); -- 13
CALL atualizar_gol_partida('CAM',4,2,'CRI'); -- 14
CALL atualizar_gol_partida('PAL',3,0,'INT'); -- 15
CALL atualizar_gol_partida('FOR',2,5,'CRU'); -- 16
CALL atualizar_gol_partida('JUV',2,4,'COR'); -- 17
CALL atualizar_gol_partida('FLA',5,4,'SAO'); -- 18
CALL atualizar_gol_partida('BOT',6,4,'ACG'); -- 19
CALL atualizar_gol_partida('CUI',5,0,'VIT'); -- 20
CALL atualizar_gol_partida('FLU',3,5,'VAS'); -- 21
CALL atualizar_gol_partida('GRE',2,0,'CUI'); -- 22
CALL atualizar_gol_partida('RBB',3,5,'COR'); -- 23
CALL atualizar_gol_partida('CAM',2,5,'CRU'); -- 24
CALL atualizar_gol_partida('VIT',0,5,'BAH'); -- 25
CALL atualizar_gol_partida('PAL',2,6,'FLA'); -- 26
CALL atualizar_gol_partida('CAP',6,5,'INT'); -- 27
CALL atualizar_gol_partida('BOT',1,4,'JUV'); -- 28
CALL atualizar_gol_partida('ACG',4,1,'SAO'); -- 29
CALL atualizar_gol_partida('CRI',0,4,'FOR'); -- 30
CALL atualizar_gol_partida('VAS',6,0,'CRI'); -- 31
CALL atualizar_gol_partida('CUI',2,4,'CAM'); -- 32
CALL atualizar_gol_partida('BAH',0,2,'GRE'); -- 33
CALL atualizar_gol_partida('FLA',2,4,'BOT'); -- 34
CALL atualizar_gol_partida('CRU',3,1,'VIT'); -- 35
CALL atualizar_gol_partida('COR',4,4,'FLU'); -- 36
CALL atualizar_gol_partida('FOR',3,3,'RBB'); -- 37
CALL atualizar_gol_partida('JUV',2,4,'CAP'); -- 38
CALL atualizar_gol_partida('INT',2,4,'ACG'); -- 39
CALL atualizar_gol_partida('SAO',4,0,'PAL'); -- 40
CALL atualizar_gol_partida('FLU',1,4,'CAM'); -- 41
CALL atualizar_gol_partida('RBB',6,4,'FLA'); -- 42
CALL atualizar_gol_partida('COR',5,1,'FOR'); -- 43
CALL atualizar_gol_partida('VIT',5,0,'SAO'); -- 44
CALL atualizar_gol_partida('CAP',4,2,'VAS'); -- 45
CALL atualizar_gol_partida('BOT',5,5,'BAH'); -- 46
CALL atualizar_gol_partida('CUI',0,2,'PAL'); -- 47
CALL atualizar_gol_partida('JUV',5,1,'ACG'); -- 48
CALL atualizar_gol_partida('CRU',1,4,'INT'); -- 49
CALL atualizar_gol_partida('GRE',2,5,'CRI'); -- 50
CALL atualizar_gol_partida('FLA',5,2,'COR'); -- 51
CALL atualizar_gol_partida('PAL',3,6,'CAP'); -- 52
CALL atualizar_gol_partida('FOR',6,1,'BOT'); -- 53
CALL atualizar_gol_partida('ACG',5,5,'CRU'); -- 54
CALL atualizar_gol_partida('BAH',2,1,'RBB'); -- 55
CALL atualizar_gol_partida('VAS',2,4,'VIT'); -- 56
CALL atualizar_gol_partida('SAO',5,4,'FLU'); -- 57
CALL atualizar_gol_partida('CRI',6,5,'CUI'); -- 58
CALL atualizar_gol_partida('INT',1,2,'JUV'); -- 59
CALL atualizar_gol_partida('CAM',0,2,'GRE'); -- 60
CALL atualizar_gol_partida('GRE',1,2,'RBB'); -- 61
CALL atualizar_gol_partida('VIT',4,3,'ACG'); -- 62
CALL atualizar_gol_partida('FLU',5,4,'JUV'); -- 63
CALL atualizar_gol_partida('CUI',3,3,'INT'); -- 64
CALL atualizar_gol_partida('COR',2,2,'BOT'); -- 65
CALL atualizar_gol_partida('CAM',1,4,'BAH'); -- 66
CALL atualizar_gol_partida('VAS',0,2,'FLA'); -- 67
CALL atualizar_gol_partida('CRI',3,5,'PAL'); -- 68
CALL atualizar_gol_partida('SAO',2,6,'CRU'); -- 69
CALL atualizar_gol_partida('FOR',5,3,'CAP'); -- 70
CALL atualizar_gol_partida('ACG',1,1,'COR'); -- 71
CALL atualizar_gol_partida('JUV',1,2,'VIT'); -- 72
CALL atualizar_gol_partida('BOT',1,6,'FLU'); -- 73
CALL atualizar_gol_partida('RBB',1,4,'CAM'); -- 74
CALL atualizar_gol_partida('CRU',1,3,'CUI'); -- 75
CALL atualizar_gol_partida('INT',2,2,'SAO'); -- 76
CALL atualizar_gol_partida('FLA',4,0,'GRE'); -- 77
CALL atualizar_gol_partida('CAP',2,2,'CRI'); -- 78
CALL atualizar_gol_partida('BAH',4,4,'FOR'); -- 79
CALL atualizar_gol_partida('PAL',2,4,'VAS'); -- 80
CALL atualizar_gol_partida('RBB',1,4,'JUV'); -- 81
CALL atualizar_gol_partida('FLU',6,5,'ACG'); -- 82
CALL atualizar_gol_partida('VIT',3,6,'INT'); -- 83
CALL atualizar_gol_partida('COR',1,4,'SAO'); -- 84
CALL atualizar_gol_partida('CAP',1,3,'FLA'); -- 85
CALL atualizar_gol_partida('GRE',1,3,'BOT'); -- 86
CALL atualizar_gol_partida('VAS',5,0,'CRU'); -- 87
CALL atualizar_gol_partida('CUI',3,3,'FOR'); -- 88
CALL atualizar_gol_partida('CRI',0,4,'BAH'); -- 89
CALL atualizar_gol_partida('CAM',5,3,'PAL'); -- 90
CALL atualizar_gol_partida('BOT',4,4,'CAP'); -- 91
CALL atualizar_gol_partida('ACG',4,3,'CRI'); -- 92
CALL atualizar_gol_partida('SAO',3,1,'CUI'); -- 93
CALL atualizar_gol_partida('FOR',1,4,'GRE'); -- 94
CALL atualizar_gol_partida('JUV',3,2,'VAS'); -- 95
CALL atualizar_gol_partida('INT',2,3,'COR'); -- 96
CALL atualizar_gol_partida('CRU',3,1,'FLU'); -- 97
CALL atualizar_gol_partida('VIT',1,0,'CAM'); -- 98
CALL atualizar_gol_partida('FLA',0,1,'BAH'); -- 99
CALL atualizar_gol_partida('PAL',3,2,'RBB'); -- 100
CALL atualizar_gol_partida('CRI',1,5,'BOT'); -- 101
CALL atualizar_gol_partida('GRE',3,1,'INT'); -- 102
CALL atualizar_gol_partida('CUI',6,3,'ACG'); -- 103
CALL atualizar_gol_partida('VAS',3,6,'SAO'); -- 104
CALL atualizar_gol_partida('BAH',2,5,'CRU'); -- 105
CALL atualizar_gol_partida('FLU',1,3,'FLA'); -- 106
CALL atualizar_gol_partida('CAP',4,1,'COR'); -- 107
CALL atualizar_gol_partida('CAM',0,3,'FOR'); -- 108
CALL atualizar_gol_partida('PAL',2,2,'JUV'); -- 109
CALL atualizar_gol_partida('RBB',3,2,'VIT'); -- 110
CALL atualizar_gol_partida('CRU',3,1,'CAP'); -- 111
CALL atualizar_gol_partida('BOT',3,4,'RBB'); -- 112
CALL atualizar_gol_partida('COR',2,4,'CUI'); -- 113
CALL atualizar_gol_partida('ACG',3,1,'GRE'); -- 114
CALL atualizar_gol_partida('JUV',4,5,'FLA'); -- 115
CALL atualizar_gol_partida('INT',6,1,'CAM'); -- 116
CALL atualizar_gol_partida('BAH',1,3,'VAS'); -- 117
CALL atualizar_gol_partida('FOR',1,5,'PAL'); -- 118
CALL atualizar_gol_partida('FLU',4,2,'VIT'); -- 119
CALL atualizar_gol_partida('SAO',1,2,'CRI'); -- 120
CALL atualizar_gol_partida('VAS',0,0,'BOT'); -- 121
CALL atualizar_gol_partida('CUI',0,2,'RBB'); -- 122
CALL atualizar_gol_partida('CAM',1,5,'ACG'); -- 123
CALL atualizar_gol_partida('GRE',3,6,'FLU'); -- 124
CALL atualizar_gol_partida('SAO',2,6,'BAH'); -- 125
CALL atualizar_gol_partida('FOR',5,6,'JUV'); -- 126
CALL atualizar_gol_partida('VIT',2,6,'CAP'); -- 127
CALL atualizar_gol_partida('FLA',4,5,'CRU'); -- 128
CALL atualizar_gol_partida('CRI',5,4,'INT'); -- 129
CALL atualizar_gol_partida('PAL',4,4,'COR'); -- 130
CALL atualizar_gol_partida('CUI',1,4,'BOT'); -- 131
CALL atualizar_gol_partida('VAS',5,3,'FOR'); -- 132
CALL atualizar_gol_partida('CRI',5,0,'CRU'); -- 133
CALL atualizar_gol_partida('CAM',2,4,'FLA'); -- 134
CALL atualizar_gol_partida('RBB',2,4,'ACG'); -- 135
CALL atualizar_gol_partida('CAP',2,3,'SAO'); -- 136
CALL atualizar_gol_partida('GRE',4,4,'PAL'); -- 137
CALL atualizar_gol_partida('BAH',3,2,'JUV'); -- 138
CALL atualizar_gol_partida('FLU',5,4,'INT'); -- 139
CALL atualizar_gol_partida('COR',6,4,'VIT'); -- 140
CALL atualizar_gol_partida('FLA',0,4,'CUI'); -- 141
CALL atualizar_gol_partida('SAO',5,4,'RBB'); -- 142
CALL atualizar_gol_partida('CRU',2,0,'COR'); -- 143
CALL atualizar_gol_partida('FOR',0,6,'FLU'); -- 144
CALL atualizar_gol_partida('JUV',4,4,'GRE'); -- 145
CALL atualizar_gol_partida('INT',1,4,'VAS'); -- 146
CALL atualizar_gol_partida('VIT',5,1,'CRI'); -- 147
CALL atualizar_gol_partida('PAL',2,1,'BAH'); -- 148
CALL atualizar_gol_partida('ACG',5,6,'CAP'); -- 149
CALL atualizar_gol_partida('BOT',6,6,'CAM'); -- 150
CALL atualizar_gol_partida('GRE',1,4,'CRU'); -- 151
CALL atualizar_gol_partida('VAS',0,1,'COR'); -- 152
CALL atualizar_gol_partida('CAP',3,3,'BAH'); -- 153
CALL atualizar_gol_partida('PAL',3,3,'ACG'); -- 154
CALL atualizar_gol_partida('FLA',5,3,'FOR'); -- 155
CALL atualizar_gol_partida('CRI',5,0,'FLU'); -- 156
CALL atualizar_gol_partida('CAM',3,2,'SAO'); -- 157
CALL atualizar_gol_partida('VIT',6,6,'BOT'); -- 158
CALL atualizar_gol_partida('CUI',5,1,'JUV'); -- 159
CALL atualizar_gol_partida('RBB',2,3,'INT'); -- 160
CALL atualizar_gol_partida('CRU',2,1,'RBB'); -- 161
CALL atualizar_gol_partida('BAH',6,2,'CUI'); -- 162
CALL atualizar_gol_partida('JUV',3,6,'CAM'); -- 163
CALL atualizar_gol_partida('COR',0,1,'CRI'); -- 164
CALL atualizar_gol_partida('ACG',1,1,'VAS'); -- 165
CALL atualizar_gol_partida('SAO',2,2,'GRE'); -- 166
CALL atualizar_gol_partida('BOT',3,5,'PAL'); -- 167
CALL atualizar_gol_partida('FOR',3,4,'VIT'); -- 168
CALL atualizar_gol_partida('FLU',1,5,'CAP'); -- 169
CALL atualizar_gol_partida('INT',6,5,'FLA'); -- 170
CALL atualizar_gol_partida('FLA',5,1,'CRI'); -- 171
CALL atualizar_gol_partida('BOT',1,5,'INT'); -- 172
CALL atualizar_gol_partida('PAL',4,4,'CRU'); -- 173
CALL atualizar_gol_partida('GRE',2,5,'VIT'); -- 174
CALL atualizar_gol_partida('CAM',1,5,'VAS'); -- 175
CALL atualizar_gol_partida('BAH',2,5,'COR'); -- 176
CALL atualizar_gol_partida('RBB',6,2,'CAP'); -- 177
CALL atualizar_gol_partida('FOR',0,0,'ACG'); -- 178
CALL atualizar_gol_partida('JUV',1,5,'SAO'); -- 179
CALL atualizar_gol_partida('CUI',3,4,'FLU'); -- 180
CALL atualizar_gol_partida('CRU',2,4,'JUV'); -- 181
CALL atualizar_gol_partida('SAO',5,4,'BOT'); -- 182
CALL atualizar_gol_partida('VIT',4,3,'FLA'); -- 183
CALL atualizar_gol_partida('FLU',2,1,'PAL'); -- 184
CALL atualizar_gol_partida('ACG',5,5,'BAH'); -- 185
CALL atualizar_gol_partida('COR',5,5,'GRE'); -- 186
CALL atualizar_gol_partida('CRI',1,1,'RBB'); -- 187
CALL atualizar_gol_partida('INT',5,3,'FOR'); -- 188
CALL atualizar_gol_partida('VAS',5,3,'CUI'); -- 189
CALL atualizar_gol_partida('CAP',1,4,'CAM'); -- 190
CALL atualizar_gol_partida('PAL',5,4,'VIT'); -- 191
CALL atualizar_gol_partida('JUV',1,6,'CRI'); -- 192
CALL atualizar_gol_partida('BAH',0,3,'INT'); -- 193
CALL atualizar_gol_partida('BOT',6,4,'CRU'); -- 194
CALL atualizar_gol_partida('FOR',3,1,'SAO'); -- 195
CALL atualizar_gol_partida('RBB',3,5,'FLU'); -- 196
CALL atualizar_gol_partida('FLA',1,6,'ACG'); -- 197
CALL atualizar_gol_partida('GRE',2,0,'VAS'); -- 198
CALL atualizar_gol_partida('CAM',1,4,'COR'); -- 199
CALL atualizar_gol_partida('CUI',4,3,'CAP'); -- 200
CALL atualizar_gol_partida('VIT',1,2,'CUI'); -- 201
CALL atualizar_gol_partida('VAS',3,3,'RBB'); -- 202
CALL atualizar_gol_partida('ACG',4,5,'BOT'); -- 203
CALL atualizar_gol_partida('CRI',3,4,'CAM'); -- 204
CALL atualizar_gol_partida('SAO',5,3,'FLA'); -- 205
CALL atualizar_gol_partida('FLU',5,3,'BAH'); -- 206
CALL atualizar_gol_partida('COR',2,4,'JUV'); -- 207
CALL atualizar_gol_partida('CAP',6,2,'GRE'); -- 208
CALL atualizar_gol_partida('INT',1,5,'PAL'); -- 209
CALL atualizar_gol_partida('CRU',2,2,'FOR'); -- 210
CALL atualizar_gol_partida('FOR',4,6,'CRI'); -- 211
CALL atualizar_gol_partida('CUI',1,0,'GRE'); -- 212
CALL atualizar_gol_partida('CRU',4,6,'CAM'); -- 213
CALL atualizar_gol_partida('VAS',5,2,'FLU'); -- 214
CALL atualizar_gol_partida('COR',3,6,'RBB'); -- 215
CALL atualizar_gol_partida('JUV',3,4,'BOT'); -- 216
CALL atualizar_gol_partida('BAH',5,1,'VIT'); -- 217
CALL atualizar_gol_partida('FLA',4,2,'PAL'); -- 218
CALL atualizar_gol_partida('SAO',4,3,'ACG'); -- 219
CALL atualizar_gol_partida('INT',5,2,'CAP'); -- 220
CALL atualizar_gol_partida('GRE',2,2,'BAH'); -- 221
CALL atualizar_gol_partida('CAM',3,5,'CUI'); -- 222
CALL atualizar_gol_partida('RBB',2,3,'FOR'); -- 223
CALL atualizar_gol_partida('FLU',1,4,'COR'); -- 224
CALL atualizar_gol_partida('PAL',5,1,'SAO'); -- 225
CALL atualizar_gol_partida('ACG',2,2,'INT'); -- 226
CALL atualizar_gol_partida('CRI',4,6,'VAS'); -- 227
CALL atualizar_gol_partida('BOT',0,2,'FLA'); -- 228
CALL atualizar_gol_partida('CAP',3,2,'JUV'); -- 229
CALL atualizar_gol_partida('VIT',3,3,'CRU'); -- 230
CALL atualizar_gol_partida('ACG',5,6,'JUV'); -- 231
CALL atualizar_gol_partida('PAL',1,1,'CUI'); -- 232
CALL atualizar_gol_partida('CAM',5,6,'FLU'); -- 233
CALL atualizar_gol_partida('BAH',2,4,'BOT'); -- 234
CALL atualizar_gol_partida('FOR',2,3,'COR'); -- 235
CALL atualizar_gol_partida('CRI',5,4,'GRE'); -- 236
CALL atualizar_gol_partida('SAO',3,3,'VIT'); -- 237
CALL atualizar_gol_partida('INT',0,5,'CRU'); -- 238
CALL atualizar_gol_partida('FLA',1,2,'RBB'); -- 239
CALL atualizar_gol_partida('VAS',2,2,'CAP'); -- 240
CALL atualizar_gol_partida('CUI',3,0,'CRI'); -- 241
CALL atualizar_gol_partida('BOT',2,3,'FOR'); -- 242
CALL atualizar_gol_partida('GRE',4,0,'CAM'); -- 243
CALL atualizar_gol_partida('CRU',1,4,'ACG'); -- 244
CALL atualizar_gol_partida('COR',0,1,'FLA'); -- 245
CALL atualizar_gol_partida('VIT',2,3,'VAS'); -- 246
CALL atualizar_gol_partida('FLU',4,6,'SAO'); -- 247
CALL atualizar_gol_partida('RBB',3,6,'BAH'); -- 248
CALL atualizar_gol_partida('CAP',1,0,'PAL'); -- 249
CALL atualizar_gol_partida('JUV',4,6,'INT'); -- 250
CALL atualizar_gol_partida('ACG',0,1,'VIT'); -- 251
CALL atualizar_gol_partida('CAP',6,1,'FOR'); -- 252
CALL atualizar_gol_partida('BOT',4,5,'COR'); -- 253
CALL atualizar_gol_partida('PAL',1,2,'CRI'); -- 254
CALL atualizar_gol_partida('RBB',2,4,'GRE'); -- 255
CALL atualizar_gol_partida('JUV',0,2,'FLU'); -- 256
CALL atualizar_gol_partida('CRU',3,1,'SAO'); -- 257
CALL atualizar_gol_partida('BAH',5,2,'CAM'); -- 258
CALL atualizar_gol_partida('FLA',0,3,'VAS'); -- 259
CALL atualizar_gol_partida('INT',6,3,'CUI'); -- 260
CALL atualizar_gol_partida('VIT',6,1,'JUV'); -- 261
CALL atualizar_gol_partida('COR',1,1,'ACG'); -- 262
CALL atualizar_gol_partida('FLU',4,2,'BOT'); -- 263
CALL atualizar_gol_partida('FOR',4,1,'BAH'); -- 264
CALL atualizar_gol_partida('CAM',2,0,'RBB'); -- 265
CALL atualizar_gol_partida('VAS',1,3,'PAL'); -- 266
CALL atualizar_gol_partida('GRE',1,4,'FLA'); -- 267
CALL atualizar_gol_partida('SAO',2,3,'INT'); -- 268
CALL atualizar_gol_partida('CUI',4,1,'CRU'); -- 269
CALL atualizar_gol_partida('CRI',4,5,'CAP'); -- 270
CALL atualizar_gol_partida('PAL',3,3,'CAM'); -- 271
CALL atualizar_gol_partida('BOT',1,0,'GRE'); -- 272
CALL atualizar_gol_partida('JUV',5,1,'RBB'); -- 273
CALL atualizar_gol_partida('SAO',1,4,'COR'); -- 274
CALL atualizar_gol_partida('FOR',5,2,'CUI'); -- 275
CALL atualizar_gol_partida('ACG',5,2,'FLU'); -- 276
CALL atualizar_gol_partida('INT',1,0,'VIT'); -- 277
CALL atualizar_gol_partida('CRU',3,3,'VAS'); -- 278
CALL atualizar_gol_partida('BAH',4,1,'CRI'); -- 279
CALL atualizar_gol_partida('FLA',6,0,'CAP'); -- 280
CALL atualizar_gol_partida('CRI',2,2,'ACG'); -- 281
CALL atualizar_gol_partida('FLU',0,1,'CRU'); -- 282
CALL atualizar_gol_partida('GRE',4,3,'FOR'); -- 283
CALL atualizar_gol_partida('CAM',5,5,'VIT'); -- 284
CALL atualizar_gol_partida('RBB',2,1,'PAL'); -- 285
CALL atualizar_gol_partida('CAP',5,4,'BOT'); -- 286
CALL atualizar_gol_partida('BAH',3,6,'FLA'); -- 287
CALL atualizar_gol_partida('COR',2,4,'INT'); -- 288
CALL atualizar_gol_partida('CUI',1,4,'SAO'); -- 289
CALL atualizar_gol_partida('VAS',6,5,'JUV'); -- 290
CALL atualizar_gol_partida('SAO',6,3,'VAS'); -- 291
CALL atualizar_gol_partida('FOR',6,5,'CAM'); -- 292
CALL atualizar_gol_partida('FLA',4,6,'FLU'); -- 293
CALL atualizar_gol_partida('COR',3,6,'CAP'); -- 294
CALL atualizar_gol_partida('ACG',0,1,'CUI'); -- 295
CALL atualizar_gol_partida('BOT',1,2,'CRI'); -- 296
CALL atualizar_gol_partida('CRU',5,0,'BAH'); -- 297
CALL atualizar_gol_partida('INT',6,3,'GRE'); -- 298
CALL atualizar_gol_partida('VIT',5,2,'RBB'); -- 299
CALL atualizar_gol_partida('JUV',2,4,'PAL'); -- 300
CALL atualizar_gol_partida('GRE',0,3,'ACG'); -- 301
CALL atualizar_gol_partida('VIT',1,5,'FLU'); -- 302
CALL atualizar_gol_partida('FLA',1,3,'JUV'); -- 303
CALL atualizar_gol_partida('PAL',4,2,'FOR'); -- 304
CALL atualizar_gol_partida('CAP',4,0,'CRU'); -- 305
CALL atualizar_gol_partida('CAM',3,5,'INT'); -- 306
CALL atualizar_gol_partida('RBB',2,5,'BOT'); -- 307
CALL atualizar_gol_partida('CRI',1,1,'SAO'); -- 308
CALL atualizar_gol_partida('CUI',4,0,'COR'); -- 309
CALL atualizar_gol_partida('VAS',6,4,'BAH'); -- 310
CALL atualizar_gol_partida('FLU',2,4,'GRE'); -- 311
CALL atualizar_gol_partida('RBB',1,1,'CUI'); -- 312
CALL atualizar_gol_partida('CAP',3,4,'VIT'); -- 313
CALL atualizar_gol_partida('JUV',6,4,'FOR'); -- 314
CALL atualizar_gol_partida('COR',2,5,'PAL'); -- 315
CALL atualizar_gol_partida('INT',2,6,'CRI'); -- 316
CALL atualizar_gol_partida('BAH',5,4,'SAO'); -- 317
CALL atualizar_gol_partida('BOT',2,3,'VAS'); -- 318
CALL atualizar_gol_partida('CRU',5,3,'FLA'); -- 319
CALL atualizar_gol_partida('ACG',5,4,'CAM'); -- 320
CALL atualizar_gol_partida('INT',5,2,'FLU'); -- 321
CALL atualizar_gol_partida('PAL',5,2,'GRE'); -- 322
CALL atualizar_gol_partida('VIT',2,4,'COR'); -- 323
CALL atualizar_gol_partida('BOT',1,1,'CUI'); -- 324
CALL atualizar_gol_partida('CRU',2,2,'CRI'); -- 325
CALL atualizar_gol_partida('FOR',2,4,'VAS'); -- 326
CALL atualizar_gol_partida('ACG',3,5,'RBB'); -- 327
CALL atualizar_gol_partida('JUV',1,2,'BAH'); -- 328
CALL atualizar_gol_partida('SAO',2,6,'CAP'); -- 329
CALL atualizar_gol_partida('FLA',3,6,'CAM'); -- 330
CALL atualizar_gol_partida('COR',6,1,'CRU'); -- 331
CALL atualizar_gol_partida('RBB',4,4,'SAO'); -- 332
CALL atualizar_gol_partida('CAP',4,3,'ACG'); -- 333
CALL atualizar_gol_partida('CRI',2,0,'VIT'); -- 334
CALL atualizar_gol_partida('BAH',3,6,'PAL'); -- 335
CALL atualizar_gol_partida('GRE',3,2,'JUV'); -- 336
CALL atualizar_gol_partida('CUI',1,6,'FLA'); -- 337
CALL atualizar_gol_partida('CAM',2,1,'BOT'); -- 338
CALL atualizar_gol_partida('VAS',1,5,'INT'); -- 339
CALL atualizar_gol_partida('FLU',4,3,'FOR'); -- 340
CALL atualizar_gol_partida('BOT',4,6,'VIT'); -- 341
CALL atualizar_gol_partida('ACG',5,2,'PAL'); -- 342
CALL atualizar_gol_partida('JUV',5,0,'CUI'); -- 343
CALL atualizar_gol_partida('SAO',5,5,'CAM'); -- 344
CALL atualizar_gol_partida('INT',3,3,'RBB'); -- 345
CALL atualizar_gol_partida('BAH',5,2,'CAP'); -- 346
CALL atualizar_gol_partida('COR',2,4,'VAS'); -- 347
CALL atualizar_gol_partida('FLU',4,0,'CRI'); -- 348
CALL atualizar_gol_partida('FOR',1,3,'FLA'); -- 349
CALL atualizar_gol_partida('CRU',2,5,'GRE'); -- 350
CALL atualizar_gol_partida('CAM',2,0,'JUV'); -- 351
CALL atualizar_gol_partida('PAL',1,4,'BOT'); -- 352
CALL atualizar_gol_partida('CUI',3,1,'BAH'); -- 353
CALL atualizar_gol_partida('CRI',6,2,'COR'); -- 354
CALL atualizar_gol_partida('VAS',1,2,'ACG'); -- 355
CALL atualizar_gol_partida('GRE',1,6,'SAO'); -- 356
CALL atualizar_gol_partida('FLA',1,2,'INT'); -- 357
CALL atualizar_gol_partida('VIT',2,1,'FOR'); -- 358
CALL atualizar_gol_partida('RBB',4,0,'CRU'); -- 359
CALL atualizar_gol_partida('CAP',1,0,'FLU'); -- 360
CALL atualizar_gol_partida('INT',2,4,'BOT'); -- 361
CALL atualizar_gol_partida('CRU',1,2,'PAL'); -- 362
CALL atualizar_gol_partida('VIT',4,2,'GRE'); -- 363
CALL atualizar_gol_partida('FLU',4,4,'CUI'); -- 364
CALL atualizar_gol_partida('VAS',1,5,'CAM'); -- 365
CALL atualizar_gol_partida('COR',5,2,'BAH'); -- 366
CALL atualizar_gol_partida('SAO',0,3,'JUV'); -- 367
CALL atualizar_gol_partida('CAP',2,2,'RBB'); -- 368
CALL atualizar_gol_partida('ACG',4,3,'FOR'); -- 369
CALL atualizar_gol_partida('CRI',2,1,'FLA'); -- 370
CALL atualizar_gol_partida('GRE',10,10,'COR'); -- 371
CALL atualizar_gol_partida('CAM',0,0,'CAP'); -- 372
CALL atualizar_gol_partida('BAH',6,6,'ACG'); -- 373
CALL atualizar_gol_partida('FLA',4,4,'VIT'); -- 374
CALL atualizar_gol_partida('BOT',1,4,'SAO'); -- 375
CALL atualizar_gol_partida('PAL',1,3,'FLU'); -- 376
CALL atualizar_gol_partida('RBB',0,4,'CRI'); -- 377
CALL atualizar_gol_partida('FOR',1,6,'INT'); -- 378
CALL atualizar_gol_partida('CUI',2,4,'VAS'); -- 379
CALL atualizar_gol_partida('JUV',3,2,'CRU'); -- 380

