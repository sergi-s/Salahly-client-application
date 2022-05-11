import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';

class ChatBotScreen extends StatefulWidget {
  static const String routeName = "/chatBotScreen";

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  ChatBot chatBot = ChatBot(
    Question(
      q: "Do you want help",
      an: [
        Answer(
          answer: "Yes",
          q: Question(q: "is your car broken", an: [
            Answer(
              answer: "Yes",
              q: Question(q: "can you still drive it", an: [
                Answer(answer: "NO", fn: () {}),
                Answer(
                    answer: "YES",
                    fn: () {
                      print("Recomend WSA");
                    })
              ]),
            ),
          ]),
        )
      ],
    ),
  );

  final messageInsert = TextEditingController();
  List<Map> messages = [];
  List<Widget> choices = [];

  @override
  void initState() {
    chatBot.printAllNodesWithAnswers(chatBot.rootQ);

    // widget.chatBot.printAnswers();
    chatBot.setDefault(() {
      messages = [];
      chatBot.rootQ = Question(
        q: "Do you want help",
        an: [
          Answer(
            answer: "Yes",
            q: Question(q: "is your car broken", an: [
              Answer(
                answer: "Yes",
                q: Question(q: "can you still drive it", an: [
                  Answer(answer: "NO", fn: () {}),
                  Answer(
                      answer: "YES",
                      fn: () {
                        print("Recomend WSA");
                      })
                ]),
              ),
            ]),
          )
        ],
      );
    });
    myMessage(chatBot.rootQ.question, 0);
    super.initState();
  }

  void myMessage(String message, int data) async {
    //0 means bot
    //1 means human
    setState(() {
      messages.insert(0, {
        "data": data,
        "message": message,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: salahlyAppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) => chat(
                      messages[index]["message"].toString(),
                      messages[index]["data"]))),
          const Divider(height: 6.0),
          Center(
            child: getChoices(),
          ),
          const SizedBox(height: 50.0)
        ],
      ),
    );
  }

  Widget getChoices() {
    List<Widget> temp = [
      Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                chatBot.rollback();
                myMessage(chatBot.rootQ.question, 0);
              });
            },
            child: Text("Back")),
      )
    ];
    // chatBot.rootQ.answers;
    // if (widget.chatBot.rootQ.answers != null) {
    for (int i = 0; i < chatBot.rootQ.answers.length; i++) {
      temp.add(
        Padding(
          padding: EdgeInsets.only(left: 8.0,right: 8.0),
          child: ElevatedButton(
            child: Text(chatBot.rootQ.answers[i].answer.toString()),
            onPressed: () {
              // chatBot.printAnswers();
              // print("CHOSSE $i prev: ${chatBot.rootQ.question}");
              // print("isa $i next: ${chatBot.rootQ.answers[i].answer}");
              myMessage(chatBot.rootQ.answers[i].answer, 1);
              chatBot.chooseAnswer(i);
              myMessage(chatBot.rootQ.question, 0);
              // print("next ${chatBot.rootQ.question}");
            },
          ),
        ),
      );
    }
    // }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [...temp],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Bubble(
          radius: const Radius.circular(15.0),
          color: data == 0 ? Colors.grey : Colors.blueAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // CircleAvatar(
                //   backgroundImage: AssetImage(
                //       data == 0 ? "assets/bot.png" : "assets/user.png"),
                // ),
                const SizedBox(width: 10.0),
                Flexible(
                    child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
              ],
            ),
          )),
    );
  }
}

class ChatBot {
  List<Question> stack = [];
  bool terminate = false;
  late Question rootQ;
  Function? defaultBehaviour;

  setDefault(Function? def) {
    defaultBehaviour = def;
  }

  ChatBot(Question q, {Function? def}) {
    rootQ = q;
    defaultBehaviour = def;
  }

  printAllNodes(Question temp) {
    print(temp.question);
    for (Answer answer in temp.answers) {
      printAllNodes(answer.q!);
    }
  }

  printAllNodesWithAnswers(Question temp) {
    print(temp.question);
    for (Answer answer in temp.answers) {
      print(answer.answer);
      if (answer.q != null) printAllNodesWithAnswers(answer.q!);
    }
  }

  getQuestion() {
    print(rootQ.question);
  }

  printAnswers() {
    for (Answer an in rootQ.answers) {
      print(an.answer);
    }
  }

  chooseAnswer(int index) {
    if (rootQ.answers[index].q != null) {
      stack.add(rootQ);
      // print(rootQ.answers[index].q!.question.toString());
      rootQ = rootQ.answers[index].q!;
    } else {
      ///TODO: check if there is a function first
      rootQ.answers[index].fn!();
      defaultBehaviour!();
      terminate = true;
    }
  }

  rollback() {
    if (stack.isNotEmpty) {
      rootQ = stack.removeLast();
    } else {
      print("stack is already empty");
    }
  }
}

class Question {
  //TODO: add parent
  late String question;
  List<Answer> answers = [];

  Question({required String q, required List<Answer> an}) {
    this.question = q;
    this.answers = an;
  }

  void addChild(Answer answer) {
    // answer.parent = this;
    answers.add(answer);
  }
}

class Answer {
  late String answer;
  Question? q;
  Function? fn;
  Question? parent;

  Answer(
      {required String answer, Question? q, Function? fn, Question? parent}) {
    this.answer = answer;
    this.q = q;
    this.fn = fn;
  }
}

void chatBotActionConfirmation(context, {required Function fn}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogRadius),
      ),
      title: Text("Confrim"),
      content: Text("We recommend that you "),
      actions: [ElevatedButton(onPressed: () => fn(), child: Text("Confirm"))],
    ),
  );
}
