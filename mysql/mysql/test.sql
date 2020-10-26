#Stored procedure
DELIMITER $$
CREATE PROCEDURE `trigger_special_article_replenishment_for_store`(IN warehouse varchar(255), product varchar(255), available INT)
BEGIN
SET @WAREHOUSE = (select pk from warehouses where p_code = warehouse);
SET @UPDATED_TIME = CONVERT_TZ(now(),'UTC','Australia/Sydney');
update stocklevels
set
p_available = available,
        modifiedTS =  @UPDATED_TIME,
        p_lastupdatefromisp = @UPDATED_TIME
where p_productcode = product and p_warehouse = @WAREHOUSE;
END$$
DELIMITER ;

 #Create Event
CREATE EVENT event_trigger_special_article_replenishment_for_store
ON SCHEDULE
EVERY 1 DAY
STARTS CONVERT_TZ('2020-04-21 05:00:00','Australia/Sydney','UTC')
COMMENT 'This is for stock Replenishment for specific article, using Uber as live example'
DO
CALL trigger_special_article_replenishment_for_store('0180','95747',90);