module PayScales
  HIGH = 'high'
  LOW = 'low'
  FULL_DAY = 'full'
  TRAVEL_DAY = 'travel'

  VALUES = {
    HIGH => {
      TRAVEL_DAY => 55,
      FULL_DAY => 85
    },
    LOW => {
      TRAVEL_DAY => 45,
      FULL_DAY => 75
    }
  }
end