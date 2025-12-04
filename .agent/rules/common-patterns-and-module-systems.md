---
trigger: always_on
---

COMMON PATTERNS & UTILITIES

Bulk Delete Pattern:
public function delete_by_selection(Request $request)
{
    $ids = $request->selectedIds;
    foreach ($ids as $id) {
        Model::findOrFail($id)->delete();
    }
    return response()->json(['success' => true]);
}

Import CSV Pattern:
public function import_products(Request $request)
{
    // Validate file
    // Parse CSV using maatwebsite/excel
    // Create/update records
    // Return success/error response
}

PDF Generation Pattern:
use Barryvdh\DomPDF\Facade\Pdf;

public function Sale_PDF($id)
{
    $sale = Sale::with('details')->findOrFail($id);
    $pdf = PDF::loadView('pdf.sale_invoice', compact('sale'));
    return $pdf->download('sale_' . $id . '.pdf');
}

Email Notification Pattern:
public function Send_Email(Request $request)
{
    // Get email template
    // Replace placeholders
    // Send via Mail facade
    // Return response
}

SMS Notification Pattern:
public function Send_SMS(Request $request)
{
    // Get SMS gateway config
    // Format message from template
    // Send via Twilio/Nexmo/InfoBip
    // Return response
}

MODULE SYSTEM & EXTENSIBILITY

Adding Modules:
- Uses nwidart/laravel-modules package
- Modules can be uploaded via admin panel
- Module status tracked in modules_statuses.json

API endpoints:
- GET /api/get_modules_info - List modules
- POST /api/update_status_module - Enable/disable module
- POST /api/upload_module - Upload new module

Module Structure:
- Modules should follow Laravel Modules package conventions
- Each module can have its own routes, controllers, views, models
