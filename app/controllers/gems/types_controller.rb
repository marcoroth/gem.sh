# frozen_string_literal: true

class Gems::TypesController < Gems::BaseController
  def index
    @samples = Types::Sample
               .group(:gem_name, :gem_version, :receiver, :method_name)
               .where(gem_name: @gem.name)
               .where("gem_version LIKE ?", "#{@gem.version.to_s.split('-').first}%")
               .order(count: :desc)
               .count
  rescue StandardError
    @samples = []
  end
end
