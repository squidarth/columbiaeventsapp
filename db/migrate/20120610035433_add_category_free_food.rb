class AddCategoryFreeFood < ActiveRecord::Migration
  def up
    id = Category.create(name: "Free Food").id
    Event.where('description LIKE ?', '%free food%').each do |e|
      Categorization.create(category_id: id, event_id: e.id)
    end
  end

  def down
    Category.where(name: "Free Food").destroy_all
  end

  def check_for_food(event)
    description = event.description.downcase
    if description.include? "free food"
      return true
    else 
      return false
    end
  end
end
