unit personlist;

interface
uses sysutils;

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

var
   head	      : pNodePtr;

function find(cLast, cFirst, cMM : str30 ; cDD, cYY : integer) : pNodePtr;
procedure printAll();
procedure init();
procedure delete(cFirst, cLast, cMM : str30 ; cDD, cYY : integer );
procedure printPerson(personVar :   personT);
procedure printYear (yearVar	:   integer);
procedure insert(newN :  pNode);
procedure addPerson(first,last, address, month : str30 ; date,year : integer; age : real);
procedure changeYear(cFirst, cLast, cMM : str30; cDD, cYY, newYear: integer);
procedure changeMonth(cFirst, cLast, cMM, newMonth : str30; cDD, cYY : integer);
procedure changeDay(cFirst, cLast, cMM : str30; cDD, cYY, newDay: integer );
   
Implementation
{***************** Functions ********************}


{************* FIND **************}
{* FIND returns a pointer to the
Node that precedes the node it is searching for. *}
   
function find(cLast, cFirst, cMM : str30 ; cDD, cYY : integer) : pNodePtr;
var
   tempPtr, prevPtr : pNodePtr;

begin
   if(head^.NodePtr = NIL) then
      begin
	 find := NIL;
	 EXIT;
      end;
   prevPtr := @head;
   tempPtr := prevPtr^.NodePtr;
   
   while (tempPtr <> NIL) do
   begin
   if((CompareStr(tempPtr^.person.last, cLast) = 0) AND (CompareStr(tempPtr^.person.first, cFirst) = 0) AND (tempPtr^.person.date.day = cDD) AND (tempPtr^.person.date.year = cYY) AND
      (CompareStr(tempPtr^.person.date.month, cMM) = 0)) then
      begin
	 find:= prevPtr;
	 EXIT;
      end;
   
   prevPtr := tempPtr;
   tempPtr := tempPtr^.nodePtr;
   end;
   
   find := NIL;
end; { find }

{********************* PROCEDURES ***********************}

procedure init();

   {headNode : pNodePtr;}
   
begin
   {*new(headNode.NodePtr);
   headNode.NodePtr := NIL;
   headNode.person.last := 'AAAAAAA';*}
   head := NIL;
end; {init}


{********** DELETE ************}
procedure delete(cFirst, cLast, cMM : str30 ; cDD, cYY : integer );
var
   tempPtr, prevPtr :   pNodePtr;

begin
   prevPtr := find(cFirst, cLast, cMM, cDD, cYY);
   if (prevPtr <> NIL) then
      begin
	 tempPtr := prevPtr^.nodePtr;
	 prevPtr^.nodePtr := tempPtr^.nodePtr;
	 dispose(tempPtr);
      end;
end;{ delete }


{******** PRINT PERSON *******}

procedure printPerson(personVar	:  personT);
begin
  
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
end; { printPerson }

{******** PRINT YEAR *************}

procedure printYear (yearVar :  integer);
var
   tempPtr :  pNodePtr;

begin
   tempPtr := @head;
   if(head^.NodePtr <> NIL) then
      begin
	 while(tempPtr <>  NIL) do
	 begin
	    if(tempPtr^.person.date.year = yearVar) then
	       printPerson(tempPtr^.person);
	 end;
      end;
end; { printYear }

{************** INSERT *************}

procedure insert(newN : pNode);
{*Assumes that pNode head is an unused node, and that the pNodePtr is set
to NIL during node creation.*}

var
   cur, next : pNodePtr; { Pointers for finding where to put a Node }

begin
   
   if (head = NIL) then
   begin
      head := @newN;
      exit;
   end;

   writeln('Head is ');
   printPerson(head^.person);

   cur := head;
   next := cur^.NodePtr;
  
   while(next <> NIL) do
   begin
       if ((CompareStr(cur^.person.last, newN.person.last) < 0) AND (CompareStr(newN.person.last, next^.person.last)<0)) then
	 break;
      cur := next;
      next := next^.NodePtr;
   end;
   cur^.NodePtr := @newN;
   newN.NodePtr := next;

   writeln('Prev Person Is ');
   printPerson(cur^.person);
   writeln('Next Person Is ');
   if (newN.NodePtr <> NIL) then
      printPerson(newN.NodePtr^.person) 
   else
      writeln('NIL');
   
end;

{*************** ADD PERSON *********}
procedure addPerson(first,last, address, month : str30 ; date,year : integer; age : real);
var
   newP	   : personT;
   newNode : pNode;
   newD : DateRec;

begin

   newP.first := first;
   newP.last := last;
   newP.address := address;

   newD.month := month;
   newD.day := date;
   newD.year := year;

   newP.date := newD;
   newP.age := age;

   newNode.person := newP;
   new(newNode.nodePtr);
   {newNode.nodePtr := NIL;}

   printPerson(newNode.person);
	  
   insert(newNode);
end;

{************* PRINT ALL *************}
procedure printAll();
var
   tempPtr :  pNodePtr;
begin
   writeln('BEGIN PRINT ALL');
   tempPtr := head;
      while(tempPtr <> nil) do
      begin
	 writeln('Begin While');
	 printPerson(tempPtr^.person);
	 writeln('Print Person');
	 tempPtr := tempPtr^.nodePtr;
      end;
end; { printAll }

{********* CHANGE YEAR *************}
procedure changeYear(cFirst, cLast, cMM	: str30; cDD, cYY, newYear: integer);
var
   tempPtr :  pNodePtr;
begin
   tempPtr := find(cfirst, cLast, cMM, cDD, cYY);
   if(tempPtr <> nil) then
      tempPtr^.NodePtr^.person.date.year := newYear;
end; { changeYear }

{********** CHANGE MONTH **********}
procedure changeMonth(cFirst, cLast, cMM, newMonth : str30; cDD, cYY : integer);
var
   tempPtr :  pNodePtr;
begin
   tempPtr := find(cfirst, cLast, cMM, cDD, cYY);
   if(tempPtr <> nil) then
      tempPtr^.NodePtr^.person.date.month := newMonth;
end; { changeMonth }

{********* CHANGE DAY ************}
procedure changeDay(cFirst, cLast, cMM : str30; cDD, cYY, newDay: integer );
var
   tempPtr :  pNodePtr;
begin
   tempPtr := find(cfirst, cLast, cMM, cDD, cYY);
   if(tempPtr <> nil) then
      tempPtr^.NodePtr^.person.date.day := newDay;
end; { changeDay }

end.