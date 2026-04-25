{
  delib,
  host,
  ...
}:
delib.module {
  name = "assertions";
  home.always = {
    assertions = [
      {
        assertion = !(host.waylandFeatured && host.x11Featured);
        message = "Enabling both 'wayland' 'X11' features is not allowed.";
      }
    ];
  };
}
