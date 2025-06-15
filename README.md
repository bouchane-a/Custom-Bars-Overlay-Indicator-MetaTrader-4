# Custom Bars Overlay Indicator – MetaTrader 4

## Overview

A MetaTrader 4 custom indicator that overlays higher timeframe bars on top of lower timeframe charts, providing enhanced visual analysis of price action across multiple timeframes.

A [demo video](#demo) is available to see the indicator in action.

### Features

- ✅ Dynamically displays custom bars on top of existing chart
- ✅ Configurable higher timeframe bar period (1m to 2d)
- ✅ Customizable bar colors for bullish and bearish movements
- ✅ Adjustable bar and wick widths
- ✅ Toggleable main and custom timeframe bar display

### Requirements

- MetaTrader 4 terminal
- Basic understanding of technical analysis and chart indicators

### Getting Started

1. Download the repository files:
   - `Custom_Bars_Inputs.mqh`
   - `Custom_Bars_Functions.mqh`
   - `Custom_Bars_Classes.mqh`
   - `Custom_Bars_Config.mqh`
   - `Custom_Bars.mq4`

2. Place files in appropriate directories:
   - Include files (.mqh): `MQL4/Include/`
   - Indicator file (.mq4): `MQL4/Indicators/`

3. Open MetaTrader 4 terminal
   - Navigate to the indicator
   - Attach to desired chart

### Indicator Behavior

The script will:

1. Generate custom higher timeframe bars.
2. Color-code bars based on bullish/bearish higher timeframe bars.
3. Overlay custom bars on existing chart.
4. Provide visual insights into multi-timeframe price action.

### Customization Options

Users can modify:
- Higher timeframe period
- Bar and wick colors
- Bar width
- Display toggles

### Performance Notes

- Minimal computational overhead
- Adaptive to different chart scales
- Compatible with most trading instruments

### Demo




### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Contact

For questions or suggestions, please contact `bouchane.dev@gmail.com`.

### Disclaimer

This indicator is provided for educational purposes. Always backtest and use responsibly in your trading strategy.