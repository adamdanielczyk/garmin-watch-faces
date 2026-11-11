// Time rounding and scheduled sleep are independent of device low-power mode.
module GlyphsDisplay {
    function roundedTime(hour, minute) {
        var rounded = ((minute + 2) / 5).toNumber() * 5;
        if (rounded > 30) { hour += 1; }
        hour = hour % 12;
        if (hour == 0) { hour = 12; }
        return { :hour => hour, :minutes => rounded % 60 };
    }

    function isScheduledSleep(nowSeconds, sleepSeconds, wakeSeconds) {
        if (sleepSeconds == null || wakeSeconds == null || sleepSeconds == wakeSeconds) { return false; }
        if (sleepSeconds > wakeSeconds) { return nowSeconds >= sleepSeconds || nowSeconds < wakeSeconds; }
        return nowSeconds >= sleepSeconds && nowSeconds < wakeSeconds;
    }

    // Alternating non-overlapping bands extinguish every lit pixel on the next
    // minute, including on older AMOLED devices with cumulative pixel limits.
    function ambientCenterY(height, minute) {
        return height * (minute % 2 == 0 ? 0.30 : 0.70);
    }
}
