# Caze

This is a simple DSL to work with use case definitions.
The main propose is to avoid the verbose declarations of
use cases entry points inside the main project file.

## Usage

Require the `Caze` in your project entry point,
and include it in your main module "class".

```ruby
# Entry point file

require 'project/version'
require 'caze'
require 'project/use_cases/foo'

module Project
  include Caze

  define_use_cases foo: UseCases::Foo
end
```

Your `Foo` use case should looks like:

```ruby
module Project
  module UseCases
    class Foo
      include Caze

      define_entry_point :foo

      def foo
        puts "bar"
      end
    end
  end
end
```

The usage is like was before:

```ruby
Project.foo # This will call foo inside the use case `Foo`
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

# License

## Apache License 2.0

Check LICENSE.txt
