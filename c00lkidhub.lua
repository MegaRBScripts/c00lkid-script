-- c00lkid Hub Script v1.7
-- Сделано в стиле легендарного c00lkid, доработано MEGARBHACK™ с АНТИБАНОМ

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 🔒 АНТИБАН by MEGARBHACK™
pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method):lower() == "kick" then
            warn("[АНТИБАН | MEGARBHACK™] Kick заблокирован!")
            return nil
        end
        return old(self, ...)
    end)

    LocalPlayer.Kick = function()
        warn("[АНТИБАН | MEGARBHACK™] Попытка прямого кика заблокирована!")
    end

    for _,v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:find("ban") or name:find("kick") then
                warn("[АНТИБАН | MEGARBHACK™] Удалён подозрительный Remote: "..v.Name)
                v:Destroy()
            end
        end
    end

    coroutine.wrap(function()
        while true do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                if char.Humanoid.Health < 5 then
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                    warn("[АНТИБАН | MEGARBHACK™] Восстановлено здоровье после попытки убийства.")
                end
            end
            wait(1)
        end
    end)()
end)

local function chat(msg)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 270, 0, 510)
main.Position = UDim2.new(0, 30, 0, 100)
main.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0, 0, 0)
title.TextColor3 = Color3.new(1, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Text = "c00lkid Hub™ - MEGARBHACK™"

local function makeBtn(text, y, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
    btn.TextColor3 = Color3.new(1,0,0)
    btn.MouseButton1Click:Connect(callback)
end

makeBtn("c00lkid Admin Commands", 40, function()
    chat("Type :fly / :unfly / :noclip / :tp [name] / :esp / :kill [name]")

    local cmds = {
        [":fly"] = function()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            bv.Velocity = Vector3.new(0,0,0)
            bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            spawn(function()
                while bv.Parent do
                    local dir = Vector3.zero
                    local cam = workspace.CurrentCamera.CFrame
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
                    bv.Velocity = dir.Magnitude > 0 and dir.Unit * 80 or Vector3.zero
                    wait()
                end
            end)
        end,
        [":unfly"] = function()
            LocalPlayer.Character.Humanoid.PlatformStand = false
            for _,v in pairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then v:Destroy() end
            end
        end,
        [":noclip"] = function()
            RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        end,
        [":esp"] = function()
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ESP") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESP"
                    box.Adornee = p.Character
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = p.Character:GetExtentsSize()
                    box.Color3 = Color3.new(1, 0, 0)
                    box.Transparency = 0.3
                    box.Parent = p.Character
                end
            end
        end,
        [":kill"] = function(name)
            for _,p in pairs(Players:GetPlayers()) do
                if string.lower(p.Name) == string.lower(name) and p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
        end,
        [":tp"] = function(name)
            for _,p in pairs(Players:GetPlayers()) do
                if string.lower(p.Name) == string.lower(name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end
        end
    }

    LocalPlayer.Chatted:Connect(function(msg)
        local args = string.split(msg, " ")
        if cmds[args[1]] then
            cmds[args[1]](args[2])
        end
    end)
end)

makeBtn("Kill All", 80, function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end)

makeBtn("TP to First Player", 120, function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            break
        end
    end
end)

makeBtn("Wallhack (Boxes)", 160, function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ESP") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP"
            box.Adornee = p.Character
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = p.Character:GetExtentsSize()
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.3
            box.Parent = p.Character
        end
    end
end)

makeBtn("Fly (Toggle F)", 200, function()
    local flying = false
    local bv
    local conn
    UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.F then
            flying = not flying
            if flying then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                    bv.Velocity = Vector3.zero
                    bv.Parent = hrp

                    conn = RunService.RenderStepped:Connect(function()
                        local dir = Vector3.zero
                        local cam = workspace.CurrentCamera.CFrame
                        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
                        bv.Velocity = dir.Magnitude > 0 and dir.Unit * 80 or Vector3.zero
                    end)
                end
            else
                if bv then bv:Destroy() end
                if conn then conn:Disconnect() end
            end
        end
    end)
end)

makeBtn("Noclip (Toggle N)", 240, function()
    local noclip = false
    UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.N then
            noclip = not noclip
        end
    end)
    RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

makeBtn("TP to Player (Select)", 280, function()
    local dropdown = Instance.new("Frame", main)
    dropdown.Size = UDim2.new(1, -20, 0, 150)
    dropdown.Position = UDim2.new(0, 10, 0, 320)
    dropdown.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    dropdown.BorderSizePixel = 1

    local layout = Instance.new("UIListLayout", dropdown)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local btn = Instance.new("TextButton", dropdown)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            btn.TextColor3 = Color3.new(1, 0, 0)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 16

            btn.MouseButton1Click:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
                dropdown:Destroy()
            end)
        end
    end
end)

makeBtn("GodMode", 360, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Name = "GodHumanoid"
        local newHumanoid = char.Humanoid:Clone()
        newHumanoid.Name = "Humanoid"
        newHumanoid.Parent = char
        wait(0.1)
        char:FindFirstChild("GodHumanoid"):Destroy()
        chat("GodMode Activated")
    end
end)

makeBtn("Heal", 400, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = char.Humanoid.MaxHealth
        chat("Healed to full")
    end
end)

makeBtn("Reset Character", 440, function()
    LocalPlayer:LoadCharacter()
    chat("Character Reset")
end)

chat("c00lkid Hub v1.7 (MEGARBHACK™ Edition) Fully Restored ✅")
