use Purple;
%PLUGIN_INFO = (
    perl_api_version => 2,
    name => "Delcom-Stoplight-Plugin",
    version => "0.1",
    summary => "Indicate your status on the Delcom USB HID stoplight.",
    description => "Monitor your status and then call an excutable to change the status of the Delcom USB HID Stoplight device.",
    author => "logan@rosetrace.com",
    url => "http://blog.endurancetrails.com",
    load => "plugin_load",
    unload => "plugin_unload",
    prefs_info => "prefs_info_cb"
);

sub timeout_cb {
    my $plugin = shift;

    my $stoplightProgram = Purple::Prefs::get_string("/plugins/core/$PLUGIN_INFO{name}/program");

    #get the status
    my $saved_status = Purple::SavedStatus::get_current();
    my $statusType = $saved_status->get_type();
    my $statusTitle = $saved_status->get_title();
    Purple::Debug::info("$PLUGIN_INFO{name}","Status type = ". $statusType . "\n");
    Purple::Debug::info("$PLUGIN_INFO{name}","Status title = ". $statusTitle . "\n");
    
    #call the stoplight program
        if ($statusType == 1){
        # offline
            system("$stoplightProgram", "off");
        }
        if ($statusType == 3){
        # busy 
            system("$stoplightProgram", "red");
        }
        if ($statusType == 5){
        # away
            system("$stoplightProgram", "yellow");
        }
        if ($statusType == 2){
        # available
            system("$stoplightProgram", "green");
        }


    #read the timeout
    my $timeout = 0+Purple::Prefs::get_string("/plugins/core/$PLUGIN_INFO{name}/timeout");

    #give some timeout if not otherwise specified
    if($timeout eq 0) {
        Purple::Debug::info("$PLUGIN_INFO{name}", "Could not parse timeout field. Using 120 seconds default.\n");
        $timeout = 120
    }

    # reschedule the timer
    Purple::Debug::info("$PLUGIN_INFO{name}", "Rescheduling timer.\n");
    Purple::timeout_add($plugin, $timeout, \&timeout_cb, $plugin);
    Purple::Debug::info("$PLUGIN_INFO{name}", "New timer set for " . $timeout . " seconds.\n");
}

sub prefs_info_cb {

    # The first step is to initialize the Purple::Pref::Frame 
    $frame = Purple::PluginPref::Frame->new();

    # Adding the timeout box
    $tpref = Purple::PluginPref->new_with_name_and_label("/plugins/core/$PLUGIN_INFO{name}/timeout", "Timeout between updates");
    $tpref->set_type(2);
    $tpref->set_max_length(3);
    $frame->add($tpref);

    # Adding the program box
    $ppref = Purple::PluginPref->new_with_name_and_label("/plugins/core/$PLUGIN_INFO{name}/program", "Delcom Stoplight Control Program");
    $ppref->set_type(2);
    $ppref->set_max_length(127);
    $frame->add($ppref);

    # return the built frame
    return $frame;

}


sub plugin_init {
    return %PLUGIN_INFO;
}

sub plugin_load {
    my $plugin = shift;
    Purple::Debug::info("$PLUGIN_INFO{name}", "plugin_load() - $PLUGIN_INFO{name} Loaded.\n");

    # set the preferences
    Purple::Prefs::add_none("/plugins/core/$PLUGIN_INFO{name}");
    Purple::Prefs::add_string("/plugins/core/$PLUGIN_INFO{name}/timeout", "120");
    Purple::Prefs::add_string("/plugins/core/$PLUGIN_INFO{name}/program", "/usr/bin/delcom-stoplight");

    # schedule a timeout to update the status
    Purple::timeout_add($plugin, 10, \&timeout_cb, $plugin);
}

sub plugin_unload {
    my $plugin = shift;

    my $stoplightProgram = Purple::Prefs::get_string("/plugins/core/$PLUGIN_INFO{name}/program");
    system("$stoplightProgram", "off");
    Purple::Debug::info("$PLUGIN_INFO{name}", "plugin_unload() - $PLUGIN_INFO{name} Unloaded.\n");


}
