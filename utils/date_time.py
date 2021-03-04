#!/usr/bin/env python3

import datetime
from astral import LocationInfo
from astral.sun import sun

city = LocationInfo("Changchun", "China" "43°53'N", "125°19'E")
city_sun = sun(city.observer, date=datetime.date.today())

city_sunrise = city_sun['sunrise'].time()
city_sunset = city_sun['sunset'].time()

print(city_sunrise.minute, city_sunrise.hour, city_sunset.minute, city_sunset.hour)