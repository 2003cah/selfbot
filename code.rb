require 'discordrb'
require 'configatron'
require 'open-uri'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, type: :user, prefix: 'cah!', advanced_functionality: false, help_command: false, parse_self: true, help_available: false, debug: true, log_mode: :quiet

bot.set_user_permission(228290433057292288, 1)

bot.command(:eval, help_available: false, permission_message: false, permission_level: 1) do |event, *code|
  begin
    event.message.edit "Input: `#{code.join(' ')}`

Output:
```#{eval code.join(' ')}```"
  rescue => e
    event.message.edit "Input: `#{code.join(' ')}`

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
      event.message.edit "Game set to: `#{args.join(' ')}`"
    when 'status'
      online = bot.on
      idle = bot.idle
      invis = bot.invisible
      dnd = bot.dnd
      eval args.join
    else
      event.message.edit "Cah did his own command wrong smh"
    end
end

bot.command(:me, help_available: false, permission_message: false, permission_level: 1) do |event, *args|
  event.channel.send_embed do |embed|
    event.message.delete
    embed.description = "***Cah*** *#{args.join(' ')}*"
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
    embed.description = "#{args.join(' ')}"
    embed.color = [11736341, 3093151, 2205818, 2353205, 12537412, 12564286,
      3306856, 9414906, 3717172, 14715195, 3813410, 9899000,
      16047888, 4329932, 12906212, 9407771, 1443384, 13694964,
      6157013, 8115963, 9072972, 16299832, 15397264, 10178593,
      7701739, 8312810, 13798754, 15453783, 12107214, 9809797,
    2582883, 13632200, 12690287, 14127493].sample
  end
end

bot.command(:die, help_available: false, permission_message: false, permission_level: 1) do |event|
  bot.send_message(event.channel.id, ':wave::skin-tone-1:')
  exit
end

bot.command(:restart, help_available: false, permission_level: 1, permission_message: false) do |event|
  begin
    event.message.edit ["Restarting selfbot...", "See you later :wave::skin-tone-1:!", "[sentence about restarting a bot]", "There was a 1 in 5 chance I would say this, cool beans", "nil."].sample
    sleep 0.5
    exec("bash restart.sh")
  end
end

bot.command(:ping, help_available: false, max_args: 0, permission_message: false, permission_level: 1) do |event|
  m = event.respond ('Pinging!')
  m.edit "Pong! Hey, that took #{((Time.now - event.timestamp) * 1000).to_i}ms."
end

bot.command([:servercount, :servcount], help_available: false, max_args: 0, permission_message: false, permission_level: 1) do |event|
  event.message.edit "Cah, you're in **#{bot.servers.count}** servers right now"
end

bot.command(:say, help_available: false, permission_message: false, permission_level: 1, min_args: 0) do |event|
  event.message.edit ["Uh, don't you think a say command for a selfbot is a bit redundant?", "Uh, why do you need this, dude?", "If you want to say something, do it yourself", "[joke about how `say` commands in selfbots are dumb]"].sample
end

bot.command(:quote, help_available: false, permission_message: false, permission_level: 1) do |event, *id|
  msg_content = event.channel.history(2, nil, id.join - 1).last.content
  msg_time = event.channel.history(2, nil, id.join - 1).last.timestamp
  msg_username = event.channel.history(2, nil, id.join - 1).last.author.name
  msg_userava = event.channel.history(2, nil, id.join - 1).last.author.avatar_url
  event.channel.send_embed do |e|
    e.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{msg_username}", icon_url: "#{msg_userava}")
    e.description = "#{msg_content}"
    e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Sent on #{msg_time}")
    e.color = [11736341, 3093151, 2205818, 2353205, 12537412, 12564286,
      3306856, 9414906, 3717172, 14715195, 3813410, 9899000,
      16047888, 4329932, 12906212, 9407771, 1443384, 13694964,
      6157013, 8115963, 9072972, 16299832, 15397264, 10178593,
      7701739, 8312810, 13798754, 15453783, 12107214, 9809797,
    2582883, 13632200, 12690287, 14127493].sample
  end
end

bot.command(:cmds, help_available: false, permission_message: false, permission_level: 1, max_args: 0) do |event|
  event << "cah!eval: Do stuff."
  event << "cah!die: Kill urself."
  event << "cah!ping: You alive bro?"
  event << "cah!servercount: How high can you go?"
  event << "cah!say: Isn't this redundant for a selfbot?"
  event << "cah!restart: Something new."
  event << "cah!esay: Says stuff in an embed, the embed color is based of a list of 34 colors"
  event << "cah!quote <messageid>: Quotes a message, using an embed format"
  event << ""
  event << "For any bystanders who saw this, yes, I did make this somewhat from scratch ~~(I did however take some code from my own bot <:CLAP:267372593483350016>)~~"
end

# whatever I'll finish it later

bot.run
