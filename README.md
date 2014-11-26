# UseCaseSupport

This is a simple DSL to work with use case definitions.
The main propose is to avoid the verbose declarations of
use cases entry points inside the main project file.

## Usage

Require the `UseCaseSupport` in your project entry point,
and include it in your main module "class".

```ruby
# Entry point file

require 'project/version'
require 'use_case_support'
require 'project/use_cases/foo'

module Project
  class << self
    include UseCaseSupport

    define_use_cases foo: UseCases::Foo
  end
end
```

You `Foo` use case should looks like:

```ruby
module Project
  module UseCases
    class Foo
      include UseCaseSupport

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

## TODO

* Handle cases where arguments are not key word arguments;
* Handle cases where arity is zero.
