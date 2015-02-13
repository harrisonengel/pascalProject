unit personlist
interface
uses sysutils;

procedure insert(list : PersonList; newN : pNode);
{*Assumes that pNode head is an unused node, and that the pNodePtr is set
to NIL during node creation.*}

var
   cur, next : ^pNode; { Pointers for finding where to put a Node }

begin
   cur := list.head;
   next := list.head.pNodePtr;

   while(next <> NIL) do
   begin
      cur := next;
      next := next.pNodePtr;
      if ((CompareStr(cur^.person.last, newN.person.last) < 0) && (CompareStr(newN.person.last, next^.person.last)<0)) then
	     break;
   end
   cur^.pNodePtr := @newP;
   if(next <> NIL)then
      newP.pNodePtr := next;
end;

procedure addPerson(list : PersonList; first,last, address, month : string; date,year : integer; age : real);
var
   newP	   : personT;
   newNode : pNode;
   newD : DateRec;

begin
   newP.first := first;
   newP.last := last;
   newP.address := address;

   newD.mmm := month;
   newD.dd := date;
   newD.year := year;

   newP.date := newD;
   newP.age := age;
   newP.pNodePtr := NIL;
	  
   insert(list, newP);
end;
