do

local function get_random_porn(attempt)
  attempt = attempt or 0
  res = io.popen('timeout 30s libs/pornhub.js'):read("*all")
  local data = json:decode(res)
  if not data and attempt < 3 then
    print('Cannot get porn, try again...')
    return get_random_porn(attempt + 1)
  end
  return data
end

local function run(msg, matches)
  local data = get_random_porn()
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
