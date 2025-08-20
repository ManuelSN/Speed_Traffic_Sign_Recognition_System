# FPGA Modules

This folder contains the **hardware modules** implemented in VHDL for the project. They are designed to be reusable and modular, forming the core FPGA architecture. 

## Architecture overview

Below is a detailed block diagram representing the hardware implementation developed in VHDL. It shows the connections between the different logic blocks, as well as the
control signals and relevant data that enable the system to operate in real time.

![System hardware architecture](assets/hardware_architecture.jpg)

### FT245 TRANSCEIVER

This functional block comprises the read (**IFREAD**) and write (**IFWRITE**) interfaces of the UM232H-B.

Both share an 8-bit bidirectional or inout (input/output) DATA bus, through which data is exchanged between the PC and the FPGA. The rest of the control signals are independent and are described below:
- **IFREAD**  
    This component is responsible for reading data from the UM-232H-B module when the PC sends information to the FPGA.
- **IFWRITE**  
This component manages the sending of data from the FPGA to the PC via the UM232H-B module. It controls when writing can take place and generates the write signal.

### CLOCKGEN

This component called **CLOCK GENERATOR** is responsible for generating the XCLK clock output, which will be the input for the MT9V111 SoC.

### DISP7SEG

This block implements control of the 4-digit 7-segment display incorporated in the BASYS 3.

### IMAGE PIPELINE

This functional block is responsible for acquiring real images captured by the MT9V111 image sensor or emulated from the SENSOR EMULATOR component. When received through the MT9V111_IF interface, they are stored in the form of bytes (in a FIFO), which
contain the pixel information before being sent to the PC through the FT245 TRANSCEIVER block.

- **FIFO**  
Reading the image from the sensor is faster than transmitting it to the PC, so it is necessary to implement FIFO RAM in the system, which allows the data received from the image sensor to be stored and ensures that it is
not lost and that there are no integrity issues with the data while it is being sent to the PC.

- **MT9V111_IF**  
This block acts as an interface with the MT9V111 sensor, as its name suggests. Its purpose is to receive image data from the sensor and transfer it to the system's FIFO, respecting the control signals and avoiding loss of
information.

- **SENSOR EMULATOR**    
This component has been developed to emulate the operation of the MT9V111 image sensor, allowing verification of the correct operation of the interface (MT9V111_IF), 
as well as the entire process of sending data to the PC without the need for real hardware, all through simulations.

#### FREE-RUNNING COUNTER  
This block is a simple counter with automatic reloading. It is a block designed for sending tests from the FPGA to the PC.
