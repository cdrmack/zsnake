const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");

pub const Apple = struct {
    rectangle: ray.Rectangle,
    color: ray.Color,

    pub fn render(self: *Apple) void {
        ray.DrawRectangleRec(self.rectangle, self.color);
    }

    pub fn moveToRandomLocation(self: *Apple) void {
        const rand_x = ray.GetRandomValue(Consts.arena_top_left.x, Consts.arena_top_right.x - 1);
        const rand_y = ray.GetRandomValue(Consts.arena_top_left.y, Consts.arena_bottom_left.y - 1);

        const new_x = rand_x - @mod(rand_x, Consts.snake_cell_size);
        const new_y = rand_y - @mod(rand_y, Consts.snake_cell_size);

        self.rectangle.x = @floatFromInt(new_x);
        self.rectangle.y = @floatFromInt(new_y);
    }
};
