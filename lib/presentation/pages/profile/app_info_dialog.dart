import 'package:flutter/material.dart';
import '../../../config/app_config.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('앱 정보'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기본 정보
            _buildInfoRow('앱 이름', AppConfig.appName),
            const SizedBox(height: 8),
            _buildInfoRow('버전', AppConfig.appVersion),
            const SizedBox(height: 8),
            _buildInfoRow('패키지', AppConfig.packageName),
            
            const Divider(height: 24),
            
            // 저작권 정보
            const Text(
              '저작권',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '© 2024 Household Ledger\n모든 권리 보유.',
              style: TextStyle(fontSize: 14),
            ),
            
            const Divider(height: 24),
            
            // 라이센스 정보
            const Text(
              '오픈소스 라이센스',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildLicenseItem('Flutter', 'BSD 3-Clause License'),
            _buildLicenseItem('BLoC Pattern', 'MIT License'),
            _buildLicenseItem('Dio', 'MIT License'),
            _buildLicenseItem('fl_chart', 'MIT License'),
            _buildLicenseItem('intl', 'BSD 3-Clause License'),
            _buildLicenseItem('shared_preferences', 'BSD 3-Clause License'),
            
            // 더 많은 라이센스 정보 보기 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showLicensePage(context);
              },
              child: const Text('전체 라이센스 보기'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('확인'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseItem(String package, String license) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              package,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            license,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showLicensePage(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: AppConfig.appName,
      applicationVersion: AppConfig.appVersion,
      applicationIcon: Image.asset(
        'assets/icon/icon.png',
        width: 64,
        height: 64,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.apps, size: 64);
        },
      ),
    );
  }
}

