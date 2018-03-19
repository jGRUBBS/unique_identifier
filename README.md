# Unique Identifier

make unique identifier fields quick and simple

## Installation

Add this line to your application's Gemfile:

    gem 'unique_identifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unique_identifier

## Usage

```ruby

  class SomeModel < ActiveRecord::Base

    # name of column to store unique identifier
    #            |
    #         -------
    unique_id :number, -> { Array.new(9) { rand(9) }.join }
    #                  ------------------------------------
    #                                    |
    # proc to be run `before_validation, on: :create` to generate unique identifier

  end

  instance = SomeModel.create
  instance.number # => "324516542"

```

## How it works

The above example is equivalent to this:

```ruby

  class SomeModel < ActiveRecord::Base

    before_validation :generate_unique_id, on: :create

    def generate_unique_id
      self.number = loop do
        random = Array.new(9) { rand(9) }.join
        break random unless self.class.exists?(number: random)
      end
    end

  end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
