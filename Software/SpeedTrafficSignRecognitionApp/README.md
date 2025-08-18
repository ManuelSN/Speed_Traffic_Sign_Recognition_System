# SpeedTrafficSignRecognitionApp

This repository contains the source code and environment configuration for the project.

## 🚀 For end users

If you only want to **use the application**, you don’t need to install Python, Conda, or any dependencies.  
Just download and run the installer **`STSRAppInstaller.exe`** located in the [Software](./) folder.  

The installer will set up everything automatically — you just need to follow the wizard and start the app.

---

## 🛠️ For developers

If you want to work with the source code, modify or extend the project, follow these steps:

### 1. Create the environment

The following command will **create a conda environment** with **all the required dependencies** specified in `requirements.txt`.  
This environment ensures you have everything needed to **compile and run the code** consistently.

```
conda env create -f conda_environment.yml
conda activate SpeedTrafficSignRecognitionApp_env
```

## 2. FTDI driver (required for ftd2xx)

To allow the application to communicate with the FTDI device, you must copy the FTDI D2XX driver DLL into your Windows system folder:

- For Windows 64-bit + Python 64-bit: copy ftd2xx64.dll to -> C:\Windows\System32\
- For Windows 64-bit + Python 32-bit: copy ftd2xx.dll to ---> C:\Windows\SysWOW64\
- For Windows 32-bit: copy ftd2xx.dll to ---------------------> C:\Windows\System32\
