# Caze

[![Build status](https://img.shields.io/travis/magnetis/caze.svg)](https://travis-ci.org/magnetis/caze)
[![Gem version](https://img.shields.io/gem/v/caze.svg)](https://rubygems.org/gems/caze)
[![Downloads](https://img.shields.io/gem/dt/caze.svg)](https://rubygems.org/gems/caze)

This is a simple DSL to declare use cases as entry points of a module.
The purpose is to avoid the verbose declarations.

## Usage

Instead of doing this:

```ruby
module Project
  def self.sum(x, y)
    UseCases::Sum.sum(x, y)
  end

  def self.subtract(x, y)
    UseCases::Subtract.subtract(x, y)
  end
end
```

You can do this:

```ruby
require 'caze'

module Project
  include Caze

  has_use_case :sum, UseCases::Sum
  has_use_case :subtract, UseCases::Subtract
end
```

## Using transactions

You can use transactions in your use cases by providing a `transaction_handler`
in your module. The only method that transaction handler should
respond is `#transaction`.

```ruby
Project.transaction_handler = ActiveRecord::Base
```

While declaring which use cases your app has, you can set the option
`transactional` to `true`.

```ruby
has_use_case :wow, UseCases::Wow, transactional: true
```

Note that the transaction handler must implement `#transaction` and
return the value inside the block. It will also be responsible for handle errors
and rollback if necessary.


## Using exception interceptor

You can use the raise use case exception in order to know the use case name when an
error happen.

While declaring which use case your app has, you can set the option
`raise_use_case_exception` to `true`.

```ruby
has_use_case :say_my_name, UseCases::SayMyName, raise_use_case_exception: true
```

It should intercept yours exceptions and write the use case name on it following the
pattern: `SayMyName: This is you error message Heisenberg`

## Exporting instance methods as class methods

Inside the use case classes you can use the `.export` method, so in the `UseCases::Sum` instead of this:

```ruby
module Project
  module UseCases
    class Sum
      def self.sum(x, y)
        new(x, y).sum
      end

      def initialize(x, y)
        @x = x
        @y = y
      end

      def sum
        x + y
      end
    end
  end
end
```

You can define a class method based on an instance method with `export`:

```ruby
module Project
  module UseCases
    class Foo
      include Caze

      export :sum, as: :execute

      def initialize(x, y)
        @x = x
        @y = y
      end

      def sum
        x + y
      end
    end
  end
end
```

The `as` param, tells how the class method must be named,
if it is not passed the class method will have the same name of the instance method.

With this you can call your project use cases without the need to know its internals:

```ruby
Project.sum(4, 2) # This will call sum inside the use case `UseCases::Sum`
```

# Installation

Add to your Gemfile:

```
gem 'caze', '~> 0.4.0'
```

Run `bundle install`.

# Apache License 2.0

Check LICENSE.txt
