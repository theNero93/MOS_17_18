# MOS_17_18
Link zum Repo: https://github.com/theNero93/MOS_17_18

#### App with server and step detection

- Done in Project
- Step Detection mit Android, iOS und Hardware

#### Heart-rate-related extensions

- Done in Project
- LiveSessionViewController

#### Calculation of energy expenditure from heart-rate

- Done in Project
- Calculator Logic

#### Database

- Firebase

#### Step detection method by Jimenez

- equivalent Hardware Detection by Nora Wokatsch
- calculations on Microcontroller Lilypad Simblee BLE Board
	- collecting 500 Values
	- calculate middle
	- start step detection: everytime (lastValue >= middle && currentValue < middle)
	- thats a step 
- values are from the z - axis of a gyroscope sensor
	- messures the rotation
- sends a notification to the iPhone, when step detected
- via Bluetooth 
- iPhone starts and stops messuring and counts steps
