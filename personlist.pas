{********************************************************
*  
*    Program Name: Lab# 2
*  
*    Student Names:      Harrison Engel, Rebecca Gonzolez
*    Semester:           Spring 2015
*    Class & Section:    COSC 30403
*    Instructor:         Dr. Comer
*    Due Date:           February 17, 2014
*  
*    Unit Overview:
*         This unit contains the Linked List, functions
*         and proceduresrelated to the linked to to be
*         used in Lab 2.
*  
*    Input:
*         The functions and procedures in this unit take
*         information from the main method and convert
*         it into actions on the linked list.
*  
*    Output:
*          The program gives feedback to the user about the
*          success/failure of each command and prints to the
*          terminal when it reads in the command P. Everything
*          printed to the screen also prints to a text file.
*  
*    Program Limitations:
*          (1) The maximum size of first and last names are
*              30 characters.
*          (2) Without any modification this code will only
*              read from "Lab2.txt".
*  
*    Significant Program Variables:
*  
*       * See Variables section below.
*  
*     References:
*      (1) Credit to Mr. Roger Frank (Asylum Computer
*	   Services LLC) for suggesting this problem as
*	   a programming assignment for his AP Computer Science
*
****************************************************************}


unit personlist;
interface
uses sysutils;


{****************** Type Declarations ********************

str30          : Basic string used in this program.

dateRec        : Record that contains Date information
    day        : Day (DD) of a dateRec. Held in an integer
    month      : Month (MMM) of a dateRec. Held in a str30
    year       : Year (YYYY) of a dateRec. Held in an integer

personT        : Record that represents a person
    first      : First Name of a person. str30
    last       : Last Name of a person. str30
    date       : Date of Death for a person. dateRec
    age        : Age of a person. The number left of the
                 decimal represents years. The right
                 represents months. Real
    address    : Represents the address of person. String

pNodePtr       : Pointer to pNode.
 
pNode          : Node for the Linked List.
     person    : personT for each node.
     nodePtr   : Pointer to the next node

**********************************************************}


type
      str30 = packed array[1..30] of char;
      dateRec = record
		   day	 : integer;
		   month : str30;
		   year	 : integer;
		end;	 
      personT = record
		   first   : str30;
		   last	   : str30;
		   date	   : dateRec;
		   age	   : real;
		   address : string;
		end;	   

      pNodePtr = ^pNode;
      pNode    = record
		    person  : personT;
		    nodePtr : pNodePtr;
		 end;

{**************** GLOBAL VARIABLES ********************

head       : Head node of the linked list

cur        : Used to run through a LL

*****************************************}
var
   head : pNodePtr;
   

{**************** Function Prototypes *******************}

function  find(cLast, cFirst, cMM : str30 ; cDD, cYY : integer) : pNodePtr;
procedure printAll(var output : text );
procedure init();
procedure delete(var output : text ; cFirst, cLast, cMM : str30 ; cDD, cYY : integer );
procedure printPerson(var output	: text ; personVar :   personT);
procedure printYear (var output : text ; yearVar	:   integer);
procedure insert(newN :  pNodePtr);
procedure addPerson(var output : text ; first,last, address, month : str30 ; dd, year : integer; age : real);
procedure changeYear(var output : text ; cFirst, cLast, cMM : str30; cDD, cYY, newYear: integer);
procedure changeMonth(var output : text ; cFirst, cLast, cMM, newMonth : str30; cDD, cYY : integer);
procedure changeDay(var output : text ; cFirst, cLast, cMM : str30; cDD, cYY, newDay: integer );


Implementation

{***************** Functions ********************}


{************************** find ********************************

 The find function takes the first name, last name, month, day,
 and years of a Node being searched for. It returns a pointer to
 the node BEFORE the one that we're looking for. This allows it
 to be deleted or printed.
 
*****************************************************************}
 
function find(cLast, cFirst, cMM : str30 ; cDD, cYY : integer) : pNodePtr;
var
   tempPtr, prevPtr : pNodePtr;

begin
   
   {* If head = nil then this is the
   first person in our list. *}

   if(head = NIL) then
      begin
	 find := NIL;
	 EXIT;
      end;
  
   prevPtr := head;
   tempPtr := prevPtr;

   { Read until the end of the LL }
   while (tempPtr <> NIL) do
   begin
      { Exit loop if we found the correct Node (temp) }
   if((CompareStr(tempPtr^.person.last, cLast) = 0) AND (CompareStr(tempPtr^.person.first, cFirst) = 0) AND (tempPtr^.person.date.day = cDD) AND (tempPtr^.person.date.year = cYY) AND
      (CompareStr(tempPtr^.person.date.month, cMM) = 0)) then
   begin
	 find := prevPtr;
	 EXIT;
      end;

      { Otherwise keep moving pointers down the list }
   prevPtr := tempPtr;
   tempPtr := tempPtr^.nodePtr;
   end;

   { If the Node is not found return NIL }
   
   find := NIL;
end; { find }

{********************************************************************}



{************************* PROCEDURES ********************************}


{************************** init  ********************************

  Init() is a simple procedure that initializes our linked list
  by allocating memory for a head nod and setting the head ptr
  to null.

*****************************************************************}


procedure init();   
begin
   new(head);
   head := NIL;
end; {init}

{********************************************************************}




{************************** delete  ********************************

  The delete procedure takes the first name, last name, death date
(month, day, and year) and searches the linked list for a person
who matches those parameters exaclty, and then removes that person
from the linked list.

*****************************************************************}

procedure delete(var output	: text ;  cFirst, cLast, cMM : str30 ; cDD, cYY : integer );

{******* Variables ********
*  tempPtr : pNodePtr that sequentially moves down the
*            linked list to find the person to delete.
*  prevPtr : trails the tempPtr to correctly maintain
*            the linked list once the person is deleted.
*  *************************}
var
   tempPtr, prevPtr :   pNodePtr;

begin
   prevPtr := find(cLast, cFirst, cMM, cDD, cYY);
   {*prev pointer begins pointing the previous 
   person in the linked list (See find()).*}
   if (prevPtr <> NIL) then
   begin
      if (prevPtr = head) then
	 {* If prevPtr is head, then the person
	    to delete is the first person in
	 the list and head must be re-established.*}
      begin
	 tempPtr := head;
	 head := head^.nodePtr;
	 dispose(tempPtr);
	 EXIT;
      end;
      
	 tempPtr := prevPtr^.nodePtr;
	 prevPtr^.nodePtr := prevPtr^.nodePtr^.nodePtr;
	 dispose(tempPtr);

      writeln('', cLast, ', ', cFirst, ' was successfully deleted.');
      writeln(output, '', cLast, ', ', cFirst, ' was successfully deleted.');
   end;
   
   if (prevPtr = NIL) then { find() didn't find the person }
   begin
      writeln('Unable to find ', cLast, ', ', cFirst, ' with the given date of death.');
      writeln(output, 'Unable to find ', cLast,', ', cFirst, ' with the given date of death.');
   end;
      
end;{ delete }

{********************************************************************}




{******************* PrintPerson ********************************
*
*  PrintPerson() is a procedure that takes a personT and prints
*  a line about their information to a specified file and to
*  the command prompt.
*
*****************************************************************}

procedure printPerson(var output : text ; personVar	:  personT);
begin

   { Print to command line }
   write(personVar.first, ' ');
   write(personVar.last, ' ');
   if(personVar.date.day < 10) then
      write('0', personVar.date.day, ' ')
   else
      write(personVar.date.day, ' ');
   write(personVar.date.month, ' ');
   write(personVar.date.year, ' ');
   write(personVar.age : 4:2 , ' ');
   writeln(personVar.address);

   { Print to output file }
   write(output, personVar.first, ' ');
   write(output, personVar.last, ' ');
   if(personVar.date.day < 10) then
      write(output, '0', personVar.date.day, ' ')
   else
      write(output, personVar.date.day, ' ');
   write(output, personVar.date.month, ' ');
   write(output, personVar.date.year, ' ');
   write(output, personVar.age : 4:2 , ' ');
   writeln(output, personVar.address);
   
end; { printPerson }

{********************************************************************}



{************************** PrintYear ***************************
*
*  PrintYear is a procedure that takes an integer and loops
*  through the linked list and prints out the information about
*  each person to the command prompt and to a file.
*
*****************************************************************}

procedure printYear (var output : text ; yearVar :  integer);

{******* Variables ********
*  tempPtr : pNodePtr that sequentially moves down the
*            linked list to check all people in the list.
**************************}

var
   tempPtr :  pNodePtr;

begin

   { Give User Feedback }
   writeln('');
   writeln('Print Year Called. Printing all people from the year: ', yearVar);
   writeln('************************************************************');
   writeln('');

   writeln(output, '');
   writeln(output, 'Print Year Called. Printing all people from the year: ', yearVar);
   writeln(output, '************************************************************');
   writeln(output, '');

   
   tempPtr := head;
	 while(tempPtr <>  NIL) do
	 begin
	    if(tempPtr^.person.date.year = yearVar) then
	       printPerson(output, tempPtr^.person);
	    tempPtr := tempPtr^.NodePtr;
	 end;

   { Give User Feedback }
   writeln('');
   writeln('************************************************************');
   writeln(output, '');
   writeln(output, '************************************************************');
   writeln('');
   writeln(output, '');

end; { printYear }


{********************************************************************}



{******************* Insert  ***********************************
*
*  Insert() is a procedure that takes a pNodePtr and inserts it
*  into the Linked List alphabetically ascending.
* 
******************************************************************}

procedure insert(newN : pNodePtr);

{******* Variables ********
*  next   : pNodePtr that moves down the
*          LL and will eventually find the
*          Node that will succeed the one
*          that is being inserted.
*
*  cur    : pNodePtr that follows next and
*           will eventually point to the
*           Node that precedes the new node
*           to be inserted.
***************************}

var
   cur, next : pNodePtr; { Pointers for finding where to put a Node }

begin
   
   if (head = NIL) then { This is the only person in list }
   begin
      head := newN;
      exit;
   end;

   new(cur);
   new(next);
   
   cur := head;
   next := cur^.NodePtr;

   { Check to see if this person should be alphabetically first }
   if ((CompareStr(newN^.person.last, head^.person.last)) < 0)then
       begin
       newN^.NodePtr := head;
       head := newN;
       exit;
       end;

   { Loop through to find where to insert the new person }
   while(next <> NIL) do 
   begin
       if ((CompareStr(cur^.person.last, newN^.person.last) <= 0) AND (CompareStr(newN^.person.last, next^.person.last) <= 0)) then
	 break;
      cur := next;
      next := next^.NodePtr;
   end;
   cur^.NodePtr := newN;
   newN^.NodePtr := next;
   
end; { insert }

{********************************************************************}



{******************* addPerson ********************************
*
*  AddPerson() is a procedure that takes the first name, last name,
*  address, death date(mmm, dd, yyyy), and age of a person to add
*  and creates the date, personT, and allocates memory for a pNode
*  to add to the LL. It then calls inert(pNodePtr) to add the person
*  to the linked list.
*
******************************************************************}
procedure addPerson(var output : text ; first,last, address, month : str30 ; dd, year : integer; age : real);

{******* Variables ********
*  newPerson : personT record that stores the data
*              about the new person to be added.
*  newD      : DateRec record that stores date of
*              death information about the person
*  newPtr    : pNodePtr that is used to dynamically
*              allocate and assign data
*              to a new pNode.
***************************}

var
   newPerson : personT;
   newD	     : DateRec;
   newPtr    : pNodePtr;
   
begin

   {Dynamically allocates memory for a new node}
   new(newPtr);
   
   newPerson.first := first;
   newPerson.last := last;
   newPerson.address := address;

   {* Create the new Date record for this person *}
   newD.month := month;
   newD.day := dd;
   newD.year := year;

   newPerson.date := newD;
   newPerson.age := age;

   newPtr^.person := newPerson;

   new(newPtr^.nodePtr);

   {New Nodes nodePtr always starts as NIL}
   newPtr^.nodePtr := NIL;
	  
   insert(newPtr);{See Insert() procedure}

   writeln(last, ', ', first, ' successfully added');
   writeln(output, last, ', ', first, ' successfully added');
   
end; { addPerson }

{********************************************************************}


{******************* printAll  ********************************
*
*  The printAll() procedure takes no values and prints out information
*  about each person in the linked list. It prints to both the comand
*  prompt and to a file.
* 
*******************************************************************}
procedure printAll(var output : text );

{******* Variables ********
*  tempPtr : pNodePtr that sequentially moves down the
*            linked list to print each person in the list.
***************************}

var
   tempPtr :  pNodePtr;
begin

   { Give User Feedback }
   writeln(output, '');
   writeln(output, 'Printing All');
   writeln(output, '******************************');
   writeln(output, '');
   
   writeln('');
   writeln('Printing All');
   writeln('******************************');
   writeln('');

   
   tempPtr := head;
      while(tempPtr <> NIL) do
      begin
	 printPerson(output, tempPtr^.person);
	 tempPtr := tempPtr^.nodePtr;
      end;

   { Give User Feedback }
   writeln('');
   writeln(output, '');
   writeln(output, '******************************');
   writeln('******************************');
   writeln('');
   writeln(output, '');
   
end; { printAll }


{********************************************************************}



{******************* ChangeYear() ********************************
*
*  The changeYear() procedure takes the first name, last name,
*  date(dd, mm, yyyy) and new year value of a person who's year of
*  death needs to be changed in the list. It then finds the person
*  and changes their year value.
*  
********************************************************************}
procedure changeYear(var output : text ; cFirst, cLast, cMM	: str30; cDD, cYY, newYear: integer);

{******* Variables ********
*  tempPtr : pNodePtr used to access the person
*            who's information needs to be
*            changed.
****************************}

var
   tempPtr :  pNodePtr;
   
begin
   
   tempPtr := find(cLast, cFirst, cMM, cDD, cYY);

   { find() could not locate the person to change }
   if(tempPtr = nil) then
   begin
      writeln(output, cLast,', ', cFirst, ' not found.');
      writeln(cLast,', ', cFirst, ' not found.');
      EXIT;
   end;
   
   if(tempPtr = head) then
	 tempPtr^.person.date.year := newYear
   else
      tempPtr^.NodePtr^.person.date.year := newYear;

   writeln(output, cLast, ', ', cFirst, ' successfully changed.');
   writeln(cLast, ', ', cFirst, ' successfully changed.');
	    
end; { changeYear }


{********************************************************************}



{******************* ChangeMonth() ********************************
*
*  The changeMonth() procedure takes the first name, last name,
*  date(dd, mm, yyyy) and new month value of a person who's month of
*  death needs to be changed in the list. It then finds the person
*  and changes the value.
*
*********************************************************************}
procedure changeMonth(var output : text ;  cFirst, cLast, cMM, newMonth : str30; cDD, cYY : integer);
{******* Variables ********
*  tempPtr : pNodePtr used to access the person
*            who's information needs to be
*            changed.
*****************************}
var
   tempPtr :  pNodePtr;
   
begin
   
   tempPtr := find(cLast, cFirst, cMM, cDD, cYY);

   { find() could not locate the person to change }
   if(tempPtr = NIL) then
   begin
      writeln(output, cLast,', ', cFirst, ' not found.');
      writeln(cLast,', ', cFirst, ' not found.');
      EXIT;
   end;
   
    if(tempPtr = head) then
       tempPtr^.person.date.month := newMonth
    else
       tempPtr^.NodePtr^.person.date.Month := newMonth;
   
   writeln(output, cLast, ', ', cFirst, ' successfully changed.');
   writeln(cLast, ', ', cFirst, ' successfully changed.');
   
end; { changeMonth }


{********************************************************************}



{******************* ChangeDay() ********************************
*
*  The changeDay() procedure takes the first name, last name,
*  date(dd, mm, yyyy) and new day value of a person who's day of
*  death needs to be changed in the list. It then finds the person
*  and changes the value.
*
**********************************************************************}
procedure changeDay(var output : text ;  cFirst, cLast, cMM : str30; cDD, cYY, newDay: integer );

{******* Variables ********
*  tempPtr : pNodePtr used to access the person
*            who's information needs to be
*            changed.
*****************************}
var
   tempPtr :  pNodePtr;

begin

   { find() could not locate the person to change }
   tempPtr := find(cLast, cFirst, cMM, cDD, cYY);

   if(tempPtr = NIL) then
   begin
      writeln(output, cLast,', ', cFirst, ' not found.');
      writeln(cLast,', ', cFirst, ' not found.');
      EXIT;
   end;

   if(tempPtr = head) then
       tempPtr^.person.date.day := newDay
   else
       tempPtr^.NodePtr^.person.date.day := newDay;
   
   writeln(output, cLast, ', ', cFirst, ' successfully changed.');
   writeln(cLast, ', ', cFirst, ' successfully changed.');

end; { changeDay }

{********************************************************************}


end.