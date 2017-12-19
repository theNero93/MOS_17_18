package at.fhooe.mc.mos_project.logic.heart_rate;

import at.fhooe.mc.mos_project.logic.heart_rate.factory.SensorFactory;
import at.fhooe.mc.mos_project.logic.heart_rate.factory.SimulationFactory;
import at.fhooe.mc.mos_project.logic.heart_rate.models.HeartRate;

/**
 * Created by Martin on 19.12.2017.
 */

public class SimulationHRM implements HeartRateMonitor {
    SensorFactory simFactroy;

    public SimulationHRM (SimulationFactory _factory) {
        simFactroy = _factory;
    }

    @Override
    public int getHeartRate() {
        HeartRate hr = simFactroy.createHRM();
        return hr.getHeartRate();
    }
}
