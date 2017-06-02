
# selfbot
A small Discord selfbot or whatever, written in Ruby

### What is this?
`selfbot` A.K.A. `i was too lazy to give it a clever name` is a small little Discord selfbot that I use on a day-to-day basis.

With it, you can:
- Say things in an embed

![Say stuff in an embed](http://owo.whats-th.is/b9d035.png)    
Embed color is taken from a list of 34 colors, feel free to add more
- Quote things (As long as you're quoting a message in the same channel), WIP

![Quote things](http://owo.whats-th.is/acc839.png)    
Same thing, color is from a list of 34 colors
- Pay your respects (don't ask why I put this in)

![Pay your respects](http://owo.whats-th.is/7c4593.png)   
- Check your ~~(probably high :eyes:)~~ server count

![Check your server count](http://owo.whats-th.is/ba4a9c.png)
- Create/Check your todo list (Requires a "todo.txt" file)

![aaaaaaaaa](http://files.cahbot.pro/ZGI1Y.png)   
Remove function isn't working fully yet
- And some other stuff I'm too lazy to write!

**DISCLAIMER:**    
While it may be a big shock to some of you, this selfbot is *not perfect*, sometimes I'll do something stupid and break the whole thing, or, I don't know, it'll ***cause a nuclear war in the year 2401***. Okay, maybe not that, but still, be aware that this selfbot isn't perfect and some stuff you might see in the code won't actualy work right.
### How to host/use?????????????   
Calm down with the question marks, mate  

To host this selfbot, you must do the following:

Keep in mind these steps are for Windows users. Since I'm sure these steps are different on other OS's, I'd suggest you look certain stuff up.

**Step 1.** Before you start, ensure you have `Ruby`, the Ruby gem `Configatron`, and most importantly, the **`discordrb`** gem    

Apparently this README was short afterwards, so I'll show you how to install Ruby & stuff very quickly

- Install your preferred Ruby version here https://rubyinstaller.org/, make sure you save to your PATH
- Check to make sure you got it right by doing `ruby -v` in your console
- `gem install configatron` and `gem install discordrb`

**Step 2.** `git clone` the repo (if you have git installed). If you have no idea what I'm taking about, [here's some help](https://help.github.com/articles/cloning-a-repository/)    
**Step 3.** Annnd that's all you need to do!   
**Step 4.** I'm kidding of course, it doesn't just magically work like that. Anyway, create a file in the repo you just cloned (or rename `example.config.rb` to it) named `config.rb`. In it, you'll want to put the lines

```rb
configatron.token = 'mfa.YoUr-T_oKen.HEre'
configatron.prefix = 'Your Prefered Prefix'
configatron.name = 'Your username, or whatever you want the selfbot to call you'
configatron.id = 'In order for the selfbot to properly work, place your User ID here'
$embeds = true
# set $embeds to true or false so everything runs buttery smooth
```
in it, obviously putting in your token & stuff into their respective places.

Wait, you don't know how to get your user token? No probalo

To make sure I don't make this super long, here's the short version how

Ctrl+Shift+I on Discord, click the double >, Application, scroll down, bam    
![bam](http://owo.whats-th.is/65d43d.png)    

**Step 5.** Provided that you did everything right, you should be able to `ruby code.rb` in your console and watch it connect :thumbsup:

Noteroni: Issues are bound to happen when installing my selfbot. If in the event that occurs, shoot me a Discord DM and we can troubleshoot *together*

I update this selfbot from time to time, so to get the latest update (provided you have git set up), you can do `<yourprefix>restart`, it'll exit the bot, pull the code, and relaunch.
