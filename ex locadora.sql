use locadora;

-- 01. Quais os países cadastrados?
select * from pais;

-- 02. Quantos países estão cadastrados?
select count(*) from pais;

-- 03. Quantos países que terminam com a letra "A" estão cadastrados?

select count(*) from pais where pais like '%a';

-- 04. Listar, sem repetição, os anos que houveram lançamento de filme.

select distinct ano_de_lancamento from filme;

-- 05. Alterar o ano de lançamento igual 2007 para filmes que iniciem com a Letra "B".

update filme
set ano_de_lancamento = '2007'
where titulo like 'B%';

-- 06. Listar os filmes que possuem duração do filme maior que 100 e classificação igual a "G".

select duracao_do_filme, classificacao from filme
where duracao_do_filme >= 100 and classificacao ='G';

-- 07. Alterar o ano de lançamento igual 2008 para filmes que possuem duração da locação menor que 4 e classificação igual a "PG".

set sql_safe_updates=0;
update filme
set ano_de_lancamento = '2008'
where classificacao like 'PG' and duracao_da_locacao < 4;

-- 08. Listar a quantidade de filmes que estejam classificados como "PG-13" e preço da locação maior que 2.40.

Select classificacao, preco_da_locacao from filme
where classificacao = 'PG-13' and preco_da_locacao >2.40;


-- 09. Listar a quantidade de filmes por classificação.

Select classificacao, count(*) qt from filme
group by classificacao;

-- 10. Listar, sem repetição, os preços de locação dos filmes cadastrados


Select distinct preco_da_locacao, count(*) qt from filme
group by preco_da_locacao;
