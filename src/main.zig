const std = @import("std");

const terminbelp_zig = @import("terminbelp_zig");

/// Beregn terminbeløp for annuitetslån
///
/// Formel:  (lån * månedlig_rente) / (1 - (1 + månedlig_rente)^-nedbetalingstid_mnd)
///         (6500000.00 * 0.003992) / (1 - (1 + 0.003992)^-312)
pub fn main(init: std.process.Init.Minimal) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var args_iter = try std.process.Args.Iterator.initAllocator(init.args, allocator);
    // Ingen behov for defer args_iter.deinit() siden arena rydder opp alt

    // Skip program name
    _ = args_iter.next();

    const lan_str = args_iter.next();
    const ar_str = args_iter.next();
    const rente_str = args_iter.next();

    if (lan_str == null or ar_str == null or rente_str == null) {
        std.debug.print("Usage: terminbelp <loan_amount> <years> <annual_interest_rate>\n", .{});
        return;
    }

    const lan_value = try std.fmt.parseFloat(f64, lan_str.?);
    const ar_value = try std.fmt.parseInt(u32, ar_str.?, 10);
    const rente_value = try std.fmt.parseFloat(f64, rente_str.?);

    const terminbelop = terminbelp_zig.calculate_terminbelop(lan_value, ar_value, rente_value);

    std.debug.print("Terminbeløp for lån på {d} over {d} år med {d}% rente er: {d:.2}\n", .{ lan_value, ar_value, rente_value, terminbelop });
}
