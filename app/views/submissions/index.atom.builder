atom_feed(:url => submissions_url(:atom)) do |feed|
  feed.title "Pixelfuckers.org - 16 Newest Submissions"
  feed.updated @submissions.first.created_at

  @submissions.each do |submission|
    feed.entry(submission) do |entry|
      entry.title submission.title
      entry.content submission.description_html, :type => "html"

      entry.author do |author|
        author.name submission.users.first.username
      end
    end
  end
end