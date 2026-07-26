import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/profile_model.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/patient_repo.dart';

part 'patient_cubit.freezed.dart';
part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final PatientRepo _patientRepo;

  PatientCubit({required PatientRepo patientRepo})
    : _patientRepo = patientRepo,
      super(PatientState.initial());

  /// 📌 Load all profiles
  Future<void> getAllPatient() async {
    emit(const PatientState.loading());
    try {
      final patientList = await _patientRepo.getAllPatients();

      emit(PatientState.loaded(patientList));
    } catch (e) {
      debugPrint('Error loading patients: $e');
      emit(PatientState.error(LocaleKeys.error_loading_patients.trnsltd));
    }
  }

  Future<void> updatePatient(ProfileModel updatedPatient) async {
    try {
      final newPatient = await _patientRepo.updatePatient(updatedPatient);

      final currentList = state.maybeWhen(
        loaded: (list) => list,
        orElse: () => <ProfileModel>[],
      );

      final updatedList = currentList.map((s) {
        return s.userId == newPatient.userId ? newPatient : s;
      }).toList();

      emit(PatientState.loaded(updatedList));
    } catch (e) {
      debugPrint('Error updating patient: $e');
      emit(PatientState.error(LocaleKeys.patient_error_update.trnsltd));
    }
  }
}
