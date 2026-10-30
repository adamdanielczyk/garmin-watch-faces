import Toybox.Application.Properties;

class Settings {
    private var settings;

    function initialize() {
        settings = {
            "UseCustomColors" => Properties.getValue("UseCustomColors"),
            "PresetColor" => Properties.getValue("PresetColor"),
            "RedHourColor" => Properties.getValue("RedHourColor"),
            "GreenHourColor" => Properties.getValue("GreenHourColor"),
            "BlueHourColor" => Properties.getValue("BlueHourColor"),
            "RedMinutesColor" => Properties.getValue("RedMinutesColor"),
            "GreenMinutesColor" => Properties.getValue("GreenMinutesColor"),
            "BlueMinutesColor" => Properties.getValue("BlueMinutesColor"),
            "SelectedFontSize" => Properties.getValue("SelectedFontSize"),
            "IsFontSizeCalculated" => Properties.getValue("IsFontSizeCalculated"),
        };
    }

    function get(key) {
        return settings[key];
    }

    function set(key, value) {
        settings[key] = value;
        Properties.setValue(key, value);
    }
}
