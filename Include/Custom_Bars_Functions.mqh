

// Utility functions for Custom Bars Indicator

// Compare two doubles with current symbol precision (Digits)
bool equal(double a, double b) {
    return NormalizeDouble(a, Digits) == NormalizeDouble(b, Digits);
}

// Integer equality check
bool equal(int a, int b) {
    return a == b;
}

// Check and update (by reference) if double changed
bool checkChange(double & a, double b) {
    if (!equal(a, b)) {
        a = b;
        return true;
    } else {
        return false;
    }
}

// Check and update (by reference) if int changed
bool checkChange(int & a, int b) {
    if (a != b) {
        a = b;
        return true;
    } else {
        return false;
    }
}

// Array resize helpers for int array
void arrayResize(int & a[], int s) {
    ArrayResize(a, s);
}

// Array resize helpers for double array
void arrayResize(double & a[], int s) {
    ArrayResize(a, s);
}

// Setup custom bar timeData (timeframe boundaries)
void initTimeFrame(int & timeData[], int period, int time) {
    if (time <= period) {
        timeData[1] = period * 60; // one bar
    } else {
        timeData[1] = period * 60 * int(time / period); // multiple bars fit in higher timeframe
    }
}

// Convert index to time (in seconds)
int timeFromIndex(int i) {
    return int(iTime(NULL, 0, i));
}

// Convert timestamp to bar index
int indexFromTime(int t) {
    return iBarShift(NULL, 0, t);
}

// Return true if a new "zone" (custom timeframe) started
bool newZone(int & t[], int current) {
    int zone = getTimeZone(t[1], current);
    if (t[0] != zone) {
        t[0] = zone;
        return true;
    } else {
        return false;
    }
}

// Calculate zone number for a given timeframe and current time
int getTimeZone(int timeframe, int current) {
    return int(current / timeframe);
}

// Chart scale (zoom level) utility
int returnChartScale() {
    return int(ChartGetInteger(0, CHART_SCALE, 0));
}

// Set histogram bar width based on current chart scale (zoom)
void updateBarWidth(int & w) {
    if (returnChartScale() == 5) {
        w = 13;
    }
    if (returnChartScale() == 4) {
        w = 6;
    }
    if (returnChartScale() == 3) {
        w = 3;
    }
    if (returnChartScale() == 2) {
        w = 2;
    }
    if (returnChartScale() == 1) {
        w = 1;
    }
    if (returnChartScale() == 0) {
        w = 1;
    }
}

// Switch chart to bar/candlestick mode
void setBarMode() {
    ChartSetInteger(0, CHART_MODE, 1);
}

// Switch chart to line mode
void setLineMode() {
    ChartSetInteger(0, CHART_MODE, 2);
}

// Count of (non-counted) bars to update
int returnMaxBars() {
    return MathMax(Bars - 1 - IndicatorCounted(), 0);
}

// Setup one index for histogram plot
void init_HIST(int & n, double & b[], int st, int s, color c) {
    SetIndexBuffer(n, b);
    SetIndexStyle(n, DRAW_HISTOGRAM, st, s, c);
    n++;
}

// Setup one index for line plot
void init_LINE(int & n, double & b[], int st, int s, color c) {
    SetIndexBuffer(n, b);
    SetIndexStyle(n, DRAW_LINE, st, s, c);
    n++;
}

// Connects dots (draws line for non-contiguous history) between two points in time
void connectDots(double & array[], double current, int currentT, double last, int lastT) {
    if (currentT != lastT) {
        double step = ((last - (current)) / double(indexFromTime(lastT) - indexFromTime(currentT)));
        for (int v = 0; v <= (indexFromTime(lastT) - indexFromTime(currentT)); v++) {
            array[indexFromTime(currentT) + v] = (current) + (double(v) * step);
        }
    }
}

