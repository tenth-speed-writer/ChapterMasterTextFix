function log_into_file(_message) {
    var _entry = string(_message);
    var _date_time = string(current_day) + "-" + string (current_month) + "-" + string(current_year) + "_" + string(current_hour) + string(current_minute) + string(current_second);
    var _log_file = file_text_open_write("ErrorLogs/" + $"error_log_{_date_time}.log");

    file_text_write_string(_log_file, _entry);
    file_text_close(_log_file);
}

function try_and_report_loop(dev_marker="generic crash",func, turn_end=true, args=[]){
    try{
        method_call(func,args);
    } catch (_exception){
        var _popup_header = $"Your game just encountered an error ({dev_marker}) :(";
        var _popup_message = $"Please, do the following: \n\n\n1) Find the following folder on your PC: C:>Users>(UserName)>AppData>Local>ChapterMaster>ErrorLogs \n\n2) Find the latest error_log file (last numbers are hours minutes seconds). \n\n3) Create a bug report on the bug-report-forum in our Chapter Master Discord server. \n\n3) Attach the error_log file to your bug report. \n\n\nThank you :)";

        if (turn_end || instance_exists(obj_turn_end) ){
            scr_popup(_popup_header, _popup_message, "debug");
        } else {
            pip = instance_create(0,0,obj_popup);
            pip.title = _popup_header;
            pip.text = _popup_message;
            pip.image = "debug"
        }

        var _formatted_stacktrace = "";
        // Loop through the array
        for (var i = 0; i < array_length(_exception.stacktrace); i++) {
            _formatted_stacktrace += _exception.stacktrace[i];
            // Add newline character
            if (i < array_length(_exception.stacktrace) - 1) {
                _formatted_stacktrace += "\n";
            }
        }

        var _full_message = $"{_exception.longMessage}\n\nIn script:\n{_exception.script}\n\nStacktrace:\n{_formatted_stacktrace}";
        log_into_file(_full_message);
        show_debug_message(_full_message);  
    }
}

