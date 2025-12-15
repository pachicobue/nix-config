{
  commonConfig,
  hostConfig,
  ...
}: {
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    mutableSettings = true;
    settings = {
      users = [
        {
          name = "sho";
          password = "$2a$10$YdgXJ5l3MX7ayFPxdp5KVu1IR5FSyT9FqBC1SLGTM0DKpdlDXrS4q";
        }
      ];

      dns = {
        bind_hosts = ["0.0.0.0"];
        upstream_dns = ["tls://1.1.1.1"];
        enable_dnssec = true;
        edns_client_subnet = {
          enabled = false;
        };
      };

      dhcp = {
        enabled = true;
        interface_name = hostConfig.network.iface.name;

        dhcpv4 = {
          gateway_ip = commonConfig.network.gateway;
          subnet_mask = "255.255.255.0";
          range_start = "192.168.10.200";
          range_end = "192.168.10.255";
          lease_duration = 86400;
        };
      };

      user_rules = [
        "@@||statsig.anthropic.com^$important"
      ];

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt";
          name = "Tohu";
          id = 2;
        }
      ];
    };
  };
}
