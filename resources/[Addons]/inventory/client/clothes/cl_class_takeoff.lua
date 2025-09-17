---@class C_Clothes
---@field id number
---@field last { id:number; drawable:number; texture:number; }[] | nil
---@field emoteOn EmoteTable
---@field emoteOff EmoteTable
---@field prop boolean
---@field empty { male:number; female:number; }
---@field extra? { id: number; drawable: number; texture:number; }[]
local CTakeoff = {}
CTakeoff.__index = CTakeoff

local function ResyncNUI()
    local tbl = {}
    for k, v in pairs(ScriptClient.Clothes.Takeoffable) do
        tbl[#tbl + 1] = {
            id = v.id,
            prop = v.prop,
            isWeared = v:IsWeared()
        }
    end

    local varis = {}
    for k, v in pairs(ScriptClient.Clothes.Variations) do
        varis[#varis + 1] = {
            id = v.id,
            prop = v.prop,
            isAvailable = v:IsVariationAvailable()
        }
    end

    SEND_NUI_MESSAGE({
        event = "SET_VARIATIONS",
        table = varis
    })

    SEND_NUI_MESSAGE({
        event = "SET_TAKEOFFABLE",
        table = tbl
    })
end

---@param data { id:number; emoteOn: EmoteTable; empty: { male:number; female: number; }; emoteOff: EmoteTable; prop: boolean; extra?: { id:number; drawable:number; texture:number; }[] }
CTakeoff.new = function(data)
    local self = setmetatable({}, CTakeoff)

    self.id = data.id
    self.emoteOn = data.emoteOn
    self.emoteOff = data.emoteOff
    self.prop = data.prop
    self.last = nil
    self.extra = data.extra
    self.empty = data.empty

    return self
end

---@return { drawable: number; texture: number; }
function CTakeoff:GetCurrentDrawableAndTexture()
    local localPed = PlayerPedId()

    if self.prop then
        return {
            drawable = GetPedPropIndex(localPed, self.id),
            texture = GetPedPropTextureIndex(localPed, self.id)
        }
    else

        return {
            drawable = GetPedDrawableVariation(localPed, self.id),
            texture = GetPedTextureVariation(localPed, self.id)
        }
    end
end

function CTakeoff:IsWeared()
    local sex = ScriptClient.Clothes:GetSex()
    if not sex then return end

    local drawable = self.empty[sex]
    if type(drawable) ~= "table" then return end

    local current = self:GetCurrentDrawableAndTexture()

    if current.drawable ~= drawable[1] then
        self.last = nil
        return true
    end


    self.last = {id = self.id, drawable = drawable[1], texture = current.texture}
end

function CTakeoff:Wear()
    if ScriptClient.Clothes.cooldown then return end
    if not self.last then return end

    local localPed = PlayerPedId()

    ScriptClient.Clothes:PlayEmote(
        self.emoteOn.dict,
        self.emoteOn.anim,
        self.emoteOn.flag,
        self.emoteOn.time,
        function()
            if self.prop then
                for k, v in pairs(self.last) do
                    if DoesEntityExist(ScriptClient.PedScreen.ped) then
                        SetPedPropIndex(ScriptClient.PedScreen.ped, v.id, v.drawable, v.texture, 1)
                    end
                    SetPedPropIndex(localPed, v.id, v.drawable, v.texture, 1)
                end
            else
                for k, v in pairs(self.last) do
                    if DoesEntityExist(ScriptClient.PedScreen.ped) then
                        SetPedComponentVariation(ScriptClient.PedScreen.ped, v.id, v.drawable, v.texture, 0)
                    end
                    SetPedComponentVariation(localPed, v.id, v.drawable, v.texture, 0)
                end
            end

            ResyncNUI()
            self.last = nil
        end
    )
end

function CTakeoff:TakeOff()
    if ScriptClient.Clothes.cooldown then return end
    if self.last then return end
    local localPed = PlayerPedId()

    local sex = ScriptClient.Clothes:GetSex()
    if not sex then return end

    local drawable = self.empty[sex]
    if type(drawable) ~= "table" then return end

    local current = self:GetCurrentDrawableAndTexture()

    if (self.id == 4) then
        local underpants = exports["engine"]:getUnderpants()

        if (underpants) then
            if (underpants.texture == nil or underpants.variant == nil) then
                for key, value in pairs(underpants) do
                    drawable[1] = value.texture
                    drawable[2] = value.variant
                end
            else
                drawable[1] = underpants.texture
                drawable[2] = underpants.variant
            end
        end
    end

    if drawable ~= current.drawable then
        ScriptClient.Clothes:PlayEmote(
            self.emoteOff.dict,
            self.emoteOff.anim,
            self.emoteOff.flag,
            self.emoteOff.time,
            function()
                local saveLasts = {
                    { id = self.id, drawable = current.drawable, texture = current.texture }
                }

                if self.prop then
                    if DoesEntityExist(ScriptClient.PedScreen.ped) then
                        ClearPedProp(ScriptClient.PedScreen.ped, self.id)
                    end
                    ClearPedProp(localPed, self.id)
                else
                    if DoesEntityExist(ScriptClient.PedScreen.ped) then
                        SetPedComponentVariation(ScriptClient.PedScreen.ped, self.id, drawable[1], drawable[2], 0)
                    end
                    SetPedComponentVariation(localPed, self.id, drawable[1], drawable[2], 0)
                end

                if self.extra then
                    for k, v in pairs(self.extra) do
                        if self.prop then
                            saveLasts[#saveLasts + 1] = {
                                id = v.id,
                                drawable = GetPedPropIndex(localPed, v.id),
                                texture = GetPedPropTextureIndex(localPed, v.id)
                            }
                            if DoesEntityExist(ScriptClient.PedScreen.ped) then
                                ClearPedProp(localPed, self.id)
                            end
                            ClearPedProp(localPed, self.id)
                        else
                            saveLasts[#saveLasts + 1] = {
                                id = v.id,
                                drawable = GetPedDrawableVariation(localPed, v.id),
                                texture = GetPedTextureVariation(localPed, v.id)
                            }
                            if DoesEntityExist(ScriptClient.PedScreen.ped) then
                                SetPedComponentVariation(ScriptClient.PedScreen.ped, v.id, v.drawable, v.texture, 0)
                            end
                            SetPedComponentVariation(localPed, v.id, v.drawable, v.texture, 0)
                        end
                    end
                end

                ResyncNUI()
                self.last = saveLasts
            end
        )
    end
end

ScriptClient.Clothes.Takeoffable = {
    Mask = CTakeoff.new({
        id = 1,
        empty = {
            male = {0, 0},
            female = {0, 0},
        },
        emoteOn = {
            dict = "mp_masks@standard_car@ds@",
            anim = "put_on_mask",
            flag = 51,
            time = 800
        },
        emoteOff = {
            dict = "mp_masks@standard_car@ds@",
            anim = "put_on_mask",
            flag = 51,
            time = 800
        }
    }),
    Pants = CTakeoff.new({
        id = 4,
        empty = {
            male = {61, 0},
            female = {14, 0}
        },
        emoteOn = {
            dict = "re@construction",
            anim = "out_of_breath",
            flag = 51,
            time = 1300
        },
        emoteOff = {
            dict = "re@construction",
            anim = "out_of_breath",
            flag = 51,
            time = 1300
        }
    }),
    Bag = CTakeoff.new({
        id = 5,
        empty = {
            male = {0, 0},
            female = {0, 0}
        },
        emoteOn = {
            dict = "anim@heists@ornate_bank@grab_cash",
            anim = "intro",
            flag = 51,
            time = 1600
        },
        emoteOff = {
            dict = "anim@heists@ornate_bank@grab_cash",
            anim = "intro",
            flag = 51,
            time = 1600
        }
    }),
    Shoes = CTakeoff.new({
        id = 6,
        empty = {
            male = {34, 0},
            female = {35, 0}
        },
        emoteOn = {
            dict = "random@domestic",
            anim = "pickup_low",
            flag = 0,
            time = 1200
        },
        emoteOff = {
            dict = "random@domestic",
            anim = "pickup_low",
            flag = 0,
            time = 1200
        }
    }),
    Accessories = CTakeoff.new({
        id = 7,
        empty = {
            male = {0, 0},
            female = {0, 0}
        },
        emoteOn = {
            dict = "clothingtie",
            anim = "try_tie_positive_a",
            flag = 51,
            time = 2100
        },
        emoteOff = {
            dict = "clothingtie",
            anim = "try_tie_positive_a",
            flag = 51,
            time = 2100
        }
    }),
    Armour = CTakeoff.new({
        id = 9,
        empty = {
            male = {0, 0},
            female = {0, 0}
        },
        emoteOn = {
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            flag = 51,
            time = 1200
        },
        emoteOff = {
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            flag = 51,
            time = 1200
        }
    }),
    Decals = CTakeoff.new({
        id = 10,
        empty = {
            male = {0, 0},
            female = {0, 0}
        },
        emoteOn = {
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            flag = 51,
            time = 1200
        },
        emoteOff = {
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            flag = 51,
            time = 1200
        }
    }),
    Top = CTakeoff.new({
        id = 11,
        empty = {
            male = {252, 0},
            female = {74, 0}
        },
        emoteOn = {
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            flag = 51,
            time = 1200
        },
        emoteOff = {
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            flag = 51,
            time = 1200
        },
        extra = {
            { id = 8,  drawable = 15, texture = 0 },
            { id = 3,  drawable = 15, texture = 0 },
            { id = 10, drawable = 0,  texture = 0 }
        }
    }),
    Hat = CTakeoff.new({
        prop = true,
        id = 0,
        empty = {
            male = {-1, 0},
            female = {-1, 0}
        },
        emoteOn = {
            dict = "mp_masks@standard_car@ds@",
            anim = "put_on_mask",
            flag = 51,
            time = 600
        },
        emoteOff = {
            dict = "missheist_agency2ahelmet",
            anim = "take_off_helmet_stand",
            flag = 51,
            time = 1200
        }
    }),
    Glasses = CTakeoff.new({
        prop = true,
        id = 1,
        empty = {
            male = {0, 0},
            female = {-1, 0}
        },
        emoteOn = {
            dict = "clothingspecs",
            anim = "take_off",
            flag = 51,
            time = 1400
        },
        emoteOff = {
            dict = "clothingspecs",
            anim = "take_off",
            flag = 51,
            time = 1400
        }
    }),
    Earrings = CTakeoff.new({
        prop = true,
        id = 2,
        empty = {
            male = {-1, 0},
            female = {-1, 0}
        },
        emoteOn = {
            dict = "mp_cp_stolen_tut",
            anim = "b_think",
            flag = 51,
            time = 900
        },
        emoteOff = {
            dict = "mp_cp_stolen_tut",
            anim = "b_think",
            flag = 51,
            time = 900
        }
    }),
    Watch = CTakeoff.new({
        prop = true,
        id = 6,
        empty = {
            male = {-1, 0},
            female = {-1, 0}
        },
        emoteOn = {
            dict = "nmt_3_rcm-10",
            anim = "cs_nigel_dual-10",
            flag = 51,
            time = 1200
        },
        emoteOff = {
            dict = "nmt_3_rcm-10",
            anim = "cs_nigel_dual-10",
            flag = 51,
            time = 1200
        }
    }),
    Bracelet = CTakeoff.new({
        prop = true,
        id = 7,
        empty = {
            male = {-1, 0},
            female = {-1, 0}
        },
        emoteOn = {
            dict = "nmt_3_rcm-10",
            anim = "cs_nigel_dual-10",
            flag = 51,
            time = 1200
        },
        emoteOff = {
            dict = "nmt_3_rcm-10",
            anim = "cs_nigel_dual-10",
            flag = 51,
            time = 1200
        }
    })
}

RegisterNUICallback("WEAR_DRESS", function(data, cb)
    local id = data.id
    local prop = data.prop

    for k, v in pairs(ScriptClient.Clothes.Takeoffable) do
        if v.id == id and v.prop == prop then
            v:Wear()
            break
        end
    end
    cb({})
end)

RegisterNUICallback("TAKE_OFF_DRESS", function(data, cb)
    local id = data.id
    local prop = data.prop
    for k, v in pairs(ScriptClient.Clothes.Takeoffable) do
        if v.id == id and v.prop == prop then
            v:TakeOff()
            break
        end
    end
    cb({})
end)

exports("wearDress", function(data)
    local id = data.id
    local drawable = data.drawable
    local texture = data.texture
    local prop = data.prop

    if prop then
        if DoesEntityExist(ScriptClient.PedScreen.ped) then
            SetPedPropIndex(ScriptClient.PedScreen.ped, id, drawable, texture, 1)
        end
    else
        if DoesEntityExist(ScriptClient.PedScreen.ped) then
            SetPedComponentVariation(ScriptClient.PedScreen.ped, id, drawable, texture, 0)
        end
    end

    ResyncNUI()
end)

AddEventHandler("inventory:onInventoryOpen", function()
    ResyncNUI()
end)
