# Assembly Graphics and Sound Project

## Overview
This project is an **assembly language implementation** designed for **MASM (Microsoft Macro Assembler) in real mode**. It consists of two main parts:

1. **Sound and Display Effects**: 
   - Plays a unique sound for each lowercase English letter key pressed.
   - Changes the screen color dynamically.
   - Displays the real-time system clock (hours, minutes, seconds) and updates it every second.

2. **Graphics Drawing and Input Handling**:
   - Accepts user input commands to draw **circles, rectangles, and squares** with specified dimensions and colors.
   - Uses **BIOS interrupt 10h** for pixel-based graphics rendering.
   - Detects invalid user inputs and requests corrected input.
   - Allows users to move shapes using keyboard arrow keys.
   - Supports an **exit key** to terminate the program.

## Features
✅ Uses **real mode assembly programming** (MASM).  
✅ Implements **sound generation via system speaker**.  
✅ Dynamically **changes screen colors**.  
✅ Draws **various geometric shapes** using BIOS interrupts.  
✅ Processes **user input with validation**.  
✅ Provides **real-time clock display and updates**.  
✅ Supports **shape movement with keyboard controls**.  
✅ Exits gracefully with a defined **exit key**.

## Installation & Execution
### **Prerequisites**
- **MASM 6.11+**
- **DOSBox (or any x86 emulator supporting real mode)**

### **Steps to Run**
1. Clone this repository:
   ```sh
   git clone https://github.com/your-repo/assembly-graphics-sound.git
   ```
2. Navigate to the project directory:
   ```sh
   cd assembly-graphics-sound
   ```
3. Assemble the program using MASM:
   ```sh
   masm Answer1.asm;
   masm Answer2.asm;
   ```
4. Link the object files:
   ```sh
   link Answer1.obj;
   link Answer2.obj;
   ```
5. Run the executable:
   ```sh
   Answer1.exe  # Runs the sound and color effect program
   Answer2.exe  # Runs the graphics program
   ```

## User Commands (For Graphics Program)
### **Drawing Shapes**
- **Circle:**
  ```sh
  >circle x y r color
  ```
- **Rectangle:**
  ```sh
  >rectangle x y m n color
  ```
- **Square:**
  ```sh
  >square x y m color
  ```

### **Controls**
| Key  | Action        |
|------|--------------|
| ⬆️    | Move Up      |
| ⬇️    | Move Down    |
| ⬅️    | Move Left    |
| ➡️    | Move Right   |
| `ESC`| Exit Program |

## Notes & Limitations
- This project **does not use any external libraries**; only BIOS interrupts.
- Ensure you **run it inside DOSBox or an appropriate real-mode emulator**.
- Input values **must be valid numbers**; otherwise, the program will request correction.
- The **clock update is real-time** and refreshes every second.

## Author
**Puya Pakshad**  
📧 Contact: [ppakshad@hawk.iit.edu](mailto:ppakshad@hawk.iit.edu)

## License
This project is licensed under the **MIT License**.
