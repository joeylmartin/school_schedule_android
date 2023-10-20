
Context context;
Vibrator v;

Day current_day; 

int ref_d = day();
int ref_m = month();
int ref_y = year();

int last_minute = minute();

float arc_shift;

void setup(){
  
  context = getActivity();
  v = ((Vibrator)context.getSystemService(context.VIBRATOR_SERVICE));
  
  noStroke();
  fullScreen();
  textFont(createFont("Monospaced-Bold", 20 * displayDensity));
  textAlign(CENTER,CENTER);
  
  RES_FACTOR = (width > height) ? height : width;
  initialize_consts();
  
  current_day = new Day(ref_d,ref_m,ref_y);
}

void draw(){
  //TODO UPDATE ARC SHIFT FOR DAY CHANGE
  if(minute() != last_minute){
    arc_shift = -((hour()*60)+minute());//find amount to shift arcs by
    current_day.update_arcs = true;
    last_minute = minute();
  }
  
  background(247, 248, 252);
  current_day.draw_schedule();
  current_day.update_arcs = false;
}
void mouseReleased(){
  //TODO: add checking for first and final days of school
  if(mouseX < (width/3)){
    if(ref_d == 1 && ref_m == 1){
      ref_d = 31;
      ref_m = 12;
      ref_y = 2020;
    }
    else{
      if(ref_d == 1){
        ref_d = month_lengths[ref_m-1];
        ref_m--;
  }
      else{
        ref_d--;
      }
    }
    v.vibrate(50);
  }
  
  else if(mouseX > (2*(width/3))){
    //check if day is new years
    if(ref_d == 31 && ref_m == 12){
      ref_d = 1;
      ref_m = 1;
      ref_y = 2021;
    }
    else{
      if(month_lengths[ref_m-1] == ref_d){
        ref_m++;
        ref_d = 1;
      }
      else{
        ref_d++;
      }
    }
    v.vibrate(50);
  }
  else if(mouseY < (height/3)){
    ref_d = day();
    ref_m = month();
    ref_y = year();
    v.vibrate(300);
  }
  current_day = new Day(ref_d,ref_m,ref_y);
}
