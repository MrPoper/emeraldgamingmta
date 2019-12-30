--[[
 _____                         _     _   _____                 _
|  ___|                       | |   | | |  __ \               (_)
| |__ _ __ ___   ___ _ __ __ _| | __| | | |  \/ __ _ _ __ ___  _ _ __   __ _
|  __| '_ ` _ \ / _ \ '__/ _` | |/ _` | | | __ / _` | '_ ` _ \| | '_ \ / _` |
| |__| | | | | |  __/ | | (_| | | (_| | | |_\ \ (_| | | | | | | | | | | (_| |
\____/_| |_| |_|\___|_|  \__,_|_|\__,_|  \____/\__,_|_| |_| |_|_|_| |_|\__, |
																		__/ |
																	   |___/
______ _____ _      ___________ _       _____   __
| ___ \  _  | |    |  ___| ___ \ |     / _ \ \ / /
| |_/ / | | | |    | |__ | |_/ / |    / /_\ \ V /
|    /| | | | |    |  __||  __/| |    |  _  |\ /
| |\ \\ \_/ / |____| |___| |   | |____| | | || |
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

-- Main chat handler for default MTA chat.
local mysql = exports.mysql
local global = exports.global

function getPlayerLastPoints(id)
    local player = mysql:Query("SELECT * FROM `accounts_history` WHERE `account`='".. id .."'")
    return player[#player]["points"] or 0
end
function addhistory(his,thePlayer,targetPlayer,theReason)
    local accountID = getElementData(targetPlayer, "account:id")
    local issuer = getElementData(thePlayer, "account:id")
    local addPoint = getPlayerLastPoints(accountID)+1
    if his == "kick" then
        mysql:Execute([[INSERT INTO `accounts_history` SET
            `account`=]]..accountID..[[ ,
            `date_issued`=']]..global:getCurrentTime()[3]..[[',	
            `length`= 1,
            `points`= ]].. addPoint .. [[ ,
            `reason`=']].. theReason ..[[',
            `issuer`=]].. issuer 
        )
    elseif his == "warn" then
        mysql:Execute([[INSERT INTO `accounts_history` SET
            `account`=]]..accountID..[[ ,
            `date_issued`=']]..global:getCurrentTime()[3]..[[',	
            `length`= 2,
            `points`= ]].. addPoint .. [[ ,
            `reason`=']].. theReason ..[[',
            `issuer`=]].. issuer 
        )
    end
end
addEvent("admin:sendhistory",true)
addEventHandler("admin:sendhistory",root,addhistory)

