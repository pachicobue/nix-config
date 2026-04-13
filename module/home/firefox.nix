{ delib, pkgs, lib, ... }:
delib.module {
  name = "firefox";
  options.firefox.enable = delib.boolOption false;
  home.ifEnabled = let
    settings = {
      "accessibility.browsewithcaret" = true;
      "browser.bookmarks.showMobileBookmarks" = false;
      "browser.search.region" = "JP";
      "browser.suggest.enabled" = false;
      "browser.tabs.closeWindowWithLastTab" = false;
      "browser.tabs.closeTabByDblclick" = true;
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.translations.automaticallyPopup" = false;
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "browser.urlbar.suggest.bookmark" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.openpage" = false;
      "browser.urlbar.suggest.quickactions" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.topsites" = false;
      "intl.locale.requested" = "ja,en-US";
      "dom.security.https_only_mode" = true;
      "sidebar.verticalTabs" = true;
    };
    enableSync = s:
      lib.attrsets.mapAttrs' (name: value: lib.attrsets.nameValuePair ("services.sync.prefs.sync." + name) value) s;
  in {
    programs.firefox = {
      enable = true;
      policies = {
        AppAutoUpdate = false;
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        DisableFeedbackCommands = true;
        DisablePocket = true;
        DontCheckDefaultBrowser = true;
        SearchEngines = {
          Default = "DuckDuckGo";
          Remove = [
            "Google"
            "Bing"
            "Wikipedia (ja)"
            "Yahoo! JAPAN"
            "Yahoo!オークション"
            "楽天市場"
          ];
          Add = [ ];
        };
        PasswordManagerEnabled = false;
        GoToIntranetSiteForSingleWordEntryInAddressBar = false;
        OfferToSaveLogins = false;
      };
      profiles.default = {
        isDefault = true;
        settings =
          settings
          // (enableSync settings)
          // { "services.sync.prefs.dangerously_allow_arbitrary" = true; };
      };
      package = pkgs.firefox-beta;
      languagePacks = [ "ja" ];
    };
  };
}
