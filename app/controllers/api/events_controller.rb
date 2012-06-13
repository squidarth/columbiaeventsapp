class Api::EventsController < ApplicationController
  respond_to :json
  before_filter :determine_scope, only: [:upcoming, :recent]

  def show
    @event = Event.find(params[:id]) || []
  end

  def upcoming
    @events = Event.find_all_upcoming @datetime, @options
    puts params
    render 'index'
  end

  def recent
    @events = Event.find_all_recent @datetime, @options
    render 'index'
  end

  protected

  def determine_scope
    @options = params.symbolize_keys.reject { |k| not ['limit', :limit, :offset].include?(k) }
    @options[:limit] ||= 10
    puts @options
    @datetime = params[:datetime] || DateTime.now
  end
end
