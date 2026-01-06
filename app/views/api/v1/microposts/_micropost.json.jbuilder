json.id micropost.id
json.title micropost.title
json.body micropost.body
json.created_at micropost.created_at.to_date.strftime("%B %d, %Y")
json.updated_at micropost.updated_at.to_date.strftime("%B %d, %Y")
json.user do
  json.id micropost.user.id
  json.username micropost.user.username
end
