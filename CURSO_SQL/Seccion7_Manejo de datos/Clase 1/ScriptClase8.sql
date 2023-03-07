-------------------------------Insert-----------------------------------
USE Northwind
Insert into Customers (CustomerID ,CompanyName ,ContactName
,ContactTitle ,[Address] ,City ,Region ,PostalCode ,Country ,Phone, Fax)
values
('ABCD5','Compañia, S.A.','Juan Perez','Ing','7av 3-3 Zona 5'
,'Guatemala','Guatemala','01005', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676'),
('ABCD6','OtraCompañia, S.A.','Ana Perez','Lic','7av 3-3 Zona 10'
,'Guatemala','Guatemala','01010', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676')

---------------------Insertar datos a partir de un select------------------------
Insert into customers
 Select Concat(substring(Replace(companyName,' ',''),1,4),'9') as codigo
 , CompanyName  ,ContactName ,ContactTitle ,[Address] ,City
 ,Region ,PostalCode  ,Country ,Phone, Fax
from suppliers

-----Creando un procedimiento almacenado para posteriormente insertar datos------
CREATE Procedure DatosProveedor
as
 Select Concat(substring(Replace(companyName,' ',''),1,4),'9') as codigo
 , CompanyName  ,ContactName ,ContactTitle ,[Address] ,City
 ,Region ,PostalCode  ,Country ,Phone, Fax
from suppliers
-----Insertar datos a partir del procedimiento anterior creado---------------------
Insert into Customers
Execute DatosProveedor

---------------------Crear a partir de los datos de un select otra tabla-----------
select c.customerid, c.companyname, o.orderid, o.orderdate
INTO ORDENESNUEVAS
from customers as c inner join orders as o
on c.CustomerID=o.customerid

Select * from ORDENESNUEVAS
---------------------Borrar el objeto-----------------------------------
DROP TABLE ORDENESNUEVAS
---------------------Objetos Temporales
#TablaTemporal    --Tabla Temporal Local solo se ve en mi sesion (local)
##TablaTemporal   --Tabla Temporal se ve en todas las sesiones (global)

---------------------Crear una tabla basica para usar default----------
Create table Test
(codigo int identity(1,1) not null primary key,
nombre varchar(100),
estadocivil varchar(100) default ('Soltero')
)

Insert into Test(  nombre, estadocivil)
values ('Juan Piao', DEFAULT)

---------------------------------Borrar datos------------------------------------
select * from ORDENESNUEVAS

--------------------BORRA SIN PASAR POR EL LOG DE TRANSACCIONES (CRIMEN PERFECTO)
TRUNCATE TABLE ORDENESNUEVAS

--------------------BORRADO NORMAL CON DELETE------------------------------------
DELETE FROM CUSTOMERS WHERE CUSTOMERID IN
(Select concat(substring(Replace(companyName,' ',''),1,4),'9') as codigo
from suppliers)
-------------
SELECT C.CUSTOMERID, C.COMPANYNAME, O.ORDERID, O.ORDERDATE
FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON C.CustomerID=O.CustomerID
WHERE O.OrderID IS NULL


--------------------ELIMINAR DATOS DE UNA TABLA CON RESPECTO A OTRA TABLA
--ELIMINAR LOS CLIENTES QUE NO HAN REALIZADO UNA ORDEN
Delete from C
from customers as c left join orders as o
on c.CustomerID=o.customerid where
 o.orderid is null


--------------------UPDATE
UPDATE CUSTOMERS
SET CompanyName=Companyname+',USA'
where country='USA'

--------------------ACTUALIZAR
--TODOS LOS PRECIOS DE LOS PRODUCTOS DE ESTADOS UNIDOS
SELECT S.COMPANYNAME
, S.COUNTRY, P.PRODUCTNAME, P.UnitPrice
FROM
SUPPLIERS AS S INNER JOIN
PRODUCTS AS P ON P.SupplierID=S.SupplierID
WHERE S.COUNTRY='USA'
--------------------SUBE EL 5% A TODOS LOS PRODUCTOS DE USA
UPDATE P SET P.UnitPrice=P.UnitPrice * 1.05
FROM
SUPPLIERS AS S INNER JOIN
PRODUCTS AS P ON P.SupplierID=S.SupplierID
WHERE S.COUNTRY='USA'
----------------------------Merge-------------------------------------------------

Select CustomerID, CompanyName, ContactName, ContactTitle
into ClientesA
from Customers where Country in ('Mexico', 'Argentina', 'Venzuela')

Select CustomerID, CompanyName, ContactName, ContactTitle
into ClientesB
from Customers where Country in ('Mexico', 'Argentina', 'Venzuela')

--Eliminar y actualizar datos de cliente A para provocar diferencias con resto Clientes B

Delete clientesA where companyname like '[a-d]%'

Update clientesA Set companyname='Nombre-Eliminado', ContactName='No-tiene' where CustomerID like '[O-P]%'

Delete from ClientesB where CustomerID='TORTU'

--Consultar tablas modificadas 
Select*from ClientesA
Select*From ClientesB

--Como se puede apreciar difieren en algunos registros las tablas de clientes A y b

Merge Into ClientesA as A using ClientesB as B -- el primero es la tabla objetivo y el 2do la tabla fuente
ON A.CustomerId=B.CustomerId --campo comun por el cual coincidan las tablas
When matched then --PASARLE DE B a A PORQUE EN 2 CASOS NO TIENE NOMBRE NI CONTACTO
    update set A.Companyname=B.companyname, A.contactname=B.contactname	
	when not matched then 
	 insert (customerid, companyname, contactname, contactTitle) Values
	 (B.customerid, B.companyname, B.Contactname, B.contacttitle)
	 when not matched by source then 
	 delete; 

-- Y si ahora consultamos nuestras tablas deberían estar iguales.
Select*from ClientesA
Select*From ClientesB

---------------------------Identity--------------------------
DBCC CHECKIDENT (suppliers, RESEED, 200);
GO
Set identity_insert suppliers on

--Crea una tabla que tendrá un codigo unico que se pondra automaticamente y empezara en 5 y avanzara de 5 en 5
Create Table Test1
(codigo int identity(5,5) primary key,
 nombre varchar(100))

 Insert into Test1 (nombre) Values ('Jose Miguel'), ('Monica Susett')

 Select * from Test1


 Select @@IDENTITY -- Dispara el último identity puesto (solo el número porque nosotros sabremos en donde se hizo)

 Select IDENT_CURRENT('Test1')

 --Inserta datos de identity manual, apagando la condicion identity -- pero que no sea un correlativo al identity 
 --es decir manualmente yo no podría poner 15 porque el número que le seguiría es este y habria duplicado
 
 SET IDENTITY_INSERT Test1 ON --ejecuto primero esto para apagarlo
 Insert into Test1 (codigo, nombre) values (3, 'Maria concepcion'), (4, 'Victor Hugo') --inserto
  SET IDENTITY_INSERT Test1 OFF -- ahora prendo la funcion identity


---------------------------Uso de Sequence--------------------
-- Este es un objeto que puede ser tomado no solo por una tabla si no por varias
--Es normal la alerta que sale al ejecutar
Create sequence numerador
as int
start with 5
increment by 5
MinValue 5
MaxValue 100
No cycle
go

--SE USA EL OBJETO MEDIANTE UN SELECT
Select Next Value for numerador -- aquí puedes ejecutar y por cada ejecucion se aumentara en 5



Create table Test2
(codigo int,
nombre varchar(100)
)

--SE USA EL OBJETO MEDIANTE INSERCION EN UNA TABLA
--Le asignara los tres ultimos valores que tendra marcado el objeto sequence
Insert into Test2 (codigo, nombre) values
(next value for numerador, 'Hugo'),
(next value for numerador, 'Paco'),
(next value for numerador , 'Luis')

Select * from Test2

--SE USA EL OBJETO MEDIANTE UNA INSERCION AUTOMATICA (ESTO SERÍA LAFORMA MAS PARECIDA AL IDENTITY)
--Aquí utilizaremos otro forma de colocar el objeto sequence (de forma automatica)
Create table Test3
(codigo int primary Key default (next value for numerador),
nombre varchar(100)
)

insert into Test3 (nombre) values ('Monica'), ('Hugo')

Select * from Test3