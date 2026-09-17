ALTER TABLE ClientConfig add UseMonthlySalary bit, SalaryMultiplier float
GO 
Update ClientConfig set UseMonthlySalary=0, SalaryMultiplier=1
GO
ALTER TABLE Positions add SalaryMultiplier float
GO
ALTER TABLE Projects add SalaryMultiplier float