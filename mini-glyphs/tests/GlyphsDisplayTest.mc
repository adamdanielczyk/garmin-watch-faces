import Toybox.Test;
import Toybox.Graphics;
import Toybox.System;

(:test)
function timeRounding(logger) {
    // Nearest five minutes, including noon/midnight and the past/to boundary.
    var cases = [[10, 2, 10, 0], [10, 3, 10, 5], [10, 32, 10, 30],
                 [10, 33, 11, 35], [11, 58, 12, 0], [23, 59, 12, 0], [0, 0, 12, 0]];
    for (var i = 0; i < cases.size(); i++) {
        var value = cases[i];
        var actual = GlyphsDisplay.roundedTime(value[0], value[1]);
        Test.assertEqual(actual[:hour], value[2]);
        Test.assertEqual(actual[:minutes], value[3]);
    }
    return true;
}

(:test)
function scheduledSleepBoundaries(logger) {
    Test.assert(GlyphsDisplay.isScheduledSleep(23*3600, 23*3600, 7*3600));
    Test.assert(GlyphsDisplay.isScheduledSleep(0, 23*3600, 7*3600));
    Test.assert(!GlyphsDisplay.isScheduledSleep(7*3600, 23*3600, 7*3600));
    Test.assert(GlyphsDisplay.isScheduledSleep(14*3600, 13*3600, 15*3600));
    Test.assert(!GlyphsDisplay.isScheduledSleep(15*3600, 13*3600, 15*3600));
    Test.assert(!GlyphsDisplay.isScheduledSleep(0, null, null));
    Test.assert(!GlyphsDisplay.isScheduledSleep(0, 0, 0));
    return true;
}

(:test)
function ambientBandsDoNotOverlap(logger) {
    var height = System.getDeviceSettings().screenHeight;
    var textHeight = 3 * Graphics.getFontHeight(Graphics.FONT_XTINY);
    Test.assert(GlyphsDisplay.ambientCenterY(height, 1) - GlyphsDisplay.ambientCenterY(height, 0) > textHeight + 2);
    return true;
}

(:test)
function gridRetainsAllHourWords(logger) {
    var words = ["O N E", "T W O", "T H R E E", "F O U R", "F I V E", "S I X", "S E V E N", "E I G H T", "N I N E", "T E N", "E L E V E N", "T W E L V E"];
    var counts = [12, 13, 15];
    for (var c=0; c<counts.size(); c++) {
        var generator = new RowsGenerator(counts[c], 31);
        var data = generator.getRowsData();
        for (var w=0; w<words.size(); w++) {
            var found = false;
            for (var i=data[:hoursStartRowIndex]; i<=data[:hoursEndRowIndex]; i++) {
                if (data[:rows][i].find(words[w]) != null) { found = true; }
            }
            Test.assertMessage(found, "Missing hour " + words[w]);
        }
    }
    return true;
}
