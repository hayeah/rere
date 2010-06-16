class AdminController < ApplicationController
  REVISION = `cd #{Rails.root} && git log HEAD^^^..HEAD`
  layout "box"
  def revision
  end
end
