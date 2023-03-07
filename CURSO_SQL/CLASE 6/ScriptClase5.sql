----------------Consultas de Varias Tablas--------
Use Northwind
go

---Inner Join solo incluye los registros donde ambas tablas coinciden
Select customers.customerid, customers.companyname,customers.contactname,
customers.country, orders.orderid, orders.orderdate
from customers inner join orders 
on customers.customerid=orders.customerid


---Inner join usando alias
Select c.customerid, c.companyname,c.contactname,
c.country, o.orderid, o.orderdate
from customers as c inner join orders as o
on c.customerid=o.customerid

---Left Outer join incluye los campos donde ambas tablas coinciden mas los datos de
---la tabla de la izquierda que no coinciden con elementos de la tabla de la derecha

Select c.customerid, c.companyname,c.contactname,
c.country, o.orderid, o.orderdate
from customers as c left outer join orders as o
on c.customerid=o.customerid


---Left Outer join mostrando los elementos de la tabla de la izquierda que no
---coinciden con elementos de la tabla de la derecha
Select c.customerid, c.companyname,c.contactname,
c.country, o.orderid, o.orderdate
from customers as c left outer join orders as o
on c.customerid=o.customerid
where o.orderid is null

---Right Outer join incluye los campos donde ambas tablas coinciden mas los datos de
---la tabla de de la derecha que no coinciden con elementos de la tabla de la izquierda

Select c.customerid, c.companyname,c.contactname,
c.country, o.orderid, o.orderdate
from customers as c right outer join orders as o
on c.customerid=o.customerid


---Right Outer join mostrando los elementos de la tabla de la derecha que no
---coinciden con elementos de la tabla de la izquierda

Select c.customerid, c.companyname,c.contactname,
c.country, o.orderid, o.orderdate
from customers as c right outer join orders as o
on c.customerid=o.customerid
where c.customerid is null

---Cross Outer join muestra todas las combinaciónes posibles entre los elementos
---de la tabla uno contra los elementos de la tabla dos

Select c.customerid, c.companyname,c.contactname,
c.country, o.orderid, o.orderdate
from customers as c cross join orders as o

---Join de la tabla con ella misma
Select j.firstname + ' ' + j.lastname as jefe
, e.firstname + ' ' + e.lastname as subalterno
from employees as j inner join employees as e
on j.employeeid=e.reportsto