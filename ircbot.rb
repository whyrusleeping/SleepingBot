require 'cinch'

bot = Cinch::Bot.new do
	configure do |c|
		c.nick 		= "SleepingBot"
		c.server 	= "irc.freenode.net"
		c.verbose 	= true
		c.channels	= ["#wsutech"]

		@autoop		= true
		@master 	= "whyrusleeping"
		@messages	= []
		@meeting	= ""
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
		if(m.message == ".history")
			File.open("/var/www/messlog.txt","w") do |f|
				@messages.each do |me|
					f.puts me
				end
			end
			m.user.send "http://techclub.eecs.wsu.edu/messlog.txt"
		else if(m.message == ".meeting")
			if(@meeting == nil)
				m.reply "No set meeting time"
			else
				m.reply @meeting unless @meeting == ""
			end
		else
			#this is a problem i think, because im supposedly initializing it in the confiugure area
			if(@messages == nil)
				@messages = []
			end
			mes = "[#{m.time.asctime}] [#{m.user.nick}]  " + m.message
			@messages.push(mes) if m.channel == "#wsutech"
		end
	end
end

bot.start

		
