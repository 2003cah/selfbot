require 'discordrb'
require 'configatron'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, type: :user, prefix: 'cah!', advanced_functionality: false, help_command: false, parse_self: true, help_available: false, debug: true #, log_mode: :quiet

bot.set_user_permission(271076191161548800, 1)

bot.command(:eval, help_available: false, permission_message: false, permission_level: 1) do |event, *code|
  begin
    event.message.delete
    m = (eval code.join(' '))
    sleep 5
    m.delete
  rescue => e
    event << "Ah geez, something went wrong, it says:"
    event << "```"
    event << "#{e} ```"
  end
end

bot.command(:say, help_available: false, permission_message: false, permission_level: 1, min_args: 0) do |event|
  event.respond ["Uh, don't you think a say command for a selfbot is a bit redundant?", "Uh, why do you need this, dude?", "If you want to say something, do it yourself"].sample
end

#whatever I'll finish it later

bot.run
