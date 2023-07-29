class GemsController < ApplicationController
  def index
  end

  def show
    @gem = Gem.latest_spec_for(params[:id])
  end
end
