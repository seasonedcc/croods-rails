# frozen_string_literal: true

Croods.initialize_for(
  :organizations,
  :users,
  :projects,
  multi_tenancy_by: :organization
)
