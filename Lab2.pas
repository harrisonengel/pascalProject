program Lab2(input, output);

type str30 = packed array [1..30] of char;
   
var data	       : TextFile;
   func, ch, deleteWhat : char;
   i, day, year	       : integer;
   firstName, LastName, month  : str30;
   age		       : real;
   address	       : String;

begin
   assign(data, 'Lab2.txt');
   reset(data);
   read(data,func);
   
   (*reads in first an last name, and DOB if I, D, or C*)
   if(func = 'I' OR func = 'D' OR func = 'C') then
      (*to account for space there*)
      read(data, ch);

      (*read in first letter of first name*)
      read(data, ch); 
      i := 1;
      (*get first name characters until it hits a space*)
      while(ch <> ' ')
          do begin
           firstname[i] := ch;
           read(data, ch);
           i := i + 1;
	  end;
   
      (*to account for space*)
      read(data, ch);

      i:= 1;
      (*get last name characters until it hits a space*)
      while(ch <> ' ')
         do begin
	    lastName[i] := ch;
	    read(data, ch);
	    i := i + 1;
	 end;
   
     (*read in day*)
     read(data, day);
   
     (*to account for space*)
     read(data, ch);

     (*read in first character of month*)
     read(data, ch);
     i := 1;
     (*get month characters until it hits a space*)
     while(ch <> ' ')
	  do begin
      	     month[i] := ch;
	     read(data, ch);
	     i := i + 1;
	  end;

    (*read in year*)
    read(data, year);
    if(func = 'I') then
       (*read in age*)
       read(data, age);

       (*read in address*)
       readln(data, address);

       (*insert function*)
       write('Insert');
   
    else if(func = 'C')then
       (*read in what to change*)
       read(data, deleteWhat);
       if(deleteWhat = 'M') then
          (*to account for space*)
	  read(data, ch);

         (*read in first character of month*)
          read(data, ch);
          i := 1;
         (*get month characters until it hits a space*)
          while(ch <> ' ')
	             do begin
			month[i] := ch;
			read(data, ch);
			i := i + 1;
		     end;
         (*change month function*) 
          writeln('Change month');
   
       else if(deleteWhat = 'D') then
          (*read in day*)
	  read(data, day);
          (*change day function*)
          writeln('Change day');

       else
        (*read in year*)
         read(data, year);
        (*change year function*)
         writeln('Change year');
       
     else
       (*delete function*)
       writeln('Delete');
else
    Try
      readln(data, year)
    Except
      On
   end.
