# EcoTrack Meta - Gestión de Estado (ChangeNotifier vs Provider)

## 1. ViewModel con ChangeNotifier
- `ConsumosViewModel` extiende `ChangeNotifier` de `flutter/foundation.dart`.
- Centraliza el estado (`consumos`, `meta`, `error`, `guardando`) y las reglas de negocio.
- Los campos calculados (`total`, `avance`, `metaSuperada`) son getters derivados del estado.

## 2. Variante A: ChangeNotifier puro (`a_change_notifier.dart`)
- El ViewModel se pasa manualmente mediante el constructor (`required this.vm`).
- Se usa `ListenableBuilder` para escuchar los cambios del ViewModel y reconstruir los widgets.
- El ciclo de vida (`dispose()`) debe ser gestionado explícitamente en el widget padre.

## 3. Variante B: Provider (`b_provider.dart`)
- Se inserta el ViewModel en el árbol de widgets usando `ChangeNotifierProvider`.
- Los adaptadores acceden al ViewModel mediante `context.watch<ConsumosViewModel>()` para escuchar y redibujar la UI.
- Los callbacks y acciones usan `context.read<ConsumosViewModel>()` para ejecutar métodos sin provocar redibujos innecesarios.
