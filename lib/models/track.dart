class Track {
  final String artistName;
  final String trackName;
  final String albumName;
  final String albumImageUrl;
  final String trackUrl;

  Track(
      {this.artistName,
      this.trackName,
      this.albumName,
      this.albumImageUrl,
      this.trackUrl});

  @override
  String toString() {
    return trackName + " - " + artistName + " - " + albumName;
  }
}
