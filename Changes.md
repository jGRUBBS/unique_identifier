0.0.4
--------
**Fixes**
- PR #1 - updates `before_create` call back to `before_validation, on: :create`
  - fixes issue where `unique_id` attribute is validated, and `generate_unique_id` wasn't called
    until after validations
