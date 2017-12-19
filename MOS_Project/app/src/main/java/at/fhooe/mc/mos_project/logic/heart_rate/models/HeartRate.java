package at.fhooe.mc.mos_project.logic.heart_rate.models;

/**
 * Created by Martin on 19.12.2017.
 */

public class HeartRate {
    int altitude;
    int heartRate;
    int epoc;
    int ventilation;
    int vOtwo;
    int energy;
    int speed;
    int cadence;
    int temperature;
    int distance;
    int respirationRate;
    int secounds;
    int iBM;
    int corrected;

    public static final short ALTITUDE = 0, HEARTRATE = 1,
            EPOC = 2, VENTILATION = 3, VOTWO = 4, ENERGY = 5, SPEED = 6,
            CADENCE = 7, TEMP = 8, DISTANCE = 9, RESPRATE = 10, SECONDS = 11,
            IBM = 12, CORRECTED = 13;





    public HeartRate() {
    }


    public HeartRate(int altitude, int heartRate, int epoc, int ventilation, int vOtwo, int energy, int speed, int cadence, int temperature, int distance, int respirationRate, int secounds, int iBM, int corrected) {
        this.altitude = altitude;
        this.heartRate = heartRate;
        this.epoc = epoc;
        this.ventilation = ventilation;
        this.vOtwo = vOtwo;
        this.energy = energy;
        this.speed = speed;
        this.cadence = cadence;
        this.temperature = temperature;
        this.distance = distance;
        this.respirationRate = respirationRate;
        this.secounds = secounds;
        this.iBM = iBM;
        this.corrected = corrected;
    }


    public int getAltitude() {
        return altitude;
    }

    public void setAltitude(int altitude) {
        this.altitude = altitude;
    }

    public int getHeartRate() {
        return heartRate;
    }

    public void setHeartRate(int heartRate) {
        this.heartRate = heartRate;
    }

    public int getEpoc() {
        return epoc;
    }

    public void setEpoc(int epoc) {
        this.epoc = epoc;
    }

    public int getVentilation() {
        return ventilation;
    }

    public void setVentilation(int ventilation) {
        this.ventilation = ventilation;
    }

    public int getvOtwo() {
        return vOtwo;
    }

    public void setvOtwo(int vOtwo) {
        this.vOtwo = vOtwo;
    }

    public int getEnergy() {
        return energy;
    }

    public void setEnergy(int energy) {
        this.energy = energy;
    }

    public int getSpeed() {
        return speed;
    }

    public void setSpeed(int speed) {
        this.speed = speed;
    }

    public int getCadence() {
        return cadence;
    }

    public void setCadence(int cadence) {
        this.cadence = cadence;
    }

    public int getTemperature() {
        return temperature;
    }

    public void setTemperature(int temperature) {
        this.temperature = temperature;
    }

    public int getDistance() {
        return distance;
    }

    public void setDistance(int distance) {
        this.distance = distance;
    }

    public int getRespirationRate() {
        return respirationRate;
    }

    public void setRespirationRate(int respirationRate) {
        this.respirationRate = respirationRate;
    }

    public int getSecounds() {
        return secounds;
    }

    public void setSecounds(int secounds) {
        this.secounds = secounds;
    }

    public int getiBM() {
        return iBM;
    }

    public void setiBM(int iBM) {
        this.iBM = iBM;
    }

    public int getCorrected() {
        return corrected;
    }

    public void setCorrected(int corrected) {
        this.corrected = corrected;
    }
}
