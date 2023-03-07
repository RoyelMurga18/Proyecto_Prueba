USE Northwind

--Procedimiento almacenado sin parámetros
CREATE PROCEDURE Proc_Ventas
as
Select c.customerid, c.companyname, o.orderid, o.orderdate from Customers as c inner join orders as o on 
c.CustomerID=o.CustomerID

Execute Proc_Ventas

--Esto es mas que una vista porque se pueden meter parámetros.

--Procedimiento almacenado con parámetro
--pero tambien con modificación
Alter Procedure Proc_Ventas @cliente varchar(5)
as
Select c.customerid, c.companyname, o.orderid, o.orderdate from Customers as c inner join orders as o on 
c.CustomerID=@cliente

Execute Proc_Ventas @cliente='ANTON'

--Si queremos borrar el procedimiento
DROP PROCEDURE Proc_Ventas

--Esto es mas que una función porque puede extenderse más 
Create Proc Proc_Insert_Cliente (@customerid varchar(5), @companyname varchar(100), @contactname varchar(100), @country varchar(100)) as 
Insert into Customers (CustomerID, CompanyName,ContactName,Country)
values
(@customerid , @companyname , @contactname , @country )

---Si los parametros lo ponemos en el orden en que lo creamos no habría que poner parametros
Exec Proc_Insert_Cliente 'VHCV3','VISOAL','Victor Cardenas', 'Guatemala'

SELECT * FROM Customers where CustomerID='VHCV3'

--Creacion de Procedure para un Update con parametro de salida
--si EL PARAMETRO ES DE ENTRADA NO ES NECESARIO PONER INPUT PERO SI ES DE SALIDA SI ES NECESARIO PONER OUTPUT

Create Proc Proc_Cambio_Pais @PaisNuevo varchar(150), @PaisViejo varchar(150), @filasafectadas int output
as
Update Customers set Country=@PaisNuevo
where Country =@PaisViejo
Set @filasafectadas=@@ROWCOUNT -- esto para que nos diga cuantas filas se afectaron en nuestro parámetro de salida

Declare @variable int --declaro una variable para mostrar lo que se guardo en @filasafectadas
Execute Proc_Cambio_Pais 'Estados Unidos', 'USA',@variable Output -- para decirle que es el parametro de salida	
Select @variable

--Consultamos si se cambio y si es la cantidad que arroja el sistema
Select * from Customers where Country = 'Estados Unidos'

---Para saber cuantos parametros tiene un procedimiento almacenado hacemos
---Primero sacamos su codigo de objeto (procedimiento)
Select*From sys.objects where name='Proc_Cambio_Pais'
----Luego filtramos los parametros por el codigo de objeto
--Aquí te dice si es parametro de salida o no, que posicion tiene....
Select*from sys.parameters where object_id=1330103779


--Ahora obtengamos los productos que se han vendido en un año especifico


Select distinct p.productid, p.productname from Products as p inner join [Order Details] as d on p.ProductID=d.ProductID
inner join orders as o on o.OrderID=d.OrderID
where DATEPART(MM,o.OrderDate)=1 and DATEPART(YYYY, o.OrderDate)=1998

---SQL DINAMICO: UN conjunto de deinstrucciones puestas en cadena de texto
Execute ('Select Customerid, companyname from Customers ')

--- si ahora hacemos que sea dinamico (se ejecuta todo junto)
declare @tabla varchar(100)
set @tabla='Customers where country = ''Mexico'''
Execute('Select * from ' + @tabla)

--Otra forma de usar el SQL DINAMICO ES:
--Esto es mejor y mas eficiente 
Declare @sqlstring nvarchar(500)
Declare @paramdescription nvarchar(500)
set @sqlstring='Select EmployeeId, Firstname, Lastname, Reportsto from Employees where ReportsTo=@report'
set @paramdescription='@report int'
Execute Sp_executeSQL @sqlstring, @paramdescription, @report=5


--Encapsulando en un procedimiento almacenado lo ultimo
Create Procedure Proc_subalternos @report int
as
Declare @sqlstring nvarchar(500)
Declare @paramdescription nvarchar(500)
set @sqlstring='Select EmployeeId, Firstname, Lastname, Reportsto from Employees where ReportsTo=@report'
set @paramdescription='@report int'
Execute Sp_executeSQL @sqlstring, @paramdescription, @report

--Ejecutando
Execute Proc_subalternos 5