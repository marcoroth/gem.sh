class GemsController < ApplicationController
  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @gem = Gemspec.find(params[:id]).metadata
  end
end
