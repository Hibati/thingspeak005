class TweetsController < ApplicationController
  def new
  end

  def create
    twitter_current_user.tweet(twitter_params[:message])
  end

  def twitter_params
    params.require(:tweet).permit(:message)
  end
  
end
