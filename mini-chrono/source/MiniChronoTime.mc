import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;

class MiniChronoTime extends WatchUi.Drawable {
    private var configurationProvider;
    private const SCREEN_MARGIN_RATIO = 0.3;
    private const VERTICAL_OFFSET_RATIO = 0.15;
    private const HORIZONTAL_OFFSET_RATIO = 0.05;

    function initialize() {
        Drawable.initialize({ :identifier => "MiniChronoTime" });
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
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;

        var currentTime = configurationProvider.getCurrentTime();
        var hour = currentTime[:hour];
        var minutes = currentTime[:minutes];

        loadFontIfNeeded(dc, screenWidth, screenHeight, hour, minutes);

        var font = configurationProvider.font;
        var fontHeight = dc.getFontHeight(font);
        var centerOffset = getCenterOffset(fontHeight);

        if (configurationProvider.useVerticalLayout) {
            drawVerticalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset);
        } else {
            drawHorizontalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset);
        }
        
        if (configurationProvider.showBattery) {
            drawBatteryIcon(dc, screenWidth, screenHeight);
        }
    }

    function loadFontIfNeeded(dc, screenWidth, screenHeight, hour, minutes) {
        if (configurationProvider.isFontSizeCalculated()) {
            return;
        }

        var isFontValid = false;
        while (!isFontValid) {
            isFontValid = configurationProvider.isMinimalFontSize() || isCurrentFontValid(dc, screenWidth, screenHeight, hour, minutes);

            if (isFontValid) {
                configurationProvider.setFontSizeCalculated();
            } else {
                configurationProvider.loadSmallerFont();
            }
        }
    }

    function isCurrentFontValid(dc, screenWidth, screenHeight, hour, minutes) {
        var font = configurationProvider.font;

        var timeWidth;
        var timeHeight;

        var fontHeight = dc.getFontHeight(font);
        var hourWidth = dc.getTextWidthInPixels(hour, font);
        var minutesWidth = dc.getTextWidthInPixels(minutes, font);
        var centerOffset = getCenterOffset(fontHeight);

        if (configurationProvider.useVerticalLayout) {
            timeWidth = hourWidth > minutesWidth ? hourWidth : minutesWidth;
            timeHeight = 2 * (fontHeight + centerOffset);
        } else {
            timeWidth = hourWidth + minutesWidth + 2 * centerOffset;
            timeHeight = fontHeight;
        }

        var additionalWidthSpace = screenWidth * SCREEN_MARGIN_RATIO;
        var additionalHeightSpace = screenHeight * SCREEN_MARGIN_RATIO;

        timeWidth += additionalWidthSpace;
        timeHeight += additionalHeightSpace;

        return timeWidth < screenWidth && timeHeight < screenHeight;
    }

    function getCenterOffset(fontHeight) {
        if (configurationProvider.useVerticalLayout) {
            return fontHeight * VERTICAL_OFFSET_RATIO;
        } else {
            return fontHeight * HORIZONTAL_OFFSET_RATIO;
        }
    }

    function drawVerticalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset) {
        var hourY = centerY - fontHeight - centerOffset;
        var minutesY = centerY + centerOffset;

        drawValue(dc, font, configurationProvider.hourColor, centerX, hourY, hour, Graphics.TEXT_JUSTIFY_CENTER);
        drawValue(dc, font, configurationProvider.minutesColor, centerX, minutesY, minutes, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHorizontalLayout(dc, hour, minutes, centerX, centerY, font, fontHeight, centerOffset) {
        var hourWidth = dc.getTextWidthInPixels(hour, font);
        var minutesWidth = dc.getTextWidthInPixels(minutes, font);
        var adjustedCenterX = centerX + (hourWidth - minutesWidth) / 2;

        var hourX = adjustedCenterX - centerOffset;
        var minutesX = adjustedCenterX + centerOffset;
        var y = centerY - fontHeight / 2;

        drawValue(dc, font, configurationProvider.hourColor, hourX, y, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        drawValue(dc, font, configurationProvider.minutesColor, minutesX, y, minutes, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawValue(dc, font, color, x, y, hour, textJustify) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, hour, textJustify);
    }
    
    function drawBatteryIcon(dc, screenWidth, screenHeight) {
        var battery = System.getSystemStats().battery;
        var centerX = screenWidth / 2;
        var topMargin = (screenHeight * 0.08).toNumber();
        
        var iconWidth = 20;
        var iconHeight = 10;
        var iconX = centerX - iconWidth / 2;
        var iconY = topMargin;
        
        var outlineColor = configurationProvider.minutesColor;
        var fillColor = configurationProvider.hourColor;
        
        // Draw battery outline
        dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawRectangle(iconX, iconY, iconWidth - 2, iconHeight);
        
        // Draw battery tip (positive terminal)
        dc.drawRectangle(iconX + iconWidth - 2, iconY + 2, 2, iconHeight - 4);
        
        // Fill battery based on level
        if (battery > 10) {
            var fillWidth = ((iconWidth - 4) * battery / 100).toNumber();
            
            dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(iconX + 1, iconY + 1, fillWidth, iconHeight - 2);
        }
    }
}
