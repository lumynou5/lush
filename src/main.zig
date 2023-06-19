const std = @import("std");
const execBuiltin = @import("builtin.zig").execBuiltin;
const tokenize = @import("tokenizer.zig").tokenize;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        try stdout.print("> ", .{});
        const input = if (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024)) |str| str else {
            return;
        };
        defer allocator.free(input);

        const args = try tokenize(allocator, input);
        defer allocator.free(args);
        const status = execBuiltin(args);

        try stdout.print("\n{d}", .{status});
    }
}
