# motd (Message of the Day)
Ubuntu’s Message Of The Day or MOTD is the name given to the welcome screen users see when they login to a Ubuntu server using a remote terminal.

### Install UpdateMotd  
```sh
sudo apt-get install update-motd
```

The filenames are named in NN-description where NN is the ascending start order with 00-header being the first script to be run.

```sh
ll /etc/update-motd.d/
```

### Add new MOTD scripts

Adding new scripts to the MOTD is a simple process. Let’s start with a hello world example. First we will create a script with the name 30-hello-world. It will start after the 00-header and 10-help-text.

```sh
cd /etc/update-motd.d/
sudo vim 30-hello-world
```

### Disable MOTD scripts
Turning off one or more scripts is simple as removing the execute permissions bit from the target. Here we will turn off the script that posts the Documentation link.

```sh
cd /etc/update-motd.d/
sudo chmod -x 10-help-text
```

### Test MOTD scripts

Use the run-parts command to see your changes.

```sh
run-parts /etc/update-motd.d
```