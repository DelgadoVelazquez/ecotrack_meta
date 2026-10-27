import 'package:flutter/material.dart';

import '../dominio/consumo.dart';

class RegistroVista extends StatefulWidget {
  final String? error;
  final bool guardando;
  final Future<bool> Function(String laboratorio, String litros) onGuardar;

  const RegistroVista({
    super.key,
    required this.error,
    required this.guardando,
    required this.onGuardar,
  });

  @override
  State<RegistroVista> createState() => _RegistroVistaState();
}

class _RegistroVistaState extends State<RegistroVista> {
  String _labSeleccionado = laboratoriosUtez.first;
  final TextEditingController _litrosController = TextEditingController();

  @override
  void dispose() {
    _litrosController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await widget.onGuardar(_labSeleccionado, _litrosController.text);
    if (ok && mounted) {
      _litrosController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consumo guardado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButton<String>(
            value: _labSeleccionado,
            items: laboratoriosUtez
                .map((lab) => DropdownMenuItem(value: lab, child: Text(lab)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _labSeleccionado = val);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('litros'),
            controller: _litrosController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: widget.error,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.guardando ? null : _submit,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class HistorialVista extends StatelessWidget {
  final List<Consumo> consumos;
  final double total;

  const HistorialVista({
    super.key,
    required this.consumos,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (consumos.isEmpty) {
      return const Center(child: Text('Sin consumos'));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Total: ${total.toStringAsFixed(1)} L',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...consumos.map(
          (c) => ListTile(
            title: Text(c.laboratorio),
            trailing: Text('${c.litros.toStringAsFixed(1)} L'),
          ),
        ),
      ],
    );
  }
}

class MetaVista extends StatelessWidget {
  final double total;
  final double meta;
  final bool metaSuperada;
  final VoidCallback onSubir;
  final VoidCallback onBajar;

  const MetaVista({
    super.key,
    required this.total,
    required this.meta,
    required this.metaSuperada,
    required this.onSubir,
    required this.onBajar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Usado: ${total.toStringAsFixed(1)} de ${meta.toStringAsFixed(1)} L',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            metaSuperada ? 'Te pasaste de la meta' : 'Dentro de la meta',
            style: TextStyle(
              color: metaSuperada ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                key: const Key('bajarMeta'),
                icon: const Icon(Icons.remove),
                onPressed: onBajar,
              ),
              const SizedBox(width: 16),
              IconButton(
                key: const Key('subirMeta'),
                icon: const Icon(Icons.add),
                onPressed: onSubir,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
