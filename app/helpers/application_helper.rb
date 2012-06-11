module ApplicationHelper
  def am_pm_hour_select(field_name)
    select_tag(field_name,options_for_select([
        ["1 AM", "01"],["2 AM", "02"],["3 AM", "03"],["4 AM", "04"],["5 AM", "05"],["6 AM", "06"],
        ["7 AM", "07"],["8 AM", "08"],["9 AM", "09"],["10 AM", "10"],["11 AM", "11"],["Noon", "12"],
        ["1 PM", "13"],["2 PM", "14"],["3 PM", "15"],["4 PM", "16"],["5 PM", "17"],["6 PM", "18"],
        ["7 PM", "19"],["8 PM", "20"],["9 PM", "21"],["10 PM", "22"],["11 PM", "23"],["Midnight", "0"]]))
  end
  
  def title
    base_title = "EventSalsa"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

end
