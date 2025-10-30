--// NovaZ UI Library v1.1
--// Design Dark com Tabs Laterais
--// Criado por você 😎

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title or "NovaZUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 300)
    Main.Position = UDim2.new(0.5, -275, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.Text = title or "NovaZ UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Main

    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 150, 1, -30)
    SideBar.Position = UDim2.new(0, 0, 0, 30)
    SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = Main

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -150, 1, -30)
    TabContainer.Position = UDim2.new(0, 150, 0, 30)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = SideBar
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    --// Minimizar
    local MinBtn = Instance.new("ImageButton")
    MinBtn.Size = UDim2.new(0, 25, 0, 25)
    MinBtn.Position = UDim2.new(1, -60, 0, 3)
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MinBtn.Image = "rbxassetid://71014873973869"
    MinBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Parent = Main

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinBtn

    --// Fechar
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -30, 0, 3)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    CloseBtn.Image = "rbxassetid://132781935997688"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Parent = Main

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    local Minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 550, 0, 35)}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 550, 0, 300)}):Play()
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
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = SideBar
        TabButton.AutoButtonColor = false

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1, -10, 1, -10)
        TabFrame.Position = UDim2.new(0, 5, 0, 5)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 4
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = TabContainer

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 6)
        Layout.Parent = TabFrame

        local Elements = {}

        function Elements:CreateButton(name, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Btn.Text = name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = TabFrame
            Btn.AutoButtonColor = false

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                if callback then
                    pcall(callback)
                end
            end)
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabFrame.Visible = true
            for _, b in pairs(SideBar:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)

        Tabs[tabName] = Elements
        return Elements
    end

    --// Notificação de carregamento
    local Notify = Instance.new("TextLabel")
    Notify.Size = UDim2.new(0, 200, 0, 25)
    Notify.Position = UDim2.new(1, -210, 1, -35)
    Notify.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    Notify.Text = "NovaZ UI Loaded!"
    Notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notify.Font = Enum.Font.GothamBold
    Notify.TextSize = 14
    Notify.BorderSizePixel = 0
    Notify.Parent = Main
    TweenService:Create(Notify, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
    task.wait(2)
    TweenService:Create(Notify, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    Notify:Destroy()

    return Library
end

return Library
