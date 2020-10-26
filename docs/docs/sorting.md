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

2. If it is the name of a method, it can accept zero, one or two arguments. Declare that method inside the model.
   The method should return an ActiveRecord::Relation. It will be chained with other methods of the collection (pagination, etc.)

The `index` action accepts the query parameters `order_by` and `order`. It will call the sorting method with the parameters that it receives, so take care to make your method respond to the correct number of parameters.

```ruby
if order_by && order
  # call sorting method with order_by, order
elsif order_by
  # call sorting method with order_by
elsif order
  # call sorting method with order
else
  # call sorting method without arguments
end
```

Example of a sorting method without parameters:

```ruby
# app/resources/lists/resource
module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true

    sort_by :sorting

    extend_model do
      def self.sorting # without arguments
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
      def self.sorting(order_by, order) # with arguments
        # if order_by isn't present and order is, the method will receive the latter as the first argument, so be careful with the usage
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

The method could also receive only one of the parameters. Just be careful because if you accept `order_by` and the request happens to pass only the parameter `order`, it will be passed as the first and only argument.
