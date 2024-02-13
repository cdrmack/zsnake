const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const screen_width = 400;
const screen_height = 400;

const snake_cell_size = 10;

const Direction = enum { up, down, left, right };

const Snake = struct { rectangle: ray.Rectangle, direction: Direction, color: ray.Color };

fn makeRectangle(x: f32, y: f32, width: f32, height: f32) ray.Rectangle {
    return ray.Rectangle{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
}

fn snakeTick(snake: *Snake) void {
    switch (snake.direction) {
        Direction.up => {
            snake.rectangle.y -= snake_cell_size;
        },
        Direction.down => {
            snake.rectangle.y += snake_cell_size;
        },
        Direction.left => {
            snake.rectangle.x -= snake_cell_size;
        },
        Direction.right => {
            snake.rectangle.x += snake_cell_size;
        },
    }
}

pub fn main() void {
    ray.InitWindow(screen_width, screen_height, "zsnake");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    var snake = Snake{
        .rectangle = makeRectangle(50, 50, snake_cell_size, snake_cell_size),
        .direction = Direction.down,
        .color = ray.GREEN,
    };

    while (!ray.WindowShouldClose()) {
        // tick
        snakeTick(&snake);

        // render
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        ray.DrawRectangleRec(snake.rectangle, snake.color);
    }
}
