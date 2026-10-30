import Toybox.System;
import Toybox.WatchUi;

class ConfigurationProvider {
    var boldFont;
    var regularFont;
    var hourColor;
    var minutesColor;

    private var settings;

    function initialize() {
        settings = new Settings();

        loadFont();
        loadColors();
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

        var hourText = WatchUi.loadResource(hoursArray[hour]);
        var minutesText = WatchUi.loadResource(minutesArray[minutes]);

        var hoursSplit = splitString(hourText, " ");
        var minutesSplit = minutes != 0 ? splitString(minutesText, " ") : [];

        return {
            :hoursSplit => hoursSplit,
            :minutesSplit => minutesSplit,
        };
    }

    function getLongestHoursText() {
        return getLongestText(hoursArray);
    }

    function getLongestMinutesText() {
        return getLongestText(minutesArray);
    }

    private function getLongestText(values) {
        var longestText = "";
        var maxLength = 0;

        for (var i = 0; i < values.size(); i++) {
            var value = WatchUi.loadResource(values[i]);
            var split = splitString(value, " ");

            for (var j = 0; j < split.size(); j++) {
                var text = split[j];
                var length = text.length();
                if (length > maxLength) {
                    maxLength = length;
                    longestText = text;
                }
            }
        }

        return longestText;
    }

    function getMaxHoursRows() {
        return getMaxRows(hoursArray);
    }

    function getMaxMinutesRows() {
        return getMaxRows(minutesArray);
    }

    private function getMaxRows(values) {
        var maxRows = 0;

        for (var i = 0; i < values.size(); i++) {
            var value = WatchUi.loadResource(values[i]);
            var split = splitString(value, " ");
            var rows = split.size();
            if (rows > maxRows) {
                maxRows = rows;
            }
        }

        return maxRows;
    }

    private function splitString(text, delimiter) {
        var result = [];
        var start = 0;
        var end = text.find(delimiter);

        while (end != null) {
            result.add(text.substring(start, end));
            text = text.substring(end + delimiter.length(), text.length());
            end = text.find(delimiter);
        }

        result.add(text);

        return result;
    }

    function isFontSizeCalculated() {
        return settings.get("IsFontSizeCalculated");
    }

    function setFontSizeCalculated() {
        settings.set("IsFontSizeCalculated", true);
    }

    function isMinimalFontSize() {
        return getFontSize() == SizeExtraSmall;
    }

    function loadSmallerFont() {
        settings.set("SelectedFontSize", getFontSize() - 1);
        loadFont();
    }

    private function loadFont() {
        var fontSize = getFontSize();
        boldFont = WatchUi.loadResource(boldFonts[fontSize]);
        regularFont = WatchUi.loadResource(regularFonts[fontSize]);
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

    private const boldFonts = [
        Rez.Fonts.LatoBold1,
        Rez.Fonts.LatoBold2,
        Rez.Fonts.LatoBold3,
        Rez.Fonts.LatoBold4,
        Rez.Fonts.LatoBold5
    ];

    private const regularFonts = [
        Rez.Fonts.LatoRegular1,
        Rez.Fonts.LatoRegular2,
        Rez.Fonts.LatoRegular3,
        Rez.Fonts.LatoRegular4,
        Rez.Fonts.LatoRegular5
    ];

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

    private const hoursArray = [
        Rez.Strings.Hour0,
        Rez.Strings.Hour1,
        Rez.Strings.Hour2,
        Rez.Strings.Hour3,
        Rez.Strings.Hour4,
        Rez.Strings.Hour5,
        Rez.Strings.Hour6,
        Rez.Strings.Hour7,
        Rez.Strings.Hour8,
        Rez.Strings.Hour9,
        Rez.Strings.Hour10,
        Rez.Strings.Hour11,
        Rez.Strings.Hour12,
        Rez.Strings.Hour13,
        Rez.Strings.Hour14,
        Rez.Strings.Hour15,
        Rez.Strings.Hour16,
        Rez.Strings.Hour17,
        Rez.Strings.Hour18,
        Rez.Strings.Hour19,
        Rez.Strings.Hour20,
        Rez.Strings.Hour21,
        Rez.Strings.Hour22,
        Rez.Strings.Hour23,
    ];

    private const minutesArray = [
        Rez.Strings.Minute0,
        Rez.Strings.Minute1,
        Rez.Strings.Minute2,
        Rez.Strings.Minute3,
        Rez.Strings.Minute4,
        Rez.Strings.Minute5,
        Rez.Strings.Minute6,
        Rez.Strings.Minute7,
        Rez.Strings.Minute8,
        Rez.Strings.Minute9,
        Rez.Strings.Minute10,
        Rez.Strings.Minute11,
        Rez.Strings.Minute12,
        Rez.Strings.Minute13,
        Rez.Strings.Minute14,
        Rez.Strings.Minute15,
        Rez.Strings.Minute16,
        Rez.Strings.Minute17,
        Rez.Strings.Minute18,
        Rez.Strings.Minute19,
        Rez.Strings.Minute20,
        Rez.Strings.Minute21,
        Rez.Strings.Minute22,
        Rez.Strings.Minute23,
        Rez.Strings.Minute24,
        Rez.Strings.Minute25,
        Rez.Strings.Minute26,
        Rez.Strings.Minute27,
        Rez.Strings.Minute28,
        Rez.Strings.Minute29,
        Rez.Strings.Minute30,
        Rez.Strings.Minute31,
        Rez.Strings.Minute32,
        Rez.Strings.Minute33,
        Rez.Strings.Minute34,
        Rez.Strings.Minute35,
        Rez.Strings.Minute36,
        Rez.Strings.Minute37,
        Rez.Strings.Minute38,
        Rez.Strings.Minute39,
        Rez.Strings.Minute40,
        Rez.Strings.Minute41,
        Rez.Strings.Minute42,
        Rez.Strings.Minute43,
        Rez.Strings.Minute44,
        Rez.Strings.Minute45,
        Rez.Strings.Minute46,
        Rez.Strings.Minute47,
        Rez.Strings.Minute48,
        Rez.Strings.Minute49,
        Rez.Strings.Minute50,
        Rez.Strings.Minute51,
        Rez.Strings.Minute52,
        Rez.Strings.Minute53,
        Rez.Strings.Minute54,
        Rez.Strings.Minute55,
        Rez.Strings.Minute56,
        Rez.Strings.Minute57,
        Rez.Strings.Minute58,
        Rez.Strings.Minute59,
    ];
}
