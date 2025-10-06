// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:flutter/material.dart';

class EditCommunity extends StatefulWidget {
  final String communityId;

  const EditCommunity({Key? key, required this.communityId}) : super(key: key);

  @override
  _EditCommunityState createState() => _EditCommunityState();
}

class _EditCommunityState extends State<EditCommunity> {
  List<Map<String, dynamic>> players = [];
  bool isLoading = true;
  final Api api = Api();
  final String baseUrl = 'https://calmletics-production.up.railway.app';

  final TextEditingController _communityNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlayersAndCommunityName();
  }

  Future<void> fetchPlayersAndCommunityName() async {
    try {
      final data = await Api.fetchCommunityplayerInEdit(widget.communityId);
      final nameFromFirstPlayer =
          data.isNotEmpty ? data[0]['community_name'] ?? '' : '';

      setState(() {
        players = data;
        _communityNameController.text = nameFromFirstPlayer;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching players: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 226, 226, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 226, 226, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تعديل المجتمع',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: bgcolor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _communityNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'اكتب اسم المجتمع',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'اللاعبون',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: const BoxDecoration(
                      color: bgcolor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final imagePath = player['image'];
                        final imageUrl =
                            imagePath != null && imagePath.isNotEmpty
                                ? (imagePath.startsWith('assets/')
                                    ? imagePath
                                    : '$baseUrl$imagePath')
                                : 'assets/images/avatar5.png';

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: imageUrl.startsWith('assets/')
                                ? AssetImage(imageUrl) as ImageProvider
                                : NetworkImage(imageUrl),
                            backgroundColor: Colors.grey[200],
                          ),
                          title: Text(
                            player['player_name'] ?? 'Unknown',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            player['status_message'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => removePlayerDialog(
                              context,
                              player['player_id'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: bgcolor,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final newName = _communityNameController.text.trim();

                  if (newName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a community name'),
                      ),
                    );
                    return;
                  }

                  final result = await Api.updateCommunityName(
                    widget.communityId,
                    newName,
                  );

                  if (result["success"] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result["message"] ?? "Community name updated",
                        ),
                      ),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result["error"] ?? "Failed to update name",
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removePlayerDialog(BuildContext context, int playerId) async {
    bool isDeleting = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(218, 43, 82, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 235, 228, 1),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Color.fromRGBO(218, 43, 82, 1),
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "حذف لاعب",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'سيتم حذف حساب اللاعب وكل بياناته المرتبطة بشكل نهائي. هل تريد المتابعة؟',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        SizedBox(
                          width: 145,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color.fromRGBO(78, 78, 78, 1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              "الغاء",
                              style: TextStyle(
                                color: Color.fromRGBO(78, 78, 78, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Delete button
                        SizedBox(
                          width: 145,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : () async {
                                    setState(() => isDeleting = true);
                                    try {
                                      final result = await Api.removePlayer(
                                        playerId,
                                      );

                                      if (result['success'] == true) {
                                        // Remove player from local list and update UI
                                        setState(() {
                                          players.removeWhere(
                                            (p) => p['player_id'] == playerId,
                                          );
                                        });

                                        Navigator.pop(context);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(result['message']),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['error'] ??
                                                  'Failed to remove player',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } finally {
                                      setState(() => isDeleting = false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                218,
                                43,
                                82,
                                1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'حذف',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
