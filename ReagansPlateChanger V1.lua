-- Reagan's Plate Changer V1
-- Thank you for using my Plate Changer, i hope it works perfectly for you but if you do ever have to make changes
-- I would love it if you contacted me on Discord so I could know about the issue, even if its just user preference.
-- 
-- Instructions for writing Custom Plates
-- 1. Max of 8 characters (including spaces)
-- 2. Each one MUST be in qoutes ( " " )
-- 3. There Must be a comma ( , ) after each choice, except the last.
--
--
-- User Writeable Plates
local USERPLATES = {
    "WRITE", "US", "IN LUA", "AT THE", "TOP"
}

-- Star Wars themed plates categorized by aspects
local starWarsCharacterPlates = {
    "YODA 1", "VADER", "LUKE SKY", "LEIA ORG", "KENOBI", "R2 D2", "C3 PO",
    "BOBAFET", "JABBA", "CHEWBACA", "REY4CE", "KYLO REN", "SITHLOR",
    "JEDI KNT", "MAUL", "GRIEVS", "PADME", "MANDO", "ASHOKA", "TARKIN",
    "WICKET", "LANDO", "HAN SOLO", "QUI GON", "FINN"
}

local starWarsShipPlates = {
    "FALCON", "X WING", "TIE FGHT", "SLAVE 1", "ROGUE", "ST DEST", "TANTIVE",
    "NABOO", "EXECUTR", "CORVET", "INTRCPT", "VENATOR", "DEFSATL", "SIDIOUS",
    "GHOST", "ARCLGHT", "BWING", "AWING", "UWING", "JEDSTAR", "TIEBOMB",
    "TIEADV", "SITHINF", "REBEL", "IMPERIAL"
}

-- GTA themed plates categorized by game titles
local gtaViceCityPlates = {
    "VICE CTY", "TOMMY V", "LANCE", "VERCETI", "DIAZ", "MALIBU", "CUBANS",
    "BIKER", "LUVFIST", "CORTZ", "RICARDO", "KENROSE", "MERCENY", "PHILCAS",
    "BANKJOB", "YATCHT", "V ROCK", "FEVER", "WILDSTY", "BANDSIX", "GOLF CRT",
    "CHEETAH", "SABRETT", "STINGER", "HOTRING"
}

local gtaSanAndreasPlates = {
    "GROVE ST", "CJ 1992", "BIGSMOKE", "SWEET", "RYDER", "OG LOC", "KENDL",
    "CESAR", "ZER0", "TRUTH", "WUZIMU", "AZTECA", "BALLAS", "VAGOS", "NITRO",
    "BURGLRY", "HYDRA", "TANK", "BMXBIKE", "LOWRIDER", "JETPACK", "CASINO",
    "HEIST", "TRIBOSS", "CJ MOM", "K DST", "K ROSE", "BUSTA"
}

local gtaIVPlates = {
    "NIKO B", "ROMAN", "LIBERTY", "VLAD", "DIMITRI", "PACKIE", "FAUSTIN",
    "BELLECI", "DARDAN", "RAY B", "PEGORIN", "ULPC", "LILJACOB", "BULGARN",
    "GAMBETI", "GRACIE", "IVAN", "KIKI", "LYLE", "MALLORI", "MANNY", "PHIL B",
    "PLAYBOY", "RICKY", "VLAD M"
}

local gtaVPlates = {
    "LSANTOS", "TREVOR", "FRANKLN", "MICHAEL", "LAMAR", "CHOP", "TRACEY",
    "JIMMY", "LESTER", "DEVIN", "AMANDA", "FIB", "HEIST", "VINEWD", "BALLAD",
    "GROVE", "DELPRRO", "LS CSTM", "ECLIPSE", "HAO", "SIMION", "OMEGA",
    "TONYA", "HANGER", "YACHT"
}

-- Pop Culture themed plates categorized by different games
local gameCharacterPlates = {
    "MARIO", "SONIC", "LARA C", "MASTCHF", "KIRBY", "PEEK A", "LINK", "ZELDA",
    "DKONG", "CLOUD", "SNAKE", "SAMUS", "POKEMON", "KRATOS", "MEGAMAN",
    "EARTHBD", "SIMCITY", "BOMBRMN", "TETRIS", "GORDON", "ALTAIR", "EZIO",
    "LEE", "CLEMENT", "NATHAN", "MEGATRON", "OPTIMUS"
}

local gameVehiclePlates = {
    "KART", "WARTHOG", "GHST RDR", "P WAGON", "VIPER", "BAT MBL", "KITT",
    "GEN LEE", "OPTIMUS", "GADGETV", "HERBIE", "A TEAM", "PEACEMKR", "ECTO1",
    "MILANO", "ELEANOR", "AKIRA", "NCC1707", "MACH 5", "MAXIMUS", "SERENITY",
    "NOSTROMO", "MCQUEEN", "MATER", "KARR", "MCFLY", "BEAUTY"
}

-- Function to update the license plate text
local function updateLicensePlateText(plateText)
    local vehicle = localplayer:get_current_vehicle()
    if vehicle then
        vehicle:set_number_plate_text(plateText)
    else
    end
end

----------------------------------- Speedometer -- Section -----------------------------------
speeds = {}                           -- List to hold past speed values
maxDataPoints = 5                     -- Number of past data points to consider for weighted moving average
local speedometerActive = false       -- Set default to False
local speedMode = {
    kph = 3.6,
    mph = 2.23694,
    current = 3.6 -- default to kph mode conversion value
}

-- Function to get the current speed of the vehicle
local function getCurrentSpeed(veh)
    local velocity = veh:get_velocity()
    local speedms = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
    return speedms
end

local function SetKPH()
    speedMode.current = speedMode.kph
end

local function setMPH()
    speedMode.current = speedMode.mph
end

-- Function to get the weighted average from the list of speeds
local function getWeightedAverage(t)
    local weightedSum = 0
    local totalWeights = 0

    for i, v in ipairs(t) do
        weightedSum = weightedSum + v * i
        totalWeights = totalWeights + i
    end

    return weightedSum / totalWeights
end

-- Function to start the speedometer
local function startSpeedometer()
    speedometerActive = true
    while speedometerActive do
        if localplayer and localplayer:is_in_vehicle() then
            local veh = localplayer:get_current_vehicle()
            local currentSpeed = getCurrentSpeed(veh)
            table.insert(speeds, currentSpeed)
            if #speeds > maxDataPoints then
                table.remove(speeds, 1)  -- Remove the oldest speed value
            end
            local predictedSpeed = getWeightedAverage(speeds)
            local displayedSpeed = math.floor(predictedSpeed * speedMode.current)
            veh:set_number_plate_text(tostring(displayedSpeed))
            sleep(0.01)
        end
    end
end

-- Dummy Function For Text Only Buttons
local function dummy()
    print("no secrets lay ahead")
end

-- Function to stop the speedometer
local function stopSpeedometer()
    speedometerActive = false
end
-------------------------------------- Menu -- Building --------------------------------------

-- Main menu
local PlateMenu = menu.add_submenu("Reagans Plate Changer V1")
PlateMenu:add_action("---------------Welcome to---------------", dummy)
PlateMenu:add_action("------Don Reagans Plate Changer V1---", dummy)
PlateMenu:add_action("-------------------------------------------", dummy)
PlateMenu:add_action("----------Please buckle up and---------", dummy)
PlateMenu:add_action("-----------------ALWAYS-----------------", dummy)
PlateMenu:add_action("-------Obey the laws of the roads------", dummy)
PlateMenu:add_action("-------------------------------------------", dummy)
PlateMenu:add_action("Turn OFF speedo to set a custom plate", dummy)
PlateMenu:add_action("-------------------------------------------", dummy)
PlateMenu:add_action("", dummy)
PlateMenu:add_action("", dummy)

-- Submenus
local Speedomenu = PlateMenu:add_submenu("Speedometer")
local starWarsMenu = PlateMenu:add_submenu("Star Wars Plates")
local gtaMenu = PlateMenu:add_submenu("GTA Plates")
local popCultureMenu = PlateMenu:add_submenu("Pop Culture Plates")
PlateMenu:add_action("", dummy)
PlateMenu:add_action("", dummy)
local helpmenu = PlateMenu:add_submenu("HELP AND INFO")
local reaganMenu = PlateMenu:add_submenu("Made by Don Reagan")

-- STAR WARS Categories 
starWarsMenu:add_array_item("Characters", starWarsCharacterPlates, function() end, function(value) updateLicensePlateText(starWarsCharacterPlates[value]) end)
starWarsMenu:add_array_item("Ships", starWarsShipPlates, function() end, function(value) updateLicensePlateText(starWarsShipPlates[value]) end)

-- GTA Categories 
gtaMenu:add_array_item("V", gtaVPlates, function() end, function(value) updateLicensePlateText(gtaVPlates[value]) end)
gtaMenu:add_array_item("Vice City", gtaViceCityPlates, function() end, function(value) updateLicensePlateText(gtaViceCityPlates[value]) end)
gtaMenu:add_array_item("San Andreas", gtaSanAndreasPlates, function() end, function(value) updateLicensePlateText(gtaSanAndreasPlates[value]) end)
gtaMenu:add_array_item("IV", gtaIVPlates, function() end, function(value) updateLicensePlateText(gtaIVPlates[value]) end)

-- Pop Culture Categories 
popCultureMenu:add_array_item("Game Characters", gameCharacterPlates, function() end, function(value) updateLicensePlateText(gameCharacterPlates[value]) end)
popCultureMenu:add_array_item("Game Vehicles", gameVehiclePlates, function() end, function(value) updateLicensePlateText(gameVehiclePlates[value]) end)
popCultureMenu:add_array_item("USER PLATES", USERPLATES, function () end, function(value) updateLicensePlateText(USERPLATES[value]) end)
popCultureMenu:add_action("", dummy)
popCultureMenu:add_action("", dummy)
popCultureMenu:add_action("Write your own plates by opening this", dummy)
popCultureMenu:add_action("Lua file in a word or note app and", dummy)
popCultureMenu:add_action("writing what you want in the area at the", dummy)
popCultureMenu:add_action("top of the script. Dont worry though,", dummy)
popCultureMenu:add_action("Further instructions will be there.", dummy)
-- Speedometer submenu
Speedomenu:add_action("Set KPH", SetKPH)
Speedomenu:add_action("Set MPH", setMPH)
Speedomenu:add_action("Start Speedometer", startSpeedometer)
Speedomenu:add_action("Stop Speedometer (Hold)", stopSpeedometer)

-- HELP AND INFO SECTION
helpmenu:add_action("If you find a bug or need help", dummy)
helpmenu:add_action("please contact me on discord at", dummy)
helpmenu:add_action("          ronnie.r.1989        ", dummy)

-- Reagan Menu
reaganMenu:add_action("Well hello there Friend", dummy)
reaganMenu:add_action("Enjoy These Reagan Qoutes", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Trust, but verify", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Honor's a calling...", dummy)
reaganMenu:add_action("...answer it with courage", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Live simply, love generously", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Speak kindly, always", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("We can't help everyone...", dummy)
reaganMenu:add_action("...but everyone can help", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Be a good neighbor", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Cherish freedom, even here", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Family is our cornerstone", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Peace is handling conflict...", dummy)
reaganMenu:add_action("...with calm in San Andreas", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Enjoy the open road of life", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Good inside comes from outside", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The future belongs to the brave", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Stand tall, cruise on top", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Life's grand, start the music", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Stay hopeful, stay strong", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Leave some things unsaid...", dummy)
reaganMenu:add_action("...hear more by listening", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Freedom is one generation away", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Preserve it with action", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Take time to do what's right", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Let's make freedom ring", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Keep faith in democracy", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Be the change in Liberty City", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Embrace challenge, grow strong", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Every day, a chance to improve", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Your choices define you", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The game's not over till it ends", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Dare to be great, even in GTA", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Make memories, live fully", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Chase dreams, not just missions", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Liberty's light never dims", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("With freedom, drive forward", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The best is yet to drive", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("In GTA, choose the high road", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Character is one's destiny", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Stay strong and clear-minded", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Your liberty is your loyalty", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Conquer with character", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Dream big, drive bigger", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Kindness is strength", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Justice is truth in action", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Navigate life with compassion", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Freedom is driving spirit", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Cultivate peace, harvest harmony", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Honesty is the soul's GPS", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Make every mission matter", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Be the hero of your story", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Drive your story with honor", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Adventure awaits the brave", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Gratitude is the heart's memory", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Generosity wins more than races", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Wisdom is the map of life", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Choose words as you choose roads", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Every end is a new beginning", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The road less traveled rewards", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Drive the path of integrity", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("True victory is in valor", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Lead with love, win with wisdom", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Honor the past, drive the future", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Optimism is the fuel of heroes", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Share the road, share the joy", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("A good citizen respects all", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Responsibility is the key", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("To drive is to explore life", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The road to truth is straight", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Unity is strength in San Andreas", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Every turn can be right", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("A smile is your best defense", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Respect wins more than races", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Be a beacon of hope", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Let's drive to a brighter future", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Your will is the wheel", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Patience is the compass", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("A giving hand steers hearts", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Your journey is unique", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("In GTA, set your own pace", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Liberty is in the journey", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Strength lies in patience", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("In unity, find power", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The brave create their paths", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Change lanes towards kindness", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Drive with purpose and pride", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Take the wheel of your fate", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Find beauty in every road", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Be a pillar of the community", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Empathy is the journey's reward", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Lead by example, even in GTA", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("A calm mind drives straight", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Every mission is a lesson", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Let's build bridges, not walls", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Unity is our strongest ally", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Steer clear of negativity", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("With respect, we all win", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Forge your path with honor", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("A clear conscience drives best", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("In GTA, be the good guy", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Justice never goes out of style", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Drive away from hate", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Create peace on these streets", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("Be the leader Los Santos needs", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("The best drivers are the kindest", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("With courage, tackle any road", dummy)
reaganMenu:add_action("", dummy)
reaganMenu:add_action("In GTA, make Reagan proud", dummy)
