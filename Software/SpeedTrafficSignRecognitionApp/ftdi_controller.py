from PySide6.QtCore import QTimer, QObject, Signal
import ftd2xx.defines
import serial.tools.list_ports
import ftd2xx

class FTDIController(QObject):

    # Define to enable debug traces
    ENABLE_DEBUG_TRACES = False

    # Default port scanning interval in ms
    DEFAULT_SCAN_INTERVAL_MS = 1000 

    # Signal to send detected ports list
    portsDetectedEvent = Signal(dict)

    def __init__(self):
        super().__init__()
        self.timer = QTimer()
        self.timer.timeout.connect(self.scanDevices)
        self.device = None
        self.connected = False

    def isConnected(self):
        return self.connected
    
    def startScanning(self):
        self.timer.start(FTDIController.DEFAULT_SCAN_INTERVAL_MS)
    
    def stopScanning(self):
        self.timer.stop()

    def scanDevices(self):
        devices = self.listDevices()
        self.portsDetectedEvent.emit(devices)

    def listDevices(self):
        """Lista todos los dispositivos FTDI conectados al PC"""
        ports = list(serial.tools.list_ports.comports())
        ftdi_serials = ftd2xx.listDevices()
        devices = { }
        for port in ports: 
            if "FTDI" in port.manufacturer:
                serialNum_ports = port.serial_number.encode("ascii")
                matching_serial = next((s for s in ftdi_serials if serialNum_ports.startswith(s)), serialNum_ports)
                devices[port.device] = {

                    "serialNum": matching_serial, # convert to bytes
                    "vid": port.vid,
                    "pid": port.pid,
                    "description": port.description
                }
            
        return devices

    def connectToDevice(self, port):
        """Establece la conexión con el chip FTDI en el puerto especificado"""
        try:
            # Open by serial number by default
            self.device = ftd2xx.openEx(port["serialNum"])
            self.device.resetDevice()
            self.device.setLatencyTimer(1)
            self.device.setFlowControl(ftd2xx.defines.FLOW_RTS_CTS, 0x00, 0x00)
            self.device.setTimeouts(1, 1) # 1ms to read & 1ms to write
            self.device.setUSBParameters(65536, 1)
            self.device.purge(ftd2xx.defines.PURGE_RX | ftd2xx.defines.PURGE_TX)
            self.connected = True
            if FTDIController.ENABLE_DEBUG_TRACES:
                print(f"✅ Conected to FTDI on {port['description']}")
            return True
        except Exception as e:
            if FTDIController.ENABLE_DEBUG_TRACES:
                print("❌ Error Connecting")
            return False

    def disconnect(self):
        """Cierra la conexión con el chip FTDI"""
        if self.device:
            self.device.close()
            self.connected = False
            if FTDIController.ENABLE_DEBUG_TRACES:
                print("🔌 Conexión FTDI cerrada.")
        else:
            if FTDIController.ENABLE_DEBUG_TRACES:
                print("⚠️ No hay conexión FTDI activa.")

    def writeData(self, data):
        """Envía datos al chip FTDI si está conectado"""
        if self.device:
            if FTDIController.ENABLE_DEBUG_TRACES:
                print(f"📤 Datos enviados: {data}")
            return self.device.write(data) > 0
        else:
            if FTDIController.ENABLE_DEBUG_TRACES:
                print("⚠️ No hay dispositivo FTDI conectado.")
            return False

    def getNumOfRxBytes(self):
        return self.device.getQueueStatus()
    
    def readData(self, numBytes):
        return self.device.read(numBytes)
    
    def purge(self):
        if self.device:
            self.device.purge(ftd2xx.defines.PURGE_RX | ftd2xx.defines.PURGE_TX)