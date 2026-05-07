{
  delib,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "programs.zen-browser";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultBrowser = boolOption false;
    };

  home.always = {
    imports = [inputs.zen-browser.homeModules.default];
  };

  myconfig.ifEnabled = {cfg, ...}:
    with lib; {
      commands.default.browser = optionals cfg.defaultBrowser ["zen-beta"];
    };
  home.ifEnabled = {cfg, ...}: {
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = cfg.defaultBrowser;
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Preferences = {
        };
      };
      profiles.default = {
        isDefault = true;
        search = {
          force = true;
          default = "ddg";
        };
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;
          "browser.translations.automaticallyPopup" = false;

          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;

          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.compact.animate-sidebar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.urlbar.behavior" = "float";
        };

        mods = [
          "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
          "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        ];

        containersForce = true;
      };
    };
  };
}
