{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.firefox";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      setAsDefaultBrowser = boolOption false;
    };
  myconfig.ifEnabled = {cfg, ...}: {
    commands.default.browser = lib.optional cfg.setAsDefaultBrowser ["firefox-beta"];
  };
  home.ifEnabled = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
        search = {
          force = true;
          default = "DuckDuckGo";
        };
      };
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
      package = pkgs.firefox-beta;
      languagePacks = ["ja"];
    };
  };
}
