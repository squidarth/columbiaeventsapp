object @event
attributes :id, :name, :description, :start_time, :facebook_id

attributes :photo_content_type
node(:photo_url) { |event| event.photo.url }
node(:photo_url_small) { |event| event.photo.url(:small) }
