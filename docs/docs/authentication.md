---
id: authentication
title: Authentication
---

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
