# Dell XPS

## Ubuntu 18.04 installation

<p align="center">
    <br>
    <img src="https://raw.githubusercontent.com/sergiovhe/automation/master/dell-xps/img/xps-notebook.png" alt="Dell XPS" width="500">
    <br>
</p>

### Windows configuration

1. Disable BitLocker from the drive before creating a partition

2. Disable Fast Startup in Windows if you created a data partition to be shared between the two systems

    Go to Control Panel > Hardware and Sound > Power Options > System Setting > Choose what the power buttons do and uncheck the Turn on fast startup box

### Machine configuration

1. BIOS Settings

    Settings > System Configuration > Thunderbolt Adapter Configuration: Enable Thunderbolt Adapter Boot Support  
    Settings > Secure Boot Enabled: Disabled

2. Install Ubuntu 18.04 with third-party software

3. Select the appropriate Installation Type

    Choose **Something else** option to manually create your own partitions, basically you must create a partition for the system and a swap area inside the free space previously created from Windows.

    Check the device for boot loader installation is your physical volume, usually ```/dev/sda```

3. Before login switch to a tty session by pressing Ctrl+Alt+F4 (tty4)

    Fix graphics and power management by changing the GRUB configuration:
    
    ```shell
    sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="nouveau.modeset=0 acpi_rev_override=1"/g' /etc/default/grub
    sudo update-grub
    ```

    *Nouveau: Accelerated Open Source driver for NVIDIA cards  
    *ACPI (Advanced Configuration and Power Interface): a standard for handling power management


    Set Windows as the default startup option:
    ```shell
    sudo sed -i -e 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub
    sudo grub-set-default 2
    sudo update-grub
    ```
 
    Different times when dual booting:

    ```shell
    # Make Linux Use Local Time:
    timedatectl set-local-rtc 1 --adjust-system-clock

    # Make Windows Use UTC Time:  
    [HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation]
    "RealTimeIsUniversal"=dword:00000001
    ```

    #### Configuration script

    To configure this settings automatically, you can use the configuration script using cURL:

    ```shell
    sudo curl -o- https://raw.githubusercontent.com/sergiovhe/automation/master/dell-xps/ubuntu-18.04-config.sh | bash
    ```
    or Wget:
    ```shell
    sudo wget -qO- https://raw.githubusercontent.com/sergiovhe/automation/master/dell-xps/ubuntu-18.04-config.sh | bash
    ```

### Setup software

To perform an initial setup and install common software, you can use the setup script using cURL:

```shell
sudo curl -o- https://raw.githubusercontent.com/sergiovhe/automation/master/dell-xps/ubuntu-18.04-setup.sh | bash
```
or Wget:
```shell
sudo wget -qO- https://raw.githubusercontent.com/sergiovhe/automation/master/dell-xps/ubuntu-18.04-setup.sh | bash
```

*Setup script contains some configuration and common software, feel free to update it locally to obtain a customized installation.