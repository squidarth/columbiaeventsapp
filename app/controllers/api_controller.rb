class ApiController < ApplicationController

  def emails
    @emails = []
    if authenticated
      User.all.each do |user|
        if user.email
          @emails << user.email
        end
      end
    end
    respond_to do |format|
      format.html { render :json => @emails }
      format.any(:xml, :json) { render request.format.to_sym => @emails }
    end
  end

  private

  def authenticated
    return signed_in?
  end

  def query
    limit = request.GET[:limit]
    offset = request.GET[:offset]
    # filter query for Event attributes
    query = request.GET.reject{ |k| k == :limit || k == :offset || !Event.column_names.include?(k) }
    results = Event.where(query, limit: limit, offset: offset)
    respond_to do |format|
      format.any(:xml, :json) { render request.format.to_sym => results }
    end
  end
end
