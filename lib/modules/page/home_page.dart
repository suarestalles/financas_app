import 'package:financas_pessoais_flutter/modules/categoria/pages/categoria_list_page.dart';
import 'package:financas_pessoais_flutter/modules/conta/controllers/conta_controller.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/conta_dto.dart';
import 'package:financas_pessoais_flutter/modules/conta/pages/conta_list_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanças App'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: const Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/avatar.jpg')),
                      ),
                      Center(
                        child: Text(
                          'Bem-Vindo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            MenuItemButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20, horizontal: 20))),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CategoriaListPage())),
              child: const Text('Categorias'),
            ),
            MenuItemButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20, horizontal: 20))),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContaListPage())),
              child: const Text('Contas'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<ContaDTO?>(
          future: context.read<ContaController>().resumo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                ContaDTO contaDTO = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Despesas/Receitas',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: contaDTO.totalReceita ?? 0,
                                  showTitle: true,
                                  title: 'Receita',
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.orange[900],
                                  value: contaDTO.totalDespesa ?? 0,
                                  showTitle: true,
                                  title: 'Despesas',
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              centerSpaceRadius: 100,
                              sectionsSpace: 5,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Text(
                              'Saldo',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.teal,
                              ),
                            ),
                            Text(
                              'R\$ ${contaDTO.saldo}',
                              style: const TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                );
              }
              return const Center(
                child: Text('Oops! Algo deu errado...'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
