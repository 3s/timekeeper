# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def format_spend(value)
    sprintf("%.2f", value) if value
  end

end
