
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController popController = TextEditingController();
  final TextEditingController empController = TextEditingController();
  final TextEditingController hcController = TextEditingController();

  bool isLoading = false;

  Future<void> predict() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "pop": double.tryParse(popController.text) ?? 0.0,
      "emp": double.tryParse(empController.text) ?? 0.0,
      "emp_to_pop_ratio": 0.3,
      "hc": double.tryParse(hcController.text) ?? 0.0,
      "ccon": 0,
      "cda": 0,
      "cn": 0,
      "ck": 0,
      "rconna": 0,
      "rdana": 0,
      "rnna": 0,
      "rkna": 0,
      "rtfpna": 0,
      "rwtfpna": 0,
      "labsh": 0,
      "irr": 0,
      "delta": 0,
      "xr": 0,
      "pl_con": 0,
      "pl_da": 0,
      "pl_gdpo": 0,
      "csh_c": 0,
      "csh_i": 0,
      "csh_g": 0,
      "csh_x": 0,
      "csh_m": 0,
      "csh_r": 0,
      "pl_c": 0,
      "pl_i": 0,
      "pl_g": 0,
      "pl_x": 0,
      "pl_m": 0,
      "pl_n": 0,
      "total": 0,
      "excl_energy": 0,
      "energy": 0,
      "metals_minerals": 0,
      "forestry": 0,
      "agriculture": 0,
      "fish": 0,
      "total_change": 0,
      "excl_energy_change": 0,
      "energy_change": 0,
      "metals_minerals_change": 0,
      "forestry_change": 0,
      "agriculture_change": 0,
      "fish_change": 0,
    };

    setState(() => isLoading = true);
    try {
      final response = await ApiService.predict(data);
      final predictedValue = double.tryParse(response);
      if (predictedValue != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(prediction: predictedValue),
          ),
        );
      } else {
        showError("Invalid response from model.");
      }
    } catch (e) {
      showError("Something went wrong: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Economic Indicators Input",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter key economic indicators to predict recession risks in African economies",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: popController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Population (millions)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: const Icon(Icons.people),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: empController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Employment Rate (%)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: const Icon(Icons.work),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: hcController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Human Capital Index",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: const Icon(Icons.school),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : predict,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                                : const Text(
                                  "PREDICT RECESSION RISK",
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Understanding the Indicators",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Population: Total population in millions\n"
                      "Employment Rate: Percentage of working-age population employed\n"
                      "Human Capital Index: Measures knowledge and skills (0-1 scale)\n\n"
                      "Our model analyzes these along with 40+ other indicators to predict recession risks.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
