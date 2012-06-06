class PagesController < ApplicationController
  def home
    @title = "Home"
    @users = User.all
    @array_of_events = Event.all
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
end
