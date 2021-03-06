require 'discordrb'
require 'configatron'
require 'open-uri'
require 'fileutils'
require 'tempfile'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, type: :user, prefix: configatron.prefix, advanced_functionality: false, help_command: false, parse_self: true, help_available: false, debug: true, log_mode: :quiet

bot.set_user_permission(configatron.id.to_i, 1)

def read
  open('todo.txt', &:read)
end

def remove
  File.open('todo.txt', "w") do |out_file|
    File.foreach('todo.txt') do |line|
      out_file.puts line unless line.chomp == "#{args.join(' ')}"
    end
  end
end

colors = [11736341, 3093151, 2205818, 2353205, 12537412, 12564286,
  3306856, 9414906, 3717172, 14715195, 3813410, 9899000,
  16047888, 4329932, 12906212, 9407771, 1443384, 13694964,
  6157013, 8115963, 9072972, 16299832, 15397264, 10178593,
  7701739, 8312810, 13798754, 15453783, 12107214, 9809797,
2582883, 13632200, 12690287, 14127493].sample

vapeS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890=+!@#$%&*():;',.?/ "
vapeE = "ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ１２３４５６７８９０＝＋！＠＃＄％＆＊（）：；＇，．？／　"

bot.ready do |event|
  bot.game = 'woahdude'
  $game = "woahdude"
end

bot.command(:eval, help_available: false, permission_message: false, permission_level: 1) do |event|
  begin
    event.message.edit "Input: ```rb
#{event.message.content[configatron.prefix.size + 5..-1]}```
Output:
```#{eval event.message.content[configatron.prefix.size + 5..-1]}```"
  rescue => e
    event.message.edit "Input: ```rb
#{event.message.content[configatron.prefix.size + 5..-1]}```
Output:
```#{e}```"
  end
end

bot.command(:set, help_available: false, permission_message: false, permission_level: 1) do |event, action, *args|
  case action
  when 'avatar'
    open("#{args.join(' ')}") { |pic| event.bot.profile.avatar = pic }
    event.message.edit "Avatar changed!"
  when 'game'
    bot.game = "#{args.join(' ')}"
    $game = "#{args.join(' ')}"
    event.message.edit "Game set to `#{args.join(' ')}`"
  when 'status'
    online = bot.on
    idle = bot.idle
    invis = bot.invisible
    dnd = bot.dnd
    eval args.join
  when 'embeds'
    if args.join(' ') == 'false'
      load 'config.rb'
      file_names = ['config.rb']
      file_names.each do |file_name|
        text = File.read(file_name)
        new_contents = text.gsub(/embeds = true/, "embeds = false")
        File.open(file_name, "w") { |file| file.puts new_contents }
        nil
      end
      event.respond "Embeds hae been turned off"
    elsif args.join(' ') == 'true'
      load 'config.rb'
      file_names = ['config.rb']
      file_names.each do |file_name|
        text = File.read(file_name)
        new_contents = text.gsub(/embeds = false/, "embeds = true")
        File.open(file_name, "w") { |file| file.puts new_contents }
        nil
      end
      event.respond "Embeds have been turned on"
    else
      event.respond "Invalid value, try `true` or `false`"
    end
  else
    event.message.edit "My apologies, but #{action.join(' ')} is not a valid setting, you can use `embeds`, `status`, `game`, or `avatar`"
  end
end

bot.command(:game, help_available: false, permission_message: false, permission_level: 1, max_args: 0) do |event|
  event.message.edit "#{configatron.name}, your current game status is `#{$game}`"
end

bot.command(:get, help_available: false, permission_message: false, permission_level: 1) do |event, action, *args|
  load 'config.rb'
  mention = bot.parse_mention("#{args.join (' ')}")
  case action
  when 'info'
    if !event.message.mentions.empty?
      if $embeds == true
        event.channel.send_embed do |e|
          e.title = "Some general info about #{mention.name}"
          e.add_field(name: "ID", value: "`#{mention.id}`")
          e.add_field(name: "Distinct (username#0000)", value: "#{mention.distinct}")
          e.add_field(name: "Nickname", value: "#{mention.on(event.server).nick}")
          e.add_field(name: "Game", value: "#{mention.game}")
          e.add_field(name: "Created On", value: "#{mention.creation_time}")
          e.add_field(name: "Joined This Server On", value: "#{mention.on(event.server).joined_at}")
          e.color = colors
        end
      else
        event.respond "__Some general info about #{mention.name}__
ID: `#{mention.id}`
Distinct (username#0000): `#{mention.distinct}`
Nickname: `#{mention.on(event.server).nick}`
Game: `#{mention.game}`
Created On: `#{mention.creation_time}`
Joined This Server On: `#{mention.on(event.server).joined_at}`"
      end
    else
      event.respond "Sorry, you have you actually *mention* the person you want to get info for"
    end
  when 'id'
    if !event.message.mentions.empty?
      if $embeds == true
        event.channel.send_embed do |e|
          e.title = "User ID for #{mention.name}"
          e.description = "#{mention.id}"
          e.color = colors
        end
      else
        event.respond "User ID for #{mention.name}: #{mention.id}"
      end
    else
      event.respond "Sorry, you have to actually *mention* the person you want to get the ID for"
    end
  else
    event.respond "Uh oh, that's not a valid thing to get, currently you can get `info` or `id`"
  end
end

bot.command(:me, help_available: false, permission_message: false, permission_level: 1) do |event, *args|
  event.channel.send_embed do |embed|
    event.message.delete
    embed.description = "***#{configatron.name}*** *#{event.message.content[configatron.prefix.size + 2..-1]}*"
    embed.color = [11736341, 3093151, 2205818, 2353205, 12537412, 12564286,
      3306856, 9414906, 3717172, 14715195, 3813410, 9899000,
      16047888, 4329932, 12906212, 9407771, 1443384, 13694964,
      6157013, 8115963, 9072972, 16299832, 15397264, 10178593,
      7701739, 8312810, 13798754, 15453783, 12107214, 9809797,
    2582883, 13632200, 12690287, 14127493].sample
  end
end

bot.command(:esay, help_available: false, permission_message: false, permission_level: 1) do |event, *args|
  event.channel.send_embed do |embed|
    event.message.delete
    embed.description = "#{event.message.content[configatron.prefix.size + 4..-1]}"
    embed.color = [11736341, 3093151, 2205818, 2353205, 12537412, 12564286,
      3306856, 9414906, 3717172, 14715195, 3813410, 9899000,
      16047888, 4329932, 12906212, 9407771, 1443384, 13694964,
      6157013, 8115963, 9072972, 16299832, 15397264, 10178593,
      7701739, 8312810, 13798754, 15453783, 12107214, 9809797,
    2582883, 13632200, 12690287, 14127493].sample
  end
end

bot.command(:die, help_available: false, permission_message: false, permission_level: 1) do |event|
  load 'config.rb'
  if $embeds == true
    event.channel.send_embed do |e|
      e.title = "#{configatron.prefix}die"
      e.description = "':wave::skin-tone-1:'"
      e.color = colors
    end
  else
    bot.send_message(event.channel.id, ':wave::skin-tone-1:')
    exit
  end
end

bot.command(:restart, help_available: false, permission_level: 1, permission_message: false) do |event|
  load 'config.rb'
  if $embeds == true
    begin
      event.channel.send_embed do |e|
        e.title = "#{configatron.prefix}restart"
        e.description = ["Restarting selfbot...", "See you later :wave::skin-tone-1:!", "[sentence about restarting a bot]", "There was a 1 in 5 chance I would say this, cool beans", "nil."].sample
        e.color = colors
      end
      sleep 0.5
      exec("bash restart.sh")
    rescue
      event.respond "Something bad happened, make sure there's a `restart.sh` file in the selfbot folder, if so, bug Cah about it"
    end
  else
    begin
      event.message.edit ["Restarting selfbot...", "See you later :wave::skin-tone-1:!", "[sentence about restarting a bot]", "There was a 1 in 5 chance I would say this, cool beans", "nil."].sample
      sleep 0.5
      exec("bash restart.sh")
    rescue
      event.respond "Something bad happened, make sure there's a `restart.sh` file in the selfbot folder, if so, bug Cah about it"
    end
  end
end

bot.command(:ping, help_available: false, max_args: 0, permission_message: false, permission_level: 1) do |event|
  m = event.respond ('Pinging!')
  m.edit ["Pong! Hey, that took #{((Time.now - event.timestamp) * 1000).to_i}ms.", "Spong! Hey, that took #{((Time.now - event.timestamp) * 1000).to_i}ms", "This whole operation took #{((Time.now - event.timestamp) * 1000).to_i}ms to do", "WOOOAAAAAHHHHH, that took #{((Time.now - event.timestamp) * 1000).to_i}ms", "Memes (took #{((Time.now - event.timestamp) * 1000).to_i}ms)"].sample
end

bot.command([:servercount, :servcount], help_available: false, max_args: 0, permission_message: false, permission_level: 1) do |event|
  event.message.edit "#{configatron.name}, you're in **#{bot.servers.count}** servers right now"
end

bot.command(:say, help_available: false, permission_message: false, permission_level: 1, min_args: 0) do |event|
  event.message.edit ["Uh, don't you think a say command for a selfbot is a bit redundant?", "Uh, why do you need this, dude?", "If you want to say something, do it yourself", "[joke about how `say` commands in selfbots are dumb]"].sample
end

bot.command(:quote, help_available: false, permission_message: false, permission_level: 1) do |event, id|
  msg_content = event.channel.history(2, nil, id.to_i - 1).last.content
  msg_time = event.channel.history(2, nil, id.to_i - 1).last.timestamp
  msg_username = event.channel.history(2, nil, id.to_i - 1).last.author.name
  msg_userava = event.channel.history(2, nil, id.to_i - 1).last.author.avatar_url
  event.channel.send_embed do |e|
    e.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{msg_username} has been quoted!", icon_url: "#{msg_userava}")
    e.description = "#{msg_content}"
    e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Sent on #{msg_time}")
    e.color =colors
  end
end

bot.command(:todo, help_available: false, permission_message: false, permission_level: 1) do |event, action, *args|
  case action
  when 'remove'
    remove
    "Removed `#{args.join(' ')}` from the list!"
  when 'add'
    File.open('todo.txt', 'a+') do |file|
      file.puts "#{args.join(' ')} \n"
      "Added `#{args.join(' ')}` to the list!"
    end
  else
    event << "Your To-Do list, right now"
    event << ""
    event << "```#{read}```"
  end
end

bot.command(:f, help_available: false, permission_message: false, permission_level: 1) do |event, *args|
  if args.empty? == true
    event.message.edit ["#{configatron.name} has paid their respects :thumbsup::skin-tone-1:",
      "#{configatron.name} has paid their respects <:PMthumbsup:255810065917804554>",
      "#{configatron.name} has paid their respects :heart:",
      ":heart: respects paid has their #{configatron.name}",
      "#{configatron.name} has paid their respects :ok_hand::skin-tone-1:",
      "#{configatron.name} has paid their respects <:gold_cookie:260084252362801152>"].sample
  elsif args.empty? == false
    event.message.edit ["#{configatron.name} has paid their respects to *#{args.join(' ')}*:thumbsup::skin-tone-1:",
      "#{configatron.name} has paid their respects to *#{args.join(' ')}*, nice",
      "#{configatron.name} has paid their respects to *#{args.join(' ')}* :heart:",
      ":heart: respects paid has their #{configatron.name} to *#{args.join(' ')}*",
      "#{configatron.name} has paid their respects to *#{args.join(' ')}* :ok_hand::skin-tone-1:",
      "#{configatron.name} has paid their respects to *#{args.join(' ')}* :wastebasket:"].sample
  end
end

bot.command(:info, help_available: false, permission_message: false, permission_level: 1, max_args: 0) do |event|
  event << "__Info about this selfbot__"
  event << ''
  event << "*What is it?* A selfbot Cah uses on a day to day basis, written in Ruby"
  event << "*Who made it?* Cah#5153 made this selfbot"
  event << "*Is it open-source?* For the most part, just don't claim it as your own without making any changes :eyes:: https://github.com/2003cah/selfbot"
  event << "*When was it made?* First commit was on Jan 19, 2017, so it's safe to assume it was made that day"
end

bot.command(:flip, help_available: false, max_args: 0, permission_level: 1, permission_message: false) do |event|
  event.message.edit '**Flipping Coin...**'
  sleep [1, 2, 3, 4].sample
  event.message.edit ["#{configatron.name} flipped a coin and it landed on Heads", "#{configatron.name} flipped a coin and it landed on tails"].sample
end

bot.command(:roll, help_available: false, max_args: 0, permission_level: 1, permission_message: false) do |event|
  event.message.edit '**Rolling Dice!**'
  sleep [1, 2, 3, 4].sample
  event.message.edit "#{configatron.name} rolled a die and got a... **#{rand(1..6)}!**"
end

bot.command([:vape, :vapor], help_available: false, permission_message: false, permission_level: 1) do |event, *args|
  event.message.edit "#{args.join(' ').tr(vapeS, vapeE)}"
end

bot.command([:cmds, :commands, :help], help_available: false, permission_message: false, permission_level: 1, max_args: 0) do |event|
  load 'config.rb'
  if $embeds == true
    event.channel.send_embed do |e|
      e.title = "Cah's Selfbot Commands"
      e.description = "#{configatron.prefix}eval: Evaluate code, Ruby style.
#{configatron.prefix}die: Shuts down the bot, without pulling code or anything.
#{configatron.prefix}ping: Check to see if your selfbot is alive
#{configatron.prefix}servercount: Prints your server count
#{configatron.prefix}say: Isn't this redundant for a selfbot?
#{configatron.prefix}info: Shows some info about this selfbot
#{configatron.prefix}restart: Closes the bot, `git pull`s, and reloads the bot
#{configatron.prefix}esay: Says stuff in an embed, the embed color is based of a list of 34 colors
#{configatron.prefix}quote <messageid>: Quotes a message, using an embed format
#{configatron.prefix}set <avatar | game | status> <args>: Sets some stuff, still in the works
#{configatron.prefix}roll: Roll a die (Picks a number from 1 through 6)
#{configatron.prefix}flip: Flip a coin (Picks heads or tails)
#{configatron.prefix}vapor: ｍ ｅ ｍ ｅ ｓ"
      e.color = colors
    end
  else
  event.respond "__Cah's Selfbot Commands__
#{configatron.prefix}eval: Evaluate code, Ruby style.
#{configatron.prefix}die: Shuts down the bot, without pulling code or anything.
#{configatron.prefix}ping: Check to see if your selfbot is alive
#{configatron.prefix}servercount: Prints your server count
#{configatron.prefix}say: Isn't this redundant for a selfbot?
#{configatron.prefix}info: Shows some info about this selfbot
#{configatron.prefix}restart: Closes the bot, `git pull`s, and reloads the bot
#{configatron.prefix}esay: Says stuff in an embed, the embed color is based of a list of 34 colors
#{configatron.prefix}quote <messageid>: Quotes a message, using an embed format
#{configatron.prefix}set <avatar | game | status> <args>: Sets some stuff, still in the works
#{configatron.prefix}roll: Roll a die (Picks a number from 1 through 6)
#{configatron.prefix}flip: Flip a coin (Picks heads or tails)
#{configatron.prefix}vapor: ｍ ｅ ｍ ｅ ｓ"
  end
end

# knowing me I probably need to fix everything

bot.run
