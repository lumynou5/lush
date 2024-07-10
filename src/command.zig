const std = @import("std");

pub fn execCommand(allocator: std.mem.Allocator, argv: []const []const u8) !u32 {
    var process = std.process.Child.init(argv, allocator);
    process.stdin_behavior = .Inherit;
    process.stdout_behavior = .Inherit;
    process.stderr_behavior = .Inherit;
    const term = process.spawnAndWait() catch |e| switch (e) {
        error.FileNotFound => return 127,
        else => return e,
    };
    return switch (term) {
        .Exited => |x| @intCast(x),
        .Signal => |x| x,
        .Stopped => |x| x,
        .Unknown => |x| x,
    };
}
