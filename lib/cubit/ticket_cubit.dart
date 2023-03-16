import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/purchase_tickets/repo/tickets_repo.dart';

part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final TicketsRepo _repo;
  final String event_id;
  final TicketType type;
  TicketCubit(
    this._repo, {
    this.event_id,
    this.type,
  }) : super(
          TicketState(
            amount: 1,
            event_id: event_id,
            type: type,
            networkStatus: TicketNetworkStatus.loading,
          ),
        );

  void changeAmount(amt) async {
    emit(
      TicketState(
        amount: amt,
        event_id: this.event_id,
        type: state.type,
        additionalCharge: state.additionalCharge,
        networkStatus: state.networkStatus,
      ),
    );
  }

  void incrementAdditionalAmount(Service s, int amount) async {
    List<Map<Service, int>> extras = new List.from(state.additionalCharge);
    Map<Service, int> temp;
    if (extras.length == 0) {
      extras.add({s: amount});
    } else {
      try {
        temp = new Map.from(
            extras?.firstWhere((element) => element.containsKey(s)));
        temp?.update(s, (value) => value + amount, ifAbsent: () => amount);
        int pos = extras.indexWhere(
            (e) => e.entries.first.key.id == temp.entries.first.key.id);
        extras[pos] = temp;
      } on StateError {
        extras.add({s: amount});
      }
    }
    emit(
      TicketState(
        amount: state.amount,
        event_id: this.event_id,
        type: state.type,
        additionalCharge: extras,
        networkStatus: state.networkStatus,
      ),
    );
  }

  void decrementAdditionalAmount(Service s, int amount) async {
    List<Map<Service, int>> extras = new List.from(state.additionalCharge);
    Map<Service, int> temp;
    if (extras.length > 0) {
      try {
        temp = new Map.from(
            extras?.firstWhere((element) => element.containsKey(s)));
        if ((temp.entries.first.value - amount) > 0) {
          print("HERE");
          temp.update(s, (value) => value - amount, ifAbsent: () => 0);
          int pos = extras.indexWhere(
              (e) => e.entries.first.key.id == temp.entries.first.key.id);
          extras[pos] = temp;
        } else
          extras.removeWhere((element) =>
              element.entries.first.key.id == temp.entries.first.key.id);
      } on StateError {
        print("dec NONE");
        // extras.add({s: amount});
      }
    }
    emit(
      TicketState(
        amount: state.amount,
        event_id: this.event_id,
        type: state.type,
        additionalCharge: extras,
        networkStatus: state.networkStatus,
      ),
    );
  }

  void changeAdditional(Map<Service, int> extra) async {
    state.additionalCharge.add(extra);
    emit(
      TicketState(
        amount: state.amount,
        event_id: this.event_id,
        type: state.type,
        additionalCharge: state.additionalCharge,
        networkStatus: state.networkStatus,
      ),
    );
  }

  Future<void> bookTicket() async {
    try {
      emit(
        new TicketState(
          amount: state.amount,
          event_id: state.event_id,
          type: state.type,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.loading,
        ),
      );
      await _repo.bookTicket(
        state.amount,
        event_id: state.event_id,
      );
      emit(
        new TicketState(
          amount: state.amount,
          event_id: state.event_id,
          type: state.type,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.created,
        ),
      );
    } catch (ex) {
      print(ex);
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.error,
          type: state.type,
        ),
      );
    }
  }

  Future<void> bookWaitingTicket() async {
    try {
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          type: state.type,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.loading,
        ),
      );
      await _repo.bookWaitingTicket(
        state.amount,
        event_id: state.event_id,
      );
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          type: state.type,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.created,
        ),
      );
      print('Type: ${state.type}');
    } catch (ex) {
      print(ex);
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.error,
          type: state.type,
        ),
      );
    }
  }

  Future<void> cancelWaitingTicket() async {
    try {
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          type: state.type,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.loading,
        ),
      );
      await _repo.cancelWaitingTicket(
        state.event_id,
      );
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          type: state.type,
          additionalCharge: state.additionalCharge,
          networkStatus: TicketNetworkStatus.created,
        ),
      );
      print('Type: ${state.type}');
    } catch (ex) {
      print(ex);
      emit(
        TicketState(
          amount: state.amount,
          event_id: state.event_id,
          networkStatus: TicketNetworkStatus.error,
          type: state.type,
          additionalCharge: state.additionalCharge,
        ),
      );
    }
  }
}
