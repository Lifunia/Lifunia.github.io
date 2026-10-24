import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Timer;
import Toybox.WatchUi;

// Separate application ID and sample data keep the user's app storage untouched.
class DeviceScreensApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() { return [new DeviceScreensView()]; }
}

class DeviceScreensView extends WatchUi.View {
    var names as Array<String> = ["TOP", "Run", "Result_set", "Result_all", "Result", "Timermenu", "AUFmode", "menu", "menu2", "PresetTimer", "EditTimer", "Setting", "History", "history1", "HistoryScore", "HistorySetDetail", "HistoryNoDetails", "Exitmenu"];
    var index = 0;
    var logged = -1;
    var ticker;
    var session as Sauna_View.SaunaView or Null = null;
    var hr as Sauna_HeartRateView.HeartRateView or Null = null;
    var results as Array<SaunaSetResult> = [];
    var history as Sauna_HistoryView.HistoryView or Null = null;
    var detail;
    var result;
    var legacy;
    function initialize() { View.initialize(); }
    function onShow() {
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
            Sauna_LogStore.addLogWithDetails({:startEpoch => 1792458000 + day * 86400,
                :totalSets => 3, :avgScore => 260.0 / 3, :setScores => scores,
                :saunaAvgHr => 124, :wbathAvgHr => 88, :restAvgHr => 74}, results);
        }
        history = new Sauna_HistoryView.HistoryView();
        history.onShow();
        detail = new Sauna_HistoryView.HistoryDetailView(history.logs[0]);
        result = new Sauna_ResultView.ResultView(87, results);
        legacy = new Sauna_HistoryView.HistoryDetailView(new SaunaHistoryEntry({"id" => 99,
            "startEpoch" => 1792630800, "avgScore" => 87, "totalSets" => 3, "setScores" => scores}));
        legacy.page = 1;
        legacy.handleKey(WatchUi.KEY_ENTER);
        hr = new Sauna_HeartRateView.HeartRateView();
        hr.stopTimersForExit();
        session = new Sauna_View.SaunaView(hr);
        hr.setParentView(session);
        session.currentHR = 124;
        session.currentTime = "18:30";
        session.remainingTime = 420;
        ticker = new Timer.Timer();
        ticker.start(method(:advance), 2400, true);
    }
    function advance() as Void {
        index++;
        if (index >= names.size()) { ticker.stop(); System.println("CAPTURE_DONE"); System.exit(); }
        else { WatchUi.requestUpdate(); }
    }
    function onUpdate(dc) {
        session.isAufgussMode = false;
        session.totonoiOverlayVisible = false;
        if (index == 0 || index == 1 || index == 6) {
            session.remainingTime = 420;
            if (index == 1) { session.remainingTime = 286; }
            if (index == 6) { session.isAufgussMode = true; session.phaseElapsedSeconds = 630; }
            session.onUpdate(dc);
        } else if (index == 2) {
            session.totonoiOverlayVisible = true;
            session.totonoiOverlayData = results[0];
            session.totonoiOverlayEndTime = 0;
            session.onUpdate(dc);
        } else if (index == 3 || index == 4 || index == 15) {
            result.historySetNumber = null;
            result.page = 0;
            if (index == 4) { result.page = 1; }
            if (index == 15) { result.showSingleHistorySet(1); }
            result.onUpdate(dc);
        } else if (index == 5) {
            var timerMenu = new Sauna_Timer_MenuView.TimerMenuView(session);
            timerMenu.onUpdate(dc);
        } else if (index == 7 || index == 8) {
            var menu = new Sauna_MenuView.MenuView(session);
            if (index == 8) { menu.selection = 3; }
            menu.onUpdate(dc);
        } else if (index == 9) {
            var preset = new Sauna_PresetTimerView.PresetTimerView(session);
            preset.selection = 1;
            preset.onUpdate(dc);
        } else if (index == 10) {
            var edit = new Sauna_TimerEditView.TimerEditView(session);
            edit.onUpdate(dc);
        } else if (index == 11) {
            var settings = new Sauna_SettingView.SettingView(session);
            settings.onUpdate(dc);
        } else if (index == 12) { history.onUpdate(dc);
        } else if (index == 13 || index == 14) { detail.page = index - 13; detail.onUpdate(dc);
        } else if (index == 16) {
            // Reapply the transient notice immediately before rendering.
            legacy.handleKey(WatchUi.KEY_ENTER);
            legacy.onUpdate(dc);
        } else {
            var exit = new Sauna_EndConfirmationView.EndConfirmationView(hr, session);
            exit.totValue = 87;
            exit.onUpdate(dc);
        }
        if (logged != index) { logged = index; System.println("CAPTURE_READY " + names[index]); }
    }
}
