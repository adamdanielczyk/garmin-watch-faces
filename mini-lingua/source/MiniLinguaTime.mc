import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;

class MiniLinguaTime extends WatchUi.Drawable {
    private var configurationProvider;

    function initialize() {
        Drawable.initialize({ :identifier => "MiniLinguaTime" });
        loadConfiguration();
    }

    function onSettingsChanged() {
        loadConfiguration();
    }

    function loadConfiguration() {
        configurationProvider = new ConfigurationProvider();
    }

    function draw(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        loadFontIfNeeded(dc, screenWidth, screenHeight);

        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;

        var currentTime = configurationProvider.getCurrentTime();
        var hoursSplit = currentTime[:hoursSplit];
        var minutesSplit = currentTime[:minutesSplit];

        var boldFont = configurationProvider.boldFont;
        var regularFont = configurationProvider.regularFont;

        var boldFontHeight = dc.getFontHeight(boldFont);
        var regularFontHeight = dc.getFontHeight(regularFont);

        var hoursSplitSize = hoursSplit.size();
        var minutesSplitSize = minutesSplit.size();
        var totalHoursHeight = hoursSplitSize * boldFontHeight;
        var totalTextHeight = totalHoursHeight + minutesSplitSize * regularFontHeight;

        var topHoursY = centerY - totalTextHeight / 2;
        var topMinutesY = topHoursY + totalHoursHeight;

        drawValues(dc, boldFont, boldFontHeight, configurationProvider.hourColor, centerX, topHoursY, hoursSplit);
        drawValues(dc, regularFont, regularFontHeight, configurationProvider.minutesColor, centerX, topMinutesY, minutesSplit);
    }

    function loadFontIfNeeded(dc, screenWidth, screenHeight) {
        if (configurationProvider.isFontSizeCalculated()) {
            return;
        }

        var isFontValid = false;
        while (!isFontValid) {
            isFontValid = configurationProvider.isMinimalFontSize() || isCurrentFontValid(dc, screenWidth, screenHeight);

            if (isFontValid) {
                configurationProvider.setFontSizeCalculated();
            } else {
                configurationProvider.loadSmallerFont();
            }
        }
    }

    function isCurrentFontValid(dc, screenWidth, screenHeight) {
        var boldFont = configurationProvider.boldFont;
        var regularFont = configurationProvider.regularFont;

        var boldFontHeight = dc.getFontHeight(boldFont);
        var regularFontHeight = dc.getFontHeight(regularFont);

        var longestHoursText = configurationProvider.getLongestHoursText();
        var longestMinutesText = configurationProvider.getLongestMinutesText();
        var maxHoursRows = configurationProvider.getMaxHoursRows();
        var maxMinutesRows = configurationProvider.getMaxMinutesRows();

        var boldFontWidth = dc.getTextWidthInPixels(longestHoursText, boldFont);
        var regularFontWidth = dc.getTextWidthInPixels(longestMinutesText, regularFont);
        var maxFontWidth = boldFontWidth > regularFontWidth ? boldFontWidth : regularFontWidth;

        var additionalHeightSpace = screenHeight * 0.2;
        var additionalWidthSpace = screenWidth * 0.1;

        var maxColumnHeight = maxHoursRows * boldFontHeight + maxMinutesRows * regularFontHeight + additionalHeightSpace;
        var maxRowWidth = maxFontWidth + additionalWidthSpace;

        return maxColumnHeight < screenHeight && maxRowWidth < screenWidth;
    }

    function drawValues(dc, font, fontHeight, color, x, topY, values) {
        for (var i = 0; i < values.size(); i++) {
            var value = values[i];
            var y = topY + i * fontHeight;

            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x, y, font, value, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
