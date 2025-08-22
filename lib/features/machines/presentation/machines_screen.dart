import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../providers/machine_providers.dart';
import '../models/machine_data.dart';

class MachinesScreen extends ConsumerWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machinesAsync = ref.watch(allMachinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Machines IoT'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: machinesAsync.when(
        data: (machines) => machines.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.precision_manufacturing, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Aucune machine connectée'),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: machines.length,
                itemBuilder: (context, index) {
                  final machine = machines[index];
                  return MachineCard(machine: machine);
                },
              ),
        loading: () => const LoadingWidget(message: 'Chargement des machines...'),
        error: (error, stack) => ErrorDisplayWidget(
          message: 'Erreur de chargement: $error',
          onRetry: () => ref.invalidate(allMachinesProvider),
        ),
      ),
    );
  }
}

class MachineCard extends StatelessWidget {
  final MachineData machine;

  const MachineCard({super.key, required this.machine});

  @override
  Widget build(BuildContext context) {
    final isHighLevel = machine.currentNiveau == 'HAUT';
    final statusColor = isHighLevel ? Colors.green : Colors.orange;
    final statusIcon = isHighLevel ? Icons.water_drop : Icons.water_drop_outlined;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MachineDetailScreen(machineId: machine.machineId),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.precision_manufacturing,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      machine.machineId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          machine.currentNiveau,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Dernière mise à jour: ${DateFormat('dd/MM/yyyy HH:mm').format(machine.lastUpdate)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event_note, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${machine.events.length} événements',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Voir détails →',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MachineDetailScreen extends ConsumerWidget {
  final String machineId;

  const MachineDetailScreen({super.key, required this.machineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machineAsync = ref.watch(machineProvider(machineId));
    final eventsAsync = ref.watch(machineEventsProvider(machineId));

    return Scaffold(
      appBar: AppBar(
        title: Text(machineId),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(machineProvider(machineId));
              ref.invalidate(machineEventsProvider(machineId));
            },
          ),
        ],
      ),
      body: machineAsync.when(
        data: (machine) {
          if (machine == null) {
            return const Center(
              child: Text('Machine non trouvée'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'État actuel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              machine.currentNiveau == 'HAUT' 
                                  ? Icons.water_drop 
                                  : Icons.water_drop_outlined,
                              color: machine.currentNiveau == 'HAUT' 
                                  ? Colors.green 
                                  : Colors.orange,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Niveau: ${machine.currentNiveau}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm:ss').format(machine.lastUpdate),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Historique des événements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                eventsAsync.when(
                  data: (events) => events.isEmpty
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: Text('Aucun événement'),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  event.niveau == 'HAUT' 
                                      ? Icons.water_drop 
                                      : Icons.water_drop_outlined,
                                  color: event.niveau == 'HAUT' 
                                      ? Colors.green 
                                      : Colors.orange,
                                ),
                                title: Text('Niveau: ${event.niveau}'),
                                subtitle: Text(
                                  DateFormat('dd/MM/yyyy HH:mm:ss').format(event.timestamp),
                                ),
                                trailing: Text(
                                  DateFormat('HH:mm').format(event.timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  loading: () => const LoadingWidget(message: 'Chargement des événements...'),
                  error: (error, stack) => ErrorDisplayWidget(
                    message: 'Erreur de chargement des événements: $error',
                    onRetry: () => ref.invalidate(machineEventsProvider(machineId)),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(message: 'Chargement de la machine...'),
        error: (error, stack) => ErrorDisplayWidget(
          message: 'Erreur de chargement: $error',
          onRetry: () => ref.invalidate(machineProvider(machineId)),
        ),
      ),
    );
  }
}