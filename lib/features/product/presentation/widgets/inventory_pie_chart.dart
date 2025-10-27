import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';

class InventoryPieChart extends StatefulWidget {
  final List<Product> products;

  const InventoryPieChart({super.key, required this.products});

  @override
  State<InventoryPieChart> createState() => _InventoryPieChartState();
}

class _InventoryPieChartState extends State<InventoryPieChart> {
  int touchedIndex = -2;

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return _buildEmptyChart();
    }

    // Calculate total value for percentage
    final totalValue = widget.products.fold<double>(
      0,
      (sum, product) => sum + product.totalValue,
    );

    // Get top 5 products by value
    final sortedProducts = List<Product>.from(widget.products)
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));

    final topProducts = sortedProducts.take(5).toList();
    final otherProducts = sortedProducts.skip(5).toList();

    // Calculate "Others" value
    final othersValue = otherProducts.fold<double>(
      0,
      (sum, product) => sum + product.totalValue,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_rounded,
                color: Colors.blue.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Inventory Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pie Chart
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: _generateSections(
                        topProducts,
                        othersValue,
                        totalValue,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildLegend(topProducts, othersValue, totalValue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections(
    List<Product> topProducts,
    double othersValue,
    double totalValue,
  ) {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.pink.shade400,
      Colors.grey.shade400,
    ];

    final sections = <PieChartSectionData>[];

    // Add top products
    for (int i = 0; i < topProducts.length; i++) {
      final product = topProducts[i];
      final percentage = (product.totalValue / totalValue) * 100;
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 65.0 : 55.0;

      sections.add(
        PieChartSectionData(
          color: colors[i],
          value: product.totalValue,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    // Add "Others" if there are more products
    if (othersValue > 0) {
      final percentage = (othersValue / totalValue) * 100;
      final isTouched = topProducts.length == touchedIndex;
      final radius = isTouched ? 65.0 : 55.0;

      sections.add(
        PieChartSectionData(
          color: colors[5],
          value: othersValue,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildLegend(
    List<Product> topProducts,
    double othersValue,
    double totalValue,
  ) {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.pink.shade400,
      Colors.grey.shade400,
    ];

    final currencyFormat = NumberFormat.currency(symbol: '₦');

    return ListView(
      shrinkWrap: true,
      children: [
        // Top products
        ...topProducts.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currencyFormat.format(product.totalValue),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),

        // Others
        if (othersValue > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[5],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Others',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currencyFormat.format(othersValue),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.pie_chart_outline_rounded,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No data to display',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to see distribution',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
