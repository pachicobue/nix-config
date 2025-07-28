{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.search.region" = "JP";
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.quickactions" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.translations.mostRecentTargetLanguages" = "ja";
        "browser.tabs.closeWindowWithLastTab" = false;
        "sidebar.verticalTabs" = true;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
      };
      extensions = {
        force = true;
      };
    };
    package = pkgs.firefox-beta;
    languagePacks = [ "ja" ];
  };
  catppuccin.firefox.profiles = {
    default = {
      enable = true;
      force = true;
    };
  };
}
