--Funciones Escalares (Ya que se ejecutan una a una )
--Extraer el año y el mes de una fecha

Select OrderID, Orderdate, Year(OrderDate) as Año, MONTH(OrderDate) as Mes from Orders

--Días transcurridos desde la fecha de pedido hadsta hoy
-- dd es para que haga la diferencias en días
Select OrderId, OrderDate, DATEDIFF(dd, [OrderDate], getdate()) as DiasTranscurridos from Orders

--Funciones de Agregado
--Conteo de todos los clientes
Select count(1) from customers


---Conteo de los clientes por País
Select country, count(*) from customers group by country

--Conteo de los productos por categoría 
Select C.categoryName, Count(P.ProductName) from Products as P inner Join categories as C on P.CategoryID=C.CategoryID
Group By C.CategoryName

--Funciones de Ventana, es la funcion en donde se muestra el detalle en conjunto 
--da el total de bebidas,.... con el detalle en si 
Select C.CategoryName, P.ProductName, COUNT(P.productName) over (partition by C.CategoryName) as  Numero
From Products as P inner join Categories as C on P.CategoryID=C.CategoryID


--Conversiones Implicitas (estamos llamando a @string cadena pero se le asigna un valor numerico)
-- a la hora de asignarlo lo asigna como texto
DECLARE @string varchar(10);
set @string = 1 
Select @string + 'Es un texto'

--aquí por el tipo de dato entiende que el valor de texto debe de ser entero por eso suma
DECLARE @notastring int;
set @notastring = '1';
select @notastring + '1'

--Las funciones implicitas no necesariamente son utiles porque el sql no interpreta siempre de la misma manera

--Funcion Convert (a este se le puede dar un estilo) y Cast
Select 'El codigo ' + convert(varchar(5),productid) + ' corresponde al producto ' + productname
+ ' con el precio de ' + convert(varchar(150),unitprice) 
from products
go

Select 'El codigo ' + cast(productid as varchar(5)) + ' corresponde al producto ' + productname
+ ' con el precio de ' + cast(unitprice as varchar(150)) 
from products
go

-- cuando no se pueda convertir el tipo de dato en vez de salir con el try_convert sale null
Select  'El producto' + productname
+ 'tiene el precio de:' + try_convert(varchar(1),unitprice) as precio
from products
go

--Convert tiene un par´´ametro que es utilizado mucho para el tema de formatos
Select CURRENT_TIMESTAMP
Select CONVERT(CHAR(8), CURRENT_TIMESTAMP, 101) AS ISO_USA
Select CONVERT(CHAR(8), CURRENT_TIMESTAMP, 102) AS ISO_ANSI
Select CONVERT(CHAR(8), CURRENT_TIMESTAMP, 103) AS ISO_UK_FR
Select CONVERT(CHAR(8), CURRENT_TIMESTAMP, 104) AS ISO_GER


--Parse (Mayormente usado para convertir fecha en texto a fecha normal)
--cambi la fecha en el formato de ee uu
SELECT PARSE('Monday, 13 December 2010' AS datetime2 USING 'en-US') AS fecha; 
go

SELECT PARSE('€345,98' AS money USING 'de-DE') AS moneda; 
go

--Le falta la "y" por eso me botarúa error si es que usaría solo el parse pero estoy 
--usando el try_parse
SELECT TRY_PARSE('Monda, 13 December 2010' AS datetime2 USING 'en-US') AS fecha; 
go

--ISNUMERIC
--Para validar si es un tipo de datos numerico o no  (0 o 1)
Select Productname, ISNUMERIC(Productname) as validarnumero, Unitprice, ISNUMERIC(Unitprice) as validarnumero2,
Categoryid from Products


--iif es una sentencia de condicion si se cumple el primero se pone el 2do sino el tercero
SELECT     productname, unitprice, 
                IIF(unitprice > 50, 'high','low') AS pricepoint
FROM products;

--choose, basado en la marca que se desgnia al inicio devuelve la categoría correspondiente
Select choose (1, 'a','b','c') -- esto devolvera "a" dado que se ha señalado 1

-- en la tabla de products a cada categoría como valor en vez de darle un valor númerico se le dará un valor de texto
--cuando sea 1 sera beverages ......
SELECT productname, 
CHOOSE (categoryid,'Beverages' ,'Condiments','Confections' ,'Dairy Products' ,'Grains/Cereals' ,'Meat/Poultry' ,'Produce' ,'Seafood')
from products
go

--¿QUe pasa si hay valores nulos en la tabla?

--is null
--cuando no tenga número fax ponerle n/a
Select customerid, companyname, isnull(fax,'n/a') from customers
go

---COALESCE
--Toma el primer valor no nulo de una lista, es decir si fax tiene valor nulo, le coloca phone y si este tambien es 
--nulo le coloca 00000000
SELECT COMPANYNAME, COALESCE(FAX, PHONE, '0000-0000') FROM CUSTOMERS


SELECT     customerid, country, region, city,
                country + ',' + COALESCE(region, ' ') + ', ' + city as location
FROM customers;
go


--nullif si los valores a comparar son iguales se pondrá null sin
--Si el precio de oferta es igual al precio de venta se pone NULL si no pone el precio de oferta
Select p.productname, p.unitprice, d.unitprice, NULLIF( p.unitprice,d.unitprice) as comparación
from products as p inner join [order details] as d
on p.productid=d.productid