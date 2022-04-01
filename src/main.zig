const std = @import("std");
const qoi = @import("qoi.zig");

pub fn main() anyerror!void {
    const arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
}