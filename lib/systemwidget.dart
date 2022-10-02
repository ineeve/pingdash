import 'dart:math';

import 'package:dart_ping/dart_ping.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemWidget extends StatefulWidget {
  const SystemWidget({super.key, required this.ip, required this.deleteCb});

  final String ip;
  final Function deleteCb;
  @override
  State<SystemWidget> createState() => _SystemWidgetState();
}

class _SystemWidgetState extends State<SystemWidget> {
  final Color lineColor = Colors.amber;
  late Ping _ping;
  List<int> _seqs = [];
  List<FlSpot> _latencies = [];
  String _latency = '-1';
  String _seq = '0';
  String _errorString = '';
  final TextEditingController _titleController = TextEditingController();
  final limitCount = 60;
  bool _mute = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.ip;
    _ping = Ping(widget.ip);

    // Begin ping process and listen for output
    _ping.stream.listen((event) {
      if (event.error != null) {
        if (!_mute) {
          SystemSound.play(SystemSoundType.alert);
        }
        setState(() {
          _errorString = event.error!.message ?? '';
        });
        return;
      }
      setState(() {
        _latency = event.response?.time!.inMilliseconds.toString() ?? "-1";
        _seq = event.response?.seq.toString() ?? "-1";

        if (event.error == null && event.response != null) {
          _latencies.add(FlSpot(event.response!.seq!.toDouble(),
              event.response!.time!.inMilliseconds.toDouble()));
          _seqs.add(event.response!.seq!.toInt());
        }
        if (_latencies.length > limitCount) {
          _latencies.removeAt(0);
          _seqs.removeAt(0);
        }
        _latencies = [..._latencies];
        _seqs = [..._seqs];
      });
    });
  }

  @override
  void dispose() {
    _ping.stop();
    super.dispose();
  }

  LineChartBarData latencyLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
          colors: [lineColor.withOpacity(0), lineColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.1, 1.0]),
      barWidth: 4,
      isCurved: false,
    );
  }

  Widget muteIcon(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            _mute = !_mute;
          });
        },
        icon:
            _mute ? const Icon(Icons.volume_off) : const Icon(Icons.volume_up));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: TextField(
              controller: _titleController,
              decoration:
                  const InputDecoration.collapsed(hintText: 'system name'),
            )),
            const Spacer(),
            muteIcon(context),
            IconButton(
                onPressed: () {
                  widget.deleteCb(widget.ip);
                },
                icon: const Icon(Icons.delete)),
          ]),
          _errorString.isNotEmpty
              ? Text(
                  _errorString,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                )
              : const SizedBox.shrink(),
          Row(
            children: [
              const Text("Seq: "),
              Text(_seq),
              const Text("; Latency: "),
              Text(_latency),
              const Text("ms")
            ],
          ),
          const SizedBox(height: 10),
          _latencies.length > 1
              ? Expanded(
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: _latencies.map((e) => e.y).reduce(max),
                      minX: _seqs.first.toDouble(),
                      maxX: _seqs.last.toDouble(),
                      lineTouchData: LineTouchData(enabled: false),
                      clipData: FlClipData.all(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      lineBarsData: [
                        latencyLine(_latencies),
                      ],
                      titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false))),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ]));
  }
}
