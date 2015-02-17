{********************************************************
*
*  Program Name: Lab# 2
*
*  Student Names:      Harrison Engel, Rebecca Gonzolez
*  Semester:           Spring 2015
*  Class & Section:    COSC 30403
*  Instructor:         Dr. Comer
*  Due Date:           February 17, 2014
*
*  Program Overview:
*       This program reads specially formatted lines from
*       a text file that contain information about people
*       who were buried in a rural cemetary on Old Fish
*       Street, London during the period January 5, 1813
*       to July 10, 1853.
*
*  Input:
*       This program takes in specially formatted text files.
*       Each line contains a command and multiple command
*       records.
*         I = Insert
*         D = delete
*         P = Print
*         C = Change [M = Month; D = Day; y = year]
*
*  Output:
*        The program gives feedback to the user about the
*        success/failure of each command and prints to the
*        terminal when it reads in the command P. Everything
*        printed to the screen also prints to a text file.
*
*  Program Limitations:
*        (1) The input file must be in the specific format
*        (2) The maximum size of first and last names are
*            30 characters.
*        (3) Without any modification this code will only
*            read from "Lab2.txt".
*
*  Significant Program Variables:
*  
*     * See Variables section below.
*
*  References:
*       (1) Credit to Mr. Roger Frank (Asylum Computer
*           Services LLC) for suggesting this problem as
*           a programming assignment for his AP Computer
*           Science course.
*  
***********************************************************}

program Lab2(input, output);

{***************** USES *****************************

 This program uses the personlist unit, which contains
 the functions and procedures to make the linked list
 work.

*****************************************************}

uses personlist;

{****************** Type Declarations ******************

str30 :    The standard string used within this program.

*********************************************************}
type
   str30 = packed array [1..30] of char;


{****************** Variables **************************

----TextFile-----
data       : Holds the Text File to be read from.
output     : Holds the new Text File for output.

------Char-------
func       : Holds first command character of a line.
ch         : Holds characters while reading in a string.
changeWhat : Stores which piece of Date will be changed

-----Integer-----
i          : Basic counter for the program
day        : Stores Day (DD) while reading a line
year       : Stores Year (YY) from line
newDay     : Stores new date to change
newYear    : Stores new Year to change 

------str30------
firstName  : Stores first name from an Insert or Delete
lastName   : Stores last name from an Insert or Delete
month      : Stores month from line
newMonth   : Stores new month for a change command

------real------
age        : Stores the age of a person. The number to
             the left of the decimal point is the number
             of years, while the right are months.

------String----
address    : Does not need to be a str30 because it is
             read from the end of the line and because
             an address can be arbitrarily large.

*********************************************************}
var
   data					: TextFile;
   func, ch, changeWhat			: char;
   i, day, year, newDay, newYear	: integer;
   firstName, LastName, month, newMonth	: str30;
   age					: real;
   address				: String;
   output				: Text;

{***************** BEGIN MAIN PROGRAM *******************}

begin
   { Open Lab2.txt and prepare to read from the front. }
   assign(data, 'Lab2.txt');
   reset(data);
   
   { Create the text file to save runtime results}
   assign(output, 'runtimeOutput.txt');
   rewrite(output);
   
   { init() initailizes the Lined List }
   init();

   writeln('');
   writeln('********************************************************');
   writeln('*                                                      *');
   writeln('*                Cemetary Program                      *');
   writeln('*                      By:                             *');
   writeln('*                  Rebecca Gonzolez                    *');
   writeln('*                      and                             *');
   writeln('*                  Harrison Engel                      *');
   writeln('*                                                      *');
   writeln('********************************************************');

   writeln('');
   writeln(output, '********************************************************');
   writeln(output, '*                                                      *');
   writeln(output, '*                Cemetary Program                      *');
   writeln(output, '*                      By:                             *');
   writeln(output, '*                  Rebecca Gonzolez                    *');
   writeln(output, '*                      and                             *');
   writeln(output, '*                  Harrison Engel                      *');
   writeln(output, '*                                                      *');
   writeln(output, '********************************************************');

 { Loop through the entire file}  
 while (NOT eof(data)) do
 begin
    {* first character of a line is stored
    in *}
   read(data,func);

   {* Depending on the function different
   routes are taken for parsing it. *}
    
   if(func = 'P') then { print }
   begin
      if(EOLn(data)) then
      begin
	 { if just 'P', then print all }
	  printAll(output);
	 readln(data);
      end
      else {* Otherwise the command must be
	   printing out a year *}
      begin
      	 readln(data, year);
	 printYear(output, year);
      end
         
   end
    
   (*reads in first an last name, and DOB if I, D, or C*)
   else
   begin
      read(data, ch);
      read(data, ch); 

      { Read in first name }
      for i:= 1 to 30 do firstname[i] := #0;
      i := 1;
      while(ch <> ' ')
          do begin
           firstname[i] := ch;
           read(data, ch);
           i := i + 1;
	  end;
   
      { Read in last name }
      read(data, ch);
      for i:= 1 to 30 do lastname[i] := #0;
      i:= 1;
      while(ch <> ' ')
         do begin
	    lastName[i] := ch;
	    read(data, ch);
	    i := i + 1;
	 end;

      { Read in Date of Death }
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
  
    if(func = 'I') then { Insert }
    begin
       read(data, age);
       readln(data, address);
       addPerson(output, firstName, lastName, address, month, day, year, age);
    end
      
    else if(func = 'C')then { Change }
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
	  changeMonth(output, firstName, lastName, month, newMonth, day, year);
        end
       
        else if(changeWhat = 'D') then { Delete }
	begin
      	     readln(data, newDay);
	     changeDay(output, firstName, lastName, month, day, year, newDay);
         end
       
	else
	begin      
	   read(data, newYear);
	   changeYear(output, firstName, lastName, month, day, year, newYear);
	   readln(data);
	end
    end
    else
    begin
       delete(output, firstName, lastName, month, day, year);
       readln(data);
     end
   end; 
 end;

   { Close Files }
   close(output);
   close(data);   
 end.
