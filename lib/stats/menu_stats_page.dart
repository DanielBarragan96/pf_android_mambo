import 'package:entregable_2/colors.dart';
import 'package:entregable_2/home/bloc/home_bloc.dart';
import 'package:entregable_2/home/drawer.dart';
import 'package:entregable_2/stats/top_artists.dart';
import 'package:entregable_2/stats/top_songs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final _tabsList = [
  Tab(icon: Icon(Icons.music_note), text: "Top Canciones"),
  Tab(icon: Icon(Icons.album), text: "Top Artistas"),
];

class StatsPage extends StatefulWidget {
  final HomeBloc bloc;
  final BuildContext context;

  StatsPage({
    Key key, 
    @required this.bloc, 
    @required this.context
  }) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBlack,
        drawer: DrawerWidget(
          bloc: widget.bloc,
        ),
        appBar: AppBar(
          title: Text("Stats"),
          bottom: TabBar(
            tabs: _tabsList,
          ),
        ),
        body: BlocProvider(
          create: (context) {
            return widget.bloc;
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            cubit: widget.bloc,
            builder: (context, state) {
              if (state is MenuStatsState) {
                return TabBarView(
                  children: [
                    SongList(songs: state.topTracks),
                    ArtistList(artists: state.topArtists),
                  ],
                );
              } else
                return Center();
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: Container(
            color: kMainPurple,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.spotify),
                    onPressed: () {},
                    iconSize: 25.0,
                    color: kWhite,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.mapMarkedAlt),
                    onPressed: () {
                      widget.bloc.add(MenuMapEvent());
                    },
                    iconSize: 25.0,
                    color: kLightGray,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.users),
                    onPressed: () {
                      widget.bloc.add(MenuChatEvent());
                    },
                    iconSize: 25.0,
                    color: kLightGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
