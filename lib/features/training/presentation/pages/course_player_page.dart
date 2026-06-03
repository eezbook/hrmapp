import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/training_remote_datasource.dart';
import '../bloc/course_player_cubit.dart';

class CoursePlayerPage extends StatefulWidget {
  final int courseId;

  const CoursePlayerPage({super.key, required this.courseId});

  @override
  State<CoursePlayerPage> createState() => _CoursePlayerPageState();
}

class _CoursePlayerPageState extends State<CoursePlayerPage>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<CoursePlayerCubit>().loadCourse();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _savePosition();
    }
  }

  void _savePosition() {
    final pos = _videoController?.value.position.inSeconds;
    if (pos != null) {
      context.read<CoursePlayerCubit>().savePosition(pos);
    }
  }

  Future<void> _initVideo(String url, int startSeconds) async {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();
    if (startSeconds > 0) {
      await _videoController!.seekTo(Duration(seconds: startSeconds));
    }
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      allowFullScreen: true,
    );

    _videoController!.addListener(() {
      if (_videoController!.value.isPlaying) {
        final duration = _videoController!.value.duration.inSeconds;
        if (duration > 0) {
          final progress =
              _videoController!.value.position.inSeconds / duration;
          context.read<CoursePlayerCubit>().updateProgress(progress);
        }
      }
    });

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _disposed = true;
    _savePosition();
    _chewieController?.dispose();
    _videoController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Player')),
      body: BlocConsumer<CoursePlayerCubit, CoursePlayerState>(
        listener: (context, state) async {
          if (state is PlayerReady) {
            final course = state.course;
            if (course.type == 'video' && course.contentUrl != null) {
              await _initVideo(
                  course.contentUrl!, state.lastPositionSeconds);
            }
          }
          if (state is CompletedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Course completed!')),
            );
            if (state.certificate != null) {
              showDialog(
                context: context,
                builder: (_) => _CertificateDialog(
                  cert: state.certificate!,
                  onDownload: () {},
                ),
              );
            }
            if (context.mounted) context.pop();
          }
        },
        builder: (context, state) {
          if (state is PlayerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlayerReady || state is ProgressUpdated || state is CompletionReady) {
            final course = state is PlayerReady
                ? state.course
                : (state is ProgressUpdated
                    ? null
                    : null);

            return Column(
              children: [
                if (state is ProgressUpdated || state is CompletionReady)
                  LinearProgressIndicator(
                    value: state is ProgressUpdated
                        ? (state as ProgressUpdated).percent
                        : 1.0,
                  ),
                Expanded(
                  child: _buildContent(state),
                ),
                if (state is CompletionReady)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppButton(
                      label: 'Mark Complete',
                      onPressed: () => context
                          .read<CoursePlayerCubit>()
                          .completeCourse(),
                    ),
                  ),
              ],
            );
          }
          if (state is PlayerError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(CoursePlayerState state) {
    if (state is PlayerReady) {
      final course = state.course;
      if (course.type == 'video') {
        if (_chewieController != null) {
          return Chewie(controller: _chewieController!);
        }
        return const Center(child: CircularProgressIndicator());
      }
      if (course.type == 'pdf' && course.contentUrl != null) {
        return const Center(
          child: Text('PDF viewer not available in preview'),
        );
      }
      if ((course.type == 'link' || course.type == 'scorm') &&
          course.contentUrl != null) {
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(course.contentUrl!));
        return WebViewWidget(controller: controller);
      }
    }
    return const SizedBox.shrink();
  }
}

class _CertificateDialog extends StatelessWidget {
  final cert;
  final VoidCallback onDownload;

  const _CertificateDialog({required this.cert, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium_rounded,
              size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          Text('You have earned a certificate for ${cert.courseName}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download),
          label: const Text('Download'),
        ),
      ],
    );
  }
}
