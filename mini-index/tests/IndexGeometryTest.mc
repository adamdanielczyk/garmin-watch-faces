import Toybox.Test;
import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;

(:test)
function handPositions(logger) {
    Test.assertEqual(IndexGeometry.hourAngle(0, 0), 0.0);
    Test.assertEqual(IndexGeometry.hourAngle(12, 0), 0.0);
    Test.assert((IndexGeometry.hourAngle(3, 0) - Math.PI/2).abs() < 0.0001);
    Test.assert((IndexGeometry.hourAngle(3, 30) - Math.PI*7/12).abs() < 0.0001);
    Test.assert((IndexGeometry.minuteAngle(15) - Math.PI/2).abs() < 0.0001);
    Test.assert((IndexGeometry.minuteAngle(30) - Math.PI).abs() < 0.0001);
    return true;
}

(:test)
function ambientDialsAreSeparatedAndInsideScreen(logger) {
    var sizes = [260, 360, 390, 454];
    for (var i=0; i<sizes.size(); i++) {
        var size=sizes[i];
        var top=IndexGeometry.dial(size,size,true,0);
        var bottom=IndexGeometry.dial(size,size,true,1);
        Test.assert(top[:y] + top[:radius] + 2 < bottom[:y] - bottom[:radius] - 2);
        Test.assert(top[:y] - top[:radius] > 0);
        Test.assert(bottom[:y] + bottom[:radius] < size);
        // Entire small dial lies inside the round screen, including pen width.
        Test.assert((top[:y] - size/2).abs() + top[:radius] + 2 < size/2);
    }
    return true;
}

// Every screen resolution currently declared by the manifest, including the
// smallest rectangle and the clipped round Forerunner 735XT display.
(:test)
function fullDialFitsSupportedScreens(logger) {
    var sizes = [[148,205],[208,208],[215,180],[218,218],[240,240],[260,260],[280,280],
                 [320,360],[360,360],[390,390],[416,416],[448,486],[454,454],[466,466]];
    for (var i=0; i<sizes.size(); i++) {
        var width=sizes[i][0]; var height=sizes[i][1];
        var dial=IndexGeometry.dial(width,height,false,0);
        Test.assert(dial[:x]-dial[:radius]-2 > 0);
        Test.assert(dial[:x]+dial[:radius]+2 < width);
        Test.assert(dial[:y]-dial[:radius]-2 > 0);
        Test.assert(dial[:y]+dial[:radius]+2 < height);
    }
    // Native font metrics: the optional date must fit inside this device's dial.
    var device=System.getDeviceSettings();
    var nativeDial=IndexGeometry.dial(device.screenWidth,device.screenHeight,false,0);
    var halfHeight=Graphics.getFontHeight(Graphics.FONT_XTINY)/2.0;
    Test.assert(nativeDial[:radius]*0.57+halfHeight < nativeDial[:radius]);
    return true;
}

(:test)
function rectangularAmbientDialsAreSeparated(logger) {
    var sizes = [[240,240],[320,360],[448,486]];
    for (var i=0; i<sizes.size(); i++) {
        var width=sizes[i][0]; var height=sizes[i][1];
        var top=IndexGeometry.dial(width,height,true,0);
        var bottom=IndexGeometry.dial(width,height,true,1);
        Test.assert(top[:y]+top[:radius]+2 < bottom[:y]-bottom[:radius]-2);
        Test.assert(top[:x]-top[:radius]-2 > 0);
        Test.assert(top[:x]+top[:radius]+2 < width);
        Test.assert(top[:y]-top[:radius]-2 > 0);
        Test.assert(bottom[:y]+bottom[:radius]+2 < height);
    }
    return true;
}

(:test)
function cutoutDialAvoidsSubscreenAndBezel(logger) {
    // Width, height, sub-display left edge and bottom from Garmin simulator metadata.
    var screens = [[176,176,113,62],[163,156,108,54],[166,166,113,52]];
    for (var i=0; i<screens.size(); i++) {
        var screen=screens[i];
        var dial=IndexGeometry.cutoutDial(screen[0],screen[1]);
        var dx=screen[2]-dial[:x];
        var dy=dial[:y]-screen[3];
        // Exclude the entire upper-right rectangle, not just the circular hole.
        Test.assert(Math.sqrt(dx*dx+dy*dy) > dial[:radius]+5);
        Test.assert(dial[:x]-dial[:radius]-2 > screen[0]*0.1);
        Test.assert(dial[:y]+dial[:radius]+2 < screen[1]*0.9);
    }
    return true;
}
