import 'package:flutter/material.dart';
import 'package:lubinpla/helpers/pref_data.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/screens/project_name_search.dart';
import 'package:lubinpla/screens/user_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagementSection extends StatefulWidget {
  final SectionData data;
  final ValueChanged<SectionData> onDataChanged;
  final Function(String field, List<Map<String, String>> selectedUsers)
      onUserSelected;

  const ManagementSection({
    super.key,
    required this.data,
    required this.onDataChanged,
    required this.onUserSelected,
  });

  @override
  State<ManagementSection> createState() => _ManagementSectionState();
}

class _ManagementSectionState extends State<ManagementSection> {
  late TextEditingController _projectNameController;
  late TextEditingController _ownerController;
  late TextEditingController _collaboratorController;
  late TextEditingController _shareController;

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
    _ownerController = TextEditingController(text: givenName);
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
      _ownerController.text = widget.data.owner;
    }
    if (oldWidget.data.collaborator != widget.data.collaborator) {
      _collaboratorController.text = widget.data.collaborator?['name'] ?? '';
    }
    if (oldWidget.data.share != widget.data.share) {
      _shareController.text =
          widget.data.share.map((user) => user['name']).join(', ');
    }
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
              ),

              // Owner Field
              _buildField(
                label: '담당자 *',
                controller: _ownerController
                  ..text = '', // Clear controller text
                onTap: () {},
                hintText: widget.data.owner == null
                    ? 'Choose an Owner'
                    : '', // Hide hint when owner is selected
                prefixIcon: FutureBuilder(
                  future: _getOwnerDetailsFromPrefs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasData && widget.data.owner != null) {
                      final ownerData = snapshot.data as Map<String, String>;
                      final profilePic = ownerData['profilePic'] ??
                          ''; // Retrieve profilePic, fallback to empty if null

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: profilePic.isNotEmpty
                                ? NetworkImage(profilePic)
                                : AssetImage('assets/default_profile_pic.png'),
                            radius:
                                18, // Radius of the CircleAvatar, adjust as needed
                            backgroundColor: Colors.grey.shade100,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${ownerData['givenName']} ${ownerData['surname']}', // Full name
                            style: const TextStyle(
                              color: Colors.black, // Set text color to black
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }

                    return SizedBox
                        .shrink(); // Show nothing if data isn't ready
                  },
                ),
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
                          Text(
                            widget.data.collaborator!['name'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.black, // Set text color to black
                              fontSize: 16,
                            ),
                          ),
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
                                  child: Text(
                                    user['name'] ?? 'Unknown',
                                    style: const TextStyle(fontSize: 16),
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
