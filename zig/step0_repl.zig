const std = @import("std");

pub fn READ(str: []const u8) []u8 {
    return str;
}

pub fn EVAL(ast: []const u8, env: []const u8) []u8 {
    return ast;
}

pub fn PRINT(exp: []const u8) []u8 {
    return exp;
}

pub fn REP(str: []const u8) []u8 {
    return PRINT(EVAL(READ(str), ""));
}

pub fn main() !void {
    const stdout_file = try std.io.getStdOut();
    var bytes: [1024]u8 = undefined;
    const allocator = &std.heap.FixedBufferAllocator.init(bytes[0..]).allocator;
    var lineBuffer = try std.Buffer.initSize(allocator, 0);
    defer lineBuffer.deinit();

    while (true) {
        try stdout_file.write("user> ");
        var line = std.io.readLine(&lineBuffer) catch |err| {
            try stdout_file.write("\n");
            break;
        };
        if (line.len == 0) continue;
        try stdout_file.write(line);
        try stdout_file.write("\n");
    }
}
