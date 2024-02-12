const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const screen_width = 800;
const screen_height = 600;

pub fn main() void {
    ray.InitWindow(screen_width, screen_height, "zsnake");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        // render
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);
    }
}
