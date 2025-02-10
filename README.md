---

# 🚀 **Everything Portable Launcher**  

A **modular, portable application launcher** that allows you to **install, reinstall, launch, reset, and uninstall** multiple applications—such as **Epic Games Launcher, Minecraft Launcher, Steam, Telegram, and more**—from a single unified script.

> **Maintainer:** **Ambry**  
> Originally inspired by MarioMasta64. This project is provided **"as is"** without any warranty.

---

## 🔥 **Features**  

✅ **Modular Architecture** – Easily maintain and extend functionality for different launchers.  
✅ **Reinstall / Install Support** – Seamlessly install or reinstall applications from the same menu.  
✅ **Configurable Settings** – Customize behavior via `ini/settings.ini`.  
✅ **Utility Functions** – Built-in **PowerShell downloads** and **7-Zip extraction** for seamless installations.  
✅ **System Architecture Detection** – Automatically configures settings for **32-bit or 64-bit** systems.  
✅ **Extensible & Open-Source** – Designed to support **additional launchers** with minimal modifications.  

---

## 🖥 **Prerequisites**  

- **Windows Operating System**  
- **PowerShell** (pre-installed on Windows)  
- **7-Zip** (`7z.exe` must be in system `PATH` or inside the project directory)  
- **Internet Connection** (for downloading installers & updates)  

---

## 📂 **Repository Structure**  

```
EverythingPortableLauncher/
│── launcher.bat         # Main batch script providing the interactive menu
│── ini/settings.ini     # Configuration file for user preferences
│── bin/                 # Directory where installed binaries are stored
│── extra/               # Directory for downloaded installer files
│── helpers/             # Additional scripts for supporting functions
│── doc/                 # Documentation & licensing information
│── README.md            # This file
```

---

## ⚙ **Installation & Usage**  

### 1️⃣ **Clone the Repository**  

```bash  
git clone https://github.com/yourusername/EverythingPortableLauncher.git  
cd EverythingPortableLauncher  
```

### 2️⃣ **(Optional) Configure Settings**  

Modify `ini/settings.ini` to adjust **default behaviors, paths, and user settings**.

### 3️⃣ **Run the Launcher**  

Simply **double-click** `launcher.bat` or run it via Command Prompt:  

```bash  
launcher.bat  
```

📜 **Main Menu Options:**  
- **Epic Games Launcher**  
- **Minecraft Launcher**  
- **Steam Launcher**  
- **Telegram Launcher**  

🔧 **Available Actions for Each Application:**  
✅ **Install / Reinstall** – Downloads and sets up the launcher.  
✅ **Launch** – Starts the selected application.  
✅ **Reset** – Clears user settings & cache.  
✅ **Uninstall** – Removes the application from the system.  

---

## 🎉 **Contributing**  

🔹 **Fork the repository**  
🔹 **Create a feature branch** (`feature/your-feature`)  
🔹 **Commit your changes**  
🔹 **Submit a pull request**  

💡 Contributions are welcome! Please ensure **code quality & documentation consistency**.  

---

## 📜 **License**  

This project is licensed under the **MIT License**. See [`LICENSE`](LICENSE) for details.  

---

## ⚠️ **Disclaimer**  

This software is provided **"as is"** without any warranty. **Ambry** and **MarioMasta64** (or any contributors) are **not responsible** for any issues or damages resulting from its use.  

Use at your own risk. 🚀  

---
