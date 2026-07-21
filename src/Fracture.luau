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

local Fracture = {}
Fracture.__index = Fracture

local self = setmetatable({
    _clientDir = nil :: Folder?;
    _serverDir = nil :: Folder?;
    _commonDir = nil :: Folder?;
}, Fracture)

local Flags = require(script.Parent.Flags)
local Implementation = require(script.Parent.Implementation)


function Fracture:AssignClientDirectory(directory: Folder)
    assert(directory, `Attempt to assign directroy but nil was passed`)
    assert(typeof(directory) == "Instance", `Incorrect type passed. Expected "Instance"`)
    self._clientDir = directory
end

function Fracture:AssignServerDirectory(directory: Folder)
    assert(directory, `Attempt to assign directroy but nil was passed`)
    assert(typeof(directory) == "Instance", `Incorrect type passed. Expected "Instance"`)
    self._serverDir = directory
end

function Fracture:AssignCommonDirectory(directory: Folder)
    assert(directory, `Attempt to assign directroy but nil was passed`)
    assert(typeof(directory) == "Instance", `Incorrect type passed. Expected "Instance"`)
    self._commonDir = directory
end

--[=[
    Starts organizing where each feature should be located.
    Will throw exception if any Directories were not set.
]=]--
function Fracture:Implement(workingDir: Folder)
    assert(typeof(workingDir) == "Instance", `Incorrect type passed. Expected "Instance"`)
    assert(typeof(self._clientDir) == "Instance", `Incorrect type passed. Expected "Instance"`)
    assert(typeof(self._serverDir) == "Instance", `Incorrect type passed. Expected "Instance"`)
    assert(typeof(self._commonDir) == "Instance", `Incorrect type passed. Expected "Instance"`)
    Implementation:Implement(
        workingDir, 
        self._clientDir :: Folder, 
        self._serverDir :: Folder, 
        self._commonDir :: Folder
    )

    if Flags.F_DeleteSourceDirectory then
        workingDir:Destroy()
    end
end

return self