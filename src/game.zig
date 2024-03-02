const ray = @cImport({
    @cInclude("raylib.h");
});

const Snake = @import("snake.zig");
const Apple = @import("apple.zig");

pub const Game = struct {
    snake: Snake.Snake,
    apple: Apple.Apple,

    pub fn input(self: *Game) void {
        self.snake.input();
    }

    pub fn tick(self: *Game) void {
        self.snake.tick();
    }

    pub fn render(self: *Game) void {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        self.snake.render();
        self.apple.render();

        ray.ClearBackground(ray.BLACK);
    }
};
