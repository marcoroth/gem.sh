# frozen_string_literal: true

MethodDefinition = Struct.new(:name, :target, :node, :location, :comments, :defined_files) do
  def initialize(
    name: nil,
    target: nil,
    node: nil,
    location: nil,
    comments: [],
    defined_files: []
  )
    super
  end

  def instance_method?
    false
  end

  def class_method?
    false
  end

  def eql?(other)
    name == other.name && target.qualified_name == other.target.qualified_name
  end

  def to_s
    "#{object_name} #{name}"
  end

  def to_param
    name
  end

  def seo_title
    if target
      "#{name} (#{target.qualified_name})"
    else
      name
    end
  end

  def title
    to_s
  end

  def code
    @code ||= LocationToContent.new(defined_files.first, location)
  end
end
