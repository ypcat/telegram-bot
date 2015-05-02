do

function get_videos(html)
  local videos = {}
  for p in html:gmatch("<p class=\"tmb\">.-<div class=\"value\">") do
    table.insert(videos, {
      link = p:match("href=\"(.-)\""):gsub("?.*", ""),
      img = p:match("src=\"(.-)\""):gsub("pt.jpg", "pl.jpg"),
      title = p:match("alt=\"(.-)\""),
      name = p:match("<p class=\"sublink\">(.*)"):gsub("<.->", ""):match("^%s*(.-)%s*$")
    })
  end
  return videos
end

function get_dmm(rawid)
  local label, num = string.match(rawid, "(%a+).-(%d+)")
  local id = string.format("%s%05d", label:lower(), num)
  local res, code  = http.request("http://www.dmm.co.jp/search/=/searchstr="..id)
  if code ~= 200 then return "HTTP ERROR" end
  return get_videos(res)[1]
end

function get_dmm_random()
  local res, code = http.request("http://www.dmm.co.jp/digital/videoa/-/list/=/sort=ranking/")
  if code ~= 200 then return "HTTP ERROR" end
  local videos = get_videos(res)
  return videos[math.random(1, #videos)]
end

function send_title(cb_extra, success, result)
  if success then
    local message = cb_extra[2] .. "\n" .. cb_extra[3] .. "\n" ..cb_extra[4]
    send_msg(cb_extra[1], message, ok_cb, false)
  end
end

function run(msg, matches)
  local receiver = get_receiver(msg)
  if matches[1] == "!dmm" then
    video = get_dmm_random()
  else
    video = get_dmm(matches[1])
  end
  file_path = download_to_file(video.img)
  send_photo(receiver, file_path, send_title, {receiver, video.title, video.name, video.link})
  return false
end

return {
  description = "Send dmm video info",
  usage = {"!dmm (id): Send a dmm video cover and title. If not id, send a random one"},
  patterns = {
    "^!dmm$",
    "^!dmm (.+)"
  },
  run = run
}

end
