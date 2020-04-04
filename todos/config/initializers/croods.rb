# frozen_string_literal: true

Croods.initialize_for(
  :organizations,
  :users,
  :projects,
  :lists,
  multi_tenancy_by: :organization
)
