--// NovaZ UI Library v1.2
--// Design Dark com Tabs Laterais, Drag e Tema
--// Criado por você 😎

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

-- Tema padrão
Library.Theme = {
    MainColor = Color3.fromRGB(15,15,15),
    SideColor = Color3.fromRGB(20,20,20),
    TabColor = Color3.fromRGB(25,25,25),
    ButtonColor = Color3.fromRGB(35,35,35),
    ButtonHover = Color3.fromRGB(50,50,50),
    ButtonClick = Color3.fromRGB(60,60,60),
    TextColor = Color3.fromRGB(255,255,255),
    ToggleOn = Color3.fromRGB(0,200,0),
    ToggleOff = Color3.fromRGB(100,100,100)
}

function Library:SetTheme(theme)
    for k,v in pairs(theme) do
        self.Theme[k] = v
    end
end

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title or "NovaZUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0,550,0,300)
    Main.Position = UDim2.new(0.5,-275,0.5,-150)
    Main.BackgroundColor3 = self.Theme.MainColor
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    -- Drag
    local dragging = false
    local dragInput, mousePos, framePos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Main.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                      framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,30)
    Title.BackgroundColor3 = Color3.fromRGB(10,10,10)
    Title.Text = title or "NovaZ UI"
    Title.TextColor3 = self.Theme.TextColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Main

    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0,150,1,-30)
    SideBar.Position = UDim2.new(0,0,0,30)
    SideBar.BackgroundColor3 = self.Theme.SideColor
    SideBar.BorderSizePixel = 0
    SideBar.Parent = Main

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1,-150,1,-30)
    TabContainer.Position = UDim2.new(0,150,0,30)
    TabContainer.BackgroundColor3 = self.Theme.TabColor
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = SideBar
    UIListLayout.Padding = UDim.new(0,5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Minimizar
    local MinBtn = Instance.new("ImageButton")
    MinBtn.Size = UDim2.new(0,25,0,25)
    MinBtn.Position = UDim2.new(1,-60,0,3)
    MinBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    MinBtn.Image = "rbxassetid://71014873973869"
    MinBtn.ImageColor3 = self.Theme.TextColor
    MinBtn.Parent = Main

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1,0)
    MinCorner.Parent = MinBtn

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0,25,0,25)
    CloseBtn.Position = UDim2.new(1,-30,0,3)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
    CloseBtn.Image = "rbxassetid://132781935997688"
    CloseBtn.ImageColor3 = self.Theme.TextColor
    CloseBtn.Parent = Main

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1,0)
    CloseCorner.Parent = CloseBtn

    local Minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0,550,0,35)}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0,550,0,300)}):Play()
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local Tabs = {}

    function Library:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1,-10,0,30)
        TabButton.BackgroundColor3 = self.Theme.ButtonColor
        TabButton.Text = tabName
        TabButton.TextColor3 = self.Theme.TextColor
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = SideBar
        TabButton.AutoButtonColor = false

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1,-10,1,-10)
        TabFrame.Position = UDim2.new(0,5,0,5)
        TabFrame.CanvasSize = UDim2.new(0,0,0,0)
        TabFrame.ScrollBarThickness = 4
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = TabContainer

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0,6)
        Layout.Parent = TabFrame

        local Elements = {}

        function Elements:CreateButton(name, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1,-10,0,30)
            Btn.BackgroundColor3 = Library.Theme.ButtonColor
            Btn.Text = name
            Btn.TextColor3 = Library.Theme.TextColor
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = TabFrame
            Btn.AutoButtonColor = false

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.ButtonHover}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.ButtonColor}):Play()
            end)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme.ButtonClick}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.ButtonColor}):Play()
                if callback then pcall(callback) end
            end)
        end

        -- Toggle
        function Elements:CreateToggle(name, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1,-10,0,30)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7,0,1,0)
            Label.Text = name
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Library.Theme.TextColor
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.Parent = ToggleFrame

            local ToggleBtn = Instance.new("Frame")
            ToggleBtn.Size = UDim2.new(0,30,0,20)
            ToggleBtn.Position = UDim2.new(1,-35,0,5)
            ToggleBtn.BackgroundColor3 = default and Library.Theme.ToggleOn or Library.Theme.ToggleOff
            ToggleBtn.Parent = ToggleFrame

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0,4)
            UICorner.Parent = ToggleBtn

            local state = default or false
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                ToggleBtn.BackgroundColor3 = state and Library.Theme.ToggleOn or Library.Theme.ToggleOff
                if callback then pcall(callback,state) end
            end)
        end

        -- Slider
        function Elements:CreateSlider(name,min,max,default,callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1,-10,0,30)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = TabFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7,0,1,0)
            Label.Text = name.." : "..tostring(default)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Library.Theme.TextColor
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.Parent = SliderFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(0.7,0,0,5)
            Bar.Position = UDim2.new(0.25,0,0.5,-2)
            Bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Bar.Parent = SliderFrame

            local Handle = Instance.new("Frame")
            Handle.Size = UDim2.new(default/max,0,1,0)
            Handle.BackgroundColor3 = Library.Theme.ToggleOn
            Handle.Parent = Bar

            local dragging = false
            local UIS = game:GetService("UserInputService")
            Handle.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
                    Handle.Size = UDim2.new(pos,0,1,0)
                    local value = math.floor(min+(max-min)*pos)
                    Label.Text = name.." : "..tostring(value)
                    if callback then pcall(callback,value) end
                end
            end)
        end

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible=false end
            end
            TabFrame.Visible = true
            for _,b in pairs(SideBar:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Library.Theme.ButtonColor}):Play()
                end
            end
            TweenService:Create(TabButton,TweenInfo.new(0.2),{BackgroundColor3=Library.Theme.ButtonHover}):Play()
        end)

        Tabs[tabName] = Elements
        return Elements
    end

    return Library, Main, TabContainer
end

return Library
