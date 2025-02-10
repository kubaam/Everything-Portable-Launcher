# Everything Portable Launcher

A modular portable application launcher that allows you to install, reinstall, launch, reset, and uninstall multiple applications such as Epic Games Launcher, Minecraft Launcher, Steam Launcher, Telegram Launcher, and more—all from one unified script.

> **Note:** This project has been refactored and maintained by **Ambry**—building on initial work by MarioMasta64. Please consider that the functionality is provided "as is" without any warranty.

## Features

- **Modular Architecture:**  
  Separate menus and subroutines for each application make it easy to maintain and extend.

- **Reinstall / Install Option:**  
  Each launcher menu includes a combined "Reinstall / Install" option that works for both initial installation and reinstallation.

- **Configurable Settings:**  
  Use the `ini/settings.ini` file to configure default options (e.g., prompt behavior, user settings, etc.).

- **Common Utility Functions:**  
  Built-in routines for downloading files (via PowerShell) and extracting installers (using 7-Zip).

- **Architecture Detection:**  
  Automatically detects the system architecture (32-bit or 64-bit) and adjusts settings accordingly.

- **Extensible:**  
  The modular design makes it straightforward to add new launcher routines.

## Prerequisites

- **Windows Operating System**  
- **PowerShell** (comes pre-installed on Windows)  
- **7-Zip:**  
  Ensure that 7-Zip is installed and its executable (`7z.exe`) is available on your system `PATH` (or placed in the project directory).

- **Internet Connection:**  
  Required for downloading updates and application installers.

## Repository Structure

- **README.md:**  
  This file.

- **launcher.bat:**  
  The main batch script that provides the interactive menu system and all subroutines.

- **ini/settings.ini:**  
  Configuration file for default settings and other parameters.

- **bin/:**  
  Directory where application binaries are installed or launched from.

- **extra/:**  
  Directory used for storing downloaded installer files and temporary files.

- **helpers/:**  
  Contains helper scripts (for example, for file downloads) used by the launcher.

- **doc/:**  
  Contains additional documentation and licensing information.

## Installation & Usage

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/EverythingPortableLauncher.git
   cd EverythingPortableLauncher
   ```

2. **(Optional) Configure Settings**

   Edit the `ini/settings.ini` file to change default options (e.g., prompt behavior, username, etc.).

3. **Run the Launcher**

   Simply double-click the `launcher.bat` file (or run it from a command prompt) to open the main menu.  
   From the main menu, choose the launcher you wish to work with:
   - **Epic Games Launcher**
   - **Minecraft Launcher**
   - **Steam Launcher**
   - **Telegram Launcher**
   
   Follow the on-screen instructions for installing, launching, resetting, or uninstalling the chosen application.

## Credits

- **Ambry:**  
  Refactored, maintained, and enhanced this launcher script.

- **MarioMasta64:**  
  Original inspiration and contributions to the portable launcher concepts.

Additional contributions from the community are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your improvements. Make sure to follow the existing coding style and include appropriate documentation for any changes.

## Disclaimer

This launcher script is provided "as is" without warranty of any kind. Use it at your own risk. Neither Ambry nor MarioMasta64 (nor any contributors) shall be held liable for any issues or damages resulting from its use.
