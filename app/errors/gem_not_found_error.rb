# frozen_string_literal: true

class GemNotFoundError < StandardError
  def initialize(name, version = nil)
    super(name)
    @name = name
    @version = version
  end

  def message
    if @name && @version
      %(Couldn't find gem "#{@name} with version "#{@version}")
    else
      %(Couldn't find gem "#{@name}")
    end
  end
end
