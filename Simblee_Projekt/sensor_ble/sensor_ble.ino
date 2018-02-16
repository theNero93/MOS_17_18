#include <SimbleeBLE.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_LSM9DS0.h>
#include <Adafruit_Sensor.h>

Adafruit_LSM9DS0 sensor = Adafruit_LSM9DS0();
int led = 13;
float middle = 0.0;
bool isConnected = false;
bool hasMiddle = false;
float oldValue = 0.0;

void setupSensor()
{
  // Setup the gyroscope
  sensor.setupGyro(sensor.LSM9DS0_GYROSCALE_245DPS); 
}

void setup() { 
  Serial.begin(9600);
  
  // led used to indicate that the Simblee is advertising
  pinMode(led, OUTPUT);
  
  SimbleeBLE.deviceName = "frle1"; 
  SimbleeBLE.customUUID = "1234";
//  SimbleeBLE.advertisementInterval = 200;
//  SimbleeBLE.advertisementData = "step";
  SimbleeBLE.txPowerLevel = 4;
  SimbleeBLE.connectable = true;
  
  isConnected = false;
  hasMiddle = false;
  digitalWrite(led, LOW);

  if (!sensor.begin())
  {
    Serial.println("Oops ... unable to initialize the LSM9DS0. Check your wiring!");
    while (1);
  }
  
  Serial.println("Found LSM9DS0 9DOF");

  SimbleeBLE.begin();
}

void loop() {
  if (isConnected) {
    
//    sensor.read();
    
//    if (hasMiddle) {
//      Serial.println("gotit");
//    } else {
//      sendValues();
//    }

    if (hasMiddle) {
      checkStrike();
    } else {
      calculateMiddle();
    }
  }
  delay(100);
}

void SimbleeBLE_onAdvertisement(bool start) {
  if (start) {
    Serial.println("Advertising started");
  } else {
    Serial.println("Advertising ended");
  }
}

void SimbleeBLE_onConnect() {
  Serial.println("Connected!");
  isConnected = true;
//  digitalWrite(led, HIGH);
}

void SimbleeBLE_onDisconnect() {
  Serial.println("Disconnected");
  isConnected = false;
  digitalWrite(led, LOW);
  oldValue = 0.0;
}

void sendValues() {
  delay(1);
  SimbleeBLE.sendInt(1);
  Serial.println("sent 1");
//  Serial.println(sensor.gyroData.z);
//  SimbleeBLE.sendFloat(sensor.gyroData.z);
}

void SimbleeBLE_onReceive(char *data, int len) {

  Serial.print("received: ");
  for (int i=0; i<len; i++) {
    int temp = data[i];
    Serial.print(temp);
    Serial.print(" ");
  }
  Serial.println();
  
//  int control = data[0];
//  // toggle LED
//  if (control == 0) {
//    digitalWrite(LED, LOW);
//  } else if (control == 1) {
//    digitalWrite(LED, HIGH);
//  }
}

void checkStrike() {
  sensor.read();
  float newValue = sensor.gyroData.z;
  if(oldValue >= middle && newValue < middle) { 
     sendValues();
  }
  oldValue = newValue;
  Serial.print("old: ");Serial.print(oldValue);Serial.println("");
  
}

void calculateMiddle() {
  int count = 0;
  int sum = 0;
  
  while (count < 500) {
    sensor.read();
    sum = sum + sensor.gyroData.z;
    count = count +1;
    delay(20);
  }
  middle = sum/500;
  Serial.print("Middle = ");Serial.print(middle);
  digitalWrite(led, HIGH);
  hasMiddle = true;
}

