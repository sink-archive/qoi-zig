const std = @import("std");

// TYPES

const QoiHeader = struct {
    magic: [4]u8 = "qoif", // magic bytes
    width: u32,
    height: u32,
    channels: u8, // purely informational
    colorpace: u8, // see above
};

const Pixel = struct { r: u8 = 0, g: u8 = 0, b: u8 = 0, a: u8 = 255 };

const BinaryList = std.ArrayList(u8);

// END TYPES

inline fn pixelsEq(a: Pixel, b: Pixel) bool {
    return (a.r == b.r) and (a.g == b.g) and (a.b == b.b) and (a.a == b.a);
}

inline fn to16(val: u8) u16 {
    return @intCast(u16, val);
}
inline fn to8(val: u16) u8 {
    return @intCast(u8, val);
}

inline fn hash(pix: Pixel) u8 {
    return to8((to16(pix.r) * 3 + to16(pix.g) * 5 + to16(pix.b) * 7 + to16(pix.a) * 11) % 64);
}

inline fn makeRun(len: u8) u8 {
    return 0xC0 | len;
}

inline fn diff(prev: Pixel, curr: Pixel) ?Pixel {
    if (prev.a != curr.a) return null;

    var dr = curr.r -% prev.r;
    var dg = curr.g -% prev.g;
    var db = curr.b -% prev.b;

    if () // TODO: FINISH THIS!!!
}

var prevSeen: [64]u8 = undefined;

// the image may have at most ~4.29 billion pixels
fn enc(inputPtr: [*]Pixel, length: u32) std.mem.Allocator.Error!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var output = BinaryList.init(arena.allocator());

    var previousPixel = Pixel{};
    var runlength: u8 = 0;
    var index: u32 = 0;

    while (index < length) : ({
        index += 1;
        previousPixel = inputPtr[index - 1];
    }) {
        const currentPixel = inputPtr[index];

        if (pixelsEq(previousPixel, currentPixel)) {
            runlength += 1;
            continue;
        } else if (runlength > 0) {
            try output.appendSlice(&[_]u8{ 0xFF, previousPixel.r, previousPixel.g, previousPixel.b, previousPixel.a, makeRun(runlength) });
            runlength = 0;
        }
    }
}
