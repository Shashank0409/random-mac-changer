# Random MAC Address Changer for Kali Linux at Boot

This guide explains how to set up a script that changes the MAC address of your Kali Linux machine every time it boots up.

---

## Prerequisites

- A Kali Linux machine
- Root privileges
- Internet connection to install necessary tools

---

## Steps to Implement

### 1. Open Terminal with Root Privileges

1. Open the terminal.
2. Switch to root user by entering the following command and providing your password:
   ```bash
   sudo su
   ```

### 2. Navigate to the Home Directory

1. Change to the home directory for the `kali` user:
   ```bash
   cd /home/kali
   ```

### 3. Create a Directory for Custom Boot Programs

1. Create a directory named `bootprograms` to store your custom scripts:
   ```bash
   mkdir bootprograms
   cd bootprograms
   ```

### 4. Create the MAC Address Changing Script

1. Create a new file named `changemac.sh` and open it using `gedit`:
   ```bash
   apt install gedit  # Install gedit if not already installed
   gedit changemac.sh
   ```
2. Paste the following code into `changemac.sh`:
   ```bash
   # Function to generate a new random MAC address
   generate_new_mac(){
       # Get a list of valid MAC address prefixes from macchanger
       prefix=$(macchanger -l | grep -oP '([0-9a-f]{2}[:]){2}[0-9a-f]{2}' | sort -u)
       # Randomly select one prefix from the list
       random_prefix=$(echo "$prefix" | shuf -n 1)
       # Generate the last three octets of the MAC address randomly
       end=$(hexdump -n 3 -e '3/1 "%02x:"' /dev/random | sed 's/:$//')
       # Combine the prefix and random end to form a complete MAC address
       echo "$random_prefix:$end"
   }

   # Generate two random MAC addresses
   random_mac1=$(generate_new_mac)
   random_mac2=$(generate_new_mac)

   # Change the MAC address twice for reliability
   sudo macchanger eth0 -m $random_mac1  # First change
   sudo macchanger eth0 -m $random_mac2  # Second change
   ```
3. Save and close the file.

### 5. Make the Script Executable

1. Change the file permissions to make it executable:
   ```bash
   chmod +x changemac.sh
   ```

### 6. Test the Script

1. Verify the current MAC address:
   ```bash
   ifconfig
   ```
2. Run the script:
   ```bash
   ./changemac.sh
   ```
3. Verify if the MAC address has changed:
   ```bash
   ifconfig
   ```

### 7. Set the Script to Run at Boot

1. Open the `crontab` file:
   ```bash
   crontab -e
   ```
2. Add the following line to the file:
   ```
   @reboot /home/kali/bootprograms/changemac.sh
   ```
3. Save and exit the editor.

### 8. Ensure `cron` Service Runs at Boot

1. Start the `cron` service:
   ```bash
   service cron start
   systemctl start cron
   update-rc.d cron defaults
   ```

### 9. Reboot and Verify

1. Reboot the system:
   ```bash
   reboot
   ```
2. After rebooting, check if the MAC address has changed automatically:
   ```bash
   ifconfig
   ```

---

## How to Upload to GitHub

1. **Create a GitHub Repository:**

   - Log in to your GitHub account.
   - Click on "+" (top-right corner) > "New repository".
   - Name the repository (e.g., `random-mac-changer`).
   - Optionally, add a description and make it public or private.
   - Click "Create repository".

2. **Initialize the Local Repository:**

   - Open your terminal in the `bootprograms` directory:
     ```bash
     cd /home/kali/bootprograms
     ```
   - Initialize a Git repository:
     ```bash
     git init
     ```

3. **Add Files and Commit:**

   - Add all files to the staging area:
     ```bash
     git add changemac.sh
     ```
   - Commit the changes:
     ```bash
     git commit -m "Initial commit: Add MAC address changer script"
     ```

4. **Link to GitHub Repository:**

   - Add the GitHub repository as a remote:
     ```bash
     git remote add origin https://github.com/<your-username>/random-mac-changer.git
     ```

5. **Push to GitHub:**

   - Push the changes to the repository:
     ```bash
     git branch -M main
     g
     ```

6. error: failed to push some refs to 'https\://github.com/Shashank0409/random-mac-changer.git'

   **Verify:**

   - Visit your GitHub repository page to confirm the upload.

---

