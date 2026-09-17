ALTER TABLE UserLastTouch add PopulateReqvmtsOnBinocularSrch bit
GO
update UserLastTouch set PopulateReqvmtsOnBinocularSrch =1
--for WK
--update UserLastTouch set PopulateReqvmtsOnBinocularSrch = 0
