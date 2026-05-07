{
  delib,
  config,
  moduleSystem,
  homeManagerUser,
  ...
}:
delib.module {
  name = "home-manager";
  myconfig.always = {
    args.shared.homeconfig =
      if moduleSystem == "home"
      then config
      else config.home-manager.users.${homeManagerUser};
  };
}
