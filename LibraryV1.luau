local NovaZLib = {https://raw.githubusercontent.com/NovaZHub/NovaZXLIB/main/LibraryV1.luau}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function NovaZLib:CreateWindow(config)
	local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
	ScreenGui.Name = config.Name or "NovaZLibUI"
	ScreenGui.ResetOnSpawn = false

	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Main.BorderSizePixel = 0
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Name = "Main"
	Main.Active = true
	Main.Draggable = true

	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.Text = config.Title or "NovaZLib UI"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 24
	Title.Font = Enum.Font.GothamBold
	Title.Name = "Title"

	local TabHolder = Instance.new("Frame", Main)
	TabHolder.Position = UDim2.new(0, 0, 0, 40)
	TabHolder.Size = UDim2.new(0, 120, 1, -40)
	TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TabHolder.BorderSizePixel = 0

	local ContentHolder = Instance.new("Frame", Main)
	ContentHolder.Position = UDim2.new(0, 120, 0, 40)
	ContentHolder.Size = UDim2.new(1, -120, 1, -40)
	ContentHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	ContentHolder.BorderSizePixel = 0
	ContentHolder.Name = "ContentHolder"

	local UIList = Instance.new("UIListLayout", TabHolder)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 2)

	function NovaZLib:CreateTab(tabName)
		local TabButton = Instance.new("TextButton", TabHolder)
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		TabButton.Text = tabName
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		TabButton.BorderSizePixel = 0
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 14

		local TabFrame = Instance.new("ScrollingFrame", ContentHolder)
		TabFrame.Visible = false
		TabFrame.Name = tabName
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabFrame.BackgroundTransparency = 1
		TabFrame.ScrollBarThickness = 5
		TabFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

		local Layout = Instance.new("UIListLayout", TabFrame)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Padding = UDim.new(0, 5)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _, frame in pairs(ContentHolder:GetChildren()) do
				if frame:IsA("ScrollingFrame") then
					frame.Visible = false
				end
			end
			TabFrame.Visible = true
		end)

		local tab = {}

		function tab:AddButton(name, callback)
			local Button = Instance.new("TextButton", TabFrame)
			Button.Size = UDim2.new(1, -10, 0, 30)
			Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Button.Text = name
			Button.Font = Enum.Font.Gotham
			Button.TextColor3 = Color3.new(1, 1, 1)
			Button.TextSize = 14
			Button.BorderSizePixel = 0

			Button.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function tab:AddToggle(name, default, callback)
			local Toggle = Instance.new("TextButton", TabFrame)
			Toggle.Size = UDim2.new(1, -10, 0, 30)
			Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Toggle.Text = name .. ": " .. (default and "ON" or "OFF")
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextColor3 = Color3.new(1, 1, 1)
			Toggle.TextSize = 14
			Toggle.BorderSizePixel = 0

			local state = default

			Toggle.MouseButton1Click:Connect(function()
				state = not state
				Toggle.Text = name .. ": " .. (state and "ON" or "OFF")
				pcall(callback, state)
			end)
		end

		function tab:AddSlider(name, min, max, default, callback)
			local Container = Instance.new("Frame", TabFrame)
			Container.Size = UDim2.new(1, -10, 0, 40)
			Container.BackgroundTransparency = 1

			local Text = Instance.new("TextLabel", Container)
			Text.Size = UDim2.new(1, 0, 0, 20)
			Text.BackgroundTransparency = 1
			Text.Text = name .. ": " .. tostring(default)
			Text.TextColor3 = Color3.new(1, 1, 1)
			Text.Font = Enum.Font.Gotham
			Text.TextSize = 14

			local Slider = Instance.new("TextButton", Container)
			Slider.Size = UDim2.new(1, 0, 0, 20)
			Slider.Position = UDim2.new(0, 0, 0, 20)
			Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Slider.Text = ""
			Slider.BorderSizePixel = 0

			local Value = default

			Slider.MouseButton1Down:Connect(function()
				local conn
				conn = game:GetService("RunService").RenderStepped:Connect(function()
					local mouse = UserInputService:GetMouseLocation().X
					local rel = mouse - Slider.AbsolutePosition.X
					local percent = math.clamp(rel / Slider.AbsoluteSize.X, 0, 1)
					Value = math.floor((min + (max - min) * percent) + 0.5)
					Text.Text = name .. ": " .. tostring(Value)
					pcall(callback, Value)
				end)
				UserInputService.InputEnded:Wait()
				conn:Disconnect()
			end)
		end

		function tab:AddDropdown(name, options, callback)
			local Dropdown = Instance.new("TextButton", TabFrame)
			Dropdown.Size = UDim2.new(1, -10, 0, 30)
			Dropdown.Text = name .. ": [Select]"
			Dropdown.Font = Enum.Font.Gotham
			Dropdown.TextColor3 = Color3.new(1, 1, 1)
			Dropdown.TextSize = 14
			Dropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			Dropdown.BorderSizePixel = 0

			local Open = false

			Dropdown.MouseButton1Click:Connect(function()
				if Open then return end
				Open = true

				for _, v in pairs(TabFrame:GetChildren()) do
					if v.Name == "__DropdownOption" then
						v:Destroy()
					end
				end

				for _, v in pairs(options) do
					local Option = Instance.new("TextButton", TabFrame)
					Option.Size = UDim2.new(1, -10, 0, 30)
					Option.Text = "→ " .. v
					Option.Name = "__DropdownOption"
					Option.Font = Enum.Font.Gotham
					Option.TextColor3 = Color3.new(1, 1, 1)
					Option.TextSize = 14
					Option.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					Option.BorderSizePixel = 0

					Option.MouseButton1Click:Connect(function()
						Dropdown.Text = name .. ": " .. v
						pcall(callback, v)
						for _, c in pairs(TabFrame:GetChildren()) do
							if c.Name == "__DropdownOption" then
								c:Destroy()
							end
						end
						Open = false
					end)
				end
			end)
		end

		return tab
	end

	return NovaZLib
end

return NovaZLib