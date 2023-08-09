require_relative 'archetype'

class ArchStore
  # [[Integer]:Integer]
  attr_accessor :compMap
  
  def initialize
    # [Archetype]
    @archetypes = []
    # [[ComponentId]:ArchetypeId]
    @compMap = Hash.new
  end

  def get(archetypeId)
    return @archetypes[archetypeId]
  end

  # @params [Array<Integer>] componentIds: a sorted array of component ids
  def get_archetype_id(componentIds)
    archId = @compMap[componentIds]
    if archId != nil
      return archId
    else
      id = @archetypes.size
      @archetypes.push Archetype.new(componentIds)
      @compMap[componentIds] = id
      return id
    end
  end
end
