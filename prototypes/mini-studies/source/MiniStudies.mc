// PROTOTYPE: compare hierarchy, readability and a separate low-power composition.
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class MiniStudies extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() { return [new StudiesView()]; }
    function onSettingsChanged() { WatchUi.requestUpdate(); }
}

class StudiesView extends WatchUi.WatchFace {
    var sleeping = false;
    var white = Graphics.COLOR_WHITE;
    var accent = 0x99CCBB;
    var hours = ["twelve", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"];
    var minutes = ["o'clock", "five", "ten", "quarter", "twenty", "twenty five", "half"];
    function initialize() { WatchFace.initialize(); }
    function onEnterSleep() { sleeping = true; }
    function onExitSleep() { sleeping = false; }
    function label(dc, text, x, y, font, color, justify) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, text, justify | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    function onUpdate(dc) {
        var w = dc.getWidth(); var h = dc.getHeight();
        var t = System.getClockTime();
        var low = sleeping || Application.Properties.getValue("PreviewSleep");
        var variant = Application.Properties.getValue("Variant");
        var hour = t.hour;
        if (!System.getDeviceSettings().is24Hour) { hour = hour % 12; if (hour == 0) { hour = 12; } }
        var exact = hour.format("%02d") + ":" + t.min.format("%02d");
        dc.setColor(white, Graphics.COLOR_BLACK); dc.clear();
        // POC only: sparse layout, not a validated burn-in/power implementation.
        if (low) {
            var shift = (t.min % 3 - 1) * 3;
            label(dc, exact, w/2 + shift, h/2, Graphics.FONT_SMALL, 0xAAAAAA, Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }
        if (variant == 0) {
            label(dc, hour.format("%02d"), w/2, h*0.36, Graphics.FONT_NUMBER_THAI_HOT, white, Graphics.TEXT_JUSTIFY_CENTER);
            label(dc, t.min.format("%02d"), w/2, h*0.60, Graphics.FONT_NUMBER_THAI_HOT, accent, Graphics.TEXT_JUSTIFY_CENTER);
        } else if (variant == 1) {
            // Floor to five minutes; 0-4 dots retain exact minute information.
            var bucket = (t.min / 5).toNumber();
            var spokenHour = (t.hour + (bucket > 6 ? 1 : 0)) % 12;
            var phrase = minutes[bucket > 6 ? 12 - bucket : bucket];
            if (bucket != 0) { phrase += bucket > 6 ? " to" : " past"; }
            label(dc, bucket == 0 ? hours[spokenHour] : phrase, w/2, h*0.38, Graphics.FONT_SMALL, accent, Graphics.TEXT_JUSTIFY_CENTER);
            label(dc, bucket == 0 ? "o'clock" : hours[spokenHour], w/2, h*0.53, Graphics.FONT_MEDIUM, white, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            for (var i=0; i<t.min%5; i++) { dc.fillCircle(w/2 + (i-(t.min%5-1)/2.0)*w*0.035, h*0.66, 2); }
        } else {
            // Four indices; no seconds, telemetry, or ornamental progress rings.
            dc.setColor(white, Graphics.COLOR_TRANSPARENT); dc.setPenWidth(2);
            for (var i=0; i<4; i++) {
                var a = i*Math.PI/2;
                dc.drawLine(w/2+Math.sin(a)*w*0.36, h/2-Math.cos(a)*h*0.36, w/2+Math.sin(a)*w*0.39, h/2-Math.cos(a)*h*0.39);
            }
            hand(dc, (t.hour%12 + t.min/60.0)*Math.PI/6, 0.22, w, h, white, 5);
            hand(dc, t.min*Math.PI/30, 0.33, w, h, accent, 3);
            dc.setColor(white, Graphics.COLOR_TRANSPARENT); dc.fillCircle(w/2,h/2,3);
        }
        if (Application.Properties.getValue("Detail")) {
            var date = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            label(dc, date.day.format("%02d"), w/2, h*0.79, Graphics.FONT_XTINY, white, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    function hand(dc, angle, length, w, h, color, width) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT); dc.setPenWidth(width);
        dc.drawLine(w/2, h/2, w/2+Math.sin(angle)*w*length, h/2-Math.cos(angle)*h*length);
    }
}
