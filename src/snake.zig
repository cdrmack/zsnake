const Self = @This();

const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const Consts = @import("consts.zig");

const Direction = enum { up, down, left, right };

const SnakeCell = struct {
    previous: ?*SnakeCell,
    next: ?*SnakeCell,
    rectangle: ray.Rectangle,
};

head: SnakeCell,
last: *SnakeCell,
direction: Direction,
color: ray.Color,

pub fn grow(self: *Self) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    //defer arena.deinit(); // TODO: when should I deinit?

    const allocator = arena.allocator();

    var new_cell = try allocator.create(SnakeCell);
    new_cell.previous = self.last;
    new_cell.next = null;
    new_cell.rectangle = self.last.rectangle;

    self.last.next = new_cell;
    self.last = new_cell;
}

pub fn init() Self {
    return Self{
        .head = SnakeCell{ .previous = null, .next = null, .rectangle = ray.Rectangle{ .x = 50, .y = 150, .width = Consts.snake_cell_size, .height = Consts.snake_cell_size } },
        .last = undefined, // TODO: how to get address of .head here?
        .direction = .down,
        .color = ray.GREEN,
    };
}

fn teleportOnEdge(self: *Self) void {
    if (self.head.rectangle.y < Consts.arena_min_y) {
        self.head.rectangle.y = Consts.arena_max_y;
        return;
    }

    if (self.head.rectangle.x < Consts.arena_min_x) {
        self.head.rectangle.x = Consts.arena_max_x;
        return;
    }

    if (self.head.rectangle.y > Consts.arena_max_y) {
        self.head.rectangle.y = Consts.arena_min_y;
        return;
    }

    if (self.head.rectangle.x > Consts.arena_max_x) {
        self.head.rectangle.x = Consts.arena_min_x;
        return;
    }
}

fn updateLocations(self: *Self) void {
    var CurrentCell: ?*SnakeCell = self.last;

    while (CurrentCell) |value| {
        if (value.previous) |previous_cell| {
            value.rectangle = previous_cell.rectangle;
        }

        CurrentCell = CurrentCell.?.previous;
    }
}

pub fn tick(self: *Self) void {
    updateLocations(self);

    switch (self.direction) {
        .up => {
            self.head.rectangle.y -= Consts.snake_cell_size;
        },
        .down => {
            self.head.rectangle.y += Consts.snake_cell_size;
        },
        .left => {
            self.head.rectangle.x -= Consts.snake_cell_size;
        },
        .right => {
            self.head.rectangle.x += Consts.snake_cell_size;
        },
    }

    teleportOnEdge(self);
}

pub fn render(self: *Self) void {
    var CurrentCell: ?*SnakeCell = &self.head;

    while (CurrentCell) |value| {
        ray.DrawRectangleRec(value.rectangle, self.color);
        CurrentCell = value.next;
    }
}

fn canChangeDirection(self: *Self, direction: Direction) bool {
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

fn move(self: *Self, direction: Direction) void {
    if (self.canChangeDirection(direction)) {
        self.direction = direction;
    } else {
        ray.TraceLog(ray.LOG_INFO, "Cannot set that direction!");
    }
}

pub fn input(self: *Self) void {
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
