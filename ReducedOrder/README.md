ReduceOrder
===
Reduce continuous linear model order

Syntax
---
PlantC_RO=ReduceOrder(PlantC)

Description
---
This function reduce linear model order by removing dipole and poles/zeros far from imaginary axis.

NOTICE: use ReduceOrder() before adding any controller or compensator, otherwise this function might remove the poles/zeros of controller/compensator.
