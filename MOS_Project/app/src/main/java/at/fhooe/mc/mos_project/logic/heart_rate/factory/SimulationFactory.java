package at.fhooe.mc.mos_project.logic.heart_rate.factory;


import android.content.Context;
import android.util.Log;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import at.fhooe.mc.mos_project.logic.heart_rate.models.HeartRate;
import at.fhooe.mc.mos_project.logic.util.CSVReader;

/**
 * Created by Martin on 19.12.2017.
 */

public class SimulationFactory implements SensorFactory {
    final static String tag = "SimulationFactory";
    Context context;
    String fileName;
    CSVReader csvReader;
    List<String[]> csvData;


    public SimulationFactory(Context _context, String _fileName) {
        this.context = _context;
        this.fileName = _fileName;
        csvReader = new CSVReader(context, fileName);
        if (readCSVData()) {
            Log.i(tag, "Length file: " + csvData.size());
        } else {
            Log.e(tag, "Unable to read CSV");
        }

    }

    //TODO: Fill Heart rate with csf data
    public HeartRate createHRM () {
        return csvToHeartRate();
    }


    private boolean readCSVData () {
        try {
            csvData = csvReader.readCSV();
            return true;
        }catch (IOException _ioe) {
            Log.e(tag, "Error reading CSV: " + _ioe.getMessage());
            return false;
        }
    }

    private HeartRate csvToHeartRate() {
        String [] line = getNextLine();
        HeartRate hr = new HeartRate();
        if (line.length > 0) {

            for (int i = 0; i < line.length; i++) {
                int temp = Integer.valueOf(line[i]);
                switch (i) {
                    case HeartRate.ALTITUDE:
                        hr.setAltitude(temp);
                        break;
                    case HeartRate.HEARTRATE:
                        hr.setHeartRate(temp);
                        break;
                    case HeartRate.EPOC:
                        hr.setEpoc(temp);
                        break;
                    case HeartRate.VENTILATION:
                        hr.setVentilation(temp);
                        break;
                    case HeartRate.VOTWO:
                        hr.setvOtwo(temp);
                        break;
                    case HeartRate.ENERGY:
                        hr.setEnergy(temp);
                        break;
                    case HeartRate.SPEED:
                        hr.setSpeed(temp);
                        break;
                    case HeartRate.CADENCE:
                        hr.setCadence(temp);
                        break;
                    case HeartRate.TEMP:
                        hr.setTemperature(temp);
                        break;
                    case HeartRate.DISTANCE:
                        hr.setDistance(temp);
                        break;
                    case HeartRate.RESPRATE:
                        hr.setRespirationRate(temp);
                        break;
                    case HeartRate.SECONDS:
                        hr.setSecounds(temp);
                        break;
                    case HeartRate.IBM:
                        hr.setiBM(temp);
                        break;
                    case HeartRate.CORRECTED:
                        hr.setCorrected(temp);
                        break;
                }
            }
            return hr;
        } else {
            Log.d(tag, "Reading new Line Failed");
        }

        return hr;
    }

    private String[] getNextLine () {
        if (csvData != null && csvData.size() > 0) {
            Iterator<String[]> csvDataIterator = csvData.iterator();
            if (csvDataIterator.hasNext()){
                return csvDataIterator.next();
            }else {
                return new String[10];
            }
        } else {
            Log.d(tag, "WTF IS HAPPENDING");
            return new String[10];
        }

    }

}
