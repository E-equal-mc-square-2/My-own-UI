--// MOBILE FIRST UI LIBRARY
--// SINGLE FILE VERSION

local Library = {}

--// SERVICES

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// STATE

Library.Flags = {}
Library.Theme = {
    Background = Color3.fromRGB(18,18,18),
    Secondary = Color3.fromRGB(28,28,28),
    Accent = Color3.fromRGB(0,170,255),
    Text = Color3.fromRGB(255,255,255),
    Stroke = Color3.fromRGB(45,45,45),
    Disabled = Color3.fromRGB(70,70,70)
}

--// MOBILE

local Mobile = {}

function Mobile:IsMobile()
    return workspace.CurrentCamera.ViewportSize.X < 1000
end

function Mobile:Scale(Value)
    if self:IsMobile() then
        return Value
    end

    return math.floor(Value * 1.1)
end

function Mobile:GetWindowSize()
    if self:IsMobile() then
        return UDim2.new(0.92,0,0.82,0)
    end

    return UDim2.new(0,720,0,520)
end

--// UTILITY

local Utility = {}

function Utility:Corner(Object, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius)
    Corner.Parent = Object
end

function Utility:Stroke(Object, Color)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Object
end

function Utility:Padding(Object, Padding)
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, Padding)
    UIPadding.PaddingBottom = UDim.new(0, Padding)
    UIPadding.PaddingLeft = UDim.new(0, Padding)
    UIPadding.PaddingRight = UDim.new(0, Padding)
    UIPadding.Parent = Object
end

function Utility:Drag(Frame, DragObject)
    local Dragging = false
    local DragInput
    local Start
    local StartPos

    DragObject.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            Start = Input.Position
            StartPos = Frame.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    DragObject.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - Start

            Frame.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)
end

--// ANIMATIONS

local Animations = {}

function Animations:Pop(Object)
    local Original = Object.Size

    local Grow = TweenService:Create(
        Object,
        TweenInfo.new(0.08),
        {
            Size = Original + UDim2.new(0,2,0,2)
        }
    )

    local Shrink = TweenService:Create(
        Object,
        TweenInfo.new(0.08),
        {
            Size = Original
        }
    )

    Grow:Play()

    Grow.Completed:Connect(function()
        Shrink:Play()
    end)
end

--// WINDOW

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
    Main.Parent = ScreenGui

    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.Position = UDim2.fromScale(0.5,0.5)
    Main.Size = Mobile:GetWindowSize()

    Main.BackgroundColor3 = Library.Theme.Background
    Main.BorderSizePixel = 0

    Utility:Corner(Main,16)
    Utility:Stroke(Main,Library.Theme.Stroke)

    --// TOPBAR

    local Topbar = Instance.new("Frame")
    Topbar.Parent = Main

    Topbar.Size = UDim2.new(1,0,0,55)
    Topbar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar

    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,15,0,0)
    Title.Size = UDim2.new(1,-20,1,0)

    Title.Text = Settings.Name or "My UI"
    Title.TextColor3 = Library.Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = Mobile:Scale(18)

    --// SIDEBAR

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Main

    Sidebar.Position = UDim2.new(0,0,0,55)
    Sidebar.Size = UDim2.new(0,100,1,-55)

    Sidebar.BackgroundTransparency = 1

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar

    SidebarLayout.Padding = UDim.new(0,8)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    Utility:Padding(Sidebar,8)

    --// PAGES

    local Pages = Instance.new("Frame")
    Pages.Parent = Main

    Pages.BackgroundTransparency = 1
    Pages.Position = UDim2.new(0,105,0,60)
    Pages.Size = UDim2.new(1,-115,1,-70)

    --// TAB CREATION

    function Window:CreateTab(Name)
        local Tab = {}

        local Button = Instance.new("TextButton")
        Button.Parent = Sidebar

        Button.Size = UDim2.new(1,0,0,Mobile:Scale(42))
        Button.BackgroundColor3 = Library.Theme.Secondary

        Button.Text = Name
        Button.TextColor3 = Library.Theme.Text
        Button.Font = Enum.Font.GothamMedium
        Button.TextSize = Mobile:Scale(14)

        Utility:Corner(Button,12)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Pages

        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 0

        Page.Size = UDim2.fromScale(1,1)
        Page.CanvasSize = UDim2.new(0,0,0,0)

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Page

        Layout.Padding = UDim.new(0,10)

        Utility:Padding(Page,5)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 15)
        end)

        function Tab:Show()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            Page.Visible = true
        end

        Button.MouseButton1Click:Connect(function()
            Animations:Pop(Button)
            Tab:Show()
        end)

        --// BUTTON ELEMENT

        function Tab:CreateButton(Settings)
            Settings = Settings or {}

            local Element = Instance.new("TextButton")
            Element.Parent = Page

            Element.Size = UDim2.new(1,0,0,Mobile:Scale(48))
            Element.BackgroundColor3 = Library.Theme.Secondary

            Element.Text = Settings.Name or "Button"
            Element.TextColor3 = Library.Theme.Text
            Element.Font = Enum.Font.Gotham
            Element.TextSize = Mobile:Scale(14)

            Utility:Corner(Element,12)

            Element.MouseButton1Click:Connect(function()
                Animations:Pop(Element)

                if Settings.Callback then
                    Settings.Callback()
                end
            end)

            return Element
        end

        --// TOGGLE ELEMENT

        function Tab:CreateToggle(Settings)
            Settings = Settings or {}

            local Enabled = Settings.Default or false

            local Holder = Instance.new("Frame")
            Holder.Parent = Page

            Holder.Size = UDim2.new(1,0,0,Mobile:Scale(48))
            Holder.BackgroundColor3 = Library.Theme.Secondary
            Holder.BorderSizePixel = 0

            Utility:Corner(Holder,12)

            local Label = Instance.new("TextLabel")
            Label.Parent = Holder

            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0,12,0,0)
            Label.Size = UDim2.new(1,-70,1,0)

            Label.Text = Settings.Name or "Toggle"
            Label.TextColor3 = Library.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham
            Label.TextSize = Mobile:Scale(14)

            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Holder

            Toggle.AnchorPoint = Vector2.new(1,0.5)
            Toggle.Position = UDim2.new(1,-10,0.5,0)
            Toggle.Size = UDim2.new(0,42,0,24)

            Toggle.Text = ""
            Toggle.AutoButtonColor = false
            Toggle.BorderSizePixel = 0

            Utility:Corner(Toggle,999)

            local Circle = Instance.new("Frame")
            Circle.Parent = Toggle

            Circle.Size = UDim2.new(0,18,0,18)
            Circle.Position = UDim2.new(0,3,0.5,-9)

            Circle.BackgroundColor3 = Color3.new(1,1,1)
            Circle.BorderSizePixel = 0

            Utility:Corner(Circle,999)

            local function Update()
                if Enabled then
                    Toggle.BackgroundColor3 = Library.Theme.Accent

                    TweenService:Create(
                        Circle,
                        TweenInfo.new(0.2),
                        {
                            Position = UDim2.new(1,-21,0.5,-9)
                        }
                    ):Play()
                else
                    Toggle.BackgroundColor3 = Library.Theme.Disabled

                    TweenService:Create(
                        Circle,
                        TweenInfo.new(0.2),
                        {
                            Position = UDim2.new(0,3,0.5,-9)
                        }
                    ):Play()
                end

                if Settings.Flag then
                    Library.Flags[Settings.Flag] = Enabled
                end
            end

            Update()

            Toggle.MouseButton1Click:Connect(function()
                Enabled = not Enabled

                Update()

                if Settings.Callback then
                    Settings.Callback(Enabled)
                end
            end)

            return {
                Set = function(_, Value)
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

    Utility:Drag(Main,Topbar)

    return Window
end

return Library
