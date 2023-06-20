const std = @import("std");

pub fn builtin_echo(args: []const []const u8) u32 {
    const stdout = std.io.getStdOut().writer();
    var i: usize = 1;
    while (i < args.len) : (i += 1) {
        if (i != 1) {
            stdout.print(" ", .{}) catch return 1;
        }
        stdout.print("{s}", .{args[i]}) catch return 1;
    }
    return 0;
}
