slot0 = class("EventProxy", import(".NetProxy"))

function slot0.register(slot0)
	slot0.eventList = {}

	slot0:on(13002, function (slot0)
		uv0.maxFleetNums = slot0.max_team

		uv0:updateInfo(slot0.collection_list)
	end)
	slot0:on(13011, function (slot0)
		for slot4, slot5 in ipairs(slot0.collection) do
			slot6 = EventInfo.New(slot5)
			slot7, slot8 = uv0:findInfoById(slot5.id)

			if slot8 == -1 then
				table.insert(uv0.eventList, slot6)

				uv0.eventForMsg = slot6
			else
				uv0.eventList[slot8] = slot6
			end
		end

		uv0.virgin = true

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		uv0.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
	end)

	slot0.timer = Timer.New(function ()
		uv0:updateTime()
	end, 1, -1)

	slot0.timer:Start()
end

function slot0.remove(slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

function slot0.updateInfo(slot0, slot1)
	slot0.eventList = {}

	for slot5, slot6 in ipairs(slot1) do
		table.insert(slot0.eventList, EventInfo.New(slot6))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	slot0.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function slot0.updateNightInfo(slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		table.insert(slot0.eventList, EventInfo.New(slot6))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	slot0.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function slot0.getActiveShipIds(slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.eventList) do
		if slot6.state ~= EventInfo.StateNone then
			for slot10, slot11 in ipairs(slot6.shipIds) do
				table.insert(slot1, slot11)
			end
		end
	end

	return slot1
end

function slot0.findInfoById(slot0, slot1)
	for slot5, slot6 in ipairs(slot0.eventList) do
		if slot6.id == slot1 then
			return slot6, slot5
		end
	end

	return nil, -1
end

function slot0.countByState(slot0, slot1)
	for slot6, slot7 in ipairs(slot0.eventList) do
		if slot7.state == slot1 then
			slot2 = 0 + 1
		end
	end

	return slot2
end

function slot0.hasFinishState(slot0)
	if slot0:countByState(EventInfo.StateFinish) > 0 then
		return true
	end
end

function slot0.countBusyFleetNums(slot0)
	for slot5, slot6 in ipairs(slot0.eventList) do
		if slot6.state ~= EventInfo.StateNone then
			slot1 = 0 + 1
		end
	end

	return slot1
end

function slot0.updateTime(slot0)
	slot1 = false

	for slot5, slot6 in pairs(slot0.eventList) do
		if slot6:updateTime() then
			slot1 = true
		end
	end

	if slot1 then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		slot0:sendNotification(GAME.EVENT_LIST_UPDATE)
	end
end

function slot0.getEventList(slot0)
	return Clone(slot0.eventList)
end

function slot0.getActiveEvents(slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.eventList) do
		if pg.TimeMgr.GetInstance():GetServerTime() <= slot6.finishTime then
			table.insert(slot1, slot6)
		end
	end

	return slot1
end

function slot0.fillRecommendShip(slot0, slot1)
	for slot7, slot8 in ipairs(getProxy(BayProxy):getDelegationRecommendShips(slot1)) do
		table.insert(slot1.shipIds, slot8)
	end
end

function slot0.checkNightEvent(slot0)
	return (pg.gameset.night_collection_begin.key_value <= pg.TimeMgr.GetInstance():GetServerHour() and slot1 < 24 or slot1 >= 0 and slot1 < pg.gameset.night_collection_end.key_value) and not _.any(slot0.eventList, function (slot0)
		slot1 = slot0:GetCountDownTime()

		return slot0.template.type == EventConst.EVENT_TYPE_NIGHT and (not slot1 or slot1 > 0)
	end)
end

return slot0
