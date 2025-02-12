-- Copyright (c) 2025 Metatable Games, all rights reserved.
-- GitHub: https://github.com/Metatable-Games/SentinelAdonis
-- SentinelAPI SDK: https://github.com/Metatable-Games/sentinel.sdk

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local SDK = ServerScriptService:WaitForChild("Sentinel");

if not SDK then
	warn("Failed to locate Sentinel API SDK; please install it from https://github.com/Metatable-Games/sentinel.sdk.")
end

server = nil 
service = nil

return function()
	if not SDK then
		return
	end
	
	local API = require(SDK)
	server.Commands.sunban = {
		Prefix = server.Settings.Prefix;
		Commands = {"sunban"};
		Args = {"UserId", "reason"};
		Description = "Sentinel Admin:";
		AdminLevel = 100;
		Function = function(plr, args)
			local userId = args[1]
			
			if not tonumber(userId) then
				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Sentinel API",
					Icon = server.MatIcons.Gavel,
					Text = "Bad input; expected valid number user id.",
					Time = 10;
				})
				return
			end
			
			if tonumber(userId) <= 0 then
				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Sentinel API",
					Icon = server.MatIcons.Gavel,
					Text = "Bad input; expected valid number user id.",
					Time = 10;
				})
				return
			end
			
			local valid_username = Players:GetNameFromUserIdAsync(userId)

			if not valid_username then
				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Sentinel API",
					Icon = server.MatIcons.Gavel,
					Text = "That is not a valid Roblox user id!",
					Time = 10;
				})
				return
			end


			table.remove(args, 1)

			local reason = table.unpack(args)
			
			if not API:IsUserIdBanned(userId) then
				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Sentinel API",
					Icon = server.MatIcons.Gavel,
					Text = ("%s is not currently not banned."):format(valid_username),
					Time = 10;
				})
				return
			end
			
			local s,e = pcall(function()
				API:UnbanAsync(userId, reason)
			end)
			
			if not s then
				warn("An Sentinel API error occured: ", e)
				
				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Sentinel API",
					Icon = server.MatIcons.Gavel,
					Text = ("Failed to unban %s due to %s"):format(valid_username, e),
					Time = 10;
				})
				
				return
			end
			
			task.defer(server.Remote.MakeGui, plr, "Notification", {
				Title = "Sentinel API",
				Icon = server.MatIcons.Gavel,
				Text = ("%s has been unbanned!"):format(valid_username),
				Time = 10;
			})
		end	
	}

	server.Commands.sgtban = {
		Prefix = server.Settings.Prefix;
		Commands = {"sgtban"};
		Args = {"Player(s)", "Time", "reason"};
		Description = "Sentinel Admin:";
		AdminLevel = 100;
		Function = function(plr, args)
			local targets = args[1]
			local timeFrame = args[2];

			table.remove(args, 1)
			table.remove(args, 2)

			local reason = table.unpack(args)

			for i,v in pairs(service.GetPlayers(plr, targets)) do
				API:BanAsync(v, {
					Moderator = plr.UserId;
					BanType = "Experience";
					BanLengthType = "Temporary";
					BanUniversal = true;
					BanLength = timeFrame;
					PrivateReason = reason;
					PublicReason = reason;
					BanKnownAlts = true;
				})

				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Player Banned",
					Icon = server.MatIcons.Gavel,
					Text = service.FormatPlayer(v).." has been temporary banned globally.",
					Time = 10;
				})
			end
		end	
	}

	server.Commands.stban = {
		Prefix = server.Settings.Prefix;
		Commands = {"stban"};
		Args = {"Player(s)", "Time", "reason"};
		Description = "Sentinel Admin:";
		AdminLevel = 100;
		Function = function(plr, args)
			local targets = args[1]
			local timeFrame = args[2];

			table.remove(args, 1)
			table.remove(args, 2)

			local reason = table.unpack(args)

			for i,v in pairs(service.GetPlayers(plr, targets)) do
				API:BanAsync(v, {
					Moderator = plr.UserId;
					BanType = "Experience";
					BanLengthType = "Temporary";
					BanUniversal = false;
					BanLength = timeFrame;
					PrivateReason = reason;
					PublicReason = reason;
					BanKnownAlts = true;
				})

				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Player Banned",
					Icon = server.MatIcons.Gavel,
					Text = service.FormatPlayer(v).." has been temporary banned from the experience.",
					Time = 10;
				})
			end
		end	
	}

	server.Commands.sgban = {
		Prefix = server.Settings.Prefix;
		Commands = {"sgban"};
		Args = {"Player(s)", "reason"};
		Description = "Sentinel Admin:";
		AdminLevel = 100;
		Function = function(plr, args)
			local targets = args[1]

			table.remove(args, 1)

			local reason = table.unpack(args)

			for i,v in pairs(service.GetPlayers(plr, targets)) do
				API:BanAsync(v, {
					Moderator = plr.UserId;
					BanType = "Experience";
					BanLengthType = "Permanent";
					BanUniversal = true;
					BanLength = 0;
					PrivateReason = reason;
					PublicReason = reason;
					BanKnownAlts = true;
				})

				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Player Banned",
					Icon = server.MatIcons.Gavel,
					Text = service.FormatPlayer(v).." has been permanent banned globally.",
					Time = 10;
				})
			end
		end	
	}
	
	server.Commands.sban = {
		Prefix = server.Settings.Prefix;
		Commands = {"sban"};
		Args = {"Player(s)", "reason"};
		Description = "Sentinel Admin:";
		AdminLevel = 100;
		Function = function(plr, args)
			local targets = args[1]
			
			table.remove(args, 1)
			
			local reason = table.unpack(args)
			
			for i,v in pairs(service.GetPlayers(plr, targets)) do
				API:BanAsync(v, {
					Moderator = plr.UserId;
					BanType = "Experience";
					BanLengthType = "Permanent";
					BanUniversal = false;
					BanLength = 0;
					PrivateReason = reason;
					PublicReason = reason;
					BanKnownAlts = true;
				})
				
				task.defer(server.Remote.MakeGui, plr, "Notification", {
					Title = "Player Banned",
					Icon = server.MatIcons.Gavel,
					Text = service.FormatPlayer(v).." has been permanent banned from the experience.",
					Time = 10;
				})
			end
		end	
	}
end
