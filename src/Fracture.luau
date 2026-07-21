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

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Enums
local k_ModuleNetworkType = {
    k_Client = 0 :: ModuleNetworkType;
    k_Server = 1 :: ModuleNetworkType;
    k_Shared = 2 :: ModuleNetworkType;
}
type ModuleNetworkType = number

-- Types
type FamilyTree = {Instance}

local function mkDir(name: string, parent: Instance) :Folder
    local existing = parent:FindFirstChild(name)
    if existing and existing:IsA("Folder") then
        return existing
    end

    local dir = Instance.new("Folder")
    dir.Name = name
    dir.Parent = parent
    return dir
end

local function flipTable<T>(t: T) :T
    local copy = {} :: T|any
    for i: number = #t :: any, 1, -1 do
        table.insert(copy :: any, (t :: any)[i])
    end
    return copy
end

return function(flags: any)
    local workDir = ReplicatedStorage.src

    local clientDir = mkDir("client", ReplicatedStorage)
    local serverDir = mkDir("server", ServerScriptService)
    local sharedDir = mkDir("shared", ReplicatedStorage)

    -- Creates a family tree (array) of ancestors of the instance given.
    -- Array starts with the parent of the instance, and ends at the last ancestor before reaching the working directory.
    -- Assumes that the instance is parented to another directory, not another module.
    local function backtrack(instance: Instance): FamilyTree
        local familyTree = {} :: {Instance}
        local iteration = instance.Parent
        while iteration and iteration ~= workDir do
            table.insert(familyTree, iteration)
            if iteration.Parent then
                iteration = iteration.Parent
            else
                break
            end
        end
        return familyTree
    end

    -- Rebuilds the ancestor folder chain of the instance under the given owner,
    -- reusing folders that already exist, and returns the deepest (leaf) folder.
    local function mimicDirectory(familyTree: FamilyTree, owner: Instance): Instance
        local hierarchy = flipTable(familyTree)
        local parent: Instance = owner
        for _, child: Instance in hierarchy do
            parent = mkDir(child.Name, parent)
        end
        return parent
    end

    local function cycle(root: Instance)
        for _, instance: Instance in root:GetChildren() do
            if instance:IsA("ModuleScript") then
                local suffix = string.lower(string.sub(instance.Name, #instance.Name - 5, #instance.Name))
                local type = 
                    suffix == "client" and k_ModuleNetworkType.k_Client or
                    suffix == "server" and k_ModuleNetworkType.k_Server or
                    k_ModuleNetworkType.k_Shared

                -- Backtrack and find where the module script is located.
                -- Then mimic the path of the module into the new spot and move it there.
                if type == k_ModuleNetworkType.k_Client then
                    instance:Clone().Parent = mimicDirectory(backtrack(instance), clientDir)
                elseif type == k_ModuleNetworkType.k_Server then
                    instance:Clone().Parent = mimicDirectory(backtrack(instance), serverDir)
                elseif type == k_ModuleNetworkType.k_Shared then
                    instance:Clone().Parent = mimicDirectory(backtrack(instance), sharedDir)
                end
            elseif instance:IsA("Folder") then
                cycle(instance)
            end
        end
    end
    cycle(workDir)

    return {}
end