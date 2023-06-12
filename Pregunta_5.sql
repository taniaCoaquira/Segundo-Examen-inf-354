use master;
drop table suma
drop table nombre
declare @cadena1 varchar(20),
		@cadena2 varchar(20),
		@longitud_cadena1 int,
		@contador int,
		@letra varchar(20),
		@sql nvarchar(4000),
		@columna nvarchar(10),
		@variable int,
		@i int,
		@var varchar(2),
		@sql1 nvarchar(4000),
		@sql2 nvarchar(4000),
		@ver1 int,
		@ver2 int
--validar cadena--
set @cadena1='marthaa'
set @cadena2='marthaaa'
set @ver1=LEN(@cadena1) 
set @ver2=LEN(@cadena2)
while @ver1<@ver2
BEGIN
	declare @c varchar(20)= @cadena2
    set @cadena2=@cadena1
    set @cadena1=@c
    set @ver1=LEN(@cadena1) 
    set @ver2=LEN(@cadena2)
end
--crear tabla con las palabras--
set @contador=1
select @longitud_cadena1=LEN(@cadena1) 
set @sql='create table nombre ('
while @contador<=@longitud_cadena1
begin
  set @letra=LEFT(@cadena1, 1)+cast(@contador as varchar(1)) + ' int,'
  set @cadena1=RIGHT(@cadena1, LEN(@cadena1)-1)
  set @sql = @sql + @letra
  set @contador=@contador+1
end
set @sql=LEFT(@sql, LEN(@sql)-1)
set @sql=@sql+')'
exec sp_executesql @sql

set @contador=1
select @longitud_cadena1=LEN(@cadena1) 
while @contador<=@longitud_cadena1
begin
  set @letra=LEFT(@cadena2, 1)
  set @cadena1=RIGHT(@cadena2, LEN(@cadena2)-1)
  set @columna=(select top 1 COLUMN_NAME
		from INFORMATION_SCHEMA.COLUMNS
		where TABLE_NAME='nombre'
		and left(COLUMN_NAME,1)=@letra
		and ORDINAL_POSITION>=@contador)
  set @sql = 'insert into nombre('+@columna+') values(1)'
  exec sp_executesql @sql
  set @contador=@contador+1
end

--contador de la cantidad de columnas
create table suma(
datos int
);
set @variable=(select count(column_name) 
				from information_schema.columns
				where table_name='nombre')
set @i=1
while @i<=@variable
begin
	set @var =(select column_name from INFORMATION_SCHEMA.COLUMNS where table_name='nombre' and ORDINAL_POSITION=@i) 
	set @sql1 = 'SELECT cast(sum('+@var+') as int) FROM nombre'
	set @sql2 = 'INSERT INTO suma(datos) VALUES (('+@sql1+'));'
	EXEC sp_executesql @sql2
	set @i=@i+1
end
--comparación--
if exists (select * from suma where datos is null)
	print 'No son iguales.'
else
	print 'Son iguales'
