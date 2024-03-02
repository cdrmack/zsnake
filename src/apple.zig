const ray = @cImport({
    @cInclude("raylib.h");
});

pub const Apple = struct {
    rectangle: ray.Rectangle,
    color: ray.Color,

    pub fn render(self: *Apple) void {
        ray.DrawRectangleRec(self.rectangle, self.color);
    }
};
