# Portronics Speaker AUX Auto-Sleep & Cut-Off Fix

This toolkit fixes the issue where the **Portronics Radian** (or any Bluetooth/AUX speaker or soundbar) powers off, sleeps, or cuts off audio during silent/quiet movie scenes and takes 1–2 seconds to wake up when dialogue resumes.

---

## 🔍 Why Does This Happen?

1. **Speaker Hardware Auto-Standby:**
   Portable Bluetooth/AUX speakers have a built-in energy-saving circuit. When connected via 3.5mm AUX, the speaker continuously samples the analog voltage. If there is complete silence or very low volume for a few seconds, the speaker assumes nothing is playing and turns off its amplifier to save battery and avoid static hiss.
2. **Windows Realtek Driver 5-Second Sleep:**
   Windows Realtek audio drivers have a default setting (`ConservationIdleTime`) that powers down the audio DAC (D3 state) after **exactly 5 seconds** of silence.
3. **Improper Volume Staging:**
   If Windows master volume is set low (e.g. 20%) and the speaker knob is turned up high, the analog voltage sent across the AUX wire is microscopic, easily triggering the speaker's silence threshold.

---

## ⚡ Quick Hardware Tip (Do this first!)
**Turn Windows Master Volume up to 80% – 100%**, then lower the physical volume on your Portronics Radian speaker to a comfortable level.
> Sending a stronger audio signal over the 3.5mm cable helps quiet background noises stay above the speaker's cutoff threshold.

---

## 🛠️ Included Fix Scripts

All scripts are located in: `c:\Users\rushi\dev\gemini_projects\audio_fix`

| File | Purpose |
|---|---|
| **`Start_KeepAlive.bat`** | Starts the inaudible keep-alive stream silently in the background (no window). |
| **`Stop_KeepAlive.bat`** | Stops the background audio keeper. |
| **`Check_Status.bat`** | Shows whether the keeper is currently running or stopped. |
| **`Install_Startup.bat`** | Adds the keeper to Windows Startup so it starts automatically on PC boot. |
| **`Uninstall_Startup.bat`** | Removes the keeper from Windows Startup. |
| **`Test_Audio_Verification.bat`** | Plays a quick chime followed by the inaudible tone to test your setup. |
| **`Fix_Realtek_5s_Sleep.bat`** | *(Admin)* Permanently disables the 5-second DAC sleep in Windows Realtek registry. |
| **`Restore_Realtek_Default_Sleep.bat`** | *(Admin)* Restores original Realtek sleep settings if ever needed. |

---

## 🚀 How to Use

### Method 1: Everyday Use (Recommended)
1. Double-click **`Start_KeepAlive.bat`**.
2. It will generate a clean **20 Hz sub-audible keep-alive loop** and play it silently in the background using native Windows audio.
   - **0% audible sound:** 20 Hz is below the physical reproduction range of portable speakers.
   - **0% CPU usage:** Uses lightweight native Windows multimedia streaming.
3. If you want it to always run automatically whenever you turn on your PC, double-click **`Install_Startup.bat`**.

### Method 2: Permanently Disable Windows Realtek 5-Second Sleep
1. Right-click **`Fix_Realtek_5s_Sleep.bat`** and select **Run as administrator**.
2. This changes the Windows registry value `ConservationIdleTime` from 5 seconds to disabled (0), preventing Windows from cutting power to the AUX port during movie pauses.
3. Restart your PC.
