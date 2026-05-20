if SERVER then AddCSLuaFile() end

local SpatialGrid = {}
SpatialGrid.__index = SpatialGrid

function SpatialGrid.Create(cellSize)
    local self = setmetatable({}, SpatialGrid)
    self.cellSize = cellSize or 1500
    self.grid = {}
    return self
end

function SpatialGrid:Clear()
    self.grid = {}
end

function SpatialGrid:Insert(ent, pos)
    if not IsValid(ent) then return end

    local cx = math.floor(pos.x / self.cellSize)
    local cy = math.floor(pos.y / self.cellSize)
    local cz = math.floor(pos.z / self.cellSize)

    local grid = self.grid
    local cellX = grid[cx]
    if not cellX then
        cellX = {}
        grid[cx] = cellX
    end

    local cellY = cellX[cy]
    if not cellY then
        cellY = {}
        cellX[cy] = cellY
    end

    local cellZ = cellY[cz]
    if not cellZ then
        cellZ = {}
        cellY[cz] = cellZ
    end

    cellZ[#cellZ + 1] = ent
end

function SpatialGrid:GetInRadius(pos, radius, filterFunc)
    local results = {}
    local resultCount = 0

    local minX = math.floor((pos.x - radius) / self.cellSize)
    local maxX = math.floor((pos.x + radius) / self.cellSize)
    local minY = math.floor((pos.y - radius) / self.cellSize)
    local maxY = math.floor((pos.y + radius) / self.cellSize)
    local minZ = math.floor((pos.z - radius) / self.cellSize)
    local maxZ = math.floor((pos.z + radius) / self.cellSize)

    local radiusSqr = radius * radius
    local grid = self.grid

    for cx = minX, maxX do
        local cellX = grid[cx]
        if cellX then
            for cy = minY, maxY do
                local cellY = cellX[cy]
                if cellY then
                    for cz = minZ, maxZ do
                        local cellZ = cellY[cz]
                        if cellZ then
                            local cellCount = #cellZ
                            for i = 1, cellCount do
                                local ent = cellZ[i]
                                if IsValid(ent) then
                                    local entPos = ent:GetPos()
                                    if entPos:DistToSqr(pos) <= radiusSqr then
                                        if not filterFunc or filterFunc(ent) then
                                            resultCount = resultCount + 1
                                            results[resultCount] = ent
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return results, resultCount
end

DDBot.SpatialGrid = SpatialGrid
