class InstanceMethod < MethodDefinition
  def url(gem)
    if target.is_a?(ModuleDefinition)
      Router.gem_module_instance_method_path(gem, target.qualified_name, name)
    else
      Router.gem_class_instance_method_path(gem, target.qualified_name, name)
    end
  end

  def object_name
    "#"
  end

  def instance_method?
    true
  end
end
