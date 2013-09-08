/**
 * This sends latest quake info over serial communication
 * Note: The receiving end needs to run first
 */
 
import processing.serial.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.*;
import java.text.*;

Serial sPort;
int updateInterval = 15; // seconds
String lastID = "";
double curLat = -41.305204;
double curLon = 174.777518;
int updateTimer = 0;

void setup() {
  // println(Serial.list());
  // Change to the right Arduino port on your environment
  sPort = new Serial(this, Serial.list()[4], 9600);
 
  background(80);
  size(250, 68);
  
  // Info text
  textFont(createFont("Helvetica", 20, true));
  textSize(20);
  text("Quake Update", 10, 32);
  textSize(12);
  text("Check your LCD for the update", 10, 52);
  
  // Give Arduino some time to get ready
  // before sending data
  delay(2000);
}

void draw() {
  if(seconds() >= updateTimer) {
    update();
    updateTimer = seconds() + updateInterval;
  }
}

/**
 * Main function for getting and sending latest quake info
 */
void update() {
  String status = "";
  XML feed = getFeedContent();
  // We only show the first item (latest)
  XML firstItem = getFeedFirstItem(feed);
  QuakeInfoItem qItem = new QuakeInfoItem(firstItem, curLat, curLon);
  
  if(!lastID.equals(qItem.getID())) {
    if(qItem.getMagnitute() >= 4.0) status = "c";
    
    // Status line
    send(status);
    // First display line
    send(strJustify(qItem.getFormattedDate(), qItem.getFormattedTime(), 16));
    // Second display line
    send(strJustify(qItem.getFormattedMagnitute(), qItem.getLocation(), 16));
    
    lastID = qItem.getID();
  }
}

/**
 * Seconds since the program starts 
 */
int seconds() {
  return millis() / 1000;
}

/**
 * Send a string over serial line by appending 
 * newline at the end of the string
 */
void send(String str) {
  str = str + "\n";
  sPort.write(str);
}
