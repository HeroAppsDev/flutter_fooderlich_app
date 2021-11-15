import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/components/friend_post_tile.dart';
import 'package:flutter_fooderlich_app/models/models.dart';

class FriendPostListView extends StatelessWidget {
  final List<Post> friendPosts;
  const FriendPostListView({Key? key, required this.friendPosts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Chefs 👩‍🍳',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 16),
          ListView.separated(
            primary:
                false, //Since you’re nesting two list views, it’s a good idea to set primary to false. That lets Flutter know that this isn’t the primary scroll view.
            physics:
                const NeverScrollableScrollPhysics(), //Even though you set primary to false, it’s also a good idea to disable the scrolling for this list view. That will propagate up to the parent list view.
            shrinkWrap:
                true, //Set shrinkWrap to true to create a fixed-length scrollable list of items. This gives it a fixed height. If this were false, you’d get an unbounded height error.
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final post = friendPosts[index];
              return FriendPostTile(post: post);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemCount: friendPosts.length,
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}
