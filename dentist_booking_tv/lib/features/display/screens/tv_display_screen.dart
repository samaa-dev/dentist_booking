import 'package:dentist_booking_tv/core/utils/tv_scale.dart';
import 'package:dentist_booking_tv/features/display/blocs/tv_display_cubit.dart';
import 'package:dentist_booking_tv/features/display/blocs/tv_display_state.dart';
import 'package:dentist_booking_tv/features/display/widgets/ads_carousel_tv.dart';
import 'package:dentist_booking_tv/features/display/widgets/called_number_overlay.dart';
import 'package:dentist_booking_tv/features/display/widgets/queue_display_tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TvDisplayScreen extends StatefulWidget {
  const TvDisplayScreen({super.key});

  @override
  State<TvDisplayScreen> createState() => _TvDisplayScreenState();
}

class _TvDisplayScreenState extends State<TvDisplayScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    context.read<TvDisplayCubit>().start();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    context.read<TvDisplayCubit>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocBuilder<TvDisplayCubit, TvDisplayState>(
        builder: (context, state) {
          if (state is TvDisplayLoading && state is! TvDisplayLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TvDisplayError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(context.s(24)),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.s(24),
                    color: colorScheme.error,
                  ),
                ),
              ),
            );
          }
          if (state is TvDisplayLoaded) {
            final content = Column(
              children: [
                Expanded(
                  flex: 5,
                  child: AdsCarouselTv(
                    ads: state.ads,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.primary,
                          width: context.s(4),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(context.s(16)),
                    child: QueueDisplayTv(queueStatus: state.queueStatus),
                  ),
                ),
              ],
            );
            if (state.justCalledNumber != null) {
              return Stack(
                children: [
                  content,
                  Positioned.fill(
                    child: CalledNumberOverlay(
                      key: ValueKey(state.justCalledNumber),
                      queueNumber: state.justCalledNumber!,
                      doctorDisplayName: state.doctorDisplayName,
                      onDismiss: () {
                        context.read<TvDisplayCubit>().clearJustCalled();
                      },
                    ),
                  ),
                ],
              );
            }
            return content;
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
