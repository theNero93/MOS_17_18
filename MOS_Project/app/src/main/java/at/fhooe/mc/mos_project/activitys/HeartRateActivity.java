package at.fhooe.mc.mos_project.activitys;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

import at.fhooe.mc.mos_project.R;
import at.fhooe.mc.mos_project.logic.heart_rate.HeartRateMonitor;
import at.fhooe.mc.mos_project.logic.heart_rate.SimulationHRM;
import at.fhooe.mc.mos_project.logic.heart_rate.factory.SimulationFactory;

public class HeartRateActivity extends BaseActivity {
    final static String title = "Heart Rate Monitor";
    final static String fileName = "lichtenberg.csv";

    SimulationFactory sensorFactory;
    HeartRateMonitor heartRateMonitor;
    int heartRate = 100;
    TextView heartRateTextView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_heart_rate);
        onCreateDrawer(title);
        setupSiumlationHeartRate();
        //setHeartRate();
    }

    private void setupSiumlationHeartRate() {
        heartRateTextView = (TextView) this.findViewById(R.id.tv_steps);

        sensorFactory = new SimulationFactory(this, fileName);
        heartRateMonitor = new SimulationHRM(sensorFactory);


    }

    public void setHeartRate ()  {
        heartRate = heartRateMonitor.getHeartRate();
        heartRateTextView.setText("Heart Rate: " + heartRate);
    }

}
