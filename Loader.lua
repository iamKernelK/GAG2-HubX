-- ═══════════════════════════════════════════════════════════
-- 🖤 AXIS UI - PREMIUM DARK THEME (Part 1: Core Modules)
-- ═══════════════════════════════════════════════════════════

local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ==========================================
-- 🎨 THEME COLORS (Black & White Premium)
-- ==========================================
local THEME = {
    Background      = Color3.fromRGB(18, 18, 22),      -- Main dark background
    BackgroundLight = Color3.fromRGB(28, 28, 32),      -- Lighter dark for elements
    BackgroundHover = Color3.fromRGB(38, 38, 42),      -- Hover state
    TabSelected     = Color3.fromRGB(35, 35, 40),      -- Selected tab
    TextPrimary     = Color3.fromRGB(255, 255, 255),   -- White text
    TextSecondary   = Color3.fromRGB(160, 160, 160),   -- Gray text
    Border          = Color3.fromRGB(60, 60, 65),      -- Border color
    BorderActive    = Color3.fromRGB(255, 255, 255),   -- Active border
    Accent          = Color3.fromRGB(255, 255, 255),   -- White accent
    ToggleOn        = Color3.fromRGB(255, 255, 255),   -- Toggle ON
    ToggleOff       = Color3.fromRGB(60, 60, 60),      -- Toggle OFF
    SliderFill      = Color3.fromRGB(255, 255, 255),   -- Slider fill
    SliderTrack     = Color3.fromRGB(40, 40, 45),      -- Slider track
    DropdownBg      = Color3.fromRGB(25, 25, 30),      -- Dropdown background
    Success         = Color3.fromRGB(100, 255, 100),   -- Green success
    Error           = Color3.fromRGB(255, 80, 80),     -- Red error
}

-- ==========================================
-- ⚙️ UTILITY FUNCTIONS
-- ==========================================

local function MakeDraggable(dragPart, targetPart)
    local Dragging, DragInput, DragStart, StartPosition
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = targetPart.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            TweenService:Create(targetPart, TweenInfo.new(0.06, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end)
end

local function ApplyAnimatedGradient(instance, speed)
    speed = speed or 1.5
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    grad.Rotation = 0
    grad.Parent = instance
    
    -- Animation: White gradient moves left to right
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if instance and instance.Parent then
            grad.Offset = Vector2.new((math.sin(tick() * speed) + 1) / 2 * 0.3, 0)
        else
            connection:Disconnect()
        end
    end)
    return grad
end

local function ApplyStrokeGradient(instance)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    grad.Rotation = 45
    grad.Parent = instance
    return grad
end

-- ==========================================
-- 🪟 WINDOW MODULE
-- ==========================================

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    local TitleText = Options.Title or "Axis UI"
    local DescText = Options.Description or "Premium"
    local ThemeImage = Options.ThemeImage or "rbxassetid://103845371952278"
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisUI_" .. tostring(math.random(1000,9999))
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    pcall(function() self.ScreenGui.Parent = gethui() end)
    if not self.ScreenGui.Parent then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = THEME.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = self.MainFrame

    -- Animated gradient border
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.new(1, 1, 1)
    Stroke.Thickness = 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = self.MainFrame
    ApplyAnimatedGradient(Stroke, 1.2)

    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 60)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.ZIndex = 5
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 250, 0, 22)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = THEME.TextPrimary
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 5
    self.TitleLabel.Parent = self.TopBar

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 250, 0, 14)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 34)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = THEME.TextSecondary
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.ZIndex = 5
    self.DescLabel.Parent = self.TopBar

    -- Top Buttons
    local function CreateTopBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 18, 0, 18)
        btn.Position = UDim2.new(1, posOffset, 0.5, -9)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ImageColor3 = THEME.TextSecondary
        btn.ZIndex = 5
        btn.Parent = self.TopBar
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = THEME.TextPrimary, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, posOffset - 1, 0.5, -10)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = THEME.TextSecondary, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, posOffset, 0.5, -9)}):Play()
        end)
        return btn
    end

    self.CloseBtn = CreateTopBtn("Close", "rbxassetid://4458805208", -35)
    self.MaxBtn = CreateTopBtn("Maximize", "rbxassetid://103845371952278", -65)
    self.MinBtn = CreateTopBtn("Minimize", "rbxassetid://78357418744409", -95)

    -- Dividers
    local TopDivider = Instance.new("Frame", self.MainFrame)
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 60)
    TopDivider.BackgroundColor3 = THEME.Border
    TopDivider.BackgroundTransparency = 0.5
    TopDivider.BorderSizePixel = 0

    local SidebarDivider = Instance.new("Frame", self.MainFrame)
    SidebarDivider.Size = UDim2.new(0, 1, 1, -60)
    SidebarDivider.Position = UDim2.new(0, 170, 0, 60)
    SidebarDivider.BackgroundColor3 = THEME.Border
    SidebarDivider.BackgroundTransparency = 0.5
    SidebarDivider.BorderSizePixel = 0

    -- Tabs Menu
    self.TabsMenu = Instance.new("ScrollingFrame", self.MainFrame)
    self.TabsMenu.Name = "TabsMenu"
    self.TabsMenu.Size = UDim2.new(0, 170, 1, -60)
    self.TabsMenu.Position = UDim2.new(0, 0, 0, 60)
    self.TabsMenu.BackgroundTransparency = 1
    self.TabsMenu.ScrollBarThickness = 0
    
    local TabsLayout = Instance.new("UIListLayout", self.TabsMenu)
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 4)
    local TabsPadding = Instance.new("UIPadding", self.TabsMenu)
    TabsPadding.PaddingTop = UDim.new(0, 12)
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)

    -- Elements Menu
    self.ElementsMenu = Instance.new("ScrollingFrame", self.MainFrame)
    self.ElementsMenu.Name = "ElementsMenu"
    self.ElementsMenu.Size = UDim2.new(1, -171, 1, -60)
    self.ElementsMenu.Position = UDim2.new(0, 171, 0, 60)
    self.ElementsMenu.BackgroundTransparency = 1
    self.ElementsMenu.ScrollBarThickness = 3
    self.ElementsMenu.ScrollBarImageColor3 = THEME.TextSecondary
    self.ElementsMenu.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ElementsMenu.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- Floating Button
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    self.FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    self.FloatingBtn.Position = UDim2.new(0.5, 0, 0.1, 25)
    self.FloatingBtn.BackgroundColor3 = THEME.Background
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui
    
    local FloatCorner = Instance.new("UICorner", self.FloatingBtn)
    FloatCorner.CornerRadius = UDim.new(0, 10)
    
    local FloatIcon = Instance.new("ImageLabel", self.FloatingBtn)
    FloatIcon.Size = UDim2.new(1, -6, 1, -6)
    FloatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    FloatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = ThemeImage
    FloatIcon.ScaleType = Enum.ScaleType.Crop
    
    local FloatCorner2 = Instance.new("UICorner", FloatIcon)
    FloatCorner2.CornerRadius = UDim.new(0, 8)
    
    local FloatStroke = Instance.new("UIStroke", self.FloatingBtn)
    FloatStroke.Thickness = 1.5
    FloatStroke.Color = Color3.new(1,1,1)
    ApplyAnimatedGradient(FloatStroke, 1.5)
    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    -- Window Controls
    local isMaximized = false
    local normalSize = UDim2.new(0, 700, 0, 430)
    local maxSize = UDim2.new(0, 850, 0, 520)

    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
    end)

    self.MinBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.4)
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true
        self.FloatingBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 45, 0, 45)}):Play()
    end)

    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragStartPos = input.Position 
        end
    end)
    
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 5 then
                TweenService:Create(self.FloatingBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.wait(0.3)
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
            end
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.4)
        self.ScreenGui:Destroy()
    end)

    -- Open Animation
    TweenService:Create(self.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = normalSize}):Play()

    -- Store modules
    self._modules = {}
    
    return self
end

-- ==========================================
-- 📑 TAB MODULE
-- ==========================================

function AxisUI:CreateTab(Options)
    local Name = Options.Name or "Tab"
    local IconId = Options.Icon
    local Window = self

    local isFirstTab = false
    local existingTabs = 0
    for _, v in ipairs(Window.TabsMenu:GetChildren()) do
        if v:IsA("TextButton") then existingTabs = existingTabs + 1 end
    end
    if existingTabs == 0 then isFirstTab = true end

    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = Name .. "_TabBtn"
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.BackgroundColor3 = isFirstTab and THEME.TabSelected or Color3.fromRGB(0,0,0)
    TabButton.BackgroundTransparency = isFirstTab and 0 or 1
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.ClipsDescendants = true
    TabButton.Parent = Window.TabsMenu

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.BorderActive
    Stroke.Thickness = 1
    Stroke.Transparency = isFirstTab and 0.3 or 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = TabButton

    local TextOffset = 14
    if IconId then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Position = UDim2.new(0, 12, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Image = IconId
        Icon.ImageColor3 = isFirstTab and THEME.TextPrimary or THEME.TextSecondary
        Icon.Parent = TabButton
        TextOffset = 34
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -TextOffset - 10, 1, 0)
    Title.Position = UDim2.new(0, TextOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = isFirstTab and THEME.TextPrimary or THEME.TextSecondary
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TabButton

    -- Tab Container (ScrollingFrame for elements)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = Name .. "_Container"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Visible = isFirstTab
    TabContainer.ClipsDescendants = true
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Window.ElementsMenu

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.PaddingBottom = UDim.new(0, 20)
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
    Padding.Parent = TabContainer

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = TabContainer

    -- Tab Switch Logic
    TabButton.MouseButton1Click:Connect(function()
        if TabContainer.Visible then return end
        
        -- Hide all tabs
        for _, child in ipairs(Window.ElementsMenu:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        
        -- Reset all buttons
        for _, btn in ipairs(Window.TabsMenu:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1}):Play()
                TweenService:Create(btn:FindFirstChild("UIStroke"), TweenInfo.new(0.2), {Transparency = 1}):Play()
                
                local txt = btn:FindFirstChildOfClass("TextLabel")
                if txt then TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = THEME.TextSecondary}):Play() end
                
                local icon = btn:FindFirstChildOfClass("ImageLabel")
                if icon then TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = THEME.TextSecondary}):Play() end
            end
        end

        -- Activate this tab
        TabContainer.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {BackgroundColor3 = THEME.TabSelected, BackgroundTransparency = 0}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.25), {Transparency = 0.3}):Play()
        TweenService:Create(Title, TweenInfo.new(0.25), {TextColor3 = THEME.TextPrimary}):Play()
        
        local currentIcon = TabButton:FindFirstChildOfClass("ImageLabel")
        if currentIcon then TweenService:Create(currentIcon, TweenInfo.new(0.25), {ImageColor3 = THEME.TextPrimary}):Play() end
    end)
    
    TabButton.MouseEnter:Connect(function()
        if not TabContainer.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = THEME.BackgroundHover, BackgroundTransparency = 0.5}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not TabContainer.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1}):Play()
        end
    end)

    return TabContainer
end

-- ==========================================
-- 🏷️ SECTION LABEL MODULE (Divider Style)
-- ==========================================

function AxisUI:CreateSection(ParentFrame, SectionName)
    local Container = Instance.new("Frame")
    Container.Name = SectionName .. "_SectionLabel"
    -- ارتفاع 28: مسافة مناسبة فوق وتحت
    Container.Size = UDim2.new(1, 0, 0, 28)
    Container.BackgroundTransparency = 1
    Container.Parent = ParentFrame

    -- الخط الفاصل العلوي (اختياري - يعطي شكل احترافي)
    local TopLine = Instance.new("Frame", Container)
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 6)
    TopLine.BackgroundColor3 = THEME.Border
    TopLine.BackgroundTransparency = 0.5
    TopLine.BorderSizePixel = 0

    -- النص في المنتصف (مثل: - [ Config ] -)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    -- تنسيق النص: - [ الاسم ] -
    Title.Text = "- [ " .. SectionName .. " ] -"
    Title.TextColor3 = THEME.TextSecondary  -- رمادي فاتح (مثل الصورة)
    -- أو استخدم THEME.TextPrimary للأبيض الكامل
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    -- محاذاة عمودية للمنتصف
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Parent = Container

    -- الخط الفاصل السفلي (اختياري)
    local BottomLine = Instance.new("Frame", Container)
    BottomLine.Size = UDim2.new(1, 0, 0, 1)
    BottomLine.Position = UDim2.new(0, 0, 1, -6)
    BottomLine.BackgroundColor3 = THEME.Border
    BottomLine.BackgroundTransparency = 0.5
    BottomLine.BorderSizePixel = 0

    return Container
end

-- ==========================================
-- 🔘 BUTTON MODULE
-- ==========================================

function AxisUI:CreateButton(ParentFrame, Options)
    local text = Options.Name or "Button"
    local callback = Options.Callback or function() end
    local iconId = Options.Icon

    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = THEME.BackgroundLight
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = ParentFrame
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", Button)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Ripple Container
    local ClipContainer = Instance.new("Frame", Button)
    ClipContainer.Size = UDim2.new(1, 0, 1, 0)
    ClipContainer.BackgroundTransparency = 1
    ClipContainer.ClipsDescendants = true
    Instance.new("UICorner", ClipContainer).CornerRadius = UDim.new(0, 6)

    local TitleOffset = 15
    if iconId then
        local Icon = Instance.new("ImageLabel", Button)
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0, 14, 0.5, -9)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId
        Icon.ImageColor3 = THEME.TextPrimary
        Icon.ZIndex = 2
        TitleOffset = 38
    end

    local Title = Instance.new("TextLabel", Button)
    Title.Size = UDim2.new(1, -55, 1, 0)
    Title.Position = UDim2.new(0, TitleOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = THEME.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2

    local RightIcon = Instance.new("ImageLabel", Button)
    RightIcon.Size = UDim2.new(0, 16, 0, 16)
    RightIcon.Position = UDim2.new(1, -14, 0.5, 0)
    RightIcon.AnchorPoint = Vector2.new(1, 0.5)
    RightIcon.BackgroundTransparency = 1
    RightIcon.Image = "rbxassetid://107150227368485"
    RightIcon.ImageColor3 = THEME.TextSecondary
    RightIcon.ZIndex = 2

    -- Hover Effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundHover}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 0.3, Color = THEME.BorderActive}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundColor3 = THEME.BackgroundLight}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.25), {Transparency = 0.7, Color = THEME.Border}):Play()
    end)

    -- Ripple Effect
    Button.MouseButton1Down:Connect(function()
        local Mouse = Players.LocalPlayer:GetMouse()
        local X, Y = Mouse.X - Button.AbsolutePosition.X, Mouse.Y - Button.AbsolutePosition.Y
        
        local Ripple = Instance.new("Frame", ClipContainer)
        Ripple.BackgroundColor3 = THEME.TextPrimary
        Ripple.BackgroundTransparency = 0.5
        Ripple.Position = UDim2.new(0, X, 0, Y)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Ripple.ZIndex = 1
        Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)
        
        local targetSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.8
        TweenService:Create(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.5, function() Ripple:Destroy() end)
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- ==========================================
-- 🔄 TOGGLE MODULE
-- ==========================================

function AxisUI:CreateToggle(ParentFrame, Options)
    local TName = Options.Name or "Toggle"
    local TType = string.lower(Options.Type or "default")
    local State = Options.Default or false
    local Callback = Options.Callback or function() end
    local IconId = Options.Icon

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = TName .. "_Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = THEME.BackgroundLight
    ToggleFrame.Parent = ParentFrame
    
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", ToggleFrame)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local InteractBtn = Instance.new("TextButton")
    InteractBtn.Size = UDim2.new(1, 0, 1, 0)
    InteractBtn.BackgroundTransparency = 1
    InteractBtn.Text = ""
    InteractBtn.Parent = ToggleFrame

    local titleOffset = 15
    if IconId then
        local LeftIcon = Instance.new("ImageLabel")
        LeftIcon.Size = UDim2.new(0, 18, 0, 18)
        LeftIcon.Position = UDim2.new(0, 14, 0.5, -9)
        LeftIcon.BackgroundTransparency = 1
        LeftIcon.Image = IconId
        LeftIcon.ImageColor3 = THEME.TextPrimary
        LeftIcon.Parent = ToggleFrame
        titleOffset = 38
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Position = UDim2.new(0, titleOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TName
    Title.TextColor3 = THEME.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = ToggleFrame

    if TType == "box" then
        -- Box Style Toggle
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 22, 0, 22)
        Box.Position = UDim2.new(1, -14, 0.5, 0)
        Box.AnchorPoint = Vector2.new(1, 0.5)
        Box.BackgroundColor3 = THEME.Background
        Box.Parent = ToggleFrame
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)

        local BoxStroke = Instance.new("UIStroke", Box)
        BoxStroke.Thickness = 1.5
        BoxStroke.Color = THEME.Border

        local Check = Instance.new("ImageLabel")
        Check.Size = UDim2.new(0, 0, 0, 0)
        Check.AnchorPoint = Vector2.new(0.5, 0.5)
        Check.Position = UDim2.new(0.5, 0, 0.5, 0)
        Check.BackgroundTransparency = 1
        Check.Image = "rbxassetid://6257079049"
        Check.ImageColor3 = THEME.Background
        Check.Parent = Box

        local function Update()
            if State then
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOn}):Play()
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = THEME.ToggleOn}):Play()
                TweenService:Create(Check, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0.75, 0, 0.75, 0)}):Play()
            else
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Background}):Play()
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = THEME.Border}):Play()
                TweenService:Create(Check, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            end
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State; Update(); Callback(State) end)
        Update()
    else
        -- Default Pill Style Toggle (محدث)
        local Pill = Instance.new("Frame")
        Pill.Size = UDim2.new(0, 42, 0, 20)
        Pill.Position = UDim2.new(1, -14, 0.5, 0)
        Pill.AnchorPoint = Vector2.new(1, 0.5)
        Pill.BackgroundColor3 = State and THEME.ToggleOn or THEME.ToggleOff
        Pill.Parent = ToggleFrame
        Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0)

        -- الدائرة (Circle) - لونها يتغير حسب الحالة
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        -- الموقع يتغير حسب الحالة
        Circle.Position = State and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        Circle.AnchorPoint = Vector2.new(0, 0.5)
        -- ✅ لما يكون ON: الدائرة سوداء | لما يكون OFF: الدائرة بيضاء
        Circle.BackgroundColor3 = State and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        Circle.Parent = Pill
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        -- ظل خفيف للدائرة (يخليها أحلى)
        local CircleStroke = Instance.new("UIStroke", Circle)
        CircleStroke.Color = State and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(200, 200, 200)
        CircleStroke.Thickness = 0.5
        CircleStroke.Transparency = 0.5

        local function Update()
            -- لون الخلفية: ON = أبيض | OFF = رمادي داكن
            local targetBg = State and THEME.ToggleOn or THEME.ToggleOff
            -- موقع الدائرة: ON = يمين | OFF = يسار
            local targetPos = State and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            -- لون الدائرة: ON = أسود | OFF = أبيض
            local targetCircleColor = State and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            -- لون ظل الدائرة
            local targetStrokeColor = State and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(200, 200, 200)

            TweenService:Create(Pill, TweenInfo.new(0.25), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = targetPos,
                BackgroundColor3 = targetCircleColor
            }):Play()
            TweenService:Create(CircleStroke, TweenInfo.new(0.25), {Color = targetStrokeColor}):Play()
        end

        InteractBtn.MouseButton1Click:Connect(function() 
            State = not State
            Update()
            Callback(State)
        end)
        Update()
    end

    InteractBtn.MouseEnter:Connect(function() 
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundHover}):Play() 
    end)
    InteractBtn.MouseLeave:Connect(function() 
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundLight}):Play() 
    end)

    return ToggleFrame
end

-- ==========================================
-- 🎚️ SLIDER MODULE
-- ==========================================

function AxisUI:CreateSlider(ParentFrame, Options)
    local Name = Options.Name or "Slider"
    local Min = Options.Min or 0
    local Max = Options.Max or 100
    local Default = Options.Default or Min
    local IconID = Options.Icon
    local Callback = Options.Callback or function() end

    local SliderContainer = Instance.new("Frame", ParentFrame)
    SliderContainer.Size = UDim2.new(1, 0, 0, 48)
    SliderContainer.BackgroundColor3 = THEME.BackgroundLight
    SliderContainer.Parent = ParentFrame
    
    Instance.new("UICorner", SliderContainer).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", SliderContainer)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Header = Instance.new("Frame", SliderContainer)
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.Position = UDim2.new(0, 0, 0, 6)
    Header.BackgroundTransparency = 1

    local TitleOffset = 12
    if IconID then
        local Icon = Instance.new("ImageLabel", Header)
        Icon.Size = UDim2.new(0, 14, 0, 14)
        Icon.Position = UDim2.new(0, 12, 0.5, -7)
        Icon.BackgroundTransparency = 1
        Icon.Image = IconID
        Icon.ImageColor3 = THEME.TextPrimary
        TitleOffset = 30
    end

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, TitleOffset, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = THEME.TextPrimary
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ValueDisplay = Instance.new("TextLabel", Header)
    ValueDisplay.Size = UDim2.new(0, 50, 1, 0)
    ValueDisplay.Position = UDim2.new(1, -12, 0, 0)
    ValueDisplay.AnchorPoint = Vector2.new(1, 0)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = tostring(Default)
    ValueDisplay.TextColor3 = THEME.TextPrimary
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.TextSize = 12
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right

    local TrackArea = Instance.new("Frame", SliderContainer)
    TrackArea.Size = UDim2.new(1, -24, 0, 18)
    TrackArea.Position = UDim2.new(0, 12, 0, 26)
    TrackArea.BackgroundTransparency = 1

    local Track = Instance.new("Frame", TrackArea)
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0.5, -2)
    Track.BackgroundColor3 = THEME.SliderTrack
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = THEME.SliderFill
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Thumb = Instance.new("Frame", Track)
    Thumb.Size = UDim2.new(0, 14, 0, 14)
    Thumb.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
    Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)
    
    local ThumbStroke = Instance.new("UIStroke", Thumb)
    ThumbStroke.Color = THEME.Border
    ThumbStroke.Thickness = 1

    local Dragging = false
    local TargetPct = (Default - Min) / (Max - Min)
    local CurrentPct = TargetPct
    local Mouse = Players.LocalPlayer:GetMouse()

    Thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 18, 0, 18)}):Play()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if Dragging then
                Dragging = false
                TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 14, 0, 14)}):Play()
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if Dragging then
            local pos = math.clamp((Mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            TargetPct = pos
        end

        CurrentPct = CurrentPct + (TargetPct - CurrentPct) * 0.3
        if math.abs(TargetPct - CurrentPct) < 0.001 then CurrentPct = TargetPct end

        Thumb.Position = UDim2.new(CurrentPct, 0, 0.5, 0)
        Fill.Size = UDim2.new(CurrentPct, 0, 1, 0)

        local val = math.floor(Min + (CurrentPct * (Max - Min)))
        ValueDisplay.Text = tostring(val)

        if Dragging or math.abs(TargetPct - CurrentPct) > 0.001 then
            Callback(val)
        end
    end)

    return SliderContainer
end

-- ==========================================
-- ⬇️ DROPDOWN MODULE
-- ==========================================
function AxisUI:CreateDropdown(ParentFrame, Options)
    local DName = Options.Name or "Dropdown"
    local OptionsList = Options.Options or {}
    local Max = Options.Max or 1
    local Callback = Options.Callback or function() end
    
    local SelectedOptions = {}
    local OptionButtons = {}
    local IsOpen = false
    local FollowConnection = nil

    -- Main Dropdown Button
    local DropdownFrame = Instance.new("TextButton")
    DropdownFrame.Name = DName .. "_Dropdown"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    DropdownFrame.BackgroundColor3 = THEME.BackgroundLight
    DropdownFrame.AutoButtonColor = false
    DropdownFrame.Text = ""
    DropdownFrame.Parent = ParentFrame

    Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", DropdownFrame)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Left Active Indicator Line (الخط الصغير على اليسار عند التشغيل/التحديد)
    local ActiveIndicator = Instance.new("Frame", DropdownFrame)
    ActiveIndicator.Name = "ActiveIndicator"
    ActiveIndicator.Size = UDim2.new(0, 3, 0, 16)
    ActiveIndicator.Position = UDim2.new(0, 0, 0.5, 0)
    ActiveIndicator.AnchorPoint = Vector2.new(0, 0.5)
    ActiveIndicator.BackgroundColor3 = THEME.Accent or Color3.fromRGB(255, 255, 255)
    ActiveIndicator.BorderSizePixel = 0
    ActiveIndicator.BackgroundTransparency = 1
    Instance.new("UICorner", ActiveIndicator).CornerRadius = UDim.new(1, 0)

    local Title = Instance.new("TextLabel", DropdownFrame)
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = DName
    Title.TextColor3 = THEME.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local ValueText = Instance.new("TextLabel", DropdownFrame)
    ValueText.Size = UDim2.new(0.5, -35, 1, 0)
    ValueText.Position = UDim2.new(0.5, 0, 0, 0)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = "..."
    ValueText.TextColor3 = THEME.TextSecondary
    ValueText.Font = Enum.Font.GothamMedium
    ValueText.TextSize = 12
    ValueText.TextXAlignment = Enum.TextXAlignment.Right

    local Arrow = Instance.new("ImageLabel", DropdownFrame)
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -14, 0.5, 0)
    Arrow.AnchorPoint = Vector2.new(1, 0.5)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://131833120209646"
    Arrow.ImageColor3 = THEME.TextSecondary
    Arrow.ScaleType = Enum.ScaleType.Fit

    -- Floating List (القائمة المنسدلة الطويلة مع حقل البحث)
    local ScreenGui = ParentFrame:FindFirstAncestorOfClass("ScreenGui")
    
    local FloatingFrame = Instance.new("Frame")
    FloatingFrame.Size = UDim2.new(0, 0, 0, 0)
    FloatingFrame.BackgroundColor3 = THEME.DropdownBg or THEME.BackgroundLight
    FloatingFrame.ZIndex = 100
    FloatingFrame.ClipsDescendants = true
    FloatingFrame.Visible = false
    FloatingFrame.Parent = ScreenGui

    Instance.new("UICorner", FloatingFrame).CornerRadius = UDim.new(0, 6)
    local FloatStroke = Instance.new("UIStroke", FloatingFrame)
    FloatStroke.Color = THEME.Border
    FloatStroke.Transparency = 0.5

    -- Search Box Container (حقل البحث بالأعلى داخل القائمة)
    local SearchContainer = Instance.new("Frame", FloatingFrame)
    SearchContainer.Name = "SearchContainer"
    SearchContainer.Size = UDim2.new(1, -12, 0, 32)
    SearchContainer.Position = UDim2.new(0, 6, 0, 6)
    SearchContainer.BackgroundColor3 = THEME.BackgroundDark or Color3.fromRGB(30, 30, 30)
    SearchContainer.BackgroundTransparency = 0.5
    SearchContainer.ZIndex = 101

    Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 4)

    local SearchBox = Instance.new("TextBox", SearchContainer)
    SearchBox.Size = UDim2.new(1, -12, 1, 0)
    SearchBox.Position = UDim2.new(0, 6, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.PlaceholderText = "Search..."
    SearchBox.PlaceholderColor3 = THEME.TextSecondary
    SearchBox.Text = ""
    SearchBox.TextColor3 = THEME.TextPrimary
    SearchBox.Font = Enum.Font.GothamMedium
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.ZIndex = 102

    -- Scrolling Frame for Options (قائمة العناصر الطويلة)
    local Scroll = Instance.new("ScrollingFrame", FloatingFrame)
    Scroll.Size = UDim2.new(1, 0, 1, -44)
    Scroll.Position = UDim2.new(0, 0, 0, 42)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = THEME.TextSecondary
    Scroll.ZIndex = 101

    local ListLayout = Instance.new("UIListLayout", Scroll)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ExpandedHeight = 220 -- الطول الطويل للقائمة مثل الصورة المطلوبة

    local function UpdateValueText()
        if #SelectedOptions == 0 then
            ValueText.Text = "..."
            ValueText.TextColor3 = THEME.TextSecondary
            TweenService:Create(ActiveIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        else
            TweenService:Create(ActiveIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            if #SelectedOptions == 1 then
                ValueText.Text = SelectedOptions[1]
                ValueText.TextColor3 = THEME.TextPrimary
            else
                ValueText.Text = #SelectedOptions .. "/" .. Max .. " Selected"
                ValueText.TextColor3 = THEME.TextPrimary
            end
        end
    end

    local function RefreshHighlights()
        for _, data in ipairs(OptionButtons) do
            if table.find(SelectedOptions, data.Text) then
                TweenService:Create(data.Btn, TweenInfo.new(0.2), {TextColor3 = THEME.TextPrimary}):Play()
            else
                TweenService:Create(data.Btn, TweenInfo.new(0.2), {TextColor3 = THEME.TextSecondary}):Play()
            end
        end
    end

    -- إنشاء أزرار الخيارات
    for _, option in ipairs(OptionsList) do
        local OptBtn = Instance.new("TextButton", Scroll)
        OptBtn.Size = UDim2.new(1, -8, 0, 28)
        OptBtn.BackgroundTransparency = 1
        OptBtn.Text = "  " .. option
        OptBtn.TextColor3 = THEME.TextSecondary
        OptBtn.Font = Enum.Font.GothamMedium
        OptBtn.TextSize = 12
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.ZIndex = 102
        
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
        table.insert(OptionButtons, {Btn = OptBtn, Text = option})

        OptBtn.MouseEnter:Connect(function()
            TweenService:Create(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, BackgroundColor3 = THEME.BackgroundHover}):Play()
        end)
        OptBtn.MouseLeave:Connect(function()
            TweenService:Create(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end)

        OptBtn.MouseButton1Click:Connect(function()
            local isSelected = table.find(SelectedOptions, option)

            if Max == 1 then
                SelectedOptions = {option}
                IsOpen = false
                SearchBox.Text = ""
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                TweenService:Create(FloatingFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, 0)}):Play()
                task.delay(0.2, function() FloatingFrame.Visible = false end)
                if FollowConnection then FollowConnection:Disconnect() end
            else
                if isSelected then
                    table.remove(SelectedOptions, isSelected)
                else
                    if #SelectedOptions < Max then
                        table.insert(SelectedOptions, option)
                    end
                end
            end

            UpdateValueText()
            RefreshHighlights()
            Callback(SelectedOptions)
        end)
    end

    -- نظام البحث الفوري
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchBox.Text)
        local visibleCount = 0

        for _, data in ipairs(OptionButtons) do
            if query == "" or string.find(string.lower(data.Text), query) then
                data.Btn.Visible = true
                visibleCount = visibleCount + 1
            else
                data.Btn.Visible = false
            end
        end

        Scroll.CanvasSize = UDim2.new(0, 0, 0, (visibleCount * 30) + 4)
    end)

    local function UpdateFloatingPosition()
        if DropdownFrame.Parent then
            local absPos = DropdownFrame.AbsolutePosition
            local absSize = DropdownFrame.AbsoluteSize
            FloatingFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
            FloatingFrame.Size = UDim2.new(0, absSize.X, FloatingFrame.Size.Y.Scale, FloatingFrame.Size.Y.Offset)
            Scroll.CanvasSize = UDim2.new(0, 0, 0, (#OptionsList * 30) + 4)
        end
    end

    local function ToggleDropdown()
        IsOpen = not IsOpen
        if IsOpen then
            FloatingFrame.Visible = true
            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            FollowConnection = RunService.RenderStepped:Connect(UpdateFloatingPosition)
            FloatingFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, 0)
            TweenService:Create(FloatingFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, ExpandedHeight)}):Play()
        else
            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            SearchBox.Text = "" -- إعادة تعيين البحث عند الاغلاق
            local closeTween = TweenService:Create(FloatingFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, 0)})
            closeTween:Play()
            closeTween.Completed:Wait()
            FloatingFrame.Visible = false
            if FollowConnection then FollowConnection:Disconnect() end
        end
    end

    DropdownFrame.MouseButton1Click:Connect(ToggleDropdown)

    local function IsMouseOver(frame)
        local mouse = UserInputService:GetMouseLocation()
        local pos = frame.AbsolutePosition
        local size = frame.AbsoluteSize
        return mouse.X >= pos.X and mouse.X <= pos.X + size.X and mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if IsOpen and not IsMouseOver(DropdownFrame) and not IsMouseOver(FloatingFrame) then
                ToggleDropdown()
            end
        end
    end)

    return DropdownFrame
end

-- ==========================================
-- 📝 TEXTBOX MODULE
-- ==========================================

function AxisUI:CreateTextbox(ParentFrame, Options)
    local TName = Options.Name or "Textbox"
    local Callback = Options.Callback or function() end
    local Placeholder = Options.Placeholder or "Type here..."
    local IconId = Options.Icon

    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = TName .. "_Textbox"
    TextboxFrame.Size = UDim2.new(1, 0, 0, 40)
    TextboxFrame.BackgroundColor3 = THEME.BackgroundLight
    TextboxFrame.Parent = ParentFrame

    Instance.new("UICorner", TextboxFrame).CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", TextboxFrame)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local titleOffset = 14
    if IconId then
        local LeftIcon = Instance.new("ImageLabel")
        LeftIcon.Size = UDim2.new(0, 18, 0, 18)
        LeftIcon.Position = UDim2.new(0, 14, 0.5, -9)
        LeftIcon.BackgroundTransparency = 1
        LeftIcon.Image = IconId
        LeftIcon.ImageColor3 = THEME.TextPrimary
        LeftIcon.Parent = TextboxFrame
        titleOffset = 38
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -180, 1, 0)
    Title.Position = UDim2.new(0, titleOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TName
    Title.TextColor3 = THEME.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TextboxFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 120, 0, 26)
    InputBox.Position = UDim2.new(1, -14, 0.5, 0)
    InputBox.AnchorPoint = Vector2.new(1, 0.5)
    InputBox.BackgroundColor3 = THEME.Background
    InputBox.Text = ""
    InputBox.PlaceholderText = Placeholder
    InputBox.TextColor3 = THEME.TextPrimary
    InputBox.PlaceholderColor3 = THEME.TextSecondary
    InputBox.Font = Enum.Font.GothamMedium
    InputBox.TextSize = 12
    InputBox.ClearTextOnFocus = false
    InputBox.ClipsDescendants = true
    InputBox.Parent = TextboxFrame

    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 5)

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = THEME.BorderActive
    InputStroke.Thickness = 1
    InputStroke.Transparency = 1
    InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    InputStroke.Parent = InputBox

    TextboxFrame.MouseEnter:Connect(function() 
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundHover}):Play() 
    end)
    TextboxFrame.MouseLeave:Connect(function() 
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundLight}):Play() 
    end)

    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        TweenService:Create(InputBox, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundHover}):Play()
    end)

    InputBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(InputBox, TweenInfo.new(0.3), {BackgroundColor3 = THEME.Background}):Play()
        Callback(InputBox.Text)
    end)

    return TextboxFrame
end

-- ==========================================
-- ⌨️ KEYBIND MODULE
-- ==========================================

function AxisUI:CreateKeybind(ParentFrame, Options)
    local KName = Options.Name or "Keybind"
    local CurrentKey = Options.Default or Enum.KeyCode.RightShift
    local Callback = Options.Callback or function() end
    
    local IsListening = false
    local Connection = nil

    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = KName .. "_Keybind"
    KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
    KeybindFrame.BackgroundColor3 = THEME.BackgroundLight
    KeybindFrame.Parent = ParentFrame

    Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", KeybindFrame)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = KName
    Title.TextColor3 = THEME.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = KeybindFrame

    local BindBox = Instance.new("TextButton")
    BindBox.Size = UDim2.new(0, 80, 0, 26)
    BindBox.Position = UDim2.new(1, -14, 0.5, 0)
    BindBox.AnchorPoint = Vector2.new(1, 0.5)
    BindBox.BackgroundColor3 = THEME.Background
    BindBox.Text = CurrentKey.Name
    BindBox.TextColor3 = THEME.TextPrimary
    BindBox.Font = Enum.Font.GothamBold
    BindBox.TextSize = 11
    BindBox.Parent = KeybindFrame

    Instance.new("UICorner", BindBox).CornerRadius = UDim.new(0, 5)
    local BoxStroke = Instance.new("UIStroke", BindBox)
    BoxStroke.Color = THEME.BorderActive
    BoxStroke.Thickness = 1
    BoxStroke.Transparency = 1

    local function StopListening()
        IsListening = false
        BindBox.Text = CurrentKey.Name
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Background}):Play()
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
    end

    BindBox.MouseButton1Click:Connect(function()
        if IsListening then return end
        IsListening = true
        BindBox.Text = "..."
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = THEME.BackgroundHover}):Play()

        Connection = UserInputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                StopListening()
                return
            end
            if Input.UserInputType == Enum.UserInputType.Keyboard then
                local key = Input.KeyCode
                if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Escape then
                    StopListening()
                else
                    CurrentKey = key
                    StopListening()
                    Callback(CurrentKey)
                end
            end
        end)
    end)

    return KeybindFrame
end

-- ==========================================
-- 🏷️ LABEL MODULE
-- ==========================================

function AxisUI:CreateLabel(ParentFrame, Options)
    local Text = Options.Name or "Information"

    local LabelFrame = Instance.new("TextLabel")
    LabelFrame.Size = UDim2.new(1, 0, 0, 22)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Text = "▸ " .. Text
    LabelFrame.TextColor3 = THEME.TextSecondary
    LabelFrame.Font = Enum.Font.GothamMedium
    LabelFrame.TextSize = 12
    LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
    LabelFrame.Parent = ParentFrame

    return LabelFrame
end

-- ==========================================
-- 🎨 COLORPICKER MODULE
-- ==========================================

function AxisUI:CreateColorpicker(ParentFrame, Options)
    local Name = Options.Name or "Color Picker"
    local Default = Options.Default or Color3.fromRGB(255, 255, 255)
    local Callback = Options.Callback or function() end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, 0, 0, 40)
    MainFrame.BackgroundColor3 = THEME.BackgroundLight
    MainFrame.Parent = ParentFrame
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = THEME.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local ColorShow = Instance.new("Frame")
    ColorShow.Size = UDim2.new(0, 28, 0, 18)
    ColorShow.Position = UDim2.new(1, -42, 0.5, -9)
    ColorShow.BackgroundColor3 = Default
    ColorShow.Parent = MainFrame
    Instance.new("UICorner", ColorShow).CornerRadius = UDim.new(0, 4)
    
    local ColorStroke = Instance.new("UIStroke", ColorShow)
    ColorStroke.Color = THEME.Border
    ColorStroke.Thickness = 1

    local InteractBtn = Instance.new("TextButton")
    InteractBtn.Size = UDim2.new(1, 0, 1, 0)
    InteractBtn.BackgroundTransparency = 1
    InteractBtn.Text = ""
    InteractBtn.Parent = MainFrame

    InteractBtn.MouseButton1Click:Connect(function()
        local newColor = Color3.fromRGB(math.random(200,255), math.random(200,255), math.random(200,255))
        TweenService:Create(ColorShow, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        Callback(newColor)
    end)

    return MainFrame
end

-- ═══════════════════════════════════════════════════════════
-- 🖤 AXIS UI - PREMIUM DARK THEME (Part 2: Floating HUD + Lock + Example)
-- ═══════════════════════════════════════════════════════════

-- ==========================================
-- 🔒 LOCK MODULE (CONTINUED)
-- ==========================================

function AxisUI:CreateLock(Element, Options)
    if not Element then return end
    
    local requiredCode = Options.Code
    local onUnlockCallback = Options.OnUnlock or function() end
    
    local LockOverlay = Instance.new("Frame")
    LockOverlay.Name = "AxisLock_Overlay"
    LockOverlay.Size = UDim2.new(1, 0, 1, 0)
    LockOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    LockOverlay.BackgroundTransparency = 0.15
    LockOverlay.ZIndex = 1000
    LockOverlay.Active = true
    LockOverlay.ClipsDescendants = true
    LockOverlay.Parent = Element
    
    Instance.new("UICorner", LockOverlay).CornerRadius = UDim.new(0, 6)

    local LockStroke = Instance.new("UIStroke", LockOverlay)
    LockStroke.Color = THEME.Border
    LockStroke.Thickness = 1
    LockStroke.Transparency = 0.7
    TweenService:Create(LockStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.3}):Play()

    local LockIcon = Instance.new("ImageLabel")
    LockIcon.BackgroundTransparency = 1
    LockIcon.Image = "rbxassetid://15117261700"
    LockIcon.ImageColor3 = THEME.TextSecondary
    LockIcon.ZIndex = 1001
    LockIcon.Parent = LockOverlay

    local StatusText = Instance.new("TextLabel")
    StatusText.BackgroundTransparency = 1
    StatusText.TextColor3 = THEME.TextSecondary
    StatusText.Font = Enum.Font.GothamBold
    StatusText.TextSize = 12
    StatusText.ZIndex = 1001
    StatusText.Parent = LockOverlay

    local CodeBox
    if requiredCode then
        CodeBox = Instance.new("TextBox")
        CodeBox.BackgroundColor3 = THEME.Background
        CodeBox.PlaceholderText = "Enter Code"
        CodeBox.Text = ""
        CodeBox.TextColor3 = THEME.TextPrimary
        CodeBox.PlaceholderColor3 = THEME.TextSecondary
        CodeBox.Font = Enum.Font.GothamMedium
        CodeBox.TextSize = 11
        CodeBox.ZIndex = 1002
        CodeBox.Parent = LockOverlay
        
        Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0, 6)
        local BoxStroke = Instance.new("UIStroke", CodeBox)
        BoxStroke.Color = THEME.BorderActive
        BoxStroke.Thickness = 1
        BoxStroke.Transparency = 0.5
    end

    local function UpdateLayout()
        local sizeY = Element.AbsoluteSize.Y
        if sizeY <= 65 then
            LockIcon.Size = UDim2.new(0, 18, 0, 18)
            LockIcon.Position = UDim2.new(0, 15, 0.5, -9)
            LockIcon.AnchorPoint = Vector2.new(0, 0)

            StatusText.Size = UDim2.new(0, 120, 1, 0)
            StatusText.Position = UDim2.new(0, 42, 0, 0)
            StatusText.TextXAlignment = Enum.TextXAlignment.Left
            StatusText.TextYAlignment = Enum.TextYAlignment.Center
            StatusText.Text = requiredCode and "Requires Code" or "Locked"

            if CodeBox then
                CodeBox.Size = UDim2.new(0, 85, 0, 24)
                CodeBox.Position = UDim2.new(1, -12, 0.5, 0)
                CodeBox.AnchorPoint = Vector2.new(1, 0.5)
            end
        else
            LockIcon.Size = UDim2.new(0, 32, 0, 32)
            LockIcon.Position = UDim2.new(0.5, 0, 0.4, 0)
            LockIcon.AnchorPoint = Vector2.new(0.5, 0.5)

            StatusText.Size = UDim2.new(1, 0, 0, 25)
            StatusText.Position = UDim2.new(0, 0, 0.55, 0)
            StatusText.TextXAlignment = Enum.TextXAlignment.Center
            StatusText.TextYAlignment = Enum.TextYAlignment.Center
            StatusText.TextSize = 14
            StatusText.Text = requiredCode and "This Section Requires an Access Code" or "Content Locked By Developer"

            if CodeBox then
                CodeBox.Size = UDim2.new(0, 140, 0, 30)
                CodeBox.Position = UDim2.new(0.5, 0, 0.72, 0)
                CodeBox.AnchorPoint = Vector2.new(0.5, 0.5)
                CodeBox.TextSize = 13
            end
        end
    end

    UpdateLayout()
    Element:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateLayout)

    if CodeBox then
        CodeBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local input = CodeBox.Text
                CodeBox.Text = ""
                if input == "" then return end
                
                CodeBox.Visible = false

                -- Verification animation
                for i = 1, 2 do
                    StatusText.Text = "Verifying Access." task.wait(0.2)
                    StatusText.Text = "Verifying Access.." task.wait(0.2)
                    StatusText.Text = "Verifying Access..." task.wait(0.2)
                end

                if input == tostring(requiredCode) then
                    -- Success
                    StatusText.Text = "Access Granted!"
                    StatusText.TextColor3 = THEME.Success
                    LockIcon.ImageColor3 = THEME.Success
                    LockStroke.Color = THEME.Success
                    
                    TweenService:Create(LockIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                    task.wait(0.2)
                    LockIcon.Image = "rbxassetid://13132087769"
                    local targetSize = Element.AbsoluteSize.Y <= 65 and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 36, 0, 36)
                    TweenService:Create(LockIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = targetSize}):Play()

                    task.wait(1.5)
                    
                    local fade = TweenService:Create(LockOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                    TweenService:Create(LockIcon, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
                    TweenService:Create(StatusText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                    TweenService:Create(LockStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
                    fade:Play()
                    
                    fade.Completed:Connect(function()
                        LockOverlay:Destroy()
                        onUnlockCallback()
                    end)
                else
                    -- Error
                    StatusText.Text = "Access Denied!"
                    StatusText.TextColor3 = THEME.Error
                    LockIcon.ImageColor3 = THEME.Error
                    LockStroke.Color = THEME.Error
                    
                    local origPos = StatusText.Position
                    for i = 1, 6 do
                        StatusText.Position = origPos + UDim2.new(0, math.random(-3, 3), 0, 0)
                        task.wait(0.04)
                    end
                    StatusText.Position = origPos
                    
                    task.wait(1.2)
                    StatusText.TextColor3 = THEME.TextSecondary
                    LockIcon.ImageColor3 = THEME.TextSecondary
                    LockStroke.Color = THEME.Border
                    UpdateLayout()
                    CodeBox.Visible = true
                end
            end
        end)
    end
end

-- ==========================================
-- 🚀 FLOATING HUD MODULE
-- ==========================================

local FloatingModule = {}
FloatingModule.__index = FloatingModule

local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "AxisFloatingHUD"
FloatingGui.Parent = CoreGui

local SpawnRegions = {
    UDim2.new(0.5, -50, 0.1, 0),
    UDim2.new(0.1, 0, 0.5, -25),
    UDim2.new(0.9, -100, 0.5, -25),
    UDim2.new(0.2, 0, 0.8, 0),
    UDim2.new(0.8, -100, 0.8, 0)
}

local function MakeDraggableSimple(Frame)
    local dragging, dragInput, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function ApplyAnimatedStroke(Parent)
    local Stroke = Instance.new("UIStroke", Parent)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ApplyAnimatedGradient(Stroke, 2)
end

local function CreateFloatingElement(Type, Config, OriginalState)
    local Frame = Instance.new("Frame", FloatingGui)
    Frame.Size = (Type == "Slider") and UDim2.new(0, 150, 0, 70) or UDim2.new(0, 100, 0, Config.Icon and 80 or 50)
    Frame.Position = SpawnRegions[math.random(1, #SpawnRegions)]
    Frame.BackgroundColor3 = THEME.Background
    Frame.BackgroundTransparency = 0.1
    Frame.Active = true
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    ApplyAnimatedStroke(Frame)
    MakeDraggableSimple(Frame)

    local IconImg = nil
    if Config.Icon then
        IconImg = Instance.new("ImageLabel", Frame)
        IconImg.Size = UDim2.new(0, 28, 0, 28)
        IconImg.Position = UDim2.new(0.5, -14, 0.1, 0)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = Config.Icon
        IconImg.ImageColor3 = THEME.TextPrimary
    end

    local TextLab = Instance.new("TextLabel", Frame)
    TextLab.Size = Config.Icon and UDim2.new(1, 0, 0.4, 0) or UDim2.new(1, 0, 1, 0)
    TextLab.Position = Config.Icon and UDim2.new(0, 0, 0.5, 0) or UDim2.new(0, 0, 0, 0)
    TextLab.BackgroundTransparency = 1
    TextLab.Text = Config.Name or "Element"
    TextLab.Font = Enum.Font.GothamBold
    TextLab.TextSize = 13
    TextLab.TextColor3 = THEME.TextPrimary

    local Hitbox = Instance.new("TextButton", Frame)
    Hitbox.Size = UDim2.new(1, 0, 1, 0)
    Hitbox.BackgroundTransparency = 1
    Hitbox.Text = ""

    if Type == "Button" then
        Hitbox.MouseButton1Click:Connect(function()
            if Config.Callback then Config.Callback() end
        end)
    elseif Type == "Toggle" then
        local toggled = OriginalState or false
        TextLab.TextColor3 = toggled and THEME.Success or THEME.TextPrimary
        
        Hitbox.MouseButton1Click:Connect(function()
            toggled = not toggled
            TextLab.TextColor3 = toggled and THEME.Success or THEME.TextPrimary
            if Config.Callback then Config.Callback(toggled) end
        end)
    elseif Type == "Slider" then
        Hitbox:Destroy()
        TextLab.Position = UDim2.new(0, 0, 0, 5)
        TextLab.Size = UDim2.new(1, 0, 0.4, 0)

        local SliderBg = Instance.new("Frame", Frame)
        SliderBg.Size = UDim2.new(0.9, 0, 0.2, 0)
        SliderBg.Position = UDim2.new(0.05, 0, 0.6, 0)
        SliderBg.BackgroundColor3 = THEME.SliderTrack
        Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

        local SliderFill = Instance.new("Frame", SliderBg)
        SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        SliderFill.BackgroundColor3 = THEME.SliderFill
        Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

        local SlideBtn = Instance.new("TextButton", SliderBg)
        SlideBtn.Size = UDim2.new(1, 0, 1, 0)
        SlideBtn.BackgroundTransparency = 1
        SlideBtn.Text = ""

        local draggingSlider = false
        SlideBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relativeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                local val = math.floor(((Config.Max - Config.Min) * relativeX) + Config.Min)
                TextLab.Text = Config.Name .. " : " .. tostring(val)
                if Config.Callback then Config.Callback(val) end
            end
        end)
    end

    return Frame
end

function AxisUI:AttachFloating(ElementType, MainFrame, TextLabel, Config)
    if TextLabel then
        TextLabel.Position = UDim2.new(TextLabel.Position.X.Scale, TextLabel.Position.X.Offset + 25, TextLabel.Position.Y.Scale, TextLabel.Position.Y.Offset)
    end

    local AddBtn = Instance.new("TextButton", MainFrame)
    AddBtn.Size = UDim2.new(0, 18, 0, 18)
    AddBtn.Position = UDim2.new(0, 5, 0.5, -9)
    AddBtn.BackgroundColor3 = THEME.TextPrimary
    AddBtn.Text = "+"
    AddBtn.TextColor3 = THEME.Background
    AddBtn.Font = Enum.Font.GothamBold
    AddBtn.TextSize = 14
    
    Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(1, 0)
    
    local Stroke = Instance.new("UIStroke", AddBtn)
    Stroke.Color = THEME.Border
    Stroke.Thickness = 1.5

    local isInserted = false
    local SpawnedElement = nil

    AddBtn.MouseButton1Click:Connect(function()
        if not isInserted then
            isInserted = true
            AddBtn.Text = "-"
            AddBtn.TextColor3 = THEME.Error
            SpawnedElement = CreateFloatingElement(ElementType, Config, Config.State)
        else
            isInserted = false
            AddBtn.Text = "+"
            AddBtn.TextColor3 = THEME.Background
            if SpawnedElement then
                SpawnedElement:Destroy()
                SpawnedElement = nil
            end
        end
    end)
end

-- ==========================================
-- 📦 RETURN MODULE
-- ==========================================

return AxisUI
