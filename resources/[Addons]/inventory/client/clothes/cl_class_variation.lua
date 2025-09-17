---@class C_Variation
---@field id number
---@field last { drawable:number; texture:number; } | nil
---@field emote EmoteTable
---@field variations { [number]: number }
---@field prop boolean
---@field rememberLast boolean
local CVariation = {}
CVariation.__index = CVariation

---@param data { id: number; prop:boolean; rememberLast:boolean; emote: EmoteTable; variations: { [number]: number } }
CVariation.new = function(data)
    local self = setmetatable({}, CVariation)

    self.id = data.id
    self.emote = data.emote
    self.rememberLast = data.rememberLast
    self.prop = data.prop
    self.last = nil
    self.variations = data.variations

    return self
end

---@return { drawable: number; texture: number; }
function CVariation:GetCurrentDrawableAndTexture()
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

function CVariation:IsVariationAvailable()
    local current = self:GetCurrentDrawableAndTexture()
    local sex = ScriptClient.Clothes:GetSex()

    if not sex then return end

    if self.last then
        return true
    end

    local selectedVariations = self.variations[sex]
    if not selectedVariations then return end

    for k, v in pairs(selectedVariations) do
        if k == current.drawable then
            return true
        end
    end
end

function CVariation:ChangeVariation()
    if ScriptClient.Clothes.cooldown then return end
    local localPed = PlayerPedId()
    local current = self:GetCurrentDrawableAndTexture()

    local sex = ScriptClient.Clothes:GetSex()
    if not sex then return end

    local selectedVariations = self.variations[sex]
    if not selectedVariations then return end

    if not self.rememberLast then
        for k, v in pairs(selectedVariations) do
            if k == current.drawable then
                ScriptClient.Clothes:PlayEmote(
                    self.emote.dict,
                    self.emote.anim,
                    self.emote.flag,
                    self.emote.time,
                    function ()
                        if self.prop then
                            if DoesEntityExist(ScriptClient.PedScreen.ped) then
                                SetPedPropIndex(ScriptClient.PedScreen.ped, self.id, v, current.texture, 1)
                            end
                            SetPedPropIndex(localPed, self.id, v, current.texture, 1)
                        else
                            if DoesEntityExist(ScriptClient.PedScreen.ped) then
                                SetPedComponentVariation(ScriptClient.PedScreen.ped, self.id, v, current.texture, 0)
                            end
                            SetPedComponentVariation(localPed, self.id, v, current.texture, 0)
                        end
                    end
                )
                break
            end
        end
    else
        if not self.last then
            for k, v in pairs(selectedVariations) do
                if k == current.drawable then
                    ScriptClient.Clothes:PlayEmote(
                        self.emote.dict,
                        self.emote.anim,
                        self.emote.flag,
                        self.emote.time,
                        function ()
                            if self.prop then
                                if DoesEntityExist(ScriptClient.PedScreen.ped) then
                                    SetPedPropIndex(ScriptClient.PedScreen.ped, self.id, v, current.texture, 1)
                                end
                                SetPedPropIndex(localPed, self.id, v, current.texture, 1)
                            else
                                if DoesEntityExist(ScriptClient.PedScreen.ped) then
                                    SetPedComponentVariation(ScriptClient.PedScreen.ped, self.id, v, current.texture, 0)
                                end
                                SetPedComponentVariation(localPed, self.id, v, current.texture, 0)
                            end

                            self.last = current
                        end
                    )
                    break
                end
            end
        else
            ScriptClient.Clothes:PlayEmote(
                self.emote.dict,
                self.emote.anim,
                self.emote.flag,
                self.emote.time,
                function ()
                    if self.prop then
                        if DoesEntityExist(ScriptClient.PedScreen.ped) then
                            SetPedPropIndex(ScriptClient.PedScreen.ped, self.id, self.last.drawable, self.last.texture, 1)
                        end
                        SetPedPropIndex(localPed, self.id, self.last.drawable, self.last.texture, 1)
                    else
                        if DoesEntityExist(ScriptClient.PedScreen.ped) then
                            SetPedComponentVariation(ScriptClient.PedScreen.ped, self.id, self.last.drawable, self.last.texture, 0)
                        end
                        SetPedComponentVariation(localPed, self.id, self.last.drawable, self.last.texture, 0)
                    end

                    self.last = nil
                end
            )
        end
    end
end

RegisterNUICallback("CHANGE_VARIATION", function(data, cb)
    local id = data.id
    local prop = data.prop

    for k, v in pairs(ScriptClient.Clothes.Variations) do
        if v.id == id and v.prop == prop then
            v:ChangeVariation()
            break
        end
    end
    cb({})
end)

ScriptClient.Clothes.Variations = {
    Visor = CVariation.new({
        prop = true,
        id = 0,
        emote = {
            dict = "mp_masks@standard_car@ds@",
            anim = "put_on_mask",
            flag = 51,
            time = 600
        },
        variations = Variations.Visor
    }),
    Hair = CVariation.new({
        id = 2,
        emote = {
            dict = "clothingtie",
            anim = "check_out_a",
            flag = 51,
            time = 2000
        },
        variations = Variations.Hair,
        rememberLast = true
    }),
    Gloves = CVariation.new({
        id = 3,
        emote = {
            dict = "nmt_3_rcm-10",
            anim = "cs_nigel_dual-10",
            flag = 51,
            time = 1200
        },
        variations = Variations.Gloves,
        rememberLast = true
    }),
    Bag = CVariation.new({
        id = 5,
        emote = {
            dict = "anim@heists@ornate_bank@grab_cash",
            anim = "intro",
            flag = 51,
            time = 1600
        },
        variations = Variations.Bag
    }),
    Top = CVariation.new({
        id = 11,
        emote = {
            dict = "missmic4",
            anim = "michael_tux_fidget",
            flag = 51,
            time = 1500
        },
        variations = Variations.Top
    })
}