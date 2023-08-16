# frozen_string_literal: true

module RBSNamespaceHelpers
  def rbs_signature(gem)
    rbs_method_signatures = methods.map { |method| method.rbs_signature(gem, namespace: false) }.compact

    return nil if rbs_method_signatures.empty?

    <<~RBS
      #{object_name} #{qualified_name}
        #{rbs_method_signatures.join("\n  ")}
      end
    RBS
  end
end