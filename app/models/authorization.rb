class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider

  def fetch_events_from_facebook
    graph = Koala::Facebook::API.new(self.token)
    graph.get_connections('me', 'events')['data'].each do |event_data|
      self.fetch_event_from_facebook_by_id event_data['id']
    end
  end

  def fetch_event_from_facebook_by_id(facebook_id, graph=Koala::Facebook::API.new(ENV['facebook_app_token']))
    begin
      event = graph.get_object facebook_id
      if event && event['privacy'] == 'OPEN'
        owner = User.find_by_facebook_id event['owner']['id']
        Event.find_or_create_by_facebook_id(facebook_id: event['id'],
                                            user_id: || owner ? owner.id : self.user_id,
                                            name: event['name'],
                                            description: event['description'],
                                            location: event['location'],
                                            start_time: event['start_time'])
        .categorize_by_keywords
      end
    rescue Koala::Facebook::APIError
      puts "Error accessing Facebook graph"
    end
  end
end
