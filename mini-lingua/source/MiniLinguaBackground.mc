import Toybox.Graphics;
import Toybox.WatchUi;

class MiniLinguaBackground extends WatchUi.Drawable {
    function initialize() {
        Drawable.initialize({ :identifier => "MiniLinguaBackground" });
    }

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
    }
}
