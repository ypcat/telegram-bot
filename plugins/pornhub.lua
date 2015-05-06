do

local function run(msg, matches)
  local data = json:decode(io.popen('timeout 30s libs/pornhub.js ' .. matches[1]):read("*all"))
  if not data then
    return 'Error getting porn, please try again later.'
  else
    local receiver = get_receiver(msg)
    local txt = ''
    if matches[1] == 'list' then
      for k, v in pairs(data) do txt = txt .. k .. '\n' end
    else
      send_photo_from_url(receiver, data.img)
      txt = txt .. data.title .. '\n'
      txt = txt .. data.hd .. ' ' .. data.duration .. '\n'
      txt = txt .. data.views .. ' views ' .. data.rating .. '\n'
      txt = txt .. data.link
    end
    return txt
  end
end

return {
  description = "Gets a random video from pornhub",
  usage = {
    "!pornhub: Get a porn video.",
    "!pornhub (category): Get a porn video with given category.",
    "!pornhub list: Get list of categories.",
  },
  patterns = {
    "^!pornhub$",
    "^!pornhub (.*)",
  },
  run = run
}

end
