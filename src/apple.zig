const Snake = @import("snake.zig");
const ray = @cImport({
    @cInclude("raylib.h");
});

const window = @import("window.zig");

pub const Apple = struct {
    rectangle: ray.Rectangle,
    color: ray.Color,

    pub fn render(self: *Apple) void {
        ray.DrawRectangleRec(self.rectangle, self.color);
    }

    pub fn moveToRandomLocation(self: *Apple) void {
        const rand_x = ray.GetRandomValue(0, window.screen_width - 1);
        const rand_y = ray.GetRandomValue(0, window.screen_height - 1);

        const new_x = rand_x - @mod(rand_x, Snake.snake_cell_size);
        const new_y = rand_y - @mod(rand_y, Snake.snake_cell_size);

        self.rectangle.x = @floatFromInt(new_x);
        self.rectangle.y = @floatFromInt(new_y);
    }
};
