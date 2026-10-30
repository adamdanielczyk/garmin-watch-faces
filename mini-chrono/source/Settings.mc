import Toybox.Application.Properties;

class Settings {
    private var settings;

    function initialize() {
        settings = {
            "PropertiesVersion" => Properties.getValue("PropertiesVersion"),
            "UseCustomColors" => Properties.getValue("UseCustomColors"),
            "PresetColor" => Properties.getValue("PresetColor"),
            "RedHourColor" => Properties.getValue("RedHourColor"),
            "GreenHourColor" => Properties.getValue("GreenHourColor"),
            "BlueHourColor" => Properties.getValue("BlueHourColor"),
            "RedMinutesColor" => Properties.getValue("RedMinutesColor"),
            "GreenMinutesColor" => Properties.getValue("GreenMinutesColor"),
            "BlueMinutesColor" => Properties.getValue("BlueMinutesColor"),
            "UseVerticalLayout" => Properties.getValue("UseVerticalLayout"),
            "HideHourLeadingZero" => Properties.getValue("HideHourLeadingZero"),
            "SelectedFont" => Properties.getValue("SelectedFont"),
            "SelectedFontSize" => Properties.getValue("SelectedFontSize"),
            "IsFontSizeCalculatedForVerticalLayout" => Properties.getValue("IsFontSizeCalculatedForVerticalLayout"),
            "IsFontSizeCalculatedForHorizontalLayout" => Properties.getValue("IsFontSizeCalculatedForHorizontalLayout"),
            "ShowBattery" => Properties.getValue("ShowBattery"),
        };

        resetPropertiesIfNeeded();
    }

    private function resetPropertiesIfNeeded() {
        var currentVersion = 2;
        var savedVersion = get("PropertiesVersion");

        if (savedVersion < currentVersion) {
            set("PropertiesVersion", currentVersion);

            set("SelectedFont", 3);
            set("SelectedFontSize", 4);
            set("IsFontSizeCalculatedForVerticalLayout", false);
            set("IsFontSizeCalculatedForHorizontalLayout", false);
        }
    }

    function get(key) {
        return settings[key];
    }

    function set(key, value) {
        settings[key] = value;
        Properties.setValue(key, value);
    }
}
