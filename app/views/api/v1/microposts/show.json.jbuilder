json.micropost do
  json.partial! "api/v1/microposts/micropost", { micropost: @micropost }
end

if local_assigns[:flash]
  json.flash local_assigns[:flash]
end
