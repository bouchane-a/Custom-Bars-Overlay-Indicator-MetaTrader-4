//+------------------------------------------------------------------+
//|            Custom Bars Overlay Indicator                         |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property link      "https://github.com/bouchane-a"
#property description "CUSTOM BARS"
#property indicator_buffers 28
#property strict


// Include input/config, utility functions, and classes
#include <Custom_Bars_Inputs.mqh>
#include <Custom_Bars_Functions.mqh>
#include <Custom_Bars_Classes.mqh>


// Pointers to main classes
MainBars   * mainBars;
CustomBars * customBars;
CustomBar  * bar;


// Core per-bar logic
void Main() {
    bar.Main();
    if (showMainBars) {
        mainBars.draw(bar.state);
    }
    if (showCustomBars) {
        customBars.draw(bar);
    }
}


// Indicator entrypoint - loops through bars for (re)draw
int start() {
    for (loopIndex = returnMaxBars(); loopIndex >= 1; loopIndex--) {
        Main();
        ObjectSetDouble(0, "Last Close", OBJPROP_PRICE, Close[1]); // Last close for reference
    }
    return (0);
}


// Initialization
int init() {
    bar = new CustomBar(customBarsTimeframe);
    mainBars = new MainBars(mainBarsWickWidth, mainBarsbullsColor, mainBarsbearsColor);
    customBars = new CustomBars(customBarsWickWidth, customBarsBodyWidth, customBarsbullsColor, customBarsbearsColor);
    #include <Custom_Bars_Config.mqh>
    scale = returnChartScale();
    setLineMode(); // set chart mode to line (for visibility)
    return (0);
}


// Cleanup when indicator is removed or chart closed
int deinit() {
    delete mainBars;
    delete customBars;
    delete bar;
    setBarMode(); // restore bars mode
    ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrWhite); // restore chart colors
    ChartSetInteger(0, CHART_SHOW_ASK_LINE, TRUE);
    ChartSetInteger(0, CHART_SHOW_BID_LINE, TRUE);
    ObjectsDeleteAll(0); // delete any drawn objects
    return (0);
}


// Respond to chart events (zoom etc.)
void OnChartEvent(const int id,
    const long & lparam,
        const double & dparam,
            const string & sparam) {
    if (id == CHARTEVENT_CHART_CHANGE) {
        updateBarsStyle();
    }
}


// When chart scale changes, update widths of main bar bodies
void updateBarsStyle() {
    if (checkChange(scale, returnChartScale())) {
        mainBars.bullsBody.updateStyle();
        mainBars.bearsBody.updateStyle();
    }
}