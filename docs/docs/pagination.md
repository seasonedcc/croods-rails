---
id: pagination
title: Pagination
---

The Index action is paginated using the gems [Kaminari](https://github.com/kaminari/kaminari) and [api-pagination](https://github.com/davidcelis/api-pagination). No resource configuration is necessary.

If the request has the query param `page`, the collection will be paginated. The headers will include the values `Total` and `Per-Page` (see api-pagination gem) that can be used to control the pagination on the frontend.

For example, for this resource:

```ruby
# app/resources/projects/resource.rb
module Projects
  class Resource < ApplicationResource
  end
end
```

It's possible to test that pagination is working out of the box:

```ruby
  context 'when accessing the first page' do
    before do
      create_30_projects
      get '/projects?page=1'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(JSON.parse(response.body).length).to eq(25) }
    it { expect(response.headers['Total']).to eq('30') }
    it { expect(response.headers['Per-Page']).to eq('25') }
  end
```

At the same time, `get /projects` (without the query param) would return all 30 projects.

### Page size

Use `paginates_per` (from Kaminari) to configure the page size per resource. Note that must be done inside the **Model**.

```ruby
# app/resources/projects/resource.rb
module Projects
  class Resource < ApplicationResource
    extend_model do
      paginates_per 50
    end
  end
end
```

### Configuration

Use the Kaminari initializer if you want to change any defaults, such as the `page` param or the pagination method.
