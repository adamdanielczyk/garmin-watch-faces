import Toybox.Test;

(:test)
function reviewWaitsForTwoWeeksAndFourteenActiveDays(logger) {
    var start = 100 * 86400;
    var schedule = new ReviewSchedule(null, start);
    schedule.observe(start);
    Test.assert(!schedule.isDue(start));
    // Leaving the face unused for two weeks is insufficient.
    schedule.observe(start + 14 * 86400);
    Test.assert(!schedule.isDue(start + 14 * 86400));
    for (var day = 15; day <= 26; day++) {
        schedule.observe(start + day * 86400);
    }
    Test.assert(schedule.isDue(start + 26 * 86400));
    return true;
}

(:test)
function reviewDoesNotCountWristRaisesAsDays(logger) {
    var schedule = new ReviewSchedule(null, 100 * 86400);
    for (var i = 0; i < 100; i++) { schedule.observe(100 * 86400 + i); }
    Test.assertEqual(schedule.state["days"], 1);
    Test.assert(!schedule.isDue(100 * 86400 + 100));
    return true;
}

(:test)
function reviewWaitsFullInitialInterval(logger) {
    var start = 100 * 86400;
    var schedule = new ReviewSchedule(null, start);
    for (var day = 0; day < 14; day++) { schedule.observe(start + day * 86400); }
    Test.assert(!schedule.isDue(start + 14 * 86400 - 1));
    Test.assert(schedule.isDue(start + 14 * 86400));
    return true;
}

(:test)
function reviewFailuresAreThrottledAcrossRestarts(logger) {
    var start = 100 * 86400;
    var schedule = new ReviewSchedule(null, start);
    for (var day = 0; day <= 14; day++) { schedule.observe(start + day * 86400); }
    var now = start + 14 * 86400;
    schedule.attempted(now);
    var restored = new ReviewSchedule(schedule.state, now);
    Test.assert(!restored.isDue(now));
    Test.assert(!restored.isDue(now + 86400 - 1));
    Test.assert(restored.isDue(now + 86400));
    Test.assertEqual(restored.state["shown"], 0);
    return true;
}

(:test)
function reviewRemindersBackOffAndSurviveRestarts(logger) {
    var start = 100 * 86400;
    var schedule = new ReviewSchedule(null, start);
    for (var day = 0; day <= 14; day++) { schedule.observe(start + day * 86400); }
    var now = start + 14 * 86400;
    var intervals = [28, 56, 84, 84];
    for (var i = 0; i < intervals.size(); i++) {
        schedule.attempted(now);
        schedule.shown(now);
        var next = now + intervals[i] * 86400;
        schedule = new ReviewSchedule(schedule.state, now);
        Test.assert(!schedule.isDue(next - 1));
        Test.assert(schedule.isDue(next));
        now = next;
    }
    Test.assertEqual(schedule.state["shown"], 2);
    Test.assertEqual(schedule.state["days"], 14);
    return true;
}

(:test)
function reviewClockRollbackDoesNotAddUseOrPromptEarly(logger) {
    var now = 100 * 86400;
    var schedule = new ReviewSchedule(null, now);
    schedule.observe(now);
    Test.assert(!schedule.observe(now - 86400));
    Test.assertEqual(schedule.state["days"], 1);
    Test.assert(!schedule.isDue(now - 86400));
    return true;
}
