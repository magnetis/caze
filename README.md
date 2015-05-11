# Caze

This is a simple DSL to declare use cases as entry points of a module.
The purpose is to avoid the verbose declarations.

## Usage

Instead of doing this:

`has_use_case``ruby
module Project
  def self.sum(x, y)
    UseCases::Sum.execute(x, y)
  end

  def self.subtract(x, y)
    UseCases::Subtract.execute(x, y)
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

## Exporting instance methods as class methods

Inside the use case classes you can use the `.export` method, so in the `UseCases::Sum` instead of this:

```ruby
module Project
  module UseCases
    class Sum
      def self.execute(x ,y)
        new(x,y).foo
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

# Apache License 2.0

Check LICENSE.txt
