# ohm-contrib

A collection of drop-in modules for Ohm.

## List of modules

1. Ohm::Callbacks
2. Ohm::DataTypes
3. Ohm::Locking
4. Ohm::Scope
5. Ohm::Slug
6. Ohm::SoftDelete
7. Ohm::Timestamps
8. Ohm::Versioned

## Important Upgrade notes from 0.1.x

The following lists the major changes:

1. `Ohm::Typecast` has been removed in favor of `Ohm::DatTypes`.
2. `Ohm::Timestamping` has been renamed to `Ohm::Timestamps`.
3. `Ohm::Timestamps` now store times as a UNIX Timestamp.
4. `All Ohm validation related plugins have been removed.
    See [scrivener][scrivener] instead.
5. `Ohm::Boundaries` has been removed.
6. Ohm::Contrib no longer uses `autoload`. You can either
   `require 'ohm/contrib', which requires everything, or you
   can `require ohm/datatypes` for example if you want to cherry
   pick your requires.

[scrivener]: http://github.com/soveran/scrivener

Example usage
-------------

```ruby
require 'ohm'
require 'ohm/contrib'

class Post < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes

  attribute :amount, Type::Decimal
  attribute :url
  attribute :poster_email
  attribute :slug
end

post = Post.create

post.created_at.kind_of?(Time)
# => true

post.update_at.kind_of?(Time)
# => true
```

It's important to note that `created_at` and `update_at` both store
times as a unix timestamp for efficiency.

```ruby
# Casting example
class Product
  include Ohm::DataTypes

  attribute :price, Type::Decimal
  attribute :start_of_sale, Type::Time
  attribute :end_of_sale, Type::Time
  attribute :priority, Type::Integer
  attribute :rating, Type::Float
end

product = Product.create(price: "127.99")
product.price.kind_of?(BigDecimal)
# => true

product = Product.create(start_of_sale: Time.now.rfc2822)
product.start_of_sale.kind_of?(Time)
# => true

product = Product.create(end_of_sale: Time.now.rfc2822)
product.end_of_sale.kind_of?(Time)
# => true

product = Product.create(priority: "100")
product.priority.kind_of?(Integer)
# => true

product = Product.create(rating: "5.5")
product.rating.kind_of?(Float)
# => true
```
