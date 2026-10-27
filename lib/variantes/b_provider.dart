import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datos/consumo_repository.dart';
import '../presentacion/consumos_view_model.dart';
import '../presentacion/vistas.dart';

class AppProvider extends StatelessWidget {
  final ConsumoRepository repositorio;

  const AppProvider({super.key, required this.repositorio});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConsumosViewModel>(
      create: (_) => ConsumosViewModel(repositorio)..cargar(),
      child: const MaterialApp(
        home: _AppProviderNavegacion(),
      ),
    );
  }
}

class _AppProviderNavegacion extends StatefulWidget {
  const _AppProviderNavegacion();

  @override
  State<_AppProviderNavegacion> createState() => _AppProviderNavegacionState();
}

class _AppProviderNavegacionState extends State<_AppProviderNavegacion> {
  int _indicePestana = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcoTrack Meta - Provider')),
      body: IndexedStack(
        index: _indicePestana,
        children: const [
          RegistroProvider(),
          HistorialProvider(),
          MetaProvider(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indicePestana,
        onTap: (i) => setState(() => _indicePestana = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Meta',
          ),
        ],
      ),
    );
  }
}

class RegistroProvider extends StatelessWidget {
  const RegistroProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return RegistroVista(
      error: vm.error,
      guardando: vm.guardando,
      onGuardar: (lab, litros) =>
          context.read<ConsumosViewModel>().guardar(lab, litros),
    );
  }
}

class HistorialProvider extends StatelessWidget {
  const HistorialProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return HistorialVista(
      consumos: vm.consumos,
      total: vm.total,
    );
  }
}

class MetaProvider extends StatelessWidget {
  const MetaProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return MetaVista(
      total: vm.total,
      meta: vm.meta,
      metaSuperada: vm.metaSuperada,
      onSubir: () => context.read<ConsumosViewModel>().subirMeta(),
      onBajar: () => context.read<ConsumosViewModel>().bajarMeta(),
    );
  }
}
