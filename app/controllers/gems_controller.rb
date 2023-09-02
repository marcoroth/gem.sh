# frozen_string_literal: true

class GemsController < ApplicationController
  include GemScoped

  before_action :set_gem, except: :index

  def index
    @gems = Gems.just_updated
  end

  def show
    @getting_started = [
      { title: "Installation", url: readme_gem_version_gem_path(@gem.name, @gem.version), description: "Learn more about how to install and configure the gem", icon: "arrow-down-tray" },
      { title: "Documentation", url: readme_gem_version_gem_path(@gem.name, @gem.version), description: "Learn more about the details", icon: "book-open" },
      { title: "Guides", url: gem_version_guides_path(@gem.name, @gem.version), description: "Learn more about the gem in the written guides", icon: "document-text" },
      { title: "Reference", url: reference_gem_version_gem_path(@gem.name, @gem.version), description: "Learn more about the classes and modules", icon: "code-bracket" },
    ]
  end
end
