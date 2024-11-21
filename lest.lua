-- Silent Aim Configuration
getgenv().Silent = {
    Settings = {
        Enabled = true,                             -- Enable or disable silent aim
        AimPart = "HumanoidRootPart",               -- Default targeting part
        Prediction = 0.2,                           -- Aggressive prediction for better tracking
        WallCheck = true,                           -- Check if there are walls between you and the target
        Visualize = false,                          -- Disable visualizing the silent aim FOV
        AutoPrediction = true,                      -- Automatically adjust prediction based on target speed
    },
    FOV = {
        Enabled = false,                            -- Disable FOV circle entirely (set to true to enable visualization)
        Size = 10,                                  -- FOV size (can be adjusted)
        Filled = false,                             -- If true, the circle will be filled (for FOV visualization)
        Thickness = 1,                              -- Thickness of the FOV circle line
        Transparency = 100,                         -- Transparency of FOV circle (0 is fully visible, 100 is fully transparent)
        Color = Color3.fromRGB(0, 255, 0),          -- Color of the FOV circle (if enabled)
    },
    BodyParts = {                                 -- List of body parts to randomly target
        "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", 
        "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", 
        "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightLowerLeg", "RightFoot", 
        "RightUpperLeg",
    },
}

-- Function to smoothly interpolate between two positions (helps to make the aim look more natural)
local function smoothAim(currentPos, targetPos, speed)
    return currentPos:Lerp(targetPos, speed)  -- Smooth interpolation for gradual aim movement
end

-- Function to predict where the target will be based on its velocity
local function predictTargetPosition(target)
    local targetPos = target.HumanoidRootPart.Position
    if Silent.Settings.AutoPrediction then
        local velocity = target.HumanoidRootPart.Velocity
        targetPos = targetPos + velocity * Silent.Settings.Prediction  -- Adjust prediction based on velocity
    end
    return targetPos
end

-- Function to check if the target is visible (i.e., not blocked by walls)
local function isTargetVisible(target)
    local origin = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local direction = target.HumanoidRootPart.Position - origin
    local ray = Ray.new(origin, direction)
    local result = workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character)
    return result == nil  -- Return true if no obstacle between player and target
end

-- Function to randomly select a body part to aim at
local function selectBodyPart(target)
    local partName = Silent.BodyParts[math.random(1, #Silent.BodyParts)]  -- Random body part selection
    return target:FindFirstChild(partName)
end

-- Function to apply the silent aim behavior during each frame
game:GetService("RunService").Heartbeat:Connect(function()
    if Silent.Settings.Enabled then
        -- Iterate through all players in the game
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local target = player.Character

                -- Check if the target is visible and within FOV (if enabled)
                if isTargetVisible(target) then
                    local selectedPart = selectBodyPart(target)  -- Randomly select a body part
                    if selectedPart then
                        local targetPos = predictTargetPosition(target)  -- Get the predicted target position
                        local newAimPosition = smoothAim(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, selectedPart.Position, 0.1)
                        
                        -- Adjust the crosshair or aim position (depending on how the game handles aiming)
                        -- This can be added based on your specific setup, but here’s a simple placeholder:
                        -- game:GetService("UserInputService"):SetMouseLocation(newAimPosition.X, newAimPosition.Y)
                    end
                end
            end
        end
    end
end)

-- Load the script from your GitHub (replace with your raw URL)
loadstring(game:HttpGet("https://raw.githubusercontent.com/your-username/your-repository/main/silent_aim_script.lua", true))()
