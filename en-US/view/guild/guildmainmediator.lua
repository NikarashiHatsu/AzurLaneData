slot0 = class("GuildMainMediator", import("..base.ContextMediator"))
slot0.OPEN_MEMBER = "GuildMainMediator:OPEN_MEMBER"
slot0.CLOSE_MEMBER = "GuildMainMediator:CLOSE_MEMBER"
slot0.OPEN_APPLY = "GuildMainMediator:OPEN_APPLY"
slot0.CLOSE_APPLY = "GuildMainMediator:CLOSE_APPLY"
slot0.MODIFY = "GuildMainMediator:MODIFY"
slot0.DISSOLVE = "GuildMainMediator:DISSOLVE"
slot0.QUIT = "GuildMainMediator:QUIT"
slot0.ON_BACK = "GuildMainMediator:ON_BACK"
slot0.REBUILD_ALL = "GuildMainMediator:REBUILD_ALL"
slot0.ON_REBUILD_LOG_ALL = "GuildMainMediator:ON_REBUILD_LOG_ALL"
slot0.SEND_MSG = "GuildMainMediator:SEND_MSG"
slot0.OPEN_BOSS_ACTIVITY = "GuildMainMediator:OPEN_BOSS_ACTIVITY"
slot0.CLOSE_BOSS_ACTIVITY = "GuildMainMediator:CLOSE_BOSS_ACTIVITY"
slot0.OPEN_ACTIVITY = "GuildMainMediator:OPEN_ACTIVITY"
slot0.CLOSE_ACTIVITY = "GuildMainMediator:CLOSE_ACTIVITY"
slot0.OPEN_SHOP = "GuildMainMediator:OPEN_SHOP"
slot0.CLOSE_SHOP = "GuildMainMediator:CLOSE_SHOP"
slot0.OPEN_FACILITY = "GuildMainMediator:OPEN_FACILITY"
slot0.CLOSE_FACILITY = "GuildMainMediator:CLOSE_FACILITY"
slot0.OPEN_EMOJI = "GuildMainMediator:OPEN_EMOJI"

function slot0.register(slot0)
	slot1 = getProxy(GuildProxy)

	slot0.viewComponent:setGuildVO(slot1:getData())
	slot0.viewComponent:setChatMsgs(slot1:getChatMsgs())
	slot0.viewComponent:setPlayerVO(getProxy(PlayerProxy):getData())

	if not slot1:getGuildEvent(true) then
		slot0:sendNotification(GAME.GET_GUILD_EVENT)
	else
		slot0.viewComponent:setGuildEvent(slot6)
	end

	slot0:bind(uv0.OPEN_FACILITY, function (slot0, slot1)
		uv0:addSubLayers(Context.New({
			viewComponent = GuildFacilityLayer,
			mediator = GuildFacilityMediator,
			data = slot1 or {}
		}))
	end)
	slot0:bind(uv0.CLOSE_FACILITY, function (slot0)
		uv0:closePage(GuildFacilityMediator)
	end)
	slot0:bind(uv0.ON_BACK, function (slot0)
		if getProxy(ContextProxy):getContextByMediator(MainUIMediator):getContextByMediator(NewGuildMediator) then
			slot2:removeChild(slot3)
		end

		uv0:sendNotification(GAME.GO_BACK)
	end)
	slot0:bind(uv0.REBUILD_ALL, function (slot0)
		uv0.viewComponent:updateAllChat(getProxy(GuildProxy):getChatMsgs())
	end)
	slot0:bind(uv0.OPEN_MEMBER, function ()
		uv0:addSubLayers(Context.New({
			viewComponent = GuildMemberLayer,
			mediator = GuildMemberMediator
		}))
	end)
	slot0:bind(uv0.CLOSE_MEMBER, function ()
		uv0:closePage(GuildMemberMediator)
	end)
	slot0:bind(uv0.OPEN_APPLY, function ()
		uv0:addSubLayers(Context.New({
			viewComponent = GuildRequestLayer,
			mediator = GuildRequestMediator
		}))
	end)
	slot0:bind(uv0.CLOSE_APPLY, function ()
		uv0:closePage(GuildRequestMediator)
	end)
	slot0:bind(uv0.OPEN_BOSS_ACTIVITY, function (slot0, slot1)
		GuildEventLayer.UI_TYPE = slot1

		uv0:addSubLayers(Context.New({
			viewComponent = GuildEventLayer,
			mediator = GuildEventMediator
		}))
	end)
	slot0:bind(uv0.CLOSE_BOSS_ACTIVITY, function (slot0)
		uv0:closePage(GuildEventMediator)
	end)
	slot0:bind(uv0.OPEN_ACTIVITY, function (slot0, slot1)
		print("todo open")
	end)
	slot0:bind(uv0.CLOSE_ACTIVITY, function (slot0, slot1)
		print("todo close")
	end)
	slot0:bind(uv0.MODIFY, function (slot0, slot1, slot2, slot3)
		uv0:sendNotification(GAME.MODIFY_GUILD_INFO, {
			type = slot1,
			int = slot2,
			string = slot3
		})
	end)
	slot0:bind(uv0.DISSOLVE, function (slot0, slot1)
		uv0:sendNotification(GAME.GUILD_DISSOLVE, slot1)
	end)
	slot0:bind(uv0.QUIT, function (slot0, slot1)
		uv0:sendNotification(GAME.GUILD_QUIT, slot1)
	end)
	slot0:bind(uv0.ON_REBUILD_LOG_ALL, function (slot0)
		uv0.viewComponent:updateAllLog(getProxy(GuildProxy):getData():getLogs())
	end)
	slot0:bind(uv0.SEND_MSG, function (slot0, slot1)
		uv0:sendNotification(GAME.GUILD_SEND_MSG, slot1)
	end)
	slot0:bind(uv0.OPEN_SHOP, function (slot0)
		print("todo open")
	end)
	slot0:bind(uv0.CLOSE_SHOP, function (slot0)
		print("todo close")
	end)
	slot0:bind(uv0.OPEN_EMOJI, function (slot0, slot1, slot2)
		uv0:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				pos = slot1,
				callback = slot2,
				emojiIconCallback = function (slot0)
					uv0.viewComponent:insertEmojiToInputText(slot0)
				end
			}
		}))
	end)

	if slot2:getDutyByMemberId(slot5.id) == GuildMember.DUTY_COMMANDER or slot7 == GuildMember.DUTY_DEPUTY_COMMANDER then
		slot0.viewComponent:updateNotices(slot1:isNoticesApply())
	end
end

function slot0.closePage(slot0, slot1)
	if getProxy(ContextProxy):getContextByMediator(slot1) then
		slot0:sendNotification(GAME.REMOVE_LAYERS, {
			context = slot3
		})
	end
end

function slot0.listNotificationInterests(slot0)
	return {
		GuildProxy.GUILD_UPDATED,
		GuildProxy.EXIT_GUILD,
		GAME.MODIFY_GUILD_INFO_DONE,
		GuildProxy.NEW_MSG_ADDED,
		GuildProxy.LOG_ADDED,
		GuildProxy.REQUEST_COUNT_UPDATED,
		GuildProxy.REQUEST_DELETED,
		GAME.GUILD_GET_REQUEST_LIST_DONE,
		GAME.REMOVE_LAYERS,
		GuildProxy.ADDED_EVENT,
		GAME.BOSS_EVENT_START_DONE,
		PlayerProxy.UPDATED
	}
end

function slot0.handleNotification(slot0, slot1)
	if slot1:getName() == GuildProxy.GUILD_UPDATED then
		slot0.viewComponent:setGuildVO(slot1:getBody())
		slot0.viewComponent:initTheme()
	elseif slot2 == GuildProxy.EXIT_GUILD then
		slot0.viewComponent:emit(uv0.ON_BACK)
	elseif slot2 == GAME.MODIFY_GUILD_INFO_DONE then
		slot0.viewComponent:closeModifyPanel()
		slot0.viewComponent:updateBg()
	elseif slot2 == GuildProxy.NEW_MSG_ADDED then
		slot0.viewComponent:append(slot3, -1, true)
	elseif slot2 == GuildProxy.LOG_ADDED then
		slot0.viewComponent:appendLog(slot3, true)
	elseif slot2 == GuildProxy.REQUEST_COUNT_UPDATED or slot2 == GuildProxy.REQUEST_DELETED or slot2 == GAME.GUILD_GET_REQUEST_LIST_DONE then
		slot0.viewComponent:updateNotices(getProxy(GuildProxy):isNoticesApply())
	elseif slot2 == GuildProxy.ADDED_EVENT then
		slot0.viewComponent:setGuildEvent(slot3)
		slot0.viewComponent:updateEventBtn()
	elseif slot2 == GAME.BOSS_EVENT_START_DONE then
		if not slot0.viewComponent.guildEvent then
			slot0:sendNotification(GAME.GET_GUILD_EVENT)
		end
	elseif slot2 == PlayerProxy.UPDATED then
		slot0.viewComponent:setPlayerVO(slot3)
	end
end

return slot0
