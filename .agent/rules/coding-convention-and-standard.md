---
trigger: always_on
---

CODING CONVENTIONS & STANDARDS

BACKEND (LARAVEL/PHP)

Naming Conventions:
- Controllers: PascalCase with Controller suffix (e.g., ProductsController, SalesController)
- Models: Singular PascalCase (e.g., Product, Sale, Client)
- Database Tables: Plural snake_case (e.g., products, sales, clients)
- Routes: snake_case for API endpoints (e.g., get_products_pos, store_purchase)
- Methods: camelCase (e.g., getProducts(), createSale())

Controller Patterns:
// Standard CRUD pattern
class ProductsController extends Controller
{
    public function index()      // GET /products - List
    public function store()      // POST /products - Create
    public function show($id)    // GET /products/{id} - Read
    public function update($id)  // PUT /products/{id} - Update
    public function destroy($id) // DELETE /products/{id} - Delete

    // Bulk operations
    public function delete_by_selection() // POST /products/delete/by_selection

    // Import/Export
    public function import_products()     // POST /products/import/csv
}

Model Patterns:
- Use Eloquent ORM
- Define relationships in models
- Use fillable/guarded for mass assignment protection
- Namespace: App\Models

API Response Pattern:
// Success response
return response()->json(['success' => true, 'data' => $data]);

// Error response
return response()->json(['success' => false, 'message' => $error], 422);

FRONTEND (VUE.JS)

Component Naming:
- Views: snake_case files (e.g., index_products.vue, create_sale.vue)
- Components: PascalCase for component names in code
- Routes: snake_case (e.g., index_products, store_sale)

File Organization:
- Each module has its own directory under resources/src/views/app/pages/
- CRUD operations follow pattern: index_*.vue, create_*.vue, edit_*.vue, detail_*.vue

Vue Router Pattern:
{
    path: "/app/products",
    component: () => import("./views/app/pages/products"),
    redirect: "app/products/list",
    children: [
        {
            name: "index_products",
            path: "list",
            component: () => import("./views/app/pages/products/index_products")
        },
        {
            name: "store_product",
            path: "store",
            component: () => import("./views/app/pages/products/Add_product")
        },
        // ... edit, detail routes
    ]
}

State Management:
- Use Vuex for global state
- Store modules in resources/src/store/
- Use localStorage for persistence (via vue-localstorage)
