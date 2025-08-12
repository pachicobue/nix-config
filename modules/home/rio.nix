{...}: {
  programs.rio = {
    enable = true;
    settings = {
      confirm-before-quit = false;

      padding-x = 10;
      padding-y = [5 5];
    };
  };
}
