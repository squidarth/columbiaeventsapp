object @event
attributes :id, :name, :start_time, :location
attributes :description, :facebook_id

attributes :photo_content_type
node(:photo_url) { |event| event.photo.url }
node(:photo_url_small) { |event| event.photo.url(:small) }

child(:categorizations) {
  attributes :category_id, :name
}
