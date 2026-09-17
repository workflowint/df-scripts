if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DistanceCalc]') and OBJECTPROPERTY(id, N'IsScalarFunction') = 1)
drop function [dbo].[DistanceCalc]
GO
CREATE function [dbo].[DistanceCalc] (@lat1 float, @lon1 float, @lat2 float, @lon2 float)
returns float

as

begin
declare @Dist AS FLOAT
declare @DistLat AS FLOAT
declare @DistLong AS FLOAT

SET @DistLat = 69.1 * ( ABS(@lat2 - @lat1))
SET @DistLong = 53 *( ABS(@lon2 - @lon1))
SET @Dist = SQRT( (@DistLat * @DistLat) + (@DistLong * @DistLong))
return (@Dist)

end

GO
GRANT  EXECUTE ON [dbo].[DistanceCalc]  TO [DeskFlowUsers]

GO
CREATE FUNCTION CDNCodes(@longitude float, @latitude float, @radius int )
RETURNS @CDNPostCodes TABLE (
   AddressesId       int    NOT NULL PRIMARY KEY CLUSTERED
) 
AS
BEGIN
   insert into @CDNPostCodes ( AddressesID)
select AddressesID from Addresses  with ( nolock) where postalcode in (
 SELECT zip  FROM postalcodes WITH (NOLOCK) WHERE (dbo.DistanceCalc(@latitude,@longitude, latitude,longitude)) <=@radius
 union
 SELECT  substring(zip,1,3)+' '+substring(zip,4,3)  FROM postalcodes WITH (NOLOCK) 
 WHERE (dbo.DistanceCalc(@latitude,@longitude, latitude,longitude)) <=@radius)
  
   RETURN;
END;
GO 
GRANT  SELECT ON [dbo].[CDNCodes]  TO [DeskFlowUsers]
