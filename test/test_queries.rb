Name = Struct.new :name
Pos = Struct.new :x, :y
Vel = Struct.new :x, :y

class TestQuery < Test::Unit::TestCase
  def test_query
    world = Kiwi::World.new

    world.spawn

    correctId = world.spawn(Name.new("Hello"), Pos.new(0, 10), Vel.new(11, 25))
    world.spawn(Name.new("Hello"), Pos.new(1, 12))

    count = 0
    world.query_with_ids(Name, Pos, Vel) do |id, name, pos, vel|
        assert_equal(correctId, id, "The entity id is not correct")
        assert_equal(Name.new("Hello"), name)
        assert_equal(Pos.new(0, 10), pos)
        assert_equal(Vel.new(11, 25), vel)
        count += 1
      end
    assert_equal(1, count)
  end

  def test_query_mut
    world = Kiwi::World.new

    id1 = world.spawn Pos.new(0, 10)
    id2 = world.spawn Vel.new(4, 11), Pos.new(9, 15)

    world.query_with_ids(Pos) do |id, pos|
      if id == id1
        assert_equal(Pos.new(0, 10), pos)
      elsif id == id2
        assert_equal(Pos.new(9, 15), pos)
      else
        fail()
      end
    end
  end

  def test_collect
    world = Kiwi::World.new

    world.spawn Pos.new(0, 10)
    world.spawn
    world.spawn Pos.new(1, 11), Vel.new(2, 12)
    world.spawn Vel.new(3, 13)

    puts "Query:"
    world.query(Pos).each do |a|
      puts a
    end
    assert_equal(2, world.query(Pos).count)
  end

  def test_query_one
    world = Kiwi::World.new

    world.spawn(Pos.new(0, 0))

    world.query(Pos) do |pos|
      pos.x += 5
      pos.y += 7

      assert_equal(Pos.new(5, 7), pos)
    end
  end
end
