--[[
	!!!READ ME!!!
	
	A basic example of how to prevent items not being added/lost when using inventory:add("item") OR...
	just preventing errors from popping up when someone tries to take an item with a full inventory.
	
	Written for Nutscript 1.1-beta
	
	THIS REALLY SHOULD BE IN NUTSCRIPT BY DEFAULT ALREADY!
--]]

ITEM.name = "Full Inv Item Loss Prevention"
ITEM.desc = "Full Inventory Error Prevention Test Item" -- See above for more info.
ITEM.model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

ITEM.width = 1
ITEM.height = 1

ITEM.functions._duplicate = { 
	name = "Duplicate",
	tip = "Used to test full inventory item loss prevention",
	icon = "icon16/cog.png",
	onRun = function(item)
	local client = item.player
	local char = client:getChar()
	local inventory = char:getInv()
	-------------------------------------------------------------- YOU'RE LOOKING FOR THIS.
	local freeSpot = inventory:findFreePosition(item)
	local position = client:getItemDropPos()
	
	if freeSpot == nil then
		nut.item.spawn("givetest", position)
		client:notify("Your inventory is full.")
	else
		inventory:add("givetest")
	end
	--------------------------------------------------------------
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

ITEM:hook("take", function(item)
	local client = item.player
	local inventory = client:getChar():getInv()
	
	local freeSpot = inventory:findFreePosition(item)
	
	if freeSpot == nil then
		client:notify("Your inventory is full.")
		return false
	end
end)

--------------------------------- JUST A HELPFUL FUNCTION FOR TESTING THIS CODE
ITEM.functions._zdelete = { 
	name = "Delete",
	tip = "",
	icon = "icon16/bin.png",
	onRun = function(item)
	end
}