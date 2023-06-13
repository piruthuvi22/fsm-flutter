import 'package:flutter/material.dart';

class JobSearchHeader extends StatefulWidget {
  final FocusNode focusNode;
  final Function(String?, String?) handleFilter;
  final String? searchText;
  final String? searchItem;
  const JobSearchHeader(
      this.focusNode, this.searchText, this.searchItem, this.handleFilter,
      {super.key});

  @override
  State<JobSearchHeader> createState() => _JobSearchHeaderState();
}

class _JobSearchHeaderState extends State<JobSearchHeader> {
  String? searchKey = "";
  String? selectedMenu = "";

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("===========");
    print(widget.searchText);
    textEditingController.text = widget.searchText!;

    setState(() {
      searchKey = widget.searchText;
      // selectedMenu = widget.searchItem;
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void handleSearch() {
    // textEditingController.
    widget.handleFilter(searchKey, selectedMenu);
  }

  void handleReset() {
    textEditingController.text = "";
    widget.handleFilter("", selectedMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.95,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                      // focusNode: widget.focusNode,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.blue)),
                        fillColor: Colors.blue.shade50,
                        filled: true,
                        label: const Text("Search Job"),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        alignLabelWithHint: true,
                      ),
                      onChanged: (e) => setState(() {
                            searchKey = e;
                          })),
                ),
              ),
              Expanded(
                  child: FractionallySizedBox(
                widthFactor: 0.95,
                alignment: Alignment.centerRight,
                child: TextField(
                  // focusNode: widget.focusNode,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),

                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue)),
                    fillColor: Colors.blue.shade50,
                    filled: true,
                    // label: Text("Search Job"),
                    hintText: selectedMenu,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    alignLabelWithHint: true,
                  ),
                  keyboardType: TextInputType.none,
                  showCursor: false,
                  readOnly: true,
                  onTap: () {
                    showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(1, 100, 0, 0),
                            items: [
                              const PopupMenuItem(
                                value: "Newest First",
                                child: Text('Newest First'),
                              ),
                              const PopupMenuItem(
                                value: "Oldest First",
                                child: Text('Oldest First'),
                              ),
                              const PopupMenuItem(
                                value: "Duration",
                                child: Text('Duration'),
                              ),
                            ],
                            elevation: 16)
                        .then((val) {
                      setState(() {
                        selectedMenu = val;
                      });
                    }).catchError((onError) {});
                  },
                ),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                  icon: Icon(Icons.clear),
                  onPressed: handleReset,
                  label: Text("Reset")),
              TextButton.icon(
                  icon: Icon(Icons.done),
                  onPressed: handleSearch,
                  label: Text("Apply")),
            ],
          )
        ],
      ),
    );
  }
}
