Directory with resources to build and control the maze presented in the paper. 


The Arduino codes ensure the precise control of the mouse ports (Sanworks) and light cues. Bonsai is used to synchronize distinct data streams (such as camera, Arduino, miniscope). Bonsai further outputs the following files:
* video of the behavior (.avi)
* position of the mouse body center (.csv)
* an event file with the following columns:
  + event (e.g. nose poke, trial start)
  + timestamp (camera frame)
  + X,Y position of the mouse body center in the given camera frame
  + X,Y position of the trigger zone center in the given trial
  + size of the square-shaped zone in the given trial
