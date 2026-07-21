--!strict
--!optimize 2
--!nolint



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

local SolutionDir = script:FindFirstAncestor("Fracture-Plugin")

-- Modules
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(SolutionDir.Packages.Fusion)

-- Fusion
local scope = Fusion.scoped {
    New = Fusion.New;
}
local children = Fusion.Children

return function(child: any)
    return scope:New "Frame" {
        Name = "Canvas";
        AnchorPoint = Vector2.one * 0.5;
        BackgroundTransparency = 1;
        Size = UDim2.fromScale(1, 1);
        Position = UDim2.fromScale(0.5, 0.5);
        [children] = child
    }
end