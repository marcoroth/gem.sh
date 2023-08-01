class InstanceMethod < MethodDefinition
  def url(gem)
    if target.is_a?(ModuleDefinition)
      Router.gem_module_instance_method_path(gem.name, gem.version, target.qualified_name, name)
    elsif target.is_a?(ClassDefinition)
      Router.gem_class_instance_method_path(gem.name, gem.version, target.qualified_name, name)
    else
      Router.gem_instance_method_path(gem.name, gem.version, name)
    end
  end

  def object_name
    "#"
  end

  def instance_method?
    true
  end

  def title
    "#{name} (#{target.qualified_name})"
  end
end
