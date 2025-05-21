
drop database if exists biblioteca;

create database biblioteca;

use biblioteca;

-- tabela autor
CREATE TABLE autor (
    codigo INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    CONSTRAINT PK_autor PRIMARY KEY (codigo)
);
 
 -- tabela categoria
 
CREATE TABLE categoria (
    codigo INT AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL,
    CONSTRAINT PK_categoria PRIMARY KEY (codigo)
);

 
CREATE TABLE livro (
    isbn VARCHAR(13) NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    ano INT NOT NULL,
    editora VARCHAR(100) NOT NULL,
    cocategoria INT NOT NULL,
    CONSTRAINT PK_livro PRIMARY KEY (isbn),
    CONSTRAINT FK_livro_categoria FOREIGN KEY (cocategoria) REFERENCES categoria (codigo)
);


 
CREATE TABLE autor_livro (
    isbn VARCHAR(13),
    coautor INT,
    CONSTRAINT PK_autorlivro PRIMARY KEY (isbn , coautor),
    CONSTRAINT FK_autorlivro_livro FOREIGN KEY (isbn)
        REFERENCES livro (isbn),
    CONSTRAINT FK_autorlivro_autor FOREIGN KEY (coautor)
        REFERENCES autor (codigo)
);
 
 
 alter table livro add constraint CHK_livro_ano check (ano >= 1990 and ano <= year(sysdate()));
 
 
desc autor;
desc livro;
desc categoria;
desc autor_livro;

select * from autor;
select * from livro;
select * from autor_livro;

insert into autor (nome, nacionalidade, data_nascimento) values('Monteiro Lobato','Brasileiro','1882-04-18');
insert into autor (nome, nacionalidade, data_nascimento) values('Stephen King','Estadunidense','1947-09-21');
insert into autor (nome, nacionalidade, data_nascimento) values('Clarice Lispector','Ucraniana','1920-12-10');
insert into autor (nome, nacionalidade, data_nascimento) values('Mário de Andrade','Brasileiro','1893-10-09');


insert into categoria(descricao) values
('Ficção'),
('Romance'),
('Infantil'),
('Suspense'),
 ('Terror');
 
 select * from categoria;
 
 insert into livro(isbn, titulo, ano, editora, cocategoria ) values ('9788581050379','À espera de um Milagre',2013,'Suma',4);
 insert into livro(isbn, titulo, ano, editora, cocategoria ) values ('9788556510464','O Iluminado',2017,'Suma',4);
 
   select * from livro;
   
 insert into autor_livro(isbn, coautor) values ('9788581050379',2);
 insert into autor_livro(isbn, coautor) values ('9788556510464',2);
 

  Select * from autor_livro;