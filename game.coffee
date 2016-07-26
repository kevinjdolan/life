GRID_HEIGHT = 60
GRID_WIDTH = 100
SVG_NAMESPACE = "http://www.w3.org/2000/svg"

WATER_GEN_THRESHOLD = -0.33
WATER_GEN_SCALE = 5

noise.seed(Math.random());

class Game

    constructor: () ->
        @game = document.getElementById('game')
        @pixelHeight = window.innerHeight
        @pixelWidth = window.innerWidth

        @generateWorld()
        @generateWater()

    add: (name, args) =>
        el = document.createElementNS(SVG_NAMESPACE, name);
        for key, value of args
            el.setAttributeNS(null, key, value)
        @game.appendChild(el)
        return el

    addRect: (x, y, cls) =>
        px = @pixel([x, y])
        sz = @pixel([1,1])
        @add 'rect',
            x: px[0]
            y: px[1]
            width: sz[0]
            height: sz[1]
            class: cls

    empty: () =>
        while @game.firstChild
            @game.removeChild(@game.firstChild)

    pixel: (pt) =>
        return [
            pt[0] * @pixelWidth / GRID_WIDTH,
            pt[1] * @pixelHeight / GRID_HEIGHT,
        ]

    generateWater: () =>
        for x in [0...GRID_WIDTH]
            for y in [0...GRID_HEIGHT]
                value = noise.perlin2(
                    WATER_GEN_SCALE * x / GRID_WIDTH,
                    WATER_GEN_SCALE * y / GRID_HEIGHT,
                )
                if value < WATER_GEN_THRESHOLD
                    @world[x][y].water = true

    generateWorld: () =>
        @world = []
        for x in [0...GRID_WIDTH]
            row = []
            for y in [0...GRID_HEIGHT]
                row.push(new Square())
            @world.push(row)

    render: () =>
        @empty()
        @renderGrid()

    renderGrid: () =>
        for x in [0...GRID_WIDTH]
            for y in [0...GRID_HEIGHT]
                square = @world[x][y]
                if square.water
                    @addRect(x, y, 'water')

        for i in [0...GRID_WIDTH]
            x = @pixel([i, 0])[0]
            @add 'line',
                x1: x
                y1: 0
                x2: x
                y2: @pixelHeight
                class: 'grid'
        for i in [0...GRID_HEIGHT]
            y = @pixel([0, i])[1]
            @add 'line',
                x1: 0
                y1: y
                x2: @pixelWidth
                y2: y
                class: 'grid'

class Square

    constructor: () ->
        @water = false

GAME = new Game()
GAME.render()
