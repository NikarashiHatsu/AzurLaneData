return {
	uiEffect = "",
	name = "",
	cd = 0,
	picture = "1",
	desc = "爱碳光波",
	painting = 1,
	id = 104012,
	castCV = "skill",
	aniEffect = {
		effect = "jineng",
		offset = {
			0,
			-2,
			0
		}
	},
	effect_list = {
		{
			targetAniEffect = "",
			casterAniEffect = "",
			type = "BattleSkillAddBuff",
			target_choise = "TargetAllHarm",
			arg_list = {
				buff_id = 104013,
				delay = 1
			}
		}
	}
}
