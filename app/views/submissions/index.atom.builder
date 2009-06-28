atom_feed(:url => formatted_submissions_url(:atom)) do |feed|
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

# atom_feed do |feed|
#   feed.title("My great blog!")
#   feed.updated((@posts.first.created_at))
# 
#   for post in @posts
#     feed.entry(post) do |entry|
#       entry.title(post.title)
#       entry.content(post.body, :type => 'html')
# 
#       entry.author do |author|
#         author.name("DHH")
#       end
#     end
#   end
# end
