part of 'discover_bloc.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();
}

class DiscoverInitial extends DiscoverState {
  @override
  List<Object> get props => [];
}

class Discovering extends DiscoverState {
  const Discovering();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DiscoveryLoaded extends DiscoverState {
  final Map<String, DeviceIdentity> uniqueDevices;
  const DiscoveryLoaded(this.uniqueDevices);

  @override
  bool operator ==(Object obj) {
    if (identical(this, obj)) return true;

    return obj is DiscoveryLoaded && obj.uniqueDevices == uniqueDevices;
  }

  @override
  int get hashCode => uniqueDevices.hashCode;

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DiscoverError extends DiscoverState {
  final String message;
  const DiscoverError(this.message);

  @override
  bool operator ==(Object obj) {
    if (identical(this, obj)) return true;

    return obj is DiscoverError && obj.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  // TODO: implement props
  List<Object> get props => [];
}