import 'package:appmobile/controller/holiday_controller.dart';
import 'package:appmobile/model/holiday_model.dart';
import 'package:appmobile/view/menu.dart';
import 'package:flutter/material.dart';

class HolidayPage extends StatefulWidget {
  const HolidayPage({super.key});

  @override
  State<HolidayPage> createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {
  //Instanciando o controller
  HolidayController controller = HolidayController();

  //Lista Future que vai receber os dados da API
  late Future<List<HolidayEntity>> _futureHolidays;

  //Função para preencher a lista com os dados da API
  Future<List<HolidayEntity>> getHolidays() async {
    return await controller.getHolidayList();
  }

  @override
  void initState() {
    super.initState();
    _futureHolidays = getHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        //Ano do texto fica de acordo com ano atual
        title: Text("Feriados ${controller.getYear()}"),
      ),
      body: FutureBuilder(
        future: _futureHolidays,
        builder: (context, AsyncSnapshot<List<HolidayEntity>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  elevation: 2,
                  shape: const LinearBorder(),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      snapshot.data![index].name ?? "Não informado",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      controller.dateFormatStringPtBR(snapshot.data![index].date ?? "Não informado"),
                    ),
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.deepPurple,
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
