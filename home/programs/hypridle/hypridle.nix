{ pkgs, config, lib, ... }:

let
  homeConfig = import ../../home-config.nix;
  timeouts = homeConfig.timeouts;
in
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
          timeout = timeouts.dim;
          on-timeout = "hypridle-save-and-dim";
          on-resume = "hypridle-restore-brightness";
        }
        {
          # Lock the screen after configured timeout
          timeout = timeouts.lock;
          on-timeout = "hyprlock";
          on-resume = "hypridle-restore-brightness";
        }
        {
          # Turn off the screen after configured timeout
          timeout = timeouts.screenOff;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && hypridle-restore-brightness";
        }
        {
          # Suspend the system after configured timeout
          timeout = timeouts.suspend;
          on-timeout = "systemctl suspend";
          on-resume = "hypridle-restore-brightness";
        }
      ];
    };
  };
}
