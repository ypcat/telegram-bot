
local function run(msg, matches)
  messages = {
    "SONG!",
    "超爽的～撿到一百塊咧～",
    "黑人給我閉嘴～歐巴馬～",
    "我才不告訴逆咧～雷"
  }
  return messages[ math.random( #messages ) ]
end

return {
  description = "Simplest plugin ever!",
  usage = "!echo [whatever]: echoes the msg",
  patterns = {
    "[Ss][Oo][Nn][Gg]"
  }, 
  run = run 
}
