local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local speedValue = 16
local isSpeedActive = false
local jumpValue = 50
local isJumpActive = false
local noclipActive = false
local flyActive = false
local flySpeed = 50
local infJumpActive = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RauanHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 200, 1, 0)
NotificationContainer.Position = UDim2.new(1, -210, 0, -20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotifList = Instance.new("UIListLayout")
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifList.Padding = UDim.new(0, 8)
NotifList.Parent = NotificationContainer

local function Notify(titleText, messageText)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 190, 0, 45)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
    NotifFrame.BackgroundTransparency = 0.2
    NotifFrame.Parent = NotificationContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(160, 80, 255)
    Stroke.Thickness = 1
    Stroke.Parent = NotifFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -16, 0, 16)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(180, 100, 255)
    Title.TextSize = 11
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = NotifFrame

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1, -16, 0, 18)
    Msg.Position = UDim2.new(0, 10, 0, 20)
    Msg.Text = messageText
    Msg.TextColor3 = Color3.fromRGB(220, 220, 230)
    Msg.TextSize = 10
    Msg.Font = Enum.Font.SourceSans
    Msg.TextXAlignment = Enum.TextXAlignment.Left
    Msg.BackgroundTransparency = 1
    Msg.Parent = NotifFrame

    task.delay(3, function()
        if NotifFrame and NotifFrame.Parent then
            local tween = TweenService:Create(NotifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
            tween:Play()
            tween.Completed:Connect(function() NotifFrame:Destroy() end)
        end
    end)
end

local function MakeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging, dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

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

MakeDraggable(ToggleButton, ToggleButton)

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

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

MakeDraggable(MainFrame, Header)

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
StatsLabel.Text = "FPS: --"
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
    PageScroll.CanvasSize = UDim2.new(0, 0, 0, 520)
    PageScroll.ScrollBarThickness = 4
    PageScroll.ScrollBarImageColor3 = Color3.fromRGB(160, 80, 255)
    PageScroll.Active = true
    PageScroll.ScrollingDirection = Enum.ScrollingDirection.Y
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

    local tabData = { Button = TabBtn, Indicator = Indicator, Page = PageScroll }

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

local MainHubPage, Tab1Data = CreateTabButton("Rauan Hub", 10)
local MenuPage, Tab2Data = CreateTabButton("Menu", 45)

Tab1Data.Page.Visible = true
Tab1Data.Indicator.Visible = true
Tab1Data.Button.TextColor3 = Color3.fromRGB(255, 255, 255)

local UserFrame = Instance.new("Frame")
UserFrame.Size = UDim2.new(1, 0, 0, 48)
UserFrame.Position = UDim2.new(0, 0, 1, -48)
UserFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
UserFrame.BorderSizePixel = 0
UserFrame.Parent = Sidebar

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 32, 0, 32)
AvatarImage.Position = UDim2.new(0, 8, 0.5, -16)
AvatarImage.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AvatarImage.BackgroundTransparency = 0
AvatarImage.Parent = UserFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

pcall(function()
    local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    AvatarImage.Image = content
end)

local DisplayName = Instance.new("TextLabel")
DisplayName.Size = UDim2.new(0, 80, 0, 12)
DisplayName.Position = UDim2.new(0, 46, 0, 10)
DisplayName.Text = LocalPlayer.DisplayName
DisplayName.TextColor3 = Color3.fromRGB(240, 240, 240)
DisplayName.TextSize = 11
DisplayName.Font = Enum.Font.SourceSansBold
DisplayName.TextXAlignment = Enum.TextXAlignment.Left
DisplayName.BackgroundTransparency = 1
DisplayName.Parent = UserFrame

local Username = Instance.new("TextLabel")
Username.Size = UDim2.new(0, 80, 0, 10)
Username.Position = UDim2.new(0, 46, 0, 24)
Username.Text = "@" .. LocalPlayer.Name
Username.TextColor3 = Color3.fromRGB(130, 80, 200)
Username.TextSize = 9
Username.Font = Enum.Font.SourceSans
Username.TextXAlignment = Enum.TextXAlignment.Left
Username.BackgroundTransparency = 1
Username.Parent = UserFrame

local Banner = Instance.new("Frame")
Banner.Size = UDim2.new(0.92, 0, 0, 75)
Banner.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
Banner.Parent = MainHubPage

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 8)
BannerCorner.Parent = Banner

local BannerTitle = Instance.new("TextLabel")
BannerTitle.Size = UDim2.new(0, 200, 0, 20)
BannerTitle.Position = UDim2.new(0, 15, 0, 14)
BannerTitle.Text = "Rauan Hub"
BannerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BannerTitle.TextSize = 20
BannerTitle.Font = Enum.Font.SourceSansBold
BannerTitle.TextXAlignment = Enum.TextXAlignment.Left
BannerTitle.BackgroundTransparency = 1
BannerTitle.Parent = Banner

local BannerSub = Instance.new("TextLabel")
BannerSub.Size = UDim2.new(0, 280, 0, 28)
BannerSub.Position = UDim2.new(0, 15, 0, 36)
BannerSub.Text = "Apenas um script simples para seu dia a dia, novas updates em breve!"
BannerSub.TextColor3 = Color3.fromRGB(150, 140, 170)
BannerSub.TextSize = 10
BannerSub.TextWrapped = true
BannerSub.Font = Enum.Font.SourceSans
BannerSub.TextXAlignment = Enum.TextXAlignment.Left
BannerSub.BackgroundTransparency = 1
BannerSub.Parent = Banner

local UpdateCard = Instance.new("Frame")
UpdateCard.Size = UDim2.new(0.92, 0, 0, 80)
UpdateCard.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
UpdateCard.Parent = MainHubPage

local UpdateCorner = Instance.new("UICorner")
UpdateCorner.CornerRadius = UDim.new(0, 8)
UpdateCorner.Parent = UpdateCard

local UpdateTitle = Instance.new("TextLabel")
UpdateTitle.Size = UDim2.new(0, 200, 0, 18)
UpdateTitle.Position = UDim2.new(0, 12, 0, 8)
UpdateTitle.Text = "🚀 Histórico de Updates"
UpdateTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
UpdateTitle.TextSize = 12
UpdateTitle.Font = Enum.Font.SourceSansBold
UpdateTitle.TextXAlignment = Enum.TextXAlignment.Left
UpdateTitle.BackgroundTransparency = 1
UpdateTitle.Parent = UpdateCard

local UpdateText = Instance.new("TextLabel")
UpdateText.Size = UDim2.new(0.95, 0, 0, 45)
UpdateText.Position = UDim2.new(0, 12, 0, 28)
UpdateText.Text = "• Nenhuma atualização no momento.\n• Novas funções em breve!"
UpdateText.TextColor3 = Color3.fromRGB(160, 160, 180)
UpdateText.TextSize = 11
UpdateText.Font = Enum.Font.SourceSans
UpdateText.TextXAlignment = Enum.TextXAlignment.Left
UpdateText.BackgroundTransparency = 1
UpdateText.Parent = UpdateCard

local SocialCard = Instance.new("Frame")
SocialCard.Size = UDim2.new(0.92, 0, 0, 120)
SocialCard.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SocialCard.Parent = MainHubPage

local SocialCorner = Instance.new("UICorner")
SocialCorner.CornerRadius = UDim.new(0, 8)
SocialCorner.Parent = SocialCard

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
    pcall(function()
        if type(setclipboard) == "function" then setclipboard("rauann.xxz")
        elseif type(toclipboard) == "function" then toclipboard("rauann.xxz")
        elseif type(set_clipboard) == "function" then set_clipboard("rauann.xxz")
        end
    end)
    CopyDiscordBtn.Text = "Copiado com Sucesso!"
    Notify("Rauan Hub", "Discord copiado para a área de transferência!")
    task.wait(2)
    CopyDiscordBtn.Text = "Copiar User do Discord"
end)

local function CreateFeatureControl(parent, titleText, defaultVal, onToggle, onValueChange)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.92, 0, 0, 80)
    Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Container.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Container

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
            Notify(titleText, "Status: Ativado")
        else
            ToggleBtn.Text = "Desativado"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
            Notify(titleText, "Status: Desativado")
        end
        onToggle(active)
    end)

    TextBox.FocusLost:Connect(function()
        local num = tonumber(TextBox.Text)
        if num then 
            onValueChange(num)
            Notify(titleText, "Valor alterado para: " .. tostring(num))
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
  
