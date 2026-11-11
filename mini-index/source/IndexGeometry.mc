import Toybox.Math;

module IndexGeometry {
    function hourAngle(hour, minute) { return ((hour % 12) + minute / 60.0) * Math.PI / 6; }
    function minuteAngle(minute) { return minute * Math.PI / 30; }
    function dial(width, height, ambient, minute) {
        var size = width < height ? width : height;
        if (!ambient && hasCutout()) { return cutoutDial(width, height); }
        return {
            :x => width / 2,
            :y => ambient ? height * (minute % 2 == 0 ? 0.27 : 0.73) : height / 2,
            :radius => size * (ambient ? 0.19 : 0.40),
        };
    }
    // Leave the upper-right sub-display and its bezel clear on Instinct models.
    function cutoutDial(width, height) {
        var size = width < height ? width : height;
        return { :x => width * 0.42, :y => height * 0.58, :radius => size * 0.27 };
    }
    (:cutout)
    function hasCutout() { return true; }
    (:fullScreen)
    function hasCutout() { return false; }
    (:mono)
    function isMonochrome() { return true; }
    (:color)
    function isMonochrome() { return false; }
    (:amoled)
    function isAmoled() { return true; }
    (:mip)
    function isAmoled() { return false; }
}
