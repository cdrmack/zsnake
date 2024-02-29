const ray = @cImport({
    @cInclude("raylib.h");
});

const Window = @import("window.zig");

pub const snake_cell_size = 10;

const Direction = enum { up, down, left, right };

pub const Snake = struct {
    rectangle: ray.Rectangle,
    direction: Direction,
    color: ray.Color,

    fn teleportOnEdge(self: *Snake) void {
        if (self.rectangle.y < 0) {
            self.rectangle.y = Window.screen_height;
            return;
        }

        if (self.rectangle.x < 0) {
            self.rectangle.x = Window.screen_width;
            return;
        }

        if (self.rectangle.y > Window.screen_height) {
            self.rectangle.y = 0;
            return;
        }

        if (self.rectangle.x > Window.screen_width) {
            self.rectangle.x = 0;
            return;
        }
    }

    pub fn tick(self: *Snake) void {
        switch (self.direction) {
            .up => {
                self.rectangle.y -= snake_cell_size;
            },
            .down => {
                self.rectangle.y += snake_cell_size;
            },
            .left => {
                self.rectangle.x -= snake_cell_size;
            },
            .right => {
                self.rectangle.x += snake_cell_size;
            },
        }

        teleportOnEdge(self);
    }

    pub fn render(self: *Snake) void {
        ray.DrawRectangleRec(self.rectangle, self.color);
    }

    fn canChangeDirection(self: *Snake, direction: Direction) bool {
        switch (self.direction) {
            .up => {
                if (direction == .down) {
                    return false;
                } else {
                    return true;
                }
            },
            .down => {
                if (direction == .up) {
                    return false;
                } else {
                    return true;
                }
            },
            .left => {
                if (direction == .right) {
                    return false;
                } else {
                    return true;
                }
            },
            .right => {
                if (direction == .left) {
                    return false;
                } else {
                    return true;
                }
            },
        }
    }

    fn move(self: *Snake, direction: Direction) void {
        if (self.canChangeDirection(direction)) {
            self.direction = direction;
        } else {
            ray.TraceLog(ray.LOG_INFO, "Cannot set that direction!");
        }
    }

    pub fn input(self: *Snake) void {
        if (ray.IsKeyDown(ray.KEY_RIGHT)) {
            self.move(.right);
            return;
        }

        if (ray.IsKeyDown(ray.KEY_LEFT)) {
            self.move(.left);
            return;
        }

        if (ray.IsKeyDown(ray.KEY_UP)) {
            self.move(.up);
            return;
        }

        if (ray.IsKeyDown(ray.KEY_DOWN)) {
            self.move(.down);
            return;
        }
    }
};
