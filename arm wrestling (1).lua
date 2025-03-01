--// INIT Remote
local LocalPlayer = game:GetService('Players').LocalPlayer
local PlayerStat = LocalPlayer.leaderstats

-- FireServer
local onGuiEquipRequest = game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RE.onGuiEquipRequest
local onEquipRequest = game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RE.onEquipRequest
local onUnequipRequest = game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RE.onUnequipRequest
local onClick = game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RE.onClick
local onEnterNPCTable = game:GetService("ReplicatedStorage").Packages.Knit.Services.ArmWrestleService.RE.onEnterNPCTable
local onClickRequest = game:GetService("ReplicatedStorage").Packages.Knit.Services.ArmWrestleService.RE.onClickRequest
local clickMusicalTile = game:GetService("ReplicatedStorage").Packages.Knit.Services.ArmWrestleService.RE.clickMusicalTile
local onGiveStats = game:GetService("ReplicatedStorage").Packages.Knit.Services.PunchBagService.RE.onGiveStats
local teleport = game:GetService("ReplicatedStorage").Packages.Knit.Services.ZoneService.RE.teleport

-- InvokeServer
local getTradeablePlayers = game:GetService("ReplicatedStorage").Packages.Knit.Services.TradingService.RF.getTradeablePlayers
local ReEquip = game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RF.ReEquip
local playerEquip = game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.playerEquip
local purchaseEgg = game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.purchaseEgg
local getOwned = game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.getOwned
local SetAutoDelete = game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.SetAutoDelete
local ShowTeleport = game:GetService("ReplicatedStorage").Packages.Knit.Services.TeleportService.RF.ShowTeleport
local FightNpc = game:GetService("ReplicatedStorage").Packages.Knit.Services.WrestleRNGService.RF.FightNpc
local OnClickInvoke = game:GetService("ReplicatedStorage").Packages.Knit.Services.WrestleService.RF.OnClick

local CoastingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/source.lua.txt"))()
local MainWindow = CoastingLibrary
local MainTab = MainWindow:CreateTab("Main")
local BattleSection = MainTab:CreateSection("Battle")
local WorldMap = {
    ["School"] = "1",
    ["Space"] = "2",
    ["Beach"] = "3",
    ["Nuclear"] = "4",
    ["Dino World"] = "5",
    ["The Void"] = "6",
    ["Space Center"] = "7",
    ["Roman Empire"] = "8",
    ["The Underworld"] = "9",
    ["Magic Forest"] = "10",
    ["Snowy Peaks"] = "11",
    ["Dusty Tavern"] = "12",
    ["Lost Kingdom"] = "13",
    ["Orc Paradise"] = "14",
    ["Heavenly Island"] = "15",
    ["The Rift"] = "16",
    ["The Matrix"] = "17",
    ["Striker"] = "18"
}

-- Variable
local selectedWorld = nil
local selectedBoss = nil
local worldDropdown = nil
local bossDropdown = nil
local autoFightEnabled = false
local autoClickEnabled = false
local autoFightLoop = nil
local autoClickLoop = nil
local function GetBossesInWorld(worldNumber)
    local bossList = {}
    local worldPath = workspace:WaitForChild("GameObjects"):WaitForChild("ArmWrestling"):WaitForChild(worldNumber)
    local npcFolder = worldPath:WaitForChild("NPC")
    
    for _, npc in pairs(npcFolder:GetChildren()) do
        table.insert(bossList, npc.Name)
    end
    
    return bossList
end

-- Function to battle boss
local function BattleBoss(bossName, worldNumber)
    local args = {
        [1] = bossName,
        [2] = workspace:WaitForChild("GameObjects"):WaitForChild("ArmWrestling"):WaitForChild(worldNumber):WaitForChild("NPC"):WaitForChild(bossName):WaitForChild("Table"),
        [3] = worldNumber
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ArmWrestleService"):WaitForChild("RE"):WaitForChild("onEnterNPCTable"):FireServer(unpack(args))
end

-- Function to perform click
local function PerformClick()
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ArmWrestleService"):WaitForChild("RE"):WaitForChild("onClickRequest"):FireServer()
end

-- Auto fight function
local function StartAutoFight()
    if autoFightLoop then
        autoFightLoop:Disconnect()
    end
    
    autoFightLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if autoFightEnabled and selectedWorld and selectedBoss then
            BattleBoss(selectedBoss, selectedWorld)
            task.wait(0.1) -- Add small delay to prevent overwhelming the server
        end
    end)
end

-- Auto click function
local function StartAutoClick()
    if autoClickLoop then
        autoClickLoop:Disconnect()
    end
    
    autoClickLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if autoClickEnabled then
            PerformClick()
            task.wait() -- Add small delay to prevent overwhelming the server
        end
    end)
end

-- Create world dropdown
local worldNames = {}
for name, _ in pairs(WorldMap) do
    table.insert(worldNames, name)
end

worldDropdown = BattleSection:CreateDropdown("Select World", worldNames, 1, function(selected)
    selectedWorld = WorldMap[selected]
    
    -- Update boss dropdown with bosses from selected world
    local bosses = GetBossesInWorld(selectedWorld)
    if bossDropdown then
        bossDropdown.Refresh(bosses, 1, function(selected)
            selectedBoss = selected
        end)
    end
end)
function TPArea(Tarpos)
    if (Tarpos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Tarpos
    end
end
function TPAreaEvent(Tarpos)
    if (Tarpos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Tarpos
    end
end

local function CheckDumbells()
    local dumbelstat = PlayerStat.Biceps.Value
    if SelectedWorldName == "School" then
        if dumbelstat == 0 or dumbelstat <= 50 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "1Kg")
        elseif dumbelstat == 51 or dumbelstat <= 350 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "2Kg")
        elseif dumbelstat == 351 or dumbelstat <= 1000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "3Kg")
        elseif dumbelstat == 1001 or dumbelstat <= 2500 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "4Kg")
        elseif dumbelstat == 2501 or dumbelstat <= 5000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "5Kg")
        elseif dumbelstat == 5001 or dumbelstat <= 7500 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "10Kg")
        elseif dumbelstat == 7501 or dumbelstat <= 10000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "15Kg")
        elseif dumbelstat == 10001 or dumbelstat <= 15000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "20Kg")
        elseif dumbelstat == 15001 or dumbelstat <= 20000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "25Kg")
        elseif dumbelstat == 20001 or dumbelstat <= 25000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "50Kg")
        elseif dumbelstat == 25001 or dumbelstat <= 50000 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "100Kg")
        elseif dumbelstat >= 50001 then
            onGuiEquipRequest:FireServer("1", "Dumbells", "250Kg")
        end
    elseif SelectedWorldName == "Space" then
        if dumbelstat == 0 or dumbelstat <= 750000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "300Kg")
        elseif dumbelstat == 750001 or dumbelstat <= 1125000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "400Kg")
        elseif dumbelstat == 1125001 or dumbelstat <= 175000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "500Kg")
        elseif dumbelstat == 1750001 or dumbelstat <= 2625000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "650Kg")
        elseif dumbelstat == 2625001 or dumbelstat <= 4000000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "800Kg")
        elseif dumbelstat == 4000001 or dumbelstat <= 6000000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "1000Kg")
        elseif dumbelstat == 6000001 or dumbelstat <= 7500000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "1500Kg")
        elseif dumbelstat == 7500001 or dumbelstat <= 9000000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "2000Kg")
        elseif dumbelstat == 9000001 or dumbelstat <= 13500000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "2500Kg")
        elseif dumbelstat == 13500001 or dumbelstat <= 20250000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "3000Kg")
        elseif dumbelstat == 20250001 or dumbelstat <= 30000000 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "3500Kg")
        elseif dumbelstat >= 30000001 then
            onGuiEquipRequest:FireServer("2", "Dumbells", "4000Kg")
        end
    elseif SelectedWorldName == "Beach" then
        if dumbelstat == 0 or dumbelstat <= 42000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "5000Kg")
        elseif dumbelstat == 42000001 or dumbelstat <= 63000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "6000Kg")
        elseif dumbelstat == 63000001 or dumbelstat <= 94500000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "7500Kg")
        elseif dumbelstat == 94500001 or dumbelstat <= 141750000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "10000Kg")
        elseif dumbelstat == 141750001 or dumbelstat <= 200000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "12500Kg")
        elseif dumbelstat == 200000001 or dumbelstat <= 300000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "15000Kg")
        elseif dumbelstat == 300000001 or dumbelstat <= 450000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "20000Kg")
        elseif dumbelstat == 450000001 or dumbelstat <= 675000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "25000Kg")
        elseif dumbelstat == 675000001 or dumbelstat <= 1000000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "30000Kg")
        elseif dumbelstat == 1000000001 or dumbelstat <= 1500000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "35000Kg")
        elseif dumbelstat == 1500000001 or dumbelstat <= 2250000000 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "40000Kg")
        elseif dumbelstat >= 2250000001 then
            onGuiEquipRequest:FireServer("3", "Dumbells", "45000Kg")
        end
    elseif SelectedWorldName == "Nuclear" then
        if dumbelstat == 0 or dumbelstat <= 3375000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "50000Kg")
        elseif dumbelstat == 3375000001 or dumbelstat <= 5000000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "60000Kg")
        elseif dumbelstat == 5000000001 or dumbelstat <= 7500000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "70000Kg")
        elseif dumbelstat == 7500000001 or dumbelstat <= 11250000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "80000Kg")
        elseif dumbelstat == 11250000001 or dumbelstat <= 16875000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "90000Kg")
        elseif dumbelstat == 16875000001 or dumbelstat <= 25000000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "100000Kg")
        elseif dumbelstat == 25000000001 or dumbelstat <= 37500000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "125000Kg")
        elseif dumbelstat == 37500000001 or dumbelstat <= 56000000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "150000Kg")
        elseif dumbelstat == 56000000001 or dumbelstat <= 84000000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "175000Kg")
        elseif dumbelstat == 84000000001 or dumbelstat <= 126000000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "200000Kg")
        elseif dumbelstat == 126000000001 or dumbelstat <= 189000000000 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "250000Kg")
        elseif dumbelstat >= 189000000001 then
            onGuiEquipRequest:FireServer("4", "Dumbells", "300000Kg")
        end
    elseif SelectedWorldName == "The Void" then
        if dumbelstat == 0 or dumbelstat <= 1000000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "350000Kg")
        elseif dumbelstat == 1000000000001 or dumbelstat <= 1200000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "375000Kg")
        elseif dumbelstat == 1200000000001 or dumbelstat <= 1400000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "400000Kg")
        elseif dumbelstat == 1400000000001 or dumbelstat <= 1800000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "Starter")
        elseif dumbelstat == 1800000000001 or dumbelstat <= 2200000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "450000Kg")
        elseif dumbelstat == 2200000000001 or dumbelstat <= 2500000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "Starter")
        elseif dumbelstat == 2500000000001 or dumbelstat <= 2800000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "500000Kg")
        elseif dumbelstat == 2800000000001 or dumbelstat <= 3200000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "525000Kg")
        elseif dumbelstat == 3200000000001 or dumbelstat <= 3500000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "550000Kg")
        elseif dumbelstat == 3500000000001 or dumbelstat <= 4000000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "575000Kg")
        elseif dumbelstat == 4000000000001 or dumbelstat <= 4200000000000 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "600000Kg")
        elseif dumbelstat >= 4200000000001 then
            onGuiEquipRequest:FireServer("6", "Dumbells", "625000Kg")
        end
    elseif SelectedWorldName == "Space Center" then
        if dumbelstat == 0 or dumbelstat <= 4500000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "650000Kg")
        elseif dumbelstat == 4500000000000 or dumbelstat <= 4900000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "675000Kg")
        elseif dumbelstat == 4900000000000 or dumbelstat <= 5300000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "700000Kg")
        elseif dumbelstat == 5300000000000 or dumbelstat <= 5800000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "725000Kg")
        elseif dumbelstat == 5800000000000 or dumbelstat <= 6300000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "750000Kg")
        elseif dumbelstat == 6300000000000 or dumbelstat <= 6800000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "775000Kg")
        elseif dumbelstat == 6800000000000 or dumbelstat <= 7300000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "800000Kg")
        elseif dumbelstat == 7300000000000 or dumbelstat <= 7900000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "825000Kg")
        elseif dumbelstat == 7900000000000 or dumbelstat <= 8500000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "850000Kg")
        elseif dumbelstat == 8500000000000 or dumbelstat <= 9100000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "875000Kg")
        elseif dumbelstat == 9100000000000 or dumbelstat <= 9700000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "900000Kg")
        elseif dumbelstat >= 9700000000000 then
            onGuiEquipRequest:FireServer("7", "Dumbells", "925000Kg")
        end
    elseif SelectedWorldName == "Roman Empire" then
        if dumbelstat == 0 or dumbelstat <= 1.65e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "650000Kg")
        elseif dumbelstat == 1.65e+22 or dumbelstat <= 1.92e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "675000Kg")
        elseif dumbelstat == 1.92e+22 or dumbelstat <= 2.83e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "700000Kg")
        elseif dumbelstat == 2.83e+22 or dumbelstat <= 3.79e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "725000Kg")
        elseif dumbelstat == 3.79e+22 or dumbelstat <= 4.25e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "750000Kg")
        elseif dumbelstat == 4.25e+22 or dumbelstat <= 4.8e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "775000Kg")
        elseif dumbelstat == 4.8e+22 or dumbelstat <= 5.2e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "800000Kg")
        elseif dumbelstat == 5.2e+22 or dumbelstat <= 5.6e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "825000Kg")
        elseif dumbelstat == 5.6e+22 or dumbelstat <= 6.35e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "850000Kg")
        elseif dumbelstat == 6.35e+22 or dumbelstat <= 6.75e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "875000Kg")
        elseif dumbelstat == 6.75e+22 or dumbelstat <= 7.3e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "900000Kg")
        elseif dumbelstat >= 7.3e+22 then
            onGuiEquipRequest:FireServer("8", "Dumbells", "925000Kg")
        end
    elseif SelectedWorldName == "The Underworld" then
        if dumbelstat == 0 or dumbelstat <= 2.475e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "650000Kg")
        elseif dumbelstat == 2.475e+22 or dumbelstat <= 2.88e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "675000Kg")
        elseif dumbelstat == 2.88e+22 or dumbelstat <= 4.245e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "700000Kg")
        elseif dumbelstat == 4.245e+22 or dumbelstat <= 5.685e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "725000Kg")
        elseif dumbelstat == 5.685e+22 or dumbelstat <= 6.3749999999999994e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "750000Kg")
        elseif dumbelstat == 6.3749999999999994e+22 or dumbelstat <= 7.2e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "775000Kg")
        elseif dumbelstat == 7.2e+22 or dumbelstat <= 7.8e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "800000Kg")
        elseif dumbelstat == 7.8e+22 or dumbelstat <= 8.4e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "825000Kg")
        elseif dumbelstat == 8.4e+22 or dumbelstat <= 9.525e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "850000Kg")
        elseif dumbelstat == 9.525e+22 or dumbelstat <= 1.0124999999999999e+23 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "875000Kg")
        elseif dumbelstat == 1.0124999999999999e+23 or dumbelstat <= 1.095e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "900000Kg")
        elseif dumbelstat >= 1.095e+22 then
            onGuiEquipRequest:FireServer("9", "Dumbells", "925000Kg")
        end
    elseif SelectedWorldName == "Magic Forest" then
        if dumbelstat == 0 or dumbelstat <= 1.3e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic1")
        elseif dumbelstat == 1.3e+24 or dumbelstat <= 1.7e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic2")
        elseif dumbelstat == 1.7e+24 or dumbelstat <= 2e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic3")
        elseif dumbelstat == 2e+24 or dumbelstat <= 2.7999999999999996e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic4")
        elseif dumbelstat == 2.7999999999999996e+24 or dumbelstat <= 3.2000000000000003e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic5")
        elseif dumbelstat == 3.2000000000000003e+24 or dumbelstat <= 4e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic6")
        elseif dumbelstat == 4e+24 or dumbelstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic7")
        elseif dumbelstat == 5.1e+24 or dumbelstat <= 6e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic8")
        elseif dumbelstat == 6e+24 or dumbelstat <= 7e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic9")
        elseif dumbelstat == 7e+24 or dumbelstat <= 8.199999999999999e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic10")
        elseif dumbelstat == 8.199999999999999e+24 or dumbelstat <= 8.999999999999999e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic11")
        elseif dumbelstat >= 8.999999999999999e+24 then
            onGuiEquipRequest:FireServer("10", "Dumbells", "Magic12")
        end
    elseif SelectedWorldName == "Snowy Peaks" then
        if dumbelstat == 0 or dumbelstat <= 1.3e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice1")
        elseif dumbelstat == 1.3e+24 or dumbelstat <= 1.7e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice2")
        elseif dumbelstat == 1.7e+24 or dumbelstat <= 2e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice3")
        elseif dumbelstat == 2e+24 or dumbelstat <= 2.7999999999999996e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice4")
        elseif dumbelstat == 2.7999999999999996e+24 or dumbelstat <= 3.2000000000000003e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice5")
        elseif dumbelstat == 3.2000000000000003e+24 or dumbelstat <= 4e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice6")
        elseif dumbelstat == 4e+24 or dumbelstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice7")
        elseif dumbelstat == 5.1e+24 or dumbelstat <= 6e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice8")
        elseif dumbelstat == 6e+24 or dumbelstat <= 7e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice9")
        elseif dumbelstat == 7e+24 or dumbelstat <= 8.199999999999999e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice10")
        elseif dumbelstat == 8.199999999999999e+24 or dumbelstat <= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice11")
        elseif dumbelstat >= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("11", "Dumbells", "Ice12")
        end

    elseif SelectedWorldName == "Dusty Tavern" then
        if dumbelstat == 0 or dumbelstat <= 1.3e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining1")
        elseif dumbelstat == 1.3e+24 or dumbelstat <= 1.7e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining2")
        elseif dumbelstat == 1.7e+24 or dumbelstat <= 2e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining3")
        elseif dumbelstat == 2e+24 or dumbelstat <= 2.7999999999999996e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining4")
        elseif dumbelstat == 2.7999999999999996e+24 or dumbelstat <= 3.2000000000000003e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining5")
        elseif dumbelstat == 3.2000000000000003e+24 or dumbelstat <= 4e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining6")
        elseif dumbelstat == 4e+24 or dumbelstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining7")
        elseif dumbelstat == 5.1e+24 or dumbelstat <= 6e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining8")
        elseif dumbelstat == 6e+24 or dumbelstat <= 7e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining9")
        elseif dumbelstat == 7e+24 or dumbelstat <= 8.199999999999999e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining10")
        elseif dumbelstat == 8.199999999999999e+24 or dumbelstat <= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining11")
        elseif dumbelstat >= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("12", "Dumbells", "Mining12")
        end

    elseif SelectedWorldName == "Lost Kingdom" then
        if dumbelstat == 0 or dumbelstat <= 1.3e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom1")
        elseif dumbelstat == 1.3e+24 or dumbelstat <= 1.7e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom2")
        elseif dumbelstat == 1.7e+24 or dumbelstat <= 2e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom3")
        elseif dumbelstat == 2e+24 or dumbelstat <= 2.7999999999999996e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom4")
        elseif dumbelstat == 2.7999999999999996e+24 or dumbelstat <= 3.2000000000000003e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom5")
        elseif dumbelstat == 3.2000000000000003e+24 or dumbelstat <= 4e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom6")
        elseif dumbelstat == 4e+24 or dumbelstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom7")
        elseif dumbelstat == 5.1e+24 or dumbelstat <= 6e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom8")
        elseif dumbelstat == 6e+24 or dumbelstat <= 7e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom9")
        elseif dumbelstat == 7e+24 or dumbelstat <= 8.199999999999999e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom10")
        elseif dumbelstat == 8.199999999999999e+24 or dumbelstat <= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom11")
        elseif dumbelstat >= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("13", "Dumbells", "Kingdom12")
        end

    elseif SelectedWorldName == "Orc Paradise" then
        if dumbelstat == 0 or dumbelstat <= 1.3e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise1")
        elseif dumbelstat == 1.3e+24 or dumbelstat <= 1.7e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise2")
        elseif dumbelstat == 1.7e+24 or dumbelstat <= 2e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise3")
        elseif dumbelstat == 2e+24 or dumbelstat <= 2.7999999999999996e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise4")
        elseif dumbelstat == 2.7999999999999996e+24 or dumbelstat <= 3.2000000000000003e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise5")
        elseif dumbelstat == 3.2000000000000003e+24 or dumbelstat <= 4e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise6")
        elseif dumbelstat == 4e+24 or dumbelstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise7")
        elseif dumbelstat == 5.1e+24 or dumbelstat <= 6e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise8")
        elseif dumbelstat == 6e+24 or dumbelstat <= 7e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise9")
        elseif dumbelstat == 7e+24 or dumbelstat <= 8.199999999999999e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise10")
        elseif dumbelstat == 8.199999999999999e+24 or dumbelstat <= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise11")
        elseif dumbelstat >= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("14", "Dumbells", "Paradise12")
        end

    elseif SelectedWorldName == "Heavenly Island" then
        if dumbelstat == 0 or dumbelstat <= 1.3e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven1")
        elseif dumbelstat == 1.3e+24 or dumbelstat <= 1.7e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven2")
        elseif dumbelstat == 1.7e+24 or dumbelstat <= 2e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven3")
        elseif dumbelstat == 2e+24 or dumbelstat <= 2.7999999999999996e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven4")
        elseif dumbelstat == 2.7999999999999996e+24 or dumbelstat <= 3.2000000000000003e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven5")
        elseif dumbelstat == 3.2000000000000003e+24 or dumbelstat <= 4e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven6")
        elseif dumbelstat == 4e+24 or dumbelstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven7")
        elseif dumbelstat == 5.1e+24 or dumbelstat <= 6e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven8")
        elseif dumbelstat == 6e+24 or dumbelstat <= 7e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven9")
        elseif dumbelstat == 7e+24 or dumbelstat <= 8.199999999999999e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven10")
        elseif dumbelstat == 8.199999999999999e+24 or dumbelstat <= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven11")
        elseif dumbelstat >= 8.99999999999999e+24 then
            onGuiEquipRequest:FireServer("15", "Dumbells", "Heaven12")
        end

    elseif SelectedWorldName == "The Rift" then
        if dumbelstat == 0 or dumbelstat <= 1.2e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift1")
        elseif dumbelstat == 1.2e+25 or dumbelstat <= 1.5e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift2")
        elseif dumbelstat == 1.5e+25 or dumbelstat <= 2.3e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift3")
        elseif dumbelstat == 2.3e+25 or dumbelstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift4")
        elseif dumbelstat == 2.5e+25 or dumbelstat <= 3.2e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift5")
        elseif dumbelstat == 3.2e+25 or dumbelstat <= 3.5e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift6")
        elseif dumbelstat == 3.5e+25 or dumbelstat <= 3.61e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift7")
        elseif dumbelstat == 3.61e+25 or dumbelstat <= 3.8e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift8")
        elseif dumbelstat == 3.8e+25 or dumbelstat <= 4.5e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift9")
        elseif dumbelstat == 4.5e+25 or dumbelstat <= 5.32e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift10")
        elseif dumbelstat == 5.32e+25 or dumbelstat <= 6e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift11")
        elseif dumbelstat >= 6e+25 then
            onGuiEquipRequest:FireServer("16", "Dumbells", "Rift12")
            elseif SelectedWorldName == "Striker" then
    if dumbelstat == 0 or dumbelstat <= 13e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field1")
    elseif dumbelstat <= 14e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field2")
    elseif dumbelstat <= 15e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field3")
    elseif dumbelstat <= 16e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field4")
    elseif dumbelstat <= 17e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field5")
    elseif dumbelstat <= 18e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field6")
    elseif dumbelstat <= 19e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field7")
    elseif dumbelstat <= 20e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field8")
    elseif dumbelstat <= 21e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field9")
    elseif dumbelstat <= 22e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field10")
    elseif dumbelstat <= 23e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field11")
    elseif dumbelstat <= 24e+6 then
        onGuiEquipRequest:FireServer("18", "Dumbells", "Field12")
        end
        end
    end
end
local function CheckBarbells()
    local barbelstat = PlayerStat.Biceps.Value
    if SelectedWorldName == "School" then
        if barbelstat == 3000 or barbelstat <= 15000 then
            onEquipRequest:FireServer("1", "Barbells", "Tier1")
        elseif barbelstat == 15001 or barbelstat <= 50000 then
            onEquipRequest:FireServer("1", "Barbells", "Tier2")
        elseif barbelstat >= 50001 then
            onEquipRequest:FireServer("1", "Barbells", "Tier3")
        end
    elseif SelectedWorldName == "Space" then
        if barbelstat == 250000 or barbelstat <= 1250000 then
            onEquipRequest:FireServer("2", "Barbells", "Tier4")
        elseif barbelstat == 1250000 or barbelstat <= 5000000 then
            onEquipRequest:FireServer("2", "Barbells", "Tier5")
        elseif barbelstat >= 5000000 then
            onEquipRequest:FireServer("2", "Barbells", "Tier6")
        end
    elseif SelectedWorldName == "Beach" then
        if barbelstat == 10000000 or barbelstat <= 25000000 then
            onEquipRequest:FireServer("3", "Barbells", "Tier7")
        elseif barbelstat == 25000000 or barbelstat <= 45000000 then
            onEquipRequest:FireServer("3", "Barbells", "Tier8")
        elseif barbelstat >= 45000000 then
            onEquipRequest:FireServer("3", "Barbells", "Tier9")
        end
    elseif SelectedWorldName == "Bunker" then
        if barbelstat == 3937500000 or barbelstat <= 21850000000 then
            onEquipRequest:FireServer("4", "Barbells", "Tier10")
        elseif barbelstat == 21850000000 or barbelstat <= 220000000000 then
            onEquipRequest:FireServer("4", "Barbells", "Tier11")
        elseif barbelstat >= 220000000000 then
            onEquipRequest:FireServer("4", "Barbells", "Tier12")
        end
    elseif SelectedWorldName == "The Void" then
        if barbelstat == 2.16e+19 or barbelstat <= 2.7e+19 then
            onEquipRequest:FireServer("6", "Barbells", "Tier16")
        elseif barbelstat == 2.7e+19 or barbelstat <= 3.24e+19 then
            onEquipRequest:FireServer("6", "Barbells", "Tier17")
        elseif barbelstat >= 3.24e+19 then
            onEquipRequest:FireServer("6", "Barbells", "Tier18")
        end
        elseif SelectedWorldName == "Space Center" then
        if barbelstat == 37800000000000000000 or barbelstat <= 43200000000000000000 then
            onEquipRequest:FireServer("7", "Barbells", "Tier19")
        elseif barbelstat == 43200000000000000000 or barbelstat <= 48600000000000000000 then
            onEquipRequest:FireServer("7", "Barbells", "Tier20")
        elseif barbelstat >= 48600000000000000000 then
            onEquipRequest:FireServer("7", "Barbells", "Tier21")
        end
    elseif SelectedWorldName == "Roman Empire" then
        if barbelstat == 5e+22 or barbelstat <= 1.28e+23 then
            onEquipRequest:FireServer("8", "Barbells", "Tier22")
        elseif barbelstat == 1.28e+23 or barbelstat <= 2.8e+23 then
            onEquipRequest:FireServer("8", "Barbells", "Tier23")
        elseif barbelstat >= 2.8e+23 then
            onEquipRequest:FireServer("8", "Barbells", "Tier24")
        end
    elseif SelectedWorldName == "The Underworld" then
        if barbelstat == 4.2e+23 or barbelstat <= 5.6e+23 then
            onEquipRequest:FireServer("9", "Barbells", "Tier25")
        elseif barbelstat == 5.6e+23 or barbelstat <= 7e+23 then
            onEquipRequest:FireServer("9", "Barbells", "Tier26")
        elseif barbelstat >= 7e+23 then
            onEquipRequest:FireServer("9", "Barbells", "Tier27")
        end
    elseif SelectedWorldName == "Magic Forest" then
        if barbelstat == 1.5e+24 or barbelstat <= 4e+24 then
            onEquipRequest:FireServer("10", "Barbells", "Tier28")
        elseif barbelstat == 4e+24 or barbelstat <= 8e+24 then
            onEquipRequest:FireServer("10", "Barbells", "Tier29")
        elseif barbelstat >= 8e+24 then
            onEquipRequest:FireServer("10", "Barbells", "Tier30")
        end

    elseif SelectedWorldName == "Snowy Peaks" then
        if barbelstat == 1.2e+25 or barbelstat <= 1.4e+25 then
            onEquipRequest:FireServer("11", "Barbells", "Tier31")
        elseif barbelstat == 1.4e+25 or barbelstat <= 1.6e+25 then
            onEquipRequest:FireServer("11", "Barbells", "Tier32")
        elseif barbelstat >= 1.6e+25 then
            onEquipRequest:FireServer("11", "Barbells", "Tier33")
        end

    elseif SelectedWorldName == "Dusty Tavern" then
        if barbelstat == 1.2e+25 or barbelstat <= 1.4e+25 then
            onEquipRequest:FireServer("12", "Barbells", "Mining1")
        elseif barbelstat == 1.4e+25 or barbelstat <= 1.6e+25 then
            onEquipRequest:FireServer("12", "Barbells", "Mining2")
        elseif barbelstat >= 1.6e+25 then
            onEquipRequest:FireServer("12", "Barbells", "Mining3")
        end

    elseif SelectedWorldName == "Lost Kingdom" then
        if barbelstat == 1.2e+25 or barbelstat <= 1.4e+25 then
            onEquipRequest:FireServer("13", "Barbells", "Kingdom1")
        elseif barbelstat == 1.4e+25 or barbelstat <= 1.6e+25 then
            onEquipRequest:FireServer("13", "Barbells", "Kingdom2")
        elseif barbelstat >= 1.6e+25 then
            onEquipRequest:FireServer("13", "Barbells", "Kingdom3")
        end
        elseif SelectedWorldName == "Orc Paradise" then
        if barbelstat == 1.2e+25 or barbelstat <= 1.4e+25 then
            onEquipRequest:FireServer("14", "Barbells", "Paradise1")
        elseif barbelstat == 1.4e+25 or barbelstat <= 1.6e+25 then
            onEquipRequest:FireServer("14", "Barbells", "Paradise2")
        elseif barbelstat >= 1.6e+25 then
            onEquipRequest:FireServer("14", "Barbells", "Paradise3")
        end

    elseif SelectedWorldName == "Heavenly Island" then
        if barbelstat == 3.5999999999999997e+25 or barbelstat <= 4.2e+25 then
            onEquipRequest:FireServer("15", "Barbells", "Heaven1")
        elseif barbelstat == 4.2e+25 or barbelstat <= 4.8e+25 then
            onEquipRequest:FireServer("15", "Barbells", "Heaven2")
        elseif barbelstat >= 4.8e+25 then
            onEquipRequest:FireServer("15", "Barbells", "Heaven3")
        end

    elseif SelectedWorldName == "The Rift" then
        if barbelstat == 5.999999999999999e+25 or barbelstat <= 7.5000000000000001e+25 then
            onEquipRequest:FireServer("16", "Barbells", "Rift1")
        elseif barbelstat == 7.5000000000000001e+25 or barbelstat <= 9e+25 then
            onEquipRequest:FireServer("16", "Barbells", "Rift2")
        elseif barbelstat >= 9e+25 then
            onEquipRequest:FireServer("16", "Barbells", "Rift3")
            end
            elseif SelectedWorldName == "Striker" then
    if barbelstat == 5.999999999999999e+25 or barbelstat <= 6.0e+25 then
        onEquipRequest:FireServer("18", "Barbells", "Field1")
    elseif barbelstat <= 7.5e+25 then
        onEquipRequest:FireServer("18", "Barbells", "Field2")
    elseif barbelstat <= 9.0e+25 then
        onEquipRequest:FireServer("18", "Barbells", "Field3")
        end
    end
end
local function CheckGrips()
    local gripstat = PlayerStat.Hands.Value
    if SelectedWorldName == "School" then
        if gripstat == 0 or gripstat <= 50 then
            onGuiEquipRequest:FireServer("1", "Grips", "1Kg")
        elseif gripstat == 51 or gripstat <= 150 then
            onGuiEquipRequest:FireServer("1", "Grips", "2Kg")
        elseif gripstat == 151 or gripstat <= 300 then
            onGuiEquipRequest:FireServer("1", "Grips", "3Kg")
        elseif gripstat == 301 or gripstat <= 500 then
            onGuiEquipRequest:FireServer("1", "Grips", "4Kg")
        elseif gripstat == 501 or gripstat <= 1500 then
            onGuiEquipRequest:FireServer("1", "Grips", "5Kg")
        elseif gripstat == 1501 or gripstat <= 3000 then
            onGuiEquipRequest:FireServer("1", "Grips", "10Kg")
        elseif gripstat == 3001 or gripstat <= 5000 then
            onGuiEquipRequest:FireServer("1", "Grips", "15Kg")
        elseif gripstat == 5001 or gripstat <= 10000 then
            onGuiEquipRequest:FireServer("1", "Grips", "20Kg")
        elseif gripstat == 10001 or gripstat <= 25000 then
            onGuiEquipRequest:FireServer("1", "Grips", "25Kg")
        elseif gripstat == 25001 or gripstat <= 100000 then
            onGuiEquipRequest:FireServer("1", "Grips", "50Kg")
        elseif gripstat == 100001 or gripstat <= 300000 then
            onGuiEquipRequest:FireServer("1", "Grips", "100Kg")
        elseif gripstat >= 300000 then
            onGuiEquipRequest:FireServer("1", "Grips", "250Kg")
        end
    elseif SelectedWorldName == "Space" then
        if gripstat == 0 or gripstat <= 750000 then
            onGuiEquipRequest:FireServer("2", "Grips", "300Kg")
        elseif gripstat == 750000 or gripstat <= 1125000 then
            onGuiEquipRequest:FireServer("2", "Grips", "350Kg")
        elseif gripstat == 1125000 or gripstat <= 1750000 then
            onGuiEquipRequest:FireServer("2", "Grips", "400Kg")
        elseif gripstat == 1750000 or gripstat <= 2500000 then
            onGuiEquipRequest:FireServer("2", "Grips", "450Kg")
        elseif gripstat == 2500000 or gripstat <= 3750000 then
            onGuiEquipRequest:FireServer("2", "Grips", "500Kg")
        elseif gripstat == 3750000 or gripstat <= 5625000 then
            onGuiEquipRequest:FireServer("2", "Grips", "600Kg")
        elseif gripstat == 5625000 or gripstat <= 8500000 then
            onGuiEquipRequest:FireServer("2", "Grips", "700Kg")
        elseif gripstat == 8500000 or gripstat <= 12750000 then
            onGuiEquipRequest:FireServer("2", "Grips", "800Kg")
        elseif gripstat == 12750000 or gripstat <= 16000000 then
            onGuiEquipRequest:FireServer("2", "Grips", "900Kg")
            elseif gripstat == 16000000 or gripstat <= 22000000 then
            onGuiEquipRequest:FireServer("2", "Grips", "1000Kg")
        elseif gripstat == 22000000 or gripstat <= 30000000 then
            onGuiEquipRequest:FireServer("2", "Grips", "1250Kg")
        elseif gripstat >= 30000000 then
            onGuiEquipRequest:FireServer("2", "Grips", "1500Kg")
        end
    elseif SelectedWorldName == "Beach" then
        if gripstat == 0 or gripstat <= 42000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "5000Kg")
        elseif gripstat == 42000000 or gripstat <= 63000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "6000Kg")
        elseif gripstat == 63000000 or gripstat <= 94500000 then
            onGuiEquipRequest:FireServer("3", "Grips", "7500Kg")
        elseif gripstat == 94500000 or gripstat <= 141750000 then
            onGuiEquipRequest:FireServer("3", "Grips", "10000Kg")
        elseif gripstat == 141750000 or gripstat <= 212625000 then
            onGuiEquipRequest:FireServer("3", "Grips", "12500Kg")
        elseif gripstat == 212625000 or gripstat <= 318937500 then
            onGuiEquipRequest:FireServer("3", "Grips", "15000Kg")
        elseif gripstat == 318937500 or gripstat <= 500000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "20000Kg")
        elseif gripstat == 500000000 or gripstat <= 750000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "25000Kg")
        elseif gripstat == 750000000 or gripstat <= 1125000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "30000Kg")
        elseif gripstat == 1125000000 or gripstat <= 1687500000 then
            onGuiEquipRequest:FireServer("3", "Grips", "35000Kg")
        elseif gripstat == 1687500000 or gripstat <= 2500000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "40000Kg")
        elseif gripstat >= 2500000000 then
            onGuiEquipRequest:FireServer("3", "Grips", "45000Kg")
        end
    elseif SelectedWorldName == "Bunker" then
        if gripstat == 0 or gripstat <= 3750000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "50000Kg")
        elseif gripstat == 3750000000 or gripstat <= 4000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "60000Kg")
        elseif gripstat == 4000000000 or gripstat <= 6500000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "70000Kg")
        elseif gripstat == 6500000000 or gripstat <= 12250000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "80000Kg")
        elseif gripstat == 12250000000 or gripstat <= 14875000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "90000Kg")
        elseif gripstat == 14875000000 or gripstat <= 23000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "100000Kg")
        elseif gripstat == 23000000000 or gripstat <= 36500000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "125000Kg")
        elseif gripstat == 36500000000 or gripstat <= 53000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "150000Kg")
        elseif gripstat == 53000000000 or gripstat <= 80000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "175000Kg")
        elseif gripstat == 80000000000 or gripstat <= 120000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "200000Kg")
        elseif gripstat == 120000000000 or gripstat <= 200000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "250000Kg")
        elseif gripstat >= 200000000000 then
            onGuiEquipRequest:FireServer("4", "Grips", "300000Kg")
        end
    elseif SelectedWorldName == "Dino World" then
        if gripstat == 0 or gripstat <= 2.499875e+14 then
            onGuiEquipRequest:FireServer("5", "Grips", "350000Kg")
        elseif gripstat == 2.499875e+14 or gripstat <= 4.99975e+14 then
            onGuiEquipRequest:FireServer("5", "Grips", "375000Kg")
        elseif gripstat == 4.99975e+14 or gripstat <= 9.9995e+14 then
            onGuiEquipRequest:FireServer("5", "Grips", "400000Kg")
        elseif gripstat == 9.9995e+14 or gripstat <= 1.499925e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "425000Kg")
        elseif gripstat == 1.499925e+15 or gripstat <= 1.9999e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "450000Kg")
        elseif gripstat == 1.9999e+15 or gripstat <= 2.499875e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "475000Kg")
        elseif gripstat == 2.499875e+15 or gripstat <= 2.99985e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "500000Kg")
        elseif gripstat == 2.99985e+15 or gripstat <= 3.499825e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "525000Kg")
        elseif gripstat == 3.499825e+15 or gripstat <= 3.9998e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "550000Kg")
        elseif gripstat == 3.9998e+15 or gripstat <= 4.499775e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "575000Kg")
        elseif gripstat == 4.499775e+15 or gripstat <= 5e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "600000Kg")
        elseif gripstat >= 5e+15 then
            onGuiEquipRequest:FireServer("5", "Grips", "625000Kg")
        end
    elseif SelectedWorldName == "The Void" then
        if gripstat == 0 or gripstat <= 2.16e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "650000Kg")
        elseif gripstat == 2.16e+19 or gripstat <= 2.52e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "675000Kg")
        elseif gripstat == 2.52e+19 or gripstat <= 2.88e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "700000Kg")
        elseif gripstat == 2.88e+19 or gripstat <= 3.24e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "725000Kg")
        elseif gripstat == 3.24e+19 or gripstat <= 3.6e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "750000Kg")
        elseif gripstat == 3.6e+19 or gripstat <= 3.96e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "775000Kg")
        elseif gripstat == 3.96e+19 or gripstat <= 4.32e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "800000Kg")
        elseif gripstat == 4.32e+19 or gripstat <= 4.68e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "825000Kg")
        elseif gripstat == 4.68e+19 or gripstat <= 5.04e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "850000Kg")
        elseif gripstat == 5.04e+19 or gripstat <= 5.4e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "875000Kg")
        elseif gripstat == 5.4e+19 or gripstat <= 5.76e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "900000Kg")
        elseif gripstat >= 5.76e+19 then
            onGuiEquipRequest:FireServer("6", "Grips", "925000Kg")
        end
    elseif SelectedWorldName == "Space Center" then
        if gripstat == 0 or gripstat <= 60480000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "875000Kg")
        elseif gripstat == 60480000000000000000 or gripstat <= 69120000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "900000Kg")
        elseif gripstat == 69120000000000000000 or gripstat <= 77760000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "925000Kg")
        elseif gripstat == 77760000000000000000 or gripstat <= 86400000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "950000Kg")
        elseif gripstat == 86400000000000000000 or gripstat <= 95040000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "975000Kg")
        elseif gripstat == 95040000000000000000 or gripstat <= 103680000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1000000Kg")
        elseif gripstat == 103680000000000000000 or gripstat <= 112320000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1025000Kg")
        elseif gripstat == 112320000000000000000 or gripstat <= 120960000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1050000Kg")
        elseif gripstat == 120960000000000000000 or gripstat <= 129600000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1075000Kg")
        elseif gripstat == 129600000000000000000 or gripstat <= 138240000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1100000Kg")
        elseif gripstat == 138240000000000000000 or gripstat <= 146880000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1125000Kg")
        elseif gripstat >= 146880000000000000000 then
            onGuiEquipRequest:FireServer("7", "Grips", "1150000Kg")
        end
    elseif SelectedWorldName == "Roman Empire" then
        if gripstat == 0 or gripstat <= 1.52e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "875000Kg")
        elseif gripstat == 1.52e+22 or gripstat <= 2.63e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "900000Kg")
        elseif gripstat == 2.63e+22 or gripstat <= 3.8e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "925000Kg")
        elseif gripstat == 3.8e+22 or gripstat <= 4.32e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "950000Kg")
        elseif gripstat == 4.32e+22 or gripstat <= 4.75e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "975000Kg")
        elseif gripstat == 4.75e+22 or gripstat <= 5.179999999999999e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "1000000Kg")
        elseif gripstat == 5.179999999999999e+22 or gripstat <= 5.6e+22 then
        onGuiEquipRequest:FireServer("8", "Grips", "1025000Kg")
        elseif gripstat == 5.6e+22 or gripstat <= 6.0399999999999996e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "1050000Kg")
        elseif gripstat == 6.0399999999999996e+22 or gripstat <= 6.45e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "1075000Kg")
        elseif gripstat == 6.45e+22 or gripstat <= 6.9e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "1100000Kg")
        elseif gripstat == 6.9e+22 or gripstat <= 7.3e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "1125000Kg")
        elseif gripstat >= 7.3e+22 then
            onGuiEquipRequest:FireServer("8", "Grips", "1150000Kg")
        end
    elseif SelectedWorldName == "The Underworld" then
        if gripstat == 0 or gripstat <= 2.736e+22 then
            onGuiEquipRequest:FireServer("9", "Grips", "875000Kg")
        elseif gripstat == 2.736e+22 or gripstat <= 4.7340000000000005e+22 then
            onGuiEquipRequest:FireServer("9", "Grips", "900000Kg")
        elseif gripstat == 4.7340000000000005e+22 or gripstat <= 6.840000000000001e+22 then
            onGuiEquipRequest:FireServer("9", "Grips", "925000Kg")
        elseif gripstat == 6.840000000000001e+22 or gripstat <= 7.776e+22 then
            onGuiEquipRequest:FireServer("9", "Grips", "950000Kg")
        elseif gripstat == 7.776e+22 or gripstat <= 8.55e+22 then
            onGuiEquipRequest:FireServer("9", "Grips", "975000Kg")
        elseif gripstat == 8.55e+22 or gripstat <= 9.3239999999999999e+22 then
            onGuiEquipRequest:FireServer("9", "Grips", "1000000Kg")
        elseif gripstat == 9.3239999999999999e+22 or gripstat <= 1.008e+23 then
            onGuiEquipRequest:FireServer("9", "Grips", "1025000Kg")
        elseif gripstat == 1.008e+23 or gripstat <= 1.0871999999999999e+23 then
            onGuiEquipRequest:FireServer("9", "Grips", "1050000Kg")
        elseif gripstat == 1.0871999999999999e+23 or gripstat <= 1.161e+23 then
            onGuiEquipRequest:FireServer("9", "Grips", "1075000Kg")
        elseif gripstat == 1.161e+23 or gripstat <= 1.242e+23 then
            onGuiEquipRequest:FireServer("9", "Grips", "1100000Kg")
        elseif gripstat == 1.242e+23 or gripstat <= 1.314e+23 then
            onGuiEquipRequest:FireServer("9", "Grips", "1125000Kg")
        elseif gripstat >= 1.314e+23 then
            onGuiEquipRequest:FireServer("9", "Grips", "1150000Kg")
        end
    elseif SelectedWorldName == "Magic Forest" then
        if gripstat == 0 or gripstat <= 1.5e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "875000Kg")
        elseif gripstat == 1.5e+24 or gripstat <= 2.2e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "900000Kg")
        elseif gripstat == 2.2e+24 or gripstat <= 2.9e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "925000Kg")
        elseif gripstat == 2.9e+24 or gripstat <= 3.5e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "950000Kg")
        elseif gripstat == 3.5e+24 or gripstat <= 4.3e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "975000Kg")
        elseif gripstat == 4.3e+24 or gripstat <= 5.1e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1000000Kg")
        elseif gripstat == 5.1e+24 or gripstat <= 6e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1025000Kg")
        elseif gripstat == 6e+24 or gripstat <= 6.8e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1050000Kg")
        elseif gripstat == 6.8e+24 or gripstat <= 7.7e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1075000Kg")
        elseif gripstat == 7.7e+24 or gripstat <= 8.5e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1100000Kg")
        elseif gripstat == 8.5e+24 or gripstat <= 9.999999999999999e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1125000Kg")
        elseif gripstat >= 9.999999999999999e+24 then
            onGuiEquipRequest:FireServer("10", "Grips", "1150000Kg")
        end

    elseif SelectedWorldName == "Snowy Peaks" then
        if gripstat == 0 or gripstat <= 1.05e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice1")
        elseif gripstat == 1.05e+25 or gripstat <= 1.1e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice2")
        elseif gripstat == 1.1e+25 or gripstat <= 1.2e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice3")
        elseif gripstat == 1.2e+25 or gripstat <= 1.25e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice4")
        elseif gripstat == 1.25e+25 or gripstat <= 1.4e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice5")
        elseif gripstat == 1.4e+25 or gripstat <= 1.45e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice6")
        elseif gripstat == 1.45e+25 or gripstat <= 1.6e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice7")
        elseif gripstat == 1.6e+25 or gripstat <= 1.7999999999999999e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice8")
            elseif gripstat == 1.7999999999999999e+25 or gripstat <= 1.95e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice9")
        elseif gripstat == 1.95e+25 or gripstat <= 2.2e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice10")
        elseif gripstat == 2.2e+25 or gripstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice11")
        elseif gripstat >= 2.5e+25 then
            onGuiEquipRequest:FireServer("11", "Grips", "Ice12")
        end

    elseif SelectedWorldName == "Dusty Tavern" then
        if gripstat == 0 or gripstat <= 1.05e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining1")
        elseif gripstat == 1.05e+25 or gripstat <= 1.1e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining2")
        elseif gripstat == 1.1e+25 or gripstat <= 1.2e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining3")
        elseif gripstat == 1.2e+25 or gripstat <= 1.25e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining4")
        elseif gripstat == 1.25e+25 or gripstat <= 1.4e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining5")
        elseif gripstat == 1.4e+25 or gripstat <= 1.45e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining6")
        elseif gripstat == 1.45e+25 or gripstat <= 1.6e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining7")
        elseif gripstat == 1.6e+25 or gripstat <= 1.7999999999999999e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining8")
        elseif gripstat == 1.7999999999999999e+25 or gripstat <= 1.95e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining9")
        elseif gripstat == 1.95e+25 or gripstat <= 2.2e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining10")
        elseif gripstat == 2.2e+25 or gripstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining11")
        elseif gripstat >= 2.5e+25 then
            onGuiEquipRequest:FireServer("12", "Grips", "Mining12")
        end

    elseif SelectedWorldName == "Lost Kingdom" then
        if gripstat == 0 or gripstat <= 1.05e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom1")
        elseif gripstat == 1.05e+25 or gripstat <= 1.1e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom2")
        elseif gripstat == 1.1e+25 or gripstat <= 1.2e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom3")
        elseif gripstat == 1.2e+25 or gripstat <= 1.25e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom4")
        elseif gripstat == 1.25e+25 or gripstat <= 1.4e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom5")
        elseif gripstat == 1.4e+25 or gripstat <= 1.45e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom6")
        elseif gripstat == 1.45e+25 or gripstat <= 1.6e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom7")
        elseif gripstat == 1.6e+25 or gripstat <= 1.7999999999999999e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom8")
        elseif gripstat == 1.7999999999999999e+25 or gripstat <= 1.95e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom9")
        elseif gripstat == 1.95e+25 or gripstat <= 2.2e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom10")
        elseif gripstat == 2.2e+25 or gripstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom11")
        elseif gripstat >= 2.5e+25 then
            onGuiEquipRequest:FireServer("13", "Grips", "Kingdom12")
        end

    elseif SelectedWorldName == "Orc Paradise" then
        if gripstat == 0 or gripstat <= 1.05e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise1")
        elseif gripstat == 1.05e+25 or gripstat <= 1.1e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise2")
        elseif gripstat == 1.1e+25 or gripstat <= 1.2e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise3")
        elseif gripstat == 1.2e+25 or gripstat <= 1.25e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise4")
        elseif gripstat == 1.25e+25 or gripstat <= 1.4e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise5")
        elseif gripstat == 1.4e+25 or gripstat <= 1.45e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise6")
        elseif gripstat == 1.45e+25 or gripstat <= 1.6e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise7")
        elseif gripstat == 1.6e+25 or gripstat <= 1.7999999999999999e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise8")
        elseif gripstat == 1.7999999999999999e+25 or gripstat <= 1.95e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise9")
        elseif gripstat == 1.95e+25 or gripstat <= 2.2e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise10")
        elseif gripstat == 2.2e+25 or gripstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise11")
        elseif gripstat >= 2.5e+25 then
            onGuiEquipRequest:FireServer("14", "Grips", "Paradise12")
        end

    elseif SelectedWorldName == "Heavenly Island" then
        if gripstat == 0 or gripstat <= 1.05e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven1")
        elseif gripstat == 1.05e+25 or gripstat <= 1.1e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven2")
        elseif gripstat == 1.1e+25 or gripstat <= 1.2e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven3")
        elseif gripstat == 1.2e+25 or gripstat <= 1.25e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven4")
        elseif gripstat == 1.25e+25 or gripstat <= 1.4e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven5")
        elseif gripstat == 1.4e+25 or gripstat <= 1.45e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven6")
        elseif gripstat == 1.45e+25 or gripstat <= 1.6e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven7")
        elseif gripstat == 1.6e+25 or gripstat <= 1.7999999999999999e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven8")
        elseif gripstat == 1.7999999999999999e+25 or gripstat <= 1.95e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven9")
        elseif gripstat == 1.95e+25 or gripstat <= 2.2e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven10")
        elseif gripstat == 2.2e+25 or gripstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven11")
        elseif gripstat >= 2.5e+25 then
            onGuiEquipRequest:FireServer("15", "Grips", "Heaven12")
        end

    elseif SelectedWorldName == "The Rift" then
        if gripstat == 0 or gripstat <= 2.5e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven1")
        elseif gripstat == 2.5e+25 or gripstat <= 2.6e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven2")
        elseif gripstat == 2.6e+25 or gripstat <= 2.9e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven3")
        elseif gripstat == 2.9e+25 or gripstat <= 3.3e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven4")
        elseif gripstat == 3.3e+25 or gripstat <= 3.7e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven5")
        elseif gripstat == 3.7e+25 or gripstat <= 3.9999999999999995e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven6")
        elseif gripstat == 3.9999999999999995e+25 or gripstat <= 4.3e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven7")
        elseif gripstat == 4.3e+25 or gripstat <= 4.5e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven8")
        elseif gripstat == 4.5e+25 or gripstat <= 5.3e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven9")
        elseif gripstat == 5.3e+25 or gripstat <= 5.8e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven10")
        elseif gripstat == 5.8e+25 or gripstat <= 6.3e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven11")
        elseif gripstat >= 6.3e+25 then
            onGuiEquipRequest:FireServer("16", "Grips", "Heaven12")
            elseif SelectedWorldName == "The Matrix" then
    if gripstat == 0 or gripstat <= 11.23e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix1")
    elseif gripstat <= 11.39e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix2")
    elseif gripstat <= 11.4e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix3")
    elseif gripstat <= 11.55e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix4")
    elseif gripstat <= 11.67e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix5")
    elseif gripstat <= 11.77e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix6")
    elseif gripstat <= 11.89e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix7")
    elseif gripstat <= 11.95e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix8")
    elseif gripstat <= 12.05e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix9")
    elseif gripstat <= 12.09e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix10")
    elseif gripstat <= 12.13e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix11")
    elseif gripstat <= 12.17e+6 then
        onGuiEquipRequest:FireServer("17", "Grips", "Matrix12")
        end
        elseif SelectedWorldName == "Striker" then
    if gripstat == 0 or gripstat <= 11.23e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field1")
    elseif gripstat <= 11.39e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field2")
    elseif gripstat <= 11.4e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field3")
    elseif gripstat <= 11.55e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field4")
    elseif gripstat <= 11.67e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field5")
    elseif gripstat <= 11.77e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field6")
    elseif gripstat <= 11.89e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field7")
    elseif gripstat <= 11.95e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field8")
    elseif gripstat <= 12.05e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field9")
    elseif gripstat <= 12.09e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field10")
    elseif gripstat <= 12.13e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field11")
    elseif gripstat <= 12.17e+6 then
        onGuiEquipRequest:FireServer("18", "Grips", "Field12")
        end
        end
    end
end

-- Create initial boss dropdown (will be updated when world is selected)
bossDropdown = BattleSection:CreateDropdown("Select Boss", {}, 1, function(selected)
    selectedBoss = selected
end)

-- Create auto fight toggle
BattleSection:CreateToggle("Auto Fight", function(state)
    autoFightEnabled = state
    if state then
        StartAutoFight()
    elseif autoFightLoop then
        autoFightLoop:Disconnect()
        autoFightLoop = nil
    end
end)

-- Create auto click toggle
BattleSection:CreateToggle("Auto Click battle", function(state)
    autoClickEnabled = state
    if state then
        StartAutoClick()
    elseif autoClickLoop then
        autoClickLoop:Disconnect()
        autoClickLoop = nil
    end
end)
-- Initialize control variables
getgenv().autoSpin = false
getgenv().autoGift = false
getgenv().autoRebirth = false
getgenv().autoSuperRebirth = false
getgenv().autoCraft = false
getgenv().autoClick = false
local Section = MainTab:CreateSection("Main²")
local Datas = game:GetService("ReplicatedStorage").Data
local ToolList = {'Dumbells', 'Barbells', 'Grips'}
local SelectedTools = ToolList[1] -- Default value
local ValueFarmTools = {}
local ValueSelected = nil
local AvailableWorlds = {}
local WorldNa = {
    ["School"] = "1",
    ["Space"] = "2",
    ["Beach"] = "3",
    ["Nuclear"] = "4",
    ["Dino World"] = "5",
    ["The Void"] = "6",
    ["Space Center"] = "7",
    ["Roman Empire"] = "8",
    ["The Underworld"] = "9",
    ["Magic Forest"] = "10",
    ["Snowy Peaks"] = "11",
    ["Dusty Tavern"] = "12",
    ["Lost Kingdom"] = "13",
    ["Orc Paradise"] = "14",
    ["Heavenly Island"] = "15",
    ["The Rift"] = "16",
    ["The Matrix"] = "17",
    ["Striker"] = "18"
}

for worldName, _ in pairs(WorldNa) do
    table.insert(AvailableWorlds, worldName)
end
table.sort(AvailableWorlds) -- Sort biar rapi di dropdown

WorldSelectionDropdown = Section:CreateDropdown("Select World", AvailableWorlds, 1, function(selectedWorldName)
    SelectedWorldName = selectedWorldName
    SelectedWorldNumber = WorldMap[selectedWorldName] -- Konversi ke angka
end)
-- Dropdown untuk memilih alat
Section:CreateDropdown("Select Tools", ToolList, 1, function(Value)
    SelectedTools = Value
end)
local function WeightClick()
    onClick:FireServer()
end
getgenv().isAutoClicking = false
getgenv().AutoOnClick = false

-- Fungsi untuk auto train
spawn(function()
    while true do
        if getgenv().AutoOnClick then -- Ubah kondisi ke AutoOnClick
            if game:GetService("Players").LocalPlayer.Character then
                WeightClick()
            end
        end
        task.wait()
    end
end)

-- Toggle Auto Farm
Section:CreateToggle("Auto Farm", function(Value)
    getgenv().AutoOnClick = Value
    getgenv().isAutoClicking = Value

    spawn(function()
        while getgenv().AutoOnClick do -- Gunakan getgenv() untuk konsistensi
            if SelectedTools == "Dumbells" then
                pcall(function()
                    CheckDumbells()
                end)
            elseif SelectedTools == "Barbells" then
                pcall(function()
                    CheckBarbells()
                end)
            elseif SelectedTools == "Grips" then
                pcall(function()
                    CheckGrips()
                end)
            end
            task.wait(5)
        end
    end)
end)
local function DataAreaPunch()
    if SelectedWorldName == "School" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-10226.5186, 5.15053797, 123.771912, -0.0155829815, 0, -0.999878585, 0, 1, -0, 0.999878585, -0, -0.0155829815))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-10227.5752, 5.15053797, 128.306076, -0.786992908, 0, -0.616962135, 0, 1.00000012, -0, 0.616962135, -0, -0.786992908))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-10234.5283, 5.15053797, 130.125748, -0.988179982, 0, 0.153298795, 0, 1.00000012, -0, -0.15329881, 0, -0.988179862))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-10353.9541, 5.23331785, 4059.25073, -0.995433033, 0, -0.0954622924, 0, 1, -0, 0.0954622924, -0, -0.995433033))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-10253.0537, 5.15053797, 129.890686, -0.98821795, 0, 0.153053313, 0, 1, -0, -0.153053313, 0, -0.98821795))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(-10351.7422, 5.23331928, 4051.05347, 0.948666573, -3.18870774e-09, 0.316277981, 2.80469621e-08, 1, -7.40440669e-08, -0.316277981, 7.9113768e-08, 0.948666573))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-10353.5244, 5.23331738, 4049.08447, 0.898823917, -3.41254776e-08, 0.438309908, 6.66579965e-08, 1, -5.88358269e-08, -0.438309908, 8.20999091e-08, 0.898823917))
        end
    elseif SelectedWorldName == "Space" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-10312.9844, -154.949097, 2804.17163, -0.0140013611, 0, 0.99990195, 0, 1, -0, -0.99990207, 0, -0.0140013592))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-10312.1924, -154.949081, 2795.8855, 0.0397631377, 0, 0.999209166, 0, 1, -0, -0.999209166, 0, 0.0397631377))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-10311.6865, -154.949066, 2787.02295, -0.138817862, 0, 0.990317941, 0, 1, -0, -0.990317941, 0, -0.138817862))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-10311.543, -154.949066, 2777.61792, -0.0653384775, 0, 0.997863114, 0, 1, -0, -0.997863233, 0, -0.06533847))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-10311.8906, -154.949097, 2767.55933, 0.0101079652, 0, 0.999948859, 0, 1, -0, -0.999948978, 0, 0.0101079643))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(-10310.9521, -154.949097, 2758.55029, 0.111349232, 0, 0.993781388, 0, 1.00000012, -0, -0.993781388, 0, 0.111349232))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-10311.2705, -154.949066, 2750.12451, 0.266251743, 0, 0.963903546, 0, 1, -0, -0.963903546, 0, 0.266251743))
        end
    elseif SelectedWorldName == "Beach" then
            if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(11558.6582, 9.88073826, 125.84948, -0.217357725, 0, 0.9760921, 0, 1.00000012, -0, -0.976091981, 0, -0.217357755))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(11557.7197, 9.88073826, 118.182503, -0.0782098621, 0, 0.996936917, 0, 1, -0, -0.996936917, 0, -0.0782098621))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(11557.2344, 9.88073826, 110.129379, -0.103174299, 0, 0.994663358, 0, 1.00000012, -0, -0.994663358, 0, -0.103174299))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(11557.3457, 9.88073826, 101.352608, 0.102762975, 0, 0.994705856, 0, 1.00000012, -0, -0.994705975, 0, 0.10276296))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(11557.1123, 9.88074017, 91.1643753, -0.161527604, 0, 0.986868203, 0, 1, -0, -0.986868203, 0, -0.161527604))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(11555.7783, 9.88073826, 81.3701096, -0.338747054, 0, 0.940877497, 0, 1, -0, -0.940877497, 0, -0.338747054))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(11557.9404, 9.8804121, 80.235672, -0.393749058, 0, 0.919217944, 0, 1, -0, -0.919217944, 0, -0.393749058))
        end
    elseif SelectedWorldName == "Nuclear" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-10360.6553, 6.23877478, -888.147583, 0.867073357, 0, 0.498180538, 0, 1, -0, -0.498180598, 0, 0.867073238))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-10355.1855, 6.23877478, -894.127075, 0.954581916, 0, 0.297948867, 0, 1, -0, -0.297948897, 0, 0.954581797))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-10346.0654, 5.95642185, -896.915283, 0.799118578, 0, 0.601173401, 0, 1, -0, -0.601173401, 0, 0.799118578))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-10342.0059, 6.23877478, -903.461853, 0.960983276, 0, 0.27660647, 0, 1, -0, -0.27660647, 0, 0.960983276))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-10334.957, 6.23877478, -909.604004, 0.783549249, 7.21945099e-08, 0.621329665, -1.41132661e-08, 1, -9.83955459e-08, -0.621329665, 6.83287666e-08, 0.783549249))
        end
    elseif SelectedWorldName == "The Void" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(428.126343, 40.2590561, -137.544189, -0.993069947, 0, -0.117525138, 0, 1.00000012, -0, 0.117525138, -0, -0.993069947))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(416.100769, 40.2590561, -135.599548, -0.989562273, 0, 0.144106343, 0, 1, -0, -0.144106358, 0, -0.989562154))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(402.214172, 40.2590561, -135.935806, -0.992473662, 0, -0.122458838, 0, 1.00000012, -0, 0.122458838, -0, -0.992473662))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(389.887787, 40.2590561, -137.885193, -0.983317912, 0, 0.181895196, 0, 1, -0, -0.181895196, 0, -0.983317912))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(383.9758, 40.2590599, -144.226501, 0.0482875444, 0, 0.998833537, 0, 1.00000012, -0, -0.998833537, 0, 0.0482875444))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(384.490723, 40.2590561, -158.568741, 0.119142972, 0, 0.992877066, 0, 1, -0, -0.992877185, 0, 0.119142957))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(384.531067, 40.2590561, -173.923935, -0.0110860635, 0, 0.999938548, 0, 1, -0, -0.999938548, 0, -0.0110860635))
        end
    elseif SelectedWorldName == "Space Center" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-9709.16895, 46.9589653, 515.433777, 0.117800578, 0, 0.993037283, 0, 1, -0, -0.993037283, 0, 0.117800578))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-9708.99805, 46.9589653, 494.919067, 0.0281911753, 0, 0.999602556, 0, 1, -0, -0.999602556, 0, 0.0281911753))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-9708.55469, 46.9589653, 474.15799, 0.977341592, 2.68517031e-09, 0.211668208, 3.57621599e-09, 1, -2.91983149e-08, -0.211668208, 2.92936981e-08, 0.977341592))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-9700.11523, 46.9589653, 460.796753, 0.743226886, 0, -0.669039488, -0, 1, -0, 0.669039488, 0, 0.743226886))
            elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-9682.22656, 46.9589767, 460.730377, 0.834624588, 0, -0.550819159, -0, 0.99999994, -0, 0.550819159, 0, 0.834624588))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(-9662.43555, 46.9589691, 462.22464, 0.933089256, 0, 0.359644979, 0, 1.00000012, -0, -0.359644979, 0, 0.933089256))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-9646.5293, 46.9589653, 460.563263, 0.964431822, 0, -0.264331937, -0, 1.00000012, -0, 0.264331937, 0, 0.964431822))
        end
    elseif SelectedWorldName == "Roman Empire" then
            if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-1562.02966, 47.7637024, 6.22029686, -0.828873873, -4.24696829e-08, 0.559435487, -8.47698232e-08, 1, -4.96818835e-08, -0.559435487, -8.86032652e-08, -0.828873873))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-1562.65491, 47.7636909, -1.44569683, 0.24394539, 0, 0.969789028, 0, 1.00000012, -0, -0.969789028, 0, 0.24394539))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-1562.41321, 47.7636909, -11.2723103, -0.15126887, 0, 0.988492668, 0, 1, -0, -0.988492668, 0, -0.15126887))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-1560.91187, 47.7636909, -20.9894753, -0.305013329, 0, 0.952348113, 0, 1, -0, -0.952348113, 0, -0.305013329))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-1561.73645, 47.7636909, -29.869421, -0.493594676, 0, 0.869692087, 0, 1, -0, -0.869692087, 0, -0.493594676))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(-1559.49524, 47.7637024, -38.8936501, -0.914466918, -2.64521098e-08, 0.404660642, -3.32189103e-08, 1, -9.70068736e-09, -0.404660642, -2.23133441e-08, -0.914466918))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-1560.82715, 47.7636909, -48.2506523, -0.0290641747, 0, 0.999577463, 0, 0.99999994, -0, -0.999577582, 0, -0.029064171))
        end
    elseif SelectedWorldName == "The Underworld" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-12373.4277, 71.6354828, 1317.09814, 0.99847579, 0, 0.0551929176, 0, 1, -0, -0.055192925, 0, 0.998475671))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-12367.1406, 71.6004944, 1318.70337, 0.983754694, 0, -0.179518223, -0, 1.00000012, -0, 0.179518223, 0, 0.983754694))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-12358.1396, 71.6354752, 1317.59583, 0.938703358, 0, 0.344726026, 0, 1, -0, -0.344726026, 0, 0.938703358))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-12351.6816, 71.6354752, 1317.86304, 0.991702497, 0, 0.128554031, 0, 1, -0, -0.128554031, 0, 0.991702497))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-12344.8105, 71.6354752, 1318.04651, 0.996965051, 0, 0.0778509751, 0, 1.00000012, -0, -0.0778509751, 0, 0.996965051))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(-12338.1982, 71.5655136, 1318.87024, 0.998851895, 0, -0.0479071885, -0, 1.00000012, -0, 0.047907196, 0, 0.998851776))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-12330.7988, 71.6354752, 1318.27502, 0.989132702, 0, 0.147025809, 0, 0.99999994, -0, -0.147025824, 0, 0.989132583))
        end
    elseif SelectedWorldName == "Magic Forest" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-6145.56006, -96.0125732, -1492.05005, -0.992135465, 0, -0.125168845, 0, 1, -0, 0.125168845, -0, -0.992135465))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-6151.93359, -96.0475616, -1491.81128, -0.999852359, 0, 0.0171877816, 0, 1, -0, -0.0171877835, 0, -0.99985224))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-6160.08691, -96.0825348, -1491.55298, -0.999306202, 0, 0.0372449532, 0, 0.99999994, -0, -0.0372449569, 0, -0.999306083))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-6168.3833, -96.0825348, -1491.44812, -0.999502778, 0, -0.0315319486, 0, 1, -0, 0.0315319486, -0, -0.999502778))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-6176.55957, -96.0825348, -1491.34436, -0.999725223, 0, -0.0234416425, 0, 1, -0, 0.0234416425, -0, -0.999725223))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(-6184.63525, -96.0825348, -1489.90881, -0.99895972, 0, -0.0456031673, 0, 1, -0, 0.045603171, -0, -0.998959601))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-6191.79834, -96.0825348, -1488.75085, 0.360560894, -2.24419905e-09, 0.932735682, -1.90545784e-08, 1, 9.77183046e-09, -0.932735682, -2.12962252e-08, 0.360560894))
        end

    elseif SelectedWorldName == "Snowy Peaks" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(1675.96362, -8.37515545, 2156.54492, 0.902372301, 0, -0.430957526, -0, 1.00000012, -0, 0.430957586, 0, 0.902372181))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(1683.53333, -8.37515545, 2159.3689, 0.790528119, 0, -0.612425864, -0, 1.00000012, -0, 0.612425923, 0, 0.790527999))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(1694.11938, -8.37515354, 2161.70996, 0.836271584, 0, -0.548315525, -0, 1.00000012, -0, 0.548315525, 0, 0.836271584))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(1702.93567, -8.37515545, 2164.92871, 0.815602183, 0, -0.578613162, -0, 1.00000012, -0, 0.578613162, 0, 0.815602183))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(1710.94727, -8.37515545, 2169.18896, 0.761875272, 0, -0.647723794, -0, 1, -0, 0.647723794, 0, 0.761875272))
        elseif BagPunchSelected == "Tier6" then
            TPArea(CFrame.new(1719.70874, -8.37515545, 2172.68237, 0.804367423, 0, -0.594132245, -0, 1, -0, 0.594132304, 0, 0.804367304))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(1729.72485, -8.37515831, 2176.01562, 0.409520894, -2.14058588e-07, -0.912300766, 1.56437409e-07, 1, -1.64413109e-07, 0.912300766, -7.53873621e-08, 0.409520894))
        end

    elseif SelectedWorldName == "Dusty Tavern" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(2975.7002, -3.12988043, -3893.54565, -0.981103122, 0, -0.193485513, 0, 1, -0, 0.193485513, -0, -0.981103122))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(2964.32251, -3.12988043, -3889.89087, -0.981720269, 0, -0.19032985, 0, 1, -0, 0.19032988, -0, -0.98172015))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(2952.46875, -3.12988043, -3887.46631, -0.968761265, 0, -0.247995555, 0, 1.00000012, -0, 0.247995585, -0, -0.968761146))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(2942.28833, -3.12988043, -3883.55859, -0.972948849, 0, -0.231020719, 0, 1, -0, 0.231020719, -0, -0.972948849))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(2931.00586, -3.12987995, -3881.18262, -0.97906369, 0, -0.203554377, 0, 1, -0, 0.203554407, -0, -0.97906357))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(2921.15308, -3.12987995, -3877.98145, -0.989313841, -2.50694256e-08, 0.145801634, -3.38416264e-08, 1, -5.76849715e-08, -0.145801634, -6.20027052e-08, -0.989313841))
        end

    elseif SelectedWorldName == "Lost Kingdom" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(2883.69385, 1.49053204, 574.641479, -0.999920785, 0, -0.0125937071, 0, 1, -0, 0.0125937089, -0, -0.999920666))
            elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(2873.82373, 1.49053204, 574.340759, -0.998228192, 0, 0.059502285, 0, 1.00000012, -0, -0.059502285, 0, -0.998228192))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(2865.50537, 1.49053228, 575.482727, -0.954454303, 0, 0.298357189, 0, 1, -0, -0.298357189, 0, -0.954454303))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(2855.67554, 1.49053204, 575.076172, -0.999964595, 0, -0.00842210278, 0, 1, -0, 0.00842210371, -0, -0.999964476))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(2846.53027, 1.49053204, 574.692749, -0.991879404, 0, 0.127182841, 0, 1.00000012, -0, -0.127182856, 0, -0.991879284))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(2838.22852, 1.49053216, 574.567993, -0.508367062, 3.00500669e-09, 0.86114049, 5.90910165e-09, 1, -1.17745082e-12, -0.86114049, 5.08796827e-09, -0.508367062))
        end

    elseif SelectedWorldName == "Orc Paradise" then
    if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-438.425415, 71.4885712, 3228.90723, -0.891522169, 0, 0.45297718, 0, 1.00000012, -0, -0.45297718, 0, -0.891522169))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-448.34671, 71.4885712, 3226.71851, -0.882656693, 0, 0.470018268, 0, 1, -0, -0.470018268, 0, -0.882656693))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-459.32666, 71.4885635, 3224.23096, -0.934073925, 0, 0.357079864, 0, 1, -0, -0.357079893, 0, -0.934073806))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-468.438538, 71.4885712, 3220.56274, -0.944450796, 0, 0.328652829, 0, 1, -0, -0.328652829, 0, -0.944450796))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-478.139679, 71.4885712, 3217.65601, -0.968081772, 0, 0.250634938, 0, 1.00000012, -0, -0.250634968, 0, -0.968081653))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-486.463348, 71.4885788, 3216.08032, -0.91034019, 1.19643504e-08, 0.413860738, 4.08833749e-08, 1, 6.10191506e-08, -0.413860738, 7.2468211e-08, -0.91034019))
        end

    elseif SelectedWorldName == "Heavenly Island" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-843.63147, 67.6951828, -5262.11377, -0.540441513, 0, -0.84138155, 0, 1, -0, 0.84138155, -0, -0.540441513))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-848.138611, 67.6951752, -5251.13037, -0.414766282, 0, -0.909928024, 0, 1.00000012, -0, 0.909928024, -0, -0.414766282))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-854.029236, 67.6951828, -5240.26074, -0.525166869, 0, -0.850999296, 0, 1.00000012, -0, 0.850999415, -0, -0.52516681))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-859.495789, 67.6951828, -5230.18799, -0.54235518, 0, -0.840149343, 0, 1, -0, 0.840149343, -0, -0.54235518))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-863.956787, 67.6951752, -5219.25537, -0.471052527, 0, -0.882105172, 0, 1, -0, 0.882105172, -0, -0.471052527))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-868.671448, 67.6951828, -5209.4585, -0.315498471, 6.26630436e-09, -0.948926091, 2.25653434e-08, 1, -8.98939423e-10, 0.948926091, -2.16964562e-08, -0.315498471))
        end

    elseif SelectedWorldName == "The Rift" then
        if BagPunchSelected == "Tier1" then
            TPArea(CFrame.new(-439.903107, -12.8557758, 761.22876, 0.275226682, 0, -0.961379349, -0, 1, -0, 0.961379349, 0, 0.275226682))
        elseif BagPunchSelected == "Tier2" then
            TPArea(CFrame.new(-433.697296, -12.8557758, 768.474182, 0.617868841, 0, -0.786281168, -0, 1, -0, 0.786281168, 0, 0.617868841))
        elseif BagPunchSelected == "Tier3" then
            TPArea(CFrame.new(-428.270813, -12.8557768, 774.812805, 0.533799827, 0, -0.845610857, -0, 1, -0, 0.845610857, 0, 0.533799827))
        elseif BagPunchSelected == "Tier4" then
            TPArea(CFrame.new(-421.922485, -12.8557758, 779.55249, 0.396557152, 0, -0.918009996, -0, 1, -0, 0.918010116, 0, 0.396557093))
        elseif BagPunchSelected == "Tier5" then
            TPArea(CFrame.new(-417.187225, -12.8557758, 787.157837, 0.711408854, 0, -0.702778399, -0, 1, -0, 0.702778399, 0, 0.711408854))
        elseif BagPunchSelected == "VIP" then
            TPArea(CFrame.new(-412.764526, -12.8557758, 792.086609, 0.352967829, -1.79194526e-08, -0.935635448, -2.73474878e-08, 1, -2.94689944e-08, 0.935635448, 3.59888865e-08, 0.352967829))
        end
    end
end


local function CheckPunch()
    local stat1 = PlayerStat.Biceps.Value
    local stat2 = PlayerStat.Hands.Value
    local stat3 = PlayerStat.Knuckles.Value
    local totalstat = stat3
    if SelectedWorldName == "School" then
        if totalstat == 0 or totalstat <= 400 then
            TPArea(CFrame.new(-10333.0137, 5.23331881, 4091.41162, -0.01870705, 0, 0.999825001, 0, 1, -0, -0.999825001, 0, -0.01870705))
            onGiveStats:FireServer("1", "Tier1")
        elseif totalstat == 400 or totalstat <= 3000 then
            TPArea(CFrame.new(-10345.6582, 5.23331833, 4089.54053, -0.939322531, 0, -0.34303537, 0, 1.00000012, -0, 0.34303537, -0, -0.939322531))
            onGiveStats:FireServer("1", "Tier2")
        elseif totalstat == 3000 or totalstat <= 15000 then
            TPArea(CFrame.new(-10354.1768, 5.23331881, 4068.00415, -0.972832441, 0, -0.231510445, 0, 1, -0, 0.231510445, -0, -0.972832441))
            onGiveStats:FireServer("1", "Tier3")
        elseif totalstat == 15000 or totalstat <= 38900 then
            TPArea(CFrame.new(-10353.0127, 5.23331881, 4078.67163, -0.148440063, 0, 0.988921404, 0, 1, -0, -0.988921404, 0, -0.148440063))
            onGiveStats:FireServer("1", "Tier4")
        elseif totalstat == 38900 or totalstat <= 100000 then
            TPArea(CFrame.new(-10353.9541, 5.23331785, 4059.25073, -0.995433033, 0, -0.0954622924, 0, 1, -0, 0.0954622924, -0, -0.995433033))
            onGiveStats:FireServer("1", "Tier5")
        elseif totalstat >= 100000 then
            TPArea(CFrame.new(-10351.7422, 5.23331928, 4051.05347, 0.948666573, -3.18870774e-09, 0.316277981, 2.80469621e-08, 1, -7.40440669e-08, -0.316277981, 7.9113768e-08, 0.948666573))
            onGiveStats:FireServer("1", "Tier6")
        end
    elseif SelectedWorldName == "Space" then
        if totalstat == 0 or totalstat <= 300000 then
            TPArea(CFrame.new(-10312.9844, -154.949097, 2804.17163, -0.0140013611, 0, 0.99990195, 0, 1, -0, -0.99990207, 0, -0.0140013592))
            onGiveStats:FireServer("2", "Tier1")
        elseif totalstat == 300000 or totalstat <= 750000 then
            TPArea(CFrame.new(-10312.1924, -154.949081, 2795.8855, 0.0397631377, 0, 0.999209166, 0, 1, -0, -0.999209166, 0, 0.0397631377))
            onGiveStats:FireServer("2", "Tier2")
        elseif totalstat == 750000 or totalstat <= 1250000 then
            TPArea(CFrame.new(-10311.6865, -154.949066, 2787.02295, -0.138817862, 0, 0.990317941, 0, 1, -0, -0.990317941, 0, -0.138817862))
            onGiveStats:FireServer("2", "Tier3")
        elseif totalstat == 1250000 or totalstat <= 2300000 then
            TPArea(CFrame.new(-10311.543, -154.949066, 2777.61792, -0.0653384775, 0, 0.997863114, 0, 1, -0, -0.997863233, 0, -0.06533847))
            onGiveStats:FireServer("2", "Tier4")
        elseif totalstat == 2300000 or totalstat <= 3750000 then
            TPArea(CFrame.new(-10311.8906, -154.949097, 2767.55933, 0.0101079652, 0, 0.999948859, 0, 1, -0, -0.999948978, 0, 0.0101079643))
            onGiveStats:FireServer("2", "Tier5")
        elseif totalstat >= 3750000 then
            TPArea(CFrame.new(-10310.9521, -154.949097, 2758.55029, 0.111349232, 0, 0.993781388, 0, 1.00000012, -0, -0.993781388, 0, 0.111349232))
            onGiveStats:FireServer("2", "Tier6")
        end
    elseif SelectedWorldName == "Beach" then
        if totalstat == 0 or totalstat <= 6750000 then
            TPArea(CFrame.new(11558.6787, 9.88073826, 127.701035, 0.388837308, 0, 0.921306431, 0, 1, -0, -0.921306431, 0, 0.388837308))
            onGiveStats:FireServer("3", "Tier1")
        elseif totalstat == 6750000 or totalstat <= 12000000 then
            TPArea(CFrame.new(11556.3896, 9.88073826, 117.506966, -0.56194371, 0, 0.827175498, 0, 1, -0, -0.827175498, 0, -0.56194371))
            onGiveStats:FireServer("3", "Tier2")
        elseif totalstat == 12000000 or totalstat <= 20400000 then
            TPArea(CFrame.new(11556.0283, 9.88073826, 109.48912, -0.496633857, 0, 0.867960155, 0, 1, -0, -0.867960155, 0, -0.496633857))
            onGiveStats:FireServer("3", "Tier3")
        elseif totalstat == 20400000 or totalstat <= 40800000 then
            TPArea(CFrame.new(11555.6895, 9.88073826, 101.532738, 0.341993362, 0, 0.939702332, 0, 1, -0, -0.939702451, 0, 0.341993332))
            onGiveStats:FireServer("3", "Tier4")
        elseif totalstat == 40800000 or totalstat <= 81600000 then
            TPArea(CFrame.new(11555.208, 9.88073826, 90.8077087, -0.489960104, 0, 0.871744931, 0, 1.00000012, -0, -0.871744931, 0, -0.489960104))
            onGiveStats:FireServer("3", "Tier5")
        elseif totalstat >= 81600000 then
            TPArea(CFrame.new(11554.8125, 9.88073826, 81.8547592, -0.282327443, 0, 0.959318101, 0, 1, -0, -0.959318101, 0, -0.282327443))
            onGiveStats:FireServer("3", "Tier6")
        end
    elseif SelectedWorldName == "Nuclear" then
        if totalstat == 0 or totalstat <= 302400000 then
            TPArea(CFrame.new(-10360.8809, 6.23877525, -889.909973, 0.719137967, 0, 0.694867432, 0, 1.00000012, -0, -0.694867432, 0, 0.719137967))
            onGiveStats:FireServer("4", "Tier1")
        elseif totalstat == 302400000 or totalstat <= 1512000000 then
            TPArea(CFrame.new(-10354.0449, 6.23877478, -894.323853, 0.668553412, 0, 0.743664145, 0, 1, -0, -0.743664145, 0, 0.668553412))
            onGiveStats:FireServer("4", "Tier2")
        elseif totalstat == 1512000000 or totalstat <= 7560000000 then
            TPArea(CFrame.new(-10347.4297, 6.23877478, -898.982117, 0.756246209, 0, 0.654287219, 0, 1.00000012, -0, -0.654287219, 0, 0.756246209))
            onGiveStats:FireServer("4", "Tier3")
        elseif totalstat >= 7560000000 then
            TPArea(CFrame.new(-10341.8145, 6.23877478, -904.149902, 0.909319699, 0, 0.416098177, 0, 1, -0, -0.416098177, 0, 0.909319699))
            onGiveStats:FireServer("4", "Tier4")
        end
    elseif SelectedWorldName == "The Void" then
        if totalstat == 0 or totalstat <= 2.16e+19 then
            TPArea(CFrame.new(428.126343, 40.2590561, -137.544189, -0.993069947, 0, -0.117525138, 0, 1.00000012, -0, 0.117525138, -0, -0.993069947))
            onGiveStats:FireServer("6", "Tier1")
        elseif totalstat == 2.16e+19 or totalstat <= 2.7e+19 then
            TPArea(CFrame.new(416.100769, 40.2590561, -135.599548, -0.989562273, 0, 0.144106343, 0, 1, -0, -0.144106358, 0, -0.989562154))
            onGiveStats:FireServer("6", "Tier2")
        elseif totalstat == 2.7e+19 or totalstat <= 3.6e+19 then
            TPArea(CFrame.new(402.214172, 40.2590561, -135.935806, -0.992473662, 0, -0.122458838, 0, 1.00000012, -0, 0.122458838, -0, -0.992473662))
            onGiveStats:FireServer("6", "Tier3")
        elseif totalstat == 3.6e+19 or totalstat <= 4.5e+19 then
            TPArea(CFrame.new(389.887787, 40.2590561, -137.885193, -0.983317912, 0, 0.181895196, 0, 1, -0, -0.181895196, 0, -0.983317912))
            onGiveStats:FireServer("6", "Tier4")
        elseif totalstat == 4.5e+19 or totalstat <= 5.4e+19 then
            TPArea(CFrame.new(383.9758, 40.2590599, -144.226501, 0.0482875444, 0, 0.998833537, 0, 1.00000012, -0, -0.998833537, 0, 0.0482875444))
            onGiveStats:FireServer("6", "Tier5")
        elseif totalstat >= 5.4e+19 then
            TPArea(CFrame.new(384.490723, 40.2590561, -158.568741, 0.119142972, 0, 0.992877066, 0, 1, -0, -0.992877185, 0, 0.119142957))
            onGiveStats:FireServer("6", "Tier6")
        end
    elseif SelectedWorldName == "Space Center" then
        if totalstat == 0 or totalstat <= 63000000000000000000 then
            TPArea(CFrame.new(-9709.16895, 46.9589653, 515.433777, 0.117800578, 0, 0.993037283, 0, 1, -0, -0.993037283, 0, 0.117800578))
            onGiveStats:FireServer("7", "Tier1")
        elseif totalstat == 63000000000000000000 or totalstat <= 72000000000000000000 then
            TPArea(CFrame.new(-9708.99805, 46.9589653, 494.919067, 0.0281911753, 0, 0.999602556, 0, 1, -0, -0.999602556, 0, 0.0281911753))
            onGiveStats:FireServer("7", "Tier2")
        elseif totalstat == 72000000000000000000 or totalstat <= 81000000000000000000 then
            TPArea(CFrame.new(-9708.55469, 46.9589653, 474.15799, 0.977341592, 2.68517031e-09, 0.211668208, 3.57621599e-09, 1, -2.91983149e-08, -0.211668208, 2.92936981e-08, 0.977341592))
            onGiveStats:FireServer("7", "Tier3")
        elseif totalstat == 81000000000000000000 or totalstat <= 90000000000000000000 then
            TPArea(CFrame.new(-9700.11523, 46.9589653, 460.796753, 0.743226886, 0, -0.669039488, -0, 1, -0, 0.669039488, 0, 0.743226886))
            onGiveStats:FireServer("7", "Tier4")
        elseif totalstat == 90000000000000000000 or totalstat <= 99000000000000000000 then
            TPArea(CFrame.new(-9682.22656, 46.9589767, 460.730377, 0.834624588, 0, -0.550819159, -0, 0.99999994, -0, 0.550819159, 0, 0.834624588))
            onGiveStats:FireServer("7", "Tier5")
        elseif totalstat >= 99000000000000000000 then
            TPArea(CFrame.new(-9662.43555, 46.9589691, 462.22464, 0.933089256, 0, 0.359644979, 0, 1.00000012, -0, -0.359644979, 0, 0.933089256))
            onGiveStats:FireServer("7", "Tier6")
        end
    elseif SelectedWorldName == "Roman Empire" then
        if totalstat == 0 or totalstat <= 2.2e+22 then
            TPArea(CFrame.new(-1562.02966, 47.7637024, 6.22029686, -0.828873873, -4.24696829e-08, 0.559435487, -8.47698232e-08, 1, -4.96818835e-08, -0.559435487, -8.86032652e-08, -0.828873873))
            onGiveStats:FireServer("8", "Tier1")
        elseif totalstat == 2.2e+22 or totalstat <= 3.8e+22 then
            TPArea(CFrame.new(-1562.65491, 47.7636909, -1.44569683, 0.24394539, 0, 0.969789028, 0, 1.00000012, -0, -0.969789028, 0, 0.24394539))
            onGiveStats:FireServer("8", "Tier2")
        elseif totalstat == 3.8e+22 or totalstat <= 4.5e+22 then
            TPArea(CFrame.new(-1562.41321, 47.7636909, -11.2723103, -0.15126887, 0, 0.988492668, 0, 1, -0, -0.988492668, 0, -0.15126887))
            onGiveStats:FireServer("8", "Tier3")
        elseif totalstat == 4.5e+22 or totalstat <= 6.1e+22 then
            TPArea(CFrame.new(-1560.91187, 47.7636909, -20.9894753, -0.305013329, 0, 0.952348113, 0, 1, -0, -0.952348113, 0, -0.305013329))
            onGiveStats:FireServer("8", "Tier4")
        elseif totalstat == 6.1e+22 or totalstat <= 7e+22 then
            TPArea(CFrame.new(-1561.73645, 47.7636909, -29.869421, -0.493594676, 0, 0.869692087, 0, 1, -0, -0.869692087, 0, -0.493594676))
            onGiveStats:FireServer("8", "Tier5")
        elseif totalstat >= 7e+22 then
            TPArea(CFrame.new(-1559.49524, 47.7637024, -38.8936501, -0.914466918, -2.64521098e-08, 0.404660642, -3.32189103e-08, 1, -9.70068736e-09, -0.404660642, -2.23133441e-08, -0.914466918))
            onGiveStats:FireServer("8", "Tier6")
        end
    elseif SelectedWorldName == "The Underworld" then
        if totalstat == 0 or totalstat <= 2.64e+22 then
            TPArea(CFrame.new(-12373.4277, 71.6354828, 1317.09814, 0.99847579, 0, 0.0551929176, 0, 1, -0, -0.055192925, 0, 0.998475671))
            onGiveStats:FireServer("9", "Tier1")
        elseif totalstat == 2.64e+22 or totalstat <= 5.700000000000001e+22 then
            TPArea(CFrame.new(-12367.1406, 71.6004944, 1318.70337, 0.983754694, 0, -0.179518223, -0, 1.00000012, -0, 0.179518223, 0, 0.983754694))
            onGiveStats:FireServer("9", "Tier2")
        elseif totalstat == 5.700000000000001e+22 or totalstat <= 8.1e+22 then
            TPArea(CFrame.new(-12358.1396, 71.6354752, 1317.59583, 0.938703358, 0, 0.344726026, 0, 1, -0, -0.344726026, 0, 0.938703358))
            onGiveStats:FireServer("9", "Tier3")
        elseif totalstat == 8.1e+22 or totalstat <= 1.4029999999999999e+23 then
            TPArea(CFrame.new(-12351.6816, 71.6354752, 1317.86304, 0.991702497, 0, 0.128554031, 0, 1, -0, -0.128554031, 0, 0.991702497))
            onGiveStats:FireServer("9", "Tier4")
        elseif totalstat == 1.4029999999999999e+23 or totalstat <= 1.82e+23 then
            TPArea(CFrame.new(-12344.8105, 71.6354752, 1318.04651, 0.996965051, 0, 0.0778509751, 0, 1.00000012, -0, -0.0778509751, 0, 0.996965051))
            onGiveStats:FireServer("9", "Tier5")
        elseif totalstat >= 1.82e+23 then
            TPArea(CFrame.new(-12338.1982, 71.5655136, 1318.87024, 0.998851895, 0, -0.0479071885, -0, 1.00000012, -0, 0.047907196, 0, 0.998851776))
            onGiveStats:FireServer("9", "Tier6")
        end
    elseif SelectedWorldName == "Magic Forest" then
        if totalstat == 0 or totalstat <= 1e+24 then
            TPArea(CFrame.new(-6145.56006, -96.0125732, -1492.05005, -0.992135465, 0, -0.125168845, 0, 1, -0, 0.125168845, -0, -0.992135465))
            onGiveStats:FireServer("10", "Tier1")
        elseif totalstat == 1e+24 or totalstat <= 2.3e+24 then
            TPArea(CFrame.new(-6151.93359, -96.0475616, -1491.81128, -0.999852359, 0, 0.0171877816, 0, 1, -0, -0.0171877835, 0, -0.99985224))
            onGiveStats:FireServer("10", "Tier2")
        elseif totalstat == 2.3e+24 or totalstat <= 4e+24 then
            TPArea(CFrame.new(-6160.08691, -96.0825348, -1491.55298, -0.999306202, 0, 0.0372449532, 0, 0.99999994, -0, -0.0372449569, 0, -0.999306083))
            onGiveStats:FireServer("10", "Tier3")
        elseif totalstat == 4e+24 or totalstat <= 4.9e+24 then
            TPArea(CFrame.new(-6168.3833, -96.0825348, -1491.44812, -0.999502778, 0, -0.0315319486, 0, 1, -0, 0.0315319486, -0, -0.999502778))
            onGiveStats:FireServer("10", "Tier4")
        elseif totalstat == 4.9e+24 or totalstat <= 5.5e+24 then
            TPArea(CFrame.new(-6176.55957, -96.0825348, -1491.34436, -0.999725223, 0, -0.0234416425, 0, 1, -0, 0.0234416425, -0, -0.999725223))
            onGiveStats:FireServer("10", "Tier5")
        elseif totalstat >= 5.5e+24 then
            TPArea(CFrame.new(-6184.63525, -96.0825348, -1489.90881, -0.99895972, 0, -0.0456031673, 0, 1, -0, 0.045603171, -0, -0.998959601))
            onGiveStats:FireServer("10", "Tier6")
        end
    
    elseif SelectedWorldName == "Snowy Peaks" then
        if totalstat == 0 or totalstat <= 7e+24 then
            TPArea(CFrame.new(1675.96362, -8.37515545, 2156.54492, 0.902372301, 0, -0.430957526, -0, 1.00000012, -0, 0.430957586, 0, 0.902372181))
            onGiveStats:FireServer("11", "Tier1")
        elseif totalstat == 7e+24 or totalstat <= 8.5e+24 then
            TPArea(CFrame.new(1683.53333, -8.37515545, 2159.3689, 0.790528119, 0, -0.612425864, -0, 1.00000012, -0, 0.612425923, 0, 0.790527999))
            onGiveStats:FireServer("11", "Tier2")
        elseif totalstat == 8.5e+24 or totalstat <= 9.999999999999999e+24 then
            TPArea(CFrame.new(1694.11938, -8.37515354, 2161.70996, 0.836271584, 0, -0.548315525, -0, 1.00000012, -0, 0.548315525, 0, 0.836271584))
            onGiveStats:FireServer("11", "Tier3")
        elseif totalstat == 9.999999999999999e+24 or totalstat <= 1.2e+25 then
            TPArea(CFrame.new(1702.93567, -8.37515545, 2164.92871, 0.815602183, 0, -0.578613162, -0, 1.00000012, -0, 0.578613162, 0, 0.815602183))
            onGiveStats:FireServer("11", "Tier4")
        elseif totalstat == 1.2e+25 or totalstat <= 1.35e+25 then
            TPArea(CFrame.new(1710.94727, -8.37515545, 2169.18896, 0.761875272, 0, -0.647723794, -0, 1, -0, 0.647723794, 0, 0.761875272))
            onGiveStats:FireServer("11", "Tier5")
        elseif totalstat >= 1.35e+25 then
            TPArea(CFrame.new(1719.70874, -8.37515545, 2172.68237, 0.804367423, 0, -0.594132245, -0, 1, -0, 0.594132304, 0, 0.804367304))
            onGiveStats:FireServer("11", "Tier6")
        end
    
    elseif SelectedWorldName == "Dusty Tavern" then
        if totalstat == 0 or totalstat <= 7e+24 then
            TPArea(CFrame.new(2975.7002, -3.12988043, -3893.54565, -0.981103122, 0, -0.193485513, 0, 1, -0, 0.193485513, -0, -0.981103122))
            onGiveStats:FireServer("12", "Tier1")
        elseif totalstat == 7e+24 or totalstat <= 8.5e+24 then
            TPArea(CFrame.new(2964.32251, -3.12988043, -3889.89087, -0.981720269, 0, -0.19032985, 0, 1, -0, 0.19032988, -0, -0.98172015))
            onGiveStats:FireServer("12", "Tier2")
        elseif totalstat == 8.5e+24 or totalstat <= 9.999999999999999e+24 then
            TPArea(CFrame.new(2952.46875, -3.12988043, -3887.46631, -0.968761265, 0, -0.247995555, 0, 1.00000012, -0, 0.247995585, -0, -0.968761146))
            onGiveStats:FireServer("12", "Tier3")
        elseif totalstat == 9.999999999999999e+24 or totalstat <= 1.2e+25 then
        TPArea(CFrame.new(2942.28833, -3.12988043, -3883.55859, -0.972948849, 0, -0.231020719, 0, 1, -0, 0.231020719, -0, -0.972948849))
            onGiveStats:FireServer("12", "Tier4")
        elseif totalstat >= 1.2e+25 then
            TPArea(CFrame.new(2931.00586, -3.12987995, -3881.18262, -0.97906369, 0, -0.203554377, 0, 1, -0, 0.203554407, -0, -0.97906357))
            onGiveStats:FireServer("12", "Tier5")
        end
    
    elseif SelectedWorldName == "Lost Kingdom" then
        if totalstat == 0 or totalstat <= 7e+24 then
            TPArea(CFrame.new(2883.69385, 1.49053204, 574.641479, -0.999920785, 0, -0.0125937071, 0, 1, -0, 0.0125937089, -0, -0.999920666))
            onGiveStats:FireServer("13", "Tier1")
        elseif totalstat == 7e+24 or totalstat <= 8.5e+24 then
            TPArea(CFrame.new(2873.82373, 1.49053204, 574.340759, -0.998228192, 0, 0.059502285, 0, 1.00000012, -0, -0.059502285, 0, -0.998228192))
            onGiveStats:FireServer("13", "Tier2")
        elseif totalstat == 8.5e+24 or totalstat <= 9.999999999999999e+24 then
            TPArea(CFrame.new(2865.50537, 1.49053228, 575.482727, -0.954454303, 0, 0.298357189, 0, 1, -0, -0.298357189, 0, -0.954454303))
            onGiveStats:FireServer("13", "Tier3")
        elseif totalstat == 9.999999999999999e+24 or totalstat <= 1.2e+25 then
            TPArea(CFrame.new(2855.67554, 1.49053204, 575.076172, -0.999964595, 0, -0.00842210278, 0, 1, -0, 0.00842210371, -0, -0.999964476))
            onGiveStats:FireServer("13", "Tier4")
        elseif totalstat >= 1.2e+25 then
            TPArea(CFrame.new(2846.53027, 1.49053204, 574.692749, -0.991879404, 0, 0.127182841, 0, 1.00000012, -0, -0.127182856, 0, -0.991879284))
            onGiveStats:FireServer("13", "Tier5")
        end
    
    elseif SelectedWorldName == "Orc Paradise" then
        if totalstat == 0 or totalstat <= 1.2e+25 then
            TPArea(CFrame.new(-438.425415, 71.4885712, 3228.90723, -0.891522169, 0, 0.45297718, 0, 1.00000012, -0, -0.45297718, 0, -0.891522169))
            onGiveStats:FireServer("14", "Tier1")
        elseif totalstat == 1.2e+25 or totalstat <= 1.7e+25 then
            TPArea(CFrame.new(-448.34671, 71.4885712, 3226.71851, -0.882656693, 0, 0.470018268, 0, 1, -0, -0.470018268, 0, -0.882656693))
            onGiveStats:FireServer("14", "Tier2")
        elseif totalstat == 1.7e+25 or totalstat <= 2.1e+25 then
            TPArea(CFrame.new(-459.32666, 71.4885635, 3224.23096, -0.934073925, 0, 0.357079864, 0, 1, -0, -0.357079893, 0, -0.934073806))
            onGiveStats:FireServer("14", "Tier3")
        elseif totalstat == 2.1e+25 or totalstat <= 3e+25 then
            TPArea(CFrame.new(-468.438538, 71.4885712, 3220.56274, -0.944450796, 0, 0.328652829, 0, 1, -0, -0.328652829, 0, -0.944450796))
            onGiveStats:FireServer("14", "Tier4")
        elseif totalstat >= 3e+25 then
            TPArea(CFrame.new(-478.139679, 71.4885712, 3217.65601, -0.968081772, 0, 0.250634938, 0, 1.00000012, -0, -0.250634968, 0, -0.968081653))
            onGiveStats:FireServer("14", "Tier5")
        end
        elseif SelectedWorldName == "Heavenly Island" then
        if totalstat == 0 or totalstat <= 1.2e+25 then
            TPArea(CFrame.new(-843.63147, 67.6951828, -5262.11377, -0.540441513, 0, -0.84138155, 0, 1, -0, 0.84138155, -0, -0.540441513))
            onGiveStats:FireServer("15", "Tier1")
        elseif totalstat == 1.2e+25 or totalstat <= 1.7e+25 then
            TPArea(CFrame.new(-848.138611, 67.6951752, -5251.13037, -0.414766282, 0, -0.909928024, 0, 1.00000012, -0, 0.909928024, -0, -0.414766282))
            onGiveStats:FireServer("15", "Tier2")
        elseif totalstat == 1.7e+25 or totalstat <= 2.1e+25 then
            TPArea(CFrame.new(-854.029236, 67.6951828, -5240.26074, -0.525166869, 0, -0.850999296, 0, 1.00000012, -0, 0.850999415, -0, -0.52516681))
            onGiveStats:FireServer("15", "Tier3")
        elseif totalstat == 2.1e+25 or totalstat <= 3e+25 then
        TPArea(CFrame.new(-859.495789, 67.6951828, -5230.18799, -0.54235518, 0, -0.840149343, 0, 1, -0, 0.840149343, -0, -0.54235518))
            onGiveStats:FireServer("15", "Tier4")
        elseif totalstat >= 3e+25 then
            TPArea(CFrame.new(-863.956787, 67.6951752, -5219.25537, -0.471052527, 0, -0.882105172, 0, 1, -0, 0.882105172, -0, -0.471052527))
            onGiveStats:FireServer("15", "Tier5")
        end
    
    elseif SelectedWorldName == "The Rift" then
        if totalstat == 0 or totalstat <= 5e+25 then
            TPArea(CFrame.new(-439.903107, -12.8557758, 761.22876, 0.275226682, 0, -0.961379349, -0, 1, -0, 0.961379349, 0, 0.275226682))
            onGiveStats:FireServer("16", "Tier1")
        elseif totalstat == 5e+25 or totalstat <= 6e+25 then
            TPArea(CFrame.new(-433.697296, -12.8557758, 768.474182, 0.617868841, 0, -0.786281168, -0, 1, -0, 0.786281168, 0, 0.617868841))
            onGiveStats:FireServer("16", "Tier2")
        elseif totalstat == 6e+25 or totalstat <= 7e+25 then
            TPArea(CFrame.new(-428.270813, -12.8557768, 774.812805, 0.533799827, 0, -0.845610857, -0, 1, -0, 0.845610857, 0, 0.533799827))
            onGiveStats:FireServer("16", "Tier3")
        elseif totalstat == 7e+25 or totalstat <= 7.999999999999999e+25 then
            TPArea(CFrame.new(-421.922485, -12.8557758, 779.55249, 0.396557152, 0, -0.918009996, -0, 1, -0, 0.918010116, 0, 0.396557093))
            onGiveStats:FireServer("16", "Tier4")
        elseif totalstat >= 7.999999999999999e+25 then
            TPArea(CFrame.new(-417.187225, -12.8557758, 787.157837, 0.711408854, 0, -0.702778399, -0, 1, -0, 0.702778399, 0, 0.711408854))
            onGiveStats:FireServer("16", "Tier5")
        end
    end
end
Section:CreateToggle("Auto Farm Knuckle", function(Value)
    AutoKnucklesFarm = Value

    while AutoKnucklesFarm do wait()
        pcall(function()
            CheckPunch()
        end)
    end
end)
Section:CreateLabel("Note", " ----- Farm -----")
-- Auto Rebirth
Section:CreateToggle("Auto Rebirth", function(bool)
    getgenv().autoRebirth = bool
    while getgenv().autoRebirth and wait() do
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("RebirthService"):WaitForChild("RE"):WaitForChild("onRebirthRequest"):FireServer()
        task.wait()
    end
end)
HideNotificationSetting = true

Section:CreateToggle("Hide Notifications", function(Value)
    HideNotificationSetting = Value
end)

task.spawn(function()
    while true do
        game.Players.LocalPlayer.PlayerGui.Notification.Enabled = not HideNotificationSetting
        task.wait(1) -- Hindari high CPU usage dengan delay
    end
end)

local plr = game:GetService("Players").LocalPlayer
local questString = plr.PlayerGui.GameUI.Menus.QuestTokens.RandomQuestString
local questAmount = plr.PlayerGui.GameUI.Menus.QuestTokens.Battles.TextLabel

local function Train(quest)
    local questLower = quest:lower()
    if questLower:find("knuckle") then
        CheckPunch()
    elseif questLower:find("dumbell") then
        CheckDumbells()
    elseif questLower:find("grip") then
        CheckGrips()
    elseif questLower:find("barbell") then
        CheckBarbells()
    end
end

local loop
local toggle = Section:CreateToggle("Auto Quest", function(state)
    if state then
        loop = task.spawn(function()
            while task.wait() do
                if questString.Text ~= "" and questAmount.Text ~= "" then
                    local current, max = questAmount.Text:match("(%d+)/(%d+)")
                    current, max = tonumber(current), tonumber(max)

                    if current and max then
                        if current >= max then
                            repeat task.wait() until questAmount.Text:find("0/") -- Tunggu sampai balik ke 0
                        else
                            Train(questString.Text)
                        end
                    end
                end
            end
        end)
    else
        if loop then
            task.cancel(loop)
        end
    end
end, "Auto finish token quest")
-- Auto Super Rebirth
Section:CreateToggle("Auto Super Rebirth", function(bool)
    getgenv().autoSuperRebirth = bool
    while getgenv().autoSuperRebirth and wait() do
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("RebirthService"):WaitForChild("RE"):WaitForChild("onSuperRebirth"):FireServer()
        task.wait(0.5)
    end
end)
Section:CreateToggle("Auto Click Train", function(bool)
    getgenv().autoClick = bool
    while getgenv().autoClick and wait() do
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RE"):WaitForChild("onClick"):FireServer()
        task.wait()
    end
end)
local DataZone = nil
function UpdateDataZone()
    if SelectedZone == "Zone 1 (School)" then
        DataZone = "1"
    elseif SelectedZone == "Zone 2 (Space Gym)" then
        DataZone = "2"
    elseif SelectedZone == "Zone 3 (Beach)" then
        DataZone = "3"
    elseif SelectedZone == "Zone 4 (Bunker)" then
        DataZone = "4"
    elseif SelectedZone == "Zone 5 (Dino)" then
        DataZone = "5"
    elseif SelectedZone == "Zone 6 (Void)" then
        DataZone = "6"
    elseif SelectedZone == "Zone 7 (Space Center)" then
        DataZone = "7"
    elseif SelectedZone == "Zone 8 (Roman Empire)" then
        DataZone = "8"
    elseif SelectedZone == "Zone 9 (Underworld)" then
        DataZone = "9"
    elseif SelectedZone == "Zone 10 (Magic Forest)" then
        DataZone = "10"
    elseif SelectedZone == "Zone 11 (Snowy Peaks)" then
        DataZone = "11"
    elseif SelectedZone == "Zone 12 (Dusty Tavern)" then
        DataZone = "12"
    elseif SelectedZone == "Zone 13 (Lost Kingdom)" then
        DataZone = "13"
    elseif SelectedZone == "Zone 14 (Orc Paradise)" then
        DataZone = "14"
    elseif SelectedZone == "Zone 15 (Heavenly Island)" then
        DataZone = "15"
    elseif SelectedZone == "Zone 16 (The Rift)" then
        DataZone = "16"
    end
end
Section:CreateLabel("Note", " ----- Teleporter -----")
local ZoneList =  {
    "Zone 1 (School)"; "Zone 2 (Space Gym)"; "Zone 3 (Beach)"; "Zone 4 (Bunker)"; "Zone 5 (Dino)"; "Zone 6 (Void)"; "Zone 7 (Space Center)"; "Zone 8 (Roman Empire)"; "Zone 9 (Underworld)"; "Zone 10 (Magic Forest)";
    "Zone 11 (Snowy Peaks)"; "Zone 12 (Dusty Tavern)"; "Zone 13 (Lost Kingdom)"; "Zone 14 (Orc Paradise)"; "Zone 15 (Heavenly Island)"; "Zone 16 (The Rift)"; "Zone 17 (The Matrix)"; "Zone 18 (Striker)";
}
Section:CreateDropdown("Select Zones", ZoneList, 1, function(Value)
    SelectedZone = Value
    UpdateDataZone()
end)

Section:CreateButton("Teleport to Zone", function()
    if SelectedZone == "Zone 1 (School)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["1"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 2 (Space Gym)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["2"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 3 (Beach)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["3"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 4 (Bunker)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["4"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 5 (Dino)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["5"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 6 (Void)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["6"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 7 (Space Center)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["7"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 8 (Roman Empire)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["8"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 9 (Underworld)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["9"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 10 (Magic Forest)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["10"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 11 (Snowy Peaks)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["11"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 12 (Dusty Tavern)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["12"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 13 (Lost Kingdom)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["13"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 14 (Orc Paradise)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["14"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 15 (Heavenly Island)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["15"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
    elseif SelectedZone == "Zone 16 (The Rift)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["16"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
        elseif SelectedZone == "Zone 17 (The Matrix)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["17"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
        elseif SelectedZone == "Zone 18 (Socces)" then
        local args = {
            [1] = game:GetService("Workspace").Zones["18"].Interactables.Teleports.Locations.Spawn
        }
        teleport:FireServer(unpack(args))
        
    end
end)
Section:CreateLabel("Note", " ----- Pets -----")
local craftsP = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("craft")
local deletesP = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("delete")
local equipBest = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("equipBest")
local unequipAll = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("unequipAll")
local updateLocked = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("updateLocked")
Section:CreateButton("Equip Best Pets", function()
    local args = {
        [1] = game:GetService("Players").LocalPlayer
    }
    equipBest:InvokeServer(unpack(args))
end)

Section:CreateButton("Unequip Pets", function()
    local args = {
        [1] = game:GetService("Players").LocalPlayer
    }
    unequipAll:InvokeServer(unpack(args))
end)

Section:CreateButton("Lock All Pets", function()
    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Inventory.Display.Pets.ScrollingFrame.Pets:GetChildren()) do
        if v:IsA("Frame") then
            local lockToggle = v:FindFirstChild("Toggle")
            if lockToggle and lockToggle:FindFirstChild("LockPet") and not lockToggle.LockPet.Visible then
                updateLocked:InvokeServer({ [v.Name] = true })
                wait()
                lockToggle.LockPet.Visible = true
            end
        end
    end
end)

Section:CreateButton("Unlock All Pets", function()
    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Inventory.Display.Pets.ScrollingFrame.Pets:GetChildren()) do
        if v:IsA("Frame") then
            local lockToggle = v:FindFirstChild("Toggle")
            if lockToggle and lockToggle:FindFirstChild("LockPet") and lockToggle.LockPet.Visible then
                updateLocked:InvokeServer({ [v.Name] = false })
                wait()
                lockToggle.LockPet.Visible = false
            end
        end
    end
end)
local CommonPet = false
local UncommonPet = false
local RarePet = false
local EpicPet = false
local LegendaryPet = false
local MythicPet = false
local OmegaPet = false
local ExclusivePet = false
Section:CreateToggle("Common Pets", function(Value)
    CommonPet = Value
end)

Section:CreateToggle("Uncommon Pets", function(Value)
    UncommonPet = Value
end)

Section:CreateToggle("Rare Pets", function(Value)
    RarePet = Value
end)

Section:CreateToggle("Epic Pets", function(Value)
    EpicPet = Value
end)

Section:CreateToggle("Legendary Pets", function(Value)
    LegendaryPet = Value
end)

Section:CreateToggle("Mythic Pets", function(Value)
    MythicPet = Value
end)

Section:CreateToggle("Omega Pets", function(Value)
    OmegaPet = Value
end)

Section:CreateToggle("Exclusive Pets", function(Value)
    ExclusivePet = Value
end)

local ExclusiveColor = Color3.fromRGB(255, 200, 1)
local OmegaColor = Color3.fromRGB(120, 0, 166)
local MychicalColor = Color3.fromRGB(31, 31, 31)
local LegendaryColor = Color3.fromRGB(255, 152, 0)
local EpicColor = Color3.fromRGB(233, 0, 247)
local RareColor = Color3.fromRGB(0, 116, 255)
local UncommonColor = Color3.fromRGB(0, 218, 4)
local CommonColor = Color3.fromRGB(181, 181, 181)
--[[local function DeletesPet(rarityName)
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.PetInventory.Container.ScrollingFrame.Pets:GetChildren()) do
        if v:IsA('Frame') then
            if v.Toggle.SpikeyBackground.ImageColor3 == rarityName then
                deletesP:InvokeServer(v.Name)
            end
        end
    end
end]]

local function DeletesPet(rarityName)
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Inventory.Display.Pets.ScrollingFrame.Pets:GetChildren()) do
        if v:IsA('Frame') then
            if v.Toggle.SpikeyBackground.ImageColor3 == rarityName then
                deletesP:InvokeServer(v.Name)
            end
        end
    end
end
local function CraftPets(RarityName)
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Inventory.Display.Pets.ScrollingFrame.Pets:GetChildren()) do
        if v:IsA('Frame') then
            if v.Toggle.SpikeyBackground.ImageColor3 == RarityName then
                local args = {
                    [1] = v.Name,
                    [2] = true
                }
                craftsP:InvokeServer(unpack(args))
            end
        end
    end
end
local CraftPetsFunc = false

Section:CreateToggle("Auto Craft Pets by Rarity", function(Value)
    CraftPetsFunc = Value

    while CraftPetsFunc do
        wait()
        pcall(function()
            if ExclusivePet then CraftPets(ExclusiveColor) end
            if OmegaPet then CraftPets(OmegaColor) end
            if MythicPet then CraftPets(MychicalColor) end
            if LegendaryPet then CraftPets(LegendaryColor) end
            if EpicPet then CraftPets(EpicColor) end
            if RarePet then CraftPets(RareColor) end
            if UncommonPet then CraftPets(UncommonColor) end
            if CommonPet then CraftPets(CommonColor) end
        end)
    end
end)

Section:CreateLabel("Note", "Don't missclick")
Section:CreateToggle("Auto Delete Pets by Rarity", function(Value)
    DeletePetsFunc = Value

    while DeletePetsFunc do
        wait()
        pcall(function()
            if ExclusivePet then DeletesPet(ExclusiveColor) end
            if OmegaPet then DeletesPet(OmegaColor) end
            if MythicPet then DeletesPet(MychicalColor) end
            if LegendaryPet then DeletesPet(LegendaryColor) end
            if EpicPet then DeletesPet(EpicColor) end
            if RarePet then DeletesPet(RareColor) end
            if UncommonPet then DeletesPet(UncommonColor) end
            if CommonPet then DeletesPet(CommonColor) end
        end)
    end
end)
Section:CreateLabel("Note", " ----- Arms -----")
local function UpdateLockArm(rarityName, Value1, Value2)
    local UpdateArmLocks = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("UpdateArmLocks")
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Arms.Container.Arms:GetChildren()) do
        if v:IsA('Frame') then
            if v.Toggle.LockPet.Visible == Value1 then
                if v:FindFirstChild('Toggle').CircleBackground.BackgroundColor3 == rarityName then
                    UpdateArmLocks:InvokeServer({[v.Name] = Value2})
                    wait()
                    v.Toggle.LockPet.Visible = Value2
                end
            end
        end
    end
end
local CommonArm = false
local UncommonArm = false
local RareArm = false
local EpicArm = false
local LegendaryArm = false
local MythicArm = false
local OmegaArm = false
local ExclusiveArm = false

Section:CreateToggle('Common Arm', function(Value)
    CommonArm = Value
end)

Section:CreateToggle('Uncommon Arm', function(Value)
    UncommonArm = Value
end)

Section:CreateToggle('Rare Arm', function(Value)
    RareArm = Value
end)

Section:CreateToggle('Epic Arm', function(Value)
    EpicArm = Value
end)

Section:CreateToggle('Legendary Arm', function(Value)
    LegendaryArm = Value
end)

Section:CreateToggle('Mythic Arm', function(Value)
    MythicArm = Value
end)

Section:CreateToggle('Omega Arm', function(Value)
    OmegaArm = Value
end)

Section:CreateToggle('Exclusive Arm', function(Value)
    ExclusiveArm = Value
end)
local function UpdateDeleteArms(rarityName)
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Arms.Container.Arms:GetChildren()) do
        if v:IsA('Frame') then
            if v.Toggle.CircleBackground.BackgroundColor3 == rarityName then
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("DeleteArms"):InvokeServer({v.Name})
            end
        end
    end
end
Section:CreateToggle('Delete Arm by Rarities', function(Value)
    DeleteArms = Value

    while DeleteArms do wait()
        pcall(function()
            if CommonArm then UpdateDeleteArms(CommonColor) end
            if UncommonArm then UpdateDeleteArms(UncommonColor) end
            if RareArm then UpdateDeleteArms(RareColor) end
            if EpicArm then UpdateDeleteArms(EpicColor) end
            if LegendaryArm then UpdateDeleteArms(LegendaryColor) end
            if MythicArm then UpdateDeleteArms(MychicalColor) end
            if OmegaArm then UpdateDeleteArms(OmegaColor) end
            if ExclusiveArm then UpdateDeleteArms(ExclusiveColor) end
        end)
    end
end)

local LockArm = false
local UnlockArm = false

Section:CreateToggle("Lock Arm by Rarities", function(Value)
    LockArm = Value

    while LockArm do
        wait()
        pcall(function()
            if CommonArm then UpdateLockArm(CommonColor, false, true) end
            if UncommonArm then UpdateLockArm(UncommonColor, false, true) end
            if RareArm then UpdateLockArm(RareColor, false, true) end
            if EpicArm then UpdateLockArm(EpicColor, false, true) end
            if LegendaryArm then UpdateLockArm(LegendaryColor, false, true) end
            if MythicArm then UpdateLockArm(MychicalColor, false, true) end
            if OmegaArm then UpdateLockArm(OmegaColor, false, true) end
            if ExclusiveArm then UpdateLockArm(ExclusiveColor, false, true) end
        end)
    end
end)

Section:CreateToggle("Unlock Arm by Rarities", function(Value)
    UnlockArm = Value

    while UnlockArm do
        wait()
        pcall(function()
            if CommonArm then UpdateLockArm(CommonColor, true, false) end
            if UncommonArm then UpdateLockArm(UncommonColor, true, false) end
            if RareArm then UpdateLockArm(RareColor, true, false) end
            if EpicArm then UpdateLockArm(EpicColor, true, false) end
            if LegendaryArm then UpdateLockArm(LegendaryColor, true, false) end
            if MythicArm then UpdateLockArm(MychicalColor, true, false) end
            if OmegaArm then UpdateLockArm(OmegaColor, true, false) end
            if ExclusiveArm then UpdateLockArm(ExclusiveColor, true, false) end
        end)
    end
end)

Section:CreateLabel("Note", " ----- Tower -----")
-- Global Variables
-- Global Variables
getgenv().AutoJoinBeachTower = false
getgenv().AutoJoinSuperWrestle = false
getgenv().AutoJoinRiftCave = false

getgenv().UseAllKeyBeach = false
getgenv().UseAllKeySuperWrestle = false
getgenv().UseAllKeyRiftCave = false

-- Fungsi untuk Auto Join Tower
local function StartAutoJoinTower(towerName, autoJoinVar, useAllKeyVar)
    while getgenv()[autoJoinVar] and task.wait(1) do
        local args = {
            [1] = towerName,
            [2] = getgenv()[useAllKeyVar]
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
            :WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF")
            :WaitForChild("EnterTower"):InvokeServer(unpack(args))

        task.wait(1) -- Delay agar tidak terlalu cepat spam
    end
end

-- Auto Join Beach Tower
local AutoJoinBeachToggle = Section:CreateToggle("Auto Join Beach Tower", function(state)
    getgenv().AutoJoinBeachTower = state
    if state then
        StartAutoJoinTower("BeachTower", "AutoJoinBeachTower", "UseAllKeyBeach")
    end
end)
local UseAllKeyBeachToggle = Section:CreateToggle("Use All Key (Beach)", function(state)
    getgenv().UseAllKeyBeach = state
end)

-- Auto Join Super Wrestle
local AutoJoinSuperWrestleToggle = Section:CreateToggle("Auto Join Super Wrestle", function(state)
    getgenv().AutoJoinSuperWrestle = state
    if state then
        StartAutoJoinTower("SuperWrestle", "AutoJoinSuperWrestle", "UseAllKeySuperWrestle")
    end
end)
local UseAllKeySuperWrestleToggle = Section:CreateToggle("Use All Key (Super Wrestle)", function(state)
    getgenv().UseAllKeySuperWrestle = state
end)

-- Auto Join Rift Cave
local AutoJoinRiftCaveToggle = Section:CreateToggle("Auto Join Rift Cave", function(state)
    getgenv().AutoJoinRiftCave = state
    if state then
        StartAutoJoinTower("RiftCave", "AutoJoinRiftCave", "UseAllKeyRiftCave")
    end
end)
local UseAllKeyRiftCaveToggle = Section:CreateToggle("Use All Key (Rift Cave)", function(state)
    getgenv().UseAllKeyRiftCave = state
end)




-- Auto Click Train

Section:CreateLabel("Note", "----- Farmer plants -----")
-- Global Variables
getgenv().SelectedPlant = nil
getgenv().AutoPlant = false
getgenv().AutoHarvest = false

-- Fungsi untuk mendapatkan daftar tanaman dari ReplicatedStorage.Assets.Plants
local function GetPlantList()
    local plants = {}
    local plantFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Assets") 
                        and game:GetService("ReplicatedStorage").Assets:FindFirstChild("Plants")
    if plantFolder then
        for _, plant in pairs(plantFolder:GetChildren()) do
            if plant:IsA("MeshPart") then
                table.insert(plants, plant.Name)
            end
        end
    end
    return plants
end

-- Fungsi untuk Auto Plant
local function StartAutoPlant()
    while getgenv().AutoPlant and task.wait(0.2) do
        if getgenv().SelectedPlant then
            for i = 1, 6 do
                local args = { getgenv().SelectedPlant,"1", tostring(i) }
                game:GetService("ReplicatedStorage"):WaitForChild("Packages")
                    :WaitForChild("Knit")
                    :WaitForChild("Services")
                    :WaitForChild("ItemPlantingService")
                    :WaitForChild("RF")
                    :WaitForChild("Plant")
                    :InvokeServer(unpack(args))
                task.wait(0.2)
            end
        end
    end
end

-- Fungsi untuk Auto Harvest
local function StartAutoHarvest()
    while getgenv().AutoHarvest and task.wait(0.2) do
        for i = 1, 6 do
            local args = { tostring(i) }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages")
                :WaitForChild("Knit")
                :WaitForChild("Services")
                :WaitForChild("ItemPlantingService")
                :WaitForChild("RF")
                :WaitForChild("Harvest")
                :InvokeServer(unpack(args))
            task.wait(0.2)
        end
    end
end

-- Pastikan variabel section sudah terdefinisi (misalnya NinjaSection)
-- Jika menggunakan tab atau section lain, ganti "NinjaSection" dengan variabel yang sesuai.
local PlantDropdown = Section:CreateDropdown("Select Plant", GetPlantList(), 1, function(selected)
    if selected and selected ~= "" then
        getgenv().SelectedPlant = selected
    end
end)

local AutoPlantToggle = Section:CreateToggle("Auto Plant", function(state)
    getgenv().AutoPlant = state
    if state then
        StartAutoPlant()
    end
end)

local AutoHarvestToggle = Section:CreateToggle("Auto Harvest", function(state)
    getgenv().AutoHarvest = state
    if state then
        StartAutoHarvest()
    end
end)

-- Fungsi untuk Refresh Dropdown (hanya jika method Refresh tersedia)
local function RefreshPlantDropdown()
    if PlantDropdown and type(PlantDropdown.Refresh) == "function" then
        PlantDropdown.Refresh(GetPlantList(), 1, function(selected)
            if selected and selected ~= "" then
                getgenv().SelectedPlant = selected
            end
        end)
    end
end
-- Global Variables
getgenv().AutoUpgrade = false

-- Fungsi untuk mendapatkan daftar tanaman dari ReplicatedStorage
local function GetPlantList()
    local plants = {}
    local plantFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Assets") and 
                        game:GetService("ReplicatedStorage").Assets:FindFirstChild("Plants")

    if plantFolder then
        for _, plant in pairs(plantFolder:GetChildren()) do
            if plant:IsA("MeshPart") then
                table.insert(plants, plant.Name)
            end
        end
    end
    return plants
end

-- Fungsi untuk menjalankan Auto Upgrade
local function StartAutoUpgrade()
    while getgenv().AutoUpgrade and task.wait(0.2) do
        local plantList = GetPlantList()
        for _, plantName in ipairs(plantList) do
            for tier = 1, 3 do
                local args = {
                    [1] = {
                        ["Item"] = plantName,
                        ["Tier"] = tier
                    }
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
                    :WaitForChild("Services"):WaitForChild("ItemCraftingService"):WaitForChild("RF")
                    :WaitForChild("UpgradeSnack"):InvokeServer(unpack(args))

                task.wait(0.2) -- Delay kecil untuk menghindari spam berlebihan
            end
        end
    end
end

-- Toggle untuk Auto Upgrade
local AutoUpgradeToggle = Section:CreateToggle("Auto Upgrade Fruits", function(state)
    getgenv().AutoUpgrade = state
    if state then
        StartAutoUpgrade()
    end
end)



Section:CreateLabel("Note", "----- Merchant -----")
-- Global variable untuk menyimpan merchant yang dipilih
getgenv().SelectedMerchant = nil

-- Fungsi untuk mendapatkan daftar merchant dari dua lokasi
local function GetMerchants()
    local merchants = {}

    -- Ambil merchant dari workspace.GameObjects.Merchants
    local merchantsFolder = workspace.GameObjects:FindFirstChild("Merchants")
    if merchantsFolder then
        for _, merchant in pairs(merchantsFolder:GetChildren()) do
            if merchant:IsA("Model") then
                table.insert(merchants, merchant.Name)
            end
        end
    end

    -- Ambil merchant dari workspace.GameObjects.LimitedMerchants
    local limitedMerchantsFolder = workspace.GameObjects:FindFirstChild("LimitedMerchants")
    if limitedMerchantsFolder then
        for _, merchant in pairs(limitedMerchantsFolder:GetChildren()) do
            if merchant:IsA("Model") then
                table.insert(merchants, merchant.Name)
            end
        end
    end

    return merchants
end

-- Fungsi untuk teleport ke merchant yang dipilih
local function TeleportToMerchant()
    if getgenv().SelectedMerchant then
        local merchantModel = workspace.GameObjects.Merchants:FindFirstChild(getgenv().SelectedMerchant) or
                              workspace.GameObjects.LimitedMerchants:FindFirstChild(getgenv().SelectedMerchant)

        if merchantModel and merchantModel:GetPivot() then
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:PivotTo(merchantModel:GetPivot())
            end
        end
    end
end

-- Buat Dropdown Merchant
local merchantDropdown = Section:CreateDropdown("Select Merchant", GetMerchants(), 1, function(selected)
    getgenv().SelectedMerchant = selected
end)

-- Buat Tombol Teleport
Section:CreateButton("Teleport", function()
    TeleportToMerchant()
end)

-- Fungsi untuk refresh daftar merchant
local function RefreshMerchantDropdown()
    if merchantDropdown and merchantDropdown.Refresh then
        merchantDropdown.Refresh(GetMerchants(), 1, function(selected)
            getgenv().SelectedMerchant = selected
        end)
    end
end

-- Refresh daftar merchant saat pertama kali dibuat
RefreshMerchantDropdown()

local MaTab = MainWindow:CreateTab("Spin")
local MainSection = MaTab:CreateSection("Main")
local plrs = game:GetService("Players")
local player = plrs.LocalPlayer

-- Variabel penyimpanan
local tellerGui, textLabel = nil, nil
local autoRollEnabled = false  -- Status Auto Roll
local showResultsEnabled = false  -- Status Show Results
local lastResult = "Turned off"  -- Hasil terakhir saat Auto Roll mati

local function createTellerGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "teller"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui    

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 200, 0, 100)  -- Tinggi dikurangi
    f.Position = UDim2.new(0.5, -100, 0.2, -50)
    f.BackgroundColor3 = Color3.fromRGB(40,40,40)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 2
    f.Active = true
    f.Draggable = true
    f.Parent = gui    

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = f  

    local handle = Instance.new("Frame") 
    handle.Size = UDim2.new(1, 0, 0, 25)
    handle.Position = UDim2.new(0, 0, 0, 0)
    handle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    handle.BorderSizePixel = 0
    handle.Parent = f    

    local handle_corner = Instance.new("UICorner")
    handle_corner.CornerRadius = UDim.new(0, 10)
    handle_corner.Parent = handle    

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "You got"
    title.TextColor3 = Color3.fromRGB(255,255,255) 
    title.TextSize = 14
    title.Font = Enum.Font.SourceSansBold
    title.Parent = handle    

    textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0.5, 0)
    textLabel.Position = UDim2.new(0, 10, 0.4, 0)  -- Disesuaikan agar tetap proporsional
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255,255,255)
    textLabel.TextSize = 20  -- Sedikit diperkecil agar muat
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = f
    textLabel.TextWrapped = true    
    textLabel.Text = lastResult  -- Menampilkan hasil terakhir

    local shadow = Instance.new("Frame")
    shadow.Size = f.Size + UDim2.new(0, 4, 0, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = f.ZIndex - 1
    shadow.Parent = f    

    local shadow_corner = Instance.new("UICorner")
    shadow_corner.CornerRadius = UDim.new(0, 12)
    shadow_corner.Parent = shadow    

    return gui
end


-- Toggle untuk Auto Roll

MainSection:CreateLabel("Note", " ----- Spinner -----")
-- Global Variables
MainSection:CreateToggle("Auto Roll aura", function(state)
    autoRollEnabled = state
    if state then
        -- Mulai Auto Roll
        task.spawn(function()
            while autoRollEnabled do
                local result = game:GetService("ReplicatedStorage")
                    :WaitForChild("Packages")
                    :WaitForChild("Knit")
                    :WaitForChild("Services")
                    :WaitForChild("AuraService")
                    :WaitForChild("RF")
                    :WaitForChild("Roll")
                    :InvokeServer()

                -- Simpan hasil terakhir
                if type(result) == "table" then
                    local resultText = ""
                    for k, v in pairs(result) do
                        resultText = resultText .. tostring(k) .. ": " .. tostring(v) .. "\n"
                    end
                    lastResult = resultText
                else
                    lastResult = tostring(result)
                end

                -- Update GUI jika sedang aktif
                if tellerGui and textLabel then
                    textLabel.Text = lastResult
                end

                task.wait() -- Update setiap 1 detik
            end
        end)
    else
        -- Jika Auto Roll dimatikan, ubah hasil terakhir jadi "Turned off"
        lastResult = "Turned off"

        -- Update GUI jika masih aktif
        if tellerGui and textLabel then
            textLabel.Text = lastResult
        end
    end
end)

-- Toggle untuk Show Results (menampilkan GUI)
MainSection:CreateToggle("Show Aura Results", function(state)
    showResultsEnabled = state
    if state then
        -- Aktifkan GUI
        tellerGui = createTellerGui()
    else
        -- Hapus GUI jika toggle mati
        if tellerGui then
            tellerGui:Destroy()
            tellerGui = nil
        end
    end
end)
getgenv().AutoSpinDivine = false
getgenv().AutoSpinCave = false

-- Fungsi untuk Auto Spin
local function StartAutoSpin(spinType, autoSpinVar)
    while getgenv()[autoSpinVar] and task.wait() do
        local args = { spinType }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
            :WaitForChild("Services"):WaitForChild("SpinnerService"):WaitForChild("RF")
            :WaitForChild("Spin"):InvokeServer(unpack(args))
        
        task.wait() -- Delay untuk mencegah spam
    end
end

-- Toggle untuk Auto Spin Divine Fortune
local AutoSpinDivineToggle = MainSection:CreateToggle("Auto Spin Divine Fortune", function(state)
    getgenv().AutoSpinDivine = state
    if state then
        StartAutoSpin("Divine Fortune", "AutoSpinDivine")
    end
end)

-- Toggle untuk Auto Spin Cave Fortune
local AutoSpinCaveToggle = MainSection:CreateToggle("Auto Spin Cave Fortune", function(state)
    getgenv().AutoSpinCave = state
    if state then
        StartAutoSpin("Cave Fortune", "AutoSpinCave")
    end
end)
MainSection:CreateToggle("Auto Spin Daily Wheel", function(bool)
    getgenv().autoSpin = bool
    while getgenv().autoSpin and wait() do
        local args = {
            [1] = "Regular",
            [2] = true
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("SpinService"):WaitForChild("RE"):WaitForChild("onSpinRequest"):FireServer(unpack(args))
        task.wait(0.2)
    end
end)
MainSection:CreateLabel("Note", "----- Reward -----")
-- Auto Claim Free Gift
MainSection:CreateToggle("Auto Claim Free Gifts", function(bool)
    getgenv().autoGift = bool
    while getgenv().autoGift and wait() do
        for i = 1, 12 do
            local args = {
                [1] = tostring(i)
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TimedRewardService"):WaitForChild("RE"):WaitForChild("onClaim"):FireServer(unpack(args))
            task.wait(0.5)
        end
        task.wait(0.2)
    end
end)
-- Variabel untuk menyimpan status toggle
getgenv().autoClaimRegular = false
getgenv().autoClaimPremium = false

-- Fungsi untuk klaim hadiah pass
local function claimPass(passType)
    for i = 1, 30 do
        if (passType == "Regular" and not getgenv().autoClaimRegular) or 
           (passType == "Premium" and not getgenv().autoClaimPremium) then
            break  -- Berhenti jika toggle dimatikan
        end

        local args = {
            [1] = passType,
            [2] = i
        }

        game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("SeasonPassService")
            :WaitForChild("RF")
            :WaitForChild("Claim")
            :InvokeServer(unpack(args))

        wait(0.1)  -- Tunggu 1 detik antar klaim
    end
end

-- Toggle untuk Auto Claim Regular Pass
MainSection:CreateToggle("Auto Claim Regular Pass", function(bool)
    getgenv().autoClaimRegular = bool
    if bool then
        claimPass("Regular")
    end
end)

-- Toggle untuk Auto Claim Premium Pass
MainSection:CreateToggle("Auto Claim Premium Pass", function(bool)
    getgenv().autoClaimPremium = bool
    if bool then
        claimPass("Premium")
    end
end)

getgenv().AutoCollectCircusEgg = false

MainSection:CreateToggle("Auto Collect Circus Egg", function(state)
    getgenv().AutoCollectCircusEgg = state
    while getgenv().AutoCollectCircusEgg and wait(5) do
        game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("EventEggService")
            :WaitForChild("RF")
            :WaitForChild("Claim")
            :InvokeServer()
    end
end)
local EggSection = MaTab:CreateSection("Egg")
getgenv().autoHatch = false
getgenv().selectedWorld = nil
getgenv().selectedEgg = nil

-- World Map
local GameWorldMap = {
    ["School"] = "1",
    ["Space"] = "2",
    ["Beach"] = "3",
    ["Nuclear"] = "4",
    ["Dino World"] = "5",
    ["The Void"] = "6",
    ["Space Center"] = "7",
    ["Roman Empire"] = "8",
    ["The Underworld"] = "9",
    ["Magic Forest"] = "10",
    ["Snowy Peaks"] = "11",
    ["Dusty Tavern"] = "12",
    ["Lost Kingdom"] = "13",
    ["Orc Paradise"] = "14",
    ["Heavenly Island"] = "15",
    ["The Rift"] = "16",
    ["The Matrix"] = "17",
    ["Striker"] = "18"
}

-- Fungsi untuk mengambil semua kunci dari sebuah tabel
local function getTableKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

-- Fungsi untuk mendapatkan daftar telur (Eggs) dari world berdasarkan ID
local function GetEggsInWorld(worldId)
    local eggs = {}
    local worldZone = workspace.Zones[worldId]
    if worldZone and worldZone:FindFirstChild("Interactables") and worldZone.Interactables:FindFirstChild("Eggs") then
        for _, egg in pairs(worldZone.Interactables.Eggs:GetChildren()) do
            if egg:IsA("Model") then
                table.insert(eggs, egg.Name)
            end
        end
    else
        warn("World didn't founded: " .. tostring(worldId))
    end
    return eggs
end

-- Deklarasi eggDropdown (akan diisi kemudian)
local eggDropdown = nil

-- World Dropdown: pilih world berdasarkan nama, lalu mapping ke nilainya
local worldEggDropdown = EggSection:CreateDropdown("Select World", getTableKeys(GameWorldMap), 1, function(selected)
    local worldId = GameWorldMap[selected]
    if not worldId then
        warn("Invalid selected: " .. tostring(selected))
        return
    end
    getgenv().selectedWorld = worldId  -- simpan nilai mapped (misal "10" untuk Magic Forest)
    getgenv().selectedEgg = nil
    
    -- Refresh egg dropdown dengan telur dari world yang dipilih
    local eggs = GetEggsInWorld(worldId)
    if eggDropdown and eggDropdown.Refresh then
        eggDropdown.Refresh(eggs, 1, function(eggSelected)
            getgenv().selectedEgg = eggSelected
        end)
    end
end)

-- Egg Dropdown (awalnya kosong, nanti akan di-refresh saat world dipilih)
eggDropdown = EggSection:CreateDropdown("Select Egg", {}, 1, function(selected)
    getgenv().selectedEgg = selected
end)

-- Dropdown pilih tipe hatch
EggSection:CreateLabel("Note", "Tell me if you own triple hatch\nbut it didn't worked")
EggSection:CreateDropdown("Select Hatch Type", {"Single Hatch", "Triple Hatch", "Octuple Hatch"}, 1, function(selected)
    getgenv().selectedHatchType = selected
end)

-- Toggle Auto Hatch dengan filter nama egg dan pengecekan tipe hatch
EggSection:CreateToggle("Auto Hatch", function(bool)
    getgenv().autoHatch = bool
    while getgenv().autoHatch and wait() do
        if getgenv().selectedEgg then
            local eggName = getgenv().selectedEgg
            -- Hapus akhiran " Egg" (beserta spasi sebelumnya jika ada)
            local eggEventName = eggName:gsub("%s*Egg$", "")
            
            if getgenv().selectedHatchType == "Single Hatch" then
                local args = { [1] = eggEventName, [2] = {}, [3] = false }
                purchaseEgg:InvokeServer(unpack(args))
            elseif getgenv().selectedHatchType == "Triple Hatch" then
                local args = { [1] = eggEventName, [2] = {}, [3] = true, [4] = false }
                purchaseEgg:InvokeServer(unpack(args))
            elseif getgenv().selectedHatchType == "Octuple Hatch" then
                local args = { [1] = eggEventName, [2] = {}, [3] = false, [4] = true }
                purchaseEgg:InvokeServer(unpack(args))
            end
        end
    end
end)
---------------------------
-- SECTION: Arm Wrestling (World & Boss)
---------------------------
local NinjaTab = MainWindow:CreateTab("Pirate")
local ninjasection = NinjaTab:CreateSection("Battle")



-----------------------------------------------------------
-- Dropdown untuk Memilih World
-----------------------------------------------------------
getgenv().selectedPirateWorld = nil
getgenv().selectedPirateBoss = nil
local bossPirateDropdown = nil

-- Daftar World yang tersedia
local pirateWorlds = {
    ["PirateTown"] = "PirateTown",
    ["TreasureIsland"] = "TreasureIsland",
    ["GhostIsland"] = "GhostIsland"
}

-- Fungsi mendapatkan daftar boss dari world yang dipilih
local function GetBossesInWorld(world)
    local bosses = {}
    local worldPath = workspace:FindFirstChild("GameObjects") and workspace.GameObjects:FindFirstChild("ArmWrestling") and workspace.GameObjects.ArmWrestling:FindFirstChild(world)

    if worldPath and worldPath:FindFirstChild("NPC") then
        for _, boss in pairs(worldPath.NPC:GetChildren()) do
            if boss:IsA("Model") then
                table.insert(bosses, boss.Name)
            end
        end
    else
        warn("World not found or no bosses available: " .. tostring(world))
    end
    return bosses
end
ninjasection:CreateDropdown("Select World", {"PirateTown", "TreasureIsland", "GhostIsland"}, 1, function(selected)
    getgenv().selectedPirateWorld = pirateWorlds[selected]
    getgenv().selectedPirateBoss = nil

    -- Refresh boss dropdown dengan boss dari world yang dipilih
    local bosses = GetBossesInWorld(getgenv().selectedPirateWorld)
    if bossPirateDropdown and bossPirateDropdown.Refresh then
        bossPirateDropdown.Refresh(bosses, 1, function(selectedBoss)
            getgenv().selectedPirateBoss = selectedBoss
        end)
    end
end)

-- Dropdown Pilih Boss (awalnya kosong)
bossPirateDropdown = ninjasection:CreateDropdown("Select Boss", {}, 1, function(selected)
    getgenv().selectedPirateBoss = selected
end)
ninjasection:CreateToggle("Auto Fight", function(bool)
    getgenv().AutoFight = bool
    while getgenv().AutoFight and wait(2) do
        pcall(function()
            if getgenv().selectedPirateWorld and getgenv().selectedPirateBoss then
                local bossPath = workspace:FindFirstChild("GameObjects") and workspace.GameObjects:FindFirstChild("ArmWrestling") and workspace.GameObjects.ArmWrestling:FindFirstChild(getgenv().selectedPirateWorld) and workspace.GameObjects.ArmWrestling[getgenv().selectedPirateWorld]:FindFirstChild("NPC") and workspace.GameObjects.ArmWrestling[getgenv().selectedPirateWorld].NPC:FindFirstChild(getgenv().selectedPirateBoss)

                if bossPath and bossPath:FindFirstChild("Table") then
                    local args = {
                        [1] = getgenv().selectedPirateBoss,
                        [2] = bossPath.Table,
                        [3] = getgenv().selectedPirateWorld
                    }

                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
                        :WaitForChild("Services"):WaitForChild("ArmWrestleService")
                        :WaitForChild("RE"):WaitForChild("onEnterNPCTable")
                        :FireServer(unpack(args))
                end
            end
        end)
    end
end)


ninjasection:CreateToggle("Auto Click Battle", function(bool)
    getgenv().AutoClickBattle = bool
    while getgenv().AutoClickBattle and wait() do
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
                :WaitForChild("Services"):WaitForChild("ArmWrestleService")
                :WaitForChild("RE"):WaitForChild("onClickRequest")
                :FireServer()
        end)
    end
end)
ninjasection:CreateLabel("Note", "Trial / Tower")
local AutoEnterTrial = false
local AutoUseKey = false

ninjasection:CreateToggle("Auto Enter Trial", function(Value)
    AutoEnterTrial = Value
    while AutoEnterTrial and wait() do
        pcall(function()
            local args = {
                [1] = "PirateClash",
                [2] = false
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("EnterTower"):InvokeServer(unpack(args))
        end)
    end
end)

ninjasection:CreateToggle("Auto Use All Key", function(Value)
    AutoUseKey = Value
    while AutoUseKey and wait() do
        pcall(function()
            local args = {
                [1] = "PirateClash",
                [2] = true
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("EnterTower"):InvokeServer(unpack(args))
        end)
    end
end)
getgenv().AutoClickFast = false
local function AutoClick()
    while getgenv().AutoClickFast and task.wait() do
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
            :WaitForChild("Services"):WaitForChild("WrestleService"):WaitForChild("RF")
            :WaitForChild("OnClick"):InvokeServer()
    end
end
ninjasection:CreateToggle("Auto Click", function(state)
    getgenv().AutoClickFast = state
    if state then
        task.spawn(AutoClick)
    end
end)
local TrainSection = NinjaTab:CreateSection("Main")
-- Toggle untuk Auto Farm Knuckle
local function CheckPunchPirate()
    local success, text = pcall(function()
        return game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Currencies.PirateCurrency.NinjaKnuckles.Amount.Text
    end)

    if success and text then
        local amountText = tostring(text)
        local number = 0
        
        -- Daftar satuan lengkap hingga Tdc (Tridecillion)
        local multipliers = {
            K = 1e3, M = 1e6, B = 1e9, T = 1e12, 
            Qa = 1e15, Qi = 1e18, Sx = 1e21, Sp = 1e24, 
            Oc = 1e27, No = 1e30, Dc = 1e33, Ud = 1e36, 
            Dd = 1e39, Tdc = 1e42
        }

        -- Ambil angka + huruf (misal "1.5K", "3M", "2.7Qa")
        local numStr, suffix = amountText:match("([%d%.]+)(%a*)")
        numStr = tonumber(numStr)

        -- Pastikan suffix yang dikenali ada di dalam multipliers
        if numStr and suffix and multipliers[suffix] then
            number = numStr * multipliers[suffix]
        -- Menambahkan pengecekan untuk angka desimal dengan 'k' atau 'K' untuk angka seperti "22.1k"
        elseif numStr and suffix:lower() == "k" then
            number = numStr * 1e3
        else
            number = numStr or 0
        end

        return number
    else
        return 0
    end
end

TrainSection:CreateToggle("Auto Farm Knuckle", function(Value)
    AutoKnucklesFarm = Value
    while AutoKnucklesFarm and wait() do
        pcall(function()
            local ninjastat = CheckPunchPirate()
            local totalstat = ninjastat  -- Jika terdapat stat lain, gantikan dengan perhitungan total

            -- Gunakan world yang dipilih dari dropdown, default ke "PirateTown"
            local worldForStats = getgenv().selectedWorld or "PirateTown"
            
            if ninjastat == 0 or totalstat <= 3000 then
                TPArea(CFrame.new(-50.7482452, 18.1606655, 5822.96777, 0.969894946, 0, -0.243523732, 0, 1, 0, 0.243523732, 0, 0.969894946))
                onGiveStats:FireServer(worldForStats, "Tier1")
            elseif ninjastat == 3000 or totalstat <= 13000 then
                TPArea(CFrame.new(-43.9310265, 18.6317043, 5822.44873, 0.857230783, 0, -0.514932513, -0, 1, -0, 0.514932573, 0, 0.857230663))
                onGiveStats:FireServer(worldForStats, "Tier2")
            elseif ninjastat == 13000 or totalstat <= 45000 then
                TPArea(CFrame.new(-36.0996666, 18.7413254, 5822.41406, 0.844729602, 0, -0.535193324, -0, 1, -0, 0.535193324, 0, 0.844729602))
                onGiveStats:FireServer(worldForStats, "Tier3")
            elseif ninjastat == 45000 or totalstat <= 500000 then
                TPArea(CFrame.new(-26.4939499, 18.1606655, 5822.07031, 0.811678588, 3.72835594e-08, 0.5841043, -1.43655621e-09, 1, -6.18340579e-08, -0.5841043, 4.93502803e-08, 0.811678588))
                onGiveStats:FireServer(worldForStats, "Tier4")
            elseif ninjastat == 500000 then
                TPArea(CFrame.new(-21.2316189, 18.1606655, 5822.68506, 0.835196018, 0, -0.549952447, -0, 1, -0, 0.549952507, 0, 0.835195899))
                onGiveStats:FireServer(worldForStats, "Tier5")
            end
        end)
    end
end)
local AutoKnucklesFarmGH = false

TrainSection:CreateToggle("Auto Farm Knuckle Ghost", function(Value)
    AutoKnucklesFarmGH = Value
    while AutoKnucklesFarmGH and wait() do
        pcall(function()
            local ninjastat = CheckPunchPirate()
            local totalstat = ninjastat
            local worldForStats = "GhostIsland"

            if ninjastat == 0 or totalstat <= 0 then
                TPArea(CFrame.new(-1385.59155, 22.2006207, 9249.45508, -0.29902029, -3.40734374e-08, -0.954246759, 4.51419124e-09, 1, -3.71217084e-08, 0.954246759, -1.54077959e-08, -0.29902029))
                onGiveStats:FireServer(Stats, "Tier1")
            elseif ninjastat == 0 or totalstat <= 250000 then
                TPArea(CFrame.new(-1392.40344, 22.2006397, 9253.94336, -0.937935531, 0, -0.346809894, 0, 1.00000012, -0, 0.346809924, -0, -0.937935412))
                onGiveStats:FireServer(Stats, "Tier2")
            elseif ninjastat == 250000 or totalstat <= 575000 then
                TPArea(CFrame.new(-1399.36316, 21.7616425, 9263.82617, -0.931421161, 0, -0.363943279, 0, 1, -0, 0.363943309, -0, -0.931421041))
                onGiveStats:FireServer(Stats, "Tier3")
            elseif ninjastat == 575000 or totalstat <= 1200000 then
                TPArea(CFrame.new(-1402.11548, 22.0700321, 9278.57227, 0.907696247, 0, -0.419627905, -0, 1.00000012, -0, 0.419627905, 0, 0.907696247))
                onGiveStats:FireServer(Stats, "Tier4")
            elseif ninjastat == 1200000 or totalstat <= 3000000 then
                TPArea(CFrame.new(-1403.08362, 21.9177456, 9284.46582, -0.4389247, 0, -0.898523808, 0, 1, -0, 0.898523927, -0, -0.43892464))
                onGiveStats:FireServer(Stats, "Tier5")
            elseif ninjastat == 3000000 or totalstat <= 7500000 then
                TPArea(CFrame.new(-1401.50342, 22.2006149, 9292.4082, -0.855187833, 0, -0.518318295, 0, 1, -0, 0.518318355, -0, -0.855187714))
                onGiveStats:FireServer(Stats, "Tier6")
            
            end
        end)
    end
end)
local AutoKnucklesFarmTI = false

TrainSection:CreateToggle("Auto Farm Knuckle TI", function(Value)
    AutoKnucklesFarmTI = Value
    while AutoKnucklesFarmTI and wait() do
        pcall(function()
            local ninjastat = CheckPunchPirate()
            local totalstat = ninjastat
            local worldForStats = "TreasureIsland"

            if ninjastat == 0 or totalstat <= 0 then
                TPArea(CFrame.new(-289.946869, 22.4653702, 8029.07275, 0.787453234, 0, -0.616374433, -0, 1, -0, 0.616374433, 0, 0.787453234))
                onGiveStats:FireServer(Stats, "Tier1")
            elseif ninjastat == 0 or totalstat <= 250000 then
                TPArea(CFrame.new(-281.574341, 22.4653702, 8031.21973, 0.993716717, 0, -0.111924849, -0, 0.99999994, -0, 0.111924864, 0, 0.993716598))
                onGiveStats:FireServer(Stats, "Tier2")
            elseif ninjastat == 250000 or totalstat <= 575000 then
                TPArea(CFrame.new(-274.959045, 22.4653702, 8030.44434, 0.971482754, 0, -0.237110227, -0, 1, -0, 0.237110227, 0, 0.971482754))
                onGiveStats:FireServer(Stats, "Tier3")
            elseif ninjastat == 575000 or totalstat <= 1200000 then
                TPArea(CFrame.new(-267.150726, 22.4653702, 8030.4834, 0.999592483, 0, -0.0285457317, -0, 1, -0, 0.0285457317, 0, 0.999592483))
                onGiveStats:FireServer(Stats, "Tier4")
            elseif ninjastat == 1200000 or totalstat <= 3000000 then
                TPArea(CFrame.new(-261.010193, 22.4653702, 8030.59033, 0.701719761, 0, -0.712453067, -0, 1, -0, 0.712453067, 0, 0.701719761))
                onGiveStats:FireServer(Stats, "Tier5")
            elseif ninjastat == 3000000 or totalstat <= 7500000 then
                TPArea(CFrame.new(-252.406296, 22.4653702, 8031.4834, 0.948641777, 0, -0.316352367, -0, 1, -0, 0.316352367, 0, 0.948641777))
                onGiveStats:FireServer(Stats, "Tier6")
            elseif ninjastat == 7500000 then
                TPArea(CFrame.new(-252.406296, 22.4653702, 8031.4834, 0.948641777, 0, -0.316352367, -0, 1, -0, 0.316352367, 0, 0.948641777))
                onGiveStats:FireServer(Stats, "Tier7")
            end
        end)
    end
end)
local function CheckBicepAmount()
    local success, text = pcall(function()
        return game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Currencies.PirateCurrency.NinjaBicep.Amount.Text
    end)
    
    if success and text then
        local amountText = tostring(text)
        local number = 0

        -- Daftar satuan lengkap hingga Tdc (Tridecillion)
        local multipliers = {
            K = 1e3, M = 1e6, B = 1e9, T = 1e12, 
            Qa = 1e15, Qi = 1e18, Sx = 1e21, Sp = 1e24, 
            Oc = 1e27, No = 1e30, Dc = 1e33, Ud = 1e36, 
            Dd = 1e39, Tdc = 1e42
        }

        -- Ambil angka + huruf (misal "1.5K", "3M", "2.7Qa")
        local numStr, suffix = amountText:match("([%d%.]+)(%a*)")
        numStr = tonumber(numStr)

        -- Pastikan suffix yang dikenali ada di dalam multipliers
        if numStr and suffix and multipliers[suffix] then
            number = numStr * multipliers[suffix]
        -- Menambahkan pengecekan untuk angka desimal dengan 'k' atau 'K' untuk angka seperti "22.1k"
        elseif numStr and suffix:lower() == "k" then
            number = numStr * 1e3
        else
            number = numStr or 0
        end

        return number
    else
        return 0
    end
end


local DumbbellTiers = {
    {0, "1"}, {50, "2"}, {350, "3"}, {1000, "4"}, {2500, "5"},
    {5000, "6"}, {7500, "7"}, {10000, "8"}, {15000, "9"}, {20000, "10"},
    {25000, "11"}, {50000, "12"}, {350000, "13"}, {550000, "14"},
    {850000, "15"}, {1500000, "16"}, {2000000, "17"}, {2800000, "18"},
    {3700000, "19"}, {5000000, "20"}, {8000000, "21"}, {14000000, "22"},
    {17500000, "23"}
}

TrainSection:CreateToggle("Auto Farm Dumbbells", function(state)
    getgenv().autoEquipDumbbells = state

    while getgenv().autoEquipDumbbells do
        wait()
        pcall(function()
            local selectedWorld = getgenv().selectedPirateWorld
            if selectedWorld then
                local bicepAmount = CheckBicepAmount()
                local bestTier = "1"  -- Default to the first tier

                -- Loop through tiers and set bestTier based on bicepAmount
                for _, tier in ipairs(DumbbellTiers) do
                    if bicepAmount >= tier[1] then
                        bestTier = tier[2]
                    else
                        break  -- Stop once we find the appropriate tier
                    end
                end

                local args = {
                    [1] = selectedWorld,
                    [2] = "Dumbbells",  -- Corrected spelling for "Dumbbells"
                    [3] = selectedWorld .. bestTier
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
                    :WaitForChild("Services"):WaitForChild("ToolService")
                    :WaitForChild("RE"):WaitForChild("onGuiEquipRequest")
                    :FireServer(unpack(args))
                
                WeightClick()  -- Call any other action if needed (for example, WeightClick)
            end
        end)
    end
end)

local function CheckBicepAmountForBarbells()
    local success, text = pcall(function()
        return game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Currencies.PirateCurrency.NinjaBicep.Amount.Text
    end)
    
    if success and text then
        local amountText = tostring(text)
        local number = 0

        -- Daftar satuan lengkap hingga Tdc (Tridecillion)
        local multipliers = {
            K = 1e3, M = 1e6, B = 1e9, T = 1e12, 
            Qa = 1e15, Qi = 1e18, Sx = 1e21, Sp = 1e24, 
            Oc = 1e27, No = 1e30, Dc = 1e33, Ud = 1e36, 
            Dd = 1e39, Tdc = 1e42
        }

        -- Ambil angka + huruf (misal "1.5K", "3M", "2.7Qa")
        local numStr, suffix = amountText:match("([%d%.]+)(%a*)")
        numStr = tonumber(numStr)

        -- Pastikan suffix yang dikenali ada di dalam multipliers
        if numStr and suffix and multipliers[suffix] then
            number = numStr * multipliers[suffix]
        -- Menambahkan pengecekan untuk angka desimal dengan 'k' atau 'K' untuk angka seperti "22.1k"
        elseif numStr and suffix:lower() == "k" then
            number = numStr * 1e3
        else
            number = numStr or 0
        end

        return number
    else
        return 0
    end
end

local BarbellTiersForPirate = {
    {0, "3k"}, {3000, "3k"}, {15000, "15k"}, {50000, "50k"}
}

local function EquipBarbells()
    local selectedWorld = getgenv().selectedPirateWorld
    local bicepAmount = CheckBicepAmountForBarbells()
    local bestTierForPirate = "3k"  -- Default tier

    for _, tier in ipairs(BarbellTiersForPirate) do
        if bicepAmount >= tier[1] then
            bestTierForPirate = tier[2]
        end
    end

    local args = {
        [1] = selectedWorld,  -- Nama dunia
        [2] = "Barbells",  -- Nama item
        [3] = selectedWorld .. bestTierForPirate  -- Kombinasi dunia dan tier terbaik
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
        :WaitForChild("Services"):WaitForChild("ToolService")
        :WaitForChild("RE"):WaitForChild("onEquipRequest")
        :FireServer(unpack(args))
    
    -- Fungsi tambahan untuk klik atau hal lainnya
    WeightClick()
end

TrainSection:CreateToggle("Auto Farm Barbells", function(state)
    getgenv().autoEquipPirateBarbells = state

    while getgenv().autoEquipPirateBarbells do
        wait(5)  -- Menunggu 5 detik sebelum pengecekan berikutnya
        pcall(function()
            EquipBarbells()  -- Mengeksekusi pengaturan barbells setiap 5 detik
        end)
    end
end)



TrainSection:CreateLabel("Note", "↑ Need world. on left ↑")
TrainSection:CreateLabel("Note", " ----- Eggs -----")
local function GetEggsInWorld(worldName)
    local eggs = {}
    pcall(function()
        local worldZone = workspace.Zones:FindFirstChild(worldName)
        if worldZone then
            local interactables = worldZone:FindFirstChild("Interactables")
            if interactables then
                local eggFolder = interactables:FindFirstChild("Eggs")
                if eggFolder then
                    for _, egg in pairs(eggFolder:GetChildren()) do
                        if egg:IsA("Model") then
                            table.insert(eggs, egg.Name)
                        end
                    end
                    if #eggs == 0 then
                        print("No eggs found in world: " .. worldName)
                    end
                else
                    print("Eggs folder not found in world: " .. worldName)
                end
            else
                print("Interactables not found in world: " .. worldName)
            end
        else
            print("World not found: " .. worldName)
        end
    end)
    return eggs
end

local pirateEggDropdownNew = TrainSection:CreateDropdown("Select Egg", {}, 1, function(selected)
    getgenv().selectedNewPirateEgg = selected
end)

-- Dropdown untuk memilih world
local worldDropdown = TrainSection:CreateDropdown("Select World", {"PirateTown", "TreasureIsland", "GhostIsland"}, 1, function(selectedWorld)
    -- Gunakan variabel berbeda agar tidak bentrok
    getgenv().selectedNewPirateWorld = selectedWorld
    getgenv().selectedNewPirateEgg = nil  -- Reset egg terpilih saat world baru dipilih

    -- Ambil egg berdasarkan world yang dipilih
    local eggs = {}
    pcall(function()
        eggs = GetEggsInWorld(selectedWorld)
        print("Eggs found for world", selectedWorld, ":", (#eggs > 0 and table.concat(eggs, ", ") or "None"))
    end)
    
    -- Refresh dropdown egg
    if pirateEggDropdownNew and pirateEggDropdownNew.Refresh then
        pcall(function()
            pirateEggDropdownNew.Refresh(eggs, 1, function(eggSelected)
                getgenv().selectedNewPirateEgg = eggSelected
            end)
        end)
    else
        warn("Not found")
    end
end)

-- Dropdown untuk memilih egg (variabel konsisten: pirateEggDropdownNew)

-- Dropdown untuk memilih tipe hatch
TrainSection:CreateLabel("Note", "Tell me if you own triple hatch\nbut it didn't worked")
TrainSection:CreateDropdown("Select Hatch Type", {"Single Hatch", "Triple Hatch", "Octuple Hatch"}, 1, function(selected)
    getgenv().selectedHatchTypeNew = selected
end)

-- Toggle Auto Hatch dengan pcall
TrainSection:CreateToggle("Auto Hatch", function(state)
    getgenv().autoHatchNew = state
    while getgenv().autoHatchNew and wait() do
        if getgenv().selectedNewPirateEgg then
            local eggName = getgenv().selectedNewPirateEgg
            local eggEventName = eggName:gsub("%s*Egg$", "")  -- Hapus " Egg" di akhir

            local args = {}
            if getgenv().selectedHatchTypeNew == "Single Hatch" then
                args = { [1] = eggEventName, [2] = {}, [3] = false }
            elseif getgenv().selectedHatchTypeNew == "Triple Hatch" then
                args = { [1] = eggEventName, [2] = {}, [3] = true, [4] = false }
            elseif getgenv().selectedHatchTypeNew == "Octuple Hatch" then
                args = { [1] = eggEventName, [2] = {}, [3] = false, [4] = true }
            end

            pcall(function()
                purchaseEgg:InvokeServer(unpack(args))
            end)
        else
            print("No egg selected")
        end
    end
end)



TrainSection:CreateLabel("Note", " ----- Reward -----")
local function spinSpinner()
    local args
    if spinAmount == "1x" then
        args = { [1] = "Ghost Fortune" }
    elseif spinAmount == "3x" then
        args = { [1] = "Ghost Fortune", [2] = "x10" }
    elseif spinAmount == "10x" then
        args = { [1] = "Ghost Fortune", [2] = "x25" }
    end
    
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages", 9e9):WaitForChild("Knit", 9e9):WaitForChild("Services", 9e9):WaitForChild("SpinnerService", 9e9):WaitForChild("RF", 9e9):WaitForChild("Spin", 9e9):InvokeServer(unpack(args))
    end)
end
local toggleState = false
local spinAmount = "1x"
local function autoCraft()
    while toggleState do
        local success, err = pcall(function()
            local chestName = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.ChestMachine.TreasureChestName.Text
            local args = {
                [1] = chestName
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TreasureChestService"):WaitForChild("RF"):WaitForChild("Craft"):InvokeServer(unpack(args))
        end)
        
        if not success then
            warn("Error in autoCraft:", err)
        end
        
        wait(0.1) -- Delay untuk mencegah spam berlebihan
    end
end

TrainSection:CreateToggle("Auto Craft Chest", function(state)
    toggleState = state
    if toggleState then
        autoCraft()
    end
end)
local toggleSpin = false
TrainSection:CreateToggle("Auto Spin", function(state)
    toggleSpin = state
    if toggleSpin then
        spinSpinner()
    end
end)
TrainSection:CreateDropdown("Spin Amount", {"1x", "3x", "10x"}, 1, function(option)
    spinAmount = option
end)
TrainSection:CreateLabel("Note", " ----- Mastery Reward -----")
local masteryTypes = {
    "Play Time",
    "Victory",
    "Curling",
    "Gripwork",
    "Knucklework",
    "Hatching",
    "Golden"
}

-- Fungsi untuk auto claim mastery
local function AutoClaimMastery(masteryName)
    while getgenv()["Auto" .. masteryName] and wait(1) do
        pcall(function()
            for i = 1, 5 do
                local args = {
                    [1] = masteryName,
                    [2] = i
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
                    :WaitForChild("Services"):WaitForChild("MasteryService")
                    :WaitForChild("RF"):WaitForChild("Claim")
                    :InvokeServer(unpack(args))
            end
        end)
    end
end

-- Buat toggle untuk setiap mastery type
for _, masteryName in ipairs(masteryTypes) do
    TrainSection:CreateToggle("Auto Claim " .. masteryName, function(bool)
        getgenv()["Auto" .. masteryName] = bool
        if bool then
            AutoClaimMastery(masteryName)
        end
    end)
end

-- Pastikan 'Section' merupakan objek GUI yang sudah didefinisikan
-- Fungsi Auto Claim Play Time
local function AutoClaimPlayTime(rewardType)
    for i = 1, 12 do
        pcall(function()
            local args = {
                [1] = rewardType,
                [2] = i
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit")
                :WaitForChild("Services"):WaitForChild("EventPassService")
                :WaitForChild("RF"):WaitForChild("ClaimReward")
                :InvokeServer(unpack(args))
        end)
    end
end

-- Toggle untuk Auto Claim Play Time (Free)
TrainSection:CreateToggle("Auto Claim Play Time (Free)", function(bool)
    getgenv().AutoClaimFree = bool
    while getgenv().AutoClaimFree and wait(1) do -- Setiap 5 detik untuk menghindari spam
        AutoClaimPlayTime("Free")
    end
end)

-- Toggle untuk Auto Claim Play Time (Exclusive)
TrainSection:CreateToggle("Auto Claim Play Time (Exclusive)", function(bool)
    getgenv().AutoClaimExclusive = bool
    while getgenv().AutoClaimExclusive and wait(1) do
        AutoClaimPlayTime("Exclusive")
    end
end)

local MachineTab = CoastingLibrary:CreateTab("Other")
local OtherSection = MachineTab:CreateSection("Main")
OtherSection:CreateButton('Redeem All Code', function()
    local Code = {
        'noob', 'Pirate', 'WEDNESDAY', 'FIXED', '200m', 'enchant', 'Leagues', 'pinksandcastle', 'secret', 'gullible', 'knighty', 'axel', 'THANKSFOR400M', "FORGIVEUS", "SCARY", "christmas"
    }
    for i,v in pairs(Code) do
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CodeRedemptionService"):WaitForChild("RE"):WaitForChild("onRedeem"):FireServer(v)
    end
end)
OtherSection:CreateLabel("Note", "----- Teleport bypass -----")
OtherSection:CreateButton('Zone 1 (School)', function()
    TPArea(game:GetService("Workspace").Zones["1"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 2 (Space Gym)', function()
    TPArea(game:GetService("Workspace").Zones["2"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 3 (Beach)', function()
    TPArea(game:GetService("Workspace").Zones["3"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 4 (Bunker)', function()
    TPArea(game:GetService("Workspace").Zones["4"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 5 (Dino)', function()
    TPArea(game:GetService("Workspace").Zones["5"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 6 (Void)', function()
    TPArea(game:GetService("Workspace").Zones["6"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 7 (Space Center)', function()
    TPArea(game:GetService("Workspace").Zones["7"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 8 (Roman Empire)', function()
    TPArea(game:GetService("Workspace").Zones["8"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 9 (Underworld)', function()
    TPArea(game:GetService("Workspace").Zones["9"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 10 (Magic Forest)', function()
    TPArea(game:GetService("Workspace").Zones["10"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 11 (Snowy Peaks)', function()
    TPArea(game:GetService("Workspace").Zones["11"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 12 (Dusty Tavern)', function()
    TPArea(game:GetService("Workspace").Zones["12"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 13 (Lost Kingdom)', function()
    TPArea(game:GetService("Workspace").Zones["13"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 14 (Orc Paradise)', function()
    TPArea(game:GetService("Workspace").Zones["14"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 15 (Heavenly Island)', function()
    TPArea(game:GetService("Workspace").Zones["15"].Interactables.Teleports.Locations.Spawn.CFrame)
end)

OtherSection:CreateButton('Zone 16 (The Rift)', function()
    TPArea(game:GetService("Workspace").Zones["16"].Interactables.Teleports.Locations.Spawn.CFrame)
end)
OtherSection:CreateButton('Zone 17 (The Matrix)', function()
    TPArea(game:GetService("Workspace").Zones["17"].Interactables.Teleports.Locations.Spawn.CFrame)
end)
OtherSection:CreateButton('Zone 18 (Striker)', function()
    TPArea(game:GetService("Workspace").Zones["18"].Interactables.Teleports.Locations.Spawn.CFrame)
end)
local BySection = MachineTab:CreateSection("Machine")
BySection:CreateButton('Open Enchant Machine', function()
    game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Enchant.Visible = not game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Enchant.Visible
end)

BySection:CreateButton('Open Goliath Machine', function()
    game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Goliath.Visible = not game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Goliath.Visible
end)

BySection:CreateButton('Open Mutate Machine', function()
    game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Mutate.Visible = not game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Mutate.Visible
end)

BySection:CreateButton('Open Cure Machine', function()
    game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Cure.Visible = not game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Cure.Visible
end)
BySection:CreateLabel("Note", "----- Claim -----")



local MiscTab = CoastingLibrary:CreateTab("Misc")
local MiscSection = MiscTab:CreateSection("Misc")
local MisccSection = MiscTab:CreateSection("Universal")

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local teleportService = game:GetService("TeleportService")
local starterGui = game:GetService("StarterGui")
local userInputService = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")

-- Walkspeed
local WalkspeedEnabled = false
local CurrentWalkspeed = 16
MiscSection:CreateSlider("Walkspeed", 16, 2500, 16, false, function(value)
    CurrentWalkspeed = value
    if WalkspeedEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
end)

MiscSection:CreateToggle("Enable Walkspeed", function(bool)
    WalkspeedEnabled = bool
    local char = player.Character
    spawn(function()
        while WalkspeedEnabled do
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = CurrentWalkspeed
            end
            wait(0.1)
        end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end)
end)

-- Anti-AFK
MiscSection:CreateToggle("Anti-AFK", function(state)
    if state then
        print("Afk: Turned on!")
        local VirtualUser = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            print("AFK: Active!")
        end)
    else
        print("Afk: off")
    end
end)

-- White Screen
MiscSection:CreateToggle("White Screen", function(state)
    if state then
        local whiteScreen = Instance.new("ScreenGui")
        whiteScreen.Name = "WhiteScreen"
        whiteScreen.IgnoreGuiInset = true
        whiteScreen.Parent = game.CoreGui

        local frame = Instance.new("Frame", whiteScreen)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.Position = UDim2.new(0, 0, 0, 0)
        frame.BackgroundColor3 = Color3.new(1, 1, 1)
        frame.BorderSizePixel = 0
        frame.ZIndex = 0
    else
        if game.CoreGui:FindFirstChild("WhiteScreen") then
            game.CoreGui.WhiteScreen:Destroy()
        end
    end
end)

-- FPS Booster
MiscSection:CreateButton("FPS Booster", function()
    local Notification = Instance.new("BindableFunction")
    function Notification.OnInvoke(response)
        if response == "Yes" then
            local Lighting = game:GetService("Lighting")
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then
                    v:Destroy()
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 2
            for _, instance in ipairs(workspace:GetDescendants()) do
                if instance:IsA("BasePart") and not instance:IsDescendantOf(player.Character) then
                    instance.Material = Enum.Material.SmoothPlastic
                    instance.Reflectance = 0
                elseif instance:IsA("Texture") or instance:IsA("Decal") then
                    instance.Transparency = 1
                end
            end
            local terrain = workspace:FindFirstChild("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            settings().Physics.AllowSleep = true
            settings().Rendering.QualityLevel = 1
            starterGui:SetCore("SendNotification", {
                Title = "Success",
                Text = "FPS Booster applied!",
                Duration = 2
            })
        end
    end
    starterGui:SetCore("SendNotification", {
        Title = "Confirmation",
        Text = "Apply FPS Booster?",
        Duration = 5,
        Callback = Notification,
        Button1 = "Yes",
        Button2 = "No"
    })
end)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- Function to get all players except local player
local function GetPlayerList()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Safe get property function
local function SafeGet(func)
    local success, result = pcall(func)
    return success and result or "N/A"
end

-- Function to get all available IDs from a player
local function GetPlayerIDs(player)
    local ids = {}
    
    if player.Character then
        -- Head ID
        local head = player.Character:FindFirstChild("Head")
        if head then
            local headId = SafeGet(function() 
                return tostring(head:GetAttribute("OriginalSize") or "Default")
            end)
            table.insert(ids, {
                name = "Head",
                id = headId
            })
            
            -- Face ID
            local face = head:FindFirstChild("face")
            if face then
                local faceId = SafeGet(function()
                    return face.Texture:match("%d+") or "Default"
                end)
                table.insert(ids, {
                    name = "Face",
                    id = faceId
                })
            end
        end
        
        -- Hair and Accessories IDs
        for _, accessory in ipairs(player.Character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local accessoryId = SafeGet(function()
                    local id = accessory:FindFirstChild("AccessoryId")
                    if id then
                        return tostring(id.Value)
                    end
                    -- Fallback to handle different accessory structures
                    local handle = accessory:FindFirstChild("Handle")
                    if handle then
                        local meshId = handle:FindFirstChild("Mesh") or handle:FindFirstChild("SpecialMesh")
                        if meshId then
                            return tostring(meshId.MeshId:match("%d+"))
                        end
                    end
                    return "N/A"
                end)
                
                table.insert(ids, {
                    name = accessory.Name,
                    id = accessoryId
                })
            end
        end
        
        -- Clothing IDs
        local shirt = player.Character:FindFirstChild("Shirt")
        if shirt then
            local shirtId = SafeGet(function()
                return shirt.ShirtTemplate:match("%d+") or "None"
            end)
            table.insert(ids, {
                name = "Shirt",
                id = shirtId
            })
        end
        
        local pants = player.Character:FindFirstChild("Pants")
        if pants then
            local pantsId = SafeGet(function()
                return pants.PantsTemplate:match("%d+") or "None"
            end)
            table.insert(ids, {
                name = "Pants",
                id = pantsId
            })
        end
        
        local tshirt = player.Character:FindFirstChild("ShirtGraphic")
        if tshirt then
            local tshirtId = SafeGet(function()
                return tshirt.Graphic:match("%d+") or "None"
            end)
            table.insert(ids, {
                name = "T-Shirt",
                id = tshirtId
            })
        end
        
        -- Body Parts with pcall
        local function GetBodyPartId(partName)
            local part = player.Character:FindFirstChild(partName)
            if part then
                local partId = SafeGet(function()
                    return tostring(part:GetAttribute("OriginalSize") or "Default")
                end)
                table.insert(ids, {
                    name = partName,
                    id = partId
                })
            end
        end
        
        GetBodyPartId("Left Arm")
        GetBodyPartId("Right Arm")
        GetBodyPartId("Torso")
        GetBodyPartId("UpperTorso")
        
        -- Animation IDs
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid:FindFirstChild("Animator") then
            local animator = humanoid.Animator
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local animId = SafeGet(function()
                    return track.Animation.AnimationId:match("%d+")
                end)
                
                local animType = "Other"
                local lowername = string.lower(track.Name)
                
                if lowername:match("walk") then
                    animType = "Walk"
                elseif lowername:match("run") then
                    animType = "Run"
                elseif lowername:match("jump") then
                    animType = "Jump"
                elseif lowername:match("idle") then
                    animType = "Idle"
                end
                
                table.insert(ids, {
                    name = "Animation " .. animType,
                    id = animId
                })
            end
        end
        
        -- Clothing Package
        local bodyColors = player.Character:FindFirstChild("BodyColors")
        if bodyColors then
            local packageId = SafeGet(function()
                return tostring(bodyColors:GetAttribute("ClothingPackage") or "None")
            end)
            table.insert(ids, {
                name = "Clothing Package",
                id = packageId
            })
        end
    end
    
    return ids
end
local selectedPlayer = nil
local selectedIDs = {}
local multiDropdown = MisccSection:CreateMultiDropdown(
    "Select IDs",
    {},  -- Will be populated when player is selected
    0,   -- Min select
    100, -- Max select
    {},  -- Preset options
    function(selected)
        selectedIDs = {}
        for _, fullName in ipairs(selected) do
            local id = fullName:match(": (.+)$")
            if id then
                table.insert(selectedIDs, id)
            end
        end
    end
)
-- Selected player and IDs

-- Create player dropdown
local playerDropdown = MisccSection:CreateDropdown(
    "Select Player",
    GetPlayerList(),
    1,
    function(playerName)
        selectedPlayer = Players:FindFirstChild(playerName)
        if selectedPlayer then
            -- Get new IDs
            local newIDs = GetPlayerIDs(selectedPlayer)
            local idOptions = {}
            for _, idInfo in ipairs(newIDs) do
                table.insert(idOptions, idInfo.name .. ": " .. idInfo.id)
            end
            
            -- Refresh multidropdown with new IDs
            multiDropdown.Refresh(idOptions, 1, function(selected)
                selectedIDs = {}
                for _, fullName in ipairs(selected) do
                    local id = fullName:match(": (.+)$")
                    if id then
                        table.insert(selectedIDs, id)
                    end
                end
            end)
        end
    end
)

-- Create multi dropdown for IDs


MisccSection:CreateButton(
    "Copy Selected IDs",
    function()
        if #selectedIDs > 0 then
            setclipboard(table.concat(selectedIDs, "\n"))
        end
    end
)

-- Create copy all button
MisccSection:CreateButton(
    "Copy All IDs (Formatted)",
    function()
        if selectedPlayer then
            local ids = GetPlayerIDs(selectedPlayer)
            local formattedText = {}
            for _, idInfo in ipairs(ids) do
                table.insert(formattedText, idInfo.name .. ": " .. idInfo.id)
            end
            setclipboard(table.concat(formattedText, "\n"))
        end
    end
)

-- Auto-refresh functionality
local function AutoRefresh()
    local playerList = GetPlayerList()
    playerDropdown.Refresh(playerList, 1)
    
    if selectedPlayer then
        local newIDs = GetPlayerIDs(selectedPlayer)
        local idOptions = {}
        for _, idInfo in ipairs(newIDs) do
            table.insert(idOptions, idInfo.name .. ": " .. idInfo.id)
        end
        multiDropdown.Refresh(idOptions, 1)
    end
end




-- Set up auto-refresh
MisccSection:CreateButton("Refresh Player", function()
    AutoRefresh()
end)
-- Dex
MisccSection:CreateButton("Dex", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/MDD.lua"))()
end)

-- Antisit
local antisitEnabled = false
local antisitConnection = nil
local function enableAntisit()
    antisitEnabled = true
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid.Sit = false
        if antisitConnection then antisitConnection:Disconnect() end
        antisitConnection = humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
            if humanoid.Sit then
                humanoid.Sit = false
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end

local function disableAntisit()
    antisitEnabled = false
    if antisitConnection then
        antisitConnection:Disconnect()
        antisitConnection = nil
    end
end

player.CharacterAdded:Connect(function(char)
    if antisitEnabled then
        enableAntisit()
    end
end)

MisccSection:CreateToggle("Antisit", function(state)
    if state then
        enableAntisit()
    else
        disableAntisit()
    end
end)

-- Reset
local resetEnabled = false
local function enableReset()
    resetEnabled = true
    starterGui:SetCore("ResetButtonCallback", true)
end

local function disableReset()
    resetEnabled = false
    starterGui:SetCore("ResetButtonCallback", false)
end

MisccSection:CreateToggle("Enable Reset", function(state)
    if state then
        enableReset()
    else
        disableReset()
    end
end)

-- Leaderboard
local leaderboardEnabled = true
local function enableLeaderboard()
    leaderboardEnabled = true
    starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
end

local function disableLeaderboard()
    leaderboardEnabled = false
    starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end

MisccSection:CreateToggle("Enable Leaderboard", function(state)
    if state then
        enableLeaderboard()
    else
        disableLeaderboard()
    end
end)

-- Noclip
local noclipEnabled = false
local noclipConnection = nil
local function enableNoclip()
    noclipEnabled = true
    noclipConnection = runService.Stepped:Connect(function()
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

player.CharacterAdded:Connect(function(char)
    if noclipEnabled then
        enableNoclip()
    end
end)

MisccSection:CreateToggle("Noclip", function(state)
    if state then
        enableNoclip()
    else
        disableNoclip()
    end
end)

-- Fly (Dukungan Mobile)
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyUp = false
local flyDown = false

local function createMobileControls()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyControls"
    screenGui.Parent = game.CoreGui
    
    local upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 50, 0, 50)
    upButton.Position = UDim2.new(0.9, -60, 0.7, -60)
    upButton.Text = "⬆"
    upButton.Parent = screenGui
    upButton.MouseButton1Down:Connect(function() flyUp = true end)
    upButton.MouseButton1Up:Connect(function() flyUp = false end)
    
    local downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 50, 0, 50)
    downButton.Position = UDim2.new(0.9, -60, 0.7, 0)
    downButton.Text = "⬇"
    downButton.Parent = screenGui
    downButton.MouseButton1Down:Connect(function() flyDown = true end)
    downButton.MouseButton1Up:Connect(function() flyDown = false end)
    
    return screenGui
end

local function enableFly()
    flyEnabled = true
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = rootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.Parent = rootPart
    
    local mobileControls = nil
    if userInputService.TouchEnabled then
        mobileControls = createMobileControls()
    end

    flyConnection = runService.RenderStepped:Connect(function()
        if humanoid then
            humanoid.PlatformStand = true
            local direction = Vector3.new()
            local camLook = camera.CFrame.LookVector
            local moveDir = humanoid.MoveDirection * flySpeed
            
            if userInputService:IsKeyDown(Enum.KeyCode.Space) or flyUp then
                direction = direction + Vector3.new(0, flySpeed, 0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or flyDown then
                direction = direction - Vector3.new(0, flySpeed, 0)
            end
            
            bodyVelocity.Velocity = moveDir + direction
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camLook)
        end
    end)
end

local function disableFly()
    flyEnabled = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local char = player.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                    obj:Destroy()
                end
            end
        end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    if game.CoreGui:FindFirstChild("FlyControls") then
        game.CoreGui.FlyControls:Destroy()
    end
end

player.CharacterAdded:Connect(function(char)
    if flyEnabled then
        enableFly()
    end
end)

MisccSection:CreateToggle("Fly", function(state)
    if state then
        enableFly()
    else
        disableFly()
    end
end)

MisccSection:CreateSlider("Fly Speed", 10, 200, 50, false, function(value)
    flySpeed = value
end)

-- Lock Position (Anchor Humanoid)
local lockPositionEnabled = false
local function enableLockPosition()
    lockPositionEnabled = true
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = true
    end
end

local function disableLockPosition()
    lockPositionEnabled = false
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = false
    end
end

player.CharacterAdded:Connect(function(char)
    if lockPositionEnabled then
        enableLockPosition()
    end
end)

MisccSection:CreateToggle("Lock Position", function(state)
    if state then
        enableLockPosition()
    else
        disableLockPosition()
    end
end)

-- Teleport Tool
MiscSection:CreateButton("Teleport Tool", function()
    local tool = Instance.new("Tool")
    tool.Name = "TeleportTool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
    
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local targetPos = mouse.Hit.Position
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        end
    end)
end)

-- Gravity Changer
local defaultGravity = workspace.Gravity
MiscSection:CreateSlider("Gravity Changer", 0, 196.2, defaultGravity, false, function(value)
    workspace.Gravity = value
end)

-- Built-in ESP
local espEnabled = false
local espConnections = {}
local function enableESP()
    espEnabled = true
    for _, target in pairs(players:GetPlayers()) do
        if target ~= player and target.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 0)
            highlight.Parent = target.Character
            espConnections[target] = highlight
        end
    end
    
    players.PlayerAdded:Connect(function(newPlayer)
        if espEnabled and newPlayer ~= player then
            newPlayer.CharacterAdded:Connect(function(char)
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 0)
                highlight.Parent = char
                espConnections[newPlayer] = highlight
            end)
        end
    end)
end

local function disableESP()
    espEnabled = false
    for target, highlight in pairs(espConnections) do
        if highlight then
            highlight:Destroy()
        end
    end
    espConnections = {}
end

MisccSection:CreateToggle("ESP", function(state)
    if state then
        enableESP()
    else
        disableESP()
    end
end)

-- God Mode
local godModeEnabled = false
local godModeConnection = nil
local function enableGodMode()
    godModeEnabled = true
    godModeConnection = runService.Stepped:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end)
end

local function disableGodMode()
    godModeEnabled = false
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end

player.CharacterAdded:Connect(function(char)
    if godModeEnabled then
        enableGodMode()
    end
end)

MisccSection:CreateToggle("God Mode", function(state)
    if state then
        enableGodMode()
    else
        disableGodMode()
    end
end)

-- Hitbox Expander
local hitboxEnabled = false
local hitboxSize = 10
local hitboxConnections = {}
local function enableHitboxExpander()
    hitboxEnabled = true
    for _, target in pairs(players:GetPlayers()) do
        if target ~= player and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                head.Transparency = 0.7
                head.CanCollide = false
                hitboxConnections[target] = head
            end
        end
    end
    
    players.PlayerAdded:Connect(function(newPlayer)
        if hitboxEnabled and newPlayer ~= player then
            newPlayer.CharacterAdded:Connect(function(char)
                local head = char:WaitForChild("Head")
                head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                head.Transparency = 0.7
                head.CanCollide = false
                hitboxConnections[newPlayer] = head
            end)
        end
    end)
end

local function disableHitboxExpander()
    hitboxEnabled = false
    for target, head in pairs(hitboxConnections) do
        if head then
            head.Size = Vector3.new(2, 1, 1) -- Ukuran default kepala Roblox
            head.Transparency = 0
            head.CanCollide = true
        end
    end
    hitboxConnections = {}
end

MisccSection:CreateToggle("Hitbox Expander", function(state)
    if state then
        enableHitboxExpander()
    else
        disableHitboxExpander()
    end
end)

MisccSection:CreateSlider("Hitbox Size", 5, 500, 10, false, function(value)
    hitboxSize = value
    if hitboxEnabled then
        disableHitboxExpander()
        enableHitboxExpander()
    end
end)

-- Infinite Jump
local infJumpEnabled = false
local infJumpConnection = nil
local function enableInfJump()
    infJumpEnabled = true
    infJumpConnection = userInputService.JumpRequest:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function disableInfJump()
    infJumpEnabled = false
    if infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
end

MisccSection:CreateToggle("Infinite Jump", function(state)
    if state then
        enableInfJump()
    else
        disableInfJump()
    end
end)

local spinEnabled = false
local spinSpeed = 50  -- spin speed dalam derajat per detik
local spinConnection = nil

local function enableSpinner()
    spinEnabled = true
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = char.HumanoidRootPart

    spinConnection = runService.RenderStepped:Connect(function(delta)
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed) * delta, 0)
    end)
end

local function disableSpinner()
    spinEnabled = false
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

player.CharacterAdded:Connect(function(char)
    if spinEnabled then
        enableSpinner()
    end
end)

MiscSection:CreateToggle("Spinner", function(state)
    if state then
        enableSpinner()
    else
        disableSpinner()
    end
end)

MiscSection:CreateSlider("Spin Speed", 10, 1000, 50, false, function(value)
    spinSpeed = value
end)


-- Anti-Knockback
local antiKnockbackEnabled = false
local antiKnockbackConnection = nil
local function enableAntiKnockback()
    antiKnockbackEnabled = true
    antiKnockbackConnection = runService.Stepped:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local rootPart = char.HumanoidRootPart
            rootPart.Velocity = Vector3.new(0, rootPart.Velocity.Y, 0) -- Hanya pertahankan kecepatan vertikal
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function disableAntiKnockback()
    antiKnockbackEnabled = false
    if antiKnockbackConnection then
        antiKnockbackConnection:Disconnect()
        antiKnockbackConnection = nil
    end
end

player.CharacterAdded:Connect(function(char)
    if antiKnockbackEnabled then
        enableAntiKnockback()
    end
end)

MisccSection:CreateToggle("Anti-Knockback", function(state)
    if state then
        enableAntiKnockback()
    else
        disableAntiKnockback()
    end
end)

-- X-Ray
local xrayEnabled = false
local originalTransparency = {}
local function enableXRay()
    xrayEnabled = true
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) and not part:IsA("Terrain") then
            originalTransparency[part] = part.Transparency
            part.Transparency = 0.8
        end
    end
end

local function disableXRay()
    xrayEnabled = false
    for part, transparency in pairs(originalTransparency) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
    originalTransparency = {}
end

MisccSection:CreateToggle("X-Ray", function(state)
    if state then
        enableXRay()
    else
        disableXRay()
    end
end)

-- Day/Night Changer
local function setTime(isDay)
    if isDay then
        lighting.ClockTime = 12 -- Siang
    else
        lighting.ClockTime = 0 -- Malam
    end
end

MisccSection:CreateToggle("Day/Night Changer", function(state)
    setTime(state) -- True = Day, False = Night
end)

-- FOV Changer
local defaultFOV = camera.FieldOfView
MisccSection:CreateSlider("FOV Changer", 10, 120, defaultFOV, false, function(value)
    camera.FieldOfView = value
end)

-- Headless (Visual)
local headlessEnabled = false
local function enableHeadless()
    headlessEnabled = true
    local char = player.Character
    if char and char:FindFirstChild("Head") then
        local head = char.Head
        head.Transparency = 1
        for _, accessory in pairs(char:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                local handle = accessory.Handle
                if handle:FindFirstChild("FaceFrontAttachment") then
                    handle.Transparency = 1
                end
            end
        end
    end
end

local function disableHeadless()
    headlessEnabled = false
    local char = player.Character
    if char and char:FindFirstChild("Head") then
        local head = char.Head
        head.Transparency = 0
        for _, accessory in pairs(char:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                local handle = accessory.Handle
                if handle:FindFirstChild("FaceFrontAttachment") then
                    handle.Transparency = 0
                end
            end
        end
    end
end

player.CharacterAdded:Connect(function(char)
    if headlessEnabled then
        enableHeadless()
    end
end)

MisccSection:CreateToggle("Headless (Visual)", function(state)
    if state then
        enableHeadless()
    else
        disableHeadless()
    end
end)


-- Server Hop (Dengan Confirmation)
local function serverHop()
    local apiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, response = pcall(function()
        return httpService:GetAsync(apiUrl)
    end)
    if success then
        local servers = httpService:JSONDecode(response)
        local serverList = servers.data
        if #serverList > 0 then
            local randomServer = serverList[math.random(1, #serverList)]
            teleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, player)
        else
            Library:CreateNotification("Error", "I can't find any server", 4)
        end
    else
Library:CreateNotification("Error", "I can't fetch any server..", 5)
    end
end

MisccSection:CreateButton("Server Hop", function()
    Library:CreateNotification(
        "Confirmation",
        "Hop to a new server?",
        5,
        {"Yes", "No"},
        {
            function()
                Library:CreateNotification("Looking For a new server...", "Please wait..", 10)
                serverHop()
            end,
            nil
        }
    )
end)

-- Rejoin (Dengan Confirmation)
MisccSection:CreateButton("Rejoin", function()
    Library:CreateNotification(
        "Confirmation",
        "Rejoin the game?",
        5,
        {"Yes", "No"},
        {
            function()
                Library:CreateNotification("Rejoining this server...", "Please wait..", 10)
                teleportService:Teleport(game.PlaceId, player)
            end,
            nil
        }
    )
end)

-- Infinite Yield
MisccSection:CreateButton("Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Respawn
MisccSection:CreateButton("Respawn", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid:TakeDamage(humanoid.Health)
        wait(0.1)
        player:LoadCharacter()
        starterGui:SetCore("SendNotification", {Title = "Respawn", Text = "Respawned!", Duration = 2})
    end
end)
    local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomNotification"
ScreenGui.Parent = game.CoreGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 50)
Frame.Position = UDim2.new(1, -320, 1, -100)
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BackgroundTransparency = 0.2
Frame.Parent = ScreenGui
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -50, 1, 0)
TextLabel.Position = UDim2.new(0, 50, 0, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "Thank you for using my script!\nif you don't mind give me a like on the website"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Center
TextLabel.BackgroundTransparency = 1
TextLabel.Parent = Frame
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(0, 40, 0, 40)
ImageLabel.Position = UDim2.new(0, 5, 0.5, -20)
ImageLabel.Image = "rbxassetid://316605349"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Parent = Frame
Frame.Position = UDim2.new(1, 0, 1, -100)
Frame:TweenPosition(UDim2.new(1, -320, 1, -100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
Library:CreateNotification("Thank you for using my script", "This script made by Rndm.\nLibrary Version: Beta", 5, {"Alright", "That's cool"})
wait(6)

Frame:TweenPosition(UDim2.new(1, 0, 1, -100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true)
wait(0.5)
ScreenGui:Destroy()