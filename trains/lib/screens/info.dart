import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("Informazioni sull'app"),
        backgroundColor: Color(0xff9b0014),
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical, 
        child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20,right:20),
        child: Column(
          children: [
            SizedBox(
                height: 20,
            ),
            //Center(
              Text(
                'Trains ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,                                  
                  fontWeight: FontWeight.bold,
                )
              ),
            //),
            SizedBox(
                height: 20,
            ),
            Text(
              "Quest'app è stata pensata per poter valutare lo stato di affollamento dei treni regionali italiani."+ 
              "\nAll'utente viene suggerita una lista dei treni in partenza presso la stazione più vicina alla posizione dell'utente."+
              "\nUna volta scelto il treno da prendere si potrà osservare lo stato di affollamento di tale treno basato sulle valutazioni effettuate dagli altri utenti."+
              "\nQuando l'utente si troverà nel treno potrà aggiungere la sua valutazione, l'utente che valuta viene premiato con l'assegnazione di tre tipologie diverse di punteggi, sulla base dei punti accumulati verrà calcolato un livello di esperienza."+
              "\nI punti e il livello sono osservabili nel profilo dell'utente, e sono contraddistinti da tre simboli differenti:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18.0,                                  
                //fontWeight: FontWeight.w500,
              )
            ),
            SizedBox(height:20,),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.assignment_turned_in, size: 40, color:Colors.black),
                  title: RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:"Punti valutazione",
                          style:TextStyle(
                            fontWeight: FontWeight.bold, 
                          ),
                        ),
                        TextSpan(
                          text:"\nAd ogni valutazione vengono incrementati di 10;"
                        ),
                      ]
                    ),  
                  ),
                ),
                SizedBox(height:15,),
                ListTile(
                  leading: Icon(Icons.train, size: 40, color:Colors.black),
                  title: RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:"Punti treno",
                          style:TextStyle(
                            fontWeight: FontWeight.bold, 
                          ),
                        ),
                        TextSpan(
                          text:"\nVengono incrementati di 10 se l'utente valuta un treno di una fascia oraria non ancora valutato.\n(Il treno della stessa fascia oraria in giorni differenti è considerato lo stesso treno);"
                        ),
                      ]
                    ),  
                  ),
                ),
                SizedBox(height:15,),
                ListTile(
                  leading: Icon(Icons.location_on, size: 40, color:Colors.black),
                  title: RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:"Punti stazione di partenza",
                          style:TextStyle(
                            fontWeight: FontWeight.bold, 
                          ),
                        ),
                        TextSpan(
                          text:"\nVengono incrementati di 20 se l'utente valuta un treno preso da una stazione nella quale non aveva ancora eseguito alcuna valutazione."
                        ),
                      ]
                    ),  
                  ),
                  /*title: Text(
                    "sono i punti relativi alla stazione di partenza vengono incrementati di 20 se l'utente valuta un treno preso da una stazione nella quale non aveva ancora eseguito alcuna valutazione.",
                    style:TextStyle(
                      fontSize: 18.0,
                      color:Colors.black, 
                    ),
                  ),  */                
                ),
              ],
            ),
            
            
            /*Text(
              "Icon sono i punti valutazione ad ogni valutazione vengono incrementati di 10"+
              "Icon sono i punti relativi al treno vengono incrementati di 10 se l'utente valuta un treno di una fascia oraria non ancora valutato. (Il treno della stessa fascia oraria in giorni differenti è considerato lo stesso treno)."+
              "Icon sono i punti relativi alla stazione di partenza vengono incrementati di 20 se l'utente valuta un treno preso da una stazione nella quale non aveva ancora eseguito alcuna valutazione.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18.0,                                  
                //fontWeight: FontWeight.w500,
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.assignment_turned_in, size: 40),
                  Text(
                    "sono i punti valutazione ad ogni valutazione vengono incrementati di 10",
                    //textAlign:TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18.0,
                      color:Colors.black,                      
                    ),
                  ),
                ],
              ),
            */
            
          ]
        ),
      ), 
      ),
    );
  }
}