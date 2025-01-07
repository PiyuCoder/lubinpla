import 'package:flutter/material.dart';
import 'package:lubinpla/helpers/pref_data.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/screens/project_name_search.dart';
import 'package:lubinpla/screens/user_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagementSection extends StatefulWidget {
  final SectionData data;
  final bool editingMode;
  final ValueChanged<SectionData> onDataChanged;
  final Function(String field, List<Map<String, String>> selectedUsers)
      onUserSelected;

  const ManagementSection({
    super.key,
    required this.data,
    required this.onDataChanged,
    required this.onUserSelected,
    required this.editingMode,
  });

  @override
  State<ManagementSection> createState() => _ManagementSectionState();
}

class _ManagementSectionState extends State<ManagementSection> {
  late TextEditingController _projectNameController;
  late TextEditingController _ownerController;
  late TextEditingController _collaboratorController;
  late TextEditingController _shareController;

  String? _selectedProjectImage; // Holds the path of the selected image

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    String? givenName = await getSavedData('givenName');

    _projectNameController =
        TextEditingController(text: widget.data.projectName);
    _ownerController =
        TextEditingController(text: widget.data.owner?['name'] ?? '');
    _collaboratorController = TextEditingController(
        text: widget.data.collaborator?['name'] ?? ''); // Display name only
    _shareController = TextEditingController(
        text: widget.data.share.map((user) => user['name']).join(', '));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didUpdateWidget(covariant ManagementSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data.projectName != widget.data.projectName) {
      _projectNameController.text = widget.data.projectName;
    }
    if (oldWidget.data.owner != widget.data.owner) {
      _ownerController.text = widget.data.owner?['name'] ?? '';
    }
    if (oldWidget.data.collaborator != widget.data.collaborator) {
      _collaboratorController.text = widget.data.collaborator?['name'] ?? '';
    }
    if (oldWidget.data.share != widget.data.share) {
      _shareController.text =
          widget.data.share.map((user) => user['name']).join(', ');
    }
  }

  Future<String?> _showImageSelectionModal(BuildContext context) async {
    final List<String> images = [
      'assets/project_image1.png',
      'assets/project_image2.png',
      'assets/project_image3.png',
      // Add more image paths
    ];

    return await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, images[index]);
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(images[index]),
                backgroundColor: Colors.grey.shade300,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Name Field
              _buildField(
                label: '프로젝트명 *',
                controller: _projectNameController,
                onTap: () async {
                  final projectName = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectNameSearchScreen(
                        onProjectSelected: (projectName) {
                          widget.onDataChanged(
                              widget.data.copyWith(projectName: projectName));
                        },
                      ),
                    ),
                  );
                  if (projectName != null) {
                    widget.onDataChanged(
                        widget.data.copyWith(projectName: projectName));
                  }
                },
                hintText: '입력해주세요',
                // prefixIcon: GestureDetector(
                //   onTap: () async {
                //     final selectedImage =
                //         await _showImageSelectionModal(context);
                //     if (selectedImage != null) {
                //       setState(() {
                //         _selectedProjectImage = selectedImage;
                //       });
                //     }
                //   },
                //   child: CircleAvatar(
                //     radius: 20,
                //     backgroundImage: _selectedProjectImage != null
                //         ? AssetImage(_selectedProjectImage!)
                //         : const AssetImage('assets/logo.png'),
                //     backgroundColor: Colors.grey.shade300,
                //   ),
                // ),
              ),

              _buildField(
                label: '담당자 *',
                controller: _ownerController
                  ..text = widget.data.owner == null
                      ? ''
                      : '', // Ensure no visible text in the field
                onTap: () async {
                  final selectedUser =
                      await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSearchScreen(
                        userType: 'owner',
                        onUserSelected: (user) {
                          widget.onDataChanged(
                              widget.data.copyWith(owner: user.first));
                        },
                        initialSelectedUsers:
                            widget.editingMode && widget.data.owner != null
                                ? [
                                    widget.data.owner!
                                  ] // Pass the current owner if in editing mode
                                : [], // No initial owner if not in editing mode
                      ),
                    ),
                  );
                  if (selectedUser != null) {
                    widget.onDataChanged(
                      widget.data.copyWith(owner: selectedUser),
                    );
                  }
                },
                hintText: widget.data.owner == null
                    ? 'Choose an Owner'
                    : '', // Show hint only when no owner is selected
                prefixIcon: widget.data.owner != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.data.owner!['profilePic'] ?? '',
                            ),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.owner!['name'] ?? 'Unknown',
                                style: const TextStyle(
                                    color:
                                        Colors.black, // Set text color to black
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.data.owner!['role'] ?? 'Designation',
                                style: const TextStyle(
                                  color:
                                      Colors.black38, // Set text color to black
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : null,
              ),

              // Collaborator Field
              _buildField(
                label: '공동작업자',
                controller: _collaboratorController
                  ..text = widget.data.collaborator != null
                      ? ''
                      : '', // Ensure no visible text in the field
                onTap: () async {
                  final selectedUser =
                      await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSearchScreen(
                        userType: 'collaborator',
                        onUserSelected: (user) {
                          widget.onDataChanged(widget.data.copyWith(
                              collaborator: user.first)); // Use the first user
                        },
                        initialSelectedUsers: widget.data.collaborator != null
                            ? [
                                widget.data.collaborator!
                              ] // If a collaborator is selected, wrap it in a list
                            : [],
                      ),
                    ),
                  );
                  if (selectedUser != null) {
                    widget.onDataChanged(
                      widget.data.copyWith(collaborator: selectedUser),
                    );
                  }
                },
                hintText: widget.data.collaborator == null
                    ? '입력해주세요'
                    : '', // Show hint only when no collaborator is selected
                prefixIcon: widget.data.collaborator != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.data.collaborator!['profilePic'] ?? '',
                            ),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.collaborator!['name'] ?? 'Unknown',
                                style: const TextStyle(
                                    color:
                                        Colors.black, // Set text color to black
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.data.collaborator!['role'] ??
                                    'Designation',
                                style: const TextStyle(
                                  color:
                                      Colors.black38, // Set text color to black
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : null,
              ),

              // Share Field
              _buildField(
                label: '공유',
                controller: _shareController,
                onTap: () async {
                  final selectedUsers =
                      await Navigator.push<List<Map<String, String>>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSearchScreen(
                        userType: 'share',
                        onUserSelected: (user) {
                          widget
                              .onDataChanged(widget.data.copyWith(share: user));
                        },
                        initialSelectedUsers: widget.data.share ?? [],
                      ),
                    ),
                  );
                  if (selectedUsers != null && selectedUsers.isNotEmpty) {
                    widget.onDataChanged(
                      widget.data.copyWith(share: selectedUsers),
                    );
                  }
                },
                hintText: '입력해주세요',
                prefixIcon: widget.data.share != null &&
                        widget.data.share.isNotEmpty
                    ? Column(
                        children: widget.data.share!.map((user) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user['profilePic'] ?? ''),
                                  radius: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name'] ?? 'Unknown',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        user['role'] ?? 'Designation',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : null,
              ),
            ],
          );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    String? hintText,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: controller,
            enabled: false,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

Future<Map<String, String>> _getOwnerDetailsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final givenName = prefs.getString('givenName') ?? 'Unknown';
  final surname = prefs.getString('surname') ?? '';
  final profilePic = prefs.getString('profilePic') ?? ''; // Add if available

  return {
    'givenName': givenName,
    'surname': surname,
    'profilePic': profilePic,
  };
}
