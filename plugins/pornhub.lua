do

local function run(msg, matches)
  local data = json:decode(io.popen('timeout 30s libs/pornhub.js'):read("*all"))
  if not data then
    return 'Error getting porn, please try again later.'
  else
    local receiver = get_receiver(msg)
    send_photo_from_url(receiver, data.img)
    local txt = ''
    txt = txt .. data.title .. '\n'
    txt = txt .. data.hd .. ' ' .. data.duration .. '\n'
    txt = txt .. data.views .. ' views ' .. data.rating .. '\n'
    txt = txt .. data.link
    return txt
  end
end

return {
  description = "Gets a random video from pornhub",
  usage = {
    "!pornhub: Get a porn video."
  },
  patterns = {
    "^!pornhub$"
  },
  run = run
}

end
