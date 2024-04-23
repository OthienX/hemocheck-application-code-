import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'results.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class StartTest extends StatefulWidget {
  const StartTest({super.key});

  @override
  _StartTestState createState() => _StartTestState();
}

class _StartTestState extends State<StartTest> {
  late CameraController _cameraController;
  XFile? _videoFile;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  VideoPlayerController? _videoPlayerController;
  bool _isFiberVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _startRecording() async {
    try {
      await _cameraController.startVideoRecording();
      _isRecording = true;
      _startVibrationLoop();
      setState(() {
        _isFiberVisible = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to start recording'),
        ),
      );
    }
  }

  void _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;
    try {
      XFile videoFile = await _cameraController.stopVideoRecording();
      _isRecording = false;
      _stopVibrationLoop();
      setState(() {
        _videoFile = videoFile;
        _videoPlayerController = VideoPlayerController.file(File(_videoFile!.path));
        _videoPlayerController!.initialize().then((_) {
          setState(() {});
        });
        _isFiberVisible = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to stop recording'),
        ),
      );
    }
  }


  void _startVibrationLoop() async {
    while (_isRecording) {
      await Vibration.vibrate(duration: 2000, pattern: [500, 1000], intensities: [128, 255]);
      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  void _stopVibrationLoop() {
    Vibration.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Test'),
        centerTitle: true,
        leading: Container(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _isCameraInitialized ? _buildCameraPreview() : const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (_videoFile != null) ...[
            _buildVideoPreview(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => SubmitPopup.show(context, _videoFile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _cameraController.value.isInitialized
              ? CameraPreview(_cameraController)
              : const Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          top: 16.0,
          right: 16.0,
          child: _isFiberVisible
              ? const SizedBox(
            width: 20,
            height: 20,
            child: BlinkingIcon(),
          )
              : const SizedBox(),
        ),
        Positioned(
          bottom: 16.0,
          right: 0,
          child: FloatingActionButton(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            backgroundColor: _isRecording ? Colors.red : Colors.white,
            child: _isRecording ? const Icon(Icons.stop) : const Icon(Icons.fiber_manual_record),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _videoPlayerController != null && _videoPlayerController!.value.isInitialized
              ? AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          )
              : Container(),
          IconButton(
            icon: Icon(_videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                if (_videoPlayerController!.value.isPlaying) {
                  _videoPlayerController!.pause();
                } else {
                  _videoPlayerController!.play();
                }
              });
            },
          ),
        ],
      ),
    );
  }



  Future<void> _initializeCameraController() async {
    bool hasPermission = await _checkCameraPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission not granted'),
        ),
      );
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cameras found'),
        ),
      );
      return;
    }

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );

    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to initialize camera'),
        ),
      );
    }
  }

  Future<bool> _checkCameraPermission() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    if (!cameraPermissionStatus.isGranted) {
      PermissionStatus status = await Permission.camera.request();
      return status.isGranted;
    }
    return true;
  }
}

class SubmitPopup {
  static Future<void> show(BuildContext context, XFile? videoFile) async {
    String textInput = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  textInput = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Dosage Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Retrieve device date
                DateTime now = DateTime.now();
                String formattedDate = '${now.year}-${now.month}-${now.day}';

                // Show circular loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const CircularProgressIndicator();
                  },
                );

                // Perform action to send data to FastAPI server
                await _sendDataToServer(context, formattedDate, textInput, videoFile);

                // Close the dialog
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the SubmitPopup dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _sendDataToServer(BuildContext context, String date, String text, XFile? videoFile) async {
    if (videoFile != null) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse('https://smarthemo.pythonanywhere.com/extract'));
        request.fields['date'] = date;
        request.fields['text'] = text;

        File videoFileObj = File(videoFile.path);

        request.files.add(
          http.MultipartFile.fromBytes(
            'video',
            await videoFile.readAsBytes(),
            filename: 'video.mp4',
            contentType: MediaType('video', 'mp4'),
          ),
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        var response = await request.send();

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultsPage(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data was sent successfully'),
            ),
          );
        } else {
          final String errorMessage = await response.stream.bytesToString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send data. Error: $errorMessage'),
            ),
          );
        }
      } on SocketException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No internet connection'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error sending data'),
          ),
        );
      } finally {
        Navigator.of(context).pop();
      }
    }
  }
}

class BlinkingIcon extends StatefulWidget {
  const BlinkingIcon({super.key});

  @override
  _BlinkingIconState createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible ? const Icon(Icons.fiber_manual_record_sharp,
    color: Colors.red,) : SizedBox();
  }
}

