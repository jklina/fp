module SubmissionsHelper
  def shortdate(datetime)
    datetime.strftime("%m/%d/%Y")
  end

  def authors(submission, make_links = true)
    if make_links
      submission.users.map { |u| link_to h(u.username), user_path(u) }.to_sentence
    else
      submission.users.map { |u| h(u.username) }.to_sentence
    end
  end
end
