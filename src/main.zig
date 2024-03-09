const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");
const Game = @import("game.zig");
const Snake = @import("snake.zig");
const Apple = @import("apple.zig");

const tick_target_duration: f32 = 0.1; // 10 frames per second

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

    var game = Game.init();

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
