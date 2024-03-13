const Self = @This();

const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");

rectangle: ray.Rectangle = ray.Rectangle{ .x = 0, .y = 0, .width = Consts.snake_cell_size, .height = Consts.snake_cell_size },
color: ray.Color = ray.RED,

pub fn render(self: *Self) void {
    ray.DrawRectangleRec(self.rectangle, self.color);
}

pub fn moveToRandomLocation(self: *Self) void {
    const rand_x = ray.GetRandomValue(Consts.arena_top_left.x, Consts.arena_top_right.x - 1);
    const rand_y = ray.GetRandomValue(Consts.arena_top_left.y, Consts.arena_bottom_left.y - 1);

    const new_x = rand_x - @mod(rand_x, Consts.snake_cell_size);
    const new_y = rand_y - @mod(rand_y, Consts.snake_cell_size);

    self.rectangle.x = @floatFromInt(new_x);
    self.rectangle.y = @floatFromInt(new_y);
}
