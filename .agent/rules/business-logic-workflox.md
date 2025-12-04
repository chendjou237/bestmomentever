---
trigger: always_on
---

BUSINESS LOGIC & WORKFLOWS

INVENTORY MANAGEMENT

Product Creation:
- Support for simple and variant products
- Automatic barcode generation option
- Multi-warehouse stock tracking
- Cost and price per variant

Stock Adjustments:
- Add/subtract stock
- Linked to specific warehouse
- Audit trail maintained

Warehouse Transfers:
- Transfer stock between warehouses
- Automatic stock updates
- Transfer status tracking

Stock Count:
- Physical inventory counting
- Variance reporting
- Adjustment creation from count

SALES WORKFLOW:
Quotation → Sale → Payment → Shipment
Sale Return → Return Payment
Draft Sales for POS (save and resume later)

PURCHASE WORKFLOW:
Purchase Order → Payment → Stock Update
Purchase Return → Return Payment → Stock Adjustment

POS WORKFLOW:
1. Select warehouse and customer
2. Add products (barcode scan or search)
3. Apply discounts/taxes
4. Process payment (cash, card, Stripe)
5. Print receipt
6. Option to save as draft

PROFIT CALCULATION

Methods Supported:
- FIFO (First In, First Out)
- Average Cost

Cost of Goods Sold (COGS) formula implemented
Profit = Revenue - COGS - Expenses
