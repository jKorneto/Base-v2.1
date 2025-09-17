---@type InteractContext
InteractContext = Class.new(function(class)
    ---@class InteractContext: BaseObject
    local self = class
    local menu_list = {}
    local ped_menu = ContextUI:CreateMenu(1, "")
    local vehicle_menu = ContextUI:CreateMenu(2, "")
    local object_menu = ContextUI:CreateMenu(3, "")
    
    function self:Constructor()
        Shared:Initialized("Game.InteractContext")
        self:CreateMenu()
    end

    function self:CreateMenu()
        local activeSubMenus = {}
        local subMenuParent = nil
        local menuStack = {}
    
        local function renderMenu(menu)
            ContextUI:IsVisible(menu, function(Entity)
                for i = 1, #menu_list do
                    local item = menu_list[i]
    
                    if ((item.menuType == menu and not item.isSubMenu and Shared.Table:SizeOf(activeSubMenus) == 0)
                        or (Shared.Table:SizeOf(activeSubMenus) > 0 and item.isSubMenu and activeSubMenus[item.parent] and Shared.Table:TableContains(activeSubMenus[item.parent], item.id))) then
    
                        if (item.submenuActive and item.submenu == nil) then
                            item.submenu = ContextUI:CreateSubMenu(subMenuParent and subMenuParent or item.menuType)
                        end
    
                        if (not item.condition or item.condition(Entity)) then
                            ContextUI:Button(item.title, item.subtitle, function(onSelected)
                                if (onSelected) then
                                    if (#item.subMenuId > 0) then
                                        table.insert(menuStack, { currentMenu = menu, parentMenu = subMenuParent, activeSubMenus = activeSubMenus })
                                    end
    
                                    item.action(onSelected, Entity)
    
                                    if (item.submenuActive and item.submenu) then
                                        if (item.subMenuId and #item.subMenuId > 0) then
                                            if (activeSubMenus[item.id] == nil) then
                                                activeSubMenus = {}
                                            end
                                            activeSubMenus[item.id] = item.subMenuId
                                            subMenuParent = item.submenu
                                            renderMenu(item.submenu)
                                        else
                                            activeSubMenus[item.id] = nil
                                            renderMenu(item.menuType)
                                        end
                                    end
                                end
                            end, item.submenuActive and item.submenu or nil)
                        end
                    end
                end
            end, function()
                if #menuStack > 0 then
                    local previousState = table.remove(menuStack)
                    subMenuParent = previousState.parentMenu
                    activeSubMenus = previousState.activeSubMenus
                    renderMenu(previousState.currentMenu)
                else
                    menuStack = {}
                    activeSubMenus = {}
                    subMenuParent = nil
                    renderMenu(ped_menu)
                    renderMenu(vehicle_menu)
                    renderMenu(object_menu)
                end
            end, function()
                menuStack = {}
                activeSubMenus = {}
                subMenuParent = nil
                renderMenu(ped_menu)
                renderMenu(vehicle_menu)
                renderMenu(object_menu)
            end)
        end
    
        renderMenu(ped_menu)
        renderMenu(vehicle_menu)
        renderMenu(object_menu)
    end    

    function self:findId(uid)
        for i = 1, #menu_list do
            if (menu_list[i].id == uid) then
                return i
            end
        end

        return nil
    end

    function self:findbyType(menuType)
        if (menuType == "ped_menu") then
            return ped_menu
        elseif (menuType == "vehicle_menu") then
            return vehicle_menu
        elseif (menuType == "object_menu") then
            return object_menu
        end

        return nil
    end

    function self:AddButton(menuType, title, subtitle, action, condition)
        local id = Shared:Uuid("xxxx-4xxx-xxxx")

        table.insert(menu_list, {
            id = id,
            menuType = self:findbyType(menuType),
            title = title,
            subtitle = subtitle,
            action = action,
            isSubMenu = false,
            submenuActive = nil,
            submenu = nil,
            subMenuId = {},
            subMenuParent = nil,
            condition = condition,
        })

        return id
    end

    function self:AddSubMenu(parent, title, subtitle, action, condition)
        local parentID = self:findId(parent)
        if (menu_list[parentID]) then
            local id = Shared:Uuid("xxxx-4xxx-xxxx")

            menu_list[parentID].submenuActive = true
            table.insert(menu_list[parentID].subMenuId, id)

            table.insert(menu_list, {
                id = id,
                menuType = menu_list[parentID].menuType,
                parent = parent,
                title = title,
                subtitle = subtitle,
                action = action,
                isSubMenu = true,
                submenuActive = nil,
                submenu = nil,
                subMenuId = {},
                subMenuParent = nil,
                condition = condition,
            })

            return id
        end
    end

    function self:RemoveButton(button)
        local id = self:findId(button)
        if (id) then
            table.remove(menu_list, id)
        end
    end

    return self
end)
