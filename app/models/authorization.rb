class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider

  def fetch_events_from_facebook
    graph = Koala::Facebook::API.new(self.token)
    begin
      events = graph.get_connections('me', 'events')
      puts events.count
    rescue Koala::Facebook::APIError
      puts "Error accessing Facebook graph"
    end
    (events ||= []).each do |event_data|
      self.fetch_event_from_facebook_by_id event_data['id']
    end
  end

  # [TODO] prevent inappropriate events from being recreated and destroyed
  def fetch_event_from_facebook_by_id(facebook_id,
                                      graph=Koala::Facebook::API.new(ENV['facebook_app_token']),
                                      force_create=false)
    begin
      event_data = graph.get_object facebook_id
    rescue Koala::Facebook::APIError
      puts "Error accessing Facebook graph"
    end
    if event_data ||= nil && event_data['privacy'] == 'OPEN'
      owner = User.find_by_facebook_id(event_data['owner'] ? event_data['owner']['id'] : [])
      event = Event.find_or_create_by_facebook_id(facebook_id: event_data['id'],
                                                  user_id: owner ? owner.id : self.user_id,
                                                  name: event_data['name'],
                                                  description: event_data['description'],
                                                  location: event_data['location'],
                                                  start_time: event_data['start_time'])
      event.fetch_attendings_from_facebook
      if event.appropriate? || force_create
        Categorization.categorize_event_by_keywords event
      else
        event.destroy
      end
    end
  end
end
