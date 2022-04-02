const std = @import("std");
const img = @import("img");
const qoi = @import("qoi.zig");
const types = @import("types.zig");

pub fn qoi2bmp(allocator: std.mem.Allocator, input: []u8, output: []u8) !void {
    const source = try std.fs.openFileAbsolute(input, std.fs.File.OpenFlags{ .read = true, .write = false });
    const bytes = try source.readToEndAlloc(allocator, 0xFFFFFFFFFFFFFFFF);

    const decoded = try qoi.dec(allocator, @bitCast(types.QoiImage, bytes));

    const image = try img.Image.create(allocator, decoded.width, decoded.height, img.PixelFormat.Rgba32, img.ImageFormat.Bmp);

    try image.writeToFilePath(output, image.image_format, img.AllFormats.ImageEncoderOptions{});
}

pub fn img2qoi(allocator: std.mem.Allocator, input: []u8, output: []u8) !void {
    const image = try img.Image.fromFilePath(allocator, input);
    const bytes = try image.rawBytes();

    const encoded = try qoi.enc(allocator, @bitCast([]types.Pixel, bytes), @intCast(u32, bytes.len));

    const dest = try std.fs.createFileAbsolute(output, std.fs.File.CreateFlags{
        .read = false,
        .truncate = false, // do not append
        .exclusive = false,
    });

    try dest.writeAll(encoded);
}
