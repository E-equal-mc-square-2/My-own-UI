--// Init.lua

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Themes = require(script.Modules.Themes)
local Utility = require(script.Modules.Utility)
local Mobile = require(script.Modules.Mobile)
local Animations = require(script.Modules.Animations)

Library.Theme = Themes.Default
Library.Flags = {}
Library.Windows = {}

function Library:CreateWindow(Settings)
    Settings = Settings or {}

    local Window = {}
    Window.Tabs = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Settings.Name or "MyOwnUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        ScreenGui.Parent = CoreGui
    end)

    if not ScreenGui.Parent then
        ScreenGui.Parent = PlayerGui
    end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.fromScale(0.5, 0.5)

    --// Mobile First Sizing
    Main.Size = Mobile:GetWindowSize()

    Main.BackgroundColor3 = Library.Theme.Background
    Main.BorderSizePixel = 0

    Utility:Corner(Main, 14)
    Utility:Stroke(Main, Library.Theme.Stroke)

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = Main

    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar

    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)

    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "My UI"
    Title.TextColor3 = Library.Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Title.Font = Enum.Font.GothamBold
    Title.TextSize = Mobile:Scale(18)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Main

    Sidebar.Size = UDim2.new(0, Mobile:Scale(90), 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)

    Sidebar.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = Sidebar

    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Pages = Instance.new("Frame")
    Pages.Parent = Main

    Pages.Size = UDim2.new(1, -100, 1, -60)
    Pages.Position = UDim2.new(0, 95, 0, 55)

    Pages.BackgroundTransparency = 1

    function Window:CreateTab(Name)
        local Tab = {}
        Tab.Elements = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = Sidebar

        TabButton.Size = UDim2.new(1, -10, 0, Mobile:Scale(40))
        TabButton.BackgroundColor3 = Library.Theme.Secondary

        TabButton.Text = Name
        TabButton.TextColor3 = Library.Theme.Text
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = Mobile:Scale(14)

        Utility:Corner(TabButton, 10)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Pages

        Page.Visible = false
        Page.Size = UDim2.fromScale(1,1)

        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 0

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Page

        Layout.Padding = UDim.new(0, 10)

        local Padding = Instance.new("UIPadding")
        Padding.Parent = Page

        Padding.PaddingTop = UDim.new(0,10)
        Padding.PaddingBottom = UDim.new(0,10)
        Padding.PaddingLeft = UDim.new(0,5)
        Padding.PaddingRight = UDim.new(0,5)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
        end)

        function Tab:Show()
            for _, Child in pairs(Pages:GetChildren()) do
                if Child:IsA("ScrollingFrame") then
                    Child.Visible = false
                end
            end

            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Show()
        end)

        function Tab:CreateButton(Settings)
            Settings = Settings or {}

            local Button = Instance.new("TextButton")
            Button.Parent = Page

            Button.Size = UDim2.new(1, 0, 0, Mobile:Scale(45))
            Button.BackgroundColor3 = Library.Theme.Secondary

            Button.Text = Settings.Name or "Button"
            Button.TextColor3 = Library.Theme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = Mobile:Scale(14)

            Utility:Corner(Button, 10)

            Button.MouseButton1Click:Connect(function()
                Animations:Pop(Button)

                if Settings.Callback then
                    Settings.Callback()
                end
            end)

            return Button
        end

        function Tab:CreateToggle(Settings)
            Settings = Settings or {}

            local Enabled = Settings.Default or false

            local Holder = Instance.new("Frame")
            Holder.Parent = Page

            Holder.Size = UDim2.new(1,0,0,Mobile:Scale(45))
            Holder.BackgroundColor3 = Library.Theme.Secondary

            Utility:Corner(Holder, 10)

            local Label = Instance.new("TextLabel")
            Label.Parent = Holder

            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1,-60,1,0)
            Label.Position = UDim2.new(0,10,0,0)

            Label.Text = Settings.Name or "Toggle"
            Label.TextColor3 = Library.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham
            Label.TextSize = Mobile:Scale(14)

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = Holder

            ToggleButton.AnchorPoint = Vector2.new(1,0.5)
            ToggleButton.Position = UDim2.new(1,-10,0.5,0)
            ToggleButton.Size = UDim2.new(0,40,0,22)

            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false

            Utility:Corner(ToggleButton, 999)

            local Circle = Instance.new("Frame")
            Circle.Parent = ToggleButton

            Circle.Size = UDim2.new(0,18,0,18)
            Circle.Position = UDim2.new(0,2,0.5,-9)

            Circle.BackgroundColor3 = Color3.new(1,1,1)
            Circle.BorderSizePixel = 0

            Utility:Corner(Circle,999)

            local function Update()
                if Enabled then
                    ToggleButton.BackgroundColor3 = Library.Theme.Accent

                    TweenService:Create(Circle,TweenInfo.new(0.2),{
                        Position = UDim2.new(1,-20,0.5,-9)
                    }):Play()
                else
                    ToggleButton.BackgroundColor3 = Library.Theme.Disabled

                    TweenService:Create(Circle,TweenInfo.new(0.2),{
                        Position = UDim2.new(0,2,0.5,-9)
                    }):Play()
                end

                if Settings.Flag then
                    Library.Flags[Settings.Flag] = Enabled
                end
            end

            Update()

            ToggleButton.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Update()

                if Settings.Callback then
                    Settings.Callback(Enabled)
                end
            end)

            return {
                Set = function(_,Value)
                    Enabled = Value
                    Update()
                end,

                Get = function()
                    return Enabled
                end
            }
        end

        if #Window.Tabs == 0 then
            task.wait()
            Tab:Show()
        end

        table.insert(Window.Tabs, Tab)

        return Tab
    end

    Utility:Drag(Main, Topbar)

    table.insert(Library.Windows, Window)

    return Window
end

return Library
