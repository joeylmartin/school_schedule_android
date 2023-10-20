import java.lang.Math;

class EventClass{
  String event_name; // string of event name (NOT PURELY DECORATIVE; USED IN HASHTABLES)
  int[] event_color; //array storing r,g,b of arc
  float sAngle; //starting angle of arc
  float eAngle; //ending angle of arc
  
  float text_size;
  float text_x;
  float text_y;
  float mid_ang;
  
  int start_time; //means initial start time -- important for rotating arcs
  int end_time; // initial final time
  
  int name_length;
 
 
 
 
 
  boolean multi_line; //boolean indicating whether the event name is multiple lines long
  String[] event_name_parts; //used if the event_name is multiple lines long
  
  
  ArrayList<float[]> char_locations = new ArrayList<float[]>();
  
  
  
  EventClass(int _stime, int _etime, String _en){
    start_time = _stime;
    end_time = _etime;
    event_name = _en;
    
    event_color = event_colors.get(event_name);
    
    sAngle = (start_time-360+arc_shift)*((2*PI)/1440);//conv. time from minutes+change to angle(in radians)
    eAngle = (end_time-360+arc_shift)*((2*PI)/1440);
    
    multi_line = event_name.indexOf("@") !=-1? true: false;
    if(multi_line == true){
      event_name_parts = event_name.split("@");
    }
    name_length = (multi_line == true) ? event_name.length()-1 : event_name.length();
    
    
    text_size = 2*(end_time-start_time);
    text_size /= (multi_line == true) ? event_name_parts[0].length() : event_name.length();
    
    
    text_size = (text_size > (RES_FACTOR/16)) ? (RES_FACTOR/16) : text_size;//if above text size cap, set to cap. TODO: UPDATE FOR DYNAMIC RESOLUTION
    
    set_angles();
    
  }
  
  void set_char_locations(String text, int radius){
    float CHAR_SPACING = radians(text_size/10); //angle between characters
    float offset = (CHAR_SPACING*(text.length()/2)); //offset of first char from mid angle
    
    if(text.length() % 2 == 0){
      offset -= CHAR_SPACING * 0.5;
    }
    
    float char_angle = mid_ang - offset + PI/2; //angle of first char
    
    for(int i = 0; i <  text.length(); i++){
      float char_x = sin( char_angle) * (radius);
      float char_y = cos( char_angle) * (radius);
      char_locations.add(i, new float[]{char_angle,char_x, char_y});
      char_angle += CHAR_SPACING;
    } 
  }
  
  void set_angles(){  //update angles for arc shift
    sAngle = (start_time-360+arc_shift)*((2*PI)/1440);//conv. time from minutes+change to angle(in radians)
    eAngle = (end_time-360+arc_shift)*((2*PI)/1440);
    mid_ang = (eAngle + sAngle)/2;
    if(multi_line == false){
      set_char_locations(event_name, TEXT_PADDING);
    }
    else{
      event_name_parts = event_name.split("@");
      set_char_locations(event_name_parts[0], TEXT_PADDING-20);
      set_char_locations(event_name_parts[1], TEXT_PADDING+10);
    }
  }
}
