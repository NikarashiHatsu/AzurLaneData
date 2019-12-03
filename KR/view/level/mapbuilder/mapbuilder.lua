slot0 = class("MapBuilder")
slot0.TYPENORMAL = 1
slot0.TYPEESCORT = 2
slot0.TYPESKIRMISH = 3
slot0.StateCtor = 1
slot0.StateLoading = 2
slot0.StateInit = 3
slot0.StateShow = 4
slot0.StateBlocked = 5
slot0.StateDestroy = 6

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.tfParent = slot1
	slot0.sceneParent = slot2
	slot0.map = slot1:Find("map")
	slot0.float = slot1:Find("float")
	slot0.state = slot0.StateCtor
	slot0.tweens = {}
	slot0.mapWidth = 1920
	slot0.mapHeight = 1440
end

slot0.InvokeParent = function (slot0, slot1, ...)
	if slot0.sceneParent[slot1] then
		return slot2(slot0.sceneParent, ...)
	end
end

slot0.GetUIName = function (slot0)
	return ""
end

slot0.GetType = function (slot0)
	return
end

slot0.Load = function (slot0, slot1)
	PoolMgr.GetInstance():GetUI(slot0:GetUIName(), true, function (slot0)
		slot0.name = slot0:GetUIName()
		slot0.tf = tf(slot0)

		if slot0.state < slot1.StateBlocked then
			slot0:Init()
			slot0()
		elseif slot0.state < slot1.StateDestroy then
			slot0:Init()
		else
			PoolMgr.GetInstance:ReturnUI(slot0:GetUIName(), slot0)
		end
	end)

	slot0.state = slot0.StateLoading
end

slot0.Init = function (slot0)
	if slot0.StateDestroy <= slot0.state then
		return
	end

	slot0.tf:SetParent(slot0.float, false)
	slot0:OnInit()

	slot0.state = slot0.StateInit
end

slot0.OnInit = function (slot0)
	return
end

slot0.Destroy = function (slot0)
	if slot0.StateDestroy <= slot0.state then
		return
	end

	if slot0.StateInit <= slot0.state then
		slot0:Hide()
		slot0:OnDestroy()

		slot0.tweens = nil

		PoolMgr.GetInstance:ReturnUI(slot0:GetUIName(), go(slot0.tf))
	end

	slot0.state = slot0.StateDestroy
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	if slot0.StateDestroy <= slot0.state then
		return
	end

	if slot0.StateInit <= slot0.state then
		setActive(slot0.tf, true)
		slot0:OnShow()
	end

	slot0.state = slot0.StateShow
end

slot0.OnShow = function (slot0)
	return
end

slot0.Hide = function (slot0)
	if slot0.StateDestroy <= slot0.state then
		return
	end

	if slot0.StateInit <= slot0.state then
		slot0:OnHide()

		for slot4, slot5 in pairs(slot0.tweens) do
			LeanTween.cancel(slot5)
		end

		slot0.tweens = {}

		setActive(slot0.tf, false)
	end

	slot0.state = slot0.StateBlocked
end

slot0.OnHide = function (slot0)
	return
end

slot0.Update = function (slot0, slot1)
	slot0.data = slot1
end

slot0.UpdateMapItems = function (slot0)
	slot0:Show()
end

slot0.RecordTween = function (slot0, slot1, slot2)
	slot0.tweens[slot1] = slot2
end

slot0.DeleteTween = function (slot0, slot1)
	if slot0.tweens[slot1] then
		LeanTween.cancel(slot2)

		slot0.tweens[slot1] = nil
	end
end

return slot0
