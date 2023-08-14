# frozen_string_literal: true

module MethodFinders
  def find_method(name)
    find_class_method(name) || find_instance_method(name)
  end

  def find_method!(name)
    find_method(name) || raise(GemConstantNotFoundError, "Couldn't find method '#{name}' on #{object_name} #{name}")
  end

  def find_class_method(name)
    class_methods.find { |class_method| class_method.name == name }
  end

  def find_instance_method(name)
    instance_methods.find { |instance_method| instance_method.name == name }
  end
end
