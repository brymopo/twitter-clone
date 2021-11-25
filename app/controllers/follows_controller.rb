class FollowsController < ApplicationController
  before_action :authenticate_user!

  def new
    @follow = Follow.new
  end

  def create
    @followee = User.find_by(username: follow_params[:username])
    @follow = Follow.new(follower_id: current_user.id)

    if @followee.present?
      @follow.followed_id = @followee.id
      @follow.save
    end

    if @follow.valid? && @followee.present?
      flash[:notice] = "Following #{@followee.username}"
      redirect_to user_path(@followee)
    else
      flash.now[:alert] = "One or more errors occured. See below"
      render :new
    end
  end

  private

  def follow_params
    params.require(:follow).permit(:username)
  end
end
