do

function run(msg, matches)
  local res, code = http.request("http://g.e-hentai.org/")
  if code ~= 200 then return "HTTP ERROR" end
  mangas = {}
  for p in res:match("Popular Right Now(.*)"):gmatch("class=\"id1\"(.-)class=\"id44\"") do
    table.insert(mangas, {
      link = p:match("href=\"(.-)\""),
      img = p:match("img src=\"(.-)\""),
      title = p:match("title=\"(.-)\"")
    })
  end
  local manga = mangas[math.random(1, #mangas)]
  local receiver = get_receiver(msg)
  send_photo_from_url(receiver, manga.img)
  return manga.title .. '\n' .. manga.link
end

return {
  description = "Send an e-hentai manga info.",
  usage = {"!dmm: Send an e-hentai manga info."},
  patterns = {
    "^!e%-hentai$",
  },
  run = run
}

end

