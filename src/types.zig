// header and pixel are packed so that they can be casted to and from [*]u8 correctly
// because the fields will always be in the correct order and the correct size

pub const Pixel = packed struct {
    r: u8 = 0,
    g: u8 = 0,
    b: u8 = 0,
    a: u8 = 255
};

pub const QoiImage = packed struct {
    magic: [4]u8 = "qoif", // magic bytes
    width: u32,
    height: u32,
    channels: u8, // purely informational
    colorspace: u8, // see above
    pixels: []u8
};

pub const BmpImage = packed struct {
    // header
    id: [2]u8 = "BM", // magic bytes
    size: u32,
    reserved: u32 = 0, // technically two 16 bit fields but who's counting?
    offset: u32 = 0x0E, // where the pixels start
    // DIB header
    // BITMAPINFOHEADER
    dibSize: u32 = 40,
    width: i16,
    height: i16,
    colorPlanes: u16 = 1, // must be 1
    bitsPerPixel: u16 = 32,
    compressionMethod: u32 = 0, // no compression
    dummyImageSize: u32 = 0, // dummy value since no compression applied
    widthDensity: i32 = 0,
    heightDensity: i32 = 0,
    colorPalette: u32 = 0, // dummy value to use a default
    importantColorCount: u32 = 0, // even wikipedia calls this "generally ignored" big L
    // begin pixels FINALLY
    pixels: []u8
};

pub const GenericImage = struct {
    width: u32,
    height: u32,
    pixels: []Pixel
};