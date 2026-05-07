{delib, ...}:
delib.module {
  name = "constants";
  options = with delib;
    moduleOptions {
      userName = readOnly (strOption "sho");
      userFullName = readOnly (strOption "Sho Yasui");
      userHandleName = readOnly (strOption "pachicobue");
      userEmail = readOnly (strOption "mail@pachicobue.org");
      userPassHash = readOnly (strOption "$y$jFT$8ucjYlvf80e0wuuTIRCST.$w4/ZC0ZCsas0nq3vxghytE9cwLORY5ioE6hc1zz3Ph4");
      rootPassHash = readOnly (strOption "$y$jFT$RxsQil2C/9qnFX4LcUD9S1$.8fXwaf9oMzCVHV2v/NyaavHgk8h3oBk.HfsFRYWLH5");
      gpg = readOnly (strOption "E4E61C685DD58216CE33134FC743571182DA7DB9");
    };
}
