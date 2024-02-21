import 'package:chili_labs_task/presentation/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.9) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final currentState = BlocProvider.of<SearchBloc>(context).state;
              final offset =
                  currentState is SearchSuccess ? currentState.gifs.length : 0;
              BlocProvider.of<SearchBloc>(context)
                  .add(LoadMore(text: _searchController.text, offset: offset));
            });
          }
          return true;
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  BlocProvider.of<SearchBloc>(context)
                      .add(SearchTextChanged(text: value));
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                ),
                itemCount: context.select((SearchBloc bloc) =>
                    bloc.state is SearchSuccess
                        ? (bloc.state as SearchSuccess).gifs.length
                        : 0),
                itemBuilder: (context, index) {
                  return BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchSuccess) {
                        return GridTile(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(state.gifs[index].url),
                          ),
                        );
                      } else if (state is SearchError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(
                            child: Text('Please enter a search term'));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
