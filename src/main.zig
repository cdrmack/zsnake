const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Window = @import("window.zig");
const Game = @import("game.zig");
const Snake = @import("snake.zig");
const Apple = @import("apple.zig");

const tick_target_duration: f32 = 0.5; // 2 frames per second

fn makeRectangle(x: f32, y: f32, width: f32, height: f32) ray.Rectangle {
    return ray.Rectangle{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
}

fn initGame() Game.Game {
    const snake = Snake.Snake{
        .rectangle = makeRectangle(50, 50, Snake.snake_cell_size, Snake.snake_cell_size),
        .direction = .down,
        .color = ray.GREEN,
    };

    // TODO: make apple position random
    const apple = Apple.Apple{
        .rectangle = makeRectangle(200, 200, Snake.snake_cell_size, Snake.snake_cell_size),
        .color = ray.RED,
    };

    return Game.Game{
        .snake = snake,
        .apple = apple,
    };
}

pub fn main() void {
    ray.InitWindow(Window.screen_width, Window.screen_height, "zsnake");
    defer ray.CloseWindow();

    var delta_time: f32 = tick_target_duration;

    var game = initGame();

    while (!ray.WindowShouldClose()) {
        while (delta_time < tick_target_duration) {
            game.input();
            game.render();
            delta_time += ray.GetFrameTime();
        }

        game.tick();
        delta_time = ray.GetFrameTime();
    }
}
