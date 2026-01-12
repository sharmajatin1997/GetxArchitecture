import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryVideoPickerScreen extends StatefulWidget {
  final bool multiSelection;
  final int maxSelection;

  const GalleryVideoPickerScreen({
    this.multiSelection = true,
    this.maxSelection = 5,
    super.key,
  });

  @override
  State<GalleryVideoPickerScreen> createState() => _GalleryVideoPickerScreenState();
}

class _GalleryVideoPickerScreenState extends State<GalleryVideoPickerScreen> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> videos = [];
  List<AssetEntity> selectedVideos = [];
  AssetPathEntity? currentAlbum;

  bool isLoadingAlbums = true; // ← new loading flag
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      loadAlbums();
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> loadAlbums() async {
    setState(() => isLoadingAlbums = true); // start loading

    final albumList = await PhotoManager.getAssetPathList(type: RequestType.video);

    final filteredAlbums = <AssetPathEntity>[];

    for (var album in albumList) {
      final name = album.name.toLowerCase();
      if (name.contains('camera') || name.contains('dcim') || name.contains('screenshot')) {
        continue;
      }

      final media = await album.getAssetListPaged(page: 0, size: 1);
      final hasVideo = media.any((asset) => asset.type == AssetType.video);
      if (hasVideo) filteredAlbums.add(album);
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

    loadVideos(currentAlbum!);
  }

  Future<void> loadVideos(AssetPathEntity album) async {
    final media = await album.getAssetListPaged(page: 0, size: 500);
    final filtered = media.where((asset) => asset.type == AssetType.video).toList();

    setState(() => videos = filtered);
  }

  void toggleSelection(AssetEntity asset) {
    setState(() {
      if (widget.multiSelection) {
        if (selectedVideos.contains(asset)) {
          selectedVideos.remove(asset);
        } else {
          if (selectedVideos.length < widget.maxSelection) {
            selectedVideos.add(asset);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Max ${widget.maxSelection} videos allowed")),
            );
          }
        }
      } else {
        selectedVideos.clear();
        selectedVideos.add(asset);
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
                  child: isLoadingAlbums
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : ListView.builder(
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
        loadVideos(album);
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
                      : const Icon(Icons.videocam, color: Colors.grey),
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
      body: isLoadingAlbums
          ? const Center(child: CircularProgressIndicator()) // show loader while albums load
          : _buildVideoGrid(),
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
                  currentAlbum?.name ?? "Videos",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
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
          onPressed: selectedVideos.isEmpty
              ? null
              : () async {
            final files = <File>[];
            for (var asset in selectedVideos) {
              final file = await asset.file;
              if (file != null) files.add(file);
            }
            Navigator.pop(context, files);
          },
          child: Text(
            widget.multiSelection
                ? "Done (${selectedVideos.length})"
                : "Done",
            style: TextStyle(
              color: selectedVideos.isEmpty ? Colors.grey : Colors.blueAccent,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildVideoGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final asset = videos[index];
        final selectedIndex =
        widget.multiSelection ? selectedVideos.indexOf(asset) : -1;

        return GestureDetector(
          onTap: () => toggleSelection(asset),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder<Uint8List?>(
                future: asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) return Container(color: Colors.grey[300]);
                  return Image.memory(snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity);
                },
              ),
              if (widget.multiSelection && selectedIndex != -1)
                Container(color: Colors.black.withOpacity(0.3)),
              if (widget.multiSelection && selectedIndex != -1)
                Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      "${selectedIndex + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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

