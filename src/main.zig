const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const screen_width = 400;
const screen_height = 400;

const snake_cell_size = 10;

const Snake = struct { rectangle: ray.Rectangle, color: ray.Color };

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

    const snake = Snake{
        .rectangle = makeRectangle(50, 50, snake_cell_size, snake_cell_size),
        .color = ray.GREEN,
    };

    while (!ray.WindowShouldClose()) {
        // render
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        ray.DrawRectangleRec(snake.rectangle, snake.color);
    }
}
