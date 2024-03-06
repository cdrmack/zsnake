const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");
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
        .rectangle = makeRectangle(50, 50, Consts.snake_cell_size, Consts.snake_cell_size),
        .direction = .down,
        .color = ray.GREEN,
    };

    var apple = Apple.Apple{
        .rectangle = makeRectangle(0, 0, Consts.snake_cell_size, Consts.snake_cell_size),
        .color = ray.RED,
    };

    apple.moveToRandomLocation();

    return Game.Game{
        .snake = snake,
        .apple = apple,
        .score = 0,
    };
}

fn renderBorder() void {
    // top
    ray.DrawLineV(Consts.arena_top_left, Consts.arena_top_right, ray.BLUE);
    // bottom
    ray.DrawLineV(Consts.arena_bottom_left, Consts.arena_bottom_right, ray.BLUE);
    // left
    ray.DrawLineV(Consts.arena_top_left, Consts.arena_bottom_left, ray.BLUE);
    // right
    ray.DrawLineV(Consts.arena_top_right, Consts.arena_bottom_right, ray.BLUE);
}

pub fn main() !void {
    ray.InitWindow(Consts.screen_width, Consts.screen_height, "zsnake");
    defer ray.CloseWindow();

    var delta_time: f32 = tick_target_duration;

    var game = initGame();

    var score_buffer: [20]u8 = undefined;

    const score_x = 10;
    const score_y = 10;
    const score_font_size = Consts.margin;

    while (!ray.WindowShouldClose()) {
        while (delta_time < tick_target_duration) {
            game.input();
            game.render();
            renderBorder();
            delta_time += ray.GetFrameTime();

            const score_string: [:0]u8 = try std.fmt.bufPrintZ(&score_buffer, "Score: {d}", .{game.score});
            ray.DrawText(score_string.ptr, score_x, score_y, score_font_size, ray.WHITE);
        }

        game.tick();
        delta_time = ray.GetFrameTime();
    }
}
