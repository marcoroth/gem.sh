class ClassDefinition < OpenStruct
  def initialize(namespace: nil, name: nil, qualified_name: nil, instance_methods: [], class_methods: [])
    super
  end

  def eql?(other)
    qualified_name == other.qualified_name
  end

  def object_name
    "class"
  end
end
