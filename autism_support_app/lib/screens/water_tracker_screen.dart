import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/water_tracker_service.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  double _currentIntake = 0.0;
  double _dailyGoal = WaterTrackerService.defaultDailyGoal;
  bool _isGlassMode = true; // true for glasses, false for ml
  final TextEditingController _customAmountController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final intake = await WaterTrackerService.getDailyIntake();
    final goal = await WaterTrackerService.getDailyGoal();
    setState(() {
      _currentIntake = intake;
      _dailyGoal = goal;
    });
  }

  Future<void> _addWater(double amount) async {
    await WaterTrackerService.addWater(amount);
    await _loadData();
  }

  Future<void> _setDailyGoal(double goal) async {
    await WaterTrackerService.setDailyGoal(goal);
    await _loadData();
  }

  Future<void> _resetIntake() async {
    await WaterTrackerService.resetDailyIntake();
    await _loadData();
  }

  double get _remainingWater => _dailyGoal - _currentIntake;
  double get _progress => _currentIntake / _dailyGoal;

  String _formatWater(double ml) {
    if (ml >= 1000) {
      return '${(ml / 1000).toStringAsFixed(1)}L';
    }
    return '${ml.toStringAsFixed(0)}ml';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Tracker',
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade300, Colors.pink.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Tracker')],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetIntake,
            tooltip: 'Reset daily intake',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.pink.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress Circle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: _progress.clamp(0.0, 1.0),
                        strokeWidth: 12,
                        backgroundColor: Colors.purple.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _progress >= 1.0 ? Colors.green : Colors.purple,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_drink, size: 40, color: Colors.purple),
                        const SizedBox(height: 8),
                        Text(
                          _formatWater(_currentIntake),
                          style: GoogleFonts.quicksand(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          'of ${_formatWater(_dailyGoal)}',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Remaining water
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.purple.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _remainingWater <= 0
                            ? '🎉 Goal Achieved! 🎉'
                            : 'Remaining Today',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _remainingWater <= 0
                              ? Colors.green.shade800
                              : Colors.purple.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _remainingWater <= 0
                            ? 'Great job staying hydrated!'
                            : _formatWater(_remainingWater.abs()),
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _remainingWater <= 0
                              ? Colors.green.shade700
                              : Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Unit toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add by:',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(value: true, label: Text('Glasses')),
                      ButtonSegment<bool>(value: false, label: Text('ml')),
                    ],
                    selected: {_isGlassMode},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        _isGlassMode = newSelection.first;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick add buttons
              Text(
                'Quick Add',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _isGlassMode
                    ? [
                        _buildAddButton(1, '1 Glass\n(250ml)'),
                        _buildAddButton(2, '2 Glasses\n(500ml)'),
                        _buildAddButton(3, '3 Glasses\n(750ml)'),
                      ]
                    : [
                        _buildAddButton(100, '100ml'),
                        _buildAddButton(200, '200ml'),
                        _buildAddButton(250, '250ml'),
                        _buildAddButton(500, '500ml'),
                      ],
              ),

              const SizedBox(height: 24),

              // Custom amount
              Text(
                'Custom Amount',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _customAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _isGlassMode ? 'Glasses' : 'ml',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (value) {
                        final amount = double.tryParse(value) ?? 0;
                        if (amount > 0) {
                          final mlAmount = _isGlassMode
                              ? amount * WaterTrackerService.glassSize
                              : amount;
                          _addWater(mlAmount);
                          _customAmountController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      final value = _customAmountController.text;
                      final amount = double.tryParse(value) ?? 0;
                      if (amount > 0) {
                        final mlAmount = _isGlassMode
                            ? amount * WaterTrackerService.glassSize
                            : amount;
                        _addWater(mlAmount);
                        _customAmountController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Daily goal setting
              Text(
                'Daily Goal',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildGoalButton(1500, '1.5L'),
                  _buildGoalButton(2000, '2L'),
                  _buildGoalButton(2500, '2.5L'),
                  _buildGoalButton(3000, '3L'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(double amount, String label) {
    final mlAmount = _isGlassMode
        ? amount * WaterTrackerService.glassSize
        : amount;
    return ElevatedButton(
      onPressed: () => _addWater(mlAmount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.purple.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGoalButton(double goal, String label) {
    final isSelected = _dailyGoal == goal;
    return ElevatedButton(
      onPressed: () => _setDailyGoal(goal),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.purple : Colors.purple.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.purple.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
