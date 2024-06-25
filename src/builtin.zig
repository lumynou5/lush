const std = @import("std");
const builtin_echo = @import("builtin/echo.zig").builtin_echo;

const Builtin = struct {
    name: []const u8,
    func: *const fn (args: []const []const u8) u32,
};

const builtin_data = [_]Builtin{
    .{ .name = "echo", .func = builtin_echo },
};

pub fn execBuiltin(args: []const []const u8) u32 {
    const idx = if (std.sort.binarySearch(Builtin, args[0], &builtin_data, {}, orderBuiltin)) |x| x else {
        return 127;
    };
    return builtin_data[idx].func(args);
}

fn orderBuiltin(_: void, name: []const u8, mid_item: Builtin) std.math.Order {
    return std.mem.order(u8, name, mid_item.name);
}
