import Toybox.System;
import Toybox.WatchUi;

class ConfigurationProvider {
    var font;
    var hourColor;
    var minutesColor;

    var useVerticalLayout;
    var showBattery;
    
    private var hideHourLeadingZero;
    private var settings;

    function initialize() {
        settings = new Settings();

        loadFont();
        loadColors();

        useVerticalLayout = settings.get("UseVerticalLayout");
        hideHourLeadingZero = settings.get("HideHourLeadingZero");
        
        showBattery = settings.get("ShowBattery");
    }

    function getCurrentTime() {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minutes = clockTime.min;

        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        return {
            :hour => hour.format(hideHourLeadingZero ? "%d" : "%02d"),
            :minutes => minutes.format("%02d"),
        };
    }

    function isFontSizeCalculated() {
        return settings.get(useVerticalLayout ? "IsFontSizeCalculatedForVerticalLayout" : "IsFontSizeCalculatedForHorizontalLayout");
    }

    function setFontSizeCalculated() {
        settings.set(useVerticalLayout ? "IsFontSizeCalculatedForVerticalLayout" : "IsFontSizeCalculatedForHorizontalLayout", true);
    }

    function isMinimalFontSize() {
        return getFontSize() == SizeExtraSmall;
    }

    function loadSmallerFont() {
        settings.set("SelectedFontSize", getFontSize() - 1);
        loadFont();
    }

    private function loadFont() {
        var selectedFont = settings.get("SelectedFont");
        var fontSize = getFontSize();
        font = WatchUi.loadResource(fonts[selectedFont][fontSize]);
    }

    private function getFontSize() {
        return settings.get("SelectedFontSize");
    }

    private function loadColors() {
        var hourRgb;
        var minutesRgb;

        var useCustomColors = settings.get("UseCustomColors");

        if (useCustomColors) {
            hourRgb = new Rgb(settings.get("RedHourColor"), settings.get("GreenHourColor"), settings.get("BlueHourColor"));
            minutesRgb = new Rgb(settings.get("RedMinutesColor"), settings.get("GreenMinutesColor"), settings.get("BlueMinutesColor"));
        } else {
            var presetColor = settings.get("PresetColor");
            switch (presetColor) {
                default:
                case Blue:
                    hourRgb = new Rgb(102, 204, 255);
                    minutesRgb = new Rgb(230, 247, 255);
                    break;
                case Green:
                    hourRgb = new Rgb(51, 204, 51);
                    minutesRgb = new Rgb(235, 250, 235);
                    break;
                case Grey:
                    hourRgb = new Rgb(128, 128, 128);
                    minutesRgb = new Rgb(230, 230, 230);
                    break;
                case Orange:
                    hourRgb = new Rgb(255, 153, 0);
                    minutesRgb = new Rgb(255, 245, 230);
                    break;
                case Pink:
                    hourRgb = new Rgb(255, 51, 204);
                    minutesRgb = new Rgb(255, 230, 249);
                    break;
                case Red:
                    hourRgb = new Rgb(255, 0, 0);
                    minutesRgb = new Rgb(255, 230, 230);
                    break;
                case Yellow:
                    hourRgb = new Rgb(255, 255, 0);
                    minutesRgb = new Rgb(255, 255, 230);
                    break;
            }
        }

        hourColor = hourRgb.getHex();
        minutesColor = minutesRgb.getHex();
    }

    private const fonts = {
        CourierPrime => [
            Rez.Fonts.CourierPrime1,
            Rez.Fonts.CourierPrime2,
            Rez.Fonts.CourierPrime3,
            Rez.Fonts.CourierPrime4,
            Rez.Fonts.CourierPrime5
        ],
        Inter => [
            Rez.Fonts.Inter1,
            Rez.Fonts.Inter2,
            Rez.Fonts.Inter3,
            Rez.Fonts.Inter4,
            Rez.Fonts.Inter5
        ],
        Monofett => [
            Rez.Fonts.Monofett1,
            Rez.Fonts.Monofett2,
            Rez.Fonts.Monofett3,
            Rez.Fonts.Monofett4,
            Rez.Fonts.Monofett5
        ],
        TiltNeon => [
            Rez.Fonts.TiltNeon1,
            Rez.Fonts.TiltNeon2,
            Rez.Fonts.TiltNeon3,
            Rez.Fonts.TiltNeon4,
            Rez.Fonts.TiltNeon5
        ],
        Tourney => [
            Rez.Fonts.Tourney1,
            Rez.Fonts.Tourney2,
            Rez.Fonts.Tourney3,
            Rez.Fonts.Tourney4,
            Rez.Fonts.Tourney5
        ],
    };

    enum {
        CourierPrime,
        Inter,
        Monofett,
        TiltNeon,
        Tourney,
    }

    enum {
        SizeExtraSmall,
        SizeSmall,
        SizeMedium,
        SizeLarge,
        SizeExtraLarge,
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

        function getHex() {
            return ((r & 0x0000ff) << 16) | ((g & 0x0000ff) << 8) | (b & 0x0000ff);
        }
    }
}
