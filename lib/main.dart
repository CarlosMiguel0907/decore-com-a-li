import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

void main() {
  runApp(const DecorAIApp());
}

class DecorAIApp extends StatelessWidget {
  const DecorAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decore com a Li',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA3B18A)),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F8F8),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFA3B18A), width: 2),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),

      home: const TelaInicial(),
    );
  }
}

// ======================================================
// TELA INICIAL
// ======================================================

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController temaController = TextEditingController();
  final TextEditingController coresController = TextEditingController();
  final TextEditingController orcamentoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  String? tipoEvento;

  Future<void> testarApi() async {
    try {
      final resposta = await http.get(Uri.parse('http://10.0.2.2:3000/'));

      final dados = jsonDecode(resposta.body);

      var push = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaResultado(
            tipoEvento: tipoEvento ?? 'Evento',
            tema: temaController.text,
            cores: coresController.text,
            orcamento: orcamentoController.text,
            descricao: descricaoController.text,
            sugestao: dados['sugestao'],
          ),
        ),
      );
    } catch (erro) {
      print('Erro ao conectar com a API: $erro');
    }
  }

  Future<void> enviarSugestao() async {
  try {
    final resposta = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/sugestao'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tipoEvento': tipoEvento ?? 'Evento',
        'tema': temaController.text,
        'cores': coresController.text,
        'orcamento': orcamentoController.text,
        'descricao': descricaoController.text,
      }),
    );

    print('Status da API: ${resposta.statusCode}');
    print('Resposta da API: ${resposta.body}');

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaResultado(
            tipoEvento: tipoEvento ?? 'Evento',
            tema: temaController.text,
            cores: coresController.text,
            orcamento: orcamentoController.text,
            descricao: descricaoController.text,
            sugestao: dados['sugestao'] ?? 'A IA não retornou uma sugestão.',
          ),
        ),
      );
    } else {
      print('Erro da API: ${resposta.body}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível gerar a sugestão.'),
        ),
      );
    }
  } catch (erro) {
    print('Erro ao conectar com a API: $erro');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erro ao conectar com a IA.'),
      ),
    );
  }
}

  void gerarSugestao() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResultado(
          tipoEvento: tipoEvento ?? 'Evento',
          tema: temaController.text,
          cores: coresController.text,
          orcamento: orcamentoController.text,
          descricao: descricaoController.text,
          sugestao: 'Gerando sugestão...',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Decore com a Li ✨',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CABEÇALHO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFB8D2),
                  borderRadius: BorderRadius.circular(25),
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crie sua decoração',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Conte para nós como será seu evento e receba uma sugestão personalizada da IA.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Tipo de evento',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: tipoEvento,

                decoration: const InputDecoration(
                  hintText: 'Selecione o tipo de evento',
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'Aniversário',
                    child: Text('Aniversário'),
                  ),

                  DropdownMenuItem(
                    value: 'Casamento',
                    child: Text('Casamento'),
                  ),

                  DropdownMenuItem(
                    value: 'Chá de bebê',
                    child: Text('Chá de bebê'),
                  ),

                  DropdownMenuItem(
                    value: 'Formatura',
                    child: Text('Formatura'),
                  ),

                  DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                ],

                onChanged: (valor) {
                  setState(() {
                    tipoEvento = valor;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Tema',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: temaController,
                decoration: const InputDecoration(
                  hintText: 'Ex.: Festa tropical',
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Cores desejadas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: coresController,
                decoration: const InputDecoration(
                  hintText: 'Ex.: Rosa, branco e dourado',
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Orçamento',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: orcamentoController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  hintText: 'Ex.: 500',
                  prefixText: 'R\$ ',
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Conte mais sobre seu evento',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: descricaoController,
                maxLines: 5,

                decoration: const InputDecoration(
                  hintText:
                      'Ex.: Quero uma decoração bonita, simples e elegante...',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 28),

              // BOTÃO
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  onPressed: enviarSugestao,

                  icon: const Icon(Icons.auto_awesome, color: Colors.black),

                  label: const Text(
                    'Gerar sugestão com IA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA3B18A),
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Text(
                  '✨ Sua ideia, nossa inspiração',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// TELA DE RESULTADO
// ======================================================

class TelaResultado extends StatelessWidget {
  final String tipoEvento;
  final String tema;
  final String cores;
  final String orcamento;
  final String descricao;
  final String sugestao;

  const TelaResultado({
    super.key,
    required this.tipoEvento,
    required this.tema,
    required this.cores,
    required this.orcamento,
    required this.descricao,
    required this.sugestao,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Decore com a Li ✨',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TÍTULO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFB8D2),
                  borderRadius: BorderRadius.circular(25),
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome, size: 35, color: Colors.black),

                    SizedBox(height: 12),

                    Text(
                      'Sugestão da Li ✨',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Preparei uma ideia de decoração baseada nas informações do seu evento.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // INFORMAÇÕES
              const Text(
                'Seu evento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _informacao(Icons.celebration, 'Evento', tipoEvento),

              _informacao(
                Icons.palette,
                'Tema',
                tema.isEmpty ? 'Não informado' : tema,
              ),

              _informacao(
                Icons.color_lens,
                'Cores',
                cores.isEmpty ? 'Não informado' : cores,
              ),

              _informacao(
                Icons.attach_money,
                'Orçamento',
                orcamento.isEmpty ? 'Não informado' : 'R\$ $orcamento',
              ),

              const SizedBox(height: 25),

              // SUGESTÃO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFA3B18A),
                    width: 1.5,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Color(0xFFA3B18A)),

                        SizedBox(width: 8),

                        Text(
                          'Minha sugestão',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      sugestao,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // BOTÃO VOLTAR
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(Icons.edit, color: Colors.black),

                  label: const Text(
                    'Alterar minha decoração',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA3B18A),
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  '✨ Decore com a Li',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CARD DE INFORMAÇÃO
  Widget _informacao(IconData icone, String titulo, String valor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          Icon(icone, color: const Color(0xFFA3B18A)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),

                const SizedBox(height: 2),

                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TEXTO TEMPORÁRIO DA IA
  String _gerarTextoSugestao() {
    String temaTexto = tema.isEmpty ? 'um estilo elegante' : 'o tema $tema';

    String coresTexto = cores.isEmpty ? 'tons suaves' : 'as cores $cores';

    return 'Para o seu $tipoEvento, pensando em $temaTexto e '
        '$coresTexto, a Li sugere uma decoração equilibrada e aconchegante. '
        'Você pode utilizar uma mesa principal como destaque, '
        'arranjos decorativos combinando com as cores escolhidas e '
        'uma iluminação suave para deixar o ambiente mais bonito. '
        'A ideia é aproveitar bem o orçamento informado e criar '
        'um espaço bonito sem exagerar nos elementos.';
  }
}
