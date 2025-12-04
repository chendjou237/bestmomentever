---
trigger: always_on
---

AUTHENTICATION & AUTHORIZATION

Authentication Flow:
- OAuth2 via Laravel Passport
- Token-based authentication
- Access tokens stored in oauth_access_tokens table
- Refresh tokens in oauth_refresh_tokens table

Middleware Stack:
- auth:api - Validates OAuth token
- Is_Active - Checks if user account is active
- Custom middleware in app/Http/Middleware/

User Model:
- Located at app/Models/User.php
- Uses HasApiTokens trait from Passport
- Relationships: roles, warehouses

Authorization:
- Role-based Access Control (RBAC)
- Role model with permissions
- Permission model for granular access
- 41 policy files in app/Policies/
- Permissions checked in controllers and views

Warehouse-based Access:
- Users can be assigned to specific warehouses
- UserWarehouse model manages assignments
- Data filtering based on user's assigned warehouses

FRONTEND DEVELOPMENT GUIDELINES

Component Structure:
<template>
  <!-- UI markup using Bootstrap Vue components -->
</template>

<script>
export default {
  name: "ComponentName",
  data() {
    return {
      // Component state
    };
  },
  methods: {
    // Component methods
  },
  mounted() {
    // Initialization
  }
};
</script>

<style scoped>
/* Component-specific styles */
</style>

API Communication Pattern:
// Using axios
axios.get('/api/products')
  .then(response => {
    if (response.data.success) {
      this.products = response.data.data;
    }
  })
  .catch(error => {
    // Error handling
  });

Common UI Components:
- vue-good-table for data tables
- vue-select for dropdowns
- vue-sweetalert2 for confirmations
- b-modal (Bootstrap Vue) for modals
- vee-validate for form validation
- vue-barcode for barcode display
- vue-echarts for charts

Internationalization:
// In templates
{{ $t('message_key') }}

// In scripts
this.$t('message_key')

// Language files in resources/src/translations/

State Management Pattern:
// Vuex store modules
store/
├── index.js          // Root store
├── auth.js           // Authentication state
├── products.js       // Products state
└── ...
