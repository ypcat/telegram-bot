do

function get_high_rating()
  local res, code = http.request("http://g.e-hentai.org/?f_doujinshi=1&f_manga=1&f_artistcg=1&f_gamecg=1&f_western=0&f_non-h=1&f_imageset=1&f_cosplay=1&f_asianporn=1&f_misc=1&f_search=&f_apply=Apply+Filter&advsearch=1&f_sname=on&f_stags=on&f_sr=on&f_srdd=4")
  if code ~= 200 then return "HTTP ERROR" end
  local gidlist = {}
  for gid, gtok in res:gmatch("http://g.e%-hentai.org/g/([^/]+)/([^/]+)/") do
    table.insert(gidlist, {gid, gtok})
  end
  gidlist = {gidlist[math.random(1, #gidlist)]}
  local reqbody = json:encode{method="gdata", gidlist=gidlist}
  local resbody = {}
  local result, respcode, respheaders, respstatus = http.request {
    url="http://g.e-hentai.org/api.php",
    method="POST",
    headers={
      ["Content-Type"]="application/json",
      ["Content-Length"]=tostring(#reqbody)
    },
    source=ltn12.source.string(reqbody),
    sink=ltn12.sink.table(resbody),
  }
  local data = json:decode(resbody[1]).gmetadata[1]
  return data.thumb, data.title .. '\n' .. data.title_jpn .. '\n' .. 'rating: ' .. data.rating .. '\n' .. "http://g.e-hentai.org/g/" .. data.gid .. '/' .. data.token
end

function get_popular()
  local res, code = http.request("http://g.e-hentai.org/")
  if code ~= 200 then return "HTTP ERROR" end
  local mangas = {}
  for p in res:gmatch("class=\"id1\"(.-)class=\"id44\"") do
    table.insert(mangas, {
      link = p:match("href=\"(.-)\""),
      img = p:match("img src=\"(.-)\""),
      title = p:match("title=\"(.-)\"")
    })
  end
  local manga = mangas[math.random(1, #mangas)]
  return manga.img, manga.title .. '\n' .. manga.link
end

function run(msg, matches)
  local url = nil
  local txt = nil
  if matches[1] == "!e-hentai" then
    url, txt = get_popular()
  else
    url, txt = get_high_rating()
  end
  local receiver = get_receiver(msg)
  send_photo_from_url(receiver, url)
  return txt
end

return {
  description = "Send an e-hentai manga info.",
  usage = {
    "!e-hentai: Send an popular right not e-hentai manga info.",
    "!e-hentai top: Send a > 4-star e-hentai manga info."
  },
  patterns = {
    "^!e%-hentai$",
    "^!e%-hentai top$",
  },
  run = run
}

end

