# CommissionDB

Selected SQL files relating to CSR commissions for explanation

Table_CommMatrixCSR file stores rules for commission assignments based upon 5 Factors
  Manufacturer
  Territory
  Sales Rep
  Customer Account
  Inventory Item

TEL.vw_CommLogicCSRMatrixAccrued
  This view abstracts the logic from the CommMatrixCSR rules table, Prioritizes the 5 factors and applies the logic
  to every sales detail line.  This view can also be repointed at live sales data instead of the frozen data set for
  partial month reporting


TELAccrued 07a CSR CommissionRecord_INSERTSELECT
  This query uses the view to insert the commission calculations into a table for historical record keeping.
  

There are other many other tables and views in the overall process such as a similar structure to pay sales rep and
management commissions but this selection should give an idea of how it works.


