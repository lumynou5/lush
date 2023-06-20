const std = @import("std");
const execBuiltin = @import("builtin.zig").execBuiltin;
const execCommand = @import("command.zig").execCommand;
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
        if (args.len == 0) continue;
        var status = execBuiltin(args);
        if (status == 127) {
            status = try execCommand(allocator, args);
        }

        try stdout.print("\n{d}", .{status});
    }
}
