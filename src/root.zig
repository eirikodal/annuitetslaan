const std = @import("std");
const Io = std.Io;

/// Beregn terminbeløp for annuitetslån
///
/// Formel:  (lån * månedlig_rente) / (1 - (1 + månedlig_rente)^-nedbetalingstid_mnd)
///         (6500000.00 * 0.003992) / (1 - (1 + 0.003992)^-312)
pub fn calculate_terminbelop(loan: f64, years: u32, annual_interest_rate: f64) f64 {
    const monthly_interest_rate = annual_interest_rate / 100.0 / 12.0;
    const total_payments = years * 12;
    const numerator = loan * 1000000 * monthly_interest_rate;
    const denominator = 1.0 - std.math.pow(f64, 1.0 + monthly_interest_rate, -@as(f64, @floatFromInt(total_payments)));
    return numerator / denominator;
}

test "calculate terminbelop" {
    const terminbelop = calculate_terminbelop(6500000.00, 26, 4.79);
    try std.testing.expect(@abs(terminbelop - 36468.44) < 0.01);
}
