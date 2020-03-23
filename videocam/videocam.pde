
import processing.video.*;

Capture cam;
PImage cam_image;

boolean mode_camera;

int bg_idx, fg_idx;

Movie[] bg_movie = new Movie[]{};
Movie[] fg_movie = new Movie[]{};
color key_color = color(0, 255, 0);

void setup() {
  size(640, 600);
  cam = new Capture(this, 640, 480);
  cam.start();
  
  // Carga opencv
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  
  bg_movie = new Movie[]{new Movie(this, "video\\smoke.mov"),
                         new Movie(this, "video\\city.mov")};
  fg_movie = new Movie[]{new Movie(this, "video\\woman.mov"),
                         new Movie(this, "video\\boy.mov"),
                         new Movie(this, "video\\people.mov")};
  
  for(Movie m : bg_movie) m.loop();
  for(Movie m : fg_movie) m.loop();
  
  bg_idx = 0;
  fg_idx = 0;
  
  setup_chroma();
  
  background(0);
}

void draw() {
  //background(0);
  
  if(cam.available())
  {
    cam.read();
    //PImage mask = mask_image(cam, color(255, 0, 50, 255));
    cam_image = createImage(cam.width, cam.height, ARGB);
    cam_image.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, cam_image.width, cam_image.height);
    
    
    if(!mode_camera)
      draw_chroma(fg_movie[fg_idx], bg_movie[bg_idx], key_color);
    else
      draw_chroma(cam_image, bg_movie[bg_idx], key_color);
  }
}

void keyPressed()
{
  
  
  if(key == '\n') {
    mode_camera = !mode_camera;
    background(0);
  }
  keyPressed_chroma();
  if(key == CODED)
  {
    background(0);
    if(keyCode == LEFT && bg_idx > 0) bg_idx--;
    if(keyCode == RIGHT && bg_idx < bg_movie.length - 1) bg_idx++;
    
    if(keyCode == UP && fg_idx > 0) fg_idx--;
    if(keyCode == DOWN && fg_idx < fg_movie.length - 1) fg_idx++;
  }
}

void mousePressed() {
  if(mouseButton == LEFT) {
    PImage sm = !mode_camera ? fg_movie[fg_idx] : cam_image;
    
    float w, h;
    w = sm.width;
    h = sm.height;
    
    if(0 <= mouseX && mouseX <= w && 0 <= mouseY && mouseY <= h && !apply_chroma)
    {
      if(sm.isLoaded()) sm.loadPixels();
      key_color = sm.pixels[(int)(mouseX + mouseY*w)];
    }
  }
}

void movieEvent(Movie m)
{
  m.read();
}
