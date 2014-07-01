import controlP5.*;   // Need to import the library
ControlP5 cp5;        // Create an object to use the library
XML xml;
int start_time;      // Add a holder for the startup time in milliseconds 
int start_time2;
int i=0; int k=0;
int sa=-1;int sb=-1;int sc=-1;int sd=-1;
int ea=-1;int eb=-1;int ec=-1;int ed=-1;
int a = 0; int b = 0; int c = 0; int d = 0;
int[] hzone = new int[200];
int[] freq = new int[200];
int n=0;
void setup()
{
   start_time=millis();   // Make a time stamp when setup runs
   start_time2=millis();   // Make a time stamp when setup runs
   size(200, 200);
   background(100, 100, 100);
   
   cp5  = new ControlP5(this);     // Need to init object
   
   cp5.addButton("browse")   // This creates a button
    .setValue(0)
    .setPosition(40, 80)
    .setSize(120,20);
    
   cp5.addButton("upload")   // This creates a button
    .setValue(0)
    .setPosition(40, 160)
    .setSize(120,20);
}


void draw()    // Notice we don't need any draw code
{
 
}


void browse()   // Function is automatically made with name in quotes
{
   if(millis()-start_time<1000){return;}
   println("You pressed the button");
   selectInput("Select a file to process:", "fileSelected");
}

void upload()   // Function is automatically made with name in quotes
{
   if(millis()-start_time2<1000){return;}
   println("You pressed run!");
   //selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) 
{
  if (selection == null) 
  {
    println("Window was closed or the user hit cancel.");
  } 
  else 
  {
    println("User selected " + selection.getAbsolutePath());
    xml = loadXML(selection.getAbsolutePath());
    getHRdata();
  }
}

void getHRdata()
{
  XML firstChild = xml.getChild("calendar-items/exercise/result/samples/sample/values");
  String heartratelist = firstChild.getContent();
  int[] phr = int(split(heartratelist, ','));
  int hrlen = phr.length;
  int rounds = hrlen/60;
  println (rounds);
  int[] hr = new int[rounds];
  int[] subhr = new int[60];
  int max1=0;
  for (i=0;i<rounds; i++)
  {
    subhr = subset(phr, i*60, 60);
    max1 = max(subhr);
    if((max1 >=50) && (max1 <=200))
    {
      hr[k]=max1;
      print(max1 + ",");
      k++;
    }
  }
  findPatterns(hr, rounds);
}

void findPatterns(int[] hr, int rounds)
{
  k=0;
  for(i=0;i<rounds;i++)
  {
    if((hr[i]>50) && (hr[i]<=95))
    {
      if(i>0)
      {
        if((i-1)==eb)
        {
          b= eb-sb+1;
          formZone(b,2,4);
          sb=-1; eb=-1;
        }
        else if ((i-1)==ec)
        {
          c= ec-sc+1;
          formZone(c,3,1);
          sc=-1; ec=-1;
        }
        else if ((i-1)==ed)
        {
          d= ed-sd+1;
          formZone(d,4,0);
          sd=-1; ed=-1;
        }
      }
      
      if(sa==-1)
        sa=i;
      ea=i;
    }
    else if((hr[i]>95) && (hr[i]<=130))
    {
      if(i>0)
      {
        if((i-1)==ea)
        {
          a= ea-sa+1;
          formZone(a,1,5);
          sa=-1; ea=-1;
        }
        else if ((i-1)==ec)
        {
          c= ec-sc+1;
          formZone(c,3,1);
          sc=-1; ec=-1;
        }
        else if ((i-1)==ed)
        {
          d= ed-sd+1;
          formZone(d,4,0);
          sd=-1; ed=-1;
        }
      }
      if(sb==-1)
        sb=i;
      eb=i;
    }
    else if((hr[i]>130) && (hr[i]<=165))
    {
      if(i>0)
      {
        if((i-1)==eb)
        {
          b= eb-sb+1;
          formZone(b,2,4);
          sb=-1; eb=-1;
        }
        else if ((i-1)==ea)
        {
          a= ea-sa+1;
          formZone(a,1,5);
          sa=-1; ea=-1;
        }
        else if ((i-1)==ed)
        {
          d= ed-sd+1;
          formZone(d,4,0);
          sd=-1; ed=-1;
        }
      }
      if(sc==-1)
        sc=i;
      ec=i;
    }
    else if((hr[i]>165) && (hr[i]<=200))
    {      
      if( i>0)
      {
        if((i-1)==eb)
        {
          b= eb-sb+1;
          formZone(b,2,4);
          sb=-1; eb=-1;
        }
        else if ((i-1)==ec)
        {
          c= ec-sc+1;
          formZone(c,3,1);
          sc=-1; ec=-1;
        }
        else if ((i-1)==ea)
        {
          a= ea-sa+1;
          formZone(a,1,5);
          sa=-1; ea=-1;
        }
      }
      if(sd==-1)
        sd=i;
      ed=i;
    }
  }
  if ((i-1)==ea)
  {
    a= ea-sa+1;
    formZone(a,1,5);
    sa=-1; ea=-1;
  }
  else if((i-1)==eb)
  {
    b= eb-sb+1;
    formZone(b,2,4);
    sb=-1; eb=-1;
  }
  else if ((i-1)==ec)
  {
    c= ec-sc+1;
    formZone(c,3,1);
    sc=-1; ec=-1;
  }
  else if ((i-1)==ed)
  {
    d= ed-sd+1;
    formZone(d,4,0);
    sd=-1; ed=-1;
  }  
}
  
void formZone(int val, int zone, int limit)
{
  if(val>limit)
  {
    if(n!=0 && hzone[n-1]==zone)
    {
      freq[n-1] = freq [n-1] + val;
    }
    else
    {
      hzone[n]=zone;
      freq[n]=val;
      println("Z:"+ zone + "V:" + val);
      n++;
    }
  }
}

