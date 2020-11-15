import 'dart:async';
import 'package:network/network.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yottasens/model/device.dart';
import 'package:yottasens/services/device_discovery.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DeviceDiscoveryService _deviceDiscoveryService;
  DiscoverBloc(this._deviceDiscoveryService) : super(DiscoverInitial());

  @override
  Stream<DiscoverState> mapEventToState(DiscoverEvent event,) async* {
    if (event is DiscoverDevices) {
      try {
        yield Discovering();
        const String discovery_service = "_yottamusic._tcp.local";
        final _discoveredDevices = await _deviceDiscoveryService.discoverDevices(discovery_service);
        yield DiscoveryLoaded(_discoveredDevices);
      } on NetworkException {
        yield DiscoverError("Couldn't discover devices over mDNS. Is the device connected to a network?");
      }
    }
  }
}
