delimiter $$
create function dbgeral.cpf_valido()
returns varchar(11)
not deterministic
reads sql data
begin
	declare cont int default 1;
    declare cpf varchar(11) default '';
    declare dig int default 0;
    declare dig1 int default 0;
    declare dig2 int default 0;
    while cont <= 9 do
		set dig = round(rand()*9);
		set cpf = concat(cpf,dig);
        set dig1 = dig1 + ((11 - cont) * dig);
        set dig2 = dig2 + ((12 - cont) * dig);
        set cont = cont + 1;
    end while;
    set dig1 = mod(dig1,11);
    if dig1 < 2 then
		set dig1 = 0;
	else
		set dig1 = 11 - dig1;
    end if;
    set dig2 = dig2 + (dig1 * 2);
	set dig2 = mod(dig2,11);
    if dig2 < 2 then
		set dig2 = 0;
	else
		set dig2 = 11 - dig2;
    end if;
    set cpf = concat(cpf,dig1,dig2);
    return cpf;
end$$
delimiter ;
select dbgeral.cpf_valido();