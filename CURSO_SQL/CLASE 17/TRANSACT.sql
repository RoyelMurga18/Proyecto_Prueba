--Transacciones

--Los comandos de transacción identifican bloques de código que deben tener éxito o fallar juntos y proporcionar
--puntos en los que el motor de base de datos puede revertir o deshacer operaciones.

--BEGIN TRANSACTION marca el punto de partida de una transacción explícita definida por el usuario
--Las transacciones duran hasta que se emite una sentencia COMMIT, se emite manualmente un ROLLBACK, 
--o se rompe la conexión y el sistema emite un ROLLBACK

Use Northwind

---Ver los bloqueos sobre objetos de la BD
sp_lock -- los bloqueos con objetos de bd que estan establecidos

SET XACT_ABORT ON -- ESTO CUANDO SE PONE "ON",PARA CUANDO UNA TRANSACCION TIENE UNA FALLA DENTRO DEL 
              -- CONJUNTO DE LOTES, HACE QUE POR ESTA FALLA NO SE EJECUTE TODO EL CONJUNTO, OSEA FALLE POR COMPLETO


--el primer insert se puede dar pero, fallará el segundo por tema de llave primaria y el tercero tambien 
-- puede darse 

--PRIMERO SE EJECTO EL SET XACT...
--LUEGO SE EJECUTA LA TRANSACCION

BEGIN TRANSACTION
Insert into [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
Values (10248, 22, 11.50, 12, 0)

Insert into [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
Values (10248, 22, 11.50, 12, 0)

Insert into [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
Values (10249, 22, 11.50, 12, 0)

COMMIT TRANSACTION



