

// Input & Configuration Definitions for Custom Bars Indicator

int loopIndex, scale, Bulls = 1, Bears = -1; // Global indicator vars

// Size enumeration for wick/body width selection
enum Size {
    １ = 1, ２ = 2, ３ = 3, ４ = 4, ５ = 5, ６ = 6, ７ = 7, ８ = 8, ９ = 9, １０ = 10
};

// Enum for different time durations (used as custom timeframes)
enum TimeDuration {
    １m = 1, ２m = 2, ３m = 3, ４m = 4, ５m = 5, ６m = 6, １０m = 10, １２m = 12, １５m = 15, ２０m = 20, ３０m = 30,
    １h = 60, １h３０m = 90, ２h = 120, ３h = 180, ４h = 240, ６h = 360, ８h = 480, １２h = 720, １d = 1440, ２d = 2880
};

// Enum to easily map Yes/No (for external "boolean" inputs)
enum Bool {
    Yes = True, No = False
};

// === User configurable external input parameters ===
extern TimeDuration customBarsTimeframe = TimeDuration(5); // higher timeframe bar size shown
extern Bool showMainBars = No;         // show/hide base chart bars
extern Bool showCustomBars = Yes;      // show/hide custom/higher TF bars
extern Size mainBarsWickWidth = Size(1);
extern Size customBarsWickWidth = Size(2);
extern Size customBarsBodyWidth = Size(1);

extern color mainBarsbullsColor = clrGold;
extern color mainBarsbearsColor = clrPurple;
extern color customBarsbullsColor = clrSpringGreen;
extern color customBarsbearsColor = clrRed;

