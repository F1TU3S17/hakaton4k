import 'package:flutter/material.dart';
import 'package:hakaton4k/modal/user.dart';

class UserMoreInfo extends StatelessWidget {
  const UserMoreInfo({super.key, required this.theme, required this.userData});

  final User userData;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Кнопка закрытия
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.primary),
                onPressed: () {
                  Navigator.of(context).pop(); // Закрытие модального окна
                },
              ),
            ),
            Row(
              children: [
                // Аватарка пользователя
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
                  child: Text(
                    userData.username.isNotEmpty
                        ? userData.username[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(width: 16),
                // Имя пользователя и email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.username,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userData.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Дополнительная информация
            Divider(color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme: theme,
              icon: Icons.phone,
              title: 'Телефон',
              value: userData.phone,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme: theme,
              icon: Icons.account_box,
              title: 'ID пользователя',
              value: userData.id.toString(),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme: theme,
              icon: Icons.settings,
              title: 'Уровень',
              value: 'Новичок',
            ),
          ],
        ),
      ),
    );
  }

  // Метод для создания строки информации
  Widget _buildInfoRow({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
