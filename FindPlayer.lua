local serverUrl = "https://www.roblox.com/games/getgameinstancesjson?placeId=%s&startIndex=%s"
local thumbnailUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?format=Png&isCircular=false&size=48x48&userIds=%s"

local function rbxHttpGet(url, cookie)
    return (request or syn.request)({Method = "GET", Url = url, Headers = {Cookie = cookie}}).Body
end

local function getServers(placeId, startIndex, cookie)
    if cookie and #cookie > 0 then
        return game:GetService("HttpService"):JSONDecode(rbxHttpGet(serverUrl:format(placeId, startIndex), cookie)).Collection
    else
        warn("need cookie")
    end
end

local function getAvatarHeadshot(userId)
	return game:GetService("HttpService"):JSONDecode(rbxHttpGet(thumbnailUrl:format(userId))).data[1].imageUrl
end

local function findPlayer(placeId, userId, cookie)
	local thumb = getAvatarHeadshot(userId)
	local index = 0
	while true do
		for _, server in next, getServers(placeId, index, cookie) do
			for _, player in next, server.CurrentPlayers do
				if player.Thumbnail.Url == thumb then
					return server.Guid
				end
			end
		end
		index = index + 10
	end
end

return findPlayer