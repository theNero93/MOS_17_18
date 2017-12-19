package at.fhooe.mc.mos_project.logic.util;

import android.content.Context;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Martin on 19.12.2017.
 */

public class CSVReader {
    Context context;
    String fileName;
    List <String[]> rows = new ArrayList<>();

    public CSVReader(Context _context, String _fileName) {
        this.context = _context;
        this.fileName  = _fileName;
    }

    public List<String[]> readCSV() throws IOException {
        InputStream inputStream = context.getAssets().open(fileName);
        InputStreamReader isReader = new InputStreamReader(inputStream);
        BufferedReader bufferedReader = new BufferedReader(isReader);
        String line;
        String csvSplitBy = ",";

        bufferedReader.readLine();

        while ((line = bufferedReader.readLine()) != null) {
            String [] row = line.split(csvSplitBy);
            rows.add(row);
        }

        return rows;

    }

}
