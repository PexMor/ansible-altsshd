#!/bin/bash

ansible-playbook -v -i "server," --user moravekp --ask-pass  --ask-sudo-pass testAltSsh.yaml