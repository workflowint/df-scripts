ALTER TABLE ExpenseCategories add Reimbursement bit default(1)
GO
Update ExpenseCategories set Reimbursement = 1