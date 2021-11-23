class TweetsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.create(tweet_params)
    if @tweet.valid?
      flash[:notice] = "Tweet created!"
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "Tweet cannot be created"
      render :new
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
