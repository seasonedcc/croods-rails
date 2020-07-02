---
id: usage
title: Usage
---

# Resource

A **resource** is a generic abstraction for any object your app needs to represent. Instead of `app/models/` and `app/controllers/`, with croods we have `app/resources/`.

## Creating a resource

To add a `Project` resource to your app, start by generating a migration:
`rails g migration CreateProjects`

```ruby
# It's crucial to write really solid migrations
# croods will use your database schema to build your resources.
class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
```

Then create the module and the main file `app/resources/projects/resource.rb`:

```ruby
module Projects
  class Resource < ApplicationResource
  end
end
```

The last step is to initialize your resource in `config/initializers/croods.rb`:

```ruby
Croods.initialize_for(:users, :projects)
```

With this, Croods will generate you these default routes and actions:

| Verb   | URI Pattern             | Controller#Action |
| ------ | ----------------------- | ----------------- |
| GET    | /projects(.:format)     | projects#index    |
| POST   | /projects(.:format)     | projects#create   |
| GET    | /projects/:id(.:format) | projects#show     |
| PATCH  | /projects/:id(.:format) | projects#update   |
| PUT    | /projects/:id(.:format) | projects#update   |
| DELETE | /projects/:id(.:format) | projects#destroy  |

That's it! You already have a working resource with all CRUD actions available, plus embedded authorization rules.

By default, every single attribute in your table is exposed in your endpoints, and all attributes are rendered when rendering the resource as json. Usually you'll need to customize them.

## Customizing actions and attributes

Croods gives you a lot of features and expects you to remove those you don't want to use.

### Skip actions

If you don't want some of the actions, you can skip them. For example, if you want to have only `index` for a resource:

```ruby
module Projects
  class Resource < ApplicationResource
    skip_actions :create, :update, :show, :destroy
  end
end
```

| Verb | URI Pattern         | Controller#Action |
| ---- | ------------------- | ----------------- |
| GET  | /projects(.:format) | projects#index    |

### Add actions

You can add custom actions to your resources besides the 5 default ones.

- You must have an `authorize` call
- Custom actions DO NOT accept parameters yet. If you need to use request parameters, use the de default `create` or `update` actions.

```ruby
module Projects
  class Resource < ApplicationResource
    add_action :start, method: :put do
      authorize member # required
      member.start! # method defined elsewhere
      render json: member # render something
    end
  end
end
```

### Skip attributes

By default, every single attribute in your resource's table is exposed to your default actions and accepted as params. Likewise, all attributes are rendered on the resource as json. If you don't want this, let croods know:

```ruby
module Projects
  class Resource < ApplicationResource
    skip_attributes :created_at, :updated_at
    # Will render a :bad_request error if either is used as a param
    # Will not add created_at or updated_at when rendering a project
  end
end
```

You can also select specific attributes to remove either from request params or from responses.

#### Skip attributes only for requests

```ruby
module Projects
  class Resource < ApplicationResource
    request do
      skip_attributes :created_at, :updated_at
      # Trying to pass :created_at or :updated_at as params will generate a bad request
    end
  end
end
```

#### Skip attributes only for responses

```ruby
module Projects
  class Resource < ApplicationResource
    response do
      skip_attributes :my_secret_attribute
      # Will not add :my_secret_attribute when rendering project
    end
  end
end
```

### Extend model

Croods creates a model for your resource. It looks at your database and automatically infers your model's `belongs_to` associations. But if you need to add code to your model just use `extend_model`.

`resources/projects/resource.rb`

```ruby
module Projects
  class Resource < ApplicationResource
    extend_model  do
      before_create :do_somethig
    end
  end
end
```

Protip: you can create a Model module and `extend_model { include Projects::Model }`.

`resources/projects/model.rb`

```ruby
module Projects
  module Model
    extend ActiveSupport::Concern

    included do
      before_create :do_something
    end
  end
end
```

`resources/projects/resource.rb`

```ruby
module Projects
  class Resource < ApplicationResource
    extend_model { include Projects::Model }
  end
end
```
