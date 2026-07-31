-- RAUAN HUB - Multi-Tab UI para Mobile
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RauanHubGUI"
ScreenGui.ResetOnSpawn = false

-- Proteção para o Delta / Executores
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Ícone Flutuante (Abrir/Fechar)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Text = "HUB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 18.000
OpenBtn.Active = true
OpenBtn.Draggable = true

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 25)
OpenCorner.Parent = OpenBtn

-- Janela do Hub
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 340, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Barra Superior (Título e Fechar)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.Size = UDim2.new(1, 0, 0, 35)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "Rauan Hub Mobile"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Botão [X] Arrumado (Texto limpo, sem imagem de loading)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Container do Scroll Ajustado (Sem bugs ao arrastar)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Parent = MainFrame
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Position = UDim2.new(0, 10, 0, 45)
ScrollContainer.Size = UDim2.new(1, -20, 1, -55)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
ScrollContainer.ScrollBarThickness = 6
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Lógica de Abrir/Fechar
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-----------------------------------------------------
-- FUNÇÕES E BOTÕES DO HUB
-----------------------------------------------------

-- 1. Pulo Infinito (Infinite Jump)
local infJumpActive = false
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Parent = ScrollContainer
InfJumpBtn.Size = UDim2.new(1, -10, 0, 40)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
InfJumpBtn.Font = Enum.Font.SourceSansBold
InfJumpBtn.Text = "Pulo Infinito: OFF"
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
InfJumpBtn.TextSize = 15

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 8)
BtnCorner1.Parent = InfJumpBtn

InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpActive = not infJumpActive
    if infJumpActive then
        InfJumpBtn.Text = "Pulo Infinito: ON"
        InfJumpBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        InfJumpBtn.Text = "Pulo Infinito: OFF"
        InfJumpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 2. Toggle Fly (Voo)
local flyActive = false
local flySpeed = 50
local FlyBtn = Instance.new("TextButton")
FlyBtn.Parent = ScrollContainer
FlyBtn.Size = UDim2.new(1, -10, 0, 40)
FlyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.Text = "Voo (Fly): OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
FlyBtn.TextSize = 15

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = FlyBtn

FlyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    if flyActive then
        FlyBtn.Text = "Voo (Fly): ON"
        FlyBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        FlyBtn.Text = "Voo (Fly): OFF"
        FlyBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Sistema de Voo (Base)
local bodyVelocity, bodyGyro
RunService.RenderStepped:Connect(function()
    if flyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        
        if not root:FindFirstChild("RauanFlyVel") then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "RauanFlyVel"
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = root
        end
        
        if not root:FindFirstChild("RauanFlyGyro") then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Name = "RauanFlyGyro"
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.P = 9e4
            bodyGyro.Parent = root
        end
        
        bodyGyro.CFrame = camera.CFrame
        bodyVelocity.Velocity = camera.CFrame.LookVector * flySpeed
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if root:FindFirstChild("RauanFlyVel") then root.RauanFlyVel:Destroy() end
            if root:FindFirstChild("RauanFlyGyro") then root.RauanFlyGyro:Destroy() end
        end
    end
end)
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
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 80, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
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

-- Tabela para gerenciar abas
local Tabs = {}
local CurrentTab = nil

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
    PageScroll.CanvasSize = UDim2.new(0, 0, 0, 350)
    PageScroll.ScrollBarThickness = 3
    PageScroll.ScrollBarImageColor3 = Color3.fromRGB(160, 80, 255)
    PageScroll.Visible = false
    PageScroll.Parent = MainFrame

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 10)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.Parent = PageScroll

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 15)
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

-- Criar as 2 Abas
local MainHubPage, Tab1Data = CreateTabButton("Rauan Hub", 10)
local MenuPage, Tab2Data = CreateTabButton("Menu", 45)

-- Ativar primeira aba por padrão
Tab1Data.Page.Visible = true
Tab1Data.Indicator.Visible = true
Tab1Data.Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Perfil do Usuário no Rodapé
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
UserImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
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
-- CONTEÚDO ABA 1: RAUAN HUB (INFORMAÇÕES E REDES)
---------------------------------------------------------
-- Banner Principal
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

-- Card Redes Sociais
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
    setclipboard("rauann.xxz")
    CopyDiscordBtn.Text = "Copiado com Sucesso!"
    task.wait(2)
    CopyDiscordBtn.Text = "Copiar User do Discord"
end)

---------------------------------------------------------
-- CONTEÚDO ABA 2: MENU (SPEED, JUMP, FLY, NOCLIP)
---------------------------------------------------------
-- Função Genérica de Controle
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

-- Botão Simples de Toggle (Para Noclip e InfJump)
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

-- Criando os Controles do Menu
CreateFeatureControl(MenuPage, "Velocidade (Speed)", 16, function(state) isSpeedActive = state end, function(val) speedValue = val end)
CreateFeatureControl(MenuPage, "Pulo (Jump Booster)", 50, function(state) isJumpActive = state end, function(val) jumpValue = val end)
CreateFeatureControl(MenuPage, "Voo Mobile (Fly)", 50, function(state) flyActive = state end, function(val) flySpeed = val end)
CreateSimpleToggle(MenuPage, "Atravessar Paredes (Noclip)", function(state) noclipActive = state end)
CreateSimpleToggle(MenuPage, "Pulo Infinito (Inf Jump)", function(state) infJumpActive = state end)

---------------------------------------------------------
-- SISTEMAS & MECÂNICAS (FLY MOBILE, NOCLIP, INF JUMP)
---------------------------------------------------------
-- Atualização do FPS e Ping
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        local fps = math.floor(frameCount / (tick() - lastUpdate))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        StatsLabel.Text = "FPS: " .. tostring(fps) .. " | PING: " .. tostring(ping) .. "ms"
        frameCount = 0
        lastUpdate = tick()
    end
end)

-- Loop Noclip e Stats
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and noclipActive then
                part.CanCollide = false
            end
        end
        
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            if isSpeedActive then humanoid.WalkSpeed = speedValue end
            if isJumpActive then 
                humanoid.UseJumpPower = true
                humanoid.JumpPower = jumpValue 
            end
        end
    end
end)

-- Sistema de Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if infJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Sistema de Voo (Fly Mobile Suave)
local bodyVelocity, bodyGyro
RunService.RenderStepped:Connect(function()
    if flyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        
        if not root:FindFirstChild("RauanFlyVel") then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "RauanFlyVel"
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = root
        end
        
        if not root:FindFirstChild("RauanFlyGyro") then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Name = "RauanFlyGyro"
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.P = 9e4
            bodyGyro.Parent = root
        end
        
        bodyGyro.CFrame = camera.CFrame
        bodyVelocity.Velocity = camera.CFrame.LookVector * (flySpeed or 50)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if root:FindFirstChild("RauanFlyVel") then root.RauanFlyVel:Destroy() end
            if root:FindFirstChild("RauanFlyGyro") then root.RauanFlyGyro:Destroy() end
        end
    end
end)
