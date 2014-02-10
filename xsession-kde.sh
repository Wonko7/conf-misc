#!/bin/bash

conky&
compton --config ~/.compton.conf&
#(sleep 10; killall conky; conky)
(gpg-agent --daemon --sh&)
