var person={name:'john',surname:'Doe'}      //assign object to vraiable person

function changeName(p){p.name='Andrew'};
changeName(person);
console.log(person)
//{name: "Andrew", surname: "Doe"}
var b=person                                                    //assign person to new variable b
//b
//{name: "Andrew", surname: "Doe"}
delete b; // -- cannot delete entire object
//false
delete person;
//false
console.log(b);
//{name: "Andrew", surname: "Doe"}

function changeName(p){p.name='Andrew'; p1=p; return p1};       // p1 is global so lives after function call
changeName(person);
//{name: "Andrew", surname: "Doe"}
console.log(p1);
//{name: "Andrew", surname: "Doe"}
function changeName(p){p.name='Andrew'; var p1=p; return p1};   // p1 is local so does not lives after function call 
p1=null; // howto delete an object variable
//null
delete p1;
//true
console.log(typeof(p1));
//VM396:1 Uncaught ReferenceError: p1 is not defined
//    at <anonymous>:1:1
//(anonymous) @ VM396:1

console.log(person);
//{name: "Andrew", surname: "Doe"}                              //deleting p1 as above does not modify person

p2=person                                                       //defining p2 as person
//{name: "Andrew", surname: "Doe"}
console.log(p2);
//{name: "Andrew", surname: "Doe"}
p2={name:'leo',surname:'dan'};                                  //redefining entirely p2 with an object with same structure does not change person
//{name: "leo", surname: "dan"}
console.log(person);
//{name: "Andrew", surname: "Doe"}

p2=person                                                       //defining p2 as person
//{name: "Andrew", surname: "Doe"} 
p2.name='leo'                                                   //changing p2.name properties changes also person
//"leo"
console.log(person);
//{name: "leo", surname: "Doe"}

console.log(b);                                                             //b previously defined as person
//{name: "leo", surname: "Doe"}
console.log(person);
//{name: "leo", surname: "Doe"}

person=null                                                     //reassigning person does not delete b !!
//null
console.log(b);
//{name: "leo", surname: "Doe"}