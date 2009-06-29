module PagesHelper
  def unmap_items(str)
    case str
      when nil, "submissions", "#"
        "submissions"
      when "featured"
        "featured"
      when "users"
        "users"
      else
        str.to_i
    end
  end

  def unmap_order(str)
    str.to_i
  end
end
