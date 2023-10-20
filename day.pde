class Day{
  
  int d; //day
  int m; //month
  int y; //year
  
  int school_day_count; //from sept 9.
  int day_count; //from sept.9
  
  String weekday; // weekday ex. 'Saturday'
  String day_char; //school day num ex. 5.2
  
  String[] classes_today = {};//array storing classes today
  boolean is_school_today;
  
  boolean update_arcs = true;
  //Arraylist storing all events to happen today.
  ArrayList<EventClass> schedule = new ArrayList<EventClass>();
  
  public Day (int _d, int _m, int _y){
    d = _d;
    m = _m;
    y = _y;
    
    day_count = int(cumulative_list_month[m-1] -9 + d);//index days from september 9th
    weekday = week_days[day_count % 7];//find day of week based on modulo
    
    is_school_today = is_school_day(day_count);
    
    //if is school day:
    if(is_school_today != false){
      school_day_count = convert_to_school_index(int(day_count)); //school day number
      day_char = String.valueOf(Math.floorDiv(school_day_count,2) + 1) + "." + String.valueOf(school_day_count % 2 + 1);
      classes_today = reference_schedule[Math.floorDiv(school_day_count,2)]; //find classes taken today
    }
    
    
    configure_schedule();
    redraw();
  }
  
  void configure_schedule(){
    //add events based on day of week to schedule
    for(EventClass event : daily_events.get(weekday)){
      schedule.add(event);
    }
    
    //add events based on school day to schedule
    if(is_school_today != false){
      int[][] ref_class_time_periods;
      ref_class_time_periods = (weekday == "Tuesday") ? class_time_periods_tues : class_time_periods;
      
      //add school classes to schedule
      for(int i = 0; i < classes_today.length; i++){
        int[] time_period = ref_class_time_periods[i];
        schedule.add(new EventClass(time_period[0],time_period[1],classes_today[i]));
      }
    }
    
    
    schedule.add(new EventClass(1435,1445,""));//add marker for day change
  }
  
  
  void draw_schedule(){
    //add time marker at top
    fill(40,75,99);
    arc(width/2,height/2,RES_FACTOR-PADDING,RES_FACTOR-PADDING,radians(269),radians(271),PIE);
    
    for (EventClass event : schedule){
      //update arcs for new time
      if(update_arcs == true){
        event.set_angles();
      }


      //draw arc
      fill(event.event_color[0],event.event_color[1],event.event_color[2]);
      arc(width/2,height/2,RES_FACTOR-(PADDING*2),RES_FACTOR-(PADDING*2),event.sAngle,event.eAngle,PIE);


      textSize(event.text_size);
      fill(247, 248, 252);
      
      int char_modifier = 0;//shifts iterator by val to accomodate for new line seperators in event_name
      
      for(int i = 0; i < event.name_length; i++)
      {
        //shift character drawing by 1, if new line seperator.
        if(event.event_name.charAt(i) == '@'){
           char_modifier++;
        }
        
        float[] char_location = event.char_locations.get(i);
        
        //translate matrix for text
        pushMatrix();
        translate((width/2)+char_location[1],(height/2)-char_location[2]);
        rotate(char_location[0]);
        text(event.event_name.charAt(i+char_modifier), 0, 0);
        popMatrix();
        
        
      }
      
      
    }
    
    //add final circle in middle to punch hole
    fill(247, 248, 252);
    circle(width/2,height/2,(RES_FACTOR-PADDING)-ARC_WIDTH);
    
    
    //DRAW INFO IN MIDDLE
    fill(7,59,76);
    textSize(RES_FACTOR/22);
    if(is_school_today == true){
      text(day_char,width/2,(7*height)/16);
    }
    text(weekday,width/2,height/2);
    text(m + "/" + d + "/" + y,width/2,(9*height)/16);
  }
  
  
  
  
  //------ CLASS FUNCTIONS -------
  
  //algorithm to convert number of days since Sept 9 to number of SCHOOL days since Sept 9.
  int convert_to_school_index(int day_index){
    int school_day = 0;
    int week_num = Math.floorDiv(day_index+2,7);
    int school_index = day_index -(week_num*2);
    school_index -= num_exceptions(day_index);
    school_day = school_index - (Math.floorDiv(school_index,16)*16);
    return school_day;
  }
  //checks if today is a school day
  boolean is_school_day(float day_index){
    //checks if today is a weekend
    if(weekday == "Saturday" || weekday == "Sunday"){
      return false;
    }
    //check if day isn't in exceptions list(i.e holidays, pd days, etc.)
    for(int i = 0; i < exceptions.length; i++){
      if(exceptions[i] == day_index){
        return false;
      }
    }
    return true;
  }
  
  //checks number of exceptions that have passed since current date
  int num_exceptions(int day_index){
    int exception_count = 0;
    for(int i = 0; i < exceptions.length; i++){
      if(day_index >= exceptions[i])
      {
        exception_count++;
      }
      else
      {
        break;
      }
    }
    return exception_count;
  }
   
}
