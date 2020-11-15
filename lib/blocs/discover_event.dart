part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();
}

class DiscoverDevices extends DiscoverEvent {
  DiscoverDevices();

  @override
  List<Object> get props => [];
}
