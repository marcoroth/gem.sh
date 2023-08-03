class MethodDefinition < OpenStruct
  def initialize(name: nil, target: nil, node: nil, comments: [])
    super
  end

  def instance_method?
    false
  end

  def class_method?
    false
  end

  def eql?(other)
    name == other.name && target.qualified_name == other.target.qualified_name
  end

  def to_s
    "#{object_name} #{name}"
  end

  def to_param
    name
  end

  def title
    if target
      "#{name} (#{target.qualified_name})"
    else
      name
    end
  end
end
