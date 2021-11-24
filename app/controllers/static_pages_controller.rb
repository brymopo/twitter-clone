class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to user_path(current_user)
  end
end
