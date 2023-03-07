use northwind;

--Comsultas Autonomas,

 lo que esta en lo interno no depende de lo que esta afuera
---Subquery devuelto como un escalar calculando fila por fila

Select productname, unitprice, 
(Select avg(unitprice) from products) as Promedio, 
(Select avg(unitprice) from products)-unitprice as varianza
from products

--------------------Subquery como tabla---------------
Select T.orderid, Sum(T.unitprice*T.quantity) as Total from
#Ventas -- AQUI IRÍA LA CONSULTA DE ABAJO PERO YA SE GUARDO COMO UN TEMPORAL
as T
group by T.orderid

----Creacion de una vista, la instruccion orderby no se puede acompañar con el create view, puede que si ofset
Create view ventas
as
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity, d.unitprice*d.Quantity as [Partial] from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID

---Consultar a traves de la vista creada 
Select Companyname, SUM([Partial]) as total from ventas
GROUP BY CompanyName

----borrar la vista
drop view ventas

------------Querys Empaquetados------------------------------
--Vista, esto para poder modificar los nombres de las columnas en la tabla ya copnsultada
go
Create view ventas
(compañia, numero_orden, fecha, producto, precio, cantidad)
as
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID

Select * from ventas
drop view ventas


----Crear una tabla temporal
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity 
into #Ventas
from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID

----Usando la tabla temporal
Select T.orderid, Sum(T.unitprice*T.quantity) as Total from
#Ventas
as T
group by T.orderid

----borrar la tabla ventas
drop table #Ventas


--AQUI HACIENDO UNA SUBCONSULTA CON EL TEMA DE
Select T.orderid, Sum(T.unitprice*T.quantity) as Total from
(
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
)
as T
group by T.orderid
--Una consulta que se vuelve a consultar debe de tener alias para el correcto trabajo

----Sub-consultas correlacionadas

---------------Si existe el query de adentro hace el query de fuera
--lo que trata de expresar la consulta es que si existe la consulta interna aunque sea da un registro
--pues que consulte la consuylta de afuera, de lo contrario no se mostrara ninguno
Select c.companyname, c.country, c.contactname 
from customers as c where exists
(Select o.customerid from orders as o where year(o.orderdate)=2016)

----correlacionandolo --informacion de los clientes que si han ordenado
Select c.companyname, c.country, c.contactname 
from customers as c where exists
(Select o.customerid from orders as o where c.CustomerID=o.CustomerID)

---subquery con resultado de multiples valores
--aqui una consulta sirve como filtro para la consulta externa
Select c.companyname, c.country, c.contactname 
from customers as c where c.customerid in
(Select customerid from orders )
-


----devuelvame todas las ordenes donde se pidieron mas de
----20 unidades del producto 23

Select o.orderid, o.orderdate from orders as o
where 20<
(
Select d. quantity from [Order Details] as d
where o.orderid=d.orderid and d.productid=23
)


----Creacion de vista
--con el mismo nombre por defecto
Create view clientesfrancia
as
Select customerid, companyname, contactname, country
from customers
where country='France'
with check option


----Consulta de vista
Select * from clientesfrancia

---------------------Funciones con valores de tabla en linea

--FUNCIONES DE VALORES EN TRABLE EN LÍNEA
--LA DFIFERENCIA DE UNA FVT A UNA VISTA ES QUE ESTA PRIMERA ADOPTA PARAMETROS DE ENTRADA
--INLINE --> BASASDO EN SENTENCIAS SELECT
--MULTI-STATEMENT CREA Y CARGA UNA VARIABLE DE LA TABLA

CREATE function fnVentas (@productid int)
Returns Table
as
Return(
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
where d.ProductID=@productid
)

--USAR LA FUNCION
Select * from fnVentas(14)

--MODIFICAR LA FUNCION
ALTER function fnVentas (@productid int)
Returns Table
as
Return(
Select c.companyname, o.orderid, o.orderdate, p.ProductID,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
where d.ProductID=@productid
)

--USAR LA FUNCION
Select * from fnVentas(23)

--Eliminar la funcion 
Drop function fnVentas

------------------------------------------------TABLAS DERIVADAS---------------------------------
-- ESTAS NO SON ALACENADOS COMO LAS VISTAS
--Deben de tner un alias, nombre unicos, no usa order by sino offset o fetch
Select T.jefe, count(T.subalterno) from (Select j.Firstname+' '+j.Lastname as jefe, s.Firstname+' '+s.Lastname as
subalterno from Employees as j inner join Employees as s on j.EmployeeID=s.ReportsTo) as T GROUP BY T.jefe

--Puede escribirse con el sobrenombre luego del alias de la tabla
Select T.jefe, count(T.subalterno) from (Select j.Firstname+' '+j.Lastname , s.Firstname+' '+s.Lastname 
from Employees as j inner join Employees as s on j.EmployeeID=s.ReportsTo) as T (jefe, subalterno) GROUP BY T.jefe

--Puede recibir parametros, y se puede ir a anidar pero ya no es lo más practico y recomendable debido al rendimiento de las
--consultas
Declare @anio bigint
set @anio=1996
Select t.companyname, t.orderid, sum(t.unitprice*t.quantity) as total from 
(Select c.companyname, o.orderid, o.orderdate, p.ProductID,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
where Year(o.OrderDate)=@anio
) as t group by t.CompanyName, t.OrderID

-----------------------------Commmom Table Expretion-------------------------------------------------
--AMBAS DEBEN EJECUTARSE AL MISMO TIEMPO, PÚEDE ESTA CONSULTA HACERSE COMO UNA CONSULTA DE TABLA DERIVADA PERO,
--VEAMOS QUE ES MAS PRACTICO DADO QUE PRIMERO DEFINIMOS Y LUEGO USAMOS 

With CTE_year as (
Select CustomerID, YEAR(OrderDate) AS YearOrder from Orders)

Select YearOrder, COUNT(Distinct CustomerID)
from CTE_year
group by YearOrder


--EN EL EJEMPLO ANTERIOR DE LOS SUBALTERNOS PERO CON UN CTE
With jefe as (Select EmployeeID, Firstname+' '+Lastname as CompleteName From Employees)

Select jefe.completename, Employees.FirstName+' '+Employees.LastName from Employees inner join Jefe on 
Jefe.EmployeeID=Employees.ReportsTo

--CTE ANIDADO
--UNA CONSULTA DONDE SE DEVOLVERA EL JEFE Y SUS SUBALTERNOS

CREATE FUNCTION fn_jefe (@empid int)
RETURNS TABLE
AS
RETURN
(
WITH EMPLEADO_ARBOL (EmployeeID, Name, ReportsTo, LVL) as (SELECT EmployeeID, Firstname+' '+Lastname as name,
ReportsTo, 0 as LVL from Employees WHERE EmployeeID=@empid
UNION ALL
SELECT e.EmployeeID, e.FIRSTNAME+' '+ e.LastName AS name, e.REPORTSTO, LVL +1 as LVL FROM Employees
AS e INNER JOIN EMPLEADO_ARBOL AS es ON es.EMPLOYEEID=e.ReportsTo)

SELECT * FROM EMPLEADO_ARBOL
)

select * from fn_jefe(5)

---------------------UNION DE TABLAS CON EL MISMO FORMATO------------------------

Select companyname, country from customers
union ALL
Select companyname, country from suppliers









