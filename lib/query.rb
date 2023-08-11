module Query
  # @return [enumerator<Integer>]
  def query_ids
    if block_given?
      @entityStore.entity_ids.each do |id|
        yield id
      end
    else
      return @entityStore.entity_ids
    end
  end

  def query(*componentType)
    componentIds = componentType.map { |type| type.object_id }

    result = @archStore.compMap
      .filter do |archComponents, _|
        (componentIds - archComponents).empty?
      end
      .flat_map do |_, archId|
        @archStore
          .get(archId)
          .active_components(componentIds)
      end

    if block_given?
      result.each do |a|
        yield a
      end
    else
      return result.to_enum
    end
  end

  def query_with_ids(*componentType)
    componentIds = componentType.map { |type| type.object_id }

    result = @archStore.compMap
      .filter do |archComponents, _|
        (componentIds - archComponents).empty?
      end
      .flat_map do |_, archId|
        @archStore
          .get(archId)
          .components_and_ids(componentIds)
      end

    if block_given?
      result.each do |a|
        yield a
      end
    else
      return result.to_enum
    end
  end
end
