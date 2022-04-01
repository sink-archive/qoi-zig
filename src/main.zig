const std = @import("std");
const qoi = @import("qoi.zig");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const stdout = std.io.getStdOut().writer();

    var args = try std.process.argsWithAllocator(allocator);
    if (!args.skip())
        unreachable; // ignore argv[0], crash if for some reason argv has 0 length
    
    if (args.next(allocator)) |firstArg| {
        if (firstArg == "enc" or firstArg == "dec") {
            const encMode = firstArg == "enc";
            // true = enc, false = dec

            if (args.next(allocator)) |sourcePath| {
                if (args.next(alocator)) |thirdArg| {
                    // std.fs.openFileAbsolute(absolute_path: []const u8, flags: OpenFlags) OpenError!File

                    return;
                }
            }

            try stdout.print("You must supply two args that are paths", .{});
            return;
        }
    }
    
    try stdout.print("You must supply enc or dec as an arg", .{});
}