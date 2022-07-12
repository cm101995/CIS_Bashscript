#!/bin/bash
bash filesystemcheck.sh
sh securebootcheck.sh
sh sudocheck.sh
sh aidecheck.sh
sh additionalcheck.sh
bash MACcheck.sh
bash MACcheck1.sh
bash MACcheck2.sh
sh warnbanner.sh
bash servicecheck.sh
sh serviceclientcheck.sh
sh networkcheck.sh
sh networkcheck2.sh
sh CSAcheck.sh
sh CSAcheck1.sh
sh CSAcheck3.sh