return {
	time = 0,
	name = "测试-声望-主炮额外一轮攻击2",
	init_effect = "",
	picture = "",
	desc = "触发:主炮额外一轮攻击2",
	stack = 1,
	id = 60032,
	icon = 60032,
	last_effect = "lingxing",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				skill_id = 60018,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onChargeWeaponBulletCreate"
			},
			arg_list = {
				buff_id = 60031,
				bulletTrigger = "onBulletKill",
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCancelBuff",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				count = 1,
				delay = 3
			}
		}
	}
}
