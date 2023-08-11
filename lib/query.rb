module Query
  # @return [enumerator<Integer>]
  def query_ids
    return @entityStore.entity_ids
  end

  # def query(*componentType)
  #   componentIds = componentType.map { |type| type.object_id }
    
  #   @archStore.compMap
  #     .filter do |(archComponents, _)|
  #       componentIds.filter { |id| !archComponents.include?(id) }.count == 0
  #     end
  #     .flat_map do |(_, archId)|
  #       archetype = @archStore.get(archId)
  #       entity_ids = @entityStore.entity_ids
  #       componentRows = archetype.components_from_ids(componentIds)
  #       entity_ids
  #         .map do |entId|
  #           componentRows.map do |componentRow|
  #             componentRow[entId]
  #           end
  #         end
  #     end
  # end
  def query(*componentType)
    componentIds = componentType.map { |type| type.object_id }

    @archStore.compMap
      .filter do |archComponents, _|
        (componentIds - archComponents).empty?
      end
      .flat_map do |_, archId|
        @archStore
          .get(archId)
          .active_components(componentIds)
      end
      .each do |a|
        yield a
      end
  end

  def query_with_ids(*componentType)
    componentIds = componentType.map { |type| type.object_id }

    @archStore.compMap
      .filter do |archComponents, _|
        (componentIds - archComponents).empty?
      end
      .flat_map do |_, archId|
        @archStore
          .get(archId)
          .components_and_ids(componentIds)
      end
      .each do |a|
        yield a
      end
  end
end
