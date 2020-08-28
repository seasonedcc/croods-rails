---
id: multiTenancy
title: Multi-tenancy
---

Croods supports multi-tenancy. When initializing Croods, use the `multi_tenancy_by` argument to declare which resource will define the tenancy.

```ruby
Croods.initialize_for(:users, :projects, :organizations, multi_tenancy_by: :organization)
```

You can verify multi tenancy using the console:

```ruby
> Croods.multi_tenancy?
=> true

> Croods.tenant_attribute
=> :organization_id
```

Documentation WIP
