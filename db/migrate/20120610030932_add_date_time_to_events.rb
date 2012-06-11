class AddDateTimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :start_time, :datetime
    Event.all.each do |e|
      if e.date and e.time
        e.update_attribute(:start_time, DateTime.parse("#{e.date} #{e.time.to_formatted_s(:time)} #{e.time.zone}"))
      end
    end
  end

  def self.down
    remove_column :events, :start_time
  end
end
