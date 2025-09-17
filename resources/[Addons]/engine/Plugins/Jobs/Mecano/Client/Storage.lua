mecanoStorage = Shared.Storage:Register("Mecano")
mecanoStorage:Set("custom_menu", RageUI.AddMenu("", "Catégories"))
mecanoStorage:Set("bill_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Facture"))
mecanoStorage:Set("brake_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Freins"))

mecanoStorage:Set("bumper_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Pare-chocs"))
mecanoStorage:Set("bumper_menu_front", RageUI.AddSubMenu(mecanoStorage:Get("bumper_menu"), "", "Pare-chocs avant"))
mecanoStorage:Set("bumper_menu_back", RageUI.AddSubMenu(mecanoStorage:Get("bumper_menu"), "", "Pare-chocs arrière"))

mecanoStorage:Set("chassis_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Chassis"))
mecanoStorage:Set("engine_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Réglages du moteur"))
mecanoStorage:Set("exhaust_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Échappements"))
mecanoStorage:Set("grill_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Calandres"))
mecanoStorage:Set("hood_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Capots"))
mecanoStorage:Set("fender_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Ailes"))
mecanoStorage:Set("mirror_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Rétroviseurs"))
mecanoStorage:Set("horn_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Klaxons"))

mecanoStorage:Set("lights_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Phares"))
mecanoStorage:Set("xenon_menu", RageUI.AddSubMenu(mecanoStorage:Get("lights_menu"), "", "Phares"))

mecanoStorage:Set("neon_menu", RageUI.AddSubMenu(mecanoStorage:Get("lights_menu"), "", "Couleur néon"))
mecanoStorage:Set("neon_support_menu", RageUI.AddSubMenu(mecanoStorage:Get("neon_menu"), "", "Support néon"))
mecanoStorage:Set("neon_color_menu", RageUI.AddSubMenu(mecanoStorage:Get("neon_menu"), "", "Couleur néon"))

mecanoStorage:Set("pattern_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Motifs"))
mecanoStorage:Set("plate_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Plaques"))

mecanoStorage:Set("painting_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Peintures"))
mecanoStorage:Set("primary_color_menu", RageUI.AddSubMenu(mecanoStorage:Get("painting_menu"), "", "Couleur principale"))

mecanoStorage:Set("primary_color_menu_classic", RageUI.AddSubMenu(mecanoStorage:Get("primary_color_menu"), "", "Couleur principale"))
mecanoStorage:Set("primary_color_menu_mat", RageUI.AddSubMenu(mecanoStorage:Get("primary_color_menu"), "", "Couleur principale"))
mecanoStorage:Set("primary_color_menu_metallic", RageUI.AddSubMenu(mecanoStorage:Get("primary_color_menu"), "", "Couleur principale"))
mecanoStorage:Set("primary_color_menu_metals", RageUI.AddSubMenu(mecanoStorage:Get("primary_color_menu"), "", "Couleur principale"))
mecanoStorage:Set("primary_color_menu_pearl", RageUI.AddSubMenu(mecanoStorage:Get("primary_color_menu"), "", "Couleur principale"))

mecanoStorage:Set("secondary_color_menu", RageUI.AddSubMenu(mecanoStorage:Get("painting_menu"), "", "Couleur secondaire"))
mecanoStorage:Set("secondary_color_menu_classic", RageUI.AddSubMenu(mecanoStorage:Get("secondary_color_menu"), "", "Couleur secondaire"))
mecanoStorage:Set("secondary_color_menu_mat", RageUI.AddSubMenu(mecanoStorage:Get("secondary_color_menu"), "", "Couleur secondaire"))
mecanoStorage:Set("secondary_color_menu_metallic", RageUI.AddSubMenu(mecanoStorage:Get("secondary_color_menu"), "", "Couleur secondaire"))
mecanoStorage:Set("secondary_color_menu_metals", RageUI.AddSubMenu(mecanoStorage:Get("secondary_color_menu"), "", "Couleur secondaire"))
mecanoStorage:Set("secondary_color_menu_pearl", RageUI.AddSubMenu(mecanoStorage:Get("secondary_color_menu"), "", "Couleur secondaire"))

mecanoStorage:Set("finishing_color_menu", RageUI.AddSubMenu(mecanoStorage:Get("painting_menu"), "", "Couleur finitions"))

mecanoStorage:Set("roof_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Toits"))
mecanoStorage:Set("underbody_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Bas de caisses"))
mecanoStorage:Set("spoiler_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Ailerons"))
mecanoStorage:Set("suspension_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Suspensions"))
mecanoStorage:Set("transmission_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Transmissions"))
mecanoStorage:Set("turbo_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Turbo"))
mecanoStorage:Set("wheels_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Roues"))

mecanoStorage:Set("wheels_type_menu", RageUI.AddSubMenu(mecanoStorage:Get("wheels_menu"), "", "Type de roue"))
mecanoStorage:Set("wheels_type_menu_high", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Haut de gamme"))
mecanoStorage:Set("wheels_type_menu_lowrider", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Lowrider"))
mecanoStorage:Set("wheels_type_menu_muscle", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Muscle car"))
mecanoStorage:Set("wheels_type_menu_offroad", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Tout-terrain"))
mecanoStorage:Set("wheels_type_menu_sport", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Sport"))
mecanoStorage:Set("wheels_type_menu_suv", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "SUV"))
mecanoStorage:Set("wheels_type_menu_tunning", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Tunning"))
mecanoStorage:Set("wheels_type_menu_street", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "De rue"))
mecanoStorage:Set("wheels_type_menu_track", RageUI.AddSubMenu(mecanoStorage:Get("wheels_type_menu"), "", "Circuit"))

mecanoStorage:Set("wheels_color_menu", RageUI.AddSubMenu(mecanoStorage:Get("wheels_menu"), "", "Couleur des roues"))
mecanoStorage:Set("wheels_fume_menu", RageUI.AddSubMenu(mecanoStorage:Get("wheels_menu"), "", "Fumée des pneus"))

mecanoStorage:Set("window_menu", RageUI.AddSubMenu(mecanoStorage:Get("custom_menu"), "", "Vitres"))

mecanoStorage:Set("cloak_menu", RageUI.AddMenu("", "Vestiaire"))
mecanoStorage:Set("take_outfit_menu", RageUI.AddSubMenu(mecanoStorage:Get("cloak_menu"), "", "Prendre une tenue"))
mecanoStorage:Set("remove_outfit_menu", RageUI.AddSubMenu(mecanoStorage:Get("cloak_menu"), "", "Retirer une tenue"))

mecanoStorage:Set("craft_menu", RageUI.AddMenu("", "Fabrication"))
