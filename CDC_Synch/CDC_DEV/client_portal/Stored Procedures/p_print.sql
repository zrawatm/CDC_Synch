CREATE PROCEDURE [client_portal].[p_print] @message nvarchar(1000)
AS 
BEGIN
	declare @s_msg varchar(2000);
	
	select @s_msg = '[' + format(getdate(), 'yyyy-MM-dd hh:mm:ss') +'] ' + @message;
	
	raiserror(@s_msg, 0, 1) with nowait;
	WAITFOR DELAY '00:00:05';
END