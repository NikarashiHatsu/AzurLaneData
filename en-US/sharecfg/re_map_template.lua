pg = pg or {}
pg.re_map_template = {
	{
		activity_type = 1,
		name = "红染常驻复刻",
		memory_group = 108,
		id = 1,
		bg = "temp_hongran",
		config_data = {
			2100001,
			2100002,
			2100003,
			2100004,
			2100005,
			2100006,
			2100011,
			2100012,
			2100013,
			2100014,
			2100015,
			2100016
		},
		time = {
			timer,
			{
				{
					2018,
					9,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					12,
					31
				},
				{
					23,
					59,
					59
				}
			}
		}
	},
	[7] = {
		activity_type = 1,
		name = "坠落之翼常驻复刻",
		memory_group = 115,
		id = 7,
		bg = "temp_zhuiluo",
		config_data = {
			2100061,
			2100062,
			2100063,
			2100064,
			2100065,
			2100066,
			2100071,
			2100072,
			2100073,
			2100074,
			2100075,
			2100076
		},
		time = {
			timer,
			{
				{
					2020,
					4,
					9
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					12,
					31
				},
				{
					23,
					59,
					59
				}
			}
		}
	},
	all = {
		1,
		7
	}
}

return
