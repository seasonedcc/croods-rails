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

2. If it is the name of a method, it can accept **zero** or **two** arguments. Declare that method inside the model.
   The method should return an ActiveRecord::Relation. It will be chained with other methods of the collection (pagination, etc.)

The `index` action accepts the query parameters `order_by` and `order`. If `order_by` is present and the method exists, it will call that method with both parameters.
Protip: pass these query parameters only if your methods accepts them. If you intend to use the index endpoint without the sorting parameters, remember to make the arguments optional in your method.

Example of a sorting method without parameters:

```ruby
# app/resources/lists/resource
module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true

    sort_by :sorting

    extend_model do
      def self.sorting # without parameters
        joins(:project).order('projects.name asc')
      end
    end
  end
end
```

Example of a sorting method with parameters:

```ruby
# app/resources/lists/resource
module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true

    sort_by :sorting

    extend_model do
      def self.sorting(order_by, order) # with parameters
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
