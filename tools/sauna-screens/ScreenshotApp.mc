import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Timer;
import Toybox.WatchUi;

// Screenshot-only entry point with a separate app ID. Product drawing code is unchanged.
class ScreenshotApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() { return [new ScreenshotView()]; }
}

class ScreenshotView extends WatchUi.View {
    var names = ["History", "history1", "HistoryScore", "HistorySetDetail", "HistoryNoDetails"];
    var index = 0;
    var ticker;
    var results;
    var history;
    var detail;
    var legacyDetail;
    var result;
    var loggedIndex = -1;

    function initialize() { View.initialize(); }
    function onShow() {
        // Seed only this fixture's storage. FIT recording is always disabled.
        Application.Storage.setValue("settingFitSave", 0);
        Application.Storage.setValue(Sauna_LogStore.STORAGE_KEY, Sauna_LogStore.makeDefaultStore());
        results = [];
        var scores = [82, 87, 91];
        for (var i = 0; i < 3; i++) {
            var value = new SaunaSetResult(i + 1, [135 + i * 3, 100 + i * 2, 85 + i], [110 + i, 75 + i, 62 + i]);
            value.score = scores[i];
            results.add(value);
        }
        for (var day = 0; day < 3; day++) {
            var entry = {:startEpoch => Time.now().value() - (2 - day) * 86400,
                :totalSets => 3, :avgScore => 260.0 / 3, :setScores => scores,
                :saunaAvgHr => 124, :wbathAvgHr => 88, :restAvgHr => 74};
            Sauna_LogStore.addLogWithDetails(entry, results);
        }
        history = new Sauna_HistoryView.HistoryView();
        history.onShow();
        detail = new Sauna_HistoryView.HistoryDetailView(history.logs[0]);
        var selected = Sauna_LogStore.getSetDetail(history.logs[0], 0);
        result = new Sauna_ResultView.ResultView(null, [selected]);
        result.showSingleHistorySet(1);
        // Use a summary-only entry to exercise the real missing-details path.
        var legacy = new SaunaHistoryEntry({"id" => 99, "startEpoch" => Time.now().value(),
            "avgScore" => 87, "totalSets" => 3, "setScores" => scores});
        legacyDetail = new Sauna_HistoryView.HistoryDetailView(legacy);
        legacyDetail.page = 1;
        legacyDetail.handleKey(WatchUi.KEY_ENTER);
        ticker = new Timer.Timer();
        ticker.start(method(:advance), 3000, true);
    }

    function advance() as Void {
        index++;
        if (index >= names.size()) {
            ticker.stop();
            System.println("CAPTURE_DONE");
            System.exit();
        } else {
            WatchUi.requestUpdate();
        }
    }

    function onUpdate(dc) {
        if (index == 0) {
            history.onUpdate(dc);
        } else if (index == 1 || index == 2) {
            detail.page = index - 1;
            detail.onUpdate(dc);
        } else if (index == 3) {
            result.onUpdate(dc);
        } else if (index == 4) {
            legacyDetail.onUpdate(dc);
        }
        if (loggedIndex != index) {
            loggedIndex = index;
            System.println("CAPTURE_READY " + names[index]);
        }
    }
}
