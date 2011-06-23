class PagesController < ApplicationController
  def home
    @title = "Home"
    @event = Event.all#{:one => Event.find(-1), :two => Event.find(-2), :three => Event.find(-3), :four => Event.find(-4)}
    
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

end
