# Kiwi

Kiwi is a versatile entity component system focussing on fast iteration and a nice api.

To get started, read the [usage guide](#usage) below.

[![Tests](https://github.com/Jomy10/kiwi-ecs-ruby/actions/workflows/tests.yml/badge.svg)](https://github.com/Jomy10/kiwi-ecs-ruby/actions/workflows/tests.yml)

## Installation

The library is available from [ruby gems](https://rubygems.org/gems/kiwi-ecs):

```sh
gem install kiwi-ecs
```

To use it in your ruby source files:

```ruby
require 'kiwi-ecs'
```

## Usage

### The world

The world is the main object that controls the ecs.

```ruby
world = Kiwi::World.new
```

### Components

Creating a component is as simple as declaring a struct:

```ruby
Position = Struct.new :x, :y
```

Classes can also be used instead of structs

```ruby
class Velocity
  attr_accessor :x
  attr_accessor :y
end
```

### Entities

An entity is spawned with a set of components:

```ruby
entityId = world.spawn(Position.new(10, 10))

world.spawn(Position.new(3, 5), Velocity.new(1.5, 0.0))
```

The `world.spawn(*components)` function will return the id of the spawned entity.

Killing an entity can be done using `world.kill(entityId)`:

```ruby
world.kill(entityId)
```

### Systems

#### Queries

Queries can be constructed as follows:

```ruby
# Query all position componentss
world.query(Position) do |pos|
    puts pos
end

# Query all entities having a position and a velocity component, and their entity ids
world.query_with_ids(Position, Velocity) do |id, pos, vel|
  # ...
end
```

### Flags

Entities can be tagged using flags

#### Defining flags

A flag is an integer

```ruby
module Flags
  Player = 0
  Enemy = 1
end
```

#### Setting flags

```ruby
id = world.spawn

world.set_flag(id, Flags::Player)
```

#### Removing a flag

```ruby
world.remove_flag(id, Flags::Player)
```

#### Checking wether an entity has a flag

```ruby
world.has_flag(id, Flags::Player)
```

#### Filtering queries with flags

```ruby
world.query_with_ids(Pos)
  .filter do |id, pos|
    world.has_flag(id, Flags::Player)
  end
  .each do |id, pos|
    # Do something with the filtered query
  end
```

The `hasFlags` function is also available for when you want to check multiple flags.

## Road map

- [ ] System groups

## Contributing

Contributors are welcome to open an issue requesting new features or fixes or opening a pull request for them.

## License

The library is licensed under LGPLv3.
