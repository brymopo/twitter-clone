class UsersController < ApplicationController
  before_action :authenticate_user!, :set_user

  def show
    @followers = user_actual.followers_count
    @following = user_actual.following_count
    @tweets_feed = user_actual.tweets_feed(include_following: is_current_user?)
                              .page params[:page]
  end

  def followers
    @followers = user_actual.followers
                            .alphabetical
                            .page params[:page]
  end

  def following
    @following = user_actual.following
                            .alphabetical
                            .page params[:page]
  end

  private

  attr_reader :user_actual

  def set_user
    if is_current_user?
      @user_actual = current_user
    else
      @user_actual = User.find_by!(username: params[:username])
    end
  end

  def is_current_user?
    params[:username] == current_user.username
  end
end
