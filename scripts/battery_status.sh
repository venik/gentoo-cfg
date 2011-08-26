# Battery status script
# Copyright (C) 2011 Alex Nikiforov  nikiforov.pub@gmail.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# I found it some time ago, but it was for old acpi in procfs
# unforantly, but I dont remember who was the author of that script.
# I update it for sysfs and add .bashrc. Work fine on Gentoo :]

# sample of the .bashrc
#-----------------------------------------------------------------------
#BAT=$(/path/to/the/script/battery_status.sh)
#export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] $BAT \w \$\[\033[00m\] "
#-----------------------------------------------------------------------

#!/bin/bash
BATTERY=/sys/class/power_supply/BAT0/

REM_CAP=`cat $BATTERY/energy_now`
FULL_CAP=`cat $BATTERY/energy_full`
BATSTATE=`cat $BATTERY/status`

CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`

NON='\033[00m'
BLD='\033[01m'
RED='\033[01;31m'
GRN='\033[01;32m'
YEL='\033[01;33m'

COLOUR="$RED"

case "${BATSTATE}" in
   'Charged')
   BATSTT="$BLD=$NON"
   ;;
   'Charging')
   BATSTT="$BLD+$NON"
   ;;
   'Discharging')
   BATSTT="$BLD-$NON"
   ;;
esac

# prevent a charge of more than 100% displaying
if [ "$CHARGE" -gt "99" ]
then
   CHARGE=100
fi

if [ "$CHARGE" -gt "15" ]
then
   COLOUR="$YEL"
fi

if [ "$CHARGE" -gt "30" ]
then
   COLOUR="$GRN"
fi

echo -e "${COLOUR}${CHARGE}%${NON} ${BATSTT}"

# end of file
