class GemsController < ApplicationController
  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @gem = Gem.latest_spec_for(params[:id])
  end
end
