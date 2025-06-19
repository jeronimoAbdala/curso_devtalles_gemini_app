import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainBlue = const Color(0xFF00B4D8);
    final Color lightBlue = const Color(0xFFE6F7FC);

    // TODO: Reemplaza estos datos por tus providers
    final String userName = 'Pescador Experto';
    final bool isPro = true;
    final String userDescription = 'Pescador apasionado desde 2020';
    final String location = 'Buenos Aires, Argentina';
    final String memberSince = 'Miembro desde junio 2024';
    final String profileImageUrl = '';
    // final profileImageUrl = 'https://...';

    // TODO: Reemplaza por providers de estadísticas
    final int species = 23;
    final int trophies = 5;
    final int followers = 156;
    final double rating = 4.8;
    final int achievements = 12;
    final int aiAccuracy = 89;

    return Scaffold(
      backgroundColor: lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainBlue, mainBlue.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/logo.png', // TODO: Cambia por tu logo
                          width: 36,
                          height: 36,
                          errorBuilder: (_, __, ___) => const Icon(Icons.sailing, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Fish AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                      child: const Text('Join to waitlist'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Perfil
              Center(
                child: Container(
                  width: 400,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: mainBlue.withOpacity(0.15)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: lightBlue,
                            backgroundImage: profileImageUrl.isNotEmpty ? NetworkImage(profileImageUrl) : null,
                            child: profileImageUrl.isEmpty
                                ? const Icon(Icons.person, size: 48, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: mainBlue,
                              radius: 16,
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          if (isPro)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: mainBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('Pro', style: TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(userDescription, style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue, size: 18),
                          const SizedBox(width: 4),
                          Text(location, style: const TextStyle(color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                          const SizedBox(width: 4),
                          Text(memberSince, style: const TextStyle(color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Editar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person_add_alt_1, size: 18),
                            label: const Text('Seguir'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Icon(Icons.chat_bubble_outline, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Estadísticas
              Center(
                child: Container(
                  width: 400,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: mainBlue.withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estadísticas del Pescador',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 16,
                        children: [
                          _StatIcon(
                            icon: Icons.bubble_chart,
                            value: species.toString(),
                            label: 'Especies',
                            color: mainBlue,
                          ),
                          _StatIcon(
                            icon: Icons.emoji_events,
                            value: trophies.toString(),
                            label: 'Trofeos',
                            color: mainBlue,
                          ),
                          _StatIcon(
                            icon: Icons.group,
                            value: followers.toString(),
                            label: 'Seguidores',
                            color: mainBlue,
                          ),
                          _StatIcon(
                            icon: Icons.star,
                            value: rating.toString(),
                            label: 'Rating',
                            color: Colors.orange,
                          ),
                          _StatIcon(
                            icon: Icons.emoji_flags,
                            value: achievements.toString(),
                            label: 'Logros',
                            color: Colors.green,
                          ),
                          _StatIcon(
                            icon: Icons.track_changes,
                            value: '$aiAccuracy%',
                            label: 'Precisión IA',
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // TODO: Aquí puedes agregar más secciones (galería, actividad, etc.)
            ],
          ),
        ),
      ),
    );
  }
}

class _StatIcon extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatIcon({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color, size: 28),
          radius: 26,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
} 