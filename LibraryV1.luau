local UltraXLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Criar Janela
function UltraXLib:CreateWindow(config)
	local Title = config.Title or "UltraXLib UI"
	local MainColor = config.MainColor or Color3.fromRGB(20, 20, 20)

	local ScreenGui = Instance.new("ScreenGui", CoreGui)
	ScreenGui.Name = "UltraXLib"
	ScreenGui.ResetOnSpawn = false

	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.BackgroundColor3 = MainColor
	Main.BorderSizePixel = 0
	Main.Name = "Main"
	Main.AnchorPoint = Vector2.new(0.5, 0.5)

	local UICorner = Instance.new("UICorner", Main)
	UICorner.CornerRadius = UDim.new(0, 10)

	local UIStroke = Instance.new("UIStroke", Main)
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1

	-- Título
	local TitleLabel = Instance.new("TextLabel", Main)
	TitleLabel.Text = Title
	TitleLabel.Size = UDim2.new(1, 0, 0, 40)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextScaled = true
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

	-- Drag
	local dragging, dragInput, dragStart, startPos
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	Main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Área de Tabs
	local TabButtons = Instance.new("Frame", Main)
	TabButtons.Name = "TabButtons"
	TabButtons.Size = UDim2.new(0, 120, 1, -40)
	TabButtons.Position = UDim2.new(0, 0, 0, 40)
	TabButtons.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

	local UICorner2 = Instance.new("UICorner", TabButtons)
	UICorner2.CornerRadius = UDim.new(0, 6)

	local UIList = Instance.new("UIListLayout", TabButtons)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder

	-- Área de Conteúdo
	local Pages = Instance.new("Folder", Main)
	Pages.Name = "Pages"

	local Tabs = {}

	function UltraXLib:CreateTab(tabName)
		local Button = Instance.new("TextButton", TabButtons)
		Button.Size = UDim2.new(1, 0, 0, 40)
		Button.Text = tabName
		Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		Button.Font = Enum.Font.GothamBold
		Button.TextScaled = true

		local Page = Instance.new("ScrollingFrame", Pages)
		Page.Size = UDim2.new(1, -130, 1, -50)
		Page.Position = UDim2.new(0, 130, 0, 40)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, 1, 0)
		Page.ScrollBarThickness = 4

		local PageLayout = Instance.new("UIListLayout", Page)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 6)

		Button.MouseButton1Click:Connect(function()
			for _, v in pairs(Pages:GetChildren()) do
				if v:IsA("ScrollingFrame") then v.Visible = false end
			end
			Page.Visible = true
		end)

		Tabs[tabName] = Page

		return {
			AddButton = function(_, name, callback)
				local Btn = Instance.new("TextButton", Page)
				Btn.Size = UDim2.new(1, -10, 0, 40)
				Btn.Text = name
				Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				Btn.Font = Enum.Font.Gotham
				Btn.TextScaled = true
				Btn.MouseButton1Click:Connect(callback)
			end,

			AddToggle = function(_, name, callback)
				local Toggle = Instance.new("TextButton", Page)
				Toggle.Size = UDim2.new(1, -10, 0, 40)
				Toggle.Text = "[ OFF ] "..name
				Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.Font = Enum.Font.Gotham
				Toggle.TextScaled = true

				local state = false
				Toggle.MouseButton1Click:Connect(function()
					state = not state
					Toggle.Text = state and "[ ON ] "..name or "[ OFF ] "..name
					callback(state)
				end)
			end
		}
	end

	return UltraXLib
end
