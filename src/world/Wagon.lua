Wagon = Class{}

function Wagon:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self.tilesLayer = {}
    self:generateWallsAndFloors()

    self.objects = {}
    self:generatePassengersWagonObjects()

    self.backgroundScroll = 0

    self.player = player

    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y
end

function Wagon:generateWallsAndFloors()
    local tileFloor = TILE_FLOORS[math.random(#TILE_FLOORS)]
    local tileTopWall = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]

    for y = 1, self.height do
        table.insert(self.tiles, {})
        table.insert(self.tilesLayer, {})

        for x = 1, self.width do
            local id = TILE_EMPTY
            local idLayer = TILE_EMPTY

            if y >= 1 and y <= 4 then
                if (y == 2 or y == 3) then
                    if (x >= 3 and x <= 4) or
                        (x >= 6 and x <= 7) or
                        (x >= 9 and x <= 10) or
                        (x >= 12 and x <= 13) or
                        (x >= 15 and x <= 16) or
                        (x >= 18 and x <= 19) or
                        (x >= 21 and x <= 22) then
                        id = TILE_GLASS
                    else
                        id = tileTopWall
                    end
                elseif y == 4 then
                    id = TILE_TOP_WALL_BOTTOM
                else
                    id = tileTopWall
                end
            else
                id = tileFloor
            end

            if y == 1 and x == 1 then
                idLayer = DELIMITER_TOP_LEFT_CORNER
            elseif y == 1 and x == self.width then
                idLayer = DELIMITER_TOP_RIGHT_CORNER
            elseif y == self.height and x == 1 then
                idLayer = DELIMITER_BOTTOM_LEFT_CORNER
            elseif y == self.height and x == self.width then
                idLayer = DELIMITER_BOTTOM_RIGHT_CORNER
            elseif y == 1 then
                idLayer = DELIMITER_TOP
            elseif x == 1 and (y >= 4 and y <= 9) then
                idLayer = TILE_EMPTY
            elseif x == 1 then
                idLayer = DELIMITER_LEFT
            elseif x == self.width and (y >= 4 and y <= 9) then
                idLayer = TILE_EMPTY
            elseif x == self.width then
                idLayer = DELIMITER_RIGHT
            elseif y == self.height then
                idLayer = DELIMITER_BOTTOM
            end

            table.insert(self.tiles[y], {
                id = id
            })

            table.insert(self.tilesLayer[y], {
                id = idLayer
            })
        end
        
    end
end

function Wagon:generatePassengersWagonObjects()
    -- helper = 1
    -- for x = 1, self.width / 2 - 5 do
    --     print(x)
    --     print(self.width)
    --     table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['chair'], helper * TILE_SIZE / 2, 5 * TILE_SIZE / 2))
    --     helper = helper + 6
    -- end
end

function Wagon:update(dt)
    self.player:update(dt)

    self.backgroundScroll = (self.backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
end

function Wagon:render()
    for y = 1, self.height do
        for x = 1, self.width do
            -- Render the background
            if x == 1 and y == 1 then
                love.graphics.draw(gTextures['background'], gFrames['background'][1],
                -self.backgroundScroll,
                (y - 1) * TILE_SIZE + self.renderOffsetY)
            end
            -- Render the tiles
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX,
                (y - 1) * TILE_SIZE + self.renderOffsetY)
            -- Render the tiles that are one layer above
            local tileLayer = self.tilesLayer[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tileLayer.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX,
                (y - 1) * TILE_SIZE + self.renderOffsetY)
        end
    end

    love.graphics.setColor(0, 0, 0, 100)

    -- left
    love.graphics.rectangle('fill', 0, self.renderOffsetY, self.renderOffsetX, TILE_SIZE * 4)

    -- right
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - self.renderOffsetX, self.renderOffsetY, self.renderOffsetX, TILE_SIZE * 4)

    love.graphics.setColor(255, 255, 255, 255)

    -- LEFT DOOR
    -- door walls
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        5 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        7 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        9 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][3],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        11 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door floors
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        13 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        15 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        17 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door top left corner border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][9],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        5 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door top right corner border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        2 * TILE_SIZE + self.renderOffsetY)
    -- door middle borders
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        3 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        4 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        5 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        6 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        7 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        8 * TILE_SIZE + self.renderOffsetY)
    -- door bottom left corner boder
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][11],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE * 2,
        17 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door bottom right corner border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][10],
        TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2,
        9 * TILE_SIZE + self.renderOffsetY)

    -- RIGHT DOOR
    -- door walls
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        5 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        7 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        9 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][3],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        11 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door floors
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        13 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        15 * TILE_SIZE / 2 + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        17 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door top left corner border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][11],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        2 * TILE_SIZE + self.renderOffsetY)
    -- door top right corner border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][10],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        5 * TILE_SIZE / 2 + self.renderOffsetY)
    -- door middle borders
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][8],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        3 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][8],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        4 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][8],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        5 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][8],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        6 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][8],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        7 * TILE_SIZE + self.renderOffsetY)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][8],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        8 * TILE_SIZE + self.renderOffsetY)
    -- door bottom left corder border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][9],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2,
        9 * TILE_SIZE + self.renderOffsetY)
    -- door bottom right corder border
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12],
        MAP_WIDTH * TILE_SIZE + self.renderOffsetX,
        17 * TILE_SIZE / 2 + self.renderOffsetY)

    for k, object in pairs(self.objects) do
        object:render(self.renderOffsetX, self.renderOffsetY)
    end

    love.graphics.stencil(function()
        -- bottom left door
        love.graphics.rectangle('fill', TILE_SIZE + self.renderOffsetX - TILE_SIZE - TILE_SIZE / 2, 9 * TILE_SIZE + self.renderOffsetY, TILE_SIZE, TILE_SIZE)
        -- bottom right door
        love.graphics.rectangle('fill', MAP_WIDTH * TILE_SIZE + self.renderOffsetX - TILE_SIZE / 2, 9 * TILE_SIZE + self.renderOffsetY, TILE_SIZE, TILE_SIZE)
        -- bottom
        love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - self.renderOffsetY - TILE_SIZE / 2, VIRTUAL_WIDTH, self.renderOffsetY + TILE_SIZE)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()

    -- --
    -- -- DEBUG DRAWING OF STENCIL RECTANGLES
    -- --

    -- love.graphics.setColor(0, 255, 0, 100)

    -- -- bottom
    -- love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - self.renderOffsetY - TILE_SIZE / 2, VIRTUAL_WIDTH, self.renderOffsetY + TILE_SIZE)

    -- love.graphics.setColor(255, 255, 255, 255)
end