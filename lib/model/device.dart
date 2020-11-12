class DeviceIdentity {
  String name;
  String type;
  String hostName;
  String address;
  String port;

  DeviceIdentity(String _name, String _type, String _hostname, String _address, String _port) {
    name = _name;
    type = _type;
    hostName = _hostname;
    address = _address;
    port = _port;
  }

  factory DeviceIdentity.fromCSV(String strCSV) {
    List<String> deviceID = strCSV.split(new RegExp(',\\s+'));
    return new DeviceIdentity(deviceID[0], deviceID[1], deviceID[2], deviceID[3], deviceID[4]);
  }

  factory DeviceIdentity.fromDeviceIdentity(DeviceIdentity deviceID) {
    return new DeviceIdentity(deviceID.name, deviceID.type, deviceID.hostName, deviceID.address, deviceID.port);
  }

  @override
  String toString() {
    return '${this.name}, ${this.type}, ${this.hostName}, ${this.address}, ${this.port}';
  }
}