const ray = @cImport({
    @cInclude("raylib.h");
});

// Arena is the window's space where Snake can move
pub const arena_width = 400;
pub const arena_height = 400;

pub const arena_top_left = ray.Vector2{ .x = margin, .y = header_height };
pub const arena_top_right = ray.Vector2{ .x = arena_width + margin, .y = header_height };
pub const arena_bottom_left = ray.Vector2{ .x = margin, .y = arena_height + header_height };
pub const arena_bottom_right = ray.Vector2{ .x = arena_width + margin, .y = arena_height + header_height };

pub const arena_min_x = arena_top_left.x;
pub const arena_max_x = arena_top_right.x - snake_cell_size;
pub const arena_min_y = arena_top_left.y;
pub const arena_max_y = arena_bottom_right.y - snake_cell_size;

// Header is used to display current score
pub const header_height = 40;

// Margin is the distance between window and arena borders
pub const margin = 20;

// Screen is where everything else is being drawn
pub const screen_width = arena_width + (2 * margin);
pub const screen_height = arena_height + header_height + margin;

// Dimensions of single snake `cell`
pub const snake_cell_size = 10;
