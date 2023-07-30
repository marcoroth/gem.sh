class InstanceMethod < OpenStruct
  def initialize(name: nil, target: nil, node: nil)
    super
  end

  def eql?(other)
    target.qualified_name == other.target.qualified_name
  end

  def object_name
    "Instance Method"
  end
end
