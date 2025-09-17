-- CORE --

---@type Group
function CreateGroup(name, level, inherit)

	---@class Group
	local self = {};

	self.name = name;
	self.level = level;
	self.inherit = inherit;

	---@param target Group
	function self.canTarget(target)
		if (self.name == Config.DefaultGroup) then

			return false;

		else
			if (self.level == target.level) then

				return true;

			elseif (self.inherit == target.name) then

				return true;

			elseif (self.level >= target.level) then

				return true;

			else

				return ESX.Groups[self.inherit].canTarget(target);

			end
		end
	end

	return self;

end

-- SCRIPT --

ESX.AddGroup = function(name, level, inherits)

	if (type(name) ~= 'string') then
		-- print("ES_ERROR: There seems to be an issue while creating a new group, please make sure that you entered a correct 'group' as 'string'");
	end

	if (type(inherits) ~= 'string') then
		-- print("ES_ERROR: There seems to be an issue while creating a new group, please make sure that you entered a correct 'inherit' as 'string'");
	end

	-- ExecuteCommand('add_principal group.' .. name .. ' group.' .. inherits);
	ESX.Groups[name] = CreateGroup(name, level, inherits);

end

ESX.GroupCanTarget = function(targetGroup1, targetGroup2, cb)
	if ESX.Groups[targetGroup1] and ESX.Groups[targetGroup2] then
		if cb then
			cb(ESX.Groups[targetGroup1].canTarget(ESX.Groups[targetGroup2]));
		else
			return ESX.Groups[targetGroup1].canTarget(ESX.Groups[targetGroup2]);
		end
	else
		if cb then
			cb(false)
		else
			return false
		end
	end
end

-- Default groups
ESX.AddGroup(Config.DefaultGroup, 0, Config.DefaultGroup);
ESX.AddGroup('helpeur', 1, 'helpeur');
ESX.AddGroup('moderateur', 2, 'moderateur');
ESX.AddGroup('friends', 3, 'friends');
ESX.AddGroup('admin', 4, 'admin');
ESX.AddGroup('responsable', 5, 'responsable');
ESX.AddGroup('gerantstaff', 6, 'gerantstaff');
ESX.AddGroup('fondateur', 7, 'fondateur');

RegisterNetEvent("esx:receivedGroup", function()
	
	local src = source;
	local xPlayer = ESX.GetPlayerFromId(src);

	if (xPlayer) then
		ESX.SavePlayer(xPlayer, function()
			DropPlayer(src, "Vos permissions ont été changées, vous pouvez désormais vous reconnecter");
		end);
	end

end);