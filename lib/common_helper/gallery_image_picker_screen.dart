import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImagePickerScreen extends StatefulWidget {
  final bool multiSelection;
  final int maxSelection;

  const GalleryImagePickerScreen({
    this.multiSelection = true,
    this.maxSelection = 5,
    super.key,
  });

  @override
  State<GalleryImagePickerScreen> createState() => _GalleryImagePickerScreenState();
}

class _GalleryImagePickerScreenState extends State<GalleryImagePickerScreen> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> images = [];
  List<AssetEntity> selectedImages = [];
  AssetPathEntity? currentAlbum;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  bool isLoadingAlbums = true; // new flag


  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final PermissionState ps =
    await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      loadAlbums();
    } else {
      PhotoManager.openSetting();
    }
  }


  Future<void> loadAlbums() async {
    setState(() => isLoadingAlbums = true); // start loading

    final albumList = await PhotoManager.getAssetPathList(type: RequestType.all);

    final filteredAlbums = <AssetPathEntity>[];

    for (var album in albumList) {
      final name = album.name.toLowerCase();
      if (name.contains('camera') || name.contains('dcim') || name.contains('screenshot')) {
        continue;
      }

      final media = await album.getAssetListPaged(page: 0, size: 1);
      final hasImage = media.any((asset) => asset.type == AssetType.image);
      if (hasImage) filteredAlbums.add(album);
    }

    if (filteredAlbums.isEmpty) {
      setState(() => isLoadingAlbums = false);
      return;
    }

    setState(() {
      albums = filteredAlbums;
      currentAlbum = filteredAlbums.first;
      isLoadingAlbums = false; // finished loading
    });

    loadImages(currentAlbum!);
  }



  Future<void> loadImages(AssetPathEntity album) async {
    final media = await album.getAssetListPaged(page: 0, size: 500);

    // Only include images, exclude videos completely
    final filtered = media.where((asset) {
      return asset.type == AssetType.image;
    }).toList();

    setState(() => images = filtered);
  }

  void toggleSelection(AssetEntity asset) {
    setState(() {
      if (widget.multiSelection) {
        if (selectedImages.contains(asset)) {
          selectedImages.remove(asset);
        } else {
          if (selectedImages.length < widget.maxSelection) {
            selectedImages.add(asset);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Max ${widget.maxSelection} images allowed")),
            );
          }
        }
      } else {
        selectedImages.clear();
        selectedImages.add(asset);
      }
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) _closeDropdown();
    else _openDropdown();
  }

  void _openDropdown() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeDropdown,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            width: size.width * 0.9,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              followerAnchor: Alignment.topCenter,
              targetAnchor: Alignment.bottomCenter,
              offset: const Offset(0, 15),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      final isSelected = album == currentAlbum;
                      return _buildAlbumTile(album, isSelected);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  Widget _buildAlbumTile(AssetPathEntity album, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() => currentAlbum = album);
        loadImages(album);
        _closeDropdown();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            FutureBuilder<Uint8List?>(
              future: album.getAssetListPaged(page: 0, size: 1).then(
                      (v) => v.isNotEmpty
                      ? v.first.thumbnailDataWithSize(const ThumbnailSize(100, 100))
                      : null),
              builder: (_, snap) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: snap.data != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(snap.data!, fit: BoxFit.cover),
                  )
                      : const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: TextStyle(
                      color: isSelected ? Colors.blueAccent : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<int>(
                    future: album.assetCountAsync,
                    builder: (_, snap) => Text(
                      "${snap.data ?? 0} items",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blueAccent, size: 20),
          ],
        ),
      ),
    );
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopBar(),
      body:  isLoadingAlbums
          ? const Center(child: CircularProgressIndicator()) // show loader
          :_buildImageGrid(),
    );
  }

  AppBar _buildTopBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: CompositedTransformTarget(
        link: _layerLink,
        child: InkWell(
          onTap: _toggleDropdown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  currentAlbum?.name ?? "Gallery",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _isDropdownOpen ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: selectedImages.isEmpty
              ? null
              : () async {
            // Convert AssetEntity to File and filter nulls
            final files = <File>[];
            for (var asset in selectedImages) {
              final file = await asset.file;
              if (file != null) files.add(file);
            }

            Navigator.pop(context, files); // return list of files
          },
          child: Text(
            widget.multiSelection
                ? "Done (${selectedImages.length})"
                : "Done",
            style: TextStyle(
              color: selectedImages.isEmpty ? Colors.grey : Colors.blueAccent,
            ),
          ),
        )

      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final asset = images[index];
        final selectedIndex =
        widget.multiSelection ? selectedImages.indexOf(asset) : -1;

        return GestureDetector(
          onTap: () => toggleSelection(asset),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder<Uint8List?>(
                future: asset.thumbnailDataWithSize(
                    const ThumbnailSize(300, 300)),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(color: Colors.grey[300]);
                  }
                  return Image.memory(snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity);
                },
              ),
              // Dim overlay for multi-selection
              if (widget.multiSelection && selectedIndex != -1)
                Container(color: Colors.black.withOpacity(0.3)),
              // Selection badge
              if (widget.multiSelection && selectedIndex != -1)
                Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      "${selectedIndex + 1}",
                      style:
                      const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
