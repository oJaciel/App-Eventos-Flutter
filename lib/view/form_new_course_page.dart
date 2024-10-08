import 'package:appmobile/controller/course_controller.dart';
import 'package:appmobile/model/course_model.dart';
import 'package:flutter/material.dart';

class formNewCoursePage extends StatefulWidget {
//Variável que recebe o parâmetro passado
  final CourseEntity? courseEdit;

  formNewCoursePage({super.key, this.courseEdit});

  @override
  State<formNewCoursePage> createState() => _formNewCoursePageState();
}

class _formNewCoursePageState extends State<formNewCoursePage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController textNameController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  TextEditingController textStartAtController = TextEditingController();
  String id = ''; //ID para API fazer PUT

  courseController controller = courseController();

  postNewCourse() async {
    try {
      await controller.postNewCourse(CourseEntity(
          name: textNameController.text,
          description: textDescriptionController.text,
          startAt: controller.dateFormatStringPtBRtoAPI(textStartAtController.text)));
      //
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Curso inserido com sucesso."),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  putUpdateCourse() async {
    try {
      await controller.putUpdateNewCourse(CourseEntity(
          id: id,
          name: textNameController.text,
          description: textDescriptionController.text,
          startAt: controller.dateFormatStringPtBRtoAPI(textStartAtController.text)));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Curso atualizado com sucesso."),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  //Verificando se tem parâmetros passados, para quando montar a tela preencher os campos
  @override
  void initState() {
    if (widget.courseEdit != null) {
      id = widget.courseEdit?.id ?? '';
      textNameController.text = widget.courseEdit?.name ?? "";
      textDescriptionController.text = widget.courseEdit?.description ?? "";
      textStartAtController.text = widget.courseEdit?.startAt ?? "";
      //controller.dateTimeFormatToStringPtBR(DateTime.parse(widget.courseEdit?.startAt ?? '')) ?? "--/--/----"
      //textStartAtController não está recebendo nada, verificar
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Formulário de Curso",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            // Nome do curso
                            TextFormField(
                              controller: textNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Nome obrigatório";
                                }
                                return null;
                              },
                              maxLength: 50,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  hintText: "Digite o nome do curso"),
                            ),
                            const SizedBox(height: 10),

                            // Descrição
                            TextFormField(
                              controller: textDescriptionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Descrição obrigatória';
                                }
                                return null;
                              },
                              maxLength: 200,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: "Digite a descrição"),
                            ),
                            const SizedBox(height: 10),

                            // Data de Início
                            TextFormField(
                              onTap: () {
                                showDatePicker(
                                  locale: const Locale('pt', 'BR'),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                ).then((DateTime? value) {
                                  if (value != null) {
                                    textStartAtController.text = controller.dateTimeFormatToStringPtBR(value);
                                  }
                                });
                              },
                              controller: textStartAtController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Data obrigatória';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                  hintText: "Selecione a data de início",
                                  icon: Icon(Icons.calendar_month))
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Botão Salvar
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (widget.courseEdit != null) {
                                //Se veio algum coisa por parâmetro na troca de telas, é uma edição
                                putUpdateCourse();
                              } else {
                                //Se não foi passado nada, é um novo registro
                                postNewCourse();
                              }
                            }
                          },
                          child: const Text("Salvar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
