import 'package:flutter/material.dart';
// Note: In production, use syncfusion_flutter_pdfviewer or flutter_pdfview
// For web, use url_launcher to open PDF in new tab

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String pdfUrl;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadPdf(context),
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePdf(context),
            tooltip: 'Share',
          ),
        ],
      ),
      body: _buildPdfViewer(),
    );
  }

  Widget _buildPdfViewer() {
    // Placeholder for PDF viewer
    // In production, use:
    // - syncfusion_flutter_pdfviewer for full-featured PDF viewing
    // - flutter_pdfview for simpler use cases
    // - For web: use an iframe or open in new tab
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'PDF Viewer',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          SelectableText(
            pdfUrl,
            style: const TextStyle(fontSize: 12, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Open PDF URL
              // In production, use url_launcher
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open PDF'),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Column(
              children: [
                Icon(Icons.info_outline, color: Colors.amber),
                SizedBox(height: 8),
                Text(
                  'To enable full PDF viewing, add syncfusion_flutter_pdfviewer or flutter_pdfview package to pubspec.yaml',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading PDF...')),
    );
    // In production, use dio to download or url_launcher
  }

  void _sharePdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing PDF...')),
    );
    // In production, use share_plus package
  }
}
