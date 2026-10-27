import 'package:flutter/material.dart';

import '../datos/consumo_repository.dart';
import '../presentacion/consumos_view_model.dart';
import '../presentacion/vistas.dart';

class AppChangeNotifier extends StatefulWidget {
  final ConsumoRepository repositorio;

  const AppChangeNotifier({super.key, required this.repositorio});

  @override
  State<AppChangeNotifier> createState() => _AppChangeNotifierState();
}

class _AppChangeNotifierState extends State<AppChangeNotifier> {
  late final ConsumosViewModel _vm;
  int _indicePestana = 0;

  @override
  void initState() {
    super.initState();
    _vm = ConsumosViewModel(widget.repositorio)..cargar();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('EcoTrack Meta - ChangeNotifier')),
        body: IndexedStack(
          index: _indicePestana,
          children: [
            RegistroCN(vm: _vm),
            HistorialCN(vm: _vm),
            MetaCN(vm: _vm),
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
      ),
    );
  }
}

class RegistroCN extends StatelessWidget {
  final ConsumosViewModel vm;

  const RegistroCN({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => RegistroVista(
        error: vm.error,
        guardando: vm.guardando,
        onGuardar: vm.guardar,
      ),
    );
  }
}

class HistorialCN extends StatelessWidget {
  final ConsumosViewModel vm;

  const HistorialCN({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => HistorialVista(
        consumos: vm.consumos,
        total: vm.total,
      ),
    );
  }
}

class MetaCN extends StatelessWidget {
  final ConsumosViewModel vm;

  const MetaCN({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => MetaVista(
        total: vm.total,
        meta: vm.meta,
        metaSuperada: vm.metaSuperada,
        onSubir: vm.subirMeta,
        onBajar: vm.bajarMeta,
      ),
    );
  }
}
