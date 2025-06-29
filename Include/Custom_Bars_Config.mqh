

// Set chart background color to black
ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrBlack);

// Set foreground color to white (text and labels)
ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrWhite);

// Set grid color to LightSlateGray
ChartSetInteger(0, CHART_COLOR_GRID, clrLightSlateGray);

// Set colors for price movements
ChartSetInteger(0, CHART_COLOR_CHART_UP, clrGold);   // Up trend (bullish) color
ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrPurple); // Down trend (bearish) color
ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrGold);  // Bullish candle color
ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrPurple); // Bearish candle color

// Disable the chart line and volume colors
ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrNONE);
ChartSetInteger(0, CHART_COLOR_VOLUME, clrNONE);

// Set Ask price line color to red
ChartSetInteger(0, CHART_COLOR_ASK, clrRed);

// Set Stop level line color to white
ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrWhite);

// Set chart mode to candlestick visualization
ChartSetInteger(0, CHART_MODE, CHART_CANDLES);

// Disable various chart display options for a cleaner look
ChartSetInteger(0, CHART_SHOW_OHLC, FALSE);       // Hide OHLC values
ChartSetInteger(0, CHART_SHOW_ASK_LINE, FALSE);   // Hide Ask price line
ChartSetInteger(0, CHART_SHOW_BID_LINE, FALSE);   // Hide Bid price line
ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, FALSE);// Hide period separators
ChartSetInteger(0, CHART_SHOW_GRID, FALSE);       // Hide grid lines
ChartSetInteger(0, CHART_SHOW_VOLUMES, FALSE);    // Hide volume display
ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, FALSE); // Hide object descriptions

// Enable autoscroll for real-time price movement tracking
ChartSetInteger(0, CHART_AUTOSCROLL, TRUE);

// Ensure the chart is live (not offline)
ChartSetInteger(0, CHART_IS_OFFLINE, FALSE);

// Keep chart foreground setting disabled
ChartSetInteger(0, CHART_FOREGROUND, FALSE);

// Enable chart shift for better visibility of latest prices
ChartSetInteger(0, CHART_SHIFT, TRUE);

// Show trade levels on the chart
ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, TRUE);

// Disable fixed scaling options
ChartSetInteger(0, CHART_SCALEFIX_11, FALSE);
ChartSetInteger(0, CHART_SCALEFIX, FALSE);

// Set the amount of chart shift (50 units)
ChartSetDouble(0, CHART_SHIFT_SIZE, 50.0);

// Create a horizontal line object at the last close price
ObjectCreate(0, "Last Close", OBJ_HLINE, 0, 0, Bid);

// Set the color of the "Last Close" line to white
ObjectSetInteger(0, "Last Close", OBJPROP_COLOR, clrWhite);

// Define the style of the line as solid
ObjectSetInteger(0, "Last Close", OBJPROP_STYLE, STYLE_SOLID);

// Ensure the line is not placed in the background
ObjectSetInteger(0, "Last Close", OBJPROP_BACK, false);

// Hide the line from object list
ObjectSetInteger(0, "Last Close", OBJPROP_HIDDEN, true);

// Set line thickness to 1 pixel
ObjectSetInteger(0, "Last Close", OBJPROP_WIDTH, 1);

