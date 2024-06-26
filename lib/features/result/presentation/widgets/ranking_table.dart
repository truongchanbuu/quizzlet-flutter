import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/result/data/models/result.dart';
import 'package:quizzlet_fluttter/features/result/presentation/bloc/result/result_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';

class RankingTable extends StatefulWidget {
  const RankingTable({super.key});

  @override
  State<RankingTable> createState() => _RankingTableState();
}

class _RankingTableState extends State<RankingTable> {
  List<TopicModel> topics = List.empty(growable: true);

  TopicModel? selectedTopic;
  String examType = 'Quiz';

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text(
          'Bảng xếp hạng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        _buildTopicSelection(),
        const SizedBox(height: 25),
        _buildRankingTable(),
      ],
    );
  }

  Widget _buildTopicSelection() {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        if (state is AllTopicsLoaded) {
          topics = state.topics;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle('Chọn chủ đề'),
            const SizedBox(width: 20),
            buildDropdown<TopicModel>(
              items: topics,
              selectedItem: selectedTopic,
              hintText: 'Chủ đề',
              itemBuilder: _createDropdownItem,
              onChanged: (topic) {
                setState(() => selectedTopic = topic);
                if (selectedTopic != null) {
                  _getResults(context);
                }
              },
            ),
            const SizedBox(width: 20),
            _buildTitle('Chọn loại kiểm tra'),
            const SizedBox(width: 20),
            buildDropdown<String>(
              items: ['Quiz', 'Typing'],
              selectedItem: examType,
              hintText: 'Chọn loại kiểm tra',
              itemBuilder: (type) => Text(type),
              onChanged: (type) {
                setState(() => examType = type ?? 'Quiz');
                if (selectedTopic != null) {
                  _getResults(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDropdown<T>({
    required List<T> items,
    T? selectedItem,
    String? hintText,
    required Widget Function(T) itemBuilder,
    required void Function(T?) onChanged,
  }) {
    return Expanded(
      child: DropdownButton<T>(
        items: items
            .map((item) =>
                DropdownMenuItem(value: item, child: itemBuilder(item)))
            .toList(),
        hint: Text(hintText ?? ''),
        isExpanded: true,
        value: selectedItem,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createDropdownItem(TopicModel topic) {
    return Text(topic.topicName);
  }

  Widget _buildRankingTable() {
    return BlocBuilder<ResultBloc, ResultState>(
      builder: (context, state) {
        if (state is GettingAllResultsByTopic) {
          return const LoadingIndicator();
        } else if (state is GetAllResultsByTopicFailed) {
          return const Center(
            child: Text('Đã có lỗi xảy ra trong quá trình lấy dữ liệu'),
          );
        } else if (state is GetAllResultsByTopicSuccess &&
            state.results.isNotEmpty) {
          return _buildDataTable(state.results);
        }

        return const Center(
          child: Text('Không có dữ liệu nào được ghi nhận cho đến hiện tại'),
        );
      },
    );
  }

  Widget _buildDataTable(List<ResultModel> results) {
    _sortResults(results);
    final topResults = results.take(10).toList();

    return DataTable(
      columns: _buildColumns(),
      rows: List<DataRow>.generate(
        topResults.length,
        (index) => _createResult(topResults[index], index),
      ),
    );
  }

  _sortResults(List<ResultModel> results) {
    results.sort((a, b) {
      if (a.score != b.score) {
        return b.score.compareTo(a.score);
      } else {
        return a.completionTime.compareTo(b.completionTime);
      }
    });
  }

  _buildColumns() {
    return const [
      DataColumn(
        label: Text(
          '#',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      DataColumn(
        label: Text(
          'Email',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      DataColumn(
        label: Text(
          'Score',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      DataColumn(
        label: Text(
          'Complete time',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  DataRow _createResult(result, index) {
    final Color color = index.isEven ? Colors.white : Colors.grey.shade100;

    return DataRow(
      color: WidgetStateColor.resolveWith((states) => color),
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(result.email)),
        DataCell(Text(result.score.toString())),
        DataCell(Text(result.completionTime.inSeconds.toString())),
      ],
    );
  }

  _getResults(BuildContext context) {
    context.read<ResultBloc>().add(GetAllResultsByTopicAndExamType(
          topicId: selectedTopic!.topicId,
          examType: examType.toLowerCase(),
        ));
  }
}
