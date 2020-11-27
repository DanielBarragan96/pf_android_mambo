import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:entregable_2/login/bloc/login_bloc.dart';
import 'package:entregable_2/login/login_page.dart';
import 'package:entregable_2/models/artist.dart';
import 'package:entregable_2/models/track.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LoginBloc loginBloc;
  List<Artist> topArtists = List();
  List<Track> topTracks = List();
  String spotifyApiKey =
      "BQCCMf7EfCDnIIzsHIJyY9jSFe_i68hcL4OisgBhdQcwEiDxqFjZmtOLHsAQo_afTM5899kyhopeCiDio8Fbb0UHpcP3aO8R8IWM1ANXxjhvmiXfa9STq4A2qLGjG1p_PDYm8co7RbWFq4Pbzi6g-6trKg4";

  HomeBloc({@required this.loginBloc}) : super(MenuMapState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is ScanPicture) {
      File img = await _chooseImage();
      if (img == null)
        yield Error();
      else {
        String data = "";
        // if (event.barcodeScan)
        //   data = await _barcodeScan(img);
        yield Results(result: data, chosenImage: img);
      }
    } else if (event is MenuStatsEvent) {
      yield MenuStatsState(topTracks: topTracks, topArtists: topArtists);
    } else if (event is MenuMapEvent) {
      yield MenuMapState();
    } else if (event is MenuChatEvent) {
      yield MenuChatState();
    } else if (event is SingleChatEvent) {
      yield SingleChatState(userName: event.userName);
    } else if (event is LoadSpotifyStatsEvent) {
      try {
        // get artists stats
        var responseArtist = await getSpotifyArtistStats();
        // decode json response
        Map<String, dynamic> dataArtist = jsonDecode(responseArtist.body);

        // create top artists list
        topArtists = List();
        for (var artist in dataArtist["items"])
          topArtists.add(Artist(
            artistName: "${artist["name"]}",
            artistImageUrl: "${artist["images"][0]["url"]}",
            artistUrl: "${artist["external_urls"]["spotify"]}",
          ));
        print(topArtists.toString());

        // get tracks stats
        var responseTrack = await getSpotifyTrackStats();
        // decode json response
        Map<String, dynamic> dataTrack = jsonDecode(responseTrack.body);

        // create top tracks list
        topTracks = List();
        for (var track in dataTrack["items"]) {
          topTracks.add(Track(
            trackName: "${track["name"]}",
            artistName: "${track["artists"][0]["name"]}",
            albumName: "${track["album"]["name"]}",
            albumImageUrl: "${track["album"]["images"][0]["url"]}",
            trackUrl: "${track["external_urls"]["spotify"]}",
            trackUri: "${track["uri"]}",
          ));
        }
        print(topTracks.toString());
        yield MenuStatsState(topTracks: topTracks, topArtists: topArtists);
      } catch (error) {
        //TODO error al cargar stats
        print(error);
      }
    } else if (event is CreateSpotifyPlaylistEvent) {
      if (topTracks.length > 0) {
        try {
          //create playlist
          var responsePlaylistCreate = await createSpotifyPlaylist(event.title);
          Map<String, dynamic> dataPlaylist =
              jsonDecode(responsePlaylistCreate.body);
          String newPlaylistUrl = dataPlaylist["external_urls"]["spotify"];
          String newPlaylistId = dataPlaylist["id"];
          print(newPlaylistUrl);

          //add tracks
          if (!event.sharedSongs) {
            var body = {"uris": []};
            for (var track in topTracks) {
              body["uris"].add(track.trackUri);
            }
            await addTracksSpotifyPlaylist(body, newPlaylistId);
            launch(newPlaylistUrl);
          }
        } catch (error) {
          print(error);
        }
      }
    }
  }

  // Future<String> _barcodeScan(File imageFile) async {
  //   var visionImage = FirebaseVisionImage.fromFile(imageFile);
  //   var barcode = FirebaseVision.instance.barcodeDetector();
  //   List<Barcode> codes = await barcode.detectInImage(visionImage);

  //   String data = "";
  //   for (var item in codes) {
  //     var code = item.rawValue;
  //     var type = item.valueType;
  //     var boundBox = item.boundingBox;
  //     var corners = item.cornerPoints;
  //     var url = item.url;

  //     data += '''
  //     > Codigo $code\n
  //     > Formato: $type\n
  //     > URL titulo: ${url == null ? "No disponible" : url.title}\n
  //     > URL: ${url == null ? "No disponible" : url}\n
  //     > Area de cod: $boundBox\n
  //     > Esquinas: $corners\n
  //     -----------------\n
  //     ''';
  //   }
  //   return data;
  // }

  Future<File> _chooseImage() async {
    final picker = ImagePicker();
    final PickedFile chooseImage = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    return File(chooseImage.path);
  }

  Widget logout() {
    this.loginBloc.add(LogoutWithGoogleEvent());
    return LoginPage();
  }

  Future<http.Response> getSpotifyArtistStats() async {
    String url = "https://api.spotify.com/v1/me/top/artists";

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $spotifyApiKey',
    });
  }

  Future<http.Response> getSpotifyTrackStats() async {
    String url = "https://api.spotify.com/v1/me/top/tracks";

    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $spotifyApiKey',
    });
  }

  updateSpotifyKey(String newKey) {
    spotifyApiKey = newKey;
  }

  Future<http.Response> createSpotifyPlaylist(String title) {
    String spotifyId = "flpnnk481ygtk9u1l1mcw9cs8";
    String url = "https://api.spotify.com/v1/users/$spotifyId/playlists";

    var requestBody = {
      "name": "$title",
      "description": "This playlista was created using Mambo",
      "public": true
    };

    return http.post(url, body: jsonEncode(requestBody), headers: {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $spotifyApiKey',
    });
  }

  Future<http.Response> addTracksSpotifyPlaylist(var body, String playlistId) {
    String url = "https://api.spotify.com/v1/playlists/$playlistId/tracks";

    String requestBody = jsonEncode(body);

    return http.post(url, body: requestBody, headers: {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $spotifyApiKey',
    });
  }
}
