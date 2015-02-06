# Caze

This is a simple DSL to easily define use cases.
The main propose is to avoid the verbose declarations of
use cases entry points inside the main project file.

## Usage

Instead of doing this:

```ruby
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

  define_use_cases sum:      UseCases::Sum,
                   subtract: UseCases::Subtract
end
```

And in the `UseCases::Sum` instead of this:

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

You can define the entry point (the class method) with `define_entry_point`:

```ruby
module Project
  module UseCases
    class Foo
      include Caze

      define_entry_point :sum, as: :execute

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

The usage is like was before:

```ruby
Project.sum(4, 2) # This will call sum inside the use case `UseCases::Sum`
```

## Using transactions

You can use transactions in your use cases by providing a `transaction_handler`
in your project entry point. The only method that transaction handler should
respond is `#transaction`.

```ruby
Project.transaction_handler = ActiveRecord::Base
```

Inside your use case, you need to define the entry point with the flag
`use_transaction` set to `true`.

```ruby
define_entry_point :foo, use_transaction: true
```

Note that the transaction handler should implement `#transaction` and
return the value inside the block. It will also be responsible for handle errors
and rollback if necessary.

# Apache License 2.0

Check LICENSE.txt
