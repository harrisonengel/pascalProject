program Lab2(input, output);

uses personList;

type str30 = packed array [1..30] of char;
   
var data	       : TextFile;
   func, ch, changeWhat : char;
   i, day, year, pos, newDay, newYear    : integer;
   firstName, LastName, month, newMonth  : str30;
   age		       : real;
   address	       : String;

begin
   assign(data, 'Lab2.txt');
   reset(data);
 while not eof(data) do
 begin
   read(data,func);

   if(func = 'P') then
   begin
      if(EOLn(data)) then
      begin
	 printAll();
	 readln(data);
      end
      else
      begin
      	 readln(data, year);
	 printYear(year);
      end
         
   end
    
   (*reads in first an last name, and DOB if I, D, or C*)
   else
   begin
      read(data, ch);
      read(data, ch); 

      i := 1;
      while(ch <> ' ')
          do begin
           firstname[i] := ch;
           read(data, ch);
           i := i + 1;
	  end;
   

      read(data, ch);

      i:= 1;
      while(ch <> ' ')
         do begin
	    lastName[i] := ch;
	    read(data, ch);
	    i := i + 1;
	 end;
   
     read(data, day);
     read(data, ch);
     read(data, ch);

     i := 1;
     while(ch <> ' ')
	  do begin
      	     month[i] := ch;
	     read(data, ch);
	     i := i + 1;
	  end;
    
    read(data, year);
          
    if(func = 'I') then
    begin
       read(data, age);
       readln(data, address);
       addPerson(firstName, lastName, address, month, day, year, age);
    end
      
    else if(func = 'C')then
    begin
       read(data, ch);
       read(data, changeWhat);
       if(changeWhat = 'M') then
       begin
	  read(data, ch);
          read(data, ch);
	  newMonth[1] := ch;
          read(data, ch);
	  newMonth[2] := ch;
	  readln(data, ch);
	  newMonth[3] := ch;
	  changeMonth(firstName, lastName, month, newMonth, day, year);
        end
       
        else if(changeWhat = 'D') then
	begin
      	     readln(data, newDay);
	     changeDay(firstName, lastName, month, day, year, newDay);
         end
       
	else
	begin      
	   read(data, newYear);
	   changeYear(firstName, lastName, month, day, year, newYear);
	   readln(data);
	end
    end
    else
    begin
       delete(firstName, lastName, month, day, year);
       readln(data);
     end
   end; 
 end;
 end.
