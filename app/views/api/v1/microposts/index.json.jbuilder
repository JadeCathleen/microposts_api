json.microposts @microposts, partial: "api/v1/microposts/micropost", as: :micropost do |micropost|
  json.user do
    json.id micropost.user.id
    json.username micropost.user.username
  end
end
