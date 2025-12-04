---
trigger: always_on
---

DATABASE SCHEMA & MODELS

CORE MODELS (77 total)

Inventory & Products:
- Product - Main product model with variants support
- ProductVariant - Product variations (size, color, etc.)
- CombinedProduct - Combo/bundle products
- Category - Product categories
- Brand - Product brands
- Unit - Measurement units (with base/sub-unit relationships)
- product_warehouse - Pivot table for product stock per warehouse

Transactions:
- Sale - Sales transactions
- SaleDetail - Sale line items
- Purchase - Purchase orders
- PurchaseDetail - Purchase line items
- Quotation - Sales quotations
- QuotationDetail - Quotation line items
- DraftSale - Draft/pending sales
- DraftSaleDetail - Draft sale line items

Returns:
- SaleReturn - Sales returns
- SaleReturnDetails - Return line items
- PurchaseReturn - Purchase returns
- PurchaseReturnDetails - Purchase return line items

Payments:
- PaymentSale - Sale payments
- PaymentPurchase - Purchase payments
- PaymentSaleReturns - Sale return payments
- PaymentPurchaseReturns - Purchase return payments
- PaymentWithCreditCard - Stripe payment records

Inventory Operations:
- Adjustment - Stock adjustments
- AdjustmentDetail - Adjustment line items
- Transfer - Warehouse transfers
- TransferDetail - Transfer line items
- CountStock - Stock count records
- Shipment - Delivery/shipment tracking

Parties:
- Client - Customers
- Provider - Suppliers
- Warehouse - Storage locations
- UserWarehouse - User-warehouse assignments

Accounting:
- Account - Bank/cash accounts
- Expense - Expense records
- ExpenseCategory - Expense categories
- Deposit - Deposit records
- DepositCategory - Deposit categories
- TransferMoney - Money transfers between accounts

HRM:
- Employee - Employee records
- EmployeeAccount - Employee bank accounts
- EmployeeExperience - Work experience
- EmployeeProject - Project assignments
- EmployeeTask - Task assignments
- Company - Company/branch records
- Department - Departments
- Designation - Job positions
- OfficeShift - Work shifts
- Attendance - Attendance records
- Leave - Leave requests
- LeaveType - Leave types
- Holiday - Holiday calendar
- Payroll - Payroll records

Projects & Tasks:
- Project - Project management
- Task - Task management

System:
- User - System users
- Role - User roles
- Permission - Permissions
- role_user - User-role pivot
- Setting - System settings
- PosSetting - POS-specific settings
- Currency - Currency management
- EmailMessage - Email templates
- SMSMessage - SMS templates
- sms_gateway - SMS gateway configuration

KEY RELATIONSHIPS:
- Products have many variants
- Products belong to categories and brands
- Products exist in multiple warehouses (many-to-many)
- Sales/Purchases have many details (line items)
- Users can be assigned to specific warehouses
- Employees belong to departments and have designations
- Projects have many tasks
