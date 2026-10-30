import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class MiniChrono extends Application.AppBase {

    private var view;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [ WatchUi.Views ] or [ WatchUi.Views, WatchUi.InputDelegates ] {
        view = new MiniChronoView();
        return [ view ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        view.onSettingsChanged();
        WatchUi.requestUpdate();
    }

}