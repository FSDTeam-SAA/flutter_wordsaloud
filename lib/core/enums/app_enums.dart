import 'package:json_annotation/json_annotation.dart';

enum StringBoolean {
  trueString('true'),
  falseString('false');

  final String value;
  const StringBoolean(this.value);
}

enum ReactionType {
  @JsonValue('like')
  like('like', '👍', 'assets/icons/f_like.svg', 'assets/gif/like.gif'),
  @JsonValue('love')
  love('love', '❤️', 'assets/icons/f_love.svg', 'assets/gif/heart.gif'),
  @JsonValue('haha')
  haha('haha', '😆', 'assets/icons/f_haha.svg', 'assets/gif/Ha-ha.gif'),
  @JsonValue('wow')
  wow('wow', '😮', 'assets/icons/f_wow.png', 'assets/gif/Wow.gif'),
  @JsonValue('sad')
  sad('sad', '😢', 'assets/icons/f_sad.svg', ''),
  @JsonValue('angry')
  angry('angry', '😡', 'assets/icons/f_angry.svg', 'assets/gif/Angry.gif'),
  @JsonValue('care')
  care('care', '🥰', 'assets/icons/f_care.svg', 'assets/gif/Care.gif');
  // @JsonValue('fire')
  // fire('fire', '🔥', '', ''); // No SVG or GIF asset for fire yet

  final String value;
  final String emoji;
  final String asset;
  final String gif;
  const ReactionType(this.value, this.emoji, this.asset, this.gif);

  static ReactionType fromValue(String value) {
    return ReactionType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => ReactionType.like,
    );
  }
}

enum PostType {
  @JsonValue('text')
  text('text'),
  @JsonValue('image')
  image('image'),
  @JsonValue('video')
  video('video'),
  @JsonValue('reel')
  reel('reel'),
  @JsonValue('shared')
  shared('shared');

  final String value;
  const PostType(this.value);
}

/// Relationship Status
///
// "single",
// "in_a_relationship",
// "engaged",
// "married",
// "its_complicated",

enum RelationshipStatus {
  @JsonValue('single')
  single('single'),
  @JsonValue('in_a_relationship')
  inARelationship('in_a_relationship'),
  @JsonValue('engaged')
  engaged('engaged'),
  @JsonValue('married')
  married('married'),
  @JsonValue('its_complicated')
  itsComplicated('its_complicated');

  final String value;
  const RelationshipStatus(this.value);

  static RelationshipStatus fromValue(String value) {
    return RelationshipStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => RelationshipStatus.single,
    );
  }
}

enum FriendStatus {
  @JsonValue('friend')
  friend('friend'),
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('invited')
  invited('invited'),
  @JsonValue('none')
  none('none');

  final String value;
  const FriendStatus(this.value);

  static FriendStatus fromValue(String value) {
    return FriendStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => FriendStatus.none,
    );
  }
}

/// Search Type
/// ["users", "groups", "posts", "events"]
//
enum SearchType {
  @JsonValue('users')
  users('users'),
  @JsonValue('groups')
  groups('groups'),
  @JsonValue('posts')
  posts('posts'),
  @JsonValue('events')
  events('events');

  final String value;
  const SearchType(this.value);

  static SearchType fromValue(String value) {
    return SearchType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => SearchType.users,
    );
  }
}
