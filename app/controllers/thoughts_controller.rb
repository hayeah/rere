class ThoughtsController < ApplicationController
  before_filter :authenticate_user!
end
