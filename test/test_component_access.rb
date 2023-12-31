require_relative '../lib/kiwi-ecs.rb'
require 'test/unit'

Pos = Struct.new(:x, :y)
Name = Struct.new(:name)

class TestSpawn < Test::Unit::TestCase

  def test_spawn
    world = Kiwi::World.new

    expectedPos = Pos.new(1, 4)
    expectedName = Name.new("Hello world")

    id = world.spawn(expectedPos, expectedName)
    pos = world.get_component(id, Pos)
    name = world.get_component(id, Name)

    assert_equal(pos, expectedPos)
    assert_equal(name, expectedName)
  end

  def test_spawn2
    world = Kiwi::World.new

    (0...1000).each do |i|
      world.spawn(Name.new("Hello world - #{i}"))
    end

    (0...1000).each do |i|
      assert_equal(Name.new("Hello world - #{i}"), world.get_component(i, Name))
    end
  end

  def test_has_component
    world = Kiwi::World.new
    id = world.spawn Name.new("Hello world")
    assert(world.has_component(id, Name))
    assert(!world.has_component(id, Pos))
  end
end
