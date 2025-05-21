use bdmaternidade;

create table mae (
id_mae int not null,
rg varchar(10),
endereco varchar(200),
telefone varchar(20),
data_nascimento date,
primary key (id_mae));

create table medico(
crm int not null,
nome varchar(100),
telefone varchar(20),
especialidade varchar(100),
primary key (crm));

create table bebe (
id_bebe int not null,
nome varchar(100),
data_nascimento date,
peso float(5,2),
altura int,
crm int not null,
id_mae int not null,
id_mae int not null,
primary key (id_bebe),
foreign key (crm) references medico(crm),
foreign key (id_mae) references mae(id_mae));