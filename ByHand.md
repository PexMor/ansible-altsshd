# Starting second SSH daemon

In this how-to I am assuming that you already have openssh daemon running. Tested on Ubuntu 18.04.

## The first sshd

By following command you can list details about running daemon.

```bash
systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
   Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
   Active: active (running) since Čt 2019-03-07 10:14:07 CET; 1 weeks 5 days ago
 Main PID: 9100 (sshd)
    Tasks: 1
   Memory: 7.4M
      CPU: 1.737s
   CGroup: /system.slice/ssh.service
           └─9100 /usr/sbin/sshd -D
```

From there you get the path of the __systemd__ service unit. In this case and by default on many systems it is ```/lib/systemd/system/ssh.service```.

Let us copy that to new file for further modification:

```bash
cp /lib/systemd/system/ssh.service /etc/systemd/system/ssh2.service
```

Then modify it as follows:

- change the unit description (add #2)
- change the __not__ run file flag (add 2 as infix into filename)
- change the environment to load (add 2 to the file name)
- change the alias as the __ssh__ and __sshd__ duality also applies here

```diff
diff -u /lib/systemd/system/ssh.service /etc/systemd/system/ssh2.service
--- /lib/systemd/system/ssh.service	2018-08-21 19:45:26.000000000 +0200
+++ /etc/systemd/system/ssh2.service	2019-03-19 16:05:29.762439820 +0100
@@ -1,10 +1,10 @@
 [Unit]
-Description=OpenBSD Secure Shell server
+Description=OpenBSD Secure Shell server #2
 After=network.target auditd.service
-ConditionPathExists=!/etc/ssh/sshd_not_to_be_run
+ConditionPathExists=!/etc/ssh/sshd2_not_to_be_run

 [Service]
-EnvironmentFile=-/etc/default/ssh
+EnvironmentFile=-/etc/default/ssh2
 ExecStartPre=/usr/sbin/sshd -t
 ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
 ExecReload=/usr/sbin/sshd -t
@@ -16,4 +16,4 @@

 [Install]
 WantedBy=multi-user.target
-Alias=sshd.service
+Alias=sshd2.service
```

## The config itself

Modify the copied config ```cp /etc/ssh/sshd_config /etc/ssh/sshd_config2``` as:

- change the port to 2020 (or any other as you need)
- change the pid file to ```/var/run/sshd2.pid``` (the PidFile key is not present by default)


```diff
diff -u /etc/ssh/sshd_config /etc/ssh/sshd_config2
--- /etc/ssh/sshd_config	2016-12-09 13:41:44.826684419 +0100
+++ /etc/ssh/sshd_config2	2019-03-19 16:07:51.402328654 +0100
@@ -2,7 +2,7 @@
 # See the sshd_config(5) manpage for details

 # What ports, IPs and protocols we listen for
-Port 22
+Port 2020
 # Use these options to restrict which interfaces/protocols sshd will bind to
 #ListenAddress ::
 #ListenAddress 0.0.0.0
@@ -12,6 +12,7 @@
 HostKey /etc/ssh/ssh_host_dsa_key
 HostKey /etc/ssh/ssh_host_ecdsa_key
 HostKey /etc/ssh/ssh_host_ed25519_key
+PidFile /var/run/sshd2.pid
 #Privilege Separation is turned on for security
 UsePrivilegeSeparation yes
```

## The default enviroment file

You alsou have to modify the copied env ```cp /etc/default/ssh /etc/default/ssh2``` as:

- add non-default config path ```/etc/ssh/sshd_config2```

```diff
diff -u /etc/default/ssh /etc/default/ssh2
--- /etc/default/ssh	2016-04-28 02:46:06.000000000 +0200
+++ /etc/default/ssh2	2019-03-19 16:01:14.710639994 +0100
@@ -2,4 +2,5 @@
 # /etc/init.d/ssh.

 # Options to pass to sshd
-SSHD_OPTS=
+SSHD_OPTS="-f /etc/ssh/sshd_config2"
```

## And finally run and/or enable it

```bash
systemctl daemon-reload
systemctl status ssh2
systemctl start ssh2
# here is the right place for the test
ssh user@0 -p 2020
# if OK the enable it for automatic start
systemctl enable ssh2
```
