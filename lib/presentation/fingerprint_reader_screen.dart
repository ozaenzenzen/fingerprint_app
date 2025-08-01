// Example usage widget
import 'package:fingerprint_app/service/fingerprint_capture_service.dart';
import 'package:flutter/material.dart';

class FingerprintReaderWidget extends StatefulWidget {
  const FingerprintReaderWidget({
    super.key,
  });

  @override
  State<FingerprintReaderWidget> createState() => _FingerprintReaderWidgetState();
}

class _FingerprintReaderWidgetState extends State<FingerprintReaderWidget> {
  List<String> _readers = [];
  String _status = 'Not initialized';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReaders();
  }

  Future<void> _loadReaders() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading readers...';
    });

    try {
      final readers = await FingerprintCaptureService.getAvailableReaders();
      setState(() {
        _readers = readers;
        _status = readers.isEmpty ? 'No readers found' : '${readers.length} reader(s) found';
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading readers: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeReader(int index) async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing reader...';
    });

    try {
      final success = await FingerprintCaptureService.initializeReader(index);
      final readerInfo = await FingerprintCaptureService.getReaderInfo(index);

      setState(() {
        _status = success ? 'Reader initialized: ${readerInfo?['name'] ?? 'Unknown'}' : 'Failed to initialize reader';
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing reader: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fingerprint Readers'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Status: $_status',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _loadReaders,
                        child: Text('Refresh Readers'),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Available Readers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _readers.isEmpty
                  ? Center(child: Text('No readers available'))
                  : ListView.builder(
                      itemCount: _readers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_readers[index]),
                            subtitle: Text('Reader #$index'),
                            trailing: ElevatedButton(
                              onPressed: _isLoading ? null : () => _initializeReader(index),
                              child: Text('Initialize'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
