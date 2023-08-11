require_relative '../lib/kiwi-ecs.rb'
require 'test/unit'

class TestFlags < Test::Unit::TestCase
  def test_flags
    world = Kiwi::World.new

    id = world.spawn

    world.set_flag(id, 0)
    assert(world.has_flag(id, 0))
    
    world.set_flag(id, 1)
    assert(world.has_flag(id, 0))
    assert(world.has_flag(id, 1))

    world.remove_flag(id, 0)
    assert(world.has_flag(id, 1))
  end

  def test_has_flags
    world = Kiwi::World.new

    id = world.spawn

    world.set_flag(id, 0)
    world.set_flag(id, 1)
    oid = world.spawn
    world.set_flag(oid, 0)

    i = 0
    world.query_ids
      .filter { |entId| world.has_flags(entId, 0, 1) }
      .each do |id2|
        assert_equal(id, id2)
        i += 1
      end

    assert_equal(i, 1)
  end
end
