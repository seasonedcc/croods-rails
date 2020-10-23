---
id: sorting
title: Sorting
---

Use `sort_by` to define how the resource list will be sorted on the `index` action.

```ruby
module Projects
  class Resource < ApplicationResource
    sort_by created_at: :desc
  end
end
```

There are two ways of using `sort_by`:

1. If it is an attribute, the list will be sorted by it. Internally, it uses `order(sort_by)`. You can pass one or more attributes:

```ruby
sort_by foo: :asc, bar: desc
```

2. If it is the name of a method, it must accept two arguments, order_by and order. Declare that method inside the model.
   The method should return an ActiveRecord::Relation. It will be chained with other methods of the collection (pagination, etc.)

The `index` action will then **expect** the query parameters `order_by` and `order`, and call that method with these parameters. You can do complex sorting logic with that, for example:

```ruby
# app/resources/lists/resource
module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true

    sort_by :sorting

    extend_model do
      def self.sorting(order_by, order)
        sort = parse_sorting_names(order_by) || 'created_at'
        joins(:project).order(sort => order || 'asc')
      end

      def self.parse_sorting_names(order_by)
        return 'projects.name' if order_by == 'project_name'

        order_by
      end
    end
  end
end
```
