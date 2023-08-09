require_relative '../src/world.rb'
require 'test/unit'

class TestEntityIds < Test::Unit::TestCase
  def test_reuse_entity_ids
    world = World.new

    id1 = world.spawn(Pos.new(0, 10))
    world.set_flag id1, 0
    assert_equal(1, world.entity_count)
    assert_equal([0], world.query_ids)
    count = 0
    world.query(Pos) do |pos|
      count += 1
    end
    assert_equal(1, count)
    assert(world.has_flag(id1, 0))

    world.kill(id1)

    assert_equal(0, world.entity_count)
    assert_equal([], world.query_ids)
    count = 0
    world.query(Pos) do |pos|
      count += 1
    end
    assert_equal(0, count)

    id2 = world.spawn(Pos.new(0, 10))
    assert_equal(id1, id2)
    assert_equal(1, world.entity_count)
    assert_equal([0], world.query_ids)
    count = 0
    world.query(Pos) do |pos|
      count += 1
    end
    assert_equal(1, count)
    assert(!world.has_flag(id1, 0))
  end
end
