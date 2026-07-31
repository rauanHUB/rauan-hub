-- RAUAN HUBs - Multi-Tab UI (Fix Delta Executer)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Função segura para Clipboard no Delta
local function SafeSetClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif set_clipboard then set_clipboard(text)
        end
    end)
end

-- Variáveis Globais de Estado
local speedValue = 16
local isSpeedActive = false
local jumpValue = 50
local isJumpActive = false
local noclipActive = false
local flyActive = false
local flySpeed = 50
local infJumpActive = false

-- Interface Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RauanHubGui"
ScreenGui.ResetOnSpawn = false

-- Suporte a CoreGui / PlayerGui seguro no Delta
local parentTarget
if gethui then
    pcall(function() parentTarget = gethui() end)
end
if not parentTarget then
    parentTarget = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.Parent = parentTarget

---------------------------------------------------------
-- BOTÃO FLUTUANTE (LETRA 'R')
---------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.85, 0, 0.65, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleButton.Text = "R"
ToggleButton.TextColor3 = Color3.fromRGB(160, 80, 255)
ToggleButton.TextSize = 28
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.ZIndex = 100
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 14)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(160, 80, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

---------------------------------------------------------
-- JANELA PRINCIPAL (MAIN FRAME)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 310)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

---------------------------------------------------------
-- BARRA SUPERIOR (HEADER)
---------------------------------------------------------
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 0, 18)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.Text = "Rauan Script"
Title.TextColor3 = Color3.fromRGB(170, 90, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 0, 14)
SubTitle.Position = UDim2.new(0, 15, 0, 21)
SubTitle.Text = "Mobile Script Hub"
SubTitle.TextColor3 = Color3.fromRGB(130, 130, 150)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.SourceSans
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.BackgroundTransparency = 1
SubTitle.Parent = Header

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 150, 1, 0)
StatsLabel.Position = UDim2.new(0.5, -75, 0, 0)
StatsLabel.Text = "FPS: 60 | PING: 0ms"
StatsLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
StatsLabel.TextSize = 11
StatsLabel.Font = Enum.Font.SourceSansBold
StatsLabel.BackgroundTransparency = 1
StatsLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(160, 80, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.ArialBold
CloseBtn.ZIndex = 10
CloseBtn.Parent = Header

---------------------------------------------------------
-- MENU LATERAL (SIDEBAR & NAVEGAÇÃO DE ABAS)
---------------------------------------------------------
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Tabs = {}

local function CreateTabButton(name, positionY)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.Position = UDim2.new(0, 0, 0, positionY)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "   " .. name
    TabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = Sidebar

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0, 18)
    Indicator.Position = UDim2.new(0, 0, 0.5, -9)
    Indicator.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = TabBtn

    local PageScroll = Instance.new("ScrollingFrame")
    PageScroll.Size = UDim2.new(1, -130, 1, -42)
    PageScroll.Position = UDim2.new(0, 130, 0, 42)
    PageScroll.BackgroundTransparency = 1
    PageScroll.CanvasSize = UDim2.new(0, 0, 0, 420)
    PageScroll.ScrollBarThickness = 4
    PageScroll.ScrollBarImageColor3 = Color3.fromRGB(160, 80, 255)
    PageScroll.Active = true
    PageScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    PageScroll.ElasticBehavior = Enum.ElasticBehavior.Never
    PageScroll.Visible = false
    PageScroll.Parent = MainFrame

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 10)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.Parent = PageScroll

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 20)
    PagePadding.Parent = PageScroll

    local tabData = {
        Button = TabBtn,
        Indicator = Indicator,
        Page = PageScroll
    }

    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            tab.Indicator.Visible = false
            tab.Button.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        PageScroll.Visible = true
        Indicator.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(Tabs, tabData)
    return PageScroll, tabData
end

-- Criar as Abas
local MainHubPage, Tab1Data = CreateTabButton("Rauan Hub", 10)
local MenuPage, Tab2Data = CreateTabButton("Menu", 45)

-- Ativar primeira aba por padrão
Tab1Data.Page.Visible = true
Tab1Data.Indicator.Visible = true
Tab1Data.Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Perfil do Usuário no Rodapé (Protegido contra erros do Delta)
local UserFrame = Instance.new("Frame")
UserFrame.Size = UDim2.new(1, 0, 0, 42)
UserFrame.Position = UDim2.new(0, 0, 1, -42)
UserFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
UserFrame.BorderSizePixel = 0
UserFrame.Parent = Sidebar

local UserImage = Instance.new("ImageLabel")
UserImage.Size = UDim2.new(0, 28, 0, 28)
UserImage.Position = UDim2.new(0, 8, 0.5, -14)
UserImage.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

-- Tenta carregar a imagem com fallback em caso de erro no Delta
pcall(function()
    UserImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
end)
UserImage.Parent = UserFrame

local UserImageCorner = Instance.new("UICorner")
UserImageCorner.CornerRadius = UDim.new(1, 0)
UserImageCorner.Parent = UserImage

local DisplayName = Instance.new("TextLabel")
DisplayName.Size = UDim2.new(0, 80, 0, 12)
DisplayName.Position = UDim2.new(0, 42, 0, 8)
DisplayName.Text = LocalPlayer.DisplayName
DisplayName.TextColor3 = Color3.fromRGB(240, 240, 240)
DisplayName.TextSize = 11
DisplayName.Font = Enum.Font.SourceSansBold
DisplayName.TextXAlignment = Enum.TextXAlignment.Left
DisplayName.BackgroundTransparency = 1
DisplayName.Parent = UserFrame

local Username = Instance.new("TextLabel")
Username.Size = UDim2.new(0, 80, 0, 10)
Username.Position = UDim2.new(0, 42, 0, 22)
Username.Text = "@" .. LocalPlayer.Name
Username.TextColor3 = Color3.fromRGB(130, 80, 200)
Username.TextSize = 9
Username.Font = Enum.Font.SourceSans
Username.TextXAlignment = Enum.TextXAlignment.Left
Username.BackgroundTransparency = 1
Username.Parent = UserFrame

---------------------------------------------------------
-- CONTEÚDO ABA 1: RAUAN HUB
---------------------------------------------------------
local Banner = Instance.new("Frame")
Banner.Size = UDim2.new(0.92, 0, 0, 75)
Banner.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
Banner.Parent = MainHubPage

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 8)
BannerCorner.Parent = Banner

local BannerLogo = Instance.new("TextLabel")
BannerLogo.Size = UDim2.new(0, 45, 0, 45)
BannerLogo.Position = UDim2.new(0, 12, 0.5, -22)
BannerLogo.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
BannerLogo.Text = "R"
BannerLogo.TextColor3 = Color3.fromRGB(180, 100, 255)
BannerLogo.TextSize = 32
BannerLogo.Font = Enum.Font.SourceSansBold
BannerLogo.Parent = Banner

local BannerLogoCorner = Instance.new("UICorner")
BannerLogoCorner.CornerRadius = UDim.new(0, 10)
BannerLogoCorner.Parent = BannerLogo

local BannerTitle = Instance.new("TextLabel")
BannerTitle.Size = UDim2.new(0, 200, 0, 20)
BannerTitle.Position = UDim2.new(0, 68, 0, 14)
BannerTitle.Text = "Rauan Hub"
BannerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BannerTitle.TextSize = 20
BannerTitle.Font = Enum.Font.SourceSansBold
BannerTitle.TextXAlignment = Enum.TextXAlignment.Left
BannerTitle.BackgroundTransparency = 1
BannerTitle.Parent = Banner

local BannerSub = Instance.new("TextLabel")
BannerSub.Size = UDim2.new(0, 240, 0, 28)
BannerSub.Position = UDim2.new(0, 68, 0, 36)
BannerSub.Text = "Apenas um script simples para seu dia a dia, novas updates em breve!"
BannerSub.TextColor3 = Color3.fromRGB(150, 140, 170)
BannerSub.TextSize = 10
BannerSub.TextWrapped = true
BannerSub.Font = Enum.Font.SourceSans
BannerSub.TextXAlignment = Enum.TextXAlignment.Left
BannerSub.BackgroundTransparency = 1
BannerSub.Parent = Banner

local SocialCard = Instance.new("Frame")
SocialCard.Size = UDim2.new(0.92, 0, 0, 120)
SocialCard.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SocialCard.Parent = MainHubPage

local SocialCorner = Instance.new("UICorner")
SocialCorner.CornerRadius = UDim.new(0, 8)
SocialCorner.Parent = SocialCard

local SocialStroke = Instance.new("UIStroke")
SocialStroke.Color = Color3.fromRGB(30, 30, 38)
SocialStroke.Parent = SocialCard

local SocialTitle = Instance.new("TextLabel")
SocialTitle.Size = UDim2.new(0, 200, 0, 18)
SocialTitle.Position = UDim2.new(0, 12, 0, 8)
SocialTitle.Text = "📑 Redes Oficiais"
SocialTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
SocialTitle.TextSize = 12
SocialTitle.Font = Enum.Font.SourceSansBold
SocialTitle.TextXAlignment = Enum.TextXAlignment.Left
SocialTitle.BackgroundTransparency = 1
SocialTitle.Parent = SocialCard

local SocialText = Instance.new("TextLabel")
SocialText.Size = UDim2.new(0.95, 0, 0, 50)
SocialText.Position = UDim2.new(0, 12, 0, 30)
SocialText.Text = "• Instagram: @rauann.xxz\n• TikTok: @rauann.xxz\n• Discord: rauann.xxz"
SocialText.TextColor3 = Color3.fromRGB(160, 160, 180)
SocialText.TextSize = 11
SocialText.Font = Enum.Font.SourceSans
SocialText.TextXAlignment = Enum.TextXAlignment.Left
SocialText.BackgroundTransparency = 1
SocialText.Parent = SocialCard

local CopyDiscordBtn = Instance.new("TextButton")
CopyDiscordBtn.Size = UDim2.new(0.9, 0, 0, 24)
CopyDiscordBtn.Position = UDim2.new(0.05, 0, 0, 88)
CopyDiscordBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
CopyDiscordBtn.Text = "Copiar User do Discord"
CopyDiscordBtn.TextColor3 = Color3.fromRGB(160, 90, 255)
CopyDiscordBtn.TextSize = 11
CopyDiscordBtn.Font = Enum.Font.SourceSansBold
CopyDiscordBtn.Parent = SocialCard

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 5)
CopyCorner.Parent = CopyDiscordBtn

CopyDiscordBtn.MouseButton1Click:Connect(function()
    SafeSetClipboard("rauann.xxz")
    CopyDiscordBtn.Text = "Copiado com Sucesso!"
    task.wait(2)
    CopyDiscordBtn.Text = "Copiar User do Discord"
end)

---------------------------------------------------------
-- CONTEÚDO ABA 2: MENU
---------------------------------------------------------
local function CreateFeatureControl(parent, titleText, defaultVal, onToggle, onValueChange)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.92, 0, 0, 80)
    Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Container.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Container

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(30, 30, 38)
    Stroke.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 18)
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.93, 0, 0, 22)
    TextBox.Position = UDim2.new(0.035, 0, 0, 25)
    TextBox.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    TextBox.Text = tostring(defaultVal)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 11
    TextBox.Font = Enum.Font.SourceSans
    TextBox.Parent = Container

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 5)
    BoxCorner.Parent = TextBox

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.93, 0, 0, 22)
    ToggleBtn.Position = UDim2.new(0.035, 0, 0, 51)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ToggleBtn.Text = "Desativado"
    ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.Parent = Container

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = ToggleBtn

    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            ToggleBtn.Text = "Ativado"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 240)
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.Text = "Desativado"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        onToggle(active)
    end)

    TextBox.FocusLost:Connect(function()
        local num = tonumber(TextBox.Text)
        if num then
            onValueChange(num)
        else
            TextBox.Text = tostring(defaultVal)
        end
    end)
end

local function CreateSimpleToggle(parent, titleText, onToggle)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.92, 0, 0, 50)
    Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Container.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Container

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(30, 30, 38)
    Stroke.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.3, 0, 0, 26)
    ToggleBtn.Position = UDim2.new(0.66, 0, 0.5, -13)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.Parent = Container

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = ToggleBtn

    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            ToggleBtn.Text = "ON"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 240)
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.Text = "OFF"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        onToggle(active)
    end)
end

CreateFeatureControl(MenuPage, "Velocidade (Speed)", 16, function(state) isSpeedActive = state end, function(val) speedValue = val end)
CreateFeatureControl(MenuPage, "Pulo (Jump Booster)", 50, function(state) isJumpActive = state end, function(val) jumpValue = val end)
CreateFeatureControl(MenuPage, "Voo Mobile (Fly)", 50, function(state) flyActive = state end, function(val) flySpeed = val end)
CreateSimpleToggle(MenuPage, "Atravessar Paredes (Noclip)", function(state) noclipActive = state end)
CreateSimpleToggle(MenuPage, "Pulo Infinito (Inf Jump)", function(state) infJumpActive = state end)

---------------------------------------------------------
-- SISTEMAS & MECÂNICAS
---------------------------------------------------------
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        local fps = math.floor(frameCount / (tick() - lastUpdate))
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        StatsLabel.Text = "FPS: " .. tostring(fps) .. " | PING: " .. tostring(ping) .. "ms"
        frameCount = 0
        lastUpdate = tick()
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        if noclipActive then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if isSpeedActive then humanoid.WalkSpeed = speedValue end
            if isJumpActive then 
                humanoid.UseJumpPower = true
                humanoid.JumpPower = jumpValue 
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpActive and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jump
