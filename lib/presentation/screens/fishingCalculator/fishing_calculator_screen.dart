import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:gemini_app/presentation/widgets/buttons/gradientButton.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gemini_app/config/theme/app_theme.dart';

/// Modelo simple
class ImageWithCaption {
  final XFile file;
  String caption;

  ImageWithCaption({required this.file, this.caption = ''});
}

/// Notifier que guarda la lista de (imagen + texto)
class GalleryImagesNotifier extends StateNotifier<List<ImageWithCaption>> {
  GalleryImagesNotifier() : super([]);

  /// Añade una nueva imagen con caption inicial vacío
  void addImage(XFile file) {
    state = [...state, ImageWithCaption(file: file)];
  }

  /// Actualiza la leyenda (caption) de la imagen en la posición [index]
  void updateCaption(int index, String newCaption) {
    if (index < 0 || index >= state.length) return;
    final copy = [...state];
    copy[index].caption = newCaption;
    state = copy;
  }
}

/// Provider público para la lista de ImageWithCaption
final galleryImagesProvider =
    StateNotifierProvider<GalleryImagesNotifier, List<ImageWithCaption>>(
      (ref) => GalleryImagesNotifier(),
    );

/// Provider para guardar el índice de página actual (0 = “Agregar imagen”)
final currentPageProvider = StateProvider<int>((ref) => 0);

/// Pantalla principal
class FishingCalculatorScreen extends ConsumerStatefulWidget {
  const FishingCalculatorScreen({super.key});

  

  @override
  ConsumerState<FishingCalculatorScreen> createState() =>
      _FishingCalculatorScreenState();
}

class _FishingCalculatorScreenState
    extends ConsumerState<FishingCalculatorScreen> {
  late final PageController _pageController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(viewportFraction: 0.6, initialPage: 0);

    _textController = TextEditingController();

    // Listener para detectar cambios de página en el PageView
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      final current = ref.read(currentPageProvider);
      if (newPage != current) {
        // Actualizamos el provider del índice actual
        ref.read(currentPageProvider.notifier).state = newPage;

        // Obtenemos la lista de imágenes + leyendas
        final imagesList = ref.read(galleryImagesProvider);
        if (newPage == 0) {
          // Si estamos en “Agregar imagen”, limpiamos el TextField
          _textController.text = '';
        } else {
          // Si estamos en una imagen real, cargamos la leyenda guardada
          final idx = newPage - 1; // porque index 0 = tarjeta “Añadir”
          if (idx >= 0 && idx < imagesList.length) {
            _textController.text = imagesList[idx].caption;
          } else {
            _textController.text = '';
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userProvider);
    // Obtenemos la lista actualizada de (imagen + caption)
    final imagesWithCaptions = ref.watch(galleryImagesProvider);
    // Obtenemos el índice de página activo
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fishing AI')),
      backgroundColor: lightBlue,
      body: Column(
        children: [
          //* ------------------------------
          //* 1) Carrusel de imágenes (o “Añadir imagen”)
          //* ------------------------------
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              padEnds: true,
              itemCount: imagesWithCaptions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Tarjeta “Añadir imagen”
                  return _AddImageCard(onTap: () => _showImageSourceOptions());
                } else {
                  // Tarjeta que muestra la foto existente
                  final pair = imagesWithCaptions[index - 1];
                  return _ImageCard(file: pair.file);
                }
              },
            ),
          ),

          const SizedBox(height: 8),

          //* ------------------------------
          //* 2) Campo de texto que cambia según la imagen
          //* ------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _textController,
              enabled:
                  currentPage != 0, // Solo editable si no estamos en “Agregar”
              decoration: InputDecoration(
                hintText:
                    currentPage == 0
                        ? 'Desliza a una imagen para agregar texto'
                        : null, // eliminamos hint si queremos mostrar botón
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon:
                    currentPage != 0
                        ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GradientButton(onPressed: () => {
                            generateCaption(imagesWithCaptions[currentPage - 1])

                          }),
                        )
                        : null,
              ),

              maxLines: null,
              onChanged: (nuevoTexto) {
                // Cada vez que cambia el texto, lo guardamos en el notifier
                if (currentPage > 0) {
                  final idx = currentPage - 1;
                  ref
                      .read(galleryImagesProvider.notifier)
                      .updateCaption(idx, nuevoTexto);
                }
              },
            ),
          ),

          const SizedBox(height: 16),
          // … aquí podrías insertar más widgets, un botón, etc.
        ],
      ),
    );
  }

  /// Muestra el BottomSheet para elegir origen de imagen
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Añadir imagen',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Tomar foto'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? photo = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1024,
                      maxHeight: 1024,
                      imageQuality: 85,
                    );
                    if (photo != null) {
                      ref.read(galleryImagesProvider.notifier).addImage(photo);
                      // Como agregamos una imagen nueva, queremos saltar a ella:
                      // Esperamos unos milisegundos para que PageView se reconstruya
                      Future.delayed(const Duration(milliseconds: 100), () {
                        final newIndex = ref.read(galleryImagesProvider).length;
                        _pageController.animateToPage(
                          newIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Seleccionar de galería'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1024,
                      maxHeight: 1024,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      ref.read(galleryImagesProvider.notifier).addImage(picked);
                      Future.delayed(const Duration(milliseconds: 100), () {
                        final newIndex = ref.read(galleryImagesProvider).length;
                        _pageController.animateToPage(
                          newIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

generateCaption(ImageWithCaption imagesWithCaption) {
  print(imagesWithCaption);
  
}

/// Tarjeta “Añadir imagen”
class _AddImageCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddImageCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // o Theme.of(context).cardColor
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Añadir imagen',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta que muestra la imagen seleccionada
class _ImageCard extends StatelessWidget {
  final XFile file;
  const _ImageCard({required this.file});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(file.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
