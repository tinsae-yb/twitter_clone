import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/feeds_repository.dart';

part 'feeds_state.dart';

class FeedsCubit extends Cubit<FeedsState> {
  final FeedsRepository feedsRepository;
  final AuthRepository authRepository;
  FeedsCubit({required this.authRepository, required this.feedsRepository})
      : super(FeedsInitial());
}
