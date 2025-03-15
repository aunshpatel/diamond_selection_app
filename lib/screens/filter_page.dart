import 'package:diamond_selection_app/screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/diamond_bloc.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController _minCaratController = TextEditingController();
  final TextEditingController _maxCaratController = TextEditingController();
  String? _selectedShape;
  String? _selectedLab;
  String? _selectedColor;
  String? _selectedClarity;

  final List<String> _shapes = ["All","Round", "Oval", "Princess", "Cushion", "Emerald"];
  final List<String> _labs = ["All","GIA", "IGI", "HRD"];
  final List<String> _colors = ["All","D", "E", "F", "G", "H"];
  final List<String> _clarities = ["All","IF", "VVS1", "VVS2", "VS1", "VS2"];

  void _applyFilters() {
    final double? minCarat = _minCaratController.text.isNotEmpty ? double.tryParse(_minCaratController.text) : null;
    final double? maxCarat = _maxCaratController.text.isNotEmpty ? double.tryParse(_maxCaratController.text) : null;
    if(_selectedShape == 'All') {
      setState(() {
        _selectedShape = null;
      });
    }
    if(_selectedLab == 'All') {
      setState(() {
        _selectedLab = null;
      });
    }
    if(_selectedColor == 'All') {
      setState(() {
        _selectedColor = null;
      });
    }
    if(_selectedClarity == 'All') {
      setState(() {
        _selectedClarity = null;
      });
    }

    context.read<DiamondBloc>().add(
      FilterDiamonds(
        minCarat: minCarat,
        maxCarat: maxCarat,
        shape: _selectedShape,
        lab: _selectedLab,
        color: _selectedColor,
        clarity: _selectedClarity,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filter Diamonds")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minCaratController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: "Min Carat"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _maxCaratController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: "Max Carat"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _selectedShape,
              hint: Text("Select Shape"),
              items: _shapes.map((shape) => DropdownMenuItem(value: shape, child: Text(shape))).toList(),
              onChanged: (value) => setState(() => _selectedShape = value),
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _selectedLab,
              hint: Text("Select Lab"),
              items: _labs.map((lab) => DropdownMenuItem(value: lab, child: Text(lab))).toList(),
              onChanged: (value) => setState(() => _selectedLab = value),
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _selectedColor,
              hint: Text("Select Color"),
              items: _colors.map((color) => DropdownMenuItem(value: color, child: Text(color))).toList(),
              onChanged: (value) => setState(() => _selectedColor = value),
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _selectedClarity,
              hint: Text("Select Clarity"),
              items: _clarities.map((clarity) => DropdownMenuItem(value: clarity, child: Text(clarity))).toList(),
              onChanged: (value) => setState(() => _selectedClarity = value),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Material(
                color:Color(0XFF3A4355),
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: _applyFilters,
                  minWidth: 150.0,
                  height: 60.0,
                  child: Text(
                      'Search',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                  ),
                ),
              ),
            ),

            BlocBuilder<DiamondBloc, DiamondState>(
              builder: (context, state) {
                if (state is DiamondLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
