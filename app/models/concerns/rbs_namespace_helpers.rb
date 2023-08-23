# frozen_string_literal: true

module RBSNamespaceHelpers
  def rbs_signature(gem, require_samples: true)
    rbs_method_signatures = methods.map { |method| method.rbs_signature(gem, require_samples:) }.compact

    return nil if rbs_method_signatures.empty?

    rbs_superclass = (defined?(superclass) && superclass) ? " < #{superclass.qualified_name}" : nil

    <<~RBS
      # #{defined_files.first.path.gsub("#{gem.unpack_data_path}/lib/", 'sig/')}s

      #{object_name} #{qualified_name}#{rbs_superclass}
        #{rbs_method_signatures.map { |sig| sig.gsub("\n", "\n  ") }.join("\n  ")}
      end
    RBS
  end
end
