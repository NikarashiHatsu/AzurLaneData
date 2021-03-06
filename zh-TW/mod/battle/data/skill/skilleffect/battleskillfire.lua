ys = ys or {}
slot0 = ys
slot1 = slot0.Battle.BattleDataFunction
slot2 = class("BattleSkillFire", slot0.Battle.BattleSkillEffect)
slot0.Battle.BattleSkillFire = slot2
slot2.__name = "BattleSkillFire"

function slot2.Ctor(slot0, slot1)
	uv0.super.Ctor(slot0, slot1, lv)

	slot0._weaponID = slot0._tempData.arg_list.weapon_id
	slot0._emitter = slot0._tempData.arg_list.emitter
	slot0._useSkin = slot0._tempData.arg_list.useSkin
end

function slot2.SetWeaponSkin(slot0, slot1)
	slot0._modelID = slot1
end

function slot2.DoDataEffect(slot0, slot1, slot2)
	slot0._weapon = uv0.Battle.BattleDataFunction.CreateWeaponUnit(slot0._weaponID, slot1)

	if slot0._modelID then
		slot3:SetModelID(slot0._modelID)
	elseif slot0._useSkin and slot1:GetPriorityWeaponSkin() then
		slot3:SetModelID(uv1.GetEquipSkin(slot4))
	end

	slot1:DispatchEvent(uv0.Event.New(uv0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, {
		weapon = slot3
	}))
	slot3:updateMovementInfo()
	slot3:SingleFire(slot2, slot0._emitter)
end

function slot2.DoDataEffectWithoutTarget(slot0, slot1)
	slot0:DoDataEffect(slot1)
end

function slot2.Clear(slot0)
	uv0.super.Clear(slot0)

	if slot0._weapon then
		slot0._weapon:Clear()
	end
end
