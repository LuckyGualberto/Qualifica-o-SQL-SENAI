USE dbgeral;
DELIMITER $$

CREATE FUNCTION comparacao(n1 INT, n2 INT)
RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN
    DECLARE msg_comparacao VARCHAR(250);
    
    IF n1 > n2 THEN
        SET msg_comparacao = CONCAT('O número ', n1, ' > ', n2);
    ELSEIF n1 < n2 THEN
        SET msg_comparacao = CONCAT('O número ', n1, ' < ', n2);
    ELSE
        SET msg_comparacao = CONCAT('Os números são iguais: ', n1, ' = ', n2);
    END IF;     

    RETURN msg_comparacao;
END$$

DELIMITER ;

select comparacao (9,5), comparacao (5,9), comparacao (9,9);






DELIMITER $$

CREATE FUNCTION data_br (data_ref DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN DATE_FORMAT(data_ref, '%d/%m/%Y');
END$$

DELIMITER ;

select data_br('1987-07-21'), data_br(curdate());



DELIMITER $$

CREATE FUNCTION signo(dt DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE dtf CHAR(4);
    DECLARE msg VARCHAR(50);

    SET dtf = DATE_FORMAT(dt, '%m%d');

    IF dtf BETWEEN '0321' AND '0419' THEN
        SET msg = 'Áries';
    ELSEIF dtf BETWEEN '0420' AND '0520' THEN
        SET msg = 'Touro';
    ELSEIF dtf BETWEEN '0521' AND '0620' THEN
        SET msg = 'Gêmeos';
    ELSEIF dtf BETWEEN '0621' AND '0722' THEN
        SET msg = 'Câncer';
    ELSEIF dtf BETWEEN '0723' AND '0822' THEN
        SET msg = 'Leão';
    ELSEIF dtf BETWEEN '0823' AND '0922' THEN
        SET msg = 'Virgem';
    ELSEIF dtf BETWEEN '0923' AND '1022' THEN
        SET msg = 'Libra';
    ELSEIF dtf BETWEEN '1023' AND '1121' THEN
        SET msg = 'Escorpião';
    ELSEIF dtf BETWEEN '1122' AND '1221' THEN
        SET msg = 'Sagitário';
    ELSEIF dtf >= '1222' OR dtf <= '0119' THEN
        SET msg = 'Capricórnio';
    ELSEIF dtf BETWEEN '0120' AND '0218' THEN
        SET msg = 'Aquário';
    ELSEIF dtf BETWEEN '0219' AND '0320' THEN
        SET msg = 'Peixes';
    END IF;

    RETURN msg;
END$$

DELIMITER ;


SELECT signo('2024-06-01');






DELIMITER $$

CREATE FUNCTION valor_aleatorio (v1 int, v2 int)
RETURNS VARCHAR(10)
NOT DETERMINISTIC
reads sql data
BEGIN
   return round(RAND()*(v2 - v1)+ v1);
END$$

DELIMITER ;

select valor_aleatorio(10,30);




