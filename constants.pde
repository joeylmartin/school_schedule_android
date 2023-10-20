import java.util.*;
import java.util.ArrayList;
import android.os.Vibrator;
import android.content.Context;

int RES_FACTOR; //hor. or vert. resolution; whichever is smaller
int PADDING; //spacing between end of arc and screen edge
int TEXT_PADDING; //distance from centre of screen to char
int ARC_WIDTH; //width of arc


//indexed based on modulo
String[] week_days = {"Wednesday","Thursday","Friday","Saturday","Sunday","Monday","Tuesday"};

int[] month_lengths = {31,29,31,30,31,30,31,31,30,31,30,31};

//cumulative days in a month from September 1
float[] cumulative_list_month = {122,153,181,212,242,273,0,0,0,30,61,91};

//includes all days to be exlcuded, indexed with num_days. i.e. holidays, pd days(weekends NOT included)
//float[] exceptions = {30,33,65,68,103,104,105,106,107,110,111,112,113,114,156,159,180,181,182,183,184,187,188,189,190,191,205,208,254,257};
float[] exceptions = {30,33,65,68,103,104,105,106,107,110,111,112,113,114,156,159,177,184,191,198,205,208, 215,216,217,218,219,220,222, 254,257};
//indexed by day/2, stores strings for each class.
//Time periods are: 8:45 to 10:20,10:20 to 11:40,12:25 to 1:45,1:45 to 3:05 and 3:05 to 3:45;
String[][] reference_schedule = {
{"TOK","English","Economics","Compute@rScience","Physics"},
{"Chemistry","French","Math","Physics","Spare"}, {"English","Economics","Compute@rScience","Spare","Chemistry"}, 
{"French","Math","Physics","Chemistry","Spare"}, {"Economics","Compute@rScience","TOK","English","Advisor"}, 
{"Physics","Chemistry","French","Math","Economics"} ,{"Compute@rScience","Spare","English","Economics","Spare"}, 
{"Math","Physics","Chemistry","French","Spare"}
};


//array storing time periods for each period(for every day except Tuesday)
int[][] class_time_periods = {{525,620},{620,700},{740,825},{825,905},{905,945}};
//array storing time periods for tuesday
int[][] class_time_periods_tues = {{575,645},{645,715},{760,835},{835,905},{905,945}};


//hashtable storing r,g,b for each event(key; event_name, val: int[r.g.b])
Hashtable<String, int[]> event_colors = new Hashtable<String, int[]>() {{
  put("Compute@rScience",new int[]{88,164,176});
  put("Math",new int[]{214,73,51});
  put("Physics",new int[]{121,173,220}); 
  put("French",new int[]{87,50,128});
  put("Chemistry",new int[]{12,124,89});
  put("TOK",new int[]{180,193,120});
  put("English",new int[]{222,217,111}); 
  put("Economics",new int[]{255,192,159}); 
  put("Advisor",new int[]{143,126,79}); 
  put("Spare",new int[]{173,247,182}); 
  put("Assembly@Sleep-in",new int[]{125,0,255}); 
  put("Lunch",new int[]{140,186,128}); 
  put("Sleep",new int[]{77,83,130});
  put("",new int[]{0,25,50}); //day change marker
}};

//hashtable storing events that depend on day of week. The stuff it contains needs to be initialized in a seperate function, as the calcs for text resolution are dependent on resolution.
Hashtable<String, EventClass[]> daily_events = new Hashtable<String, EventClass[]>();



void initialize_consts(){
  arc_shift = -((hour()*60)+minute());
  
  
  PADDING = int(RES_FACTOR / 10);
  ARC_WIDTH = int(PADDING * 3);
  TEXT_PADDING = ((RES_FACTOR/2)-PADDING) -int(ARC_WIDTH/8);
  
  daily_events.put("Monday", new EventClass[]{new EventClass(1350,1880,"Sleep"), new EventClass(700,740,"Lunch")});
  daily_events.put("Tuesday", new EventClass[]{new EventClass(1350,1880,"Sleep"), new EventClass(715,760,"Lunch"), new EventClass(525,575,"Assembly@Sleep-in") });
  daily_events.put("Wednesday", new EventClass[]{new EventClass(1350,1880,"Sleep"), new EventClass(700,740,"Lunch")});
  daily_events.put("Thursday", new EventClass[]{new EventClass(1350,1880,"Sleep"), new EventClass(700,740,"Lunch")});
  daily_events.put("Friday", new EventClass[]{new EventClass(1400,1880,"Sleep"), new EventClass(700,740,"Lunch")});
  daily_events.put("Saturday", new EventClass[]{new EventClass(1410,2010,"Sleep")});
  daily_events.put("Sunday", new EventClass[]{new EventClass(1350,2010,"Sleep")});
}



//matrix storing colours for text(Paradise Pink, Orange Yellow Crayola, Caribbean Green, Blue NCS and Midnight Green Eagle Green)
//CURRENTLY DEPRECATED GIVEN CURRENT UI DECISIONS -- i dunno i might use these colours later
int[][] text_colours = {{239,71,111},{255,209,102},{3,145,107},{17,138,178},{7,59,76}};
