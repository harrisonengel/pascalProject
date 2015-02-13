program class;
uses sysutils;

type
   str30 = packed array[1..30] of char;
   dateRec  = record
		 day   : integer;
		 month : str30;
		 year  : integer;
	      end;     
   personT   = record	
		 first : str30;
		 last  : str30;
		 date	   : dateRec;
		 age	   : real;
		 address   : String;
	       end;
   
   pNodePtr = ^pNode;
   pNode    = record
		 person	 : personT;
		 nodePtr :  pNodePtr;
	      end;
   
var personList : personT;
    head, tail  :  pNodePtr;

procedure initLL;
begin
   head := nil;
   tail := head;
end; { initLL }

function find(personVar :  personT) : pNodePtr;
var
   tempPtr, prevPtr : pNodePtr;
   done		    : boolean;
		    
begin
   done := false;
   if(head = nil) then
      exit;
   prevPtr := head;
   tempPtr := head;

   while true do
   begin
      if((CompareStr(tempPtr^.person.last, personVar.last) = 0) AND (CompareStr(tempPtr^.person.first, personVar.first) = 0) AND (tempPtr^.person.date.day = personVar.date.day) AND (tempPtr^.person.date.year =  personVar.date.year)
	 AND  (CompareStr(tempPtr^.person.date.month, personVar.date.month) = 0)) then
	 exit(prevPtr);
      if (tempPtr^.nodePtr^.nodePtr = nil) then
      begin
	 done := true;
      end;
      prevPtr := tempPtr;
      tempPtr := tempPtr^.nodePtr;
   end;
   exit(nil);
end; { find }

procedure delete(personVar :  personT);
var
   tempPtr, prevPtr : pNodePtr;
	 
begin
   prevPtr := find(personVar);
   tempPtr := prevPtr^.nodePtr;
   if(prevPtr<>nil) then
   begin
      if(tempPtr = head) then
	 head := head^.nodePtr
      else
      begin
	 prevPtr^.nodePtr := tempPtr^.nodePtr;
      end;
   end;
end; { delete }

procedure printPerson(personVar	: personT);
begin
   write(personVar.first, ' ');
   write(personVar.last, ' ');
   if(personVar.date.day < 10) then
      write('0', personVar.date.day, ' ')
   else
      write(personVar.date.day, ' ');
   write(personVar.date.month, ' ');
   write(personVar.date.year, ' ');
   write(personVar.age, ' ');
   writeln(personVar.address);
end; { printPerson }

procedure printYear (yearVar : integer);
var
   tempPtr : pNodePtr;
   
begin
   tempPtr := head;
   if(head <>  nil) then
   begin
         while(tempPtr^.nodePtr^.nodePtr <> nil) do
	 begin
	    if(tempPtr^.person.date.year = yearVar) then
	       printPerson(tempPtr^.person);
	    tempPtr := tempPtr^.nodePtr;
	 end;
   end;
end; { printYear }

procedure printAll();
var
   tempPtr :  pNodePtr;

begin
   tempPtr := head;
   if(head <> nil) then
   begin
      while(tempPtr^.nodePtr^.nodePtr <> nil) do
      begin
	 printPerson(tempPtr^.person);
	 tempPtr := tempPtr^.nodePtr;
      end;
   end;
end; { printAll }

procedure changeYear(cFirst, cLast, cMM : str30; cDD, cYY, newYear: integer);

var
   tempPtr : pNodePtr;

begin
   tempPtr := find(cfirst, cLast, cMM, cDD, cYY);
    if(tempPtr <> nil) then
       tempPtr^.person.date.year := newYear;
      
end; { changeYear }

procedure changeMonth(cFirst, cLast, cMM : str30; cDD, cYY; newMonth: str30 );

var
   tempPtr : pNodePtr;

begin
   tempPtr := find(cfirst, cLast, cMM, cDD, cYY);
   if(tempPtr <> nil) then
	  tempPtr^.person.date.month := newMonth;

end; { changeMonth }

procedure changeDay(cFirst, cLast, cMM : str30; cDD, cYY, newDay: integer );

var
   tempPtr : pNodePtr;
  
begin
   tempPtr := find(cfirst, cLast, cMM, cDD, cYY);
   if(tempPtr <> nil) then
	  tempPtr^.person.date.day := newDay;

end; { changeDay }

