module EventsHelper
  class EventListing
    extend ActsAsApi::Base
    attr_accessor :upcoming, :recent

    def initialize(opts)
      opts.each do |k,v|
        self.send :"#{k}=", v
      end
    end

    acts_as_api
    api_accessible :public do |t|
      t.add :upcoming
      t.add :recent
    end
  end
end
