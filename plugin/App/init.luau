--!strict
--!optimize 2
--!nolint
local ReplicatedStorage = game:GetService("ReplicatedStorage")



--[=[

    MIT License

    Copyright (c) 2026 Liam Rousselle

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

]=]--

-- Modules
local Fusion = require(ReplicatedStorage["Fracture-Plugin"].Packages.Fusion)
local Identify = require(script.Parent.Identify)
local Types = require(script.Parent.Types)
local Canvas = require(script.primitive.Canvas)

-- Fusion
local scope = Fusion.scoped {
    New = Fusion.New;
}

local function app()
    return Canvas {
        scope:New "TextLabel" {
            Name = "TitleLabel";
            AnchorPoint = Vector2.zero;
            Size = UDim2.fromOffset(200, 100);
            Position = UDim2.fromScale(0.05, 0.05);
            BackgroundTransparency = 1;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextScaled = true;
            Text = "Fracture";
        }
    }
end

local function new(common: Types.PluginCommon)
    local plugin = common.Plugin
    DockWidgetPluginGuiInfo.new()
    local dockWidgetInfo = DockWidgetPluginGuiInfo.new(
        Enum.InitialDockState.Right,
        false,
        false,
        800,
        600,
        400,
        300
    )
    local widget = plugin:CreateDockWidgetPluginGuiAsync(Identify("mainwin"), dockWidgetInfo)

    widget:BindToClose(function()
        widget.Enabled = false
        common.Button:SetActive(false)
    end)

    local app = app()
    app.Parent = widget

    return {
        App = app;
        Widget = widget;
    }
end

return new