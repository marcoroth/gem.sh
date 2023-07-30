class InstanceMethod < OpenStruct
  def initialize(name: nil, target: nil, node: nil)
    super
  end

  def url(gem)
    if target.is_a?(ModuleDefinition)
      Router.gem_module_instance_method_path(gem, target.qualified_name, name)
    else
      Router.gem_class_instance_method_path(gem, target.qualified_name, name)
    end
  end

  def eql?(other)
    target.qualified_name == other.target.qualified_name
  end

  def object_name
    "Instance Method"
  end

  def to_param
    name
  end
end
