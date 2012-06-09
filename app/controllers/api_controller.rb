class ApiController < ApplicationController
  def	events 
    @events = Event.getTopEvents()
    render :json => @events
  end

  def query
    limit = request.GET[:limit]
    offset = request.GET[:offset]
    # filter query for Event attributes
    query = request.GET.reject{ |k| k == :limit || k == :offset || !Event.column_names.include?(k) }
    render :json => Event.where(query, limit: limit, offset: offset)
  end

  def emails
    @emails = []
    User.all.each do |user|
      if user.email
        @emails << user.email
      end

    end

    if signed_in?
      render :json => @emails
    else
      render :json => []
    end
  end

  private

  def get_top
  end

  def authenticate
    if(!signed_in?)
      return false
    else
      return true
    end
  end
end
