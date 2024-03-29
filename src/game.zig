const Self = @This();

const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");
const Snake = @import("snake.zig");
const Apple = @import("apple.zig");

snake: Snake,
apple: Apple,
score: u32,

pub fn init(allocator: std.mem.Allocator) Self {
    const snake = Snake.init(allocator);

    var apple = Apple{};
    apple.moveToRandomLocation();

    return Self{
        .snake = snake,
        .apple = apple,
        .score = 0,
    };
}

pub fn input(self: *Self) void {
    self.snake.input();
}

pub fn tick(self: *Self) !void {
    self.snake.tick();

    if (ray.CheckCollisionRecs(self.snake.head.rectangle, self.apple.rectangle)) {
        self.apple.moveToRandomLocation();
        self.score += 1;
        try self.snake.grow();
    }
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

pub fn render(self: *Self) void {
    ray.BeginDrawing();
    defer ray.EndDrawing();

    self.snake.render();
    self.apple.render();
    renderBorder();

    ray.ClearBackground(ray.BLACK);
}
