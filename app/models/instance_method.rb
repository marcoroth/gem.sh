# frozen_string_literal: true

class InstanceMethod < MethodDefinition
  def url(gem)
    if target.is_a?(ModuleDefinition)
      Router.gem_version_module_instance_method_path(gem.name, gem.version, target.qualified_name, name)
    elsif target.is_a?(ClassDefinition)
      Router.gem_version_class_instance_method_path(gem.name, gem.version, target.qualified_name, name)
    else
      Router.gem_version_instance_method_path(gem.name, gem.version, name)
    end
  end

  def object_name
    "#"
  end

  def instance_method?
    true
  end
end
