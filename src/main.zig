const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Snake = @import("snake.zig");
const Window = @import("window.zig");

fn makeRectangle(x: f32, y: f32, width: f32, height: f32) ray.Rectangle {
    return ray.Rectangle{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
}

pub fn main() void {
    ray.InitWindow(Window.screen_width, Window.screen_height, "zsnake");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    var snake = Snake.Snake{
        .rectangle = makeRectangle(50, 50, Snake.snake_cell_size, Snake.snake_cell_size),
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
