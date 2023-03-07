USE Northwind

--USO DE LOTES
--SIRVE PARA SACAR INFO DE DOS SQL DINAMICOS USANDO LOS MISMOS PARAMETROS PERO SEPARADOS POR LOTES
--LOS LOTES SON SEPARADOS POR GO
--Tambien un dato importante que cuando ponemos al parámetro tabla un nombre en la definicion puede ser actualizado con elset
go
Declare @tabla varchar(50) = 'Products'
Set @tabla='Customers';
Execute ('Select * from ' + @tabla);
go

Declare @tabla varchar(50)='Customers';
Execute('Select* from ' + @tabla)
go

Declare @valor int; --aquí declaramos la variable
Select @valor=COUNT(*) from Orders--aquí solo guardamos en el parametro la consulta
Select @valor -- y aquí se muestra lo que hicimos
go


--USO DE SINONIMOS

Create View VENTAANUALES
as 
Select c.companyname, DATEPART(YYYY,o.orderdate) as anio, SUM (d.unitprice*d.quantity) as total 
from Customers as c inner join orders as o on c.CustomerID=o.CustomerID inner join [Order Details] as d
 on o.OrderID=d.OrderID group by c.CompanyName,DATEPART(YYYY,o.orderdate)

--AHORA A ESTE VISTA LE COLOCAMOS UN NOMBRE MAS AMIGABLE

CREATE SYNONYM VA FOR VENTAANUALES

--EXPRESAN LO MISMO SOLO QUE SE USA PARA TRABAJAR CON UN NOMBRE MAS FÁCIL
--TAMBIEN PUEDE ESTAR DENTRO DE UN PROCEDURE
SELECT *FROM VA
SELECT * FROM VENTAANUALES

--CREACION DE CICLOS WHILE
DECLARE @empid int =1, @lname nvarchar(20);
while @empid<=5
begin 
Select @lname=LastName from Employees where EmployeeID=@empid
print @lname
set @empid+=1
END;


--CREACION DE CICLO IF
Create Procedure InsertarCatalogo
@Companyname varchar(150), @contactname varchar(150), @contacttitle varchar(150), 
@country varchar(150), @tabla varchar(100)

as

if @tabla='Customers'
 Begin 
     Insert into Customers (CustomerID, CompanyName, ContactName, ContactTitle, Country)
	 Values (SUBSTRING(@Companyname,1,5), @Companyname, @contactname, @contacttitle, @country)
 End

else 
   Begin 
       Insert into Suppliers(CompanyName, ContactName, ContactTitle, Country)
	   Values (@companyname, @contactname, @contacttitle, @country)
   End

Execute InsertarCatalogo 'VISOAL,S.A.', 'Victor Cardenas', 'Ing', 'Guatemala', 'Suppliers'
Execute InsertarCatalogo 'VISOAL,S.A.', 'Victor Cardenas', 'Ing', 'Guatemala', 'Customers'

Select * from Customers
Select * from Suppliers

--Como administramos los mensajes de errores
