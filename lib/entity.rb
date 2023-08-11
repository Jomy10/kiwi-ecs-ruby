require 'set'
require_relative 'bitmap'

module Kiwi
module Internal

Entity = Struct.new(:archId, :archRow)

class EntityStore
  def initialize
    # [Entity]
    @entities = []
    # [Bitmap]
    @flags = []
    @nextId = 0
    @deadEntities = Set.new
  end

  # Returns a new entity id (int)
  def new_id
    id = @deadEntities.first
    if id != nil
      @deadEntities.delete id
      return id
    else
      id = @nextId
      @nextId += 1
      return id
    end
  end

  # Spawn a new entity with the given ids
  def spawn(entityId, archId, archRowId)
    if @entities.count <= entityId
      @entities.push(Entity.new(archId, archRowId))
    else
      @entities[entityId] = Entity.new(archId, archRowId)
      self.reset_flags(entityId)
    end
  end

  # Returns an entity
  # @param [Integer] entityId
  def get(entityId)
    return @entities[entityId]
  end

  # def exists?(entityId)
  #   return @entities.size > entityId
  # end

  # Mark an entity as dead
  def kill(entityId)
    @deadEntities.add entityId
  end

  def entity_count
    return ((0...@entities.count).reduce(0) do |count, id|
      if @deadEntities.include? id
        return count
      else
        return count + 1
      end
    end)
  end

  # @param [Integer, #read] entityId
  # @param [Integer, #read] flagId
  # @return [bool]
  def has_flag(entityId, flagId)
    if @flags.size <= entityId
      return false
    else
      return @flags[entityId].contains(flagId)
    end
  end

  def set_flag(entityId, flagId)
    if @flags.size <= entityId
      (@flags.size..entityId).each do |_|
        @flags.push(Bitmap.new)
      end
    end

    @flags[entityId].set(flagId)
  end

  def remove_flag(entityId, flagId)
    if @flags.size <= entityId
      return
    end

    @flags[entityId].remove(flagId)
  end
  
  def reset_flags(entityId)
    @flags[entityId].clear()
  end

  def entity_ids
    return (0...@nextId).filter do |id|
      !@deadEntities.include?(id)
    end
  end
end

end
end
