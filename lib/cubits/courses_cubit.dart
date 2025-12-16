import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  /// Check if a string is a base64 image string
  bool _isBase64String(String data) {
    if (data.isEmpty) return false;

    // Check if it's a data URI format
    if (data.startsWith('data:image')) return true;

    // Check if it's an asset path or URL
    if (data.startsWith('assets/') ||
        data.startsWith('http://') ||
        data.startsWith('https://')) {
      return false;
    }

    // Check for base64 image signatures (common image formats)
    // PNG: iVBORw0KGgo
    // JPEG: /9j/4AAQ
    // GIF: R0lGODlh
    // WebP: UklGR
    final base64Signatures = [
      'iVBORw0KGgo', // PNG
      '/9j/4AAQ', // JPEG
      'R0lGODlh', // GIF
      'UklGR', // WebP
    ];

    // Check if it matches image signatures
    for (var signature in base64Signatures) {
      if (data.startsWith(signature)) {
        return true;
      }
    }

    // If it's long and contains only base64 characters, it's likely base64
    if (data.length > 200 && RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(data)) {
      return true;
    }

    return false;
  }

  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _coursesSubscription;

  CoursesCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(CoursesInitial()) {
    _startListening();
  }

  /// Start listening to courses collection in real-time
  void _startListening() {
    emit(CoursesLoading());

    _coursesSubscription?.cancel();
    _coursesSubscription = _firestore.collection('courses').snapshots().listen(
      (snapshot) {
        try {
          final courses = snapshot.docs.map((doc) {
            final data = doc.data();
            // Check for base64 image in separate field or in imagePath
            String? imageData = data['imageBase64'] as String?;
            String? imagePath = data['imagePath'] as String?;

            // If imagePath is a base64 string, treat it as base64 data
            if (imageData == null &&
                imagePath != null &&
                _isBase64String(imagePath)) {
              imageData = imagePath;
              imagePath = null; // Clear imagePath so we use base64
            }

            return {
              'id': doc.id,
              'name': data['name'] ?? 'Unnamed Course',
              'imagePath': imagePath ?? 'assets/images/exam.png',
              'imageBase64': imageData, // Store base64 if available
              'description': data['description'] ?? '',
            };
          }).toList();

          // Sort by name locally to avoid Firestore index requirements
          courses.sort(
              (a, b) => (a['name'] as String).compareTo(b['name'] as String));

          emit(CoursesLoaded(courses));
        } catch (e) {
          emit(CoursesError('Failed to load courses: $e'));
        }
      },
      onError: (error) {
        emit(CoursesError('Error listening to courses: $error'));
      },
    );
  }

  /// Manually refresh courses (reconnects the listener)
  Future<void> refreshCourses() async {
    _startListening();
  }

  /// Load courses once (non-realtime, for backward compatibility)
  Future<void> loadCourses() async {
    emit(CoursesLoading());
    try {
      final snapshot = await _firestore.collection('courses').get();

      final courses = snapshot.docs.map((doc) {
        final data = doc.data();
        // Check for base64 image in separate field or in imagePath
        String? imageData = data['imageBase64'] as String?;
        String? imagePath = data['imagePath'] as String?;

        // If imagePath is a base64 string, treat it as base64 data
        if (imageData == null &&
            imagePath != null &&
            _isBase64String(imagePath)) {
          imageData = imagePath;
          imagePath = null; // Clear imagePath so we use base64
        }

        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed Course',
          'imagePath': imagePath ?? 'assets/images/exam.png',
          'imageBase64': imageData, // Store base64 if available
          'description': data['description'] ?? '',
        };
      }).toList();

      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CoursesError('Failed to load courses: $e'));
    }
  }

  @override
  Future<void> close() {
    _coursesSubscription?.cancel();
    return super.close();
  }
}
