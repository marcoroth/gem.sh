class ModuleDefinition < OpenStruct
  def initialize(namespace: nil, name: nil, qualified_name: nil, instance_methods: [], class_methods: [])
    super
  end

  def eql?(other)
    qualified_name == other.qualified_name
  end

  def object_name
    "module"
  end

  def to_s
    "#{object_name} #{qualified_name}"
  end

  def to_param
    qualified_name
  end
end
