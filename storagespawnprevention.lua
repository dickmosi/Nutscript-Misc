PLUGIN.name = "Storage Spawning Prevention"
PLUGIN.author = "a monkey with a typewriter"
PLUGIN.desc = "Restricts the ability to spawn storage to adminges"

function PLUGIN:CanPlayerSpawnStorage(client)
	if client:IsSuperAdmin() or client:IsAdmin() then
		return true
	else 
		return false 
	end
end