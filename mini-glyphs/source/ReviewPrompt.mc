import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

// Each face is exported independently; keep this file identical in all four apps.
class ReviewSchedule {
    const DAY = 86400;
    var state;

    function initialize(saved, now) {
        state = saved;
        if (!(state instanceof Lang.Dictionary)) {
            state = {"firstSeen" => now, "lastDay" => -1, "days" => 0,
                     "nextAt" => now + 14 * DAY, "shown" => 0, "attemptAt" => 0};
        }
    }

    function observe(now) {
        var day = (now / DAY).toNumber();
        if (day <= state["lastDay"]) { return false; }
        state["lastDay"] = day;
        if (state["days"] < 14) { state["days"] += 1; }
        return true;
    }

    function isDue(now) {
        return state["days"] >= 14 && now >= state["nextAt"] &&
               now >= state["attemptAt"];
    }

    // Denials, failures and callbacks arriving after sleep retry no sooner than tomorrow.
    function attempted(now) { state["attemptAt"] = now + DAY; }

    function shown(now) {
        var count = state["shown"];
        var weeks = count == 0 ? 4 : (count == 1 ? 8 : 12);
        state["shown"] = count < 2 ? count + 1 : 2;
        state["nextAt"] = now + weeks * 7 * DAY;
    }
}

class ReviewPrompt {
    const STORAGE_KEY = "reviewScheduleV1";
    private var schedule;
    private var active = false;
    private var pending = false;

    function initialize() {}

    function resume() {
        active = true;
        if (!(WatchUi has :makeReviewTokenRequest) || !(WatchUi has :startUserReview)) {
            return;
        }
        var now = Time.now().value();
        if (schedule == null) {
            schedule = new ReviewSchedule(Application.Storage.getValue(STORAGE_KEY), now);
        }
        if (schedule.observe(now)) { save(); }
        if (pending || !schedule.isDue(now) || !isConvenient()) { return; }
        schedule.attempted(now);
        save();
        pending = true;
        try {
            WatchUi.makeReviewTokenRequest(method(:onReviewResponse));
        } catch (error instanceof Lang.Exception) {
            // Review requests must never prevent the clock from working.
            pending = false;
        }
    }

    function pause() { active = false; }

    private function isConvenient() {
        var hour = System.getClockTime().hour;
        var device = System.getDeviceSettings();
        return hour >= 9 && hour < 20 &&
               (!(device has :doNotDisturb) || !device.doNotDisturb) &&
               device.phoneConnected;
    }

    private function save() {
        Application.Storage.setValue(STORAGE_KEY, schedule.state);
    }

    function onReviewResponse(status as WatchUi.ReviewRequestStatus, token as WatchUi.ReviewResponseToken or Null) as Void {
        pending = false;
        if (status != WatchUi.REVIEW_REQUEST_STATUS_GRANTED || token == null ||
            !active || !isConvenient()) { return; }
        // Persist before opening Garmin's UI, which may hide or stop this face.
        schedule.shown(Time.now().value());
        save();
        try {
            WatchUi.startUserReview(token);
        } catch (error instanceof Lang.Exception) {
            // Keep the cooldown even if firmware cannot open the review UI.
        }
    }
}
