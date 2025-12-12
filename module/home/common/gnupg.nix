{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      with-fingerprint = true;
      with-keygrip = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
      throw-keyids = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 86400;
    pinentry = {
      package = pkgs.pinentry-all;
    };
  };
}
