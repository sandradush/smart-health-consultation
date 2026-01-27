import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final bool isDoctor;

  const VideoCallScreen({
    super.key,
    required this.channelName,
    this.isDoctor = false,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  bool _muted = false;
  bool _videoEnabled = true;
  bool _speakerEnabled = true;
  List<int> _remoteUids = [];

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'YOUR_AGORA_APP_ID',
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() => _remoteUids.add(remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() => _remoteUids.remove(remoteUid));
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: '1000',
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote Video
            if (_remoteUids.isNotEmpty)
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: _remoteUids.first),
                  connection: const RtcConnection(channelId: 'default'),
                ),
              )
            else
               const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Waiting for doctor to join...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

            // Local Video Preview
            if (_videoEnabled)
              Positioned(
                top: 20,
                right: 20,
                child: SizedBox(
                  width: 120,
                  height: 200,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),

            // Top Info Bar
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    StreamBuilder<int>(
                      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
                      builder: (context, snapshot) {
                        final seconds = snapshot.data ?? 0;
                        final duration = Duration(seconds: seconds);
                        return Text(
                          '${duration.inMinutes.toString().padLeft(2, '0')}:'
                          '${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Doctor Info
            if (_remoteUids.isNotEmpty && !widget.isDoctor)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Dr. Alice Uwase - General Physician',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

            // Control Buttons
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mute Button
                  _buildControlButton(
                    icon: _muted ? Icons.mic_off : Icons.mic,
                    backgroundColor: _muted ? Colors.red : Colors.white24,
                    onPressed: () {
                      setState(() => _muted = !_muted);
                      _engine.muteLocalAudioStream(_muted);
                    },
                  ),
                  const SizedBox(width: 20),

                  // Video Button
                  _buildControlButton(
                    icon: _videoEnabled ? Icons.videocam : Icons.videocam_off,
                    backgroundColor: _videoEnabled ? Colors.white24 : Colors.red,
                    onPressed: () {
                      setState(() => _videoEnabled = !_videoEnabled);
                      _engine.enableLocalVideo(_videoEnabled);
                    },
                  ),
                  const SizedBox(width: 20),

                  // Speaker Button
                  _buildControlButton(
                    icon: _speakerEnabled
                        ? Icons.volume_up
                        : Icons.volume_off,
                    backgroundColor: Colors.white24,
                    onPressed: () {
                      setState(() => _speakerEnabled = !_speakerEnabled);
                      _engine.setEnableSpeakerphone(_speakerEnabled);
                    },
                  ),
                  const SizedBox(width: 20),

                  // End Call Button
                  _buildControlButton(
                    icon: Icons.call_end,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      _engine.leaveChannel();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}