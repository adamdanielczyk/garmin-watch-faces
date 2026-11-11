import Toybox.Application;
import Toybox.WatchUi;

class MiniIndexApp extends Application.AppBase {
    private var view;
    function initialize() { AppBase.initialize(); }
    function getInitialView() {
        view = new MiniIndexView();
        return [view];
    }
    function onSettingsChanged() {
        if (view != null) { view.loadSettings(); }
        WatchUi.requestUpdate();
    }
}
