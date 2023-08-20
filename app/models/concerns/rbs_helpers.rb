# frozen_string_literal: true

module RBSHelpers
  def rbs_signature(gem, require_samples: true)
    return nil if require_samples && samples(gem).empty?

    "def #{class_method? ? 'self.' : ''}#{name}: (#{rbs_parameters(gem)}) -> #{rbs_return_value(gem)}"
  end

  private

  def rbs_parameters(gem)
    parameters = samples(gem).pluck(:parameters).compact.flatten(1).group_by { |p| [p[0], p[1]] }

    params_to_rbs(parameters).join(", ")
  end

  def rbs_return_value(gem)
    return "void" if instance_method? && name == "initialize"

    return_values = samples(gem).pluck(:return_value).compact

    if return_values.any?
      type_list_to_rbs(return_values)
    else
      "untyped"
    end
  end

  def params_to_rbs(params)
    params.to_h.map do |(param_name, param_type), types|
      type_list = types.map(&:last)

      param_type_to_rbs_symbol(param_type, param_name, type_list_to_rbs(type_list))
    end
  end

  def param_type_to_rbs_symbol(param_type, param_name, rbs_type)
    case param_type
    when "req"
      "#{rbs_type} #{param_name}"
    when "opt"
      "?#{rbs_type} #{param_name}"
    when "rest"
      "*#{param_name}: #{rbs_type}"
    when "key", "keyreq"
      "#{param_name}: #{rbs_type}"
    when "keyopt"
      "?#{param_name}: #{rbs_type}"
    when "keyrest"
      "**#{param_name}: #{rbs_type}"
    when "block"
      "&#{param_name}: #{rbs_type}"
    else
      raise "Don't know about param_type: #{param_type}"
    end
  end

  def type_to_rbs(type)
    case type
    when Array
      first = type.shift
      if first == "Array"
        if type.length >= 7
          "Array"
        else
          "Array[#{type.map { |t| type_to_rbs(t) }.join(', ')}]"
        end
      elsif first == "Hash"
        "Hash<...>"
      else
        first
      end
    else
      case type
      when "TrueClass"
        "true"
      when "FalseClass"
        "false"
      when "NilClass"
        "nil"
      else
        type
      end
    end
  end

  def type_list_to_rbs(types)
    types = Array.wrap(types).map! { |type| type_to_rbs(type) }.uniq.compact

    if types.count("true").positive? && types.count("false").positive?
      types -= ["true", "false"]
      types << "bool"
    end

    # TODO: if number of unique types is greater than (?) then the parameter is probably of type Object

    list = types.join(" | ")

    if types.none?
      "untyped"
    elsif types.one?
      list
    else
      "(#{list})"
    end
  end
end
