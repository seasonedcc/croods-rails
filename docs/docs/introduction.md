---
id: introduction
title: Introduction
---

Croods-rails is a framework for creating CRUDs in Rails APIs without so much boilerplate and repetition.

Its goal is to increase the development speed of APIs that rely mostly on CRUD operations.

It uses well-defined migrations to infer everything you need to have fully functional endpoints with strong cohesion, complete with routes, controllers, models, authentication, authorization, request and response validations.

Watch the <a href="https://us02web.zoom.us/rec/share/M3613DtBHx6RbAhjW5oHEb_kWfI1dhEcj0hDCAGsPhNzVE5JVc1qmEcl8XearFWG.Q0zgc9tbvjA785cA" target="_blank">full 1-hour interview</a> explaining the why, how and what of croods-rails.

## Why

A typical Rails API that has a good and reliable structure will have validations in multiple places.
Let's say we have a `Project` entity with a `name` field that is mandatory.

- Database-level validation: `name: string not null`
- Model validation: `validates_presence_of :name`
- Request validations: when creating a project, allow the param `name`, make it mandatory and validate its type
- Response validations: making sure the `name` is there when rendering a `Project`

In other words, you do the same work when creating the migration, when building the model and when defining your endpoints.

If and when any of those change, it means we'll have to change all those places, plus their specs. That's time-consuming, error-prone and not DRY. When APIs grow, we see that pattern over and over, for all kinds of validations that make the API be well structured in the first place.

Croods-rails aims to make building well-structured REST APIs much easier, following the two [Rails principles](https://guides.rubyonrails.org/getting_started.html#what-is-rails-questionmark):

- DRY
- Convention over configuration

## Strategy

The strategy behind Croods-rails is: Write the schema once, preferably in the database.

That means that everything you can write on the database migration, you will write ONLY on the migration. Database migrations become a first-class citizen of the workflow. The database schema is the single source of truth for everything it can be, for example, validation of mandatory fields, default values, or uniqueness.

Think _very carefully_ about your tables and migrations, since they will create all defaults for your API.
