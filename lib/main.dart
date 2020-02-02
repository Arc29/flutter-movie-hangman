import 'package:flutter/material.dart';
import 'package:flutter_app/fetchMovies/movieFetcher.dart';

void main() {
  runApp(MaterialApp(
    title: 'Hangman solver',
    home:AppBody()
  ));
}



class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Solver'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.black45,
      body:RootState(),
    );
  }
}

class RootState extends StatefulWidget {
  @override
  _RootStateState createState() => _RootStateState();
}

class _RootStateState extends State<RootState> {
  int listItems=0;
  List<WordComponent> words=[];
  List<List<String>> result=[];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            child: ListView.builder(
                itemCount: listItems,
                itemBuilder: (context,index){
                  final item=words[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: item,
                  );
                }),
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.exposure_neg_1),
                  onPressed: (){
                    if(listItems!=0){
                      setState(() {
                        listItems--;
                        words.removeLast();
                        result.removeLast();
                      });
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.exposure_plus_1),
                  onPressed: (){
                    setState(() {
                      listItems++;
//                      print(listItems);
                      result.add([]);
                      words.add(WordComponent(

                        itemNo:listItems-1,
                        insert:insertLetter,
                        change:changeLetter,
                        delete:deleteLetter
                      ));
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.red,
                  child:Text('Solve',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  ),
                  ),
                  onPressed: findAns,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  void changeLetter(int word,int pos,String s){
    setState(() {
      result[word][pos]=s;
    });
  }
  void insertLetter(int word){
    setState(() {
      result[word].add('[^AEIOU .,:]');
    });
  }
  void deleteLetter(int word){
    setState(() {
      result[word].removeLast();
    });
  }
  void findAns() async{
    var regex=[];
    for(final list in result){

      regex.add(list.join());
    }
    var regexStr=regex.join('[ ,:]+');
    regexStr='^'+regexStr+'\$';
    print(regexStr);
    RegExp regExp=RegExp(regexStr,caseSensitive: false,unicode: true);
    Fetch fetcher=Fetch();
    var holly=await fetcher.fetchHolly();
    List<String> results=[];
    for(final i in holly){
      if(regExp.hasMatch(i))
        results.add(i);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Found ${results.length} movies:'),
            content: showResults(results),
          );
        }
    );
  }
  Widget showResults(List<String> list){
    return Container(
      height: 300.0,
      width: 300.0,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
              title: Text(list[index]),
            );
          }),
    );
  }
}


class WordComponent extends StatefulWidget {
  final itemNo;
  final Function insert,change,delete;
  WordComponent({this.itemNo,this.insert,this.change,this.delete});
  @override
  _WordComponentState createState() => _WordComponentState();
}

class _WordComponentState extends State<WordComponent> {
  int letterCount=0;
  List<Widget> wordState=[];
  @override
  Widget build(BuildContext context) {

    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        GestureDetector(onTap: (){
          if(letterCount!=1){
            setState(() {
              letterCount--;
              wordState.removeLast();
              widget.delete(widget.itemNo);
            });
          }
        }, child: Icon(Icons.exposure_neg_1,color: Colors.white,),),
        Wrap(
          alignment: WrapAlignment.center,
          children: wordState,
        ),
        GestureDetector(onTap: (){
          setState(() {
            letterCount++;
            widget.insert(widget.itemNo);
            wordState.add(LetterComponent(
              itemNo:widget.itemNo,
              letterNo:letterCount-1,
              change:widget.change
            ));

          });
        }, child: Icon(Icons.exposure_plus_1,color: Colors.white,))
      ],);
  }
}

class LetterComponent extends StatefulWidget {
  final int itemNo,letterNo;
  final Function change;
  LetterComponent({this.itemNo,this.letterNo,this.change});
  @override
  _LetterComponentState createState() => _LetterComponentState();
}

class _LetterComponentState extends State<LetterComponent> {
  int pos=0;
  final letterRot=['[^AEIOU .,:]','A','E','I','O','U'];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      setState(() {
        pos=(pos+1)%6;
//        print(pos);
        widget.change(widget.itemNo,widget.letterNo,letterRot[pos]);
      });
    }, child:Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white
        )
      ),
      width: 40.0,
      height: 40.0,
      child: Center(
        child: Text(pos==0?'':letterRot[pos],
        style: TextStyle(color: Colors.white),),
      ),

    ));
  }
}



