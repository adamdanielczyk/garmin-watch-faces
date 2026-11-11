import Toybox.Application;
import Toybox.Graphics;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class MiniIndexView extends WatchUi.WatchFace {
    private var lowPower = false;
    private var accent;
    private var showDate;
    private var markers;

    function initialize() { WatchFace.initialize(); loadSettings(); }
    function loadSettings() {
        var selected = Application.Properties.getValue("Accent");
        var colors = IndexGeometry.isAmoled() ? [0x99CCBB, 0xEEEEEE, 0xFF9900, 0x99CCFF] : [0x00FFAA, 0xFFFFFF, 0xFF9900, 0x00AAFF];
        if (selected == null || selected < 0 || selected >= colors.size()) { selected = 2; }
        accent = colors[selected];
        if (Application.Properties.getValue("UseCustomColor") == true) {
            var red = colorChannel("MinuteHandRed", 255);
            var green = colorChannel("MinuteHandGreen", 153);
            var blue = colorChannel("MinuteHandBlue", 0);
            accent = (red << 16) | (green << 8) | blue;
        }
        if (IndexGeometry.isMonochrome()) { accent = Graphics.COLOR_WHITE; }
        showDate = Application.Properties.getValue("ShowDate") == true;
        markers = Application.Properties.getValue("HourMarkers");
        if (markers != 4 && markers != 12) { markers = 0; }
    }
    private function colorChannel(key, fallback) {
        var value = Application.Properties.getValue(key);
        if (value == null) { return fallback; }
        if (value < 0) { return 0; }
        if (value > 255) { return 255; }
        return value.toNumber();
    }
    function onEnterSleep() { lowPower = true; WatchUi.requestUpdate(); }
    function onExitSleep() { lowPower = false; WatchUi.requestUpdate(); }

    function onUpdate(dc) {
        dc.clearClip();
        // Smooth diagonal hands where supported; preserve crisp low-power rendering.
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(!lowPower && IndexGeometry.isAmoled());
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var now = System.getClockTime();
        var ambient = lowPower && IndexGeometry.isAmoled();
        var dial = IndexGeometry.dial(dc.getWidth(), dc.getHeight(), ambient, now.min);
        var cx = dial[:x]; var cy = dial[:y]; var radius = dial[:radius];
        var foreground = ambient ? 0x808080 : Graphics.COLOR_WHITE;
        var minuteColor = ambient ? foreground : accent;
        var markerCount = ambient && markers > 4 ? 4 : markers;
        var stroke = ambient ? 1 : (radius / 65).toNumber();
        if (stroke < 1) { stroke = 1; }
        dc.setColor(foreground, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(stroke);
        for (var i = 0; i < markerCount; i++) {
            var angle = i * Math.PI * 2 / markerCount;
            var cardinal = markerCount == 4 || i % 3 == 0;
            var inner = radius * (cardinal ? 0.91 : 0.96);
            dc.drawLine((cx + Math.sin(angle)*inner).toNumber(), (cy - Math.cos(angle)*inner).toNumber(),
                        (cx + Math.sin(angle)*radius).toNumber(), (cy - Math.cos(angle)*radius).toNumber());
        }
        // Draw date first: hands always remain visible as they cross it.
        if (showDate && !ambient) {
            var date = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            dc.setColor(foreground, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, cy + radius*0.57, Graphics.FONT_XTINY, date.day.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        var hourWidth = ambient ? 2 : (radius * 0.032).toNumber();
        var minuteWidth = ambient ? 1 : (radius * 0.019).toNumber();
        if (!ambient && minuteWidth < 2) { minuteWidth = 2; }
        hand(dc, cx, cy, radius*0.57, IndexGeometry.hourAngle(now.hour, now.min), foreground, hourWidth < 2 ? 2 : hourWidth);
        hand(dc, cx, cy, radius*0.84, IndexGeometry.minuteAngle(now.min), minuteColor, minuteWidth < 1 ? 1 : minuteWidth);
        dc.setColor(foreground, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, ambient ? 1 : stroke + 1);
    }

    function hand(dc, x, y, length, angle, color, width) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(width);
        dc.drawLine(x, y, (x + Math.sin(angle)*length).toNumber(), (y - Math.cos(angle)*length).toNumber());
    }
}
