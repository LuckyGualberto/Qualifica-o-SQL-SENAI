use ddlbdloja;

create table cliente (
id_cliente varchar(100) not null,
nome varchar (100),
limite_credito float(5,2),
`status`varchar (10),
cep varchar(10),
logradouro varchar(200),
numero int,
primary key (id_cliente) );

show create table cliente;

create table pedido (
id_pedido int not null,
`data`date ,
totalpedido float (5,2),
id_cliente_pedido varchar (100),
primary key (id_pedido),
foreign key (id_cliente_pedido) references cliente (id_cliente));

show create table pedido;

create table categoria (
id_categoria int not null,
nome varchar(100),
primary key (id_categoria));


create table categoria (
id_categoria int not null,
nome varchar(100),
primary key (id_categoria)
);

create table produto (
id_produto int not null,
nome varchar(100),
preco float (5,2),
id_categoria int not null,
primary key (id_produto),
foreign key (id_categoria) references categoria(id_categoria));

show create table produto;

create table pedido_produto(
id_produto int not null,
id_pedido int not null,
quantidade int,
primary key (id_produto, id_pedido),
foreign key (id_produto) references produto(id_produto),
foreign key (id_pedido) references pedido(id_pedido));
