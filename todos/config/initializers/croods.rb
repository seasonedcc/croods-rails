# frozen_string_literal: true

Croods.initialize_for(
  :organizations,
  :users,
  :projects,
  :lists,
  :tasks,
  :assignments,
  multi_tenancy_by: :organization
)
