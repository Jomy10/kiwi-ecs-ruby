module Kiwi
module Internal

# TODO: actual bitmap implementation
class Bitmap
  def initialize
    @flags = []
  end

  def contains(id)
    return (@flags.size > id) && @flags[id]
  end

  def set(id)
    if @flags.size < id
      (@flags.size...id).each do |i|
        @flags.push false
      end
    end

    @flags[id] = true
  end
  
  def remove(id)
    if @flags.size > id
      @flags[id] = false
    end
  end

  def clear
    (0...@flags.size).each do |i|
      @flags[i] = false
    end
  end
end

end
end
