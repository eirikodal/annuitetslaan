const std = @import("std");
const terminbelp_zig = @import("terminbelp_zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();

    _ = args_iter.next(); // Skip program name

    var lan_str = args_iter.next();
    if (lan_str != null and (std.mem.eql(u8, lan_str.?, "-h") or std.mem.eql(u8, lan_str.?, "--help"))) {
        return showUsage();
    }

    var ar_str = args_iter.next();
    var rente_str = args_iter.next();

    // Interaktiv input hvis argumenter mangler
    if (lan_str == null or ar_str == null or rente_str == null) {
        const stdin = std.fs.File.stdin();
        var buf: [100]u8 = undefined;

        if (lan_str == null) {
            std.debug.print("Lanebelop: ", .{});
            lan_str = try readLine(stdin, &buf, allocator);
        }
        if (ar_str == null) {
            std.debug.print("Antall ar: ", .{});
            ar_str = try readLine(stdin, &buf, allocator);
        }
        if (rente_str == null) {
            std.debug.print("Arlig rente (%): ", .{});
            rente_str = try readLine(stdin, &buf, allocator);
        }
    }

    const lan = try std.fmt.parseFloat(f64, lan_str.?);
    const ar = try std.fmt.parseInt(u32, ar_str.?, 10);
    const rente = try std.fmt.parseFloat(f64, rente_str.?);

    const terminbelop = terminbelp_zig.calculate_terminbelop(lan, ar, rente);

    std.debug.print("Terminbelop: {d:.2} kr/mnd\n", .{terminbelop});
}

fn readLine(file: std.fs.File, buf: []u8, allocator: std.mem.Allocator) ![:0]const u8 {
    const n = try file.read(buf);
    return try allocator.dupeZ(u8, std.mem.trim(u8, buf[0..n], &std.ascii.whitespace));
}

fn showUsage() void {
    std.debug.print("Bruk: terminbelp <lanebelop> <ar> <rente>\n", .{});
}
