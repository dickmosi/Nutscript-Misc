PLUGIN.name = "Vorti-Howl"
PLUGIN.author = "josephfra"
PLUGIN.desc = "Howling for Vorts!"

nut.flag.add("Y", "Access to Horde Language.")

nut.chat.register("horde", {
			onCanSay = function(speaker)
				if !speaker:getChar():hasFlags("Y") then return false end
			end,
			onCanHear = function(speaker, listener)
			local dist = speaker:GetPos():Distance(listener:GetPos())
			local speakRange = nut.config.get("chatRange", 280) * 1.5
			
			if (dist <= speakRange) then
				if listener:getChar():hasFlags("Y") then
					return true
				else
					chat.AddText(Color(77, 158, 154), speaker, " says something in a foreign language.")
					return false
				end
			else return false end
				
			end,
			onChatAdd = function(speaker, text)
				chat.AddText(Color(77, 158, 154), speaker, " says \""..text.."\"")
			end,
			prefix = {"/h", "/horde"},
			font = "nutMediumFont",
			filter = "IC"
})