# frozen_string_literal: true

class ClassMethod < MethodDefinition
  def url(gem)
    if target.is_a?(ModuleDefinition)
      Router.gem_module_class_method_path(gem.name, gem.version, target.qualified_name, name)
    elsif target.is_a?(ClassDefinition)
      Router.gem_class_class_method_path(gem.name, gem.version, target.qualified_name, name)
    else
      Router.gem_class_method_path(gem.name, gem.version, name)
    end
  end

  def object_name
    "::"
  end

  def class_method?
    true
  end
end
