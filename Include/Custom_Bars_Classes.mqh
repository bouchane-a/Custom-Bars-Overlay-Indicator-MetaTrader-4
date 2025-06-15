

// Main Classes Definitions for Custom Bars Visualization

// Represents a single (custom timeframe) bar with all calculation logic
class CustomBar {

    public: 
        int timeData[],      // Stores [zone, period]
            index,           // Current bar index (loop variable)
            state,           // Bulls or Bears
            barTime,         // This bar time (seconds)
            lastBarTime,     // Prior bar time (seconds)
            barStartIndex,   // Index where bar starts
            barMiddleIndex;  // Midpoint index used for drawing
        double barOpen,      // Custom bar open
            barClose,        // Custom bar close
            barHigh,         // High
            barLow;          // Low
        bool newBar,         // true if this bar is a new higher TF bar
            bullsFlag,       // flag for bull line coloring alternatives
            bearsFlag;       // flag for bear line coloring alternatives

    // CustomBar constructor: initializes timeData
    CustomBar(int barTimeframe) {
        arrayResize(timeData, 2);
        initTimeFrame(timeData, Period(), barTimeframe);
    }

    // Main state machine for custom bar construction
    void Run() {
        // If this is a new custom bar zone...
        if (newZone(timeData, timeFromIndex(index - 1))) {

            newBar = true; // a new custom bar is starting

            barStartIndex = indexFromTime(barTime) - 1;
            barMiddleIndex = index + int((barStartIndex - index) / 2);

            barHigh = High[index];
            barLow = Low[index];

            barClose = Close[index];
            barOpen = Open[barStartIndex];

            if (barClose > barOpen) { // Bullish

                state = Bulls;
                bullsFlag = !bullsFlag;  // alternate to change color/shape lines

                // Search for high/low in this new range zone
                for (int j = index; j < indexFromTime(barTime); j++) {
                    barHigh = MathMax(barHigh, High[j]);
                    barLow = MathMin(barLow, Low[j]);
                }

            } else { // Bearish

                state = Bears;
                bearsFlag = !bearsFlag;

                for (int j = index; j < indexFromTime(barTime); j++) {
                    barHigh = MathMax(barHigh, High[j]);
                    barLow = MathMin(barLow, Low[j]);
                }
            }

            lastBarTime = barTime;
            barTime = timeFromIndex(index);
        }
    }

    // Entrypoint called each tick
    void Main() {
        index = loopIndex;
        newBar = false;
        Run();
    }

};

// Abstract visual object base, used for buffer index management
class VisualObject {

    public:
        static int totalBuffers;

    VisualObject() {}~VisualObject() {}

    // The current chart/indicator loop index
    int getIndex() {
        return loopIndex;
    }
};

// Initialize static variable
int VisualObject::totalBuffers = 0;

// Histogram shape for wicks & bodies (base for custom drawing)
class Histogram: public VisualObject {

    public:

        int histHIndex,  // buffer index for high part
            histLIndex,  // buffer index for low part
            histStyle,   // style of histogram
            histWidth;   // bar width

        double histHigh[],  // upper histogram values
            histLow[];      // lower histogram values

        color histClr;      // color of this histogram

    Histogram(int hist_Width, color hist_Clr) {
        histStyle = 0;
        histWidth = hist_Width;
        histClr = hist_Clr;
        histHIndex = totalBuffers;
        init_HIST(totalBuffers, histHigh, histStyle, histWidth, histClr);
        histLIndex = totalBuffers;
        init_HIST(totalBuffers, histLow, histStyle, histWidth, histClr);
    }

    // Draw the histogram for current getIndex()
    void draw(double high, double low) {
        int i = getIndex();
        histHigh[i] = high;
        histLow[i] = low;
    }

    // Draw with explicitly provided index
    void draw(double high, double low, int i) {
        histHigh[i] = high;
        histLow[i] = low;
    }

    // Update style when scale changes
    void updateStyle() {
        updateBarWidth(histWidth);
        SetIndexStyle(histHIndex, DRAW_HISTOGRAM, histStyle, histWidth, histClr);
        SetIndexStyle(histLIndex, DRAW_HISTOGRAM, histStyle, histWidth, histClr);
    }

};

// Simple line class for connecting open/close on body
class Line: public VisualObject {

    public:

        double line[];    // the plotting array

    Line(int lineStyle, Size lineWidth, color lineClr) {
        init_LINE(totalBuffers, line, lineStyle, lineWidth, lineClr);
    }

    // Draw line for current getIndex()
    void draw(double d) {
        int i = getIndex();
        line[i] = d;
    }

    // Connect line between two time/index points (used for higher TF bodies)
    void connect(double current, int currentT, double last, int lastT) {
        connectDots(line, current, currentT, last, lastT);
    }

};

// Main bars class (used for original timeframe bars overlay)
class MainBars: public VisualObject {

    public:

        Histogram * bullsWick;    // Bull upper/lower wick
        Histogram * bearsWick;    // Bear upper/lower wick
        Histogram * bullsBody;    // Bull body
        Histogram * bearsBody;    // Bear body

    MainBars(Size wickWidth, color bullClr, color bearClr) {
        int bodyWidth;
        updateBarWidth(bodyWidth);
        bullsWick = new Histogram(wickWidth, bullClr);
        bearsWick = new Histogram(wickWidth, bearClr);
        bullsBody = new Histogram(bodyWidth, bullClr);
        bearsBody = new Histogram(bodyWidth, bearClr);
    }

    ~MainBars() {
        delete bullsWick;
        delete bearsWick;
        delete bullsBody;
        delete bearsBody;
    }

    // Draws main time frame bars as histograms
    void draw(int state) {
        int i = getIndex();
        if (state > 0) {
            bullsWick.draw(High[i], Low[i]);
            bullsBody.draw(Close[i], Open[i]);
        } else {
            bearsWick.draw(High[i], Low[i]);
            bearsBody.draw(Open[i], Close[i]);
        }
    }

};

// Class for all custom/higher timeframe visualizations
class CustomBars: public VisualObject {

    public:

        // Bullish wicks, body, lines (2 sets for visual alternation)
        Histogram * bullsUpperWick;Histogram * bullsLowerWick;Histogram * bullsBody;
        Line * bullsUpperLine_1;Line * bullsLowerLine_1;Line * bullsUpperLine_2;Line * bullsLowerLine_2;

        // Bearish wicks, body, lines (2 sets for visual alternation)
        Histogram * bearsUpperWick;Histogram * bearsLowerWick;Histogram * bearsBody;
        Line * bearsUpperLine_1;Line * bearsLowerLine_1;Line * bearsUpperLine_2;Line * bearsLowerLine_2;

    CustomBars(Size wickWidth, Size bodyWidth, color bullClr, color bearClr) {
        // Bulls...
        bullsUpperWick = new Histogram(wickWidth, bullClr);
        bullsLowerWick = new Histogram(wickWidth, bullClr);
        bullsBody = new Histogram(bodyWidth, bullClr);
        bullsUpperLine_1 = new Line(0, bodyWidth, bullClr);
        bullsUpperLine_2 = new Line(0, bodyWidth, bullClr);
        bullsLowerLine_1 = new Line(0, bodyWidth, bullClr);
        bullsLowerLine_2 = new Line(0, bodyWidth, bullClr);

        // Bears...
        bearsUpperWick = new Histogram(wickWidth, bearClr);
        bearsLowerWick = new Histogram(wickWidth, bearClr);
        bearsBody = new Histogram(bodyWidth, bearClr);
        bearsUpperLine_1 = new Line(0, bodyWidth, bearClr);
        bearsUpperLine_2 = new Line(0, bodyWidth, bearClr);
        bearsLowerLine_1 = new Line(0, bodyWidth, bearClr);
        bearsLowerLine_2 = new Line(0, bodyWidth, bearClr);
    }

    ~CustomBars() {
        // Proper clean-up for all pointers
        delete bullsUpperWick; delete bullsLowerWick; delete bullsBody;
        delete bearsUpperWick; delete bearsLowerWick; delete bearsBody;
        delete bullsUpperLine_1; delete bullsLowerLine_1; delete bullsUpperLine_2; delete bullsLowerLine_2;
        delete bearsUpperLine_1; delete bearsLowerLine_1; delete bearsUpperLine_2; delete bearsLowerLine_2;
    }

    // Draw the custom bars by copying data from CustomBar logic object
    void draw(CustomBar & Bar) {

        int i = getIndex();

        if (Bar.newBar) {
            if (Bar.state == Bulls) {
                // Bull bar: upper wick, lower wick, bodies and connecting lines
                bullsUpperWick.draw(Bar.barHigh, Bar.barClose, Bar.barMiddleIndex);
                bullsLowerWick.draw(Bar.barOpen, Bar.barLow, Bar.barMiddleIndex);
                bullsBody.draw(Bar.barClose, Bar.barOpen);
                bullsBody.draw(Bar.barClose, Bar.barOpen, Bar.barStartIndex);

                if (Bar.bullsFlag) {
                    bullsUpperLine_1.connect(Bar.barClose, timeFromIndex(i), Bar.barClose, timeFromIndex(Bar.barStartIndex));
                    bullsLowerLine_1.connect(Bar.barOpen, timeFromIndex(i), Bar.barOpen, timeFromIndex(Bar.barStartIndex));
                } else {
                    bullsUpperLine_2.connect(Bar.barClose, timeFromIndex(i), Bar.barClose, timeFromIndex(Bar.barStartIndex));
                    bullsLowerLine_2.connect(Bar.barOpen, timeFromIndex(i), Bar.barOpen, timeFromIndex(Bar.barStartIndex));
                }

            } else {
                // Bear bar: upper wick, lower wick, bodies and connecting lines
                bearsUpperWick.draw(Bar.barHigh, Bar.barOpen, Bar.barMiddleIndex);
                bearsLowerWick.draw(Bar.barClose, Bar.barLow, Bar.barMiddleIndex);
                bearsBody.draw(Bar.barOpen, Bar.barClose);
                bearsBody.draw(Bar.barOpen, Bar.barClose, Bar.barStartIndex);

                if (Bar.bearsFlag) {
                    bearsUpperLine_1.connect(Bar.barOpen, timeFromIndex(i), Bar.barOpen, timeFromIndex(Bar.barStartIndex));
                    bearsLowerLine_1.connect(Bar.barClose, timeFromIndex(i), Bar.barClose, timeFromIndex(Bar.barStartIndex));
                } else {
                    bearsUpperLine_2.connect(Bar.barOpen, timeFromIndex(i), Bar.barOpen, timeFromIndex(Bar.barStartIndex));
                    bearsLowerLine_2.connect(Bar.barClose, timeFromIndex(i), Bar.barClose, timeFromIndex(Bar.barStartIndex));
                }
            }

        }

    }

};

