---
id: introduction
title: Introduction
---

Croods-rails is a framework for creating CRUDs in Rails APIs without so much boilerplate and repetition.

It uses information from the database structure to create fully functional endpoints for your resources, complete with routes, controllers, models, authentication, authorization, request and response validations.

Watch the <a href="https://us02web.zoom.us/rec/share/M3613DtBHx6RbAhjW5oHEb_kWfI1dhEcj0hDCAGsPhNzVE5JVc1qmEcl8XearFWG.Q0zgc9tbvjA785cA" target="_blank">full 1-hour interview</a> explaining the why, how and what of croods-rails.

### Why

A typical Rails API that has a good and reliable structure will have validations in multiple places.
Let's say we have a `Project` entity with a `name` field that is mandatory.

- Database-level validation: `name: string not null`
- Model validation: `validates_presence_of :name`
- Request validations: make the param `name` be allowed and required when creating a `Project`
- Response validations: making sure the `name` is there when rendering a `Project`

If that changes at any point, it means we'll have to change all those places. That's time-consuming, error-prone and not DRY. When APIs grow, we see that pattern over and over, for all kinds of validations that make the API be well structured in the first place.

Croods-rails aims to make building well-structured REST APIs much easier, following the two [Rails principles](https://guides.rubyonrails.org/getting_started.html#what-is-rails-questionmark):

- DRY
- Convention over configuration
