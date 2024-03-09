const Self = @This();

const ray = @cImport({
    @cInclude("raylib.h");
});

const Snake = @import("snake.zig");
const Apple = @import("apple.zig");

snake: Snake,
apple: Apple,
score: u32,

pub fn init() Self {
    const snake = Snake.init();
    var apple = Apple.init();

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

pub fn tick(self: *Self) void {
    self.snake.tick();

    if (ray.CheckCollisionRecs(self.snake.rectangle, self.apple.rectangle)) {
        self.apple.moveToRandomLocation();
        self.score += 1;
    }
}

pub fn render(self: *Self) void {
    ray.BeginDrawing();
    defer ray.EndDrawing();

    self.snake.render();
    self.apple.render();

    ray.ClearBackground(ray.BLACK);
}
