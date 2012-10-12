require 'cinch'

bot = Cinch::Bot.new do
	configure do |c|
		c.nick 		= "SleepingBotTEST"
		c.server 	= "irc.freenode.net"
		c.verbose 	= true
		c.channels	= ["#wsutech"]

		@autoop		= true
		@master 	= "whyrusleeping"
		@messages	= []
	end

	on :join do |m|
		puts "|" + m.user.nick + "|"
		if(m.user.nick == "whyrusleeping")
			puts "opping master!"
			m.channel.op(m.user) if m.user.authed?
		end
		m.reply "Welcome #{m.user.nick}!" unless m.user.nick == "SleepingBot"
	end

	on :channel, /^!autoop (on|off)$/ do |m, option|
		@autoop = true
	end

	on :message do |m|
		if(m.message == ".history2")
			File.open("messlog.txt","w") do |f|
				@messages.each do |me|
					f.puts me
				end
			end
			m.user.send "http://techclub.eecs.wsu.edu/messlog.txt"
			#@messages.each do |me|
			#	m.user.send me
			#end
		else
			puts m.message
			puts m.channel
			puts m.user
			if(@messages == nil)
				@messages = []
			end
			mes = "[#{m.time.asctime}] [#{m.user.nick}]  " + m.message
			@messages.push(mes) if m.channel == "#wsutech"
		end
	end
end

bot.start

		
