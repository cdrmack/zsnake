const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Snake = @import("snake.zig");
const Window = @import("window.zig");
const Apple = @import("apple.zig");

fn makeRectangle(x: f32, y: f32, width: f32, height: f32) ray.Rectangle {
    return ray.Rectangle{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
}

const TickTargetDuration: f32 = 0.5; // 2 frames per second

pub fn main() void {
    ray.InitWindow(Window.screen_width, Window.screen_height, "zsnake");
    defer ray.CloseWindow();

    var snake = Snake.Snake{
        .rectangle = makeRectangle(50, 50, Snake.snake_cell_size, Snake.snake_cell_size),
        .direction = .down,
        .color = ray.GREEN,
    };

    // TODO: make apple position random
    var apple = Apple.Apple{
        .rectangle = makeRectangle(200, 200, Snake.snake_cell_size, Snake.snake_cell_size),
        .color = ray.RED,
    };

    var delta_time: f32 = TickTargetDuration;

    while (!ray.WindowShouldClose()) {
        while (delta_time < TickTargetDuration) {
            snake.input();

            // render
            ray.BeginDrawing();
            defer ray.EndDrawing();

            ray.ClearBackground(ray.BLACK);
            snake.render();
            apple.render();

            delta_time += ray.GetFrameTime();
        }

        snake.tick();
        delta_time = ray.GetFrameTime();
    }
}
