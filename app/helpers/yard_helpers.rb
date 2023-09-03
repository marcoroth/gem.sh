# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable

module YARDHelpers
  def yard_docs
    parser = YARD::DocstringParser.new

    @object.comments.each do |c|
      parser.parse(c)
    end

    if parser.tags.any?
      parser.tags.group_by(&:tag_name).map do |tag_name, tags|
        case tag_name
        when "option"
          option_tags(tags)
        when "param"
          param_tags(tags)
        when "raise"
          raise_tags(tags)
        when "return"
          return_tags(tags)
        when "overload"
          overload_tags(tags)
        when "deprecated"
          deprecated_tags(tags)
        else
          other_tags(tags)
        end
      end.join("<br/>")
    else
      comments_content
    end
  end

  def option_tags(tags)
    items = tags.map { |tag| option_tag(tag) }

    %(
      <b>Options Hash</b>: <code>(**#{tags.first.name})</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def option_tag(tag)
    %(
      <li>
        <b><code>#{tag.pair.name}</code></b>
        (<code>#{tag.pair.types.join(', ')}</code>)
        -- #{tag.pair.text}
      </li>
    )
  end

  def param_tags(tags)
    items = tags.map { |tag| param_tag(tag) }

    %(
      <b>Parameters</b>:</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def param_tag(tag)
    %(
      <li>
        <b><code>#{tag.name}</code></b>
        (<code>#{tag.try(:types).to_a.join(', ')}</code>)
        -- #{tag.try(:text)}
      </li>
    )
  end

  def raise_tags(tags)
    items = tags.map { |tag| raise_tag(tag) }

    %(
      <b>Raises</b>:</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def raise_tag(tag)
    %(
      <li>
        <b><code>(#{tag.types.join(', ')})</code></b>
        - #{tag.text}
      </li>
    )
  end

  def return_tags(tags)
    items = tags.map { |tag| return_tag(tag) }

    %(
      <b>Returns</b>:</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def return_tag(tag)
    %(
      <li>
        <b><code>(#{tag.types.join(', ')})</code></b>
        - #{tag.text}
      </li>
    )
  end

  def deprecated_tags(tags)
    items = tags.map { |tag| deprecated_tag(tag) }

    %(
      <b>Deprecated</b>:</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def deprecated_tag(tag)
    %(
      <li>#{tag.text}</li>
    )
  end

  def overload_tags(tags)
    items = tags.map { |tag| overload_tag(tag) }

    %(
      <b>Overloads</b>:</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def overload_tag(tag)
    %(
      <li>
        <b><code>#{tag.signature.gsub('$0', @object.name)}</code></b>
      </li>
    )
  end

  def other_tags(tags)
    items = tags.map { |tag| other_tag(tag) }

    %(
      <b>Other tags</b>:</code><br/>
      <ul>#{items.join}</ul>
    )
  end

  def other_tag(tag)
    %(<b>#{tag.tag_name.capitalize}</b>:  #{tag.name} -  #{tag.try(:text)} <br/>)
  end
end

# rubocop:enable Rails/HelperInstanceVariable
