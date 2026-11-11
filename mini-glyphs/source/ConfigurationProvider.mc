import Toybox.System;
import Toybox.Time;
import Toybox.UserProfile;

class ConfigurationProvider {
    var font;
    var highlightColor;
    var regularColor;
    private var settings;

    function initialize() {
        settings = new Settings();

        loadFont();
        loadColors();
    }

    function getCurrentTime() {
        var clockTime = System.getClockTime();
        return GlyphsDisplay.roundedTime(clockTime.hour, clockTime.min);
    }

    function shouldUseSleepModeLayout() {
        if (!settings.get("EnableSleepModeLayout")) { return false; }
        var profile = UserProfile.getProfile();
        var sleep = profile.sleepTime;
        var wake = profile.wakeTime;
        var clock = System.getClockTime();
        var nowSeconds = clock.hour * 3600 + clock.min * 60 + clock.sec;
        return GlyphsDisplay.isScheduledSleep(nowSeconds, sleep == null ? null : sleep.value(), wake == null ? null : wake.value());
    }

    private function loadFont() {
        font = WatchUi.loadResource(Rez.Fonts.Inconsolata);
    }

    private function loadColors() {
        var highlightRgb;
        var regularRgb;

        var useCustomColors = settings.get("UseCustomColors");

        if (useCustomColors) {
            highlightRgb = new Rgb(settings.get("RedHighlightColor"), settings.get("GreenHighlightColor"), settings.get("BlueHighlightColor"));
            regularRgb = new Rgb(settings.get("RedRegularColor"), settings.get("GreenRegularColor"), settings.get("BlueRegularColor"));
        } else {
            var presetColor = settings.get("PresetColor");
            switch (presetColor) {
                default:
                case Blue:
                    highlightRgb = new Rgb(102, 204, 255);
                    regularRgb = new Rgb(30, 59, 74);
                    break;
                case Green:
                    highlightRgb = new Rgb(51, 204, 51);
                    regularRgb = new Rgb(20, 82, 20);
                    break;
                case Grey:
                    highlightRgb = new Rgb(128, 128, 128);
                    regularRgb = new Rgb(51, 51, 51);
                    break;
                case Orange:
                    highlightRgb = new Rgb(255, 153, 0);
                    regularRgb = new Rgb(102, 61, 0);
                    break;
                case Pink:
                    highlightRgb = new Rgb(255, 51, 204);
                    regularRgb = new Rgb(84, 17, 67);
                    break;
                case Red:
                    highlightRgb = new Rgb(255, 0, 0);
                    regularRgb = new Rgb(102, 0, 0);
                    break;
                case Yellow:
                    highlightRgb = new Rgb(255, 255, 0);
                    regularRgb = new Rgb(102, 102, 0);
                    break;
            }
        }

        highlightColor = highlightRgb.getHex();
        // Control only background letters; persisted custom colors remain intact.
        var brightness = settings.get("BackgroundBrightness");
        if (brightness == null) { brightness = 60; }
        regularColor = regularRgb.getDimmedHex(brightness);
    }

    enum {
        Blue,
        Green,
        Grey,
        Orange,
        Pink,
        Red,
        Yellow,
    }

    class Rgb {
        private var r;
        private var g;
        private var b;

        function initialize(r, g, b) {
            me.r = r;
            me.g = g;
            me.b = b;
        }

        function getDimmedHex(percent) {
            percent = percent < 0 ? 0 : (percent > 100 ? 100 : percent);
            return (((r * percent / 100).toNumber() & 0xff) << 16) | (((g * percent / 100).toNumber() & 0xff) << 8) | ((b * percent / 100).toNumber() & 0xff);
        }

        function getHex() {
            return ((r & 0x0000ff) << 16) | ((g & 0x0000ff) << 8) | (b & 0x0000ff);
        }
    }
}
