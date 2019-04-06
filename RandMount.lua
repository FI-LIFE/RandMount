SLASH_RM1 = "/rm"
SlashCmdList["RM"] = function(msg)
    local ids, list = C_MountJournal.GetMountIDs(), {};

    list['ground'] = {};
    list['flying'] = {};
    list['water'] = {};
    list['other'] = {};

    for key, mountID in pairs(ids) do
        local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction,
        hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID);

        if (isUsable and isCollected) then
            local creatureDisplayID, descriptionText, sourceText, isSelfMount, mountType,
            uiModelScene = C_MountJournal.GetMountInfoExtraByID(mountID);

            if (mountType == 230) then
                table.insert(list['ground'], mountID);
            elseif (mountType == 231 or mountType == 232 or mountType == 269 or mountType == 254) then
                table.insert(list['water'], mountID);
            elseif (mountType == 248 or mountType == 247) then
                table.insert(list['flying'], mountID);
            elseif (mountType == 284) then
                table.insert(list['other'], mountID);
            end
        end
    end

    local canFly = IsFlyableArea();
    local haveGroundSkill = false;
    local haveFlySkill = false;
    local isSwimming = IsSwimming();

    local riding_data = {33388,33391,34090,34091,90265}
    local riding_skill = 0

    for i=#riding_data, 1, -1 do
        if IsSpellKnown(riding_data[i]) then
            riding_skill = 75*i
            break
        end
    end

    if (riding_skill >= 75) then
        haveGroundSkill = true;
        if (riding_skill >= 225) then
            haveFlySkill = true;
        end
    end

    if isSwimming then
        C_MountJournal.SummonByID(list['water'][math.random(1,#list['water'])])
    elseif (canFly and haveFlySkill) then
            C_MountJournal.SummonByID(list['flying'][math.random(1,#list['flying'])])
    elseif (haveGroundSkill) then
        C_MountJournal.SummonByID(list['ground'][math.random(1,#list['ground'])])
    else
        C_MountJournal.SummonByID(list['other'][math.random(1,#list['other'])])
    end
end
