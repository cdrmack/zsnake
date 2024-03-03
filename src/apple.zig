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
        const new_x = ray.GetRandomValue(0, window.screen_width - 1);
        const new_y = ray.GetRandomValue(0, window.screen_height - 1);

        self.rectangle.x = @floatFromInt(new_x);
        self.rectangle.y = @floatFromInt(new_y);
    }
};
