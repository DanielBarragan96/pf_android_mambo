class Artist {
  final String artistName;
  final String artistImageUrl;
  final String artistUrl;

  Artist({
    this.artistName,
    this.artistImageUrl,
    this.artistUrl,
  });

  @override
  String toString() {
    return artistName;
  }
}
