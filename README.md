# JustCheckers

A checkers engine written in ruby. It provides a representation of a checkers game complete with rules enforcement and serialisation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'just_checkers'
```

Or install it yourself as:

    $ gem install just_checkers

## Usage

To start, a new game state can be instantiated with the default state:

```ruby
  game_state = JustCheckers::GameState.default
```

Moves can be made by passing in the player number, from co-ordinates and an array of to co-ordinates. It will return true if the move is valid, otherwise it will return false.


```ruby
  game_state.move(1, {x: 1, y: 2}, [{x: 2, y: 3}])
```

Alternatively, moves can be made by specifying the ids of the squares.

```ruby
  game_state.move(1, 1, [2])
```

The last change with all its details are found in the `last_change` attribute

```ruby
  game_state.last_change
```

If something happens errors may be found in the errors attribute

```ruby
  game_state.errors
```

The Winner can be found by calling winner on the object.

```ruby
  game_state.winner
```

Also, the game can be serialized into a hash.

```ruby
  game_state.as_json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrlhumphreys/just_checkers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

