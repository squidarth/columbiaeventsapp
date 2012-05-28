class PopulateCategorizationsFromTagsAndEvents < ActiveRecord::Migration

  @@old_categories = ['', 'Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other']
  @@new_categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Cultural', 'Special Interest', 'Music', 'NYC Event', 'Academic']


  def self.up
    @@new_categories.each do |c|
      Category.create(:name => c)
    end
    Tag.all.each do |t|
      Categorization.create(:event_id => t.event_id, :category_id => Category.find_or_create_by_name(t.name).id) if t.event_id and @@new_categories.include? t.name
    end
    Event.all.each do |e|
      Categorization.create(:event_id => e.id, :category_id => Category.find_or_create_by_name(@@old_categories[e.category]).id) if e.category and @@new_categories.include? @@old_categories[e.category]
    end
  end

  def self.down
    @@new_categories.each do |c|
      Category.where(:name => c).destroy_all
    end
    Tag.all.each do |t|
      Categorization.joins(:category).where(:event_id => t.event_id, :categories => { :name => t.name }).destroy_all if t.event_id and @@new_categories.include? t.name
    end
    Event.all.each do |e|
      Categorization.joins(:category).where(:event_id => e.id, :categories => { :name => @@old_categories[e.category] }).destroy_all if e.category and @@new_categories.include? @@old_categories[e.category]
    end
  end
end
