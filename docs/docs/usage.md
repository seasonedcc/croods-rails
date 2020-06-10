---
id: usage
title: Usage
---

### Resource

A **resource** is a generic abstraction for any object your app needs to represent. Instead of `app/models/` and `app/controllers/`, with croods we have `app/resources/`.

### Creating a resource

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

Last step is to initialize your resource in `config/initializers/croods.rb`:

```ruby
Croods.initialize_for(:users, :projects)
```

### Skip actions

Croods creates five basic endpoints for your resource. If you don't want one, you need to skip it's action:

```ruby
module Projects
  class Resource < ApplicationResource
    skip_actions :index, :create, :update, :show, :destroy
  end
end
```

### Skip attributes

By default, every single attribute in your table is exposed in your endpoints. If you don't want this, let croods know:

```ruby
module Projects
  class Resource < ApplicationResource
    skip_attributes :created_at, :updated_at
  end
end
```

### Extend model

Croods creates a model for your resource. It looks at your database and automatically infers your model's `belongs_to` associations. But if you need to add code to your model just use `extend_model`.

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
