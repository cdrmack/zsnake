const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Window = @import("window.zig");
const Game = @import("game.zig");
const Snake = @import("snake.zig");
const Apple = @import("apple.zig");

const tick_target_duration: f32 = 0.1; // 2 frames per second

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

    var apple = Apple.Apple{
        .rectangle = makeRectangle(0, 0, Snake.snake_cell_size, Snake.snake_cell_size),
        .color = ray.RED,
    };

    apple.moveToRandomLocation();

    return Game.Game{
        .snake = snake,
        .apple = apple,
        .score = 0,
    };
}

pub fn main() !void {
    ray.InitWindow(Window.screen_width, Window.screen_height, "zsnake");
    defer ray.CloseWindow();

    var delta_time: f32 = tick_target_duration;

    var game = initGame();

    var score_buffer: [20]u8 = undefined;
    while (!ray.WindowShouldClose()) {
        while (delta_time < tick_target_duration) {
            game.input();
            game.render();
            delta_time += ray.GetFrameTime();

            const score_string: [:0]u8 = try std.fmt.bufPrintZ(&score_buffer, "Score: {d}", .{game.score});
            ray.DrawText(score_string.ptr, 10, Window.screen_height - 34, 24, ray.WHITE);
        }

        game.tick();
        delta_time = ray.GetFrameTime();
    }
}
