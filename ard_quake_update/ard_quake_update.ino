#include <LiquidCrystal.h>

/**
 * Display 2 lines of a quake info item and 
 * turn an led based on a given status - 'c' turns red LED on, otherwise green LED.
 *
 * Expected data coming from serial line is in form of lines 
 * where each line finishes by newline character "\n".
 * First line contains a status, one character that signifies the criticality of the quake item.
 * Second and third lines are displayed as they are. 
 *
 * For example:
 *   c\n12/03/13   21:43\nM4.0   Sedden\n
 */

const byte ROWS = 3, COLS = 16;
const byte lcdOpPin = 9; // LCD operating voltage pin
const byte criticalLedPin = 7;
const byte normalLedPin = 6;
const byte ledInterval = 10; // Seconds

unsigned int criticalLedTimer = 0;
unsigned int normalLedTimer = 0;

char line[ROWS][COLS];
int lineIndex = 0, lineCharIndex = 0;
LiquidCrystal lcd(12, 11, 2, 3, 4, 5);

void setup() {
  Serial.begin(9600);
  pinMode(criticalLedPin, OUTPUT);
  pinMode(normalLedPin, OUTPUT);
  
  lcd.begin(COLS, ROWS);
  // Splash screen
  lcd.print("= Quake Update =");
  
  // Set lcd's contrast
  pinMode(lcdOpPin, OUTPUT);
  analogWrite(lcdOpPin, 100);
}

void loop() {
  char ch; 
  
  if(Serial.available()) {
    ch = Serial.read();
    
    if(ch ==  '\n') {
      lineIndex++;
      lineCharIndex = 0;
    }
    else {
      line[lineIndex][lineCharIndex] = ch;
      lineCharIndex++;
    }
    
    // Ready for displaying
    if(lineIndex == ROWS) {
      // We're interested in first character of the status (first) line
      if(line[0][0] == 'c') {
        criticalLedTimer = seconds() + ledInterval;
      }
      else {
        normalLedTimer = seconds() + ledInterval;
      }
      
      lcd.clear();
      // Print line one
      lcd.print(line[1]);
      // Position to second row and print line two
      lcd.setCursor(0, 1);
      lcd.print(line[2]);
      
      // Reset variables for next display
      lineIndex = 0;
      lineCharIndex = 0;
      memset(line[0], 0, COLS);
      memset(line[1], 0, COLS);
      memset(line[2], 0, COLS);
    }
  }
  
  updateLeds();
}

/**
 * Turn an LEDs on or off based on theirs timer
 */
void updateLeds() {
  digitalWrite(criticalLedPin, criticalLedTimer > seconds());
  digitalWrite(normalLedPin, normalLedTimer > seconds());
}

/**
 * Convert Arduino millis() api to seconds
 */
int seconds() {
  return millis() / 1000;
}
