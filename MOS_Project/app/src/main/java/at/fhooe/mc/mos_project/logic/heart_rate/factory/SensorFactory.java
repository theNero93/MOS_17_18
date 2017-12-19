package at.fhooe.mc.mos_project.logic.heart_rate.factory;

import android.content.Context;

import at.fhooe.mc.mos_project.logic.heart_rate.models.HeartRate;

/**
 * Created by Martin on 19.12.2017.
 */

public interface SensorFactory {


    abstract HeartRate createHRM ();
}
