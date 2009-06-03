class FeaturedCart
  attr_reader  :items
  
  def initialize
    @items = []
  end 
  
  def add_submission(submission)
    @items << submission
  end
  
  def remove_submission(index)
    @items.delete_at(index)
  end
end