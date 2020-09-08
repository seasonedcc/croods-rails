---
id: usage
title: Usage
---

# Resources

A **resource** is a generic abstraction for any entity your app needs to represent; anything you would have a database table for.

Everything in Croods-rails is organized around resources, even the file structure.

When you start your server, Croods-rails uses your resources as recipes to create routes, models, controllers, actions, authentication, authorization and multi-tenancy at runtime.

## File structure

In a traditional Rails application, if you want to know the behavior of an entity, you need to navigate between many folders and files:

- `config/routes.rb`
- `models/your_model.rb`
- `controllers/your_controller.rb`
- ...and so on.

That file structure has nothing to do with the behavior of the application. It's just a representation of the framework's interface. As the app grows, each of these folders gets bigger, and finding what you want becomes harder.

Croods-rails changes that. Its architecture is based on the behavior of the API and not on the classic Rails framework structure. It enforces cohesion and incentivizes decoupling. Instead of `app/models/`, `app/controllers/`, etc., with croods we have `app/resources/`.

Each of your resources will have its own folder inside it and everything related to each resource will be in a single place, instead of scattered over your app. This way, you have a better **modularization**.

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

With this, Croods will generate these default routes and actions:

| Verb   | URI Pattern             | Controller#Action |
| ------ | ----------------------- | ----------------- |
| GET    | /projects(.:format)     | projects#index    |
| POST   | /projects(.:format)     | projects#create   |
| GET    | /projects/:id(.:format) | projects#show     |
| PATCH  | /projects/:id(.:format) | projects#update   |
| PUT    | /projects/:id(.:format) | projects#update   |
| DELETE | /projects/:id(.:format) | projects#destroy  |

That's it! You already have a working resource with all CRUD actions available. By default, all of these endpoinds will require users to be authenticated and authorized.

You can check what resources you have declared using the console:

```ruby
> Croods.resources
=> [Projects::Resource, Users::Resource]
```

By default, every single attribute in your table is exposed in your endpoints, and all attributes are rendered when rendering the resource as json.

In the above example, the `create` endpoint would allow the parameters `name`, `created_at` and `updated_at` (`id` is filtered by default.) The `update` endpoints would also allow all these parameters to be changed.

The `index` and `show` endpoints would render this JSON:

```ruby
{
  id: id,
  name: name,
  created_at: created_at,
  updated_at: updated_at
}
```

Usually you'll need to customize them.

## Customizing actions and attributes

Croods gives you a lot of features out of the box and expects you to remove those you don't want to use.

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
      skip_attribute :my_secret_attribute
      # Will not add :my_secret_attribute when rendering project
    end
  end
end
```

#### Add attributes only for responses

This is a simple way to render any method that your model has that doesn't correspond to a field in the database.

```ruby
module Projects
  class Resource < ApplicationResource
    response do
      add_attribute :some_derived_attribute
      # Will add :some_derived_attribute when rendering project
    end
  end
end
```

### Extend model

Croods creates a model for your resource. It looks at your database and automatically infers your model's `belongs_to` associations. But if you need to add code to your model, use `extend_model`.

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

There's a simple pattern where you use modules to separate those into files:

#### Step 1: Create a `model` module

Note we're creating it inside the resources/projects folder for better modularization: everything related to the resource `projects` is in the same place.

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

#### Step 2: extend that module in your `resource` file

`resources/projects/resource.rb`

```ruby
module Projects
  class Resource < ApplicationResource
    extend_model { include Projects::Model }
  end
end
```

## Other options

#### Using a custom resource identifier

Croods assumes the resource identifier will be `id`. If you want to use some other column instead, declare its `identifier`.

```ruby
module Projects
  class Resource < ApplicationResource
    identifier :slug
  end
end
```

#### Filtering

By default, the `index` actions returns all records for that resource. You can filter it with `filter_by`.

```ruby
module Projects
  class Resource < ApplicationResource
    filter_by :client_id
  end
end
```

The `index` endpoint becomes: `GET /projects?client_id=<id>`

Now Croods will require the param `client_id` for the that action and return a list of projects with that client_id.

#### Sort the resource list

Use `sort_by` to define how the resource list will be sorted on the `index` action.

```ruby
module Projects
  class Resource < ApplicationResource
    sort_by created_at: :desc
  end
end
```

#### Public actions

Public actions do not perform authentication nor authorization. In other words, they are available for anyone.

```ruby
module Projects
  class Resource < ApplicationResource
    public_action :index
  end
end
```

In this example, `GET /projects` can be accessed by anyone. All other routes for this resource will still be authenticated and authorized.

#### use_service, use_services

Documentation WIP

#### Creating mailers

Documentation WIP
