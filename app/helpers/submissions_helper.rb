module SubmissionsHelper
  def shortdate(datetime)
    datetime.strftime("%m/%d/%Y")
  end
end
