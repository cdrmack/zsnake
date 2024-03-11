const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");
const Game = @import("game.zig");
const Snake = @import("snake.zig"); // tmp

const tick_target_duration: f32 = 0.5; // 2 frames per second

pub fn main() !void {
    ray.InitWindow(Consts.screen_width, Consts.screen_height, "zsnake");
    defer ray.CloseWindow();

    var delta_time: f32 = tick_target_duration;

    var game = Game.init();
    // tmp start
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    // 1
    var new_cell = try allocator.create(Snake.SnakeCell);
    new_cell.previous = &game.snake.head;
    new_cell.next = null;
    new_cell.rectangle = ray.Rectangle{ .x = game.snake.head.rectangle.x, .y = game.snake.head.rectangle.y - Consts.snake_cell_size, .width = Consts.snake_cell_size, .height = Consts.snake_cell_size };

    game.snake.head.next = new_cell;
    game.snake.last = new_cell;
    // 2
    var new_cell2 = try allocator.create(Snake.SnakeCell);
    new_cell2.previous = game.snake.last;
    new_cell2.next = null;
    new_cell2.rectangle = ray.Rectangle{ .x = game.snake.last.?.rectangle.x, .y = game.snake.last.?.rectangle.y - Consts.snake_cell_size, .width = Consts.snake_cell_size, .height = Consts.snake_cell_size };

    game.snake.last.?.next = new_cell2;
    game.snake.last = new_cell2;
    // tmp end

    var score_buffer: [20]u8 = undefined;

    const score_x = 10;
    const score_y = 10;
    const score_font_size = Consts.margin;

    while (!ray.WindowShouldClose()) {
        while (delta_time < tick_target_duration) {
            game.input();
            game.render();
            delta_time += ray.GetFrameTime();

            const score_string: [:0]u8 = try std.fmt.bufPrintZ(&score_buffer, "Score: {d}", .{game.score});
            ray.DrawText(score_string.ptr, score_x, score_y, score_font_size, ray.WHITE);
        }

        game.tick();
        delta_time = ray.GetFrameTime();
    }
}
