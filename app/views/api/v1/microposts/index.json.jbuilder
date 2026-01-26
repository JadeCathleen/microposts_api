json.microposts @microposts do |micropost|
  json.partial! "api/v1/microposts/micropost", { micropost: micropost }
end

json.pagy do
  page = @pagy.page
  pages = @pagy.pages

  json.page  page
  json.pages pages

  json.prev(page > 1 ? page - 1 : nil)
  json.next(page < pages ? page + 1 : nil)

  json.limit @pagy.limit
  json.count @pagy.count
end
