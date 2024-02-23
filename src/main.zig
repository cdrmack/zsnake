const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const screen_width = 400;
const screen_height = 400;

const snake_cell_size = 10;

const Direction = enum { up, down, left, right };

const Snake = struct {
    rectangle: ray.Rectangle,
    direction: Direction,
    color: ray.Color,

    fn teleportOnEdge(self: *Snake) void {
        if (self.rectangle.y < 0) {
            self.rectangle.y = screen_height;
            return;
        }

        if (self.rectangle.x < 0) {
            self.rectangle.x = screen_width;
            return;
        }

        if (self.rectangle.y > screen_height) {
            self.rectangle.y = 0;
            return;
        }

        if (self.rectangle.x > screen_width) {
            self.rectangle.x = 0;
            return;
        }
    }

    fn tick(self: *Snake) void {
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

    fn render(self: *Snake) void {
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

    fn input(self: *Snake) void {
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

fn makeRectangle(x: f32, y: f32, width: f32, height: f32) ray.Rectangle {
    return ray.Rectangle{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
}

pub fn main() void {
    ray.InitWindow(screen_width, screen_height, "zsnake");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    var snake = Snake{
        .rectangle = makeRectangle(50, 50, snake_cell_size, snake_cell_size),
        .direction = .down,
        .color = ray.GREEN,
    };

    while (!ray.WindowShouldClose()) {
        // input
        snake.input();

        // tick
        snake.tick();

        // render
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        snake.render();
    }
}
