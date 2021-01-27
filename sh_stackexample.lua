--[[
Credit goes to Chancer for his split/merge code. It's a weird mix of my own work and his.
The bulk of it is taken from an old schema of mine and I really can't recall who's is what but I think it's mainly his.
-]]

ITEM.name = "Stack Example"
ITEM.desc = "Uses Nutscript's default stackable item thing... kinda"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.uniqueID = "stack_example"

----------------------------------------------------------------------------------------------------

ITEM.isStackable = true
ITEM.maxQuantity = 10

ITEM.functions._MergeUn = { 
	name = "Split",
	tip = "",
	icon = "icon16/delete.png",
	onRun = function(item)
	local client = item.player
	local inventory = client:getChar():getInv()
		
	local stack = item:getQuantity()
	if(stack <= 1) then return false end

	client:requestString("Split", "", function(text)	
	amount = math.Clamp(tonumber(text), 1, stack - 1)

	item:setQuantity(stack - amount)
	nut.item.spawn(item.uniqueID, client:getItemDropPos(), -- Just adding to the inventory will auto-merge
		function(item2)
			item2:setData("quantity", amount) -- converts into Item data, is converted back upon pickup.
		end
	)
	end, 1)	
	
	return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

ITEM.functions._Merge = {
	name = "Merge",
	tip = "",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local inventory = char:getInv()
		local stack = item:getQuantity()
		
		local total = stack
		for k, v in pairs(inventory:getItems()) do
			if(v.id == item.id) then
				continue
			end
		
			if(v.uniqueID == item.uniqueID) then
				total = total + v:getQuantity()
				
				if(v.id != item.id) then
					v:remove()
				end
			end
		end
		
		if(total <= item.maxQuantity) then
			item:setQuantity(total)
		else
			local position = client:getItemDropPos()
		
			for i = 1, math.floor(total / item.maxQuantity) do
				timer.Simple(i/5, function()
					inventory:add(item.uniqueID, item.maxQuantity)
				end)
			end
			
			local remainder = total - (item.maxQuantity * math.floor(total / item.maxQuantity))
			if(remainder > 0) then
				item:setQuantity(remainder)
			else
				return true
			end
		end
		
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

ITEM.onCombine = function(itemSelf, itemTarget)
	if(itemSelf.uniqueID == itemTarget.uniqueID) then
		local amountSelf = itemSelf:getQuantity()
		local amountTarget = itemTarget:getQuantity()
		
		local combined = amountSelf + amountTarget
		
		if(combined > itemSelf.maxQuantity) then
			itemSelf:setQuantity(itemSelf.maxQuantity)
			itemTarget:setQuantity(combined - itemSelf.maxQuantity)
		else
			itemTarget:remove()
			itemSelf:setQuantity(amountSelf + amountTarget)
		end
	end
end

ITEM:hook("take", function(item)
	local client = item.player
	local inventory = client:getChar():getInv()
	
	local freeSpot = inventory:findFreePosition(item)
	
	if freeSpot == nil then
		client:notify("Your inventory is full.")
		return false
	end
	-- Converts item data back into quantity
	if item:getData("quantity") ~= nil then
		item:setQuantity(item:getData("quantity"))
		item:setData("quantity", nil)
	end	
end)

if (CLIENT) then
	function ITEM:paintOver(item, w, h) -- This displays the Item's quantity.
		draw.SimpleText(item:getQuantity(), "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
	end
end
---------------------------------------------------------------------------------------
------------------------------------------- TESTING FUNCTIONS

--[[
item:addQuantity(amount)
item:setQuantity(amount)
item:getQuantity()
--]]

ITEM.functions._addQuantity = { 
	name = "Add +1 Quantity",
	tip = "",
	icon = "icon16/brick_add.png",
	onRun = function(item)
	
	if item:getQuantity() == item.maxQuantity then
		item.player:notify("Max Quantity Reached!")
		return false
	end
	
	item:addQuantity(1)
	
	return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

ITEM.functions._dupeQuantity = { -- This function showcases built-in merging quite nicely
	name = "Duplicate Quantity",
	tip = "",
	icon = "icon16/bricks.png",
	onRun = function(item)
	local inventory = item.player:getChar():getInv()

	inventory:add(item.uniqueID, item:getQuantity()) -- ITEM, Quantity, Data
	
	return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

ITEM.functions._setQuantity = { 
	name = "Set Quantity",
	tip = "",
	icon = "icon16/brick_edit.png",
	onRun = function(item)
	
	item.player:requestString("Set Quantity", "", function(text)	
	amount = math.Clamp(tonumber(text), 1, item.maxQuantity)
		item:setQuantity(amount)
	end, 1)
	
	return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

ITEM.functions._getQuantity = { 
	name = "Get Quantity",
	tip = "",
	icon = "icon16/brick_go.png",
	onRun = function(item)
		
	item.player:ChatPrint(item:getQuantity())
	
	return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}