require 'discordrb'
require 'configatron'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, type: :user, prefix: 'cah!', advanced_functionality: false, help_command: false, parse_self: true, help_available: false, debug: true, log_mode: :quiet

bot.set_user_permission(228290433057292288, 1)

bot.command(:eval, help_available: false, permission_message: false, permission_level: 1) do |event, *code, args|
  begin
    eval code.join(' ')
  rescue => e
    event.message.edit "Cah tried #{args.join} and it ended in... ```#{e}```"
  end
end

bot.command(:die, help_available: false, permission_message: false, permission_level: 1) do |event|
  bot.send_message(event.channel.id, ':wave::skin-tone-1:')
  exit
end

bot.command(:restart, help_available: false, permission_level: 1, permission_message: false) do |event|
  begin
    event.message.edit "Restarting selfbot..."
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
  event.message.edit ["Uh, don't you think a say command for a selfbot is a bit redundant?", "Uh, why do you need this, dude?", "If you want to say something, do it yourself"].sample
end

bot.command(:cmds, help_available: false, permission_message: false, permission_level: 1, max_args: 0) do |event|
  event << "cah!eval: Do stuff."
  event << "cah!die: Kill urself."
  event << "cah!ping: You alive bro?"
  event << "cah!servercount: How high can you go?"
  event << "cah!say: Isn't this redundant for a selfbot?"
  event << "cah!restart: Something new."
  event << ""
  event << "For any bystanders who saw this, yes, I did make this somewhat from scratch ~~(I did however take some code from my own bot :CLAP:)~~"
end

# whatever I'll finish it later

bot.run
