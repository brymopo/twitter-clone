class FollowsController < ApplicationController
  before_action :authenticate_user!

  def new
    @follow = Follow.new
  end

  def create
    @followee = User.find_by!(username: follow_params[:username])
    @follow = Follow.create!(
                             follower_id: current_user.id,
                             followed_id: @followee.id
                           )
    flash[:notice] = "Following #{@followee.username}"
    redirect_to user_path(@followee)
  rescue StandardError => e
    flash.now[:alert] = "One or more errors occured. Make sure that the username exists"
    render :new
  end

  private

  def follow_params
    params.require(:follow).permit(:username)
  end
end
