const std = @import("std");

pub fn execCommand(allocator: std.mem.Allocator, argv: []const []const u8) !u32 {
    var process = std.ChildProcess.init(argv, allocator);
    process.stdin_behavior = .Inherit;
    process.stdout_behavior = .Inherit;
    process.stderr_behavior = .Inherit;
    const term = try process.spawnAndWait();
    return switch (term) {
        .Exited => |x| @intCast(u32, x),
        .Signal => |x| x,
        .Stopped => |x| x,
        .Unknown => |x| x,
    };
}
