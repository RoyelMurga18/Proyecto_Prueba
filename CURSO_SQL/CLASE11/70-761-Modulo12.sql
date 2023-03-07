---La sentencia UNION ALL --> LAS TABLAS A UNIR DEBEN TENER EL MISMO FORMATO (MISMO NOMBRE COLUMNAS, MISMO TAMAÑO)
--- Y CADA CAMPO TENGA EN EL MISMO FORMATO
--- UNION ALL CONSOLIDAD TODO LOS REGISTROS NO IMPORTA SI HALLA REPETIDO EN EL CASO DE QUE SOLO SE QUIERA UNICOS USAR
--- UNION, PERO UNION ALL ES MAS RAPIDO

Create View ContactCatalog
as
Select companyname, contactname, city, country from Customers
union all
Select companyname, contactname, city, country from Suppliers
go

Select * from ContactCatalog

----interseccion de las dos tablas por el codigo
----esto es como un inner join (solo los que se intersectan)
Select customerid from customers --codigos de clientes
intersect
select customerid from orders    --codigos de clientes que ordenaron


----donde no se intersetan las dos tablas por el codigo, no han ordenado
Select customerid from customers --codigos de clientes
except
select customerid from orders    --codigos de clientes que ordenaron

----Operador Union  
----Juntando los datos de dos tablas
Select companyname, fax,contactname, country, 'Cliente' as estado
from customers
union all
Select companyname,'' ,contactname, country, 'Proveedor' as estado
from suppliers

----USO DE APLY

--Clientes que han ordenado
Select c.customerid, c.companyname, c.country, o.Orderid, o.orderdate from Customers as c inner join Orders as o on
c.CustomerID=o.CustomerID

--clientes que no han ordenado
Select c.customerid, c.companyname, c.country, o.Orderid, o.orderdate from Customers as c left outer join Orders as o on
c.CustomerID=o.CustomerID where o.OrderID is null


--Funcion de tabla en linea que devuelva las ordenes hecha por el cliente
create function fn_cliente_ordenes (@codigocliente varchar(5))
returns table
as
Return (
Select orderid, orderdate from orders where CustomerID=@codigocliente
)

--Revisar la funcion
select * from fn_cliente_ordenes('ANTON')

--Ahora el Cross Aply devuelve por cada fila de la tabla izquierda una expresion de tabla de la derecha 
--Conceptualmente similar a INNER JOIN entre dos tablas pero puede correlacionar datos entre dos fuentes

--por cada cliente me da ordenes de dato
Select c.customerid, c.companyname, c.country, o.orderid, o.orderdate from Customers as c cross apply fn_cliente_ordenes(c.customerid) 
as o order by c.customerid

--Ahora el OUTER Aply devuelve la expresion de tabla derecha a cada fila de la tabla izquierda
--agrega filas para aquellos con null en columnas la tabla derecha 
--Conceptualmente similar a Left outer JOIN 

--clientes que no hicieron ordenes
Select c.customerid, c.companyname, c.country, o.orderid, o.orderdate from Customers as c outer apply fn_cliente_ordenes(c.customerid) 
as o where o.OrderID is null

--EN resumen el cross y oter apply me permiten combinar uyn tabla con una expresion de tabla
