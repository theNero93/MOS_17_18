package at.fhooe.mc.mos_project.activitys;

import android.os.Bundle;

import at.fhooe.mc.mos_project.R;

public class MainActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        onCreateDrawer("Main Activity");
    }


}
