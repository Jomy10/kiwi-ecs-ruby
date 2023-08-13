module Kiwi
  module Internal
    ComponentColumn = Struct.new(:components)
    
    class Archetype
      # @params [Array<Integer>] componentIds
      def initialize(componentIds)
        # [Integer(componentId): ComponentColumn]
        @components = componentIds.map do |compId|
          [compId, ComponentColumn.new([])]
        end.to_h
        @availableEntityRows = []
        @entities = []
      end

      # @return [int]
      def new_arch_row_id(entityId)
        id = @availableEntityRows.pop
        if id != nil
          @entities[id] = entityId
          return id
        else
          id = @entities.size
          @entities.push entityId
          return id
        end
      end

      def set_component(archRowId, component)
        compCol = @components[component.class.object_id]
        if compCol.components.size <= archRowId
          compCol.components.push component
        else
          compCol.components[archRowId] = component
        end
      end

      def get_component(archRowId, componentId)
        return @components[componentId].components[archRowId]
      end

      def has_component(componentId)
        return @components[componentId] != nil
      end

      def remove_entity(archRowId)
        @availableEntityRows.push(archRowId)
        @entities[archRowId] = nil
      end

      # @return [[Component, EntityId]]
      def active_components(componentIds)
        # [comp1a, comp1b]
        # [comp2a, comp2b]
        # ...
        components = componentIds
          .map do |compId|
            @components[compId].components
          end
        compCount = componentIds.size

        @entities
          .each_with_index
          .filter do |entId, _|
            entId != nil
          end
          .map do |_, rowIdx|
            (0...compCount).map do |compRowId|
              components[compRowId][rowIdx]
            end
          end
      end

      def components_and_ids(componentIds)
        # [comp1a, comp1b]
        # [comp2a, comp2b]
        # ...
        components = componentIds
          .map do |compId|
            @components[compId].components
          end
        compCount = componentIds.size

        @entities
          .each_with_index
          .filter do |entId, _|
            entId != nil
          end
          .map do |entId, rowIdx|
            [entId, *(0...compCount).map do |compRowId|
              components[compRowId][rowIdx]
            end]
          end
      end
    end
  end
end
