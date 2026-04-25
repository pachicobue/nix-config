{delib, ...}:
delib.module {
  name = "constants";

  options.constants = with delib; {
    userName = readOnly (strOption "sho");
    userFullName = readOnly (strOption "Sho Yasui");
    userHandleName = readOnly (strOption "pachicobue");
    userEmail = readOnly (strOption "mail@pachicobue.org");
    userPassHash = readOnly (strOption "$y$jFT$8ucjYlvf80e0wuuTIRCST.$w4/ZC0ZCsas0nq3vxghytE9cwLORY5ioE6hc1zz3Ph4");
    rootPassHash = readOnly (strOption "$y$jFT$RxsQil2C/9qnFX4LcUD9S1$.8fXwaf9oMzCVHV2v/NyaavHgk8h3oBk.HfsFRYWLH5");
    gpg = readOnly (strOption "E4E61C685DD58216CE33134FC743571182DA7DB9");
    sshKeys = readOnly (listOfOption str [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJGjzlH+kjBX98qiZOQ1raIQ2H6CJefEq3c8LO4uSuP sho@coconut"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIurSBgviLvpzHnZOMuu7UEbw9sktSuVahUySjW0dquy sho@plum"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9zd4/wJ4gleti/ciOfbI0wMi/lG7Rkgc9Q2jyjA7Cg iPhone XR"
    ]);
    network = readOnly (submoduleOption {
      options = {
        gateway = strOption "192.168.10.1";
        dns = strOption "192.168.10.181";
        pi4IfaceName = strOption "eth0";
      };
    } {});
  };
}
