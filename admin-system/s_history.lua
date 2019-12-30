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

