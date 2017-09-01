![BABL Logo](https://github.com/getbannerman/babl/raw/master/logo-babl.png)

[![Build Status](https://travis-ci.org/getbannerman/babl.svg?branch=master)](https://travis-ci.org/getbannerman/babl)
[![Gem](https://img.shields.io/gem/v/babl-json.svg)](https://rubygems.org/gems/babl-json)
[![Downloads](https://img.shields.io/gem/dt/babl-json.svg)](https://rubygems.org/gems/babl-json)

BABL (Bannerman API Builder Language) is a templating langage for generating JSON in APIs.

It plays a role similar to [RABL](https://github.com/nesquena/rabl), [JBuilder](https://github.com/rails/jbuilder), [Grape Entity](https://github.com/ruby-grape/grape-entity), [AMS](https://github.com/rails-api/active_model_serializers), and many others.

# Features

## Template compilation

A BABL template has to be compiled before it can be used. This approach carries several advantages:
- Many errors can be detected earlier during the development process.
- Partials are resolved only once, during compilation: zero overhead at runtime.
- [Code generation [WIP]](https://github.com/getbannerman/babl/pull/21) should bring performances close to handcrafted Ruby code.

## Automatic documentation (JSON schema)

BABL can automatically document its template by exporting a JSON-Schema description. Combined with optional type-checking assertions, it becomes possible to do some exciting things.

For instance, it is possible to generate TypeScript interfaces by feeding the exported JSON-Schema to https://github.com/bcherny/json-schema-to-typescript.

## Dependency analysis (automatic preloading)

Due to the static nature of BABL templates, it is possible to determine in advance which methods will be called on models objects during rendering. This is called dependency analysis. In practice, the extracted dependencies can be passed to a preloader, in order to avoid all N+1 issues.

Please note that this requires a compatible preloader implementation. At Bannerman, we are using **Preeloo**. It natively supports ActiveRecord associations, computed columns, and custom preloadable properties. Unfortunately, it hasn't been released publicly (yet), because it still has severe bugs and limitations.

## Example

BABL template:

```ruby
object(
    document: object(
        :id, :title,

        owner: _.nullable.object(:id, :name),
        authors: _.each.object(:id, :name),
        category: 'Not implemented'
    )
)
```

JSON output:

```json
{
    "document": {
        "id": 1,
        "title": "Hello BABL",
        "owner": null,
        "authors": [
            { "id": 4, "name": "Fred" },
            { "id": 5, "name": "Vivien" }
        ],
        "category": "not implemented"
    }
}
```

Interestingly, this JSON output is also a valid BABL template. In general, when a JSON file is also a valid Ruby file, then it is also a valid BABL template. This property makes it very easy to mix static and dynamic content during developpement.

## Documentation

- [Getting started (with Rails)](pages/getting_started.md)
- [Fundamental concepts](pages/concepts.md)
- [BABL Templates](pages/templates.md)
- [List of all operators](pages/operators.md)
- [Limitations / Known issues](pages/limitations.md)

# License

Copyright (c) 2017 [Bannerman](https://www.bannerman.com/), [Frederic Terrazzoni](https://github.com/fterrazzoni)

Licensed under the [MIT license](https://opensource.org/licenses/MIT).