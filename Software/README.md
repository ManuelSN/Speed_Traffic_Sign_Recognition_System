# 💻 Software

The following command will **create a conda environment** with **all the required dependencies** specified in **`requirements.txt`**.  
This environment ensures you have everything needed to **compile and run all the scripts & code** consistently.

```
conda env create -f conda_environment.yml
conda activate SpeedTrafficSignRecognitionApp_env
```

## SpeedTrafficSignRecognitionApp

This repository contains the source code and environment configuration for the project.

Two different **graphical interfaces (GUIs)** have been developed:  
- 🛠️ **Debug Mode** → intended for FPGA debugging and testing ([releases](https://github.com/ManuelSN/Speed_Traffic_Sign_Recognition_System/releases)).  
- 🚀 **Release Mode** → intended for end users, providing a simplified and user-friendly interface ([releases](https://github.com/ManuelSN/Speed_Traffic_Sign_Recognition_System/releases)).  

## 🚀 For end users

The GUI in **Release Mode** it looks like this:

[Release Mode](assets/DEBUG_TEST_PROCESS.png)

If you only want to **use the application**, you don’t need to install Python, Conda, or any dependencies.  
Just download the installer **`STSRAppInstaller.exe`** from the [releases](https://github.com/ManuelSN/Speed_Traffic_Sign_Recognition_System/releases) section.  

The installer will set up everything automatically — you just need to follow the wizard and start the app.


## 🛠️ For developers

The GUI in **Debug Mode** it looks like this:

[Debug Mode](assets/SW_Test_Sign_Recognized.png)

If you want to work with the source code, modify or extend the project, you will need:

### FTDI driver (required for ftd2xx)

To allow the application to communicate with the FTDI device, you must copy the FTDI D2XX driver DLL downloaded [here](https://ftdichip.com/drivers/d2xx-drivers/) into your Windows system folder:

- For Windows 64-bit + Python 64-bit: copy ftd2xx64.dll to -> C:\Windows\System32\
- For Windows 64-bit + Python 32-bit: copy ftd2xx.dll to ---> C:\Windows\SysWOW64\
- For Windows 32-bit: copy ftd2xx.dll to ---------------------> C:\Windows\System32\
---
## Neural_Network

This folder contains the **machine learning pipeline** used to train, fine-tune, and evaluate the deep learning model for **speed traffic sign recognition**.  
It complements the main application by providing the trained detection model (`.pt`), which is later integrated into the GUI software.

Key features:
- 📂 Clear organization of datasets, scripts, models, and training outputs.  
- ⚙️ Training scripts for base training, evaluation, and fine-tuning.  
- 📊 Outputs include metrics, confusion matrices, and example predictions.  
- 🔄 A reproducible workflow from dataset preparation → training → evaluation → fine-tune → export.  

> ⚠️ Note: The folder structure is **illustrative**. Paths are not hard-coded in the scripts; users can adapt them as long as they update the dataset paths in the corresponding scripts.
