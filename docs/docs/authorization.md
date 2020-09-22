---
id: authorization
title: Authorization
---

Croods uses [pundit](https://github.com/varvet/pundit) under the hood. All actions are authorized and have default authorization rules.

## Default authorization rules

Croods-rails authorizes by default users that are admins and users that own the resource.
Any resources that have no explicit authorization rules have this under the hood:

```ruby
module Lists
  class Resource < ApplicationResource
    authorize :admin, :owner # not need to write this line, since this is the default
  end
end
```

Your User model must respond to the method `admin?`. Its simplest form is to have an `admin: boolean` field on the Users table, then Croods will take care of everything else for you.

### Owner

"owner" is a special authorization rule. The rationale behind it is that the "owner" of a resource has access to it.

Croods searches the resource (and its references, recursively) for the closest `user_id` reference. That is considered to be the resource's owner.

For example, in the example below, `project.user` is considered to be the project's owner, because Project has a field `user_id`. That user will be able to access all actions for the projects that have her id.

```sql
  create_table "projects", force: :cascade do |t|
    t.bigint   "user_id",     :null=>false
    t.string   "name",        :null=>false
  end
```

#### TODO: add examples with list and show actions

The process is recursive, so, if `List` does not have a `user_id`, but it belongs to `Project` that does, then the owner of the Project will be authorized to access its `lists` actions.

```sql
  create_table "projects", force: :cascade do |t|
    t.bigint   "user_id",     :null=>false
    t.string   "name",        :null=>false
  end

  create_table "lists", force: :cascade do |t|
    t.bigint   "project_id",     :null=>false
    t.string   "name",           :null=>false
  end
```

#### TODO: add examples with actions

### user_is_not_the_owner!

Sometimes, you want to have a `user_id` reference and it does not mean the user has the `owner` role of that resource. When that happens, use the method `user_is_not_the_owner!` and Croods will not look for the owner associations.

TODO: explain what authorization happens in this case

```ruby
module Assignments
  class Resource < ApplicationResource
    user_is_not_the_owner!
  end
end
```

## Customizing authorization

Use `authorize` to define the roles that have authorization to access a resource.

```ruby
module Lists
  class Resource < ApplicationResource
    authorize :supervisor
  end
end
```

In the example, it will expect the model User to respond to the method `supervisor?`. You can add any business logic to it, and Croods will apply that rule to all actions from the resource. It will authorize users for whom the method returns truthy values.

You can pass a symbol or an array of symbols to specify which actions should have that rule.

```ruby
module Lists
  class Resource < ApplicationResource
    authorize :supervisor, on: %i[index show]
  end
end
```

#### Skipping authorization

If you want to skip authorization for an action, you need to explicitly skip it, or else Pundit will raise errors.

```ruby
def my_custom_action
  skip_authorization
  skip_policy_scope

  <your action code...>
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
