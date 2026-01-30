{ pkgs, config, lib, ... }:

{
  services.hypridle = {

    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          # Save current brightness, dim and warn that the screen will be locked in 1 minute
          timeout = 240;
          on-timeout = "hypridle-save-and-dim";
          on-resume = "hypridle-restore-brightness";
        }
        {
          # Lock the screen after 5 minutes of inactivity
          timeout = 300;
          on-timeout = "hyprlock";
          on-resume = "hypridle-restore-brightness";
        }
        {
          # turn off the screen after 7 minutes of inactivity
          timeout = 420;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && hypridle-restore-brightness";
        }
        {
          # suspend the system after 1 hour of inactivity
          timeout = 3600;
          on-timeout = "systemctl suspend";
          on-resume = "hypridle-restore-brightness";
        }
      ];
    };




  };
}
