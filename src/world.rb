require_relative 'entity'
require_relative 'arch_store'
require_relative 'query'

class World
  def initialize
    @entityStore = EntityStore.new
    @archStore = ArchStore.new
  end

  def spawn(*components)
    compIds = components.map { |c| c.class.object_id }.sort
    archId = @archStore.get_archetype_id(compIds)
    entId = @entityStore.new_id
    archetype = @archStore.get(archId)
    archRowId = archetype.new_arch_row_id(entId)
    @entityStore.spawn(entId, archId, archRowId)
    for component in components
      archetype.set_component(archRowId, component)
    end
    return entId
  end

  def get_component(entityId, componentType)
    entity = @entityStore.get(entityId)
    archetype = @archStore.get(entity.archId)
    archetype.get_component(entity.archRow, componentType.object_id)
  end

  def kill(entityId)
    entity = @entityStore.get entityId
    @entityStore.kill(entityId)
    archetype = @archStore.get(entity.archId)
    archetype.remove_entity(entity.archRow)
  end

  def entity_count
    return @entityStore.entity_count
  end

  def has_component(entityId, componentType)
    entity = @entityStore.get(entityId)
    archetype = @archStore.get(entity.archId)
    return archetype.has_component(componentType.object_id)
  end

  def has_flag(entityId, flagId)
    return @entityStore.has_flag entityId, flagId
  end

  def has_flags(entityId, *flagIds)
    return flagIds.filter { |flagId| !@entityStore.has_flag entityId, flagId }.count == 0
  end

  def set_flag(entityId, flagId)
    @entityStore.set_flag(entityId, flagId)
  end

  def remove_flag(entityId, flagId)
    @entityStore.remove_flag(entityId, flagId)
  end

  include Query
end
