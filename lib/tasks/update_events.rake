	desc "grab all facebook events"
	task :grab_events => :environment do
		Event.fetch_all_from_facebook
	end

	desc "update the numAttending of all events"
	task :update_attending => :environment do
		Event.update_attendings()
	end
