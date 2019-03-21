Role Name
=========

Ansible role to setup alternative ssh daemon on systemd

__Simple test:__ (when cloning this repo)

```bash
ansible-playbook -v -i "server," --user remote-user --ask-pass  --ask-sudo-pass testAltSsh.yaml
```

__Where:__

  __server__ is hostname or ip of your server

__Ansible Galaxy install:__ (directly from github)

```bash
ansible-galaxy install git+https://github.com/pexmor/ansible-altsshd.git
```

Requirements
------------

This ansible role assumes that the target host has openssh daemon already installed and has a decent version of SystemD.

Role Variables
--------------

__ssh.id__ - This identifier which should follow abvious rules of identifiers (a-z0-9) is used for filenames. __No spaces plase !!!__

__ssh.name__ - This name is used in service file as short description

__ssh.port__ - This is the __main__ and most important value as we are setting the other port for ssh.

Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: altssh, ssh: { id: ssh2, name: 'SSHD@2020', port: 2020 } }

License
-------

MIT

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
