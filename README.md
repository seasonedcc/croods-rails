[![CircleCI](https://circleci.com/gh/SeasonedSoftware/croods-rails.svg?style=svg)](https://circleci.com/gh/SeasonedSoftware/croods-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/5531c26549b427684578/maintainability)](https://codeclimate.com/github/SeasonedSoftware/croods-rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5531c26549b427684578/test_coverage)](https://codeclimate.com/github/SeasonedSoftware/croods-rails/test_coverage)
![](https://ruby-gem-downloads-badge.herokuapp.com/croods?type=total)

# Croods
Short description and motivation.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'croods'
```

And then execute:
```bash
$ bundle
```

## Usage
### Resource
Resource is a generic abstraction for any object your app needs to represent. Instead of `app/models/` and `app/controllers/`, with croods we have `app/resources/`.

### Creating a resource
To add a `Project` resource to your app, start by generating a migration:
```rails g migration CreateProjects```

``` ruby
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
### Authentication
Croods uses [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth) under the hood.
To customize which devise modules are loaded, you can pass them as arguments to `use_for_authentication!`
```ruby
use_for_authentication!(
  :database_authenticatable,
  :recoverable,
  :rememberable,
  :trackable,
  :validatable
)
```

## Contributing

You can manually check your changes in the dummy Rails app under `/todos`.

To set it up:
```
cd todos/
bin/setup
```

To run specs use:
```bin/rspec```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

