const std = @import("std");

pub fn tokenize(allocator: std.mem.Allocator, src: []u8) std.mem.Allocator.Error![][]u8 {
    var result = std.ArrayList([]u8).init(allocator);
    defer result.deinit();

    var i: usize = 0;
    while (i < src.len) : (i += 1) {
        if (std.ascii.isWhitespace(src[i])) continue;
        const end = if (std.mem.indexOfAny(u8, src[i..], &std.ascii.whitespace)) |x| i + x else src.len;
        try result.append(src[i..end]);
        i = end;
    }
    return result.toOwnedSlice();
}
