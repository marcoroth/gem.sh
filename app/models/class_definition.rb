class ClassDefinition < OpenStruct
  def initialize(namespace: nil, name: nil, qualified_name: nil, node: nil, superclass: nil, instance_methods: [], class_methods: [])
    super
  end

  def eql?(other)
    qualified_name == other.qualified_name
  end

  def object_name
    "class"
  end

  def to_s
    "#{object_name} #{qualified_name}#{superclass ? " < #{superclass.qualified_name}" : nil}"
  end

  def to_param
    qualified_name
  end
end
