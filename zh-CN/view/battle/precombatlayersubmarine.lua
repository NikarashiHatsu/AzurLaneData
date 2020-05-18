slot0 = class("PreCombatLayerSubmarine", import(".PreCombatLayer"))
slot1 = import("..ship.FormationUI")
slot0.FORM_EDIT = "EDIT"
slot0.FORM_PREVIEW = "PREVIEW"

function slot0.getUIName(slot0)
	return "PreCombatUI"
end

function slot0.init(slot0)
	uv0.super.init(slot0)

	slot1 = slot0:findTF("middle")

	SetActive(slot1:Find("mask/grid_bg"), false)
	SetActive(slot0._gridFrame, false)
	SetActive(slot1:Find("gear_score/main"), false)
	SetActive(slot1:Find("gear_score/vanguard"), false)

	slot6 = "gear_score/submarine"

	SetActive(slot1:Find(slot6), true)

	slot0._subFrame = slot1:Find("mask/bg_sub")

	SetActive(slot0._subFrame, true)

	slot0._gridTFs = {
		[TeamType.Submarine] = {}
	}

	for slot6 = 1, 3 do
		slot0._gridTFs[TeamType.Submarine][slot6] = slot0._subFrame:Find("submarine_" .. slot6)
	end
end

function slot0.SetFleets(slot0, slot1)
	slot0._fleetVOs = {}
	slot0._fleetIDList = {}

	_.each(_.filter(_.values(slot1), function (slot0)
		return slot0:getFleetType() == FleetType.Submarine
	end), function (slot0)
		if #slot0.ships > 0 then
			uv0._fleetVOs[slot0.id] = slot0

			table.insert(uv0._fleetIDList, slot0.id)

			uv1 = uv1 + 1
		end
	end)

	if 0 == 0 then
		slot0._fleetVOs[11] = slot2[1]

		table.insert(slot0._fleetIDList, 11)
	else
		table.sort(slot0._fleetIDList, function (slot0, slot1)
			return slot0 < slot1
		end)
	end
end

function slot0.SetCurrentFleet(slot0, slot1)
	slot0._currentFleetVO = slot0._fleetVOs[slot1 or slot0._fleetIDList[1]]
end

function slot0.UpdateFleetView(slot0, slot1)
	slot0:displayFleetInfo()
	slot0:resetGrid(TeamType.Submarine)

	if slot1 then
		slot0:loadAllCharacter()
	else
		slot0:setAllCharacterPos(true)
	end
end

function slot0.didEnter(slot0)
	onButton(slot0, slot0._backBtn, function ()
		if uv0._currentForm == uv1.FORM_EDIT and uv0._editedFlag then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				zIndex = -100,
				content = i18n("battle_preCombatLayer_save_confirm"),
				onYes = function ()
					uv0:emit(PreCombatMediator.ON_COMMIT_EDIT, function ()
						pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))

						GetOrAddComponent(uv0._tf, typeof(CanvasGroup)).interactable = false

						uv0:uiExitAnimating()
						LeanTween.delayedCall(0.3, System.Action(function ()
							uv0:emit(uv1.ON_CLOSE)
						end))
					end)
				end,
				onNo = function ()
					uv0:emit(PreCombatMediator.ON_ABORT_EDIT)

					GetOrAddComponent(uv0._tf, typeof(CanvasGroup)).interactable = false

					uv0:uiExitAnimating()
					LeanTween.delayedCall(0.3, System.Action(function ()
						uv0:emit(uv1.ON_CLOSE)
					end))
				end
			})
		else
			GetOrAddComponent(uv0._tf, typeof(CanvasGroup)).interactable = false

			uv0:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function ()
				uv0:emit(uv1.ON_CLOSE)
			end))
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0._startBtn, function ()
		if uv0._currentForm == uv1.FORM_EDIT and uv0._editedFlag then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				zIndex = -100,
				content = i18n("battle_preCombatLayer_save_march"),
				onYes = function ()
					uv0:emit(PreCombatMediator.ON_COMMIT_EDIT, function ()
						pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
						uv0:emit(PreCombatMediator.ON_START, uv0._currentFleetVO.id)
					end)
				end
			})
		else
			uv0:emit(PreCombatMediator.ON_START, uv0._currentFleetVO.id)
		end
	end, SFX_UI_WEIGHANCHOR)
	onButton(slot0, slot0._nextPage, function ()
		if uv0:getNextFleetID() then
			uv0:emit(PreCombatMediator.ON_CHANGE_FLEET, slot0, true)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._prevPage, function ()
		if uv0:getPrevFleetID() then
			uv0:emit(PreCombatMediator.ON_CHANGE_FLEET, slot0, true)
		end
	end, SFX_PANEL)
	slot0:UpdateFleetView(true)

	if slot0.contextData.form == uv0.FORM_EDIT then
		slot0._editedFlag = true

		slot0:switchToEditMode()

		if slot0._characterList then
			slot0:enabledTeamCharacter(TeamType.Submarine, true)
		end

		slot0:setAllCharacterPos(false)
	else
		slot0:swtichToPreviewMode()
	end

	slot0.contextData.form = nil

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._autoToggle, false)
	onNextTick(function ()
		uv0:uiStartAnimating()
	end)

	if slot0.contextData.system == SYSTEM_ACT_BOSS then
		PoolMgr.GetInstance():GetUI("al_bg01", true, function (slot0)
			slot0:SetActive(true)
			setParent(slot0, uv0._tf)
			slot0.transform:SetAsFirstSibling()
		end)
	end

	if slot0._currentForm == uv0.FORM_PREVIEW and slot0.contextData.system == SYSTEM_DUEL and #slot0._currentFleetVO.mainShips <= 0 then
		triggerButton(slot0._checkBtn)
	end
end

function slot0.getNextFleetID(slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0._fleetIDList) do
		if slot6 == slot0._currentFleetVO.id then
			slot1 = slot5

			break
		end
	end

	return slot0._fleetIDList[slot1 + 1]
end

function slot0.getPrevFleetID(slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0._fleetIDList) do
		if slot6 == slot0._currentFleetVO.id then
			slot1 = slot5

			break
		end
	end

	return slot0._fleetIDList[slot1 - 1]
end

function slot0.swtichToPreviewMode(slot0)
	slot0._editedFlag = nil
	slot0._currentForm = uv0.FORM_PREVIEW
	slot0._checkBtn:GetComponent("Button").interactable = true

	setActive(slot0._checkBtn:Find("save"), false)
	setActive(slot0._checkBtn:Find("edit"), true)
	slot0:resetGrid(TeamType.Submarine)
	slot0:setAllCharacterPos(false)
	onButton(slot0, slot0._checkBtn, function ()
		uv0:switchToEditMode()

		if uv0._characterList then
			uv0:enabledTeamCharacter(TeamType.Submarine, true)
		end

		uv0:setAllCharacterPos(false)
	end, SFX_PANEL)
	slot0:disableAllStepper()
	slot0:SetFleetStepper()

	if slot0._characterList then
		slot0:enabledTeamCharacter(TeamType.Submarine, false)
	end
end

function slot0.switchToEditMode(slot0)
	slot0._currentForm = uv0.FORM_EDIT
	slot0._checkBtn:GetComponent("Button").interactable = true

	setActive(slot0._checkBtn:Find("save"), true)
	setActive(slot0._checkBtn:Find("edit"), false)
	onButton(slot0, slot0._checkBtn, function ()
		uv0:emit(PreCombatMediator.ON_COMMIT_EDIT, function ()
			if uv0._editedFlag then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
			end

			uv0:swtichToPreviewMode()
		end)
	end, SFX_CONFIRM)
	slot0:EnableAddGrid(TeamType.Submarine)
	function (slot0)
		for slot4, slot5 in ipairs(slot0) do
			if tf(slot5):Find("mouseChild") then
				if slot6:GetComponent("EventTriggerListener") then
					uv0.eventTriggers[slot7] = true

					slot7:RemovePointEnterFunc()
				end

				if slot4 == uv0._shiftIndex then
					slot6:GetComponent(typeof(Image)).enabled = true
				end
			end
		end
	end(slot0._characterList[TeamType.Submarine])

	slot0._shiftIndex = nil

	slot0:disableAllStepper()
end

function slot0.switchToShiftMode(slot0, slot1, slot2)
	slot0:disableAllStepper()

	slot0._checkBtn:GetComponent("Button").interactable = false

	for slot6 = 1, 3 do
		setActive(slot0._gridTFs[TeamType.Submarine][slot6]:Find("tip"), false)
		setActive(slot0._gridTFs[slot2][slot6]:Find("shadow"), false)
	end

	for slot7, slot8 in ipairs(slot0._characterList[slot2]) do
		if slot8 ~= slot1 then
			LeanTween.moveLocalY(go(slot8), slot0._gridTFs[slot2][slot7].localPosition.y + 80, 0.5)

			slot10 = tf(slot8):Find("mouseChild"):GetComponent("EventTriggerListener")
			slot0.eventTriggers[slot10] = true

			slot10:AddPointEnterFunc(function ()
				for slot3, slot4 in ipairs(uv0) do
					if slot4 == uv1 then
						uv2:shift(uv2._shiftIndex, slot3, uv3)

						break
					end
				end
			end)
		else
			slot0._shiftIndex = slot7
			tf(slot8):Find("mouseChild"):GetComponent(typeof(Image)).enabled = false
		end

		slot8:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end
end

function slot0.loadAllCharacter(slot0)
	removeAllChildren(slot0._heroContainer)

	slot0._characterList = {
		[TeamType.Submarine] = {}
	}
	slot0._infoList = {
		[TeamType.Submarine] = {}
	}

	function slot1(slot0, slot1, slot2, slot3)
		slot5 = uv0._shipVOs[slot1]:getConfigTable()

		if uv0.exited then
			PoolMgr.GetInstance():ReturnSpineChar(slot4:getPrefab(), slot0)

			return
		end

		for slot10, slot11 in pairs(slot4:getAttachmentPrefab()) do
			if slot11.attachment_combat_ui[1] ~= "" then
				ResourceMgr.Inst:getAssetAsync("Effect/" .. slot12, slot12, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
					if not uv0.exited then
						slot1 = Object.Instantiate(slot0)
						uv0._attachmentList[#uv0._attachmentList + 1] = slot1

						tf(slot1):SetParent(tf(uv1))

						tf(slot1).localPosition = BuildVector3(uv2.attachment_combat_ui[2])
					end
				end), true, true)
			end
		end

		uv0._characterList[slot2][slot3] = slot0

		tf(slot0):SetParent(uv0._heroContainer, false)

		slot7 = uv0._shipVOs[slot1]
		tf(slot0).localScale = Vector3(0.65, 0.65, 1)

		pg.ViewUtils.SetLayer(tf(slot0), Layer.UI)

		slot0:GetComponent("SkeletonGraphic").raycastTarget = false

		uv0:enabledCharacter(slot0, true, slot7, slot2)
		uv0:setCharacterPos(slot2, slot3, slot0)
		uv0:sortSiblingIndex()

		slot8 = cloneTplTo(uv0._heroInfo, slot0)

		setAnchoredPosition(slot8, {
			x = 0,
			y = 0
		})

		slot8.localScale = Vector3(2, 2, 1)

		SetActive(slot8, true)

		slot8.name = "info"
		slot10 = findTF(findTF(slot8, "info"), "stars")
		slot12 = findTF(slot9, "energy")

		if slot7.energy <= Ship.ENERGY_MID then
			slot13, slot14 = slot7:getEnergyPrint()

			if not GetSpriteFromAtlas("energy", slot13) then
				warning("找不到疲劳")
			end

			setImageSprite(slot12, slot15)
		end

		setActive(slot12, slot11 and uv0.contextData.system ~= SYSTEM_DUEL)

		for slot17 = 1, slot7:getStar() do
			cloneTplTo(uv0._starTpl, slot10)
		end

		if not GetSpriteFromAtlas("shiptype", shipType2print(slot7:getShipType())) then
			warning("找不到船形, shipConfigId: " .. slot7.configId)
		end

		setImageSprite(findTF(slot9, "type"), slot14, true)
		setText(findTF(slot9, "frame/lv_contain/lv"), slot7.level)
		setActive(slot9:Find("expbuff"), getProxy(ActivityProxy):getBuffShipList()[slot7:getGroupId()] ~= nil)

		if slot17 then
			if slot17 % 100 > 0 then
				slot21 = tostring(slot17 / 100) .. "." .. tostring(slot20)
			end

			setText(slot18:Find("text"), string.format("EXP +%s%%", slot21))
		end
	end

	function (slot0, slot1)
		for slot5, slot6 in ipairs(slot0) do
			slot7 = uv0._shipVOs[slot6]:getPrefab()

			table.insert(uv1, function (slot0)
				PoolMgr.GetInstance():GetSpineChar(uv0, true, function (slot0)
					uv0(slot0, uv1, uv2, uv3)
					uv4()
				end)
			end)
		end
	end(slot0._currentFleetVO.subShips, TeamType.Submarine)
	pg.UIMgr.GetInstance():LoadingOn()
	parallelAsync({}, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function slot0.setAllCharacterPos(slot0, slot1)
	for slot5, slot6 in ipairs(slot0._characterList[TeamType.Submarine]) do
		slot0:setCharacterPos(TeamType.Submarine, slot5, slot6, slot1)
	end

	slot0:sortSiblingIndex()
end

function slot0.setCharacterPos(slot0, slot1, slot2, slot3, slot4)
	SetActive(slot3, true)

	slot6 = slot0._gridTFs[slot1][slot2].position

	LeanTween.cancel(go(slot3))

	if slot4 then
		tf(slot3).position = Vector3(slot6.x, slot6.y + 0.9, slot6.z)

		LeanTween.moveY(go(slot3), slot6.y, 0.5):setDelay(0.5)
	else
		tf(slot3).position = Vector3(slot6.x, slot6.y, slot6.z)
	end

	SetActive(slot5:Find("shadow"), true)
	slot3:GetComponent("SpineAnimUI"):SetAction("stand", 0)
end

function slot0.resetGrid(slot0, slot1)
	slot2 = slot0._currentFleetVO:getTeamByName(slot1)

	for slot7, slot8 in ipairs(slot0._gridTFs[slot1]) do
		SetActive(slot8:Find("shadow"), false)
		SetActive(slot8:Find("tip"), false)
	end
end

function slot0.EnableAddGrid(slot0, slot1)
	if #slot0._currentFleetVO:getTeamByName(slot1) < 3 then
		slot6 = slot0._gridTFs[slot1][slot4 + 1]:Find("tip")
		slot6:GetComponent("Button").enabled = true

		onButton(slot0, slot6, function ()
			uv0:emit(PreCombatMediator.CHANGE_FLEET_SHIP, nil, uv0._currentFleetVO, uv1)
		end, SFX_UI_FORMATION_ADD)

		slot6.localScale = Vector3(0, 0, 1)

		SetActive(slot6, true)
		LeanTween.value(go(slot6), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
			uv0.localScale = Vector3(slot0, slot0, 1)
		end)):setEase(LeanTweenType.easeOutBack)
	end
end

function slot0.shift(slot0, slot1, slot2, slot3)
	slot4 = slot0._characterList[slot3]
	slot6 = slot0._currentFleetVO:getTeamByName(slot3)
	slot7 = slot4[slot2]
	slot9 = slot0._gridTFs[slot3][slot1].position
	tf(slot7).position = Vector3(slot9.x, slot9.y + 0.9, slot9.z)

	LeanTween.cancel(go(slot7))

	slot4[slot2] = slot4[slot1]
	slot4[slot1] = slot4[slot2]
	slot6[slot2] = slot6[slot1]
	slot6[slot1] = slot6[slot2]
	slot0._shiftIndex = slot2

	slot0:sortSiblingIndex()
end

function slot0.sortSiblingIndex(slot0)
	slot1 = 3
	slot2 = 0

	while slot1 > 0 do
		if slot0._characterList[TeamType.Submarine][slot1] then
			tf(slot3):SetSiblingIndex(slot2)

			slot2 = slot2 + 1
		end

		slot1 = slot1 - 1
	end
end

function slot0.enabledTeamCharacter(slot0, slot1, slot2)
	for slot8, slot9 in ipairs(slot0._characterList[slot1]) do
		slot0:enabledCharacter(slot9, slot2, slot0._shipVOs[slot0._currentFleetVO:getTeamByName(slot1)[slot8]], slot1)
	end
end

function slot0.enabledCharacter(slot0, slot1, slot2, slot3, slot4)
	if slot2 then
		slot5, slot6, slot7, slot8 = tf(slot1):Find("mouseChild")

		if slot5 then
			SetActive(slot5, true)
		else
			slot5 = GameObject("mouseChild")

			tf(slot5):SetParent(tf(slot1))

			tf(slot5).localPosition = Vector3.zero
			slot6 = GetOrAddComponent(slot5, "ModelDrag")
			slot7 = GetOrAddComponent(slot5, "UILongPressTrigger")
			slot8 = GetOrAddComponent(slot5, "EventTriggerListener")
			slot0.eventTriggers[slot8] = true

			slot6:Init()

			slot9 = slot5:GetComponent(typeof(RectTransform))
			slot9.sizeDelta = Vector2(2.5, 2.5)
			slot9.pivot = Vector2(0.5, 0)
			slot9.anchoredPosition = Vector2(0, 0)
			slot7.longPressThreshold = 1

			pg.DelegateInfo.Add(slot0, slot7.onLongPressed)
			slot7.onLongPressed:AddListener(function ()
				if uv0.contextData.system ~= SYSTEM_HP_SHARE_ACT_BOSS then
					uv0:emit(PreCombatMediator.OPEN_SHIP_INFO, uv1.id, uv0._currentFleetVO)
				end
			end)
			pg.DelegateInfo.Add(slot0, slot6.onModelClick)
			slot6.onModelClick:AddListener(function ()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
				uv0:emit(PreCombatMediator.CHANGE_FLEET_SHIP, uv1, uv0._currentFleetVO, uv2)
			end)
			slot8:AddBeginDragFunc(function ()
				screenWidth = UnityEngine.Screen.width
				screenHeight = UnityEngine.Screen.height
				widthRate = rtf(uv0._tf).rect.width / screenWidth
				heightRate = rtf(uv0._tf).rect.height / screenHeight

				LeanTween.cancel(go(uv1))
				uv0:switchToShiftMode(uv1, uv2)
				uv1:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(uv1):SetParent(uv0._moveLayer, false)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
			end)
			slot8:AddDragFunc(function (slot0, slot1)
				rtf(uv0).anchoredPosition = Vector2((slot1.position.x - screenWidth / 2) * widthRate + 20, (slot1.position.y - screenHeight / 2) * heightRate - 20)
			end)
			slot8:AddDragEndFunc(function (slot0, slot1)
				uv0:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)

				if slot1.position.x > UnityEngine.Screen.width * 0.65 or slot1.position.y < UnityEngine.Screen.height * 0.25 then
					if not uv1._currentFleetVO:canRemove(uv2) then
						slot3, slot4 = uv1._currentFleetVO:getShipPos(uv2)

						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", uv2:getConfigTable().name, uv1._currentFleetVO.name, Fleet.C_TEAM_NAME[slot4]))
						function ()
							tf(uv0):SetParent(uv1._heroContainer, false)
							uv1:emit(PreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, uv1._currentFleetVO)
							uv1:switchToEditMode()
							uv1:sortSiblingIndex()
						end()
					else
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							hideNo = false,
							zIndex = -100,
							content = i18n("battle_preCombatLayer_quest_leaveFleet", uv2:getConfigTable().name),
							onYes = function ()
								for slot4, slot5 in ipairs(uv0._characterList[uv1]) do
									if slot5 == uv2 then
										PoolMgr.GetInstance():ReturnSpineChar(uv3:getPrefab(), uv2)
										table.remove(slot0, slot4)

										break
									end
								end

								uv0:emit(PreCombatMediator.REMOVE_SHIP, uv3, uv0._currentFleetVO)
								uv0:switchToEditMode()
								uv0:sortSiblingIndex()
							end,
							onNo = slot2
						})
					end
				else
					slot2()
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
			end)
		end
	elseif not IsNil(tf(slot1):Find("mouseChild")) then
		setActive(slot5, false)
	end
end

function slot0.displayFleetInfo(slot0)
	slot1 = slot0._currentFleetVO:GetPropertiesSum()

	setActive(slot0._popup, true)
	uv0.tweenNumText(slot0._costText, slot0._currentFleetVO:GetCostSum().oil)
	uv0.tweenNumText(slot0._subGS, slot0._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	setText(slot0._fleetNameText, uv0.defaultFleetName(slot0._currentFleetVO))
	setText(slot0._fleetNumText, slot0._currentFleetVO.id - 10)
end

function slot0.SetFleetStepper(slot0)
	setActive(slot0._nextPage, slot0:getNextFleetID() ~= nil)
	setActive(slot0._prevPage, slot0:getPrevFleetID() ~= nil)
end

function slot0.willExit(slot0)
	if slot0.eventTriggers then
		for slot4, slot5 in pairs(slot0.eventTriggers) do
			ClearEventTrigger(slot4)
		end

		slot0.eventTriggers = nil
	end

	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
	slot0:recycleCharacterList(slot0._currentFleetVO.subShips, slot0._characterList[TeamType.Submarine])

	if slot0._resPanel then
		slot0._resPanel:exit()

		slot0._resPanel = nil
	end

	for slot4, slot5 in ipairs(slot0._attachmentList) do
		Object.Destroy(slot5)
	end

	slot0._attachmentList = nil
end

return slot0
