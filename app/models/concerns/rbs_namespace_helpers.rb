# frozen_string_literal: true

module RBSNamespaceHelpers
  def rbs_signature(gem, require_samples: true)
    rbs_method_signatures = methods.map { |method| method.rbs_signature(gem, require_samples: require_samples) }.compact

    return nil if rbs_method_signatures.empty?

    <<~RBS
      # #{defined_files.first.path.gsub("#{gem.unpack_data_path}/lib/", 'sig/')}s

      #{object_name} #{qualified_name}
        #{rbs_method_signatures.join("\n  ")}
      end
    RBS
  end
end
