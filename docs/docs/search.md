---
id: search
title: Search
---

All resources have search enabled by default. It uses the [pg_search](https://github.com/Casecommons/pg_search) gem under the hood and applies `pg_search_scope` to them.
Use the param `query` to search all fields that are either `string` or `text`.

```ruby
module Projects
  class Resource < ApplicationResource
  end
end
```

```ruby
  get '/projects?query=baz'
```

### Customization

Use search_by to configure [pg_search_scope](https://github.com/Casecommons/pg_search#pg_search_scope) manually.

```ruby
module Lists
  class Resource < ApplicationResource
    search_by :search,
              against: %i[
                name status_text
              ],
              associated_against: { project: :name },
              using: { tsearch: { prefix: true } }
  end
end
```

### Beyond pg_search

You can pass a block to search_by to expand it beyond text fields. For example, to implement your manual search by a date field called `deadline`:

```ruby
module Projects
  class Resource < ApplicationResource
    search_by :search, { against: %i[name] } do |query|
      parse_query_param(query)
    end

    extend_model do
      def parse_query_param(query)
        if date?(query)
          query = format_date_to_db(query)
          where("deadline = '#{query}'")
        else
          search(query)
        end
      end

      def date?(query)
        %r{(\d{2})[-./](\d{2})[-./](\d{4})}.match(query).present?
      end

      def format_date_to_db(date)
        date_split = date.split('/')
        "#{date_split[2]}-#{date_split[0]}-#{date_split[1]}"
      end
    end
  end
end
```

The block will be executed by the model and should return an ActiveRecord::Relation that will be chained with other methods of the collection (sorting, pagination, etc.)

### Disabling search

Use `skip_search` to disable search. The param `query` will not be allowed anymore and the resource will not have the `search` method.

```ruby
module Organizations
  class Resource < ApplicationResource
    skip_search
  end
end
```
