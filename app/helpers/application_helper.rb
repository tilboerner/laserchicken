module ApplicationHelper

  def dom_id(item)
    item.class.name.downcase + '-' + item.id.to_s
  end

end
