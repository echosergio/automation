# Dell XPS

## Ubuntu 18.04 installation

Setup steps:

1. BIOS Settings

    Settings > System Configuration > Thunderbolt Adapter Configuration: Enable Thunderbolt Adapter Boot Support
    Settings > Secure Boot Enabled: Disabled

2. Install Ubuntu 18.04 with third-party software

3. Before login switch to a tty session by pressing Ctrl+Alt+F4 (tty4)

    - Fix graphics and power management by changing the GRUB configuration:
    
    ```shell
    sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="nouveau.modeset=0 acpi_rev_override=1"/g' /etc/default/grub
    sudo update-grub
    ```

    - Set Windows as the default startup option:
    ```shell
    sudo sed -i -e 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub
    sudo grub-set-default 2
    sudo update-grub
    ```
 
    - Different times when dual booting:

    ```shell
    # Make Linux Use Local Time:
    timedatectl set-local-rtc 1 --adjust-system-clock

    # Make Windows Use UTC Time:  
    [HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation]
    "RealTimeIsUniversal"=dword:00000001
    ```
   