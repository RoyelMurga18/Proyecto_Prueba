Select * from customers

Use Northwind;
-----Funciones Escalares
--dias trasncurridos desde la fecha de pedido hasta hoy
Select orderid, orderdate
, datediff(dd,[orderdate],getdate()) as DiasTranscurridos
from orders
--Edad
declare @fechanacimiento date= '01-25-76'
Select datediff(yy,@fechanacimiento,getdate()) as Edad

--Usando funcion escalar substring --calculo fila por fila
Select companyname, substring(companyname,1,3) as PrimerasTresLetras
from customers

-----Funciones de Agregado---------------
Select count(*) from customers

Select country, count(*) from customers
group by country

/* Usando funciones de agregado determine cuanto
ha sido el total de ventas que ha realizado en todas las 
ordenes un ciente, debe usar customers, orders, [order details]
*/
---Uso de la funcion CAST
Select 'El producto:'+ productname + 
', tiene el precio de: '+ cast(unitprice as varchar(10)) as
precio
from products
--
Select CAST(sysdatetime() as date);
---------CONVERT
Select 'El producto:'+ productname + 
', tiene el precio de: '+ convert(varchar(10),unitprice) as precio
from products

Select  Try_convert(int,productname) as precio
from products
----
Select CURRENT_TIMESTAMP as Fecha
Select convert(char(8), CURRENT_TIMESTAMP, 101) as ISO_USA;
Select convert(char(8), CURRENT_TIMESTAMP, 102) as ISO_ANSI;
Select convert(char(8), CURRENT_TIMESTAMP, 103) as ISO_UK_FR;
Select convert(char(8), CURRENT_TIMESTAMP, 104) as ISO_GER;
---PARSE SQL 2012
SELECT PARSE('ddfdf Monday, 13 december 2010' 
AS DATETIME2 USING 'EN-us')  AS FECHA

 SELECT TRY_PARSE('Monday, 13 december 2010' 
 AS DATETIME2 USING 'EN-us')  AS FECHA

 --------------CHOOSE---------
 select productname, unitprice, 
 choose(categoryid,
'Beverages' ,'Condiments','Confections','Dairy Products'
,'Grains/Cereals','Meat/Poultry','Produce','Seafood') as category
 from products
----------------ISNULL
 SELECT COMPANYNAME, FAX FROM CUSTOMERS
 SELECT COMPANYNAME, isnull(FAX,'0000-0000') FROM CUSTOMERS

 select productname, unitprice, 
 iif( Discontinued=0 , 'EnExistencia','Descontinuado') 
 as Discontinued 
 from products
 -------------------Count
 Select count(*) from orders  --el numero de filas
 select count(customerid) from orders  ---el numero de filas
 select count(distinct customerid) from orders --el numero de clientes
 --no repetidos que ordenaron
 select distinct count_big(customerid) from orders

 select count(coalesce(fax,'00-00')) from customers
 

 Select coalesce(fax,'00-00') from customer


 Select isnull(fax,'00-00') from customers

Select distinct country from customers

Select country from customers
group by country
--------------------------------------------------------
Select c.companyname, p.productname
, sum(od.unitprice * od.quantity) as total, grouping(c.companyname)
from customers as c inner join orders as o
on c.customerid=o.customerid
inner join [Order Details] as od
on o.orderid=od.orderid
inner join products as p
on p.ProductID=od.ProductID
group by  c.companyname, p.productname with rollup
order by c.companyname, p.productname
 














